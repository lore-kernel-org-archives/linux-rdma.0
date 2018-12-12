From: Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH net-next] net/mlx5e: Remove set but not used variable
 'upriv'
Date: Wed, 12 Dec 2018 17:10:12 +0200
Message-ID: <20181212151012.GD3933@mtr-leonro.mtl.com>
References: <1544603633-170212-1-git-send-email-yuehaibing@huawei.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="Nx8xdmI2KD3LNVVP"
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1544603633-170212-1-git-send-email-yuehaibing@huawei.com>
Sender: netdev-owner@vger.kernel.org
To: YueHaibing <yuehaibing@huawei.com>
Cc: Saeed Mahameed <saeedm@mellanox.com>, netdev@vger.kernel.org, linux-rdma@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org


--Nx8xdmI2KD3LNVVP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Dec 12, 2018 at 08:33:53AM +0000, YueHaibing wrote:
> Fixes gcc '-Wunused-but-set-variable' warning:
>
> drivers/net/ethernet/mellanox/mlx5/core/en_rep.c: In function 'mlx5e_vport_rep_load':
> drivers/net/ethernet/mellanox/mlx5/core/en_rep.c:1490:21: warning:
>  variable 'upriv' set but not used [-Wunused-but-set-variable]
>
> drivers/net/ethernet/mellanox/mlx5/core/en_rep.c: In function 'mlx5e_vport_rep_unload':
> drivers/net/ethernet/mellanox/mlx5/core/en_rep.c:1557:21: warning:
>  variable 'upriv' set but not used [-Wunused-but-set-variable]
>
> It not used any more since commit ef381359e3a8 ("net/mlx5e: Replace egdev with
> indirect block notifications"). Also remove unused variable 'uplink_rpriv'
> after this change.
>
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>
> ---
>  drivers/net/ethernet/mellanox/mlx5/core/en_rep.c | 10 ----------
>  1 file changed, 10 deletions(-)
>

Thanks,
Reviewed-by: Leon Romanovsky <leonro@mellanox.com>

--Nx8xdmI2KD3LNVVP
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBAgAGBQJcESTUAAoJEORje4g2clinQeMQAJoQAMYYHbstWhyARNEiH8W2
g/6HcJNkXaxvpW8QmxEco0qf3cCBA5ehRZsrsqrIQtDsdPnviatcgugjVJKsRMBI
u8kUL6hg6VOBK1k9VgYOAl8QBsTyDX5h+db0C+A5CJEA7z8iGjptbunLAekH11vO
Mz+414C33vG9e3gfKcWntLUt70RxXR/FMUajlUQoHoMP0mIbUc9z/6+DPLhKZUxB
nY/wdiXIzTfrOrhW1cHMdJUZ6inDz2rAyL24ZIiWFpenJIr/0l8BkPomIepfogJj
d6m3mmtYaXKWtNNT8C+3lsvyzZQ+N9PKSckzC+vbfcifTqEpQvtt23ZtGsrpNUln
OiLaC2L8qPRxGlODjYpJ1LxgcKKbJFofUbpAx3eWTMgGbGq99Sajpl3fhgcT+4GE
Lcxeb0L6iyejoqCw/So9DXBjj7PfQRO4v5RCQfce0as98AnKnShtmC74LelCrkjP
olD1g23Hjko0DDkrWGxe5GMwfvyD2lQFSxwEMKGEwawhlnaz4zVKt21TgVk4OjU6
PeHzph8acbIHKInJfVZZnYIN99fm+/nwg67iBePfz4GQo+c0p54W65GSngKoEtGS
FX6B36DV/OdUzfkuTqg8I2em3kKXDdM8xXC046I0xDR7AjDBzbkvaKy5T1FyyxQL
/NvFCcGobl/3vkZGHqo6
=FJDk
-----END PGP SIGNATURE-----

--Nx8xdmI2KD3LNVVP--
