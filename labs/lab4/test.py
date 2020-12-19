#!/usr/bin/python

import sys
import lxml.etree

#print 'Number of arguments:', len(sys.argv), 'arguments.'
#print 'Argument List:', str(sys.argv)

def check_args(args):
    if len(args) != 3:
        print("test <dtd-file> <xml-file>")
        sys.exit(-1)
        

if __name__ == "__main__":
    check_args(sys.argv)
    xml_validator = lxml.etree.DTD(file=sys.argv[1])
    xml_file = lxml.etree.parse(sys.argv[2])
    print(xml_validator.validate(xml_file))
