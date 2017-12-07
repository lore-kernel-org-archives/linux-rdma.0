From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-rc 0/4] RDMA fixes for 4.15
Date: Thu, 07 Dec 2017 15:50:00 -0500
Message-ID: <1512679800.5537.5.camel@redhat.com>
References: <20171205203004.28386-1-leon@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-9N9y7YJG3CACk0FLn4Av"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171205203004.28386-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--=-9N9y7YJG3CACk0FLn4Av
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2017-12-05 at 22:30 +0200, Leon Romanovsky wrote:
> The patches from Daniel are targeted for stable@.
>=20
> The patches are available in the git repository at:
>   git.kernel.org/pub/scm/linux/kernel/git/leon/linux-rdma.git tags/rdma-r=
c-2017-12-05
>=20
> 	Thanks
> ---------------------------------------
>=20
> Daniel Jurgens (2):
>   IB/core: Bound check alternate path port number
>   IB/core: Don't enforce PKey security on SMI MADs
>=20
> Guy Levi (1):
>   IB/mlx4: Fix RSS hash fields restrictions
>=20
> Leon Romanovsky (1):
>   RDMA/netlink: Fix general protection fault
>=20
>  drivers/infiniband/core/cma.c        |  2 +-
>  drivers/infiniband/core/device.c     |  2 +-
>  drivers/infiniband/core/iwcm.c       |  2 +-
>  drivers/infiniband/core/nldev.c      |  2 +-
>  drivers/infiniband/core/security.c   |  7 +++++--
>  drivers/infiniband/core/uverbs_cmd.c |  6 ++++++
>  drivers/infiniband/hw/mlx4/qp.c      | 26 +++++++++++++++++++-------
>  7 files changed, 34 insertions(+), 13 deletions(-)
>=20
> --
> 2.15.1
>=20

Thanks Leon, applied to -rc.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD
--=-9N9y7YJG3CACk0FLn4Av
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEErmsb2hIrI7QmWxJ0uCajMw5XL90FAlopqXgACgkQuCajMw5X
L91t5w/+JjmlR6sJOOD0Y5/Jzq7u0xVVJ8eBw+32F9maTBxtUXHQ/5+L8nmofWf9
7GOjBtWM+hXvWOc4AIXYw8svdPiS5s8P788fGkL6s27irccDSYJEPlyFVSBKhExU
2jskG2zJvquJNstKfcjPg0WsY4QI0TQDzd98Ukgi+2Lslh8BF62VH+WCGD9RcpqZ
oLLS3O+DJdDqLHjzrTA52AVqymaqz7MadIfOtzMydtj0ZACA6WcZw3+bccu8hCOi
10ynDej6DIhMYHIK6lQMYz5drSfuKjEXIS4qCzJDujJKfKRN8TQtD7HGBDlEV3sr
Jy6M4SNI5t3JbOrZP7DkiW5b7AfHa5TI9Qe+BNkC9yD/H6b0VacRjmMuayNNV2Z1
h1gdPJFIhqBo98I/uOfWUC5OEZgakzn0THuj8HoeN939SxBLh+hdf9ohNCOO/rfw
il8V06wcwCl8e+v3XFoVtFyvxtAHuRWuwN2BGBm/Mi0pNbMoJH5vXM7hxbeMfZLG
zApTfAPzHk8lrLVR2/Ek56TTUPoaY3cz+VgiMe9ZwNwa407HNQYbIqt3lr/CXaV4
2Sh6UkSi4jwop9DBdgVzw34woekjIgtjsgr0bbBUbydDeG2/PywPHdf3ePstcKNA
iT/5a9VszeVuvxpfdwN2rFlxtPL0xjvCMI+wAZzXV9c8MQ6rfyM=
=Wgma
-----END PGP SIGNATURE-----

--=-9N9y7YJG3CACk0FLn4Av--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
