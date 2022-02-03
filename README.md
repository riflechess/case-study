## case-study
Tech Assessment Case Study

### lfs
`lfs` will produce a JSON formatted list of files and their size (bytes) for a given filesystem or mount point.

```shell
# example usage
$ ./lfs /tmp/cs
{
  "files":
  [
    {
    "name":"/tmp/cs/main.rs",
    "size":31527
    }
    ,
    {
    "name":"/tmp/cs/z/x/y/n/l/notes.txt",
    "size":16
    }
    ,
    {
    "name":"/tmp/cs/cs.tar.gz",
    "size":32562831
    }
  ]
}
```
### installation/build
`lfs` is built in rust, with a few cargo [crates](https://crates.io/).  Use the following procedure to install in a linux environment.

```shell
# Use default rustup installation procedure from https://doc.rust-lang.org/book/ch01-01-installation.html
$ curl --proto '=https' --tlsv1.2 https://sh.rustup.rs -sSf | sh

# Source your path
source $HOME/.cargo/env

# Validate install 
rustc --version
rustc 1.58.1 (db9d1b20b 2022-01-20)

# clone repostiory
git@github.com:riflechess/case-study.git
cd case-study/src

# build release (this may take a couple of minutes)
cargo build --release
cd ../target/release/

# run binary
./lfs --help
lfs - list file sizes
lfs will provide json-formatted output of the specified files in a given directory.
USAGE: lfs [directory]
       lfs /tmp/
       lfs --help
```

### test module
Project includes a test module, `test-module.sh`.  
 - Generates random number of files (maximum `maxfiles`) in subfolder of a specified `workingdir`
 - Each of these file has random filesize (maximum `maxfilebytes`)
 - Test 1 compares `lfs` derived filecount vs. actual
 - Test 2 compares `lfs` derived total filesize vs. actual

`test-module.sh` prereqs:
 - `jq` installed for parsing the JSON output
 - `lfs` compiled and location added to `lfsbinary`

```
~/dev/case-study/src$ ./test-module.sh 
20220202_063457 - ***LFS test module***
20220202_063457 - workingdir:   /tmp/cs
20220202_063457 - maxfiles:     5000
20220202_063457 - maxfilebytes: 1000000
20220202_063500 - 2228 files created in /tmp/cs/4a31
20220202_063500 - 36127900 bytes total
20220202_063500 - FILECOUNT TEST: checking /tmp/cs/4a31 count with lfs...
20220202_063500 - lfs filecount in /tmp/cs/4a31 is 2228
20220202_063500 - FILECOUNT PASS
20220202_063500 - FILESIZE TEST: checking /tmp/cs/4a31 total file size with lfs...
20220202_063500 - lfs file size in /tmp/cs/4a31 is 36127900
20220202_063500 - FILESIZE PASS
20220202_063500 - Tests completed successfully.
20220202_063500 - /tmp/cs/4a31 removed
```

### web service
Project has a simple REST webservice under `./site`, and hosted at [https://cs.sitsev.net/](https://cs.sitsev.net/).  

The project contains a binary that was built on Ubuntu on `x86_64`, so it may need to be rebuilt (instructions above) to work on another platform.  

#### deploy web service

```
# clone repostiory
git@github.com:riflechess/case-study.git
cd case-study/site

# bring up container (docker compose)
docker-compose up -d
```
#### call web service
```
curl "https://cs.sitsev.net/lfs.php?fs=/var"
```