#!/bin/bash

function export_pin() {
    local pin=$1
    if [ -d /sys/class/gpio/gpio$pin ]
    then
        echo /sys/class/gpio/gpio$pin "GPIO Already Exported" 
    else
        echo /sys/class/gpio/gpio$pin "Not Found, export GPIO"
        echo $pin > /sys/class/gpio/export
    fi
}

function unexport_pin() {
    local pin=$1
    if [ -d /sys/class/gpio/gpio$pin ]
    then
        echo /sys/class/gpio/gpio$pin "Found, unexport GPIO" 
        echo $pin > /sys/class/gpio/unexport
    else
        echo /sys/class/gpio/gpio$pin "GPIO Already Unexported"
    fi
}

function set_out() {
    local pin=$1
    if [ -d /sys/class/gpio/gpio$pin ]
    then
        echo /sys/class/gpio/gpio$pin "Set to OUTPUT" 
        echo "out" > /sys/class/gpio/gpio$pin/direction
    else
        echo /sys/class/gpio/gpio$pin "Not Found GPIO"
    fi
}

function set_in() {
    local pin=$1
    if [ -d /sys/class/gpio/gpio$pin ]
    then
        echo /sys/class/gpio/gpio$pin "Set to INPUT" 
        echo "in" > /sys/class/gpio/gpio$pin/direction
    else
        echo /sys/class/gpio/gpio$pin "Not Found GPIO"
    fi
}

function set_high() {
    local pin=$1
    if [ -d /sys/class/gpio/gpio$pin ]
    then
        echo /sys/class/gpio/gpio$pin "Set to HIGH" 
        echo 1 > /sys/class/gpio/gpio$pin/value
    else
        echo /sys/class/gpio/gpio$pin "Not Found GPIO"
    fi
}

function set_low() {
    local pin=$1
    if [ -d /sys/class/gpio/gpio$pin ]
    then
        echo /sys/class/gpio/gpio$pin "Set to LOW" 
        echo 0 > /sys/class/gpio/gpio$pin/value
    else
        echo /sys/class/gpio/gpio$pin "Not Found GPIO"
    fi
}


function call_func_array() {
    local call_array=("${!2}")

    local func=$1
    for i in ${call_array[@]}
    do
        $func $i
    done
}

function blink_gpios() {
    local gpios_array=("${!1}")
    local delay=$2

    call_func_array export_pin gpios_array[@]   
    call_func_array set_out gpios_array[@]   
    for (( ; ; ))
    do 
        call_func_array set_high gpios_array[@]   
        sleep $delay

        call_func_array set_low gpios_array[@]   
        sleep $delay
    done
    call_func_array unexport_pin gpios_array[@]   
}


gpios=("60" "10" "11")

echo "gpios[0]     = ${gpios[0]}"  #print gpios[0]
echo "gpios[2]     = ${gpios[2]}"  #print gpios[2]
echo "gpios[*]     = ${gpios[*]}"  #print gpios all item
echo "gpios[@]     = ${gpios[@]}"  #print gpios all item
echo "gpios index  = ${!gpios[@]}" #print gpios index number
echo "gpios size   = ${#gpios[@]}" #print gpios size
echo "gpios[0] size= ${#gpios[0]}" #print gpios[0] size

blink_gpios gpios[@]  1
