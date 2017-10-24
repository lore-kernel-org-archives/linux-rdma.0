From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Endianess in cxgb4
Date: Tue, 24 Oct 2017 21:37:59 +0300
Message-ID: <20171024183759.GK16127@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="YZQs1kEQY307C4ut"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--YZQs1kEQY307C4ut
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Steve,

I reviewed my reports from various static checkers and saw strange code
in build_tpte_memreg() function that in drivers/infiniband/hw/cxgb4/qp.c.

That function has following code:
 614         fr->r2 = cpu_to_be32(0);
 615         fr->stag = cpu_to_be32(mhp->ibmr.rkey);

The r2, stag and rkey are u32, why do you need cpu_to_be32() conversion?

The error report which I got is:

 134 drivers/infiniband/hw/cxgb4/qp.c:614:16: warning: incorrect type in assignment (different base types)
 135 drivers/infiniband/hw/cxgb4/qp.c:614:16:    expected unsigned int [unsigned] [usertype] r2
 136 drivers/infiniband/hw/cxgb4/qp.c:614:16:    got restricted __be32 [usertype] <noident>
 137 drivers/infiniband/hw/cxgb4/qp.c:615:18: warning: incorrect type in assignment (different base types)
 138 drivers/infiniband/hw/cxgb4/qp.c:615:18:    expected unsigned int [unsigned] [usertype] stag
 139 drivers/infiniband/hw/cxgb4/qp.c:615:18:    got restricted __be32 [usertype] <noident>

Thanks

--YZQs1kEQY307C4ut
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlnviIcACgkQ5GN7iDZy
WKfEZhAAq6DLzV2xp9g33SFrVQhtLmngV3d23nwu2d+FUrO7StEyuwER16QeJ206
JILczFbwXCQbO/UYPmhnp/L9OgVxu0oxT/eBBZ/fJJFTiF3y4cJiLJiaj2PUcl54
90W9qMilDEikVIn4R0e4s1mEisNVsOR+KYPtitxSu4uPq66/51N2yvuPhLtPwEWK
+9JlahrCVxAZ4wmP/bqEUpzniMsKqn2Uon4lpf5GRMaM5DNZ2mCwrSRWvHlwUXsc
/JdtlkMP1Oz0ynZDeMxRrQLzfOVVK524dB+ObxYmIUYCidVd1sKiq84H5kD3UbDz
aKsp0U6BM8iFdekJ7M0ZshfBg2enV8AZhJjfDzRCB/Yzoj2hd/uih/Y4Tv2K4qO8
bNT7eVjsxAiWeZofOQPxi8uPfXwfJCD06lHv1tQ9HVtMINb2adkaHtJFdDynsw/M
Ix7XDc+P+c+PqNHV+UM5ebjN7xHiFS5LGQGFf6p6tn49BUyZuORoBLXyJjCpsifH
RSdfglMYMcx4DiiTe6W0940Y2Rfm5wpFXceMVL3mpHmFIo4pDjQASzSN5GIBvJFf
iY0YjW3mJdYq7W0zHh0OkGRr026kyRUPyOkuUYHVBFioLqzBkP/YLb5fPYAJKrlW
yw+D0p8W04GbrQxBoZCLM0gNlnZDxljplB7f1VL8P+nHuxI8SV8=
=e+Xl
-----END PGP SIGNATURE-----

--YZQs1kEQY307C4ut--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
