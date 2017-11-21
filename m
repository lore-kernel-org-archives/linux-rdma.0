From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] IB: INFINIBAND should depend on HAS_DMA
Date: Tue, 21 Nov 2017 08:06:33 +0200
Message-ID: <20171121060633.GP18825@mtr-leonro.local>
References: <1511117910-25003-1-git-send-email-geert@linux-m68k.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="RzVoCur9CYlE2OzC"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1511117910-25003-1-git-send-email-geert-Td1EMuHUCqxL1ZNQvxDV9g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Geert Uytterhoeven <geert-Td1EMuHUCqxL1ZNQvxDV9g@public.gmane.org>
Cc: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--RzVoCur9CYlE2OzC
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Nov 19, 2017 at 07:58:30PM +0100, Geert Uytterhoeven wrote:
> If NO_DMA=y:
>
>     ERROR: "bad_dma_ops" [net/sunrpc/xprtrdma/rpcrdma.ko] undefined!
>     ERROR: "bad_dma_ops" [net/smc/smc.ko] undefined!
>     ERROR: "bad_dma_ops" [net/rds/rds_rdma.ko] undefined!
>     ERROR: "bad_dma_ops" [net/9p/9pnet_rdma.ko] undefined!
>     ERROR: "bad_dma_ops" [drivers/nvme/target/nvmet-rdma.ko] undefined!
>     ERROR: "bad_dma_ops" [drivers/nvme/host/nvme-rdma.ko] undefined!
>     ERROR: "bad_dma_ops" [drivers/infiniband/ulp/srpt/ib_srpt.ko] undefined!
>     ERROR: "bad_dma_ops" [drivers/infiniband/ulp/srp/ib_srp.ko] undefined!
>     ERROR: "bad_dma_ops" [drivers/infiniband/ulp/isert/ib_isert.ko] undefined!
>     ERROR: "bad_dma_ops" [drivers/infiniband/ulp/iser/ib_iser.ko] undefined!
>     ERROR: "bad_dma_ops" [drivers/infiniband/ulp/ipoib/ib_ipoib.ko] undefined!
>     ERROR: "bad_dma_ops" [drivers/infiniband/core/ib_core.ko] undefined!
>
> Before, this was handled implicitly by the dependency on PCI.
> Add an explicit dependency on HAS_DMA to fix this.
>
> Fixes: 931bc0d91639f8fb ("IB: Move PCI dependency from root KConfig to HW's KConfigs")
> Signed-off-by: Geert Uytterhoeven <geert-Td1EMuHUCqxL1ZNQvxDV9g@public.gmane.org>
> ---
>  drivers/infiniband/Kconfig | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>

Thanks,
Reviewed-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

--RzVoCur9CYlE2OzC
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAloTwmkACgkQ5GN7iDZy
WKfcDRAAmIlLoxIlg/niFzfoctxhbI7CDEF8YbXup+YtWKMY358idcxiEJml6dgP
HVPljYAqrftmUkhFVgNoUmYjIwu+vx6BSumE8a1MYNAkqfLp+p3ihVnCIZcOkH27
46ntJ2JSDRBaU+TH1yqCqbUZeUtgCAB9JgNoPVZanQ8qJWRCF5Wl4it4mI/9vBPN
zK141Dtiu+T3urp3Gf1Bff6U7q3q4Zz3SelWJliMC0PjIr0xHxszCHzpY1i23jEJ
Hn5ejOoHQDu7A1PJEgGes5kYdb0BlfaWmWqrnYIbrh0+5Ppt+8OZ7UHP8RofrjTU
m34FLQL9/ctSmFv0vr9BaUSdqWfb4WtIm9VyaKyu0Cb3hnImmDfS9ZEpByN+ZdcN
nUbZZPgVOVqRFbDFqdMjEgeQE4Nl1W9TskP1C4ahCWSYiUMnTq0Pm9B68gzI+hAt
Ln08+GroUVP3Psbmf10/TYmwG3gEbpBVdkahkPcUzsI7fBzDl9AgPz0d/oWC+lNE
GNAAiWecmW8oN4BpkFoFyYqy9/FbQZUUjxV8NcZ9rGgN1Xiz+Iyzcs3noMd9RonD
fVE7U8LRz4OzDkJ+GRiA6o2X+114pPXBvJ3lAPksSJ7/V7Ty0ssc7yCQEKte17Mg
oOJDHCgmAC628IvVThjIcezU5c8a0iyHL91L3/GGsDlGk8CNBIU=
=todi
-----END PGP SIGNATURE-----

--RzVoCur9CYlE2OzC--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
