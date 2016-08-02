From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH for-next 0/2] uverbs and mlx5 fixes for 4.8
Date: Tue, 02 Aug 2016 14:34:28 -0400
Message-ID: <1470162868.18081.28.camel@redhat.com>
References: <1467548899-21923-1-git-send-email-leon@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-92i4DDadGbBfkNKDgzt1"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1467548899-21923-1-git-send-email-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--=-92i4DDadGbBfkNKDgzt1
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, 2016-07-03 at 15:28 +0300, Leon Romanovsky wrote:
> Hi Doug,
>=20
> Here are two more fixes which are queued for 4.8. They apply cleanly
> on top of your k.o/for-4.8 branch.
>=20
> ConnectX-4/Connect-IB fix is marked to be sent to stable.
>=20
> These patches are available in the "topic/fixes-ib-next" branch of
> this git repo:
> git://git.kernel.org/pub/scm/linux/kernel/git/leon/linux-rdma.git
>=20
> Or for browsing:
> https://git.kernel.org/cgit/linux/kernel/git/leon/linux-rdma.git/log/
> ?h=3Dtopic/fixes-ib-next
>=20
> Thanks
>=20
> Jason Gunthorpe (1):
> =C2=A0 IB/uverbs: Fix race between uverbs_close and remove_one
>=20
> Slava Shwartsman (1):
> =C2=A0 IB/mlx5: Fix iteration overrun in GSI qps
>=C2=A0

I applied patch 2/2, I'm waiting on testing confirmation for 1/2.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD

--=-92i4DDadGbBfkNKDgzt1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJXoOe0AAoJELgmozMOVy/dh3kP/3iGyRjEjc0XSiFuiCi9kKgK
ouL8LAhFKelik1W0Gl2RG0pGxSFZvEXifaunEWfdyl9+umlIWHxwH+l821uRU445
Kxkh4O3P1WgI+d723BWhxzcOIP4qwedUou+PaFfvUpgCkYJsItJupQNiT52XH5ZE
0Se3qDOVY8uex+kCEqWdckEXNXHISnUJs54OpM7WVXc89G3DLhU2dAWpK+749aEd
hm1bZcPX9WcAMTTemC3HhvjAozFam2jog/8EMR8ZWbwnFDwRcL6XO1i2iPs9CZc6
C61FuhfAaiLP7Vz8BicD9h6yR8yRX+QfmPZeCJcNOVJmSRDNYyBTHcsg1CXz3pI3
f8+V7Aic+nBkS32icA2Ps5qCRPi94kPkCVgxEQyjtGkLkLlRjDfjnTWn3gVEIpVX
U7ozt3X/O1x5pPJat3qYHwKkehog5+3X8yO5gn7NQQXqVuA5FuUQuz7ynU9TWVlZ
66d00945aAEb3DEtBTlYSDs4sOOGXoCtFuYzDoqeSdOJ82GGy+0izmjEvJ0Mm7xu
IGTgrCyKvL3IyvNYGa7JfgT0bbQ2IMbkc+DwO8dPAowggZGRGlxo7turrWaRhKzv
37G1ytEe5wnCPgOnapwuUiqO1eR1c5mGWKYdBscvVAGhw8wfmVUwjw0QVV54lb5Z
m8VcyTxh4AYIHf2ARERX
=m0iC
-----END PGP SIGNATURE-----

--=-92i4DDadGbBfkNKDgzt1--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
