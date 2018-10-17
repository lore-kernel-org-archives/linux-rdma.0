From: Doug Ledford <dledford@redhat.com>
Subject: Re: [PATCH rdma-next] IB/mlx5: Add support for extended atomic
 operations
Date: Wed, 17 Oct 2018 11:55:14 -0400
Message-ID: <e40246fa133a0fac46aefdda80b542877e3f47f4.camel@redhat.com>
References: <20181010062516.5996-1-leon@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-Qo9A5BsLInh9O62hBkaX"
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20181010062516.5996-1-leon@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Leon Romanovsky <leon@kernel.org>, Jason Gunthorpe <jgg@mellanox.com>
Cc: Yonatan Cohen <yonatanc@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Guy Levi <guyle@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>, Leon Romanovsky <leonro@mellanox.com>
List-Id: linux-rdma@vger.kernel.org


--=-Qo9A5BsLInh9O62hBkaX
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2018-10-10 at 09:25 +0300, Leon Romanovsky wrote:
> From: Yonatan Cohen <yonatanc@mellanox.com>
>=20
> Extended atomic operations cmp&swp and fetch&add is a Mellanox
> feature extending the standard atomic operation to use, varied
> operand sizes, as apposed to normal atomic operation that use
> an 8 byte operand only.
> Extended atomics allows masking the results and arguments.
>=20
> This patch configures QP to support extended atomic operation
> with the maximum size possible, as exposed by HCA capabilities.
>=20
> Signed-off-by: Yonatan Cohen <yonatanc@mellanox.com>
> Reviewed-by: Guy Levi <guyle@mellanox.com>
> Signed-off-by: Leon Romanovsky <leonro@mellanox.com>

Thanks, applied to for-next.

--=20
Doug Ledford <dledford@redhat.com>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD

--=-Qo9A5BsLInh9O62hBkaX
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEErmsb2hIrI7QmWxJ0uCajMw5XL90FAlvHW2IACgkQuCajMw5X
L922CxAAicc72NM2uXoqoU24nN/qCRBfvnLpyIwS5IZoXcdtWPzUoMd7PznyPFCN
ZnOz+fk1mYwY5LYDrNFM8sZskq9bkznNchsNmJ2gpyPqLa//jBZUARBqGSW2M/gX
6nB+sxBbcvgQDCCDSeZoH4vOoS/EviVCTyU0YC7ISiPNbl6Q+3d2xBUR2cwtK/25
Gmn++G6knbvr6HUlJor3tWHLIr/1XO9boP2eqYEYC3VOi++HdEMpr2lT/yNi64uH
uvNGddCDwaAyttxGnnjdCz3mmlNHOYsptFc7NIrYK0pTNoxEfB+eBCQu5nWj6r53
mEz8zyzC8EjHmNCEye2Pjql766vOdd3CJaSNM4qUU0DGq9fnUXiKr99IOxpKTNpu
xct/F+deN9AlDQm/i4+dIbrQWhlE5DtTVrsdjzzcQuaC2Ix9l1sJSkJzH4+kc2bB
rAW8G9bEaIMQW61Ii3pxWHkdKQ5GzPu1NObQoHMNFXc8sQG7nBpbLMqqXkmRNieV
9K/C2T/bxH3zSM5UE9krofw0/pKZj7R4828qAWzxvDsDM+ODSW5/chbZ2hv8poMi
EvlCwfUg3dDe8a+o/BjMJgzbtyVJp05mp6etIvY5kQrpMjUfdOzVIjLgOo4rg+KA
tK2aS2VE38Q8vxsLdstKsJH0tVraHFATMjvjochIo+9Ou4w5X2k=
=2mh4
-----END PGP SIGNATURE-----

--=-Qo9A5BsLInh9O62hBkaX--
