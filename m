From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] RDMA/qedr: lower print level of flushed CQEs
Date: Thu, 25 Jan 2018 11:20:12 -0500
Message-ID: <1516897212.27592.132.camel@redhat.com>
References: <1516879400-8000-1-git-send-email-Michal.Kalderon@cavium.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-0Yd5UE0THr83wRukFrBA"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1516879400-8000-1-git-send-email-Michal.Kalderon-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Michal Kalderon <Michal.Kalderon-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ariel Elior <Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--=-0Yd5UE0THr83wRukFrBA
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2018-01-25 at 13:23 +0200, Michal Kalderon wrote:
> There are races where can still get flush on CQEs before the QP enters
> error state. This is not an error and should be treated as
> debug information.
>=20
> Signed-off-by: Michal Kalderon <Michal.Kalderon-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
> Signed-off-by: Ariel Elior <Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>

Thanks, applied.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD
--=-0Yd5UE0THr83wRukFrBA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEErmsb2hIrI7QmWxJ0uCajMw5XL90FAlpqA7wACgkQuCajMw5X
L92Gfg/9GiQ5cLiR9ncuohjvxDaJiDW1E0hI7gGA4r+RDCmBYI5kgFKNK1s1ED4+
odkdvtkHCHHv0ndxVcLZfqD6huzru6huU1dYZK9Ds36hccH5a5OGmT/Zc0b2IHAc
it/gGaOirkFnVpAfEKtolKoHr6rxk1ifg509tcp1DDxq+U8H52e4su1CSlT0I59g
Wn7WT2h4uMHBngXxiOd7ASFjGqey5+cqNa+GDsoUM/1ikO3/kReB1tDY7VRRtGP0
gNNL0iYIycMkVvZh5a0dHO/guh8ZVeo+a/Q95xk6uLMLuOj0mYTWpUC6KbSW3uco
w9GuShYNicwHXr+D7V4sSTNGN4nayLpq0uR4MyL7jSF8ipbWkYNkkVrTcljReIzA
8Ik9ZAw0eBAO2qrrZwleMeoLjT/TwfHpfi9tK4jWh+GVhd+rZseukpt2Zf7IyRYR
Msg/AL4xpJEPvkqx+xPEfDTCADnwPIYI406X7RID+M9a/QXwsM3qMOSm5VRIrmG4
vWn/X6d2jWaNkRauW0QeM0HA8lbpe0O/fueIqF4XIxkx8DMwkWE0yIvx2+yXJzE5
GGsrf45p8ej2QE8aorFddPjwWOvPhBNgjBt+bXx0ZFog8UFTQX58PVkrvZNhO1P4
tARLnM0PYaHaDarsl+nPO59wKuwVSt95X0HkYpnBF6bwgkKXp6k=
=js0g
-----END PGP SIGNATURE-----

--=-0Yd5UE0THr83wRukFrBA--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
