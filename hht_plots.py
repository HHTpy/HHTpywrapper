import matplotlib.pyplot as plt
import matplotlib.image as mpimg


def example_qpo(time, amp, imfs, ifreq, iamp):
    plt.subplot(221)
    plt.plot(time, amp)
    plt.ylabel('4-Hz QPO X-ray Light Curve (cts/s)')
    plt.subplot(222)
    plt.plot(time, ifreq)
    plt.ylabel('Instantaneous frequency (Hz)')
    plt.subplot(223)
    plt.plot(time, imfs)
    plt.ylabel('IMF c4')
    plt.xlabel('Time (s)')
    plt.subplot(224)
    plt.plot(time, iamp)
    plt.ylabel(r'Instantaneous amplitude (cts/s)')
    plt.xlabel('Time (s)')
    plt.show()


def example_lena(filename, imfs):
    img = mpimg.imread(filename)
    plt.subplot(231)
    plt.imshow(img)
    plt.title('Original image', fontsize=10)
    plt.subplot(232)
    plt.title('IMF c1', fontsize=10)
    plt.imshow(imfs[:, :, 0], cmap="Greys_r")
    plt.subplot(233)
    plt.title('IMF c2', fontsize=10)
    plt.imshow(imfs[:, :, 1], cmap="Greys_r")
    plt.subplot(234)
    plt.title('IMF c3', fontsize=10)
    plt.imshow(imfs[:, :, 2], cmap="Greys_r")
    plt.subplot(235)
    plt.title('IMF c4', fontsize=10)
    plt.imshow(imfs[:, :, 3], cmap="Greys_r")
    plt.subplot(236)
    plt.title('IMF c5', fontsize=10)
    plt.imshow(imfs[:, :, 4], cmap="Greys_r")
    plt.show()
