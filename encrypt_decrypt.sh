#!/bin/bash

option="" # Menu option variable

echo "Welcome to Text Message Encryption & Decryption Shell Program."
echo "Please select 'E/e' for encryption or 'D/d' for decryption:"
read option

case "$option" in
e|E)
    # Input plain text file
    echo "Enter plain text file name:"
    read plainFile
    if [ ! -f "$plainFile" ]; then
        echo "File does not exist in current directory."
        exit 1
    fi

    # Check for non-alphabet characters
    while read -r line; do
        if [[ $line =~ [^A-Za-z] ]]; then
            echo "Input file contains non-alphabetical characters."
            exit 1
        fi
    done < "$plainFile"

    # Variables for key generation
    sum=0
    max=0
    keyWord=""

    # Compute sum for each word to generate key
    while read -r line; do
        read -r -a array <<< "$line"
        for word in "${array[@]}"; do
            while read -n1 char; do
                case "$char" in
                    A|a)sum=$((sum+1));;
                    B|b)sum=$((sum+2));;
                    C|c)sum=$((sum+3));;
                    D|d)sum=$((sum+4));;
                    E|e)sum=$((sum+5));;
                    F|f)sum=$((sum+6));;
                    G|g)sum=$((sum+7));;
                    H|h)sum=$((sum+8));;
                    I|i)sum=$((sum+9));;
                    J|j)sum=$((sum+10));;
                    K|k)sum=$((sum+11));;
                    L|l)sum=$((sum+12));;
                    M|m)sum=$((sum+13));;
                    N|n)sum=$((sum+14));;
                    O|o)sum=$((sum+15));;
                    P|p)sum=$((sum+16));;
                    Q|q)sum=$((sum+17));;
                    R|r)sum=$((sum+18));;
                    S|s)sum=$((sum+19));;
                    T|t)sum=$((sum+20));;
                    U|u)sum=$((sum+21));;
                    V|v)sum=$((sum+22));;
                    W|w)sum=$((sum+23));;
                    X|x)sum=$((sum+24));;
                    Y|y)sum=$((sum+25));;
                    Z|z)sum=$((sum+26));;
                esac
            done <<< "$word"
            if [ "$sum" -gt "$max" ]; then
                max=$sum
                keyWord="$word"
            fi
            sum=0
        done
    done < "$plainFile"

    bkey=$(echo "obase=2;$max" | bc)
    printf "Key word: %s, Key decimal: %d\n" "$keyWord" "$max"
    printf "Key binary: %s\n" "$bkey"

    # Prepare temp files
    > ascii.txt > delim.txt > delim2.txt > dAscii.txt > bAscii.txt > xor1.txt > xor2.txt > xor3.txt

    tr ' ' '&' < "$plainFile" > delim.txt
    tr '\12' '@' < delim.txt > delim2.txt

    # ASCII conversion
    while read -n1 char; do
        printf "%s%d\n" "$char" "'$char" >> ascii.txt
    done < delim2.txt

    # Remove non-digits for decimal ASCII
    tr -d '[A-Za-z@&]' < ascii.txt > dAscii.txt

    # Decimal to binary
    while read decimalAscii; do
        binaryAscii=$(echo "obase=2;$decimalAscii" | bc)
        echo "$binaryAscii" >> bAscii.txt
    done < dAscii.txt

    # XOR with key
    while read decimalAscii; do
        xorVal=$((decimalAscii ^ max))
        echo "$xorVal" >> xor1.txt
    done < dAscii.txt

    # Binary conversion after XOR
    while read decimalXor; do
        binaryXor=$(echo "obase=2;$decimalXor" | bc)
        echo "$binaryXor" >> xor2.txt
    done < xor1.txt

    # Pad to 8 bits
    while read -r line; do
        while [ ${#line} -lt 8 ]; do
            line="0$line"
        done
        echo "$line" >> xor3.txt
    done < xor2.txt

    echo "Enter cipher text output file name:"
    read encrypted
    > "$encrypted"

    # 4-bit swap
    while read -r line; do
        echo "${line:(-4)}${line:0:4}" >> "$encrypted"
    done < xor3.txt

    # Pad and swap key
    while [ ${#bkey} -lt 8 ]; do
        bkey="0$bkey"
    done
    echo "${bkey:(-4)}${bkey:0:4}" >> "$encrypted"
    ;;

d|D)
    echo "Enter cipher text file name:"
    read cipher
    if [ ! -f "$cipher" ]; then
        echo "File does not exist."
        exit 1
    fi

    :> infile.txt :> temp.txt :> semiFinal.txt :> EncSwapped.txt :> swapped.txt :> Final.txt :> invDelim.txt
    cp "$cipher" infile.txt

    Keydec=$(tail -n1 infile.txt)
    Keydec=${Keydec:(-4)}${Keydec:0:4}
    Dkey=$((2#$Keydec))
    printf "Key binary: %s, Key decimal: %d\n" "$Keydec" "$Dkey"

    # Remove key line
    sed '$d' infile.txt > temp.txt && mv temp.txt infile.txt

    # Swap 4-bit back
    while read -r l; do
        echo "${l:(-4)}${l:0:4}" >> swapped.txt
    done < infile.txt

    # Binary → Decimal
    while read swap; do
        bin2dec=$((2#$swap))
        echo "$bin2dec" >> EncSwapped.txt
    done < swapped.txt

    # XOR with key
    while read deciSwap; do
        decXKey=$((deciSwap ^ Dkey))
        echo "$decXKey" >> semiFinal.txt
    done < EncSwapped.txt

    # Decimal → char
    while read a; do
        echo "$a" | awk '{ printf("%c",$0); }' >> Final.txt
    done < semiFinal.txt

    echo "Enter decrypted output file name:"
    read output
    tr '&' ' ' < Final.txt > invDelim.txt
    tr '@' '\12' < invDelim.txt > "$output"
    ;;

*)
    echo "Invalid option!"
    exit 1
    ;;
esac
