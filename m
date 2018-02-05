From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-core] build: Pass extra cmake flags
Date: Sun, 04 Feb 2018 20:40:47 -0500
Message-ID: <1517794847.3936.52.camel@redhat.com>
References: <20180201103206.26356-1-leon@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-UVTSnnAXL0GNoytV+n14"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180201103206.26356-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Alaa Hleihel <alaa-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, Nicolas Morey-Chaisemartin <nmoreychaisemartin-l3A5Bk7waGM@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--=-UVTSnnAXL0GNoytV+n14
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2018-02-01 at 12:32 +0200, Leon Romanovsky wrote:
> From: Alaa Hleihel <alaa-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>=20
> Add ability to provide extra cmake flags when building library
> and when creating RPMs or DEBs using EXTRA_CMAKE_FLAGS.
>=20
> Set an environment variable prior execution to provide
> this information to build scripts:
> export EXTRA_CMAKE_FLAGS=3D"<flags>"
>=20
> Cc: Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
> Cc: Nicolas Morey-Chaisemartin <nmoreychaisemartin-l3A5Bk7waGM@public.gmane.org>
> Signed-off-by: Alaa Hleihel <alaa-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

Tested as best I could locally then applied, thanks.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD
--=-UVTSnnAXL0GNoytV+n14
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEErmsb2hIrI7QmWxJ0uCajMw5XL90FAlp3th8ACgkQuCajMw5X
L90YbQ//TRUZfBC8FVriICHxTLTY8HFPCJReYw2v6ybTRizyUYtrT7KKy0H0JCRj
hAkNX1e0nPxYQo9P4A0/orUeSp0leP8VP+RNaerAjH96zEN77Lz0witr7fReYBia
4B1URcUp9q9b+VkvQuTcFucN9lARTcC7serq/xZjkBt45guN0vG+bUGFMDRllaC0
bupWlLFhGF70A1oDsN00f1jFpdPYiBlsqJTcQxwTOkyJg9xWgJ2z0Driy7IS4WLn
hbbDvjnESgqqyn+2u+hrF/whqDh7+qzcezlJ253tisB6SHPbVifhcpC6slLzgtp1
hC5vWc4fAPnTFT+Uj45YI2i1d8TJey0BXbGQKAf27x0JvOIK+nchIuWhh2xzHHZN
rIESbB/nF6MCR8lpP009sn5w3IfXjQGyfYIlL6re1d+NHUIGktXq+CFbBJ51xWXU
v12ltg877sc1eOAz0dnOLPqPFwc7SowPfkdZzR+4QfZnBvFLdbkHUt/df6NLCSd0
iaaZdfpZZNF32UhwWmB4c7s/YT4qTQejSGQ4PloJq0rngKhYJkXzL9LeGLLsHKqU
9Ki+oBMaTwwX2yPwjbQQ5WfAwejwZ2LRkmiLQLjotf/gyIijCiRyD7/AKb7sHNf6
cJ53fhDRWjsXHD2eq1mXA2nL4fHZHiMSuyjT/98v5Z5HP5JN9Hw=
=0jAH
-----END PGP SIGNATURE-----

--=-UVTSnnAXL0GNoytV+n14--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
