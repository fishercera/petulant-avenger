#!/usr/bin/bash

function quit {
    exit
}
function hello {
    echo Hello!
}
hello
#quit
echo foo 
	  
function e {
    echo $1 
}  
e Hello
e World
#quit

e "So calling a function is just this simple"

quit
echo foo 
