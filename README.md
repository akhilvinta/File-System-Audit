# File-System-Audit

An analyzer for a file system summary that reports all discovered inconsistencies, errors, and corruption.

## Syntax

For examples of a file system summary, see the [File-System-Exploration](https://github.com/AryamanLadha/File-System-Exploration) project, which generates CSV summaries for EXT2 filesystems.

## Compilation

To compile the FileSystem program, run:

```bash
make clean
make
```

## Usage

```bash
./FileSystem FILE
```
Where FILE is a CSV summary of an EXT2 filesystem.

## Output

### Block Inconsistencies

#### Invalid Blocks
Every block pointer in an I-node or indirect block should be a legal data block within the filesystem, or zero.
An `INVALID` block is one whose number is less than zero or greater than the highest block in the file system.

In such cases, the following error messages will be generated to standard output:

- INVALID BLOCK 101 IN INODE 13 AT OFFSET 0
- INVALID INDIRECT BLOCK 101 IN INODE 13 AT OFFSET 12
- INVALID DOUBLE INDIRECT BLOCK 101 IN INODE 13 AT OFFSET 268
- INVALID TRIPLE INDIRECT BLOCK 101 IN INODE 13 AT OFFSET 65804

The block numbers are logical block offsets.

#### Reserved Blocks

A `RESERVED` block could not legally be allocated to any file because it should be reserved for file system metadata (e.g., superblock or group summary).

- RESERVED INDIRECT BLOCK 3 IN INODE 13 AT OFFSET 12
- RESERVED DOUBLE INDIRECT BLOCK 3 IN INODE 13 AT OFFSET 268
- RESERVED TRIPLE INDIRECT BLOCK 3 IN INODE 13 AT OFFSET 65804
- RESERVED BLOCK 3 IN INODE 13 AT OFFSET 0

#### Unreferenced Blocks

If a block is not referenced by any file and is not on the free block bitmap, it is unreferenced.

UNREFERENCED BLOCK 37

#### Allocated Blocks

If a block allocated to some file also appears on the free block bitmap, the following error message is generated:

ALLOCATED BLOCK 8 ON FREELIST

#### Duplicate Blocks

If a legal block is referenced by multiple files (or even multiple times in a single file), messages like the following are generated for each reference to that block:

- DUPLICATE BLOCK 8 IN INODE 13 AT OFFSET 0
- DUPLICATE INDIRECT BLOCK 8 IN INODE 13 AT OFFSET 12
- DUPLICATE DOUBLE INDIRECT BLOCK 8 IN INODE 13 AT OFFSET 268
- DUPLICATE TRIPLE INDIRECT BLOCK 8 IN INODE 13 AT OFFSET 65804

### Inode Inconsistencies

#### Allocated Inode

If an inode appears in a CSV summary and has a valid type, it is allocated. If it also shows up on the free block bitmap, the following message is generated:

ALLOCATED INODE 2 ON FREELIST

#### Unallocated Inode

Conversely, if an inode is not allocated, but not in the free block bitmap, the following is generated:

UNALLOCATED INODE 17 NOT ON FREELIST

### Directory Inconsistencies

#### Link count mismatch
If the reference count recorded in an Inode does not match the number of directory entries that refer to it, a message should be generated as follows:

INODE 2 HAS 4 LINKS BUT LINKCOUNT IS 5

For unreferenced inodes:

INODE 17 HAS 0 LINKS BUT LINKCOUNT IS 1

#### References to invalid inodes
If a directory entry refers to an invalid(inode number is less than 1 or greater than the last I-node) or unallocated inode, the following is generated:

DIRECTORY INODE 2 NAME 'nullEntry' UNALLOCATED INODE 17
DIRECTORY INODE 2 NAME 'bogusEntry' INVALID INODE 26

Finally, each directory should have links to itself and its parent. If these are missing/invalid, the following is generated:

DIRECTORY INODE 2 NAME '..' LINK TO INODE 11 SHOULD BE 2
DIRECTORY INODE 11 NAME '.' LINK TO INODE 2 SHOULD BE 11


