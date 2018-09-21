From: Doug Ledford <dledford@redhat.com>
Subject: Re: [PATCH rdma-next 0/4] mlx5 vport loopback
Date: Fri, 21 Sep 2018 15:14:36 -0400
Message-ID: <4d9969b9424642dc4c50ca698c57c41654f7006a.camel@redhat.com>
References: <20180917103049.18235-1-leon@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-wHdIJD+amcdI2xBwZUah"
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180917103049.18235-1-leon@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Leon Romanovsky <leon@kernel.org>, Jason Gunthorpe <jgg@mellanox.com>
Cc: Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Mark Bloch <markb@mellanox.com>, Yishai Hadas <yishaih@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org


--=-wHdIJD+amcdI2xBwZUah
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2018-09-17 at 13:30 +0300, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@mellanox.com>
>=20
> Hi,
>=20
> This is short series from Mark which extends handling of loopback
> traffic. Originally mlx5 IB dynamically enabled/disabled both unicast
> and multicast based on number of users. However RAW ethernet QPs need
> more granular access.
>=20
> Thanks
>=20
> Mark Bloch (4):
>   net/mlx5: Rename incorrect naming in IFC file
>   RDMA/mlx5: Refactor transport domain bookkeeping logic
>   RDMA/mlx5: Allow creating RAW ethernet QP with loopback support
>   RDMA/mlx5: Enable vport loopback when user context or QP mandate

I've reviewed this series and I'm OK with it, but the first patch is for
net/mlx5.  How are you expecting the series to be applied?  Are you
wanting me or Jason to take the entire series, or does the first patch
need to go through the mlx5 tree and get picked up by Dave and us, and
then we take the rest?  This is unclear to me...

--=20
Doug Ledford <dledford@redhat.com>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD

--=-wHdIJD+amcdI2xBwZUah
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEErmsb2hIrI7QmWxJ0uCajMw5XL90FAlulQx0ACgkQuCajMw5X
L90mXxAAquVeOQsMNcd3YmVx5O/DFdxvK8gOdXNQfnB+Dm8ajkuUDT4qDZKOdbcf
Er71h7ulHYd64LLGFPxoxjvOcmwJKgrNTUXpN9+WpTkG3UzO5lgb39Psbk0bOuta
SZbB5EClGoY37LzVa1rGX4ixcfsmN71vcDqVMuaZlHDxF0IPC/Jw173PEJmIcAwK
ARPclBSRpO7zWXL7XFcPkbTCsrCRow5cCeWXyV4S+Py9MSdWEXMiQ98hAwrfHdN9
QTVjtKBBKAIqFjFK13ffNjRaqzoQxfDxCbanbzxheb6V0QMN/3zoRHJPH3EvEK1/
K2M5p39Tq8WmUmvd0RUx2B3ZsbSdX/wPFwIQNAnmVm2AlucAH/CW+rlN+UETQ13V
DvGMMAxPnMZnoGjCb9WiJMu6rijJSTk266rmvsubfeJjf0H9UaiIej/w3lh4IzLX
J5TpRTLoPzUxMhjX0H0eqsHviFT8SRrnL9xzQ1F7DLklQJef7omIsTWwJta4gDzR
1RyLFjjjEsTaX+iexSJwA2u0s13CakBc4u6qDo8wRWsSpVnXr8xFrlYuqpL8sJCj
j+EHf+A2WuDdKZGrOCppVTGEOdA9DQDuYIK4Xtimz5dWq3m9L/SHPM9Xo69hkVSh
0+pF9ud4AVmHASFvpwtbGBfL7qzlEoQmlY03dY/VTQ+UiqBRb5A=
=Ix/Y
-----END PGP SIGNATURE-----

--=-wHdIJD+amcdI2xBwZUah--
