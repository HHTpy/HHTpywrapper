from pymatbridge import Matlab

mlab = Matlab()
mlab.start()
mlab.run_code('addpaths')


class EMD():
    def __init__(self, signal, Nstd, NE, num_imf=10, run_CEEMD=1, max_sift=10,
                 type_spline=2, modify_BC=1, rand_type=2, seed_no=1,
                 check_signal=1):
        res = mlab.run_func('feemd_post_pro', signal, Nstd, NE, num_imf,
                            run_CEEMD, max_sift, type_spline, modify_BC,
                            rand_type, seed_no, check_signal)
        self.imfs = res['result']
