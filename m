From: Doug Ledford <dledford@redhat.com>
Subject: Re: [PATCH rdma] net/mlx5: Fix XRC SRQ umem valid bits
Date: Tue, 06 Nov 2018 16:31:08 -0500
Message-ID: <cb4d41e3a24c667c5c4e0492d3d3b21a5a165919.camel@redhat.com>
References: <20181031102028.9142-1-leon@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-LE/kIFcgCrAIgoJxo/xT"
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20181031102028.9142-1-leon@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Leon Romanovsky <leon@kernel.org>, Jason Gunthorpe <jgg@mellanox.com>
Cc: Yishai Hadas <yishaih@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Artemy Kovalyov <artemyko@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>, Leon Romanovsky <leonro@mellanox.com>
List-Id: linux-rdma@vger.kernel.org


--=-LE/kIFcgCrAIgoJxo/xT
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2018-10-31 at 12:20 +0200, Leon Romanovsky wrote:
> From: Yishai Hadas <yishaih@mellanox.com>
>=20
> Adapt XRC SRQ to the latest HW specification with fixed definition
> around umem valid bits. The previous definition relied on a bit which
> was taken for other purposes in legacy FW.
>=20
> Fixes: bd37197554eb ("net/mlx5: Update mlx5_ifc with DEVX UID bits")
> Signed-off-by: Yishai Hadas <yishaih@mellanox.com>
> Reviewed-by: Artemy Kovalyov <artemyko@mellanox.com>
> Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
> ---
> Hi Doug, Jason
>=20
> This commit fixes code sent in this merge window, so I'm not marking it
> with any rdma-rc/rdma-next. It will be better to be sent during this merg=
e
> window if you have extra pull request to issue, or as a -rc material, if
> not.
>=20
> BTW, we didn't combine reserved fields, because our convention is to alig=
n such
> fields to 32 bits for better readability.
>=20
> Thanks

This looks fine.  Let me know when it's in the mlx5-next tree to pull.

--=20
Doug Ledford <dledford@redhat.com>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD

--=-LE/kIFcgCrAIgoJxo/xT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEErmsb2hIrI7QmWxJ0uCajMw5XL90FAlviCBwACgkQuCajMw5X
L91cwBAAlPoCWREBR7J2LOtFmxUyETAPJKq8hPeeWRrYSgt+EQJkZjUY8DabcswP
+K62exL1ucivkHPvXlb4Int/4dz3Cy9ZLXvXcprVEPK5WpHDeQWz1jLQ8Evol0+N
m/VOFlTJKOdSbHtsZ5W77umGvoGJKiOYccyrTqu1+YNJWifawVje9x+yJodKcHWq
ySEcxblOcvw4MhUYqaaej5TbBCOMymr29R661wL+G0IBAIvqDPobWXvuli+GD28h
e/k6y7K1v0PZv3oUZzJeEky+CjTOZB2QUQld9IWJu3iqZ8vQ+mZQothFOhiiPYwP
SbjVkRnskm2ZMVxkpF2bJ9OISXtIpMRBVF4qJoxavTvAvLgV+x/E2VPWk3zGzFwE
lCsEmnnj7FnOI5616xy3KCGQZufajZOBmgF68+zqzgHHbq8nQpwzEgSsP7bwx6lg
C+xtT5HmQa8rfH1JYVYzn+vbSDtXq1KXl+K/H6EQeHJPKfhEGZIemce0MjhYsgxl
9WfOmnOln5Tnmki2NVckCJGQBsLGBYA5c4aQHtj/32QA/G69hNyj/XWo+7FWtjE/
HbaYT8WkMbtxWgxGmITCWofWlyHGeIrjS1DOJm2OoYjlKc6VDM7DIQcrYsRnySDc
kcC5+eaFw0HUsbgiH44N0aU4z0d3cGTxbEcOUfLYJuWImD52aww=
=noW6
-----END PGP SIGNATURE-----

--=-LE/kIFcgCrAIgoJxo/xT--
