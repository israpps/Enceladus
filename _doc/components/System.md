---
title: System functions
sections:
  - Executables Launching
  - File Handling
  - Directories
  - Miscelaneous
  - Peripherals
---

----------

### Executables Launching

#### `System.loadELF(path, reboot_iop, args...)`
tries to load an EE ELF program from the specified path

##### Parameters:
`path`: location of the executable. either relative or absolute path.  
`reboot_iop`: integer, indicates if I/O Processor should be rebooted before loading ELF (0: no, 1: yes). we strongly recommend to use `0` unless you know what youre doing  
`args`: variadic arguments for strings, these will be passed to the ELF (path will always be `argv[0]`)

----------

### File Handling

#### `fd = System.openFile(path, type)`
Opens a file.
##### Parameters:
`path`: path to be opened. either absolute or relative.  
`type`: the Open mode:
- `FREAD`: Read Only
- `FWRITE`: Write Only
- `FCREATE`: Write Only, _if file does not exist it will be created._
- `FRDWR`: Read and Write
- `FTRUNCATE`: Write Only, _if file exist it's content will be wiped_

#### `buffer = System.readFile(fd, size)`
Reads from a file
##### Parameters:
`fd`: Integer. File descriptor returned by `System.openFile()`  
`size`: The ammount of bytes to read from the file
##### return value
a buffer with the data.

#### `System.writeFile(fd, data, size)`
Writes to a file
##### Parameters:
`fd`: Integer. File descriptor returned by `System.openFile()`  
`data`: The buffer containing the data to be written  
`size`: The ammount of bytes to write

#### `System.closeFile(fd)`
Closes a file
##### Parameters:
`fd`: Integer. File descriptor returned by `System.openFile()`


#### `System.seekFile(fd, pos, type)`
Changes the file pointer of this opened file
##### Parameters:
`fd`: Integer. File descriptor returned by `System.openFile()`  
`pos`: Integer. Position to move into  
`type`: The type of seek:
- `SET`: seeks from the begining of file
- `CUR`: seeks from the position indicated in `pos`
- `END`: seeks from the end of file

#### `size = System.sizeFile(fd)`
Returns the size of the file associated to the file descriptor
##### Parameters:
`fd`: Integer. File descriptor returned by `System.openFile()`
##### return value
Size of file

#### `doesFileExist(path)`
Checks if the specified file exists
##### Parameters:
`path`: Location of the file. either relative of absolute path
##### return value
Boolean

#### `System.removeFile(path)`
Removes specified file
##### Parameters:
`path`: Location of the file. either relative of absolute path

#### `System.copyFile(source, dest)`
Copy the specified file to another location
##### Parameters:
`source`: Location of the file. either relative of absolute path  
`dest`: Location of the new copy of the source file.

#### `System.moveFile(source, dest)`
Moves the file from one location to another
##### Parameters:
`source`: Current location of the file. either relative of absolute path  
`dest`: New location of the file

#### `System.rename(source, dest)`
Renames a file
##### Parameters:
`source`: Location of the file. either relative of absolute path.  
`dest`: New Location of the file


#### `System.threadCopyFile(source, dest)`
Copy the specified file to another location asynchronously.
##### Parameters:
`source`: Location of the file. either relative of absolute path  
`dest`: Location of the new copy of the source file.

#### `progress = System.getFileProgress()`
Gets the transfer progress of the on-going transfer called by `System.threadCopyFile()`

##### return value
Table:
- `progress.current`: ammount of bytes already written to destination
- `progress.final`: file size in bytes

----------

### Directories

#### `current_path = System.currentDirectory(path)`
Checks if the specified file exists
##### Parameters:
`path`: Specifies the path to be set as current directory. if no parameter is passed, this function returns the current directory
##### return value
The current directory. this return value is only obtained if no parameters are passed

#### `listdir = System.listDirectory(path)`
Lists the contents of the specified path
##### Parameters:
`path`: Path to scan. _if no path is specified, current directory is used_
##### return value
a table array, containing information of the path contents. __if the operation failed, `nil` is returned__
- `listdir[index].name:` file name on indicated index (_string_)
- `listdir[index].directory`: if indicated index is a file or a directory (_bool_)

#### `System.createDirectory(path)`
Creates a folder
##### Parameters:
`path`: Path to create

#### `System.removeDirectory(path)`
Removes a folder
##### Parameters:
`path`: Path to remove

----------

### Miscelaneous

#### `checksum = System.md5sum(string)`
Calculate MD5 checksum
##### Parameters:
`string`: String or buffer to obtain an MD5 Checksum
##### return value
A string containing the MD5 checksum

#### `System.sleep(sec)`
Stop program for a defined ammount of time
##### Parameters:
`sec`: Ammount of seconds to wait before continuing with script execution

#### `freemem = System.getFreeMemory()`
Returns the ammount of free RAM on the EmotionEngine CPU
##### return value
Integer. free RAM on the EE CPU

#### `System.exitToBrowser()`
program execution stops and system jumps to the console browser straight away

### Peripherals
Functions related to peripherals such as memory cards or discs

#### `info = System.getMCInfo(slot)`
Returns a table containing the information of the specified memory card
##### Parameters:
`slot`: Integer. memory card slot. either `0` or `1`.
##### return value
Table:
- `info.type`: memory card type:
  + `0`: No valid card
  + `1`: PS1 card
  + `2`: PS2 card
  + `3`: PDA
- `info.format`: format state
  + `0`: Not Formatted
  + `1`: Formatted
- `info.freemem`: free memory

#### `status = System.checkDiscTray()`
Returns if the disc tray is open or not
##### return value
integer: `1` if open. `0` if closed.

#### `isValid = System.checkValidDisc()`
Returns if the current disc inside the PS2 is a valid disc
##### return value
integer: `1` if valid. `0` if invalid.

#### `disctype = System.getDiscType()`
Returns a value identifying what type of disc is inside the PS2 right now
##### return value
One of the following integer values can be returned:

{: .table}
| Value | Meaning
|-
| `-1` | Failed to get disc type
| `1`  | No disc
| `2`  | A disc is being detected...
| `3`  | A CD is being detected...
| `4`  | A DVD is being detected...
| `5`  | A Dual layer DVD is being detected...
| `6`  | Unknown
| `7`  | PlayStation 1 CD
| `8`  | PlayStation 1 CDDA
| `9`  | PlayStation 2 CD
| `10` | PlayStation 2 CDDA
| `11` | PlayStation 2 DVD
| `12` | ESR Game (off)
| `13` | ESR Game (on)
| `14` | Audio CD
| `15` | Video DVD
| `16` | Illegal Media (Unsupported)

