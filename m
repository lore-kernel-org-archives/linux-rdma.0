From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-core 0/2] Fixes for hip8 libhns
Date: Mon, 20 Nov 2017 10:30:48 +0200
Message-ID: <20171120083048.GD18825@mtr-leonro.local>
References: <1511000496-181604-1-git-send-email-oulijun@huawei.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="UFAhM25PQ7kKLIx5"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1511000496-181604-1-git-send-email-oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--UFAhM25PQ7kKLIx5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Nov 18, 2017 at 06:21:34PM +0800, Lijun Ou wrote:
> These series fix two bugs with filtering the 0 length sge
> as well as make hns sparse clean.
>
> Lijun Ou (2):
>   libhns: Make the provider sparse clean
>   libhns: Filter for zero length of sge in hip08 userspace
>

Thanks, applied.

--UFAhM25PQ7kKLIx5
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAloSkrgACgkQ5GN7iDZy
WKdCOxAAzcuHRlTpkEg44hzsIKcVwgUw8CkUuox+GoWh82cv7WN/2X0HTK+dMmnT
X5tEL+rYdZ2LHJNwoR5fFzcr2gtbyCScJxqGk0OMWKyPZe6/+JwvyllllT/pJIGQ
P86hMl3CJz0hDlqzRj+MYZTouL8itet9iFzksMISS6uXHaD8s5H+nveOaCL2c/Pv
HHrWGycakR8zcEDLkI1nzP2Ireq3f/wK7X+OCLJXWc/ut4aTznY37r362QJytz5S
RWkuPBVJKK+vM80HgisRdqVvCeqePQ4kaeKVqx1X5pjybalbXs9FQQ5vmtvdelQR
+ST+CZ8Kbn/x/+JlCDceIBZno5k2L8iFvG78hjfmsvsM2hV9vBIelEiN78MdlzMs
tJHPPtJ706UEPY/yQn7FL+BbPhU6UHu/l41OFh1/wBiklHRqoHaPWPKtnQFy4OFF
pBP6isrgPIU2Lmu1W9NzFh7kGhKRPFjhTeWKuA4gjQBtEkswVgmr6tX8njAgW1nz
pJV5uZKQApgkD3xyiMbPGUtMHWDxKmMzg28+PVQup8vEc/S4RLxx/VLTB4kCRO5z
q4rwvnWMPmg31vo3DvnV4Qf4qcjul6DO+ktYRl+7sitYA62rAUCw5FwKVK+XaYCL
yfoZXnIpfWj1x5JcNUn2vXPSLvCLlaKe3nQXjSw3i9Bf9hMwIJg=
=swfp
-----END PGP SIGNATURE-----

--UFAhM25PQ7kKLIx5--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
