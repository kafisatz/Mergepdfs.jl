
function __init__()
    try
	    copy!(pyModulePyPDF2, PyCall.pyimport("PyPDF2"))
    catch e 
        @show e
        try  
            copy!(pyModulePyPDF2, PyCall.pyimport_conda("PdfFileMerger","PyPDF2","conda-forge"))
        catch f
            @show f 
        end
    end

py"""
import pkg_resources
vv = pkg_resources.get_distribution("PyPDF2").version
print(f"Mergepdfs - Check is OK: PyPDF2 version is: {vv}. We expect 1.27.9")

#print(vv)
if "1.27.9" != vv:
    print(f"Mergepdfs - ERROR: PyPDF2 version is: {vv}. We expect 1.27.9")
    print('Consider this snippet:')
    print('ENV["PYTHON"]=raw"c:\Python313\python.exe"; using Pkg; Pkg.build("PyCall");Pkg.build("Mergepdfs");')

assert "1.27.9" == vv, f"PyPDF2 is not equal to 1.27.9, got: {vv}"

import pkg_resources
pkg_resources.require("PyPDF2==1.27.9")

from PyPDF2 import PdfFileMerger
from PyPDF2 import PdfFileReader
from PyPDF2 import PdfFileWriter

from hashlib import md5

from PyPDF2 import PdfFileReader, PdfFileWriter
from PyPDF2.generic import NameObject, DictionaryObject, ArrayObject, NumberObject, ByteStringObject
#from PyPDF2._security import _alg33, _alg34, _alg35
#from PyPDF2._utils import b_
from PyPDF2.pdf import _alg33, _alg34, _alg35
from PyPDF2.utils import b_

#see https://github.com/py-pdf/PyPDF2/blob/a89ff74d8c0203278a039d9496a3d8df4d134f84/PyPDF2/_security.py

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

end #end __init__
