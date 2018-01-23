From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] librdmacm: Set errno correctly if status is positive
Date: Tue, 23 Jan 2018 12:02:19 -0500
Message-ID: <1516726939.27592.42.camel@redhat.com>
References: <20180110160721.14469-1-yuval.shaia@oracle.com>
         <20180110182932.GJ4518@ziepe.ca> <20180110183318.GA14534@yuvallap>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-8pqEonU2b912mRvJrwE5"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180110183318.GA14534@yuvallap>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Cc: leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--=-8pqEonU2b912mRvJrwE5
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2018-01-10 at 20:33 +0200, Yuval Shaia wrote:
> On Wed, Jan 10, 2018 at 11:29:32AM -0700, Jason Gunthorpe wrote:
> > On Wed, Jan 10, 2018 at 06:07:21PM +0200, Yuval Shaia wrote:
> > > No need to convert to positive if status is already positive.
> > >=20
> > > Fixes: 1ef5c3a84 ("librdmacm: Set errno correctly in ucma_complete")
> > >=20
> > > Signed-off-by: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> > >  librdmacm/cma.c | 2 +-
> > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > >=20
> > > diff --git a/librdmacm/cma.c b/librdmacm/cma.c
> > > index 25ebaaee..fb2dc5e4 100644
> > > +++ b/librdmacm/cma.c
> > > @@ -866,7 +866,7 @@ int ucma_complete(struct rdma_cm_id *id)
> > >  		else if (id_priv->id.event->status < 0)
> > >  			ret =3D ERR(-id_priv->id.event->status);
> > >  		else
> > > -			ret =3D ERR(-id_priv->id.event->status);
> > > +			ret =3D ERR(id_priv->id.event->status);
> >=20
> > This code hurts my brain - why is status sometimes a possitive errno
> > and sometimes a negative errno?
>=20
> Have no idea :)
> But since current code ask "if (id_priv->id.event->status < 0)" i assume =
it
> can.

Since this item covers the entire gamut of events, I wouldn't be
surprised if there are some events defined with negative returns and
some with positive returns.  Anyway, an audit of all the returns is more
than I want to do just for this patch (and I did a quick look through in
the kernel to see if the answer to this is easy to get to and
unfortunately it's not because of how many places you need to track down
the treatment of the status item), so I'll apply it as is.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD
--=-8pqEonU2b912mRvJrwE5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEErmsb2hIrI7QmWxJ0uCajMw5XL90FAlpnapsACgkQuCajMw5X
L91KSw//eTX77ua+VaIDLTuo8bqBLKtV1oUVjdAU8McMdO6oaumnXi+ZRf8I0Xss
7B/PbFj4XJunZufuEWUdOFwPaMOVOlEShjMQGmyU5n4lH3DqpVFZ/R4Uh5FqVqXH
bDHDxpP42Xt32VVhzhJS01kSsbwRFjAnvd9Ua23q+sbCID8vmkllZQAdWvktxiFt
QsCWfpziLC3o9T2r/h2WJVoZg+S8NERx33UywCQ3HfTHt96oskGkDRwiWtcDc2/7
vnYFBZQsPjY7HPdh6ffhAras5N98wBacDUY+Vxm27Qsoy17XfDykORykLdtoMV2S
IFMZklTc8XByi/p7e6GbyZDRtf8lkZegSQxFYDAFgmu6WLgXHKJ5YlQP4sLnmCAU
oa+tnfkBilByVTg8UNTwFIVjU82dz7ORm6OQ95puVwrdvghW5krS6PqtTkkx30ok
zyt1RcEfBCWb4dT/h0xxHnb9w7BO+qzgHFeDIpUtifKZqusOSTbYDecHol42BZzJ
14U0jJATBTwkyumna+zqjsOF/dWMM4LuxjuzNOg9Nk2v8HExOdSia9FXuOfbX4OZ
lrZwpnSO+vO+bzfsq6QxYtiFNdrnsnBPkAFJNFAvlCNG6MkGsHOzvtaPYx3BtDnP
lYwo+2xMG8ALjOKBGqoWwsQf9N4voEDTd3NNVajxqY4ubt1LWHE=
=NV3Q
-----END PGP SIGNATURE-----

--=-8pqEonU2b912mRvJrwE5--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
