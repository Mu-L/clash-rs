#!/bin/sh

# docker's platform to clash-rs's built binary name
file_name=""
case $TARGETPLATFORM in
    "linux/amd64")
        file_name="x86_64-unknown-linux-gnu-static-crt"
        ;;
    "linux/arm64")
        file_name="aarch64-unknown-linux-gnu-static-crt"
        ;;
    "linux/arm/v7")
        file_name="armv7-unknown-linux-gnueabi-static-crt"
        ;;
    *)
        echo "Unknown architecture"
        exit 1
        ;;        
esac

echo $file_name