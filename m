From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-next v2 0/7] Expose CQ moderation to user space
Date: Mon, 13 Nov 2017 17:01:01 -0500
Message-ID: <1510610461.3735.47.camel@redhat.com>
References: <20171113085119.1705-1-leon@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-0H0q/DOkh2TYl2nzh3k4"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171113085119.1705-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--=-0H0q/DOkh2TYl2nzh3k4
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2017-11-13 at 10:51 +0200, Leon Romanovsky wrote:
> Changelog:
> v1->v2:
>  * Replaced word cookie to be CQE in commit messages.
>  * Added patch to rename ib_modify_cq() to be rdma_set_moderation()
> v0->v1:
>  * Dropped comp_mask, there is already attr_mask
>  * Put CQ moderartion into special struct instead of general struct
>  * ib_uverbs_ex_modify_cq
>=20
> -------------------------------------------------------------------------=
-----
> This patch set exposes CQ moderation. This will allow to moderate
> number of CQEs needed to create an event. Such change brings performance
> improvement by reducing pressure on application to receive event per-CQE.
>=20
> The proposed semantics follows the well-established kernel semantics.
>   * cq_max_count - defines the number of cookies needed to create an even=
t.                                                                         =
                   * cq_period    - defines the timeout between last event =
and a new one
>                    that will occur even if cq_max_count was not reached
>=20
> The patches are available in the git repository at:
>   git.kernel.org/pub/scm/linux/kernel/git/leon/linux-rdma.git tags/rdma-n=
ext-2017-11-13
>=20
>         Thanks
> ---------------------------------------

Thanks, applied.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD
--=-0H0q/DOkh2TYl2nzh3k4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEErmsb2hIrI7QmWxJ0uCajMw5XL90FAloKFh0ACgkQuCajMw5X
L91YaxAAtiWFcg3SFxXrwa7shkWZmkhBTwLT6PZ1dsJBplHYTdyDfC1SIxBqN4dK
bvEF++iMHuQiRyfMh+DwkJwBcLxF3OKhMKPOjW2N+OMFMqtPjPvkCewSV/rr72Yo
Muj2fg1FZnXg93ymaO4RsCvbC0JqJWIjU3ZpiCED1bBdeu95WvwkaCE/jPwRUkzu
YgLOWn6VRXH3bwD+c5XgIVKLRgRw40kf2RtaCiAurWwmbrRDNoM1wmg3kJ7xGAbh
sCDQh6LP4l8wz1th0uv70uD9yR7SvSH3M5bSNwQwMGdAsALyszV0MwnWJmyP6ahF
/5e86qOgWLDG7kdZjYoJJ+fPu/43pdIyomhGlE3reR30sj5R2CMTg2tYcmszTpk0
J0YKL3Xx1V46sI3nUUqqQrpae0uPO7KUCj/MrBl2Z8sXDbE6oV4FOGA62sK46TgH
4DX5lXCV61nX/CY4uDm0V1WrBswEEJRw/HOgYfnU7DME9sBySF4Tm8WTDN5sUwpz
3afA8oj1yccmJqySKu91RqJjP9CMQeB7oZnDRSVXIzLyDQ8rFVT/qr7wgtHyC+bO
w7IrGNQ1qDwCuSkqyso/rm2aWgiO3Zyzs7hpcb4csx3/zRzrarZ9iT7Ylvxid3dE
IiHWqbSDMNzthoWQAn9vY3oJYVVXzBwmmVAz2ZQtOeujNSK2kHo=
=iKDY
-----END PGP SIGNATURE-----

--=-0H0q/DOkh2TYl2nzh3k4--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
