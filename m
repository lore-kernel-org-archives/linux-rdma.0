From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-next] IB/mlx5: Fix configuration of port
 capabilities
Date: Tue, 14 Feb 2017 13:41:56 -0500
Message-ID: <1487097716.86943.85.camel@redhat.com>
References: <20170214052538.16562-1-leon@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-GW6mYLb4e1t1fofVOJF3"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170214052538.16562-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--=-GW6mYLb4e1t1fofVOJF3
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2017-02-14 at 07:25 +0200, Leon Romanovsky wrote:
> From: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>=20
> When the "ib_virt" cap it set, configuration of port capabilities
> need
> to be done through mlx5_core_modify_hca_vport_context.
> Since modify_hca_vport_context accepts mask and value, there is no
> need
> to read the port capabilities and calculate the new cap values so we
> avoid the mutex when ib_virt is set.
>=20
> Fixes: e126ba97dba9edeb ('mlx5: Add driver for Mellanox Connect-IB
> adapters')
> Signed-off-by: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Reviewed-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

Thanks, applied.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
=C2=A0 =C2=A0 GPG KeyID: B826A3330E572FDD
=C2=A0 =C2=A0
Key fingerprint =3D AE6B 1BDA 122B 23B4 265B =C2=A01274 B826 A333 0E57 2FDD

--=-GW6mYLb4e1t1fofVOJF3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJYo090AAoJELgmozMOVy/docYQAImHZNhKdv8L4SXjkaJ+zK6O
VJ+GY6zesfZ7QSaFs2cWE0dgvSkY7ZA902OyiBjtu7NtyYUyHZnt15vQJ8QQOihr
INwr6m2Y6EleMPcIqviQfnMXzmvRvX/tkmuuD85xsNGssJgwTnf4/iZxosxgZOHF
f1OAoYNneC3Gj9KGjulVeI9nF1Ovk157xWTKD509SnNMvVTqrp3D1g4b2RKNokk+
7g/+8YgW/tm4wzvT+37DGnyKQN6+YvIs3Q/uEfEmmkYrw2oBTiN+4ol9snXJv2Tj
tio9bWxrTnukB0aDIkkvhaE1mF4JU4IYj9HpVTg+S8KhKmAOoMs3DUh0X5U+gNvl
KeNnOStmAIfNJpVOaUT9sUfYtbQQdkV7rrCrTc3a2DsSHegHpi8Vq26JCcz2yOao
OiTpTUm9Al+68/Yx2tU0PuAFQxtD0v1fQ4TdqCctDSfGel8RuPXlI1TKut9zcSr2
NpbDlDaMZgrs7uJ7GHykE2La2tRTUPcRreEXmj7D4nkzV1hCb/bLxEr6jQ44PA6W
QWqcATEoNX5S4cEqdyl5+YwMuDJfpAdvA6CT8ASS8cp+RuIIooNN47+KU360YSjI
DoTUBqtQOxQOUzHjGKbxPlbTTfq5xE1OCA+TMdE0hEe4FxmkQAN3+9EGq+4qJh8I
nVxdese1RBzm17L+fHI5
=0hSB
-----END PGP SIGNATURE-----

--=-GW6mYLb4e1t1fofVOJF3--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
