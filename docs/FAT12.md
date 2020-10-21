FAT12
=====

Directory Entry
---------------

| Offset | Length | Description             |
| :---   | :---   | :---                    |
| 0      | 8      | File name, space padded |
| 8      | 3      | File extension          |
| 11     | 1      | File property           |
| 12     | 10     | Reserved                |
| 22     | 2      | Create time             |
| 24     | 2      | Create date             |
| 26     | 2      | First cluster number    |
| 28     | 4      | File size               |