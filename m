From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] IB/qib: remove duplicate code
Date: Thu, 8 Jun 2017 13:37:48 +0300
Message-ID: <20170608103748.GM1127@mtr-leonro.local>
References: <20170607204202.GA29640@embeddedgus>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="q8dntDJTu318bll0"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170607204202.GA29640@embeddedgus>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Gustavo A. R. Silva" <garsilva-L1vi/lXTdts+Va1GwOuvDg@public.gmane.org>
Cc: Mike Marciniszyn <infinipath-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--q8dntDJTu318bll0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jun 07, 2017 at 03:42:02PM -0500, Gustavo A. R. Silva wrote:
> Remove duplicate code.
>
> Addresses-Coverity-ID: 1226951
> Signed-off-by: Gustavo A. R. Silva <garsilva-L1vi/lXTdts+Va1GwOuvDg@public.gmane.org>
> ---
>  drivers/infiniband/hw/qib/qib_mad.c | 2 --
>  1 file changed, 2 deletions(-)
>

Thanks,
Reviewed-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

--q8dntDJTu318bll0
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlk5KPwACgkQ5GN7iDZy
WKdGQw/8Cw8lmrA4o8BBuzMq91TWcrIgBG23GvaBTjRRJGqgHikBcvv+m2qwFqp0
AXU53G+bLGDJ3+OEKOVIMZkWK5fvO/sskMoMvlC28eE08YbJmdOhNl9ixnXRLeI6
RAnxv6+atYhoivnPYAzb80mi6heviRVgxwB8YTbQQyoKVp6XVsS0thS60dn7iclB
c/ftuDG+HaGphFvtPfGBbWLhbaaWBBaCijJtSVhsUJcFXwtXZK3fKfCjkKqtW6ks
GW2jYkcPZWBlTSKE6eh0mwDRIgz32etfbiznSdleIofTCKBqMukN4J7NbVSnxVAB
AY5dIDlpPEDRW/n96BJllfS9vhnrKTUnNZcuk9+yH0LcDYP6P5TWdRAG8LkrWG4r
4DLKwRC0mmEGhs7eXN2p1do+hfnkTeBSEHSufx4/q+l6k5gzpwkrjdyRsGACdm3D
+85j35LSkNtx+MwcQInc78UdAg76WOk+jInyrlfd9y/Db+bsPrx55hB3f4KpuH5J
RI5/HcWSdUADiXvHdIcum4o2mvbobCyJMfZaptcR1+H40Gt4/eJwRcm8+Htdp7ed
bvWedamRnVvEktTVdaZAQ6hfG8YW2qzUFcnHowq0+8hh+Onc9GJyhTful2VE6JNj
5o4s+kEcN47wz6DihGlBH6eoFup4B9Bg+4tbrub+TgX4ASwoL1g=
=Erqh
-----END PGP SIGNATURE-----

--q8dntDJTu318bll0--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
