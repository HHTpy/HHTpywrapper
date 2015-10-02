import os
import shutil
import urllib.request
from pyunpack import Archive

urllib.request.urlretrieve('http://rcada.ncu.edu.tw/FEEMD.rar', 'EEMD.rar')
urllib.request.urlretrieve('http://rcada.ncu.edu.tw/Matlab%20runcode.zip',
                           'Matlab_runcode.zip')

Archive('Matlab_runcode.zip').extractall('./')
Archive('EEMD.rar').extractall('./HHT_MATLAB_package/')

os.rename("Matlab runcode", "Matlab_runcode")
os.rename("Matlab_runcode/FAimphilbert.m", "Matlab_runcode/FAimpHilbert.m")

source = os.listdir("./Matlab_runcode/")
destination = "./HHT_MATLAB_package/"
for files in source:
    shutil.move("./Matlab_runcode/" + files, destination)


os.remove("EEMD.rar")
os.remove("Matlab_runcode.zip")
os.rmdir("Matlab_runcode")
