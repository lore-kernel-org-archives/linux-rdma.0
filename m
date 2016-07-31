From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 02/28] IB/hfi1: Fix to fully initialize send context area
Date: Sun, 31 Jul 2016 09:53:31 +0300
Message-ID: <20160731065331.GY4628@leon.nu>
References: <20160725203554.4800.37248.stgit@scvm10.sc.intel.com>
 <20160725203759.4800.2358.stgit@scvm10.sc.intel.com>
 <20160726052657.GD20674@leon.nu>
 <20160728163209.GA28030@phlsvsds.ph.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="BERr2LqgA7m/bZG/"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160728163209.GA28030-W4f6Xiosr+yv7QzWx2u06xL4W9x8LtSr@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "ira.weiny" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tymoteusz Kielan <tymoteusz.kielan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Andrzej Kacprowski <andrzej.kacprowski-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--BERr2LqgA7m/bZG/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 28, 2016 at 12:32:09PM -0400, ira.weiny wrote:
> On Tue, Jul 26, 2016 at 08:26:57AM +0300, Leon Romanovsky wrote:
> > On Mon, Jul 25, 2016 at 01:38:01PM -0700, Dennis Dalessandro wrote:
> > > From: Tymoteusz Kielan <tymoteusz.kielan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > >=20
> > > =20
> > > -	dd->kernel_send_context =3D kmalloc_node(dd->num_send_contexts *
> > > +	dd->kernel_send_context =3D kzalloc_node(dd->num_send_contexts *
> > >  					sizeof(struct send_context *),
> > >  					GFP_KERNEL, dd->node);
> >=20
> > Dennis,
> > Don't you want to check kzalloc_node execution success
> > prior to use dd->kernel_send_context?
>=20
> Again thanks for catching this.  Follow on fix was sent which depends on =
this
> patch.

No problem.

>=20
> Thanks,
> Ira
>=20
> >=20
> > >  	dd->kernel_send_context[0] =3D dd->vld[15].sc;
> > >=20
> > > --
> > > To unsubscribe from this list: send the line "unsubscribe linux-rdma"=
 in
> > > the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--BERr2LqgA7m/bZG/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXnaBrAAoJEORje4g2clin9C8P/3+OUojzTvb66DYNPTB0ZRCj
V6/sIujKWBzk6hbkuugCz/liStESAox9pTuFz2rw5QjOruWJlRpSIfWJhgMgHxKE
psdcdV0ZMrFKDsbvlhT1OzvmnJ7UVQco+K2TtOBMYTQm6TpilMr8/zlxsaQgM1Nx
bF4FjJyop7ylu/1ag1ELhU3wNv/QL9YMOkpmjpE3kX5zOV2qVgvBszyUmuxxWibN
hDJMY3TpDdj2TnPxkcyJ7B1sBhRsCnuaFp4I6MtyvBKWTv1B0vORaTmKVnr7UV3Y
ibA+Cy2Kx4MknhUNVK1XOX3DZJzLlnHVCxVjdaheFWsYB/piv7OwKH2DkIHtwNBC
qT6D5hTufNLjmS1OtmuSkBG/tAbDww12Xz48X9xvtv0tGIl49Gv7bNAiWS/Z2BSR
iL2Brpfm+2lftWpiM+yVCHax4DCMAJ3UEsbkELmKQKJhZznwwLThoiBoQc7fDI3P
AWyqVAR+Kk9y3ktuZfQJ8q2z05T9JlHJVeS11f8A3MGgYKdpg+PAqYjxpa1vEPuX
ATo1RPu/FrHpSn19gJueuaThwmZxY8el2bs06BcpEWpE+HFW/9SYN4zvxHbddIKi
A4FbjQDjusB2qjOK/qfdZWx9TzvMFzPSIjsnk6TGO5Be+3Rt4CWQEygFduXxyyma
nbeR99itZth/j8SfzqIg
=/HMl
-----END PGP SIGNATURE-----

--BERr2LqgA7m/bZG/--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
