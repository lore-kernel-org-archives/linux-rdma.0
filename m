From: Leon Romanovsky <leonro@mellanox.com>
Subject: Re: [PATCH mlx5-next 3/4] IB/mlx5: Use helper to get CQE opcode
Date: Wed, 5 Dec 2018 08:09:20 +0000
Message-ID: <20181205062304.GF15544@mtr-leonro.mtl.com>
References: <20181205020303.16318-1-saeedm@mellanox.com>
 <20181205020303.16318-4-saeedm@mellanox.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="mR8QP4gmHujQHb1c"
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20181205020303.16318-4-saeedm@mellanox.com>
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
To: Saeed Mahameed <saeedm@mellanox.com>
Cc: "netdev@vger.kernel.org" <netdev@vger.kernel.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, Jason Gunthorpe <jgg@mellanox.com>, Tariq Toukan <tariqt@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

--mR8QP4gmHujQHb1c
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Dec 04, 2018 at 06:03:02PM -0800, Saeed Mahameed wrote:
> From: Tariq Toukan <tariqt@mellanox.com>
>
> Use the new helper that extracts the opcode
> from a CQE (completion queue entry) structure.
>
> Signed-off-by: Tariq Toukan <tariqt@mellanox.com>
> Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
> ---
>  drivers/infiniband/hw/mlx5/cq.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
>

I recommend you to squash this patch into the previous one.

Thanks,
Acked-by: Leon Romanovsky <leonro@mellanox.com>

--mR8QP4gmHujQHb1c
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBAgAGBQJcB27IAAoJEORje4g2clinsR8P/3XKtzLwAxLthz9d4JzZOsu7
XoQ0k0RK0jNLU4wEYld05fFRoIL5lkMO6lrwBo2AuFqePNo2FD6jvt20kzwY6Mtn
LaiK/676F/lW+dPqsPUbcr7reRK1/t7xXg7YejOF0hujs2UCocAnSmGEuSj4fcpN
4PKx1qAQoqEh9g9BlywWEnKey6jsGZPLBi4rUrw2vaQddVA1kzM26VlZdT3b6oIz
/GcWmKIRvYZz24Bq8xiRgB7pkE/keW3HMmKnGbB+tI1om4R+qV2ctvlieQ/dZT/u
zGRB5gY6cPLnnHQDHP/NYasvFKinqnZFesl8KtfReaJfUpM7a1LJEz835Yinsgc6
o9dYf9jiDUB5kR+Is03+EhDawwGlUuP0P0XfsuHeKa4s0VZe4sixW58rbVGugkXD
+6TpyT8twf6GbljzZWK8SRh3uG4fXr05Fgaiax48xe4lcA/pDMd70v5HfRVUDgi3
h71hU3VFxSxixtRuNydMzM5FtxkExeb2lLR08u1e2oa1pdM1T/wYwaKv1eAuutrs
p9CpXQjvEfMpCz/Rw7akNMQN+jZNBtONrmtKOXy0BrEBuQmmjSQP44oc7vx9go94
nkyMrFwD3g2zqINO8g5F7jmKshIliiBhBPNFS12Me5SxCXWA6h4Evl0lRsPs96Zd
eUIKjkN7gBxOhygOR3+a
=TQII
-----END PGP SIGNATURE-----

--mR8QP4gmHujQHb1c--
