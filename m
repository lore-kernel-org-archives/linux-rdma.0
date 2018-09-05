From: Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH net-next] net/mlx5e: Make function
 mlx5i_grp_sw_update_stats() static
Date: Wed, 5 Sep 2018 14:25:30 +0300
Message-ID: <20180905112530.GQ2977@mtr-leonro.mtl.com>
References: <1536146162-132732-1-git-send-email-weiyongjun1@huawei.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="vk/v8fjDPiDepTtA"
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1536146162-132732-1-git-send-email-weiyongjun1@huawei.com>
Sender: netdev-owner@vger.kernel.org
To: Wei Yongjun <weiyongjun1@huawei.com>
Cc: Saeed Mahameed <saeedm@mellanox.com>, Jason Gunthorpe <jgg@ziepe.ca>, Or Gerlitz <ogerlitz@mellanox.com>, Tariq Toukan <tariqt@mellanox.com>, Feras Daoud <ferasda@mellanox.com>, Alex Vesker <valex@mellanox.com>, Erez Shitrit <erezsh@mellanox.com>, netdev@vger.kernel.org, linux-rdma@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org


--vk/v8fjDPiDepTtA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Sep 05, 2018 at 11:16:02AM +0000, Wei Yongjun wrote:
> Fixes the following sparse warning:
>
> drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c:119:6: warning:
>  symbol 'mlx5i_grp_sw_update_stats' was not declared. Should it be static?
>
> Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
> ---
>  drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>

Thanks,
Reviewed-by: Leon Romanovsky <leonro@mellanox.com>

--vk/v8fjDPiDepTtA
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBAgAGBQJbj70qAAoJEORje4g2clin5DAP/Ay8Ol1p9QJpOla3jm+sGlEa
ZZ/lR1DVol4oY9F3mXRXXff0Gx+dvXmaxTzH/qVh9tGeEr3/Bckn3HCX1yan3BSn
Qi7pfChcwxFMMCrHQT15ZpxPTM7vIDMSkgMmyNyjn2gf9Hri4ybcO48yIi7u/RIP
7QmxErmZLeYWR7K+xXN3WH1ocd+Rnrv73OJsxwlZviW8C5GcbxiITRu6IqnLjxEW
8/2nVBG/gGkRY+2HjvhZVeYL5xcywYXW3gdsKd7ckR3AnURVpqlGaMkZhcyJL1Ds
XuPpgmZ7rMrJm+XqG8BBlfxnJOe8WvAn6jIUfi4BM3gJM47BE9wBEw4oUmNTVmx2
TE7qR9dVSYXdCEuegp90gbMDTbyqGRunTFcnUPfFKyWi8xuMzOfA/KJRArZAddw6
2WjVeSKgjj3b5zLD78dPNhgiVVn8pTlWWz5bEhftaPg1tPpSX517ycilF07F3igJ
wh+cqdqlNdBsQlhS7RKSiF7tH0Y4UFBxLUyT2IB51pbEdtEkvcektqcfEy+a7VhX
Ce9tmN6l79M3piq1bZ2Rc5LmDoomj3oS8qR7H7YuaF63wqAzLJ8zSBayo3XPVcfT
d/IJ1pSfAVsVsKGXtbIIYc0qLWCj8aWODqqzQujdBAAkF5SiZmoPfgo0XUQsAJmV
m7w4a4YfM648XWYDU58B
=g8pc
-----END PGP SIGNATURE-----

--vk/v8fjDPiDepTtA--
