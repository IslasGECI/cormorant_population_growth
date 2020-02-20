#!/usr/bin/env python

import argparse

def path_files():
    parser = argparse.ArgumentParser(description='CLI entradas y salidas')
    parser.add_argument('-i', '--input', action='append', nargs='+',help='Ruta al archivo de entrada')
    parser.add_argument('-e', '--exit', action='append', nargs='+', help='Ruta del archivo de salida')
    parser.add_argument('-d', '--drop', action='append', nargs='+', help='Registros no deseables')
    return parser.parse_args()