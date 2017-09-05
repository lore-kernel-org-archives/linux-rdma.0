From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v1] IB: Move PCI dependency from root KConfig to HW's
 KConfigs
Date: Tue, 5 Sep 2017 07:08:26 +0300
Message-ID: <20170905040826.GB1070@mtr-leonro.local>
References: <20170904152848.3471-1-yuval.shaia@oracle.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="jho1yZJdad60DJr+"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170904152848.3471-1-yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, swise-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org, mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org, Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--jho1yZJdad60DJr+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Sep 04, 2017 at 06:28:48PM +0300, Yuval Shaia wrote:
> No reason to have dependency on PCI for the entire infiniband stack so
> move it to KConfig of only the drivers that actually using PCI.
>
> Signed-off-by: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> ---
> v0 -> v1:
> 	* As suggested by Thomas Bogendoerfer:
> 		* Remove unneeded header inclusion from ipoib
> 		* Remove PCI dependency from ipoib's Kconfig
> ---
>  drivers/infiniband/Kconfig                | 1 -
>  drivers/infiniband/hw/cxgb3/Kconfig       | 1 +
>  drivers/infiniband/hw/cxgb4/Kconfig       | 1 +
>  drivers/infiniband/hw/hfi1/Kconfig        | 1 +
>  drivers/infiniband/hw/i40iw/Kconfig       | 1 +
>  drivers/infiniband/hw/qedr/Kconfig        | 1 +
>  drivers/infiniband/hw/qib/Kconfig         | 1 +
>  drivers/infiniband/sw/rdmavt/Kconfig      | 1 +
>  drivers/infiniband/ulp/ipoib/ipoib_main.c | 1 -
>  9 files changed, 7 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/infiniband/Kconfig b/drivers/infiniband/Kconfig
> index 234fe01904e7..568088a9298c 100644
> --- a/drivers/infiniband/Kconfig
> +++ b/drivers/infiniband/Kconfig
> @@ -1,6 +1,5 @@
>  menuconfig INFINIBAND
>  	tristate "InfiniBand support"
> -	depends on PCI || BROKEN
>  	depends on HAS_IOMEM
>  	depends on NET
>  	depends on INET
> diff --git a/drivers/infiniband/hw/cxgb3/Kconfig b/drivers/infiniband/hw/cxgb3/Kconfig
> index 2b6352b85485..bd32926afa77 100644
> --- a/drivers/infiniband/hw/cxgb3/Kconfig
> +++ b/drivers/infiniband/hw/cxgb3/Kconfig
> @@ -1,5 +1,6 @@
>  config INFINIBAND_CXGB3
>  	tristate "Chelsio RDMA Driver"
> +	depends on PCI || BROKEN
>  	depends on CHELSIO_T3 && INET

Yuval,
Why do we need to be dependent on CONFIG_BROKEN?
Is it still valid for IB stack?

Thanks,

--jho1yZJdad60DJr+
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlmuIzMACgkQ5GN7iDZy
WKcpFQ/+IpLceODrVYDOPcrf8uzfE/00ZwcidYawummWlbGwLZpkeTBNp2Oda3zc
nsmv3TrbYSaAjgaKfCZ3NQjQ1afsZdF4rQdBrlTif6+aHy/prNjXYHUzfC/xOFnN
k/1Ir7IpPtMvls/O3vL5sjKCryu4F9+JDX5I0bAOrpSRkIxayQk4hFb3ndjD+bwC
sDteOZ75pJqUEEQP4Nt8Fap6QCBs3sAFmVCTfQWVRmmb/v4lOishtJMRXxjkt/AI
njBs0M2XmPxR73ydXrWa/7TUik0B7yQVIH97FE+uz5ddy0wiAZBG825/mgCti1Tq
KbqGuiSazkTGWPiDXNEm9yAQqXdiFoJq5wA/bSAnNfQlNYnPZiz3J4fkIsxN4Ke/
P+iXFCRjIxW73TaYcp2gZ3oiwYsMIZSd6Xq//yc4uwfxaVYDUd00M2zoa9VSeNdP
J1d4cN97625yFMtyA85T7+SkrsGfNceNKmeaic5hRG7NUShP3uWOhhIVvrKP6iwC
xTgxXVvrwP+PJvamvkHXRtkjsfUgx2BNZCxaF6vhjrs8nM1W/G3s2zvpzRJMChs0
JPDpdMXaslLJ/gkhTLvXyUJMxNKnz3UbFFtaO/BxD8LeyiomX6MbQJe+HTAaIXyy
2XmfpyTxZIce+kfktbSsMOB37ObRq5nwk4kdOTDYOQT+8GChN6g=
=k+O9
-----END PGP SIGNATURE-----

--jho1yZJdad60DJr+--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
