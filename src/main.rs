extern crate exitcode;
extern crate walkdir;

use walkdir::WalkDir;
use std::env;
use std::path::Path;

fn usage(){
    println!("USAGE: lfs [directory]");
    println!("       e.g. lfs /tmp/");
    println!("       lfs --help");
    
    std::process::exit(exitcode::OK);    
}

fn help(){
    println!("lfs - list file sizes");
    println!("lfs will provide json-formatted output of the specified files in a given directory.");
	println!("USAGE: lfs [directory]");
    println!("       lfs /tmp/");
    println!("       lfs --help");

    std::process::exit(exitcode::OK);
}

fn err(errtxt: &str){
    println!("{} error has occurred.  Exiting.", errtxt);
    std::process::exit(exitcode::DATAERR);
}

fn main() {
    let args: Vec<String> = env::args().collect();
    if args.len() != 2 {
        usage();
    }else if &args[1] == "--help" {
    	help(); 
	}else{
        let rootfs = &args[1];
        if Path::new(rootfs).exists() {
        println!("{}","{"); 
        println!("  \"files\":\n  [");
        let mut first=true;
        for e in WalkDir::new(rootfs).into_iter().filter_map(|e| e.ok()) {
            if e.metadata().unwrap().is_file() {
                let filepath = e.path();
                if first == false {
                    println!("{}","    ,");
                }
                first = false;
                println!("{}{}{}{}{}","    {\"name\":\"",filepath.display(),"\", \"size\":",std::fs::metadata(filepath).unwrap().len(),"}");
            }
        }
        println!("{}","  ]\n}");
        }else{
            err("FILESYSTEM NOT FOUND");
        }
    }
}
