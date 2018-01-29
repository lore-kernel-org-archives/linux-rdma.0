From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-next v7 0/8] RDMA resource tracking
Date: Mon, 29 Jan 2018 15:11:53 -0500
Message-ID: <1517256713.27592.241.camel@redhat.com>
References: <20180128091725.13103-1-leon@kernel.org>
         <20180128210520.GK23869@ziepe.ca>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-PypzWM4XRZcngEQ039So"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180128210520.GK23869-uk2M96/98Pc@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--=-PypzWM4XRZcngEQ039So
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, 2018-01-28 at 14:05 -0700, Jason Gunthorpe wrote:
> On Sun, Jan 28, 2018 at 11:17:17AM +0200, Leon Romanovsky wrote:
>=20
> > The original goal of this series was to allow ability to view connectio=
n
> > (QP) information about running processes, however I used this opportuni=
ty and
> > created common infrastructure to track and report various resources. Th=
e report
> > part is implemented in netlink (nldev), but smart ULPs can now create
> > advanced usage models based on device utilization.
> >=20
> > The current implementation relies on one lock per-object per-device, so
> > creation/destroying of various objects (CQ, PD, e.t.c) on various or th=
e
> > same devices doesn't interfere each with another.
> >=20
> > The data protection is performed with SRCU and its reader-writer model
> > ensures that resource won't be destroyed till readers will finish their
> > work.
>=20
> Well, this cover letter isn't quite right anymore.. but no matter.
>=20
> My small comments aside it looks OK to me.

Likewise.  I'm happy with it at this point.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD
--=-PypzWM4XRZcngEQ039So
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEErmsb2hIrI7QmWxJ0uCajMw5XL90FAlpvgAkACgkQuCajMw5X
L91R2Q//V2INZn+nWRakP/nBrhOVYj6w3ni+RcCTQaUXdGOzwp16i2Xhjqn0X6Ro
LzfCQfwAOPS4f4ZM8S106nDo5H1l80ha9TP5qP3N4ZIdukxwd4sKi97rCgKFanJs
mJlFuXDmh1nmvyIJdD4mRJLV+imA1gStWvXisCmAimIv9YFg97voxFuWNR9KSeU5
n9qCni5NvflXBJCVeJugmhvDvlYMSb33UZJmjye5NHF5IhkmsF0ETUTwxm3g16S4
8oBu+bpDJ/OdmIT3ecSrmFCVKA9J0R+zinK18nFNeR+UZh8jAFarJrMv3euJ1yHY
EII81XOYUbMVoRMdCkff1vWPJH8DksekrUMDET2G88msmYJWm6Vztk/BhltvifST
6xy4bPoZpz2rdqZCXismfXh4q8Qm7NP2MVdDX/Pf8JpstuLnUavxnVynqwIMJYhU
X9SsJiLYXU7SyST3sc3lW/ql8K9NgOmNqqaA5FPnlujgm1ct+P25Qm4eVqm483fh
WbqXLZg3uf9xZa5zd4kNaZVRCPAIAKbz+ikBil62c3rU+VBzHQcH6LTXqpWSNnZR
v85vQz3g3k0lyq0iwVdjmXK3j19Z4p+d/g4cFNR917nQeXMOR4GUlO/9Ub6eiTcA
S8BWDFIuwSBVBLb7mz6tSBzKRkWP4NOjD5WqHQ9a543O0RiXr4w=
=p3UI
-----END PGP SIGNATURE-----

--=-PypzWM4XRZcngEQ039So--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
