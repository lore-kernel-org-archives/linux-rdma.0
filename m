From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-next] RDMA/umem: Avoid partial declaration of
 non-static function
Date: Fri, 10 Nov 2017 13:02:40 -0500
Message-ID: <1510336960.3735.5.camel@redhat.com>
References: <20171025155649.9089-1-leon@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-bE9LYWmEEpKd4CXOL+Gg"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171025155649.9089-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--=-bE9LYWmEEpKd4CXOL+Gg
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2017-10-25 at 18:56 +0300, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>=20
> The RDMA/umem uses generic RB-trees macros to generate various ib_umem
> access functions. The generation is performed with INTERVAL_TREE_DEFINE
> macro, which allows one of two modes: declare all functions as static or
> declare none of the function to be static.
>=20
> The second mode of operation produces the following sparse errors:
>  drivers/infiniband/core/umem_rbtree.c:69:1:
>         warning: symbol 'rbt_ib_umem_iter_first' was not declared.
>         Should it be static?
>  drivers/infiniband/core/umem_rbtree.c:69:1:
>         warning: symbol 'rbt_ib_umem_iter_next' was not declared.
>         Should it be static?
>=20
> Code relocation together with declaration of such functions to be
> "static" solves the issue.
>=20
> Because there is no need to have separate file for two functions,
> let's consolidate umem_rtree.c and umem_odp.c into one file.
>=20
> Signed-off-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Thanks, applied.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD
--=-bE9LYWmEEpKd4CXOL+Gg
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEErmsb2hIrI7QmWxJ0uCajMw5XL90FAloF6cAACgkQuCajMw5X
L92rhRAAkRypsrmhcF+cL7owr3AQ+oF46Ahf8GhPI4gGWoFTN2na1RVkFVbf7jz9
AZZIzWT+bZDr6AOKyS1XouPJBeyUaWjtJjLVqr39p8dJ6NkTLfUx3XVZOeYBEJ7p
odAKofbG+QZ4V/YRRgsrv+15I0xlBAhSOFATwglte+KhJPxqybxoSgwQq9y0fFhL
YROr0kEbQ8SwbrODj+N4VZO8GUuLFHoHPGULwL0wDtGNWfnitiK85PiU7oTax5pt
zTm7Cy51ngN1d/BNt84Oc/+yRneozFa7t3opKTOA4qk2G6BOWDqGcWApugt60qgs
G528A5CzLAmVJFp631X3YrXSEUJlzSum61fkBvKuDjniPjCF+uWl4Gf0Ii7K6ukf
MYwcl+01y1OVHMScjWOBG0joiuivOAt6+TBXfGPel01NSRze8SRfGHCzRZhexBiZ
GIjpsYr/7uvctw0pv5XDjENyzPxIKFeqt+7QJjs4NZFEnQqauZNlhIdhXkmow1wL
kfGMy0XMxfyO7Qx0sWf+LVsL8ZfhLi/aEagQhrchzKnM9ls5a0iVcADkXYdRTE0m
lquyL0m+ZhdBpalNHB3fmujt8Xre6wi4MhUbKyqAcwUn9l915yizBHnBQCpxx8Uj
FB9oJjnvU0PZUqFJ+yqBZGkjPkDMimDmJOsm/q+Ss+MA4kPOjIk=
=YGUe
-----END PGP SIGNATURE-----

--=-bE9LYWmEEpKd4CXOL+Gg--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
