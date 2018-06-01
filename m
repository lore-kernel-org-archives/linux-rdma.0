From: Doug Ledford <dledford@redhat.com>
Subject: Re: [PATCH V2 mlx5-next 0/2] Mellanox, mlx5 new device events
Date: Fri, 01 Jun 2018 11:08:24 -0400
Message-ID: <82ddad11b6a77aa07238ff50ae8769360bfb583b.camel@redhat.com>
References: <20180530175950.9488-1-saeedm@mellanox.com>
         <20180531.153603.45475041396194381.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-UVolf40a18z/6Ie6NlHo"
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180531.153603.45475041396194381.davem@davemloft.net>
Sender: netdev-owner@vger.kernel.org
To: David Miller <davem@davemloft.net>, saeedm@mellanox.com
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, leonro@mellanox.com, jgg@mellanox.com
List-Id: linux-rdma@vger.kernel.org


--=-UVolf40a18z/6Ie6NlHo
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2018-05-31 at 15:36 -0400, David Miller wrote:
> From: Saeed Mahameed <saeedm@mellanox.com>
> Date: Wed, 30 May 2018 10:59:48 -0700
>=20
> > The following series is for mlx5-next tree [1], it adds the support of =
two
> > new device events, from Ilan Tayari:
> >=20
> > 1. High temperature warnings.
> > 2. FPGA QP error event.
> >=20
> > In case of no objection this series will be applied to mlx5-next tree
> > and will be sent later as a pull request to both rdma and net trees.
> >=20
> > [1] https://git.kernel.org/pub/scm/linux/kernel/git/mellanox/linux.git/=
log/?h=3Dmlx5-next
> >=20
> > v1->v2:
> >   - improve commit message of the FPGA QP error event patch.
>=20
> Series applied, thanks.

Hi Dave,

Although in this case it doesn't really matter and we can work around
it, this was supposed to be a case of the new methodology that Saeed and
Jason had worked out with you.  Specifically, when Saeed says in the
cover letter:

> In case of no objection this series will be applied to mlx5-next tree>
> and will be sent later as a pull request to both rdma and net trees.

then it is intended for you to ack the original patch series, not apply
it, and when acks from both the net and rdma side have been received,
then we will get a pull request of just that series.

--=20
Doug Ledford <dledford@redhat.com>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD
--=-UVolf40a18z/6Ie6NlHo
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEErmsb2hIrI7QmWxJ0uCajMw5XL90FAlsRYWgACgkQuCajMw5X
L929BQ//ck20GiC8ScXU1XxLxcj3CUq0HJA9mlv1SvOo0kUzOmil1S3urrT1CjDZ
yrxGbV4YgD61dgmFuwTU7Q9/icvSpAkd3hI0Ekipzd/sXwz/tV/GhCNg16FX2a8t
6QK4Xwr+hpCweHBAQNlaR6ankSWQ+8wqS9IT+9FgIs028+GAe3mHOCCWQZZeL3jz
3iSxDYEf7w7UCwZtMkL1FeWDgLEVkBNLz0UO7isBAuZJ+l+imvJTMC+iIj2YfKJx
Py8R7NirpX1YbmhrFYGF5MLfsBokLuGvi0eB9dZ4wjA7YW8MSgyAQa3tZoR42zLA
7z+t2RNo6gFF4ZkVUE0VuedLh7GZsS9pyOzGIZL1u1mZCd1CtcK6gSDmkOtQiSlT
knT8nFUeaw+k338vvCecpO4e38o2WWdWbzDNr78Ey2K+3XvMeq+4iNz5tasyrfwl
S6FekUaSrQ3B/iYMDKn4L1LNwJ30PYjf3994WAUCk1mPwoGYunmgx0ZEKUYNWdYx
SGdC5avlqL9dENI3TkudbbxGkqrYHxlIGEAAQ59wtpuZmXQM6snvpdJcMm6JjQu0
oiGY2L1Nluo8QNmeMMXZJDiPnPwf4vCE3W+owl4qe9YCmY5axhwGEAiEyRixRWPz
zK1ISraAbkZKe4f1nNxBTNy5kFeLPBMEBwhk6doaPzUucDsRR38=
=zvwF
-----END PGP SIGNATURE-----

--=-UVolf40a18z/6Ie6NlHo--
