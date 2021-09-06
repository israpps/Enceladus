#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <malloc.h>
#include <math.h>
#include <fcntl.h>

#include <packet2.h>
#include <packet2_utils.h>

#include <draw3d.h>

#include <jpeglib.h>
#include <time.h>
#include <png.h>

#include "include/graphics.h"

extern u8 rawlualogo;
extern int size_rawlualogo;

#define DEG2RAD(x) ((x)*0.01745329251)

static const u64 BLACK_RGBAQ   = GS_SETREG_RGBAQ(0x00,0x00,0x00,0xFF,0x00);
static const u64 TEXTURE_RGBAQ = GS_SETREG_RGBAQ(0x80,0x80,0x80,0x80,0x00);

GSGLOBAL *gsGlobal = NULL;
GSFONTM *gsFontM = NULL;

MATRIX view_screen;

VECTOR camera_position = { 0.00f, 0.00f, 0.00f, 1.00f };
VECTOR camera_rotation = { 0.00f, 0.00f, 0.00f, 1.00f };

int light_count;
int iXOffset=0, iYOffset=0;

VECTOR* light_direction;
VECTOR* light_colour;
int* light_type;

void enceladus_dma_send_packet2(packet2_t *packet2, int channel, u8 flush_cache)
{
	// dmaKit_send_chain does NOT flush all data that is "source chained"
	if (packet2->mode == P2_MODE_CHAIN){
		// "dmaKit_send always flushes the data cache"
		if (flush_cache){
			FlushCache(0);
			dmaKit_send_chain(channel, (void *)((u32)packet2->base & 0x0FFFFFFF), packet2->tte ? 1 : 0);
		}
	}
	else dmaKit_send(channel, (void *)((u32)packet2->base & 0x0FFFFFFF), ((u32)packet2->next - (u32)packet2->base) >> 4);
}

//2D drawing functions

void displaySplashScreen()
{	
	int t;
   	int alpha = 0;
   	GSTEXTURE eclSplash;

   	int size;

   	unsigned char *fb, *splash;
   	eclSplash.Width = 180;
	eclSplash.Height = 206;
	eclSplash.PSM = GS_PSM_CT24;
	
	// useless but keep compiler happy :)
	size = size_rawlualogo;
	
	size = gsKit_texture_size(180, 206, GS_PSM_CT24);
	
	eclSplash.Mem = (u32 *)malloc(size);
	
	// copy the texture into memory
	// not sure if I can directly point to my buffer (alignement?)
	fb = (unsigned char *)eclSplash.Mem;
	splash = &rawlualogo;
	for (int i=size;i--;) *fb++ = *splash++;
 
   gsKit_TexManager_bind(gsGlobal, &eclSplash);

   while(alpha <= 0x80)
	{
	gsKit_clear(gsGlobal, BLACK_RGBAQ);
    gsKit_prim_sprite_striped_texture(gsGlobal, &eclSplash,
			320-(eclSplash.Width/2),
			224-(eclSplash.Height/2),
			0,
			0,
			320+(eclSplash.Width/2),
			224+(eclSplash.Height/2),
			eclSplash.Width,
			eclSplash.Height,
			1,
			GS_SETREG_RGBAQ(0x80,0x80,0x80,alpha,0x00)
			);
	
    flipScreen();
	alpha +=2;	
	}

	for (t=0; t<240; t++) {
		gsKit_vsync_wait();
	}

	while(alpha >= 0x00)
	{
	gsKit_clear(gsGlobal, BLACK_RGBAQ);
    gsKit_prim_sprite_striped_texture(gsGlobal, &eclSplash,
			320-(eclSplash.Width/2),
			224-(eclSplash.Height/2),
			0,
			0,
			320+(eclSplash.Width/2),
			224+(eclSplash.Height/2),
			eclSplash.Width,
			eclSplash.Height,
			1,
			GS_SETREG_RGBAQ(0x80,0x80,0x80,alpha,0x00)
			);
	
    flipScreen();
	alpha -=1;	
	}

}


GSTEXTURE* luaP_loadpng(const char *path, bool delayed)
{
	GSTEXTURE* tex = (GSTEXTURE*)malloc(sizeof(GSTEXTURE));
	tex->Delayed = delayed;

	FILE* File = fopen(path, "rb");
	if (File == NULL)
	{
		printf("Failed to load PNG file: %s\n", path);
		return NULL;
	}

	png_structp png_ptr;
	png_infop info_ptr;
	png_uint_32 width, height;
	png_bytep *row_pointers;

	u32 sig_read = 0;
        int row, i, k=0, j, bit_depth, color_type, interlace_type;

	png_ptr = png_create_read_struct(PNG_LIBPNG_VER_STRING, (png_voidp) NULL, NULL, NULL);

	if(!png_ptr)
	{
		printf("PNG Read Struct Init Failed\n");
		fclose(File);
		return NULL;
	}

	info_ptr = png_create_info_struct(png_ptr);

	if(!info_ptr)
	{
		printf("PNG Info Struct Init Failed\n");
		fclose(File);
		png_destroy_read_struct(&png_ptr, (png_infopp)NULL, (png_infopp)NULL);
		return NULL;
	}

	if(setjmp(png_jmpbuf(png_ptr)))
	{
		printf("Got PNG Error!\n");
		png_destroy_read_struct(&png_ptr, &info_ptr, (png_infopp)NULL);
		fclose(File);
		return NULL;
	}

	png_init_io(png_ptr, File);

	png_set_sig_bytes(png_ptr, sig_read);

	png_read_info(png_ptr, info_ptr);

	png_get_IHDR(png_ptr, info_ptr, &width, &height, &bit_depth, &color_type,&interlace_type, NULL, NULL);

	png_set_strip_16(png_ptr);

	if (color_type == PNG_COLOR_TYPE_PALETTE)
		png_set_expand(png_ptr);

	if (color_type == PNG_COLOR_TYPE_GRAY && bit_depth < 8)
		png_set_expand(png_ptr);

	if (png_get_valid(png_ptr, info_ptr, PNG_INFO_tRNS))
		png_set_tRNS_to_alpha(png_ptr);

	png_set_filler(png_ptr, 0xff, PNG_FILLER_AFTER);

	png_read_update_info(png_ptr, info_ptr);

	tex->Width = width;
	tex->Height = height;

        tex->VramClut = 0;
        tex->Clut = NULL;

	if(png_get_color_type(png_ptr, info_ptr) == PNG_COLOR_TYPE_RGB_ALPHA)
	{
		int row_bytes = png_get_rowbytes(png_ptr, info_ptr);
		tex->PSM = GS_PSM_CT32;
		tex->Mem = (u32*)memalign(128, gsKit_texture_size_ee(tex->Width, tex->Height, tex->PSM));

		row_pointers = (png_byte**)calloc(height, sizeof(png_bytep));

		for (row = 0; row < height; row++) row_pointers[row] = (png_bytep)malloc(row_bytes);

		png_read_image(png_ptr, row_pointers);

		struct pixel { u8 r,g,b,a; };
		struct pixel *Pixels = (struct pixel *) tex->Mem;

		for (i = 0; i < tex->Height; i++) {
			for (j = 0; j < tex->Width; j++) {
				memcpy(&Pixels[k], &row_pointers[i][4 * j], 3);
				Pixels[k++].a = row_pointers[i][4 * j + 3] >> 1;
			}
		}

		for(row = 0; row < height; row++) free(row_pointers[row]);

		free(row_pointers);
	}
	else if(png_get_color_type(png_ptr, info_ptr) == PNG_COLOR_TYPE_RGB)
	{
		int row_bytes = png_get_rowbytes(png_ptr, info_ptr);
		tex->PSM = GS_PSM_CT24;
		tex->Mem = (u32*)memalign(128, gsKit_texture_size_ee(tex->Width, tex->Height, tex->PSM));

		row_pointers = (png_byte**)calloc(height, sizeof(png_bytep));

		for(row = 0; row < height; row++) row_pointers[row] = (png_bytep)malloc(row_bytes);

		png_read_image(png_ptr, row_pointers);

		struct pixel3 { u8 r,g,b; };
		struct pixel3 *Pixels = (struct pixel3 *) tex->Mem;

		for (i = 0; i < tex->Height; i++) {
			for (j = 0; j < tex->Width; j++) {
				memcpy(&Pixels[k++], &row_pointers[i][4 * j], 3);
			}
		}

		for(row = 0; row < height; row++) free(row_pointers[row]);

		free(row_pointers);
	}
	else
	{
		printf("This texture depth is not supported yet!\n");
		return NULL;
	}

	tex->Filter = GS_FILTER_NEAREST;
	png_read_end(png_ptr, NULL);
	png_destroy_read_struct(&png_ptr, &info_ptr, (png_infopp) NULL);
	fclose(File);

	if(!tex->Delayed)
	{
		tex->Vram = gsKit_vram_alloc(gsGlobal, gsKit_texture_size(tex->Width, tex->Height, tex->PSM), GSKIT_ALLOC_USERBUFFER);
		if(tex->Vram == GSKIT_ALLOC_ERROR)
		{
			printf("VRAM Allocation Failed. Will not upload texture.\n");
			return NULL;
		}

		if(tex->Clut != NULL)
		{
			if(tex->PSM == GS_PSM_T4)
				tex->VramClut = gsKit_vram_alloc(gsGlobal, gsKit_texture_size(8, 2, GS_PSM_CT32), GSKIT_ALLOC_USERBUFFER);
			else
				tex->VramClut = gsKit_vram_alloc(gsGlobal, gsKit_texture_size(16, 16, GS_PSM_CT32), GSKIT_ALLOC_USERBUFFER);

			if(tex->VramClut == GSKIT_ALLOC_ERROR)
			{
				printf("VRAM CLUT Allocation Failed. Will not upload texture.\n");
				return NULL;
			}
		}

		// Upload texture
		gsKit_texture_upload(gsGlobal, tex);
		// Free texture
		free(tex->Mem);
		tex->Mem = NULL;
		// Free texture CLUT
		if(tex->Clut != NULL)
		{
			free(tex->Clut);
			tex->Clut = NULL;
		}
	}
	else
	{
		gsKit_setup_tbw(tex);
	}

	return tex;

}


GSTEXTURE* luaP_loadbmp(const char *Path, bool delayed)
{
	GSBITMAP Bitmap;
	int x, y;
	int cy;
	u32 FTexSize;
	u8  *image;
	u8  *p;

    GSTEXTURE* tex = (GSTEXTURE*)malloc(sizeof(GSTEXTURE));
	tex->Delayed = delayed;

	FILE* File = fopen(Path, "rb");
	if (File == NULL)
	{
		printf("BMP: Failed to load bitmap: %s\n", Path);
		return NULL;
	}
	if (fread(&Bitmap.FileHeader, sizeof(Bitmap.FileHeader), 1, File) <= 0)
	{
		printf("BMP: Could not load bitmap: %s\n", Path);
		fclose(File);
		return NULL;
	}

	if (fread(&Bitmap.InfoHeader, sizeof(Bitmap.InfoHeader), 1, File) <= 0)
	{
		printf("BMP: Could not load bitmap: %s\n", Path);
		fclose(File);
		return NULL;
	}

	tex->Width = Bitmap.InfoHeader.Width;
	tex->Height = Bitmap.InfoHeader.Height;
	tex->Filter = GS_FILTER_NEAREST;

	if(Bitmap.InfoHeader.BitCount == 4)
	{
		tex->PSM = GS_PSM_T4;
		tex->Clut = (u32*)memalign(128, gsKit_texture_size_ee(8, 2, GS_PSM_CT32));
		tex->ClutPSM = GS_PSM_CT32;

		memset(tex->Clut, 0, gsKit_texture_size_ee(8, 2, GS_PSM_CT32));
		fseek(File, 54, SEEK_SET);
		if (fread(tex->Clut, Bitmap.InfoHeader.ColorUsed*sizeof(u32), 1, File) <= 0)
		{
			if (tex->Clut) {
				free(tex->Clut);
				tex->Clut = NULL;
			}
			printf("BMP: Could not load bitmap: %s\n", Path);
			fclose(File);
			return NULL;
		}

		GSBMCLUT *clut = (GSBMCLUT *)tex->Clut;
		int i;
		for (i = Bitmap.InfoHeader.ColorUsed; i < 16; i++)
		{
			memset(&clut[i], 0, sizeof(clut[i]));
		}

		for (i = 0; i < 16; i++)
		{
			u8 tmp = clut[i].Blue;
			clut[i].Blue = clut[i].Red;
			clut[i].Red = tmp;
			clut[i].Alpha = 0x80;
		}

	}
	else if(Bitmap.InfoHeader.BitCount == 8)
	{
		tex->PSM = GS_PSM_T8;
		tex->Clut = (u32*)memalign(128, gsKit_texture_size_ee(16, 16, GS_PSM_CT32));
		tex->ClutPSM = GS_PSM_CT32;

		memset(tex->Clut, 0, gsKit_texture_size_ee(16, 16, GS_PSM_CT32));
		fseek(File, 54, SEEK_SET);
		if (fread(tex->Clut, Bitmap.InfoHeader.ColorUsed*sizeof(u32), 1, File) <= 0)
		{
			if (tex->Clut) {
				free(tex->Clut);
				tex->Clut = NULL;
			}
			printf("BMP: Could not load bitmap: %s\n", Path);
			fclose(File);
			return NULL;
		}

		GSBMCLUT *clut = (GSBMCLUT *)tex->Clut;
		int i;
		for (i = Bitmap.InfoHeader.ColorUsed; i < 256; i++)
		{
			memset(&clut[i], 0, sizeof(clut[i]));
		}

		for (i = 0; i < 256; i++)
		{
			u8 tmp = clut[i].Blue;
			clut[i].Blue = clut[i].Red;
			clut[i].Red = tmp;
			clut[i].Alpha = 0x80;
		}

		// rotate clut
		for (i = 0; i < 256; i++)
		{
			if ((i&0x18) == 8)
			{
				GSBMCLUT tmp = clut[i];
				clut[i] = clut[i+8];
				clut[i+8] = tmp;
			}
		}
	}
	else if(Bitmap.InfoHeader.BitCount == 16)
	{
		tex->PSM = GS_PSM_CT16;
		tex->VramClut = 0;
		tex->Clut = NULL;
	}
	else if(Bitmap.InfoHeader.BitCount == 24)
	{
		tex->PSM = GS_PSM_CT24;
		tex->VramClut = 0;
		tex->Clut = NULL;
	}

	fseek(File, 0, SEEK_END);
	FTexSize = ftell(File);
	FTexSize -= Bitmap.FileHeader.Offset;

	fseek(File, Bitmap.FileHeader.Offset, SEEK_SET);

	u32 TextureSize = gsKit_texture_size_ee(tex->Width, tex->Height, tex->PSM);

	tex->Mem = (u32*)memalign(128,TextureSize);

	if(Bitmap.InfoHeader.BitCount == 24)
	{
		image = (u8*)memalign(128, FTexSize);
		if (image == NULL) {
			printf("BMP: Failed to allocate memory\n");
			if (tex->Mem) {
				free(tex->Mem);
				tex->Mem = NULL;
			}
			if (tex->Clut) {
				free(tex->Clut);
				tex->Clut = NULL;
			}
			fclose(File);
			return NULL;
		}

		fread(image, FTexSize, 1, File);
		p = (u8*)((u32)tex->Mem);
		for (y = tex->Height - 1, cy = 0; y >= 0; y--, cy++) {
			for (x = 0; x < tex->Width; x++) {
				p[(y * tex->Width + x) * 3 + 2] = image[(cy * tex->Width + x) * 3 + 0];
				p[(y * tex->Width + x) * 3 + 1] = image[(cy * tex->Width + x) * 3 + 1];
				p[(y * tex->Width + x) * 3 + 0] = image[(cy * tex->Width + x) * 3 + 2];
			}
		}
		free(image);
		image = NULL;
	}
	else if(Bitmap.InfoHeader.BitCount == 16)
	{
		image = (u8*)memalign(128, FTexSize);
		if (image == NULL) {
			printf("BMP: Failed to allocate memory\n");
			if (tex->Mem) {
				free(tex->Mem);
				tex->Mem = NULL;
			}
			if (tex->Clut) {
				free(tex->Clut);
				tex->Clut = NULL;
			}
			fclose(File);
			return NULL;
		}

		fread(image, FTexSize, 1, File);

		p = (u8*)((u32*)tex->Mem);
		for (y = tex->Height - 1, cy = 0; y >= 0; y--, cy++) {
			for (x = 0; x < tex->Width; x++) {
				u16 value;
				value = *(u16*)&image[(cy * tex->Width + x) * 2];
				value = (value & 0x8000) | value << 10 | (value & 0x3E0) | (value & 0x7C00) >> 10;	//ARGB -> ABGR

				*(u16*)&p[(y * tex->Width + x) * 2] = value;
			}
		}
		free(image);
		image = NULL;
	}
	else if(Bitmap.InfoHeader.BitCount == 8 || Bitmap.InfoHeader.BitCount == 4)
	{
		char *text = (char *)((u32)tex->Mem);
		image = (u8*)memalign(128,FTexSize);
		if (image == NULL) {
			printf("BMP: Failed to allocate memory\n");
			if (tex->Mem) {
				free(tex->Mem);
				tex->Mem = NULL;
			}
			if (tex->Clut) {
				free(tex->Clut);
				tex->Clut = NULL;
			}
			fclose(File);
			return NULL;
		}

		if (fread(image, FTexSize, 1, File) != 1)
		{
			if (tex->Mem) {
				free(tex->Mem);
				tex->Mem = NULL;
			}
			if (tex->Clut) {
				free(tex->Clut);
				tex->Clut = NULL;
			}
			printf("BMP: Read failed!, Size %d\n", FTexSize);
			free(image);
			image = NULL;
			fclose(File);
			return NULL;
		}
		for (y = tex->Height - 1; y >= 0; y--)
		{
			if(Bitmap.InfoHeader.BitCount == 8)
				memcpy(&text[y * tex->Width], &image[(tex->Height - y - 1) * tex->Width], tex->Width);
			else
				memcpy(&text[y * (tex->Width / 2)], &image[(tex->Height - y - 1) * (tex->Width / 2)], tex->Width / 2);
		}
		free(image);
		image = NULL;

		if(Bitmap.InfoHeader.BitCount == 4)
		{
			int byte;
			u8 *tmpdst = (u8 *)((u32)tex->Mem);
			u8 *tmpsrc = (u8 *)text;

			for(byte = 0; byte < FTexSize; byte++)
			{
				tmpdst[byte] = (tmpsrc[byte] << 4) | (tmpsrc[byte] >> 4);
			}
		}
	}
	else
	{
		printf("BMP: Unknown bit depth format %d\n", Bitmap.InfoHeader.BitCount);
	}

	fclose(File);

	if(!tex->Delayed)
	{
		tex->Vram = gsKit_vram_alloc(gsGlobal, gsKit_texture_size(tex->Width, tex->Height, tex->PSM), GSKIT_ALLOC_USERBUFFER);
		if(tex->Vram == GSKIT_ALLOC_ERROR)
		{
			printf("VRAM Allocation Failed. Will not upload texture.\n");
			return NULL;
		}

		if(tex->Clut != NULL)
		{
			if(tex->PSM == GS_PSM_T4)
				tex->VramClut = gsKit_vram_alloc(gsGlobal, gsKit_texture_size(8, 2, GS_PSM_CT32), GSKIT_ALLOC_USERBUFFER);
			else
				tex->VramClut = gsKit_vram_alloc(gsGlobal, gsKit_texture_size(16, 16, GS_PSM_CT32), GSKIT_ALLOC_USERBUFFER);

			if(tex->VramClut == GSKIT_ALLOC_ERROR)
			{
				printf("VRAM CLUT Allocation Failed. Will not upload texture.\n");
				return NULL;
			}
		}

		// Upload texture
		gsKit_texture_upload(gsGlobal, tex);
		// Free texture
		free(tex->Mem);
		tex->Mem = NULL;
		// Free texture CLUT
		if(tex->Clut != NULL)
		{
			free(tex->Clut);
			tex->Clut = NULL;
		}
	}
	else
	{
		gsKit_setup_tbw(tex);
	}

	return tex;

}

struct my_error_mgr {
  struct jpeg_error_mgr pub;    /* "public" fields */

  jmp_buf setjmp_buffer;        /* for return to caller */
};

typedef struct my_error_mgr *my_error_ptr;

METHODDEF(void)
my_error_exit(j_common_ptr cinfo)
{
  /* cinfo->err really points to a my_error_mgr struct, so coerce pointer */
  my_error_ptr myerr = (my_error_ptr)cinfo->err;

  /* Always display the message. */
  /* We could postpone this until after returning, if we chose. */
  (*cinfo->err->output_message) (cinfo);

  /* Return control to the setjmp point */
  longjmp(myerr->setjmp_buffer, 1);
}

// Following official documentation max width or height of the texture is 1024
#define MAX_TEXTURE 1024
static void  _ps2_load_JPEG_generic(GSTEXTURE *Texture, struct jpeg_decompress_struct *cinfo, struct my_error_mgr *jerr, bool scale_down)
{
	int textureSize = 0;
	if (scale_down) {
		unsigned int longer = cinfo->image_width > cinfo->image_height ? cinfo->image_width : cinfo->image_height;
		float downScale = (float)longer / (float)MAX_TEXTURE;
		cinfo->scale_denom = ceil(downScale);
	}

	jpeg_start_decompress(cinfo);

	int psm = cinfo->out_color_components == 3 ? GS_PSM_CT24 : GS_PSM_CT32;

	Texture->Width =  cinfo->output_width;
	Texture->Height = cinfo->output_height;
	Texture->PSM = psm;
	Texture->Filter = GS_FILTER_NEAREST;
	Texture->VramClut = 0;
	Texture->Clut = NULL;

	textureSize = cinfo->output_width*cinfo->output_height*cinfo->out_color_components;
	#ifdef DEBUG
	printf("Texture Size = %i\n",textureSize);
	#endif
	Texture->Mem = (u32*)memalign(128, textureSize);

	unsigned int row_stride = textureSize/Texture->Height;
	unsigned char *row_pointer = (unsigned char *)Texture->Mem;
	while (cinfo->output_scanline < cinfo->output_height) {
		jpeg_read_scanlines(cinfo, (JSAMPARRAY)&row_pointer, 1);
		row_pointer += row_stride;
	}

	jpeg_finish_decompress(cinfo);
}

GSTEXTURE* luaP_loadjpeg(const char *Path, bool scale_down, bool delayed)
{

	
    GSTEXTURE* tex = (GSTEXTURE*)malloc(sizeof(GSTEXTURE));
	tex->Delayed = delayed;

	FILE *fp;
	struct jpeg_decompress_struct cinfo;
	struct my_error_mgr jerr;

	if (tex == NULL) {
		printf("jpeg: error Texture is NULL\n");
		return NULL;
	}

	fp = fopen(Path, "rb");
	if (fp == NULL)
	{
		printf("jpeg: Failed to load file: %s\n", Path);
		return NULL;
	}

	/* We set up the normal JPEG error routines, then override error_exit. */
	cinfo.err = jpeg_std_error(&jerr.pub);
	jerr.pub.error_exit = my_error_exit;
	/* Establish the setjmp return context for my_error_exit to use. */
	if (setjmp(jerr.setjmp_buffer)) {
		/* If we get here, the JPEG code has signaled an error.
		* We need to clean up the JPEG object, close the input file, and return.
		*/
		jpeg_destroy_decompress(&cinfo);
		fclose(fp);
		if (tex->Mem)
			free(tex->Mem);
		printf("jpeg: error during processing file\n");
		return NULL;
	}
	jpeg_create_decompress(&cinfo);
	jpeg_stdio_src(&cinfo, fp);
	jpeg_read_header(&cinfo, TRUE);

	_ps2_load_JPEG_generic(tex, &cinfo, &jerr, scale_down);
	
	jpeg_destroy_decompress(&cinfo);
	fclose(fp);

	
	if(!tex->Delayed)
	{
		tex->Vram = gsKit_vram_alloc(gsGlobal, gsKit_texture_size(tex->Width, tex->Height, tex->PSM), GSKIT_ALLOC_USERBUFFER);
		if(tex->Vram == GSKIT_ALLOC_ERROR)
		{
			printf("VRAM Allocation Failed. Will not upload texture.\n");
			return NULL;
		}

		if(tex->Clut != NULL)
		{
			if(tex->PSM == GS_PSM_T4)
				tex->VramClut = gsKit_vram_alloc(gsGlobal, gsKit_texture_size(8, 2, GS_PSM_CT32), GSKIT_ALLOC_USERBUFFER);
			else
				tex->VramClut = gsKit_vram_alloc(gsGlobal, gsKit_texture_size(16, 16, GS_PSM_CT32), GSKIT_ALLOC_USERBUFFER);

			if(tex->VramClut == GSKIT_ALLOC_ERROR)
			{
				printf("VRAM CLUT Allocation Failed. Will not upload texture.\n");
				return NULL;
			}
		}

		// Upload texture
		gsKit_texture_upload(gsGlobal, tex);
		// Free texture
		free(tex->Mem);
		tex->Mem = NULL;
		// Free texture CLUT
		if(tex->Clut != NULL)
		{
			free(tex->Clut);
			tex->Clut = NULL;
		}
	}
	else
	{
		gsKit_setup_tbw(tex);
	}

	return tex;

}


void gsKit_clear_screens()
{
	int i;

	for (i=0; i<2; i++)
	{
		gsKit_clear(gsGlobal, BLACK_RGBAQ);
		gsKit_queue_exec(gsGlobal);
		gsKit_sync_flip(gsGlobal);
	}
}

void clearScreen(Color color)
{
	gsKit_clear(gsGlobal, color);
	
}

void loadFontM()
{
	gsFontM = gsKit_init_fontm();
	gsKit_fontm_upload(gsGlobal, gsFontM);
	gsFontM->Spacing = 0.70f;
}

void printFontMText(char* text, float x, float y, float scale, Color color)
{
	gsGlobal->PrimAlphaEnable = GS_SETTING_ON;
	gsKit_set_test(gsGlobal, GS_ATEST_ON);
	gsKit_fontm_print_scaled(gsGlobal, gsFontM, x, y, 1, scale, color, text);
}

void unloadFontM()
{
	gsKit_free_fontm(gsGlobal, gsFontM);
}

int FPSCounter(clock_t prevtime, clock_t curtime)
{
	float fps = 0.0f;

	if (prevtime != 0) {
	        clock_t diff = curtime - prevtime;
	        float rawfps = ((100 * CLOCKS_PER_SEC) / diff) / 100.0f;

	        if (fps == 0.0f)
	            fps = rawfps;
	        else
	            fps = fps * 0.9f + rawfps / 10.0f;
	    }
	return fps;
}

GSFONT* loadFont(const char* path){
	int file = open(path, O_RDONLY, 0777);
	uint16_t magic;
	read(file, &magic, 2);
	close(file);
	GSFONT* font = NULL;
	if (magic == 0x4D42) {
		font = gsKit_init_font(GSKIT_FTYPE_BMP_DAT, (char*)path);
		gsKit_font_upload(gsGlobal, font);
	} else if (magic == 0x4246) {
		font = gsKit_init_font(GSKIT_FTYPE_FNT, (char*)path);
		gsKit_font_upload(gsGlobal, font);
	} else if (magic == 0x5089) { 
		font = gsKit_init_font(GSKIT_FTYPE_PNG_DAT, (char*)path);
		gsKit_font_upload(gsGlobal, font);
	}

	return font;
}

void printFontText(GSFONT* font, char* text, float x, float y, float scale, Color color)
{
	gsGlobal->PrimAlphaEnable = GS_SETTING_ON;
	gsKit_set_test(gsGlobal, GS_ATEST_ON);
	gsKit_font_print_scaled(gsGlobal, font, x, y, 1, scale, color, text);
}

void unloadFont(GSFONT* font)
{
	gsKit_TexManager_free(gsGlobal, font->Texture);
	// clut was pointing to static memory, so do not free
	font->Texture->Clut = NULL;
	// mem was pointing to 'TexBase', so do not free
	font->Texture->Mem = NULL;
	// free texture
	free(font->Texture);
	font->Texture = NULL;

	if (font->RawData != NULL)
		free(font->RawData);

	free(font);
}

int getFreeVRAM(){
	return (4096 - (gsGlobal->CurrentPointer / 1024));
}

void drawImage(GSTEXTURE* source, float x, float y, float width, float height, float startx, float starty, float endx, float endy, Color color)
{

	if ((source->PSM == GS_PSM_CT32) || (source->Clut && source->ClutPSM == GS_PSM_CT32)) {
        gsGlobal->PrimAlphaEnable = GS_SETTING_ON;
        gsKit_set_test(gsGlobal, GS_ATEST_ON);
    } else {
        gsGlobal->PrimAlphaEnable = GS_SETTING_OFF;
        gsKit_set_test(gsGlobal, GS_ATEST_OFF);
    }

	gsKit_TexManager_bind(gsGlobal, source);
	gsKit_prim_sprite_texture(gsGlobal, source, 
					x-width/2, // X1
					y-height/2, // Y1
					startx,  // U1
					starty,  // V1
					(width/2+x), // X2
					(height/2+y), // Y2
					endx, // U2
					endy, // V2
					1, 
					color);	

}


void drawImageRotate(GSTEXTURE* source, float x, float y, float width, float height, float startx, float starty, float endx, float endy, float angle, Color color){

	float c = cosf(angle);
	float s = sinf(angle);

	if ((source->PSM == GS_PSM_CT32) || (source->Clut && source->ClutPSM == GS_PSM_CT32)) {
        gsGlobal->PrimAlphaEnable = GS_SETTING_ON;
        gsKit_set_test(gsGlobal, GS_ATEST_ON);
    } else {
        gsGlobal->PrimAlphaEnable = GS_SETTING_OFF;
        gsKit_set_test(gsGlobal, GS_ATEST_OFF);
    }

	gsKit_TexManager_bind(gsGlobal, source);
	gsKit_prim_quad_texture(gsGlobal, source, 
							(-width/2)*c - (-height/2)*s+x, (-height/2)*c + (-width/2)*s+y, startx, starty, 
							(-width/2)*c - height/2*s+x, height/2*c + (-width/2)*s+y, startx, endy, 
							width/2*c - (-height/2)*s+x, (-height/2)*c + width/2*s+y, endx, starty, 
							width/2*c - height/2*s+x, height/2*c + width/2*s+y, endx, endy, 
							1, color);

}

void drawPixel(float x, float y, Color color)
{
	gsGlobal->PrimAlphaEnable = GS_SETTING_ON;
	gsKit_prim_point(gsGlobal, x, y, 1, color);
}

void drawLine(float x, float y, float x2, float y2, Color color)
{
	gsGlobal->PrimAlphaEnable = GS_SETTING_ON;
	gsKit_prim_line(gsGlobal, x, y, x2, y2, 1, color);
}

void drawRect(float x, float y, int width, int height, Color color)
{
	gsGlobal->PrimAlphaEnable = GS_SETTING_ON;
	gsKit_prim_sprite(gsGlobal, x-width/2, y-height/2, (x+width)-width/2, (y+height)-height/2, 1, color);
}

void drawTriangle(float x, float y, float x2, float y2, float x3, float y3, Color color)
{
	gsGlobal->PrimAlphaEnable = GS_SETTING_ON;
	gsKit_prim_triangle(gsGlobal, x, y, x2, y2, x3, y3, 1, color);
}

void drawTriangle_gouraud(float x, float y, float x2, float y2, float x3, float y3, Color color, Color color2, Color color3)
{
	gsGlobal->PrimAlphaEnable = GS_SETTING_ON;
	gsKit_prim_triangle_gouraud(gsGlobal, x, y, x2, y2, x3, y3, 1, color, color2, color3);
}

void drawQuad(float x, float y, float x2, float y2, float x3, float y3, float x4, float y4, Color color)
{
	gsGlobal->PrimAlphaEnable = GS_SETTING_ON;
	gsKit_prim_quad(gsGlobal, x, y, x2, y2, x3, y3, x4, y4, 1, color);
}

void drawQuad_gouraud(float x, float y, float x2, float y2, float x3, float y3, float x4, float y4, Color color, Color color2, Color color3, Color color4)
{
	gsGlobal->PrimAlphaEnable = GS_SETTING_ON;
	gsKit_prim_quad_gouraud(gsGlobal, x, y, x2, y2, x3, y3, x4, y4, 1, color, color2, color3, color4);
}

void drawCircle(float x, float y, float radius, u64 color, u8 filled)
{
	float v[37*2];
	int a;
	float ra;

	for (a = 0; a < 36; a++) {
		ra = DEG2RAD(a*10);
		v[a*2] = cos(ra) * radius + x;
		v[a*2+1] = sin(ra) * radius + y;
	}

	if (!filled) {
		v[36*2] = radius + x;
		v[36*2 + 1] = y;
	}

	gsGlobal->PrimAlphaEnable = GS_SETTING_ON;
	
	if (filled)
		gsKit_prim_triangle_fan(gsGlobal, v, 36, 1, color);
	else
		gsKit_prim_line_strip(gsGlobal, v, 37, 1, color);
}

void InvalidateTexture(GSTEXTURE *txt)
{
    gsKit_TexManager_invalidate(gsGlobal, txt);
}

void UnloadTexture(GSTEXTURE *txt)
{
    gsKit_TexManager_free(gsGlobal, txt);
}

int GetInterlacedFrameMode()
{
    if ((gsGlobal->Interlace == GS_INTERLACED) && (gsGlobal->Field == GS_FRAME))
        return 1;

    return 0;
}

GSGLOBAL *getGSGLOBAL(){return gsGlobal;}

void setVideoMode(s16 mode, int width, int height, int psm, s16 interlace, s16 field) {
	gsGlobal->PSM = psm;
	gsGlobal->Mode = mode;
	gsGlobal->Interlace = interlace;
	gsGlobal->Field = field;
	gsGlobal->Width = width;
	if ((interlace == GS_INTERLACED) && (field == GS_FRAME))
		gsGlobal->Height = height / 2;
	else
		gsGlobal->Height = height;

	gsKit_vram_clear(gsGlobal);
	gsKit_init_screen(gsGlobal);
	gsKit_set_display_offset(gsGlobal, 0.0f, 0.0f);
	gsKit_sync_flip(gsGlobal);
}

void fntDrawQuad(rm_quad_t *q)
{
    if ((q->txt->PSM == GS_PSM_CT32) || (q->txt->Clut && q->txt->ClutPSM == GS_PSM_CT32)) {
        gsGlobal->PrimAlphaEnable = GS_SETTING_ON;
        gsKit_set_test(gsGlobal, GS_ATEST_ON);
    } else {
        gsGlobal->PrimAlphaEnable = GS_SETTING_OFF;
        gsKit_set_test(gsGlobal, GS_ATEST_OFF);
    }

    gsKit_TexManager_bind(gsGlobal, q->txt);
    gsKit_prim_sprite_texture(gsGlobal, q->txt,
                              q->ul.x , q->ul.y,
                              q->ul.u, q->ul.v,
                              q->br.x, q->br.y,
                              q->br.u, q->br.v, 1, q->color);
}


void calculate_vertices_no_clip(VECTOR *output,  int count, VECTOR *vertices, MATRIX local_screen) {
	asm __volatile__ (
					  "lqc2		$vf1, 0x00(%3)	\n"
					  "lqc2		$vf2, 0x10(%3)	\n"
					  "lqc2		$vf3, 0x20(%3)	\n"
					  "lqc2		$vf4, 0x30(%3)	\n"
					  "1:					\n"
					  "lqc2		$vf6, 0x00(%2)	\n"
					  "vmulaw		$ACC, $vf4, $vf0	\n"
					  "vmaddax		$ACC, $vf1, $vf6	\n"
					  "vmadday		$ACC, $vf2, $vf6	\n"
					  "vmaddz		$vf7, $vf3, $vf6	\n"
//					  "vclipw.xyz	$vf7, $vf7	\n" // FIXME: Clip detection is still kinda broken.
					  "cfc2		$10, $18	\n"
					  "beq			$10, $0, 3f	\n"
					  "2:					\n"
   					  "sqc2		$0, 0x00(%0)	\n"
   					  "j			4f		\n"
					  "3:					\n"
					  "vdiv		$Q, $vf0w, $vf7w	\n"
					  "vwaitq				\n"
					  "vmulq.xyz		$vf7, $vf7, $Q	\n"
					  "sqc2		$vf7, 0x00(%0)	\n"
					  "4:					\n"
					  "addi		%0, 0x10	\n"
					  "addi		%2, 0x10	\n"
					  "addi		%1, -1		\n"
					  "bne		$0, %1, 1b	\n"
					  : : "r" (output), "r" (count), "r" (vertices), "r" (local_screen) : "$10", "memory"
					  );
}

void init3D()
{
	create_view_screen(view_screen, 4.0f/3.0f, -0.20f, 0.20f, -0.20f, 0.20f, 1.00f, 2000.00f);

}


typedef union TexCoord { 
    struct {
        float s, t;
    };
    u64 word;
} __attribute__((packed, aligned(8))) TexCoord;

#define GIF_TAG_TRIANGLE_GORAUD_TEXTURED_ST_REGS(ctx) \
    ((u64)(GS_TEX0_1 + ctx) << 0 ) | \
    ((u64)(GS_PRIM)         << 4 ) | \
    ((u64)(GS_RGBAQ)        << 8 ) | \
    ((u64)(GS_ST)           << 12) | \
    ((u64)(GS_XYZ2)         << 16) | \
    ((u64)(GS_RGBAQ)        << 20) | \
    ((u64)(GS_ST)           << 24) | \
    ((u64)(GS_XYZ2)         << 28) | \
    ((u64)(GS_RGBAQ)        << 32) | \
    ((u64)(GS_ST)           << 36) | \
    ((u64)(GS_XYZ2)         << 40) | \
    ((u64)(GIF_NOP)         << 44)


static inline u32 lzw(u32 val) {
    u32 res;
    __asm__ __volatile__ ("   plzcw   %0, %1    " : "=r" (res) : "r" (val));
    return(res);
}

static inline void gsKit_set_tw_th(const GSTEXTURE *Texture, int *tw, int *th) {
    *tw = 31 - (lzw(Texture->Width) + 1);
    if(Texture->Width > (1<<*tw))
        (*tw)++;

    *th = 31 - (lzw(Texture->Height) + 1);
    if(Texture->Height > (1<<*th))
        (*th)++;
}

static void gsKit_prim_triangle_goraud_texture_3d_st(
    GSGLOBAL *gsGlobal, GSTEXTURE *Texture,
    float x1, float y1, int iz1, float u1, float v1,
    float x2, float y2, int iz2, float u2, float v2,
    float x3, float y3, int iz3, float u3, float v3,
    u64 color1, u64 color2, u64 color3
) {
    gsKit_set_texfilter(gsGlobal, Texture->Filter);
    u64* p_store;
    u64* p_data;
    const int qsize = 6;
    const int bsize = 96;

    int tw, th;
    gsKit_set_tw_th(Texture, &tw, &th);

    int ix1 = gsKit_float_to_int_x(gsGlobal, x1);
    int ix2 = gsKit_float_to_int_x(gsGlobal, x2);
    int ix3 = gsKit_float_to_int_x(gsGlobal, x3);
    int iy1 = gsKit_float_to_int_y(gsGlobal, y1);
    int iy2 = gsKit_float_to_int_y(gsGlobal, y2);
    int iy3 = gsKit_float_to_int_y(gsGlobal, y3);
 
    TexCoord st1 = (TexCoord) { { u1, v1 } };
    TexCoord st2 = (TexCoord) { { u2, v2 } };
    TexCoord st3 = (TexCoord) { { u3, v3 } };

    p_store = p_data = (u64*)gsKit_heap_alloc(gsGlobal, qsize, bsize, GSKIT_GIF_PRIM_TRIANGLE_TEXTURED);

    *p_data++ = GIF_TAG_TRIANGLE_GORAUD_TEXTURED(0);
    *p_data++ = GIF_TAG_TRIANGLE_GORAUD_TEXTURED_ST_REGS(gsGlobal->PrimContext);

    const int replace = 0; // cur_shader->tex_mode == TEXMODE_REPLACE;
    const int alpha = gsGlobal->PrimAlphaEnable;

    if (Texture->VramClut == 0) {
        *p_data++ = GS_SETREG_TEX0(Texture->Vram/256, Texture->TBW, Texture->PSM,
            tw, th, alpha, replace,
            0, 0, 0, 0, GS_CLUT_STOREMODE_NOLOAD);
    } else {
        *p_data++ = GS_SETREG_TEX0(Texture->Vram/256, Texture->TBW, Texture->PSM,
            tw, th, alpha, replace,
            Texture->VramClut/256, Texture->ClutPSM, 0, 0, GS_CLUT_STOREMODE_LOAD);
    }

    *p_data++ = GS_SETREG_PRIM( GS_PRIM_PRIM_TRIANGLE, 1, 1, gsGlobal->PrimFogEnable,
                gsGlobal->PrimAlphaEnable, gsGlobal->PrimAAEnable,
                0, gsGlobal->PrimContext, 0);


    *p_data++ = color1;
    *p_data++ = st1.word;
    *p_data++ = GS_SETREG_XYZ2( ix1, iy1, iz1 );

    *p_data++ = color2;
    *p_data++ = st2.word;
    *p_data++ = GS_SETREG_XYZ2( ix2, iy2, iz2 );

    *p_data++ = color3;
    *p_data++ = st3.word;
    *p_data++ = GS_SETREG_XYZ2( ix3, iy3, iz3 );
}

void setCameraPosition(float x, float y, float z){
	camera_position[0] = x;
	camera_position[1] = y;
	camera_position[2] = z;
	camera_position[3] = 1.00f;
}

void setCameraRotation(float x, float y, float z){
	camera_rotation[0] = x;
	camera_rotation[1] = y;
	camera_rotation[2] = z;
	camera_rotation[3] = 1.00f;
}

void setLightQuantity(int quantity){
	light_count = quantity;
	light_direction = (VECTOR*)memalign(128, sizeof(VECTOR) * light_count);
	light_colour = (VECTOR*)memalign(128, sizeof(VECTOR) * light_count);
	light_type = (int*)memalign(128, sizeof(int) * light_count);
}

void createLight(int lightid, float dir_x, float dir_y, float dir_z, int type, float r, float g, float b){
	light_direction[lightid-1][0] = dir_x;
	light_direction[lightid-1][1] = dir_y;
	light_direction[lightid-1][2] = dir_z;
	light_direction[lightid-1][3] = 1.00f;

	light_colour[lightid-1][0] = r;
	light_colour[lightid-1][1] = g;
	light_colour[lightid-1][2] = b;
	light_colour[lightid-1][3] = 1.00f;

	light_type[lightid-1] = type;

}

ps2ObjMesh* loadOBJ(const char *Path, const char *texpath){

	fastObjMesh* m = fast_obj_read(Path);
	ps2ObjMesh* mesh = (ps2ObjMesh*)memalign(128, sizeof(ps2ObjMesh));

	mesh->position_count = m->position_count;
	mesh->texcoord_count = m->texcoord_count;
	mesh->material_count = m->material_count;
	mesh->normal_count = m->normal_count;
	mesh->face_count = m->face_count;

	mesh->indices = (unsigned int*)memalign(128, sizeof(unsigned int) * (mesh->face_count*3));
	mesh->t_indices = (unsigned int*)memalign(128, sizeof(unsigned int) * (mesh->face_count*3));
	mesh->n_indices = (unsigned int*)memalign(128, sizeof(unsigned int) * (mesh->face_count*3));

	mesh->positions = (VECTOR*)memalign(128, sizeof(VECTOR) * mesh->position_count);
	mesh->colours = (VECTOR*)memalign(128, sizeof(VECTOR) * mesh->position_count);
	mesh->normals = (VECTOR*)memalign(128, sizeof(VECTOR) * mesh->normal_count);
	mesh->texcoords = (VECTOR*)memalign(128, sizeof(VECTOR) * mesh->texcoord_count);

	int cnt = 0;

	for (int i = 0; i < mesh->position_count; i++){
		mesh->positions[i][0] = m->positions[cnt];
		mesh->positions[i][1] = m->positions[cnt+1];
		mesh->positions[i][2] = m->positions[cnt+2];
		mesh->positions[i][3] = 1.000f;

		mesh->colours[i][0] = 1.000f;
		mesh->colours[i][1] = 1.000f;
		mesh->colours[i][2] = 1.000f;
		mesh->colours[i][3] = 1.000f;

		cnt += 3;
	}

	cnt = 0;

	for (int i = 0; i < mesh->normal_count; i++){
		mesh->normals[i][0] = m->normals[cnt];
		mesh->normals[i][1] = m->normals[cnt+1];
		mesh->normals[i][2] = m->normals[cnt+2];
		mesh->normals[i][3] = 1.000f;

		cnt += 3;
	}

	cnt = 0;

	for (int i = 0; i < mesh->texcoord_count; i++){
		mesh->texcoords[i][0] = m->texcoords[cnt];
		mesh->texcoords[i][1] = 1-m->texcoords[cnt+1];
		cnt += 2;
	}

	for (int i = 0; i < mesh->face_count*3; i++){
		mesh->indices[i] = m->indices[i].p;
		mesh->t_indices[i] = m->indices[i].t;
		mesh->n_indices[i] = m->indices[i].n;
	}

	if (texpath != NULL) { 
			mesh->texture = luaP_loadpng(texpath, false);
	} else {
		free(mesh->texture); 
		mesh->texture = NULL;
	}

	free(m);
	return mesh;
}

void drawOBJ(ps2ObjMesh* m, float pos_x, float pos_y, float pos_z, float rot_x, float rot_y, float rot_z)
{
	
	VECTOR object_position = { pos_x, pos_y, pos_z, 1.00f };
	VECTOR object_rotation = { rot_x, rot_y, rot_z, 1.00f };

	int i;

	// Matrices to setup the 3D environment and camera
	MATRIX local_world;
	MATRIX local_light;
	MATRIX world_view;
	MATRIX local_screen;

	// Allocate calculation space.
	VECTOR *temp_normals  = (VECTOR     *)memalign(128, sizeof(VECTOR) * m->normal_count);
	VECTOR *temp_lights   = (VECTOR     *)memalign(128, sizeof(VECTOR) * m->position_count);
	color_f_t *temp_colours  = (color_f_t  *)memalign(128, sizeof(color_f_t)  * m->position_count);
	vertex_f_t *temp_vertices = (vertex_f_t *)memalign(128, sizeof(vertex_f_t) * m->position_count);


	gsGlobal->PrimAlphaEnable = GS_SETTING_OFF;
	gsKit_set_test(gsGlobal, GS_ATEST_OFF);
	gsGlobal->PrimAAEnable = GS_SETTING_ON;
	gsKit_set_test(gsGlobal, GS_ZTEST_ON);

	// Create the local_world matrix.
	create_local_world(local_world, object_position, object_rotation);

	// Create the local_light matrix.
	create_local_light(local_light, object_rotation);

	// Create the world_view matrix.
	create_world_view(world_view, camera_position, camera_rotation);

	// Create the local_screen matrix.
	create_local_screen(local_screen, local_world, world_view, view_screen);

	// Calculate the normal values.
	calculate_normals(temp_normals, m->normal_count, m->normals, local_light);
	
	// Calculate the lighting values.
	calculate_lights(temp_lights, m->position_count, temp_normals, light_direction, light_colour, light_type, light_count);

	// Calculate the colour values after lighting.
	calculate_colours((VECTOR *)temp_colours, m->position_count, m->colours, temp_lights);

	// Calculate the vertex values.
	//calculate_vertices((VECTOR *)temp_vertices, m->position_count, m->positions, local_screen);
	calculate_vertices_no_clip((VECTOR *)temp_vertices, m->position_count, m->positions, local_screen);

	// Convert floating point vertices to fixed point and translate to center of screen.
	xyz_t   *verts  = (xyz_t   *)memalign(128, sizeof(xyz_t)   * m->position_count);
	color_t *colors = (color_t *)memalign(128, sizeof(color_t) * m->position_count);
	texel_t *tex = (texel_t *)memalign(128, sizeof(texel_t) * m->texcoord_count);
	
	draw_convert_xyz(verts, 2048, 2048, 16, m->position_count, temp_vertices);
	draw_convert_rgbq(colors, m->position_count, temp_vertices, temp_colours, 0x80);
	draw_convert_st(tex, m->texcoord_count, temp_vertices, (texel_f_t *)m->texcoords);

	for (i = 0; i < (m->face_count*3); i+=3) {
		float fX=gsGlobal->Width/2;
		float fY=gsGlobal->Height/2;

		//Backface culling
		float orientation = (temp_vertices[m->indices[i+1]].x - temp_vertices[m->indices[i]].x) * (temp_vertices[m->indices[i+2]].y - temp_vertices[m->indices[i]].y) - (temp_vertices[m->indices[i+1]].y - temp_vertices[m->indices[i]].y) * (temp_vertices[m->indices[i+2]].x - temp_vertices[m->indices[i]].x);
		if(orientation < 0.0) {
			continue;
		}
		
		// Clipping
		if(temp_vertices[m->indices[i]].z < -1.0 || temp_vertices[m->indices[i]].z > 0 || temp_vertices[m->indices[i]].x > 1.0 || temp_vertices[m->indices[i]].x < -1.0 || temp_vertices[m->indices[i]].y > 1.0 || temp_vertices[m->indices[i]].y < -1.0){
			continue;
		}
		if(temp_vertices[m->indices[i+1]].z < -1.0 || temp_vertices[m->indices[i+1]].z > 0 || temp_vertices[m->indices[i+1]].x > 1.0 || temp_vertices[m->indices[i+1]].x < -1.0 || temp_vertices[m->indices[i+1]].y > 1.0 || temp_vertices[m->indices[i+1]].y < -1.0){
			continue;
		}
		if(temp_vertices[m->indices[i+2]].z < -1.0 || temp_vertices[m->indices[i+2]].z > 0 || temp_vertices[m->indices[i+2]].x > 1.0 || temp_vertices[m->indices[i+2]].x < -1.0 || temp_vertices[m->indices[i+2]].y > 1.0 || temp_vertices[m->indices[i+2]].y < -1.0){
			continue;
		}

		if (m->texture == NULL){
			gsKit_prim_triangle_gouraud_3d(gsGlobal
				, (temp_vertices[m->indices[i]].x + 1.0f) * fX, (temp_vertices[m->indices[i]].y + 1.0f) * fY, verts[m->indices[i]].z
				, (temp_vertices[m->indices[i+1]].x + 1.0f) * fX, (temp_vertices[m->indices[i+1]].y + 1.0f) * fY, verts[m->indices[i+1]].z
				, (temp_vertices[m->indices[i+2]].x + 1.0f) * fX, (temp_vertices[m->indices[i+2]].y + 1.0f) * fY, verts[m->indices[i+2]].z
				, colors[m->indices[i]].rgbaq, colors[m->indices[i+1]].rgbaq, colors[m->indices[i+2]].rgbaq);
		} else {
			gsKit_prim_triangle_goraud_texture_3d_st(gsGlobal, m->texture,
					(temp_vertices[m->indices[i]].x + 1.0f) * fX, (temp_vertices[m->indices[i]].y + 1.0f) * fY, verts[m->indices[i]].z, tex[m->t_indices[i]].s, tex[m->t_indices[i]].t,
					(temp_vertices[m->indices[i+1]].x + 1.0f) * fX, (temp_vertices[m->indices[i+1]].y + 1.0f) * fY, verts[m->indices[i+1]].z, tex[m->t_indices[i+1]].s, tex[m->t_indices[i+1]].t,
					(temp_vertices[m->indices[i+2]].x + 1.0f) * fX, (temp_vertices[m->indices[i+2]].y + 1.0f) * fY, verts[m->indices[i+2]].z, tex[m->t_indices[i+2]].s, tex[m->t_indices[i+2]].t,
					colors[m->indices[i]].rgbaq, colors[m->indices[i+1]].rgbaq, colors[m->indices[i+2]].rgbaq);
		}

	}
	
	free(temp_normals);
	free(temp_lights);
	free(temp_colours);
	free(temp_vertices);
	free(verts);
	free(colors);
	free(tex);

}

void initGraphics()
{

	gsGlobal = gsKit_init_global();

	gsGlobal->Mode = gsKit_check_rom();
	if (gsGlobal->Mode == GS_MODE_PAL){
		gsGlobal->Height = 512;
	} else {
		gsGlobal->Height = 448;
	}

	gsGlobal->PSM  = GS_PSM_CT16;
	gsGlobal->PSMZ = GS_PSMZ_16;
	gsGlobal->ZBuffering = GS_SETTING_ON;
	gsGlobal->DoubleBuffering = GS_SETTING_ON;
	gsGlobal->PrimAlphaEnable = GS_SETTING_ON;
	gsGlobal->Dithering = GS_SETTING_ON;

	gsKit_set_primalpha(gsGlobal, GS_SETREG_ALPHA(0, 1, 0, 1, 0), 0);

	dmaKit_init(D_CTRL_RELE_OFF, D_CTRL_MFD_OFF, D_CTRL_STS_UNSPEC, D_CTRL_STD_OFF, D_CTRL_RCYC_8, 1 << DMA_CHANNEL_GIF);
	dmaKit_chan_init(DMA_CHANNEL_GIF);
	dmaKit_chan_init(DMA_CHANNEL_VIF1);

	printf("\nGraphics: created video surface of (%d, %d)\n",
		gsGlobal->Width, gsGlobal->Height);

	gsKit_set_clamp(gsGlobal, GS_CMODE_CLAMP);

	gsKit_vram_clear(gsGlobal);

	gsKit_init_screen(gsGlobal);

	gsKit_mode_switch(gsGlobal, GS_ONESHOT);

    gsKit_clear(gsGlobal, BLACK_RGBAQ);	

}

void flipScreen()
{	
	gsKit_sync_flip(gsGlobal);
	gsKit_queue_exec(gsGlobal);
	gsKit_TexManager_nextFrame(gsGlobal);
}

void graphicWaitVblankStart(){

	gsKit_vsync_wait();

}
