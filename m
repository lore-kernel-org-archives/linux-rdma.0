From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH V1 for-next 1/2] IB/core: Report LSO capabilities when
 querying device
Date: Mon, 9 May 2016 22:16:13 +0300
Message-ID: <20160509191613.GS29160@leon.nu>
References: <1828884A29C6694DAF28B7E6B8A82373AB04816A@ORSMSX109.amr.corp.intel.com>
 <20160502190619.GB32613@obsidianresearch.com>
 <1828884A29C6694DAF28B7E6B8A82373AB048E47@ORSMSX109.amr.corp.intel.com>
 <20160504181135.GA15355@obsidianresearch.com>
 <21d9307f-766e-9aaa-54d3-207a4a4d5d8c@mellanox.com>
 <20160505181423.GB5957@obsidianresearch.com>
 <alpine.DEB.2.20.1605052116570.1091@east.gentwo.org>
 <20160506225523.GA21309@obsidianresearch.com>
 <alpine.DEB.2.20.1605090926440.6128@east.gentwo.org>
 <20160509163537.GA15479@obsidianresearch.com>
Reply-To: leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Y51z1SGMnxVzkhDv"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160509163537.GA15479-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Bodong Wang <bodong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--Y51z1SGMnxVzkhDv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, May 09, 2016 at 10:35:37AM -0600, Jason Gunthorpe wrote:
> On Mon, May 09, 2016 at 09:27:32AM -0500, Christoph Lameter wrote:
> > On Fri, 6 May 2016, Jason Gunthorpe wrote:
> >=20
> > > > > This is where I get upset with the process we are following here,
> > > > > without input from other hardware architects in other companies,
> > > > > it is hard to design something truly common.
> > > >
> > > > Presumably the other vendors are listening in on this conversation.=
 The
> > > > lack of alternate proposals and objections by them has often been
> > > > considered silent approval in the past.
> > >
> > > I know the various hardware architects that would be involved with a
> > > IBTA process/etc do not monitor this list.
> >=20
> > An IBTA process? How would that be relevant here?
>=20
> What do you mean? IBTA is the only multi-vendor body left working on
> standardizing the hardware specification for verbs.
>=20
> These various recent patches are adding new hardware features to
> verbs.

These patches are exporting hardware capabilities and not "adding new
hardware features".

>=20
> If you want hardware knowledgeable people to help, then you need to go
> to the forums they are active in.

It doesn't make sense to look after these people who have no interest in
linux RDMA at all.

--Y51z1SGMnxVzkhDv
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXMOH8AAoJEORje4g2clin7Y0QAJHMLdOebmTrxciOteDvL2my
4+YfSCFmqR1ekSqajyg/kYGI2hCdd8cdRxXbujuIe2pwukVuWjlslVUA/e4jO7mS
EjxwsBrGRJkpKaUomz5bWwZeknLo2MTGFS3p4pfC9hAYaSLseU9i3qrctKc8v2pC
z9zqFPS7FC/SID6ouCxbliH4Cq55UoNBfTYJWIcNZcmIX3vkurp+XdI74Nux0rg7
BxddACUkybrxN+PaAVLeTQHNC3zEAOsevLUr69/GUnIZPdziASJjy1SUoIWwIXtu
bxgUDvWLeoTu2ZTzq2oMRa84B5pd6UEuUvMQUTJ4wtSxC+c9lbDqudiuUO9oWwNW
AXXiWK6JV1uIF/hzrmxhTkkWRFAJcd44onzLu7v1Gy+43HxHDm84L0peJU+RcNAk
EFFglol1TFkDl5QGmhsgIFCIFhHjo90pv14cWFlGBPHVGLxs0ppjCZH25P/s0n9y
vVS6t2nxJAaZMct2RMHAJF+4a61RP3uQgOeJu3nR1m8gOjbgUlsmC7axvBCnip+G
HbWwiq8p8cPNGhwsvXusnNExas+EQv5PFGgFqdjeHyrUpiNbCQx1SecBPQpBD4Wx
WgLktTeN1lM7WQZM6IiWHX1m3b/bwnpaQTzzaFF+U/n7sAORkj1rvQ5bluPURPh6
4V/dUFarWckCgutsn8Hv
=PPsy
-----END PGP SIGNATURE-----

--Y51z1SGMnxVzkhDv--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
