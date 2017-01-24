From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] IB/qib: Remove empty function
Date: Tue, 24 Jan 2017 16:25:42 -0500
Message-ID: <1485293142.43764.77.camel@redhat.com>
References: <20170118055758.27237-1-leon@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-RHdli1UEwS5InXeSc/v9"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170118055758.27237-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Mike Marciniszyn <infinipath-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--=-RHdli1UEwS5InXeSc/v9
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2017-01-18 at 07:57 +0200, Leon Romanovsky wrote:
> Commit f06267104dd9 ("RDMA: Update workqueue usage") removed
> content of qib_qsfp_deinit(...) and left it empty.
>=20
> This patch deletes all leftovers of that function.
>=20
> Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

Thanks, applied to -next area.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
=C2=A0 =C2=A0 GPG KeyID: B826A3330E572FDD
=C2=A0 =C2=A0
Key fingerprint =3D AE6B 1BDA 122B 23B4 265B =C2=A01274 B826 A333 0E57 2FDD

--=-RHdli1UEwS5InXeSc/v9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJYh8ZWAAoJELgmozMOVy/dkrcP/ApBupJDSOCxRtbllAp2r6LF
Bph2GfokFopO0/WDHrRaX4ECbULP5vQAEEFyUkcb89Bg4+JTcCkXJNTwBIdkfyeN
5mrGdoQRzLYNF9xnsJ1kE8nEbFvoWomYpaCOW5H2F0frsMhEpLbNqlAaUdvJa3V2
TgmksdvdzQ4q4x938Rzj4+fdgUrSeyp1jV1zgCjoc289E9XQnapCA5iaPUB/yede
O5dTZO3Z04MxV82sHBwYAX7o97agWC6wUDjfK4mO0z0nGIzbWKuxVM6zYH4pn1Qh
MkeUMX3JBw/sNduu5D4MkHSslySDWvVQao2KtHOoV3Y5T3ELlTbzn18WkyxSuUbX
jzSWixcCxn8B51e2rUBrfQoKMKlyb9sCgWKdjV0/hjdGhD6sv4uAE6WpCZEyDeNb
Orvyydq0LnQj0aowW9cHbPisLYDRn/C9lwREOO64TBdvPVbYeIf760d7192P3iV/
jVUxR2nepiUl81a14f130owsAgFDnyr8ZFluOyHQgWDAJe6iN1KMNpIxwl+o/mYG
//ry1zUIpH/jyZ/f9Y7bfGnndFBbEOUr+peNxgkwqmtNmch7k4oFAdxBp2zgWyIp
taqADP/ZLfzxkRuTQfLnl2WoajMclH4mBWMxf3K9/jYx7C6MiqxfcTjmnjgGazZQ
JuLVngV8JxpFyUtJg+Hx
=VdyJ
-----END PGP SIGNATURE-----

--=-RHdli1UEwS5InXeSc/v9--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
