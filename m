From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 09/13] SoftiWarp transmit path
Date: Sun, 8 Oct 2017 16:06:12 +0300
Message-ID: <20171008130612.GW25829@mtr-leonro.local>
References: <20171006122853.16310-1-bmt@zurich.ibm.com>
 <20171006122853.16310-10-bmt@zurich.ibm.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="APvmIexg9DiduZOF"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171006122853.16310-10-bmt-OA+xvbQnYDHMbYB6QlFGEg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bernard Metzler <bmt-OA+xvbQnYDHMbYB6QlFGEg@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--APvmIexg9DiduZOF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Oct 06, 2017 at 08:28:49AM -0400, Bernard Metzler wrote:
> Signed-off-by: Bernard Metzler <bmt-OA+xvbQnYDHMbYB6QlFGEg@public.gmane.org>
> ---
>  drivers/infiniband/sw/siw/siw_qp_tx.c | 1341 +++++++++++++++++++++++++++++++++
>  1 file changed, 1341 insertions(+)
>  create mode 100644 drivers/infiniband/sw/siw/siw_qp_tx.c
>

All BUGs and BUG_ONs should be removed.

Thanks,

--APvmIexg9DiduZOF
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlnaIsQACgkQ5GN7iDZy
WKfVtw/+L+uXgu7UK1NZGobNs7HddJHHklmsEAw/TGyXaIGIjZbwF5uBe1gDrNZ3
v0nnp4ieuK+J9CjfHFva3UeVZ0TzTFGizK+d6hpAq8dgwBAXjI2gOug6WKDVNwdn
NkGPPAduRO0LlqNOy9hRnqkuXHxVqLg3BgkPnWdx2F/IA9QwK5bIcs3pg021C9EU
IBOJ6f8TQ+iNRCJABOZn8Qa43BrRoQuw9pzxD4ZFsm2R/SDDY0n1CTFaKFvcMbjh
61gFC52CjxdOlsj2M2bEnBcrF0UwlYJ3Sjo7Uixr2rxJT5tlxsL2W28sbNkERNIB
2unmc/EENsjcyDYYA8RBnTWckUV9x4wk86/DqTO2UMg4yOtyu1PtbDcaA+7Cd+l8
wz+yriz631ZVQH7IZpHIfi81pyv9Nfna6nwqY4uHjp84ToZTkTbk2njW0Y2dRy9o
I3RXOxd0jBiTphXSbuFXRMwz9dJicL6ukn5YK9nfoFdHBwsH4teyh52iVgmSGHcK
GpRg39mRyKKSEyRonGaP/eRP4QsJrMtNU2XeR27T0yeBb9C1ofjz+hHcWYElnwFn
Rhx70WxDiSYP4CXalCQXOBy8HwKcEya1QPsPMInkUftWkpA+YSDdp/NjbadZkYsn
SaVz5S2+rTFDlWW4wOlyIogiqbRm33t5MBMccXpCKZlx/OKoGDw=
=8SVM
-----END PGP SIGNATURE-----

--APvmIexg9DiduZOF--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
