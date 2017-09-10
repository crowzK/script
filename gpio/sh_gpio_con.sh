#!/bin/sh

export_pin() {
    local pin=$1
    if [ -d /sys/class/gpio/gpio$pin ]
    then
        echo /sys/class/gpio/gpio$pin "GPIO Already Exported" 
    else
        echo /sys/class/gpio/gpio$pin "Not Found, export GPIO"
        echo $pin > /sys/class/gpio/export
    fi
}

unexport_pin() {
    local pin=$1
    if [ -d /sys/class/gpio/gpio$pin ]
    then
        echo /sys/class/gpio/gpio$pin "Found, unexport GPIO" 
        echo $pin > /sys/class/gpio/unexport
    else
        echo /sys/class/gpio/gpio$pin "GPIO Already Unexported"
    fi
}

set_out() {
    local pin=$1
    if [ -d /sys/class/gpio/gpio$pin ]
    then
        echo /sys/class/gpio/gpio$pin "Set to OUTPUT" 
        echo "out" > /sys/class/gpio/gpio$pin/direction
    else
        echo /sys/class/gpio/gpio$pin "Not Found GPIO"
    fi
}

set_in() {
    local pin=$1
    if [ -d /sys/class/gpio/gpio$pin ]
    then
        echo /sys/class/gpio/gpio$pin "Set to INPUT" 
        echo "in" > /sys/class/gpio/gpio$pin/direction
    else
        echo /sys/class/gpio/gpio$pin "Not Found GPIO"
    fi
}

set_high() {
    local pin=$1
    if [ -d /sys/class/gpio/gpio$pin ]
    then
        echo /sys/class/gpio/gpio$pin "Set to HIGH" 
        echo 1 > /sys/class/gpio/gpio$pin/value
    else
        echo /sys/class/gpio/gpio$pin "Not Found GPIO"
    fi
}

set_low() {
    local pin=$1
    if [ -d /sys/class/gpio/gpio$pin ]
    then
        echo /sys/class/gpio/gpio$pin "Set to LOW" 
        echo 0 > /sys/class/gpio/gpio$pin/value
    else
        echo /sys/class/gpio/gpio$pin "Not Found GPIO"
    fi
}

array_test() {
    local count=`expr $idx + 1`
    local idx=0

    while [ true ]
    do 
        idx=`expr $idx + 1`
        if [ $idx > $count ]
        then
            break
        fi
    done
}

call_func_array() {
    local func=$1
    local count=`expr $# - 1`
    local idx=0
    for TOKEN in $*
    do
        idx=`expr $idx + 1`
        if [ $idx -gt 1 ]
        then
            $func $TOKEN
        fi
    done
}


blink_gpio() {
    local pin=$1
    local delay=$2
    
    export_pin $pin   
    set_out $pin    
    
    while [ true ]
    do 
        set_high $pin     
        sleep $delay

        set_low $pin  
        sleep $delay
    done
    unexport_pin $pin     
}

blink_gpios() {

    call_func_array export_pin $*  
    call_func_array set_out $*  
    while [ true ]
    do 
        call_func_array set_high $*   
        sleep 1

        call_func_array set_low $*   
        sleep 1
    done
    call_func_array unexport_pin $*  
}

blink_gpios 10 60
