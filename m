From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 0/2] IB/core: introduce ib_mtu_int_to_enum
Date: Tue, 24 Jan 2017 15:10:17 -0500
Message-ID: <1485288617.43764.61.camel@redhat.com>
References: <1482734458-32131-1-git-send-email-Ram.Amrani@cavium.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-JqQUV6XW3HYn1Ry66DOY"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1482734458-32131-1-git-send-email-Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ram Amrani <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Cc: Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org, Michal.Kalderon-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--=-JqQUV6XW3HYn1Ry66DOY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2016-12-26 at 08:40 +0200, Ram Amrani wrote:
> As the functionality to convert the MTU from a number to enum_ib_mtu
> is ubiquitous, define a dedicated function and remove the duplicated
> code (first patch).
> Note that the patch doesn't include ocrdma, qib and hfi1 that check
> for an exact match of the int mtu and return a different default
> value
> (or error). I leave it to them to adapt to the new function, if at
> all.
>=20
> The second patch fixes a qedr bug using the newly introduced
> function.
>=20
> Ram Amrani (2):
> =C2=A0 IB/core: add the function ib_mtu_int_to_enum
> =C2=A0 qedr: fix MTU returned from QP query
>=20
> =C2=A0drivers/infiniband/hw/cxgb3/iwch_provider.c | 11 +----------
> =C2=A0drivers/infiniband/hw/cxgb4/provider.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0| 11 +----------
> =C2=A0drivers/infiniband/hw/i40iw/i40iw_verbs.c=C2=A0=C2=A0=C2=A0| 11 +--=
--------
> =C2=A0drivers/infiniband/hw/nes/nes_verbs.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0| 12 +-----------
> =C2=A0drivers/infiniband/hw/qedr/verbs.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0|=C2=A0=C2=A02 +-
> =C2=A0include/rdma/ib_verbs.h=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0| 15 +++++++++++++++
> =C2=A06 files changed, 20 insertions(+), 42 deletions(-)

Thanks, series applied.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
=C2=A0 =C2=A0 GPG KeyID: B826A3330E572FDD
=C2=A0 =C2=A0
Key fingerprint =3D AE6B 1BDA 122B 23B4 265B =C2=A01274 B826 A333 0E57 2FDD

--=-JqQUV6XW3HYn1Ry66DOY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJYh7SpAAoJELgmozMOVy/dJlsQAIjwtB2sZVge0+BSc1695/M3
yTBkn55Ki3uB67s8aX05692yDtNjhRVzns6Qz1YwKwIfF6WL7NipIRuq+44spb7V
HBBvxMOOBpcKt9eZ5r4IrWdB4YWt9AbiBFSCU/NZFix0rBkEgMjYtvnqZGQecxJe
1lhrP2cjdooXYALQOmmMAoBiKEVwn9womwmUEMY/0jkGvaAaCwVxhLMqmW8RPLI5
jvot30UIKm/Vxd9dXqkzjnDRd2LDgOH/Gd3tjZaBQzp+KZ6e8vLkrknvzuJwwUaT
JCUotnMZJrBAwUqhGzJlZOTzKpfXUqfeMF1cGPxN7RDqYBwWODOdcM3D9unyB5Yp
O9UueMYRJ9kkUz1WOntx/QsMZX8HNk1hSC5+LkEkQu8lJFbuOuq2TIx8hdNldpLU
RBKUNIFav+2b7BhgzOKlbiM5+zK6iYIwT4Twe6k2sq1udfZps/ck8OzDFGRYX0IE
BD/ZbzR7m1l8zUWqra9e/8XdUgc6zT6NYJoZbVZsO7sKYjAxPnS4c64wuArIs1SM
IyvCygVn0baWr8oAajPIUeFNjez6HzjQIYFwcOWfHsf+sDFVuX5e5vUfv9kK7zL2
vUdRje8AxsRbdOLAmKHdehc0Ccj+mGOiKWUYEyy8b4QMU0jG4zkvGRSa/TpynBdl
mokOtIayIR2IMV3FBVgx
=14p4
-----END PGP SIGNATURE-----

--=-JqQUV6XW3HYn1Ry66DOY--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
