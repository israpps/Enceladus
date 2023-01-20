#ifndef VORBIS_H
#define VORBIS_H

void setVol(int vol);
void bgmMute(void);
int isBgmPlaying(void);
void bgmStop(void);
void bgmStart(const char* gDefaultBGMPath);

#endif