#-*- coding:utf-8 -*-
import matlab
import matlab.engine
import time

def testMatlab(filepath, id):
    print("Begin to start matlab...")
    print(time.time())
    engine = matlab.engine.start_matlab()
    print("Start matlab sucess!")
    print(time.time())
    # out = engine.divide(matlab.double([5]), matlab.double([2]))
    if id == 1:
        out = engine.piRNApredictor(filepath)
    else:
        out = engine.piRNApredictor2(filepath)
    engine.quit()