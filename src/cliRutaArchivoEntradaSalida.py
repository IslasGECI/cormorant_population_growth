#!/usr/bin/env python

import argparse

def ruta_archivos():
    parser = argparse.ArgumentParser(description='CLI entradas y salidas')
    parser.add_argument('-e', '--entrada', action='append', nargs='+',help='Ruta al archivo de entrada')
    parser.add_argument('-s', '--salida', action='append', nargs='+', help='Ruta del archivo de salida')
    return parser.parse_args()