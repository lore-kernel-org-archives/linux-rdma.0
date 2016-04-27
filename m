From: Robert LeBlanc <robert-4JaGZRWAfWbajFs6igw21g@public.gmane.org>
Subject: Status of RXE/Soft-RoCE driver?
Date: Wed, 27 Apr 2016 16:57:53 -0600
Message-ID: <CAANLjFq+6qu7kD75yOmVuztvE-6cbvhfjFOmGAy9i_43Cfdz7A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA256

What is the status of getting RXE included in the mainline kernel? I
saw a post from Kamal Heib on 22 Sep 2015 with a patchset for
inclusion [0], but there didn't seem to be any discussion about it. I
diffed the kernel tree with the RXE tree on GitHub using the
rxe_submission_v8 branch [1], but there was over 10 million lines in
the patch file for the same kernel version. I'd rather patch into the
vanilla kernel tree so that I can see the differences rather than just
building the tree that someone else provides.

I will probably go through all 32 patches anyway, but thought I would
prod here about the status as it can be very helpful for
compatibility.

[0] http://www.spinics.net/lists/linux-rdma/msg28829.html
[1] https://github.com/SoftRoCE/rxe-dev/tree/rxe_submission_v8

Thanks,
- ----------------
Robert LeBlanc
PGP Fingerprint 79A2 9CA4 6CC4 45DD A904  C70E E654 3BB2 FA62 B9F1
-----BEGIN PGP SIGNATURE-----
Version: Mailvelope v1.3.6
Comment: https://www.mailvelope.com

wsFcBAEBCAAQBQJXIUPOCRDmVDuy+mK58QAA+noQALVF1CpD+oqlMR2lgRT1
zFgy5PeKLjX+nmqZExuvd0uu2kVw/JNJUnsvUGG0083/HT68Qm0XuVzZMoPX
XQq5VoyuqsapEX2nEGhT2Wy+w6hSvxpVn6xGde11v6RQ9Lq/u1yHGxUFmWGf
BwHD3G4/pGgJg5dG/BbfxUYE4w+TNl4FpGVAeZOPsCRCVehxQsgU7LNPWyo+
pWcn3CY1AAIgUB+ZLKASsQq5a7/jbuYKFJCdC0i56dCiv8RHdGxTLRGzquLy
QOR0sUhxDhUAKS1iwX/UdOXvCm6iWOesF5XWS19311ENPZREgaGtrcCNkXTM
cDQi1eQU0BB2j2ZIsFMhTh1mD5NxKNTOWDptexEpa0VYFLxs1nnkajhm854d
YZXXqSOnKtAkatjEXKRXWzJImgVcPl7FnWY6va+VKt/YNpZ4WzekL+V73Xly
5at18zou4DpZG8OYkg1hTW13X/1NYlOctwdu7qYSj1MAuJ0DHcoV/UAg8/SQ
L+27Hf71svtsLvDqwN7+uDj3mg74Iu6s5jBhjwYFNU6aeQKOZzllAjOczT+Z
bY+1MGSGPY3Tt7Y5BunTLsp63O5VPcWBk64P5TE+RDoXYAzfan1Ok0h1Vinm
x3n6yWY23mlTSflVtzF+z+97Dq6VoSmKDUVhz/yB4Ehu6r54N5bcT25ohDUB
L9IZ
=u+48
-----END PGP SIGNATURE-----
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
