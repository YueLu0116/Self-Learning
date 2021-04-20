# Windows IO

## Unbuffered file IO

> [File Buffering](https://docs.microsoft.com/en-us/windows/win32/fileio/file-buffering)
>
> [Buffered vs unbuffered IO](https://stackoverflow.com/questions/1450551/buffered-vs-unbuffered-io)
>
> [What's the difference between buffered I/O and unbuffered I/O?](https://www.quora.com/Whats-the-difference-between-buffered-I-O-and-unbuffered-I-O)

How to interact with data that is not being cached (buffered) by the system?

- disable system caching: When opening or creating a file with the `CreateFile` function, the `FILE_FLAG_NO_BUFFERING` flag can be specified to disable system caching of data being read from or written to the file.

- data alignment requirements:
  - File access sizes: must be for a number of bytes that is an integer multiple of the volume sector size.
  - File access buffer addresses: aligned on addresses in memory that are integer multiples of the volume's physical sector size.

- two sector sizes:

  1. Logical Sector: The unit that is used for logical block addressing for the media. We can also think of it as the smallest unit of write that the storage can accept. This is the "emulation".

     > Application developers should take note of new types of storage devices being introduced into the market with a physical media sector size of 4,096 bytes. The industry name for these devices is "Advanced Format". As there may be compatibility issues with directly introducing 4,096 bytes as the unit of addressing for the media, a temporary compatibility solution is to introduce devices that emulate a regular 512-byte sector storage device but make available information about the true sector size through standard ATA and SCSI commands.

  2. Physical Sector: The unit for which read and write operations to the device are completed in a single operation. This is the unit of atomic write, and what unbuffered I/O will need to be aligned to in order to have optimal performance and reliability characteristics.

- Use `VirtualAlloc` to allocate sector-aligned buffers.

When to use unbuffered IO and buffered IO?

> You want unbuffered output whenever you want to ensure that the output has been written before continuing. One example is standard error under a C runtime library - this is usually unbuffered by default. Since errors are (hopefully) infrequent, you want to know about them immediately. On the other hand, standard output is buffered simply because it's assumed there will be far more data going through it.
>
> Another example is a logging library. If your log messages are held within buffers in your process, and your process dumps core, there a very good chance that output will never be written.

## File cache

> [File Caching](https://docs.microsoft.com/en-us/windows/win32/fileio/file-caching)

- Caching occurs under the direction of the **cache manager**, which operates continuously while Windows is running. 

- lazy writing: The policy of delaying the writing of the data to the file and holding it in the cache until the cache is flushed is called lazy writing, and it is triggered by the cache manager at a determinate time interval.

- when to use unbuffered io: When large blocks of file data are read and written, it is more likely that disk reads and writes will be necessary to finish the I/O operation.

- Write-through caching: directly write files to disk

  > such as virus-checking software, require that their write operations be flushed to disk immediately

  With write-through caching enabled, data is still written into the cache, but the cache manager writes the data immediately to disk rather than incurring a delay by using the lazy writer. 

- File system metadata: File system metadata is always cached. Therefore, to store any metadata changes to disk, the file must either be flushed or be opened with FILE_FLAG_WRITE_THROUGH.

