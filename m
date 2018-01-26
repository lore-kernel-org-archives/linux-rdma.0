From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH for-next 16/16] IB/ipoib: Fix for potential no-carrier
 state
Date: Fri, 26 Jan 2018 12:09:56 -0500
Message-ID: <1516986596.27592.209.camel@redhat.com>
References: <20180126142640.6868.12402.stgit@scvm10.sc.intel.com>
         <20180126143323.6868.89162.stgit@scvm10.sc.intel.com>
         <1516986011.27592.207.camel@redhat.com> <20180126170610.GD23869@ziepe.ca>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-qujy6zZe3Jjn+ybLyouj"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180126170610.GD23869-uk2M96/98Pc@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Cc: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Alex Estrin <alex.estrin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--=-qujy6zZe3Jjn+ybLyouj
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2018-01-26 at 10:06 -0700, Jason Gunthorpe wrote:
> On Fri, Jan 26, 2018 at 12:00:11PM -0500, Doug Ledford wrote:
>=20
> > device, there is that window from our first ib_query_pkey call until we
> > complete the ib_register_event_handler() call for the pkey to change.=
=20
> > Instead of throwing the flush regardless, it might be nicer to do:
>=20
> Can we move the ib_register_event_handler sooner?

I didn't do a full audit, but I'm not sure it's safe to, simply because
we haven't fully completed our device setup and if our event handler is
live, we can get event triggered activities that might expect everything
to be done.  It would take a complete audit to know for sure.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD
--=-qujy6zZe3Jjn+ybLyouj
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEErmsb2hIrI7QmWxJ0uCajMw5XL90FAlprYOQACgkQuCajMw5X
L910zQ//dDFjy16T35G01Ca0+F6YLWKZE8kIDX/IV602bDkdP/RdNseKfZGI5bT8
1zpoG9X1xBROIYnVIEwh/NoQCGh8XNtv4dnQJD+B203NrtY6K+Aob0+86MdZZFjF
lDZX6xlXf3JFSI6OYtKYqpYBwj5L1nQMBBxOW/zXsRNX3H2R9RvD8d/Jg2q4m1Iu
PaExS8LtquAgGJ5g2eqkfQo0HYPN8pA5BwRjQ+dfiKmcfzSzbSbgrqXS0AGRvYvL
BegkV0bSwnQMrnfoXyRXHUlDxV42Kby6hy8y5Ayu+IcU+AMg+N0NEQWkfwgW6C6W
y/+U4Yj4M9CULoWweeGK0rFmdXYBXZ7/0b/ttWdjU6appKyz2ANje5z+25Ak1UPy
uBtsNXu5qQtaGvU0f2WfaeMLz9DNmeuMNwjXkeXsWHX+VN/qV4rVVrJyEZCCbkft
Sa2BauWFgAGqbNMW4E4KptRRFyZHUeU1POr4iEDmHtQK0zQ44y/jL+MeDBJBLfXy
jhq/8s4xOgKtl8ntgnrNd0A+PLou2c4GnnODCNC33LG1bKHSe+B7xkhuvuKX0lVS
wqE9m+4nBZRgqLL3+N2MWkBnNXpZgkNUhfqSJCdgbz17rzB+3TWptikP3i5NdtiJ
oHJZj+tKmp5pOleDSBTs0fia7vyGl4aiy/8HPXJtEbEJUpFVyvE=
=Z01n
-----END PGP SIGNATURE-----

--=-qujy6zZe3Jjn+ybLyouj--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
