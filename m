From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-next V1 2/9] IB/ipoib: Set device connection mode
 only when needed
Date: Thu, 12 Jan 2017 21:25:25 +0200
Message-ID: <20170112192525.GN20392@mtr-leonro.local>
References: <20161228124728.26619-1-leon@kernel.org>
 <20161228124728.26619-3-leon@kernel.org>
 <1484246826.123135.20.camel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="+2GlJm56SCtLHYlr"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1484246826.123135.20.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Feras Daoud <ferasda-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--+2GlJm56SCtLHYlr
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 12, 2017 at 01:47:06PM -0500, Doug Ledford wrote:
> On Wed, 2016-12-28 at 14:47 +0200, Leon Romanovsky wrote:
> > From: Feras Daoud <ferasda-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> >
> > When changing the connection mode, the ipoib_set_mode function
> > did not check if the previous connection mode equals to the
> > new one. This commit adds the required check and return 0 if the new
> > mode equals to the previous one.
> >
> > Fixes: 839fcaba355a ("IPoIB: Connected mode experimental support")
> > Signed-off-by: Feras Daoud <ferasda-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> > Signed-off-by: Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> > Reviewed-by: Alex Vesker <valex-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> > Reviewed-by: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> > Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> > ---
> > =A0drivers/infiniband/ulp/ipoib/ipoib_main.c | 8 ++++++++
> > =A01 file changed, 8 insertions(+)
> >
> > diff --git a/drivers/infiniband/ulp/ipoib/ipoib_main.c
> > b/drivers/infiniband/ulp/ipoib/ipoib_main.c
> > index a550cc6..1787f6b 100644
> > --- a/drivers/infiniband/ulp/ipoib/ipoib_main.c
> > +++ b/drivers/infiniband/ulp/ipoib/ipoib_main.c
> > @@ -474,6 +474,14 @@ int ipoib_set_mode(struct net_device *dev, const
> > char *buf)
> > =A0{
> > =A0	struct ipoib_dev_priv *priv =3D netdev_priv(dev);
> >
> > +	if ((test_bit(IPOIB_FLAG_ADMIN_CM, &priv->flags) &&
> > +	=A0=A0=A0=A0=A0!strcmp(buf, "connected\n")) ||
> > +	=A0=A0=A0=A0=A0(!test_bit(IPOIB_FLAG_ADMIN_CM, &priv->flags) &&
> > +	=A0=A0=A0=A0=A0!strcmp(buf, "datagram\n"))) {
> > +		ipoib_dbg(priv, "already in that mode, goes
> > out.\n");
>
> There is no need for any message here. =A0Nothing unexpected is
> happening.

Right,
Thank you fixing it.

>
> --
> Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> =A0 =A0 GPG KeyID: B826A3330E572FDD
> =A0 =A0
> Key fingerprint =3D AE6B 1BDA 122B 23B4 265B =A01274 B826 A333 0E57 2FDD



--+2GlJm56SCtLHYlr
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlh32CUACgkQ5GN7iDZy
WKdY2hAArZv1n8xTsBstFWE7pTbaydVQZG8hlxEqWGw+fvl+G2O1g6c2imsbKiEK
c6anGJmg8AbFO2NbUtcQMVcAIRrUbUAeBcpuNjKRP4koKlrqksSuco3qqLbrCxio
65+G0DOds859zh0g4lAU7vI9j7/pMbJUCutFx5pQn+FVWsFrF6iZGFz5cVU2PzvN
9l/VUc0aqRPp7JuqjwDfc/AF4YThgFILaRqDLVle6UwwhA4vLaU1AEL4ewmjeqsh
lPp71NIBe9mdd3H7q7qHr6TdO56lYNBM2XMg/nfTBPNCovaP04Iar0SQU8W8ZAwf
F/5EJDM5Y1a87SIOVdMGY+AAFmtaJ8GC31J+5BHf2rLR/3mpN4J2xmfjGLgwZkc3
gNCWbe1YHV9HYuGsyG4V9Y8sxQK8oI00XGcthiMFInwvWNUP2Ss5f/3N0pTdAAmh
ooTTLEYfdaREp8xRAbR7+PkSO7tacT75uaEV28r+B09Cy8BcIzhK81FV8LP1hg46
UUKB0Mf499hJ5jCX8DwkTzvHPnaY9G6NmwMM4DF4rJlyC/0xy04E/OfV7tdgXjZD
Po1mxkgF71XYTkvoioKnU/aqwXp+SYx/MTN4kvyuIdwc4eGqOjl4xG74eUUmMwD0
VMZuFv/mhiqTxRt2zIfZ5+RQmMU5CkcpzadE3g+3dJtBql7YKf8=
=hrUw
-----END PGP SIGNATURE-----

--+2GlJm56SCtLHYlr--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
