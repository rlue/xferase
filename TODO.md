* Improve verbose mode
  * print when new files are detected
  * run photein in debug mode, too
* Replace staging directory with crash log (see ADR #1)
* Rewrite inotify watcher to handle appearance of directories
* auto-create inbox/staging/libraries if they don’t exist
* double-check deletion-sync logic
  and make sure we don’t delete files with the same timestamp
  but potentially different content (e.g., a JPG and a PNG)
* what should xferase do with corrupted videos that photein failed to import?
