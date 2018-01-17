From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-core] cbuild: Add Fedora 27 container
Date: Wed, 17 Jan 2018 10:14:37 -0500
Message-ID: <1516202077.3403.254.camel@redhat.com>
References: <20180112115209.17437-1-leon@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-sZoSYI4bXITDK6ZoA5+X"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180112115209.17437-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--=-sZoSYI4bXITDK6ZoA5+X
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2018-01-12 at 13:52 +0200, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>=20
> Add Fedora 27 to the list of cbuild targets.
>=20
> Signed-off-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> ---
>  buildlib/cbuild | 15 +++++++++++++++
>  1 file changed, 15 insertions(+)
>=20
> diff --git a/buildlib/cbuild b/buildlib/cbuild
> index 3f659bf8..0ef80b60 100755
> --- a/buildlib/cbuild
> +++ b/buildlib/cbuild
> @@ -141,6 +141,20 @@ class fc26(Environment):
>              " ".join(sorted(self.pkgs))));
>          return res;
>=20
> +class fc27(Environment):
> +    docker_parent =3D "fedora:27";
> +    pkgs =3D (centos7.pkgs - {"make"}) | {"ninja-build"};

Is there some reason why are you pulling a fedora:27 container and then
centos packages?



--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD
--=-sZoSYI4bXITDK6ZoA5+X
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEErmsb2hIrI7QmWxJ0uCajMw5XL90FAlpfaF0ACgkQuCajMw5X
L90yPg/+KiNa197YqoIY8/x9GFqDIBapF4frCRqsAqJOqAWvh3i252XeFioj2Sd0
f3EAyCVupS3ZUltc4e7MzG2dTZhMngi5Ru7Z6Vi+9LiRwJhQ3YvEJKOxyREiU/qq
kBtpu1tMhqTAmFJWVma8/8RKw4S7QljZcgU4/HexwNwPK/iMwLkOJ2TuYFyDgPNw
I/WgyPYSpLZ2ujD7afgZlElRLuRmU33ocTFyYJkg0q0gCCUjYKZM6VLhfMD7jVGq
sZFz2VIVLPRofIuKXmK4TFWzM+Q18NofKgDtl3ucYQFZhltXMYSV1QO5aW0lEj2y
6EdwOLFmt7IgfZ+Fm3iCA621OF6grqeuNebkvDMcRrsfksGwO6Rs48HuBLY2Tekt
aHV2l1u2Ydfpe6dhy62W5r4it4r/PzJWokjunOEdNl6XYoLgJUxZi0wNt7WAY3bw
RDd4fvA6irDCZhx+lmNoeADBwA7fD7Lqv31mc1qOvklRsCjA62gHFAD2udwQaBQg
vrvdgih3OQdzqCjwlqCQT6OsN71EfOOTgSgtSPRB2FcaoJngylsFjLwvmbLQt3m0
4sQ+zM5tIO7lG3DIJBNms5BYBRGfbs/SQtoJbCpCgo4IDomqe6AyMhIY2JlG7Vgq
KdZCv4q15x2IbGmSCQggSk3BMLOaWXMhEhheZsyCIzOVgKTAElw=
=KeIg
-----END PGP SIGNATURE-----

--=-sZoSYI4bXITDK6ZoA5+X--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
