From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] IB: Move PCI dependency from root KConfig to HW's
 KConfigs
Date: Mon, 26 Jun 2017 13:02:31 +0300
Message-ID: <20170626100231.GC1248@mtr-leonro.local>
References: <20170626085313.6052-1-yuval.shaia@oracle.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="e7WmlSfQJTtHfSol"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170626085313.6052-1-yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, swise-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org, mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, rajesh.borundia-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org, Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--e7WmlSfQJTtHfSol
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jun 26, 2017 at 11:53:13AM +0300, Yuval Shaia wrote:
> No reason to have dependency on PCI for the entire infiniband stack so
> move it to KConfig of only the drivers that actually using PCI.
>
> Signed-off-by: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> ---
>  drivers/infiniband/Kconfig           | 1 -
>  drivers/infiniband/hw/cxgb3/Kconfig  | 1 +
>  drivers/infiniband/hw/cxgb4/Kconfig  | 1 +
>  drivers/infiniband/hw/hfi1/Kconfig   | 1 +
>  drivers/infiniband/hw/i40iw/Kconfig  | 1 +
>  drivers/infiniband/hw/qedr/Kconfig   | 1 +
>  drivers/infiniband/hw/qib/Kconfig    | 1 +
>  drivers/infiniband/sw/rdmavt/Kconfig | 1 +

Why do you need PCI for rdmavt?

>  drivers/infiniband/ulp/ipoib/Kconfig | 1 +
>  9 files changed, 8 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/infiniband/Kconfig b/drivers/infiniband/Kconfig
> index 234fe01..568088a 100644
> --- a/drivers/infiniband/Kconfig
> +++ b/drivers/infiniband/Kconfig
> @@ -1,6 +1,5 @@
>  menuconfig INFINIBAND
>  	tristate "InfiniBand support"
> -	depends on PCI || BROKEN

By the way, do you know why are we dependent on BROKEN?

Thanks

--e7WmlSfQJTtHfSol
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAllQ27cACgkQ5GN7iDZy
WKeypw/9Hbm2pEdNoUT1huFM10FIZTbgLd/cfLFTieoaMENWISCYFhApp9DQ+fJq
cJTcfJUtE2UiMqhkQgm2sBlir/JbS3GiGkK8tgIu5x5mBgsrzW8OplrU9pYjWZOT
xNq1wsbxH007OVFiTekbxLwaXaRJzeJUV7/dtNXnp28VoeBEB9MsTTjTrCbNgB0Y
luhHt6ikUK6Ok/gjpfV32mkdfVjTAn+W5+nUrURfmcjDtBgbxC1Sf+TwM7X+rtxB
UJHANqe28FWOrA/JfxfCOWh/OOS2t7oMJ1EnMnGv7JsUwuX8eFzFyTSVvSI4PWMl
ZGNSFQyiJCkTmaq7QH3ZktkVy4MVxp/ucfYohtfcp6VhC/HuzVGd3I5Wj0z83gx2
mVWPNoTK8x5vJazYIj3XPsrb6qLe9wJGwoii5jam+c0uTYHZdFHicbPLvlQNYNQi
f2GjySwqVDQIc6CUa8fXEzyd3woTn+EcISiYftnxiUfu1OkuNwgo1WgoH+BVKq+q
JcbXzyq/ZGB7wFT6Z/wLHMlL/MTLpdfx8h9fgUbM7f29ARw2C8owfrgXeK8Yf0mX
KkddmPjjhvf5rRv0e4iFWq03s/1FCMy3othodeR8cBztovHBkuGLk9FcYfhx4UZF
q5qJ+00BmGNypyenIgNyVqfdbkZiSdLkOza1aiF1dqFeiczfkG0=
=KAuD
-----END PGP SIGNATURE-----

--e7WmlSfQJTtHfSol--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
