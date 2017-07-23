From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 2/2] IB/rxe: Convert pr_info to pr_warn
Date: Sun, 23 Jul 2017 08:22:56 +0300
Message-ID: <20170723052256.GA3259@mtr-leonro.local>
References: <20170721191409.3050-1-yuval.shaia@oracle.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="E50aLcSU4JxQSj/B"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170721191409.3050-1-yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--E50aLcSU4JxQSj/B
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jul 21, 2017 at 10:14:09PM +0300, Yuval Shaia wrote:
> This message is warning so let's print it accordingly.
>
> Signed-off-by: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> ---
>  drivers/infiniband/sw/rxe/rxe_av.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>

Thanks,
Reviewed-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

--E50aLcSU4JxQSj/B
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAll0MrAACgkQ5GN7iDZy
WKcxEw//bachzN04uwgytjGm3ZCnuMWQzZp6hJ6pSuQEKJTP7Wmhiz/cNrOLHqUa
5JtlG1ZciMBuxJ4zP5wyeKIWNcRLpBgsFFrOzhR6Ycp4PgHOmnPlX8N5VJ40zwb4
8lNsps1nf1NYXXblMG5awmEW3GtOiE6nfNIpQRiKXUWrWburt71SJfyQUh5gD0Ws
tcPJmn9uL6behJzeiU5DoRCNvZzO+74e3CW/nMoXGZTCRhjmTlk0xtt7OXp6xTK8
tHH1u0chxAVsPzDxVK7SwsW+iYIV5CeRIrYh8XKHRxCsvBChCpl/mxB3isnLtWtq
ocrDdSimhVU4O+8Nis9q32K+/Wop9kPv5wcSpivmc7Em/P9iYDdRNvhM6FKgeJQW
CJhCIvhyHn9/8sn9vivHDJLoKvKS40sU6xjbm3U8d47ROTTxqegLx1t6CIzJ2TU/
uS/iXUPPiBmkrcGBJQTbwTKuBo3si37q9DBmYQJFCfr6aE39/eX9ZinOv2rzV4N2
zPTQVXyAc/TM0WAIvLip63AGuEnln8szPQmRzcmKfJKtfWXZVhpgAFhPxIDeHq+I
pqHSAnoFDNHb3xJ5gFxaoHJ90ZHrnJeinhW6nnc1moj2GITOgg0Lc+O0+WBKSsrw
RqfwUh/UYHOw6o5pWri53kOM8Y0PjuwamHeF8WKS3OWhDuM6Alk=
=6CAp
-----END PGP SIGNATURE-----

--E50aLcSU4JxQSj/B--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
