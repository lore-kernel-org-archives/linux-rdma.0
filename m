From: Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH] net/mlx5: Delete unneeded function argument
Date: Wed, 15 Aug 2018 17:20:18 +0300
Message-ID: <20180815142018.GV5325@mtr-leonro.mtl.com>
References: <20180815135433.23834-1-yuval.shaia@oracle.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="qZLIv6EoKi7YuaSc"
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180815135433.23834-1-yuval.shaia@oracle.com>
Sender: netdev-owner@vger.kernel.org
To: Yuval Shaia <yuval.shaia@oracle.com>
Cc: saeedm@mellanox.com, davem@davemloft.net, netdev@vger.kernel.org, linux-rdma@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org


--qZLIv6EoKi7YuaSc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Aug 15, 2018 at 04:54:33PM +0300, Yuval Shaia wrote:
> priv argument is not used by the function, delete it.
>
> Fixes: a89842811ea98 ("net/mlx5e: Merge per priority stats groups")
>

No extra space here.

Thanks

--qZLIv6EoKi7YuaSc
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBAgAGBQJbdDaiAAoJEORje4g2clinjt0P/jpd6jAHYeY1VcNrDnnqH/to
VENcAl5g7xRFIZdyKM+qEL4VrRbSA5KqzNF6xuU0UbcTK9fe/AYFhR6E5t+B2jXj
aNQH4/5R8N5Ddp4k8XYcvofVG73a0i+Epr8BY3g4i7UBSnHfluUkvFN2mMPdWHKK
V6ueavfXItMj5f2jvJ74q0QvR3e0w7YGPlJXzj7LyyQIq/bvjhmlGPhsS8l1V5N/
49iFCWkHHzOwJIW2PrMBQ5JapUfvcrvJ9byT+hRzNBQafIOJZhZFaRZJHtgLJk56
CE4ojyPiaFhJOPKKsk6OGuoBs4ZGet9V+CJIP8+NvOXJ2iOrpWS8aFUBmujWeKT9
ADS0sYmk0SvdQEWv4fF5g+PTVMoX+yYND43drirSceqYB/Aw1zqfbXcFg00jhRap
8cSZBaK2/qwWb30BhhAnqSiqK5NQhmziR3GTRErmQg07pm0BD9sGXfJYnhtKkbxA
sy+APv7DNJfDJeu/DToOMxVm1bp33GPZW13LijmIdXBD3XtfYcwZG0gxBXevLNT2
EB5DPD93w3LmNhD0mXihe8Jgk4ZAb2HVv1kjQn/FVZ1mRIQMGwFq6ewjyy2biJ0z
49P669eZXE0nANB+XSehB3vXnxU90CJnvOrWu0nVhrJWmaLsNRJgkgT8PTsMGLju
QVMYmLhNJQ22btUNWv9b
=5sP3
-----END PGP SIGNATURE-----

--qZLIv6EoKi7YuaSc--
