#!/bin/bash

AUTOMATIC_DIR="/home/c_byrne/tools/sd/sd-interfaces/stable-diffusion-webui"

sd() {
	cd $AUTOMATIC_DIR
	python launch.py --xformers --no-half-vae
}

sd