From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 0/2] iw_cxgb4 fixes for 4.8
Date: Tue, 02 Aug 2016 13:23:41 -0400
Message-ID: <1470158621.18081.16.camel@redhat.com>
References: <cover.1469824142.git.swise@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-R9Am7riep31FSi+j8L/g"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1469824142.git.swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--=-R9Am7riep31FSi+j8L/g
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2016-07-29 at 13:29 -0700, Steve Wise wrote:
> Hey Doug, here are few iw_cxgb4 fixes that I would
> like to hit 4.8.
>=20
> Thanks,
>=20
> Steve.
> ---
>=20
> Steve Wise (2):
> =C2=A0 iw_cxgb4: stop MPA_REPLY timer when disconnecting
> =C2=A0 iw_cxgb4: explicitly move the qp to ERROR state during flush
>=20
> =C2=A0drivers/infiniband/hw/cxgb4/cm.c | 12 +++++++++++-
> =C2=A0drivers/infiniband/hw/cxgb4/qp.c |=C2=A0=C2=A09 +++++++++
> =C2=A02 files changed, 20 insertions(+), 1 deletion(-)
>=20

Series applied, thanks.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD

--=-R9Am7riep31FSi+j8L/g
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJXoNcdAAoJELgmozMOVy/dgZgQALxCKamBHtxB9Tf/+um2QkmS
73Bo/ehh4v+HvyfzPBh5q+ojpcSMdSKa4nU9PX+y8JSGq8LXrFW0CiP+S7ykg6CZ
o3cmcXby2zJxOAF+SeHfk3oVA5fyuLLLbX1hv8QLH9+uzy20XaBml0yWICjYKulf
uT1gYocYF8RSObfFy0TQnxQJzqpFjcpGRxzQDjiyqN6/yziI3mIX9eG9EhS0XHv9
+rJ9AP4e8tT65LvDVfjRi9G6vAycE4lsS21yxo7C+lGtAmRff7OutaO+GdBeDfKh
A5KzSkYLl1MPJ/5bIlbxwOim0g07VSa3zBB62PW7xHborGB7kwcNC0OMux229Ggo
Qbj1kWEw2N7Gm+yXY31C+OlVHXIokqbdIgrzVf3cWGY2qWgG4caxcIGnXdot8E78
CuaJSg56Y+0/QORxRauJvhjUAtoXq6c6zc5liC0AAQQzSLicwEIInNYgEIuOQQyq
uMDcy+tzu4IIQTdGBQETifKjxquMmxI6vPgsehGJ5BSoJAsPFhYHh4t/MFvYM9BB
iJw+pIy2b9dMr3r+yFgaB2xY3V3a8uy1Tdnx9SI3fTw5kGv7dWJZ8BY4fUL4OpiD
PNw4v/myKgegAfhXwX/JdvnQAOlngwAGuPNC/EKPkubFNnAPDT1wQOTN8rXmoRDP
10CzbcGKTL+nF0yVFYvj
=SDEu
-----END PGP SIGNATURE-----

--=-R9Am7riep31FSi+j8L/g--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
