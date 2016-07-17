From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] IB/iopib: Report SG feature regardless of HW UD CSUM
 capability
Date: Sun, 17 Jul 2016 16:54:45 +0300
Message-ID: <20160717135445.GB20674@leon.nu>
References: <1468753728-13369-1-git-send-email-yuval.shaia@oracle.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="BwCQnh7xodEAoBMC"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1468753728-13369-1-git-send-email-yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--BwCQnh7xodEAoBMC
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Jul 17, 2016 at 04:08:48AM -0700, Yuval Shaia wrote:
> Decouple SG support from HW ability to do UD checksum.
> This coupling is for historical reasons and removed with commit
> ec5f06156423 ("net: Kill link between CSUM and SG features.")
>=20
> Signed-off-by: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> ---
>  drivers/infiniband/ulp/ipoib/ipoib_main.c |    5 +++--
>  1 files changed, 3 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/infiniband/ulp/ipoib/ipoib_main.c b/drivers/infiniba=
nd/ulp/ipoib/ipoib_main.c
> index 5f58c41..119790c 100644
> --- a/drivers/infiniband/ulp/ipoib/ipoib_main.c
> +++ b/drivers/infiniband/ulp/ipoib/ipoib_main.c
> @@ -1967,8 +1967,7 @@ int ipoib_set_dev_features(struct ipoib_dev_priv *p=
riv, struct ib_device *hca)
>  	priv->hca_caps =3D hca->attrs.device_cap_flags;
> =20
>  	if (priv->hca_caps & IB_DEVICE_UD_IP_CSUM) {
> -		priv->dev->hw_features =3D NETIF_F_SG |
> -			NETIF_F_IP_CSUM | NETIF_F_RXCSUM;
> +		priv->dev->hw_features =3D NETIF_F_IP_CSUM | NETIF_F_RXCSUM;
> =20
>  		if (priv->hca_caps & IB_DEVICE_UD_TSO)
>  			priv->dev->hw_features |=3D NETIF_F_TSO;
> @@ -1976,6 +1975,8 @@ int ipoib_set_dev_features(struct ipoib_dev_priv *p=
riv, struct ib_device *hca)
>  		priv->dev->features |=3D priv->dev->hw_features;
>  	}
> =20
> +	priv->dev->features |=3D NETIF_F_SG;
> +

I don't know about it for sure, but maybe the more appropriate place
to place it will be in ipoib_setup() function?

1764         dev->features            =3D (NETIF_F_VLAN_CHALLENGED     |
1765                                     NETIF_F_HIGHDMA);

What do you think?

>  	return 0;
>  }
> =20
> --=20
> 1.7.1
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--BwCQnh7xodEAoBMC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXi44lAAoJEORje4g2clin/5kP/RMmokU+2fj+s0ZkkrGCcrLt
iNfDQEVkhmi29VWjAcrmF68Nw5wPHQqDyKNzKaPa3Y1vQ7KBfc2nbTI7FnGa9eib
v2PcOe6lj6ebDKVPPW7SvcZIjfvbbhSW62IevLt9IHGOgG0oYgungxXL/XgcOrBJ
1b+CsQOWuJpVA16/ephDyge8+jaDLWh2OJGnpIQ80KQG0RY8mVGk20dLqtWJ+Xri
oU7ZlV7mJ3DCPtgpNWV+8J5eTOpROZ17UcWZuesriZUVXVKNDkMCGPyYDcjIbBcT
pAcUrAdORmgBU1XtZroxPrZIyh3ROqO+lS5zv3FWsH9kJE3vvlsLOKZsJ7AoDNiB
YpT/TaM/EzmzzmgU+onJDYHU8/QkqLcTtFNjrgp9sXacp+xSslJKtaOBBHGHrW3P
VdoR+pcNmdMcdeFtkDLzQPwFrCyMmGflKeAjgSclGSBczPD/IPTsqm22QWqQ435j
Gxfx2d+oqdoY2CjRxgUXOmiaN2uGB2kWshtvWY5xqSlAMOuvbRw8IUuePRW/lXq3
IzqnNf577xbjVGFnSae+WAHo8Blfn1vf/9ULst3Zt2jcrZi2tgGPSE1N9U7LT6FF
aX7d12lmOrhMXgntjcC1BTdtJn6NmNjDQPdfqKEDpJWMiK0htf++XwrmOe1mMiEh
/D/QOLyB3/g3i7GafgCG
=rPeY
-----END PGP SIGNATURE-----

--BwCQnh7xodEAoBMC--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
