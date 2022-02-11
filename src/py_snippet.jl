
py"""
from PyPDF2 import PdfFileMerger
from PyPDF2 import PdfFileReader
from PyPDF2 import PdfFileWriter

from hashlib import md5

from PyPDF2 import PdfFileReader, PdfFileWriter
from PyPDF2.generic import NameObject, DictionaryObject, ArrayObject, NumberObject, ByteStringObject
from PyPDF2.pdf import _alg33, _alg34, _alg35
from PyPDF2.utils import b_

#user_pwd (str) – The user password, which allows for opening and reading the PDF file with the restrictions provided.
#owner_pwd (str) – The owner password, which allows for opening the PDF files without any restrictions. By default, the owner password is the same as the user password.

def encrypt_modification(writer_obj: PdfFileWriter, user_pwd, owner_pwd=None, use_128bit=True):
    import time, random
    if owner_pwd == None:
        owner_pwd = user_pwd
    if use_128bit:
        V = 2
        rev = 3
        keylen = int(128 / 8)
    else:
        V = 1
        rev = 2
        keylen = int(40 / 8)
    # permit copy and printing only:
    P = -44
    O = ByteStringObject(_alg33(owner_pwd, user_pwd, rev, keylen))
    ID_1 = ByteStringObject(md5(b_(repr(time.time()))).digest())
    ID_2 = ByteStringObject(md5(b_(repr(random.random()))).digest())
    writer_obj._ID = ArrayObject((ID_1, ID_2))
    if rev == 2:
        U, key = _alg34(user_pwd, O, P, ID_1)
    else:
        assert rev == 3
        U, key = _alg35(user_pwd, rev, keylen, O, P, ID_1, False)
    encrypt = DictionaryObject()
    encrypt[NameObject("/Filter")] = NameObject("/Standard")
    encrypt[NameObject("/V")] = NumberObject(V)
    if V == 2:
        encrypt[NameObject("/Length")] = NumberObject(keylen * 8)
    encrypt[NameObject("/R")] = NumberObject(rev)
    encrypt[NameObject("/O")] = ByteStringObject(O)
    encrypt[NameObject("/U")] = ByteStringObject(U)
    encrypt[NameObject("/P")] = NumberObject(P)
    writer_obj._encrypt = writer_obj._addObject(encrypt)
    writer_obj._encrypt_key = key


#unmeta = PdfFileReader('my_pdf.pdf')

#writer = PdfFileWriter()
#writer.appendPagesFromReader(unmeta)
#encrypt(writer, '1', '123')

def read_and_encrypt(pdf_inputfile,pdf_outfile,secure_file=False,usrpwd=None,ownrpwd=None):
    #print('1')
    #print(pdf_inputfile)
    pdf = PdfFileReader(pdf_inputfile)
    #print('2')
    pdf_writer = PdfFileWriter()
    #print('3')
    for page in range(pdf.getNumPages()):
        pdfpage = pdf.getPage(page)
        pdf_writer.addPage(pdfpage)
    
    #print('4')

    with open(pdf_outfile, 'wb') as out:
        if secure_file: 
            encrypt_modification(pdf_writer, usrpwd, ownrpwd, use_128bit=True)
        pdf_writer.write(out)

    #print('5')

    return 0
"""
