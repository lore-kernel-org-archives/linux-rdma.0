From: Leon Romanovsky <leonro@mellanox.com>
Subject: Re: [PATCH] net/mlx5: Uninitialized variable in esw_add_uc_addr()
Date: Thu, 10 Aug 2017 14:21:02 +0300
Message-ID: <20170810112102.GU1423@mtr-leonro.local>
References: <20170809072418.e4x5xmbvboadhe5w@mwanda>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="2qwbT0JTInWqknst"
Return-path: <kernel-janitors-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170809072418.e4x5xmbvboadhe5w@mwanda>
Sender: kernel-janitors-owner@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Saeed Mahameed <saeedm@mellanox.com>, Matan Barak <matanb@mellanox.com>, linux-rdma@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org


--2qwbT0JTInWqknst
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Aug 10, 2017 at 12:28:11AM +0300, Dan Carpenter wrote:
> "err" isn't initialized if we hit the "goto fdb_add;".
>
> Fixes: eeb66cdb6826 ("net/mlx5: Separate between E-Switch and MPFS")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
>
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
> index fd51f0ea8df9..baed45c0dabe 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
> @@ -376,7 +376,7 @@ static int esw_add_uc_addr(struct mlx5_eswitch *esw, struct vport_addr *vaddr)
>  {
>  	u8 *mac = vaddr->node.addr;
>  	u32 vport = vaddr->vport;
> -	int err;
> +	int err = 0;

I'm not sure that it is the right error value which we want to return in
case of vprot == 0 was supplied.

Saeed ?

>
>  	/* Skip mlx5_mpfs_add_mac for PFs,
>  	 * it is already done by the PF netdev in mlx5e_execute_l2_action
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--2qwbT0JTInWqknst
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlmMQZ4ACgkQ5GN7iDZy
WKfpIQ/+O66M2ZTWxxb9vs4AuKr0y6aNyX7Gj6pcDsg4wLrbNA27w4qqxIsPSt0C
4c8MOUSOV0742HXd4SMPBu7elUg8VYrs/tnxEId8ddsCzikx9c7cm8UHpOd1L19t
e6etWz6r10/gbHQEamqiOEOhR2Veo2XOJnjfPkmO3tf7ok59Lf4tIm0ZwTZxhva6
kLwBithLcP/Pys/bhI5V7fIaQjaQBHBeLz01d6vJFWjA0pF22Ro0coYf4TN5EArx
Nfmy/pW/p3PHji6Vm0vA2TQ3W72lWRS0l5QhUz+hbkX6M+xGxpNZ7cJPZCQia3pk
dH9EEsBsnf5ARC/wfTeTTIU7UGtz/iLIdb8cqbjcvWFoUghPBcJLJsASuEMNWXKk
7kMGHQpJEgvQuZ61rRLatdug0gAsXdtAXsLbgoeymVGJ2G7nCyqQNUah8jyUYo68
FYXJbCPRKcovw0366hW5cHlGouwR3QEBu/GzNWN/V+IQ1JiaWjgSR9WhZDMUIH73
r6UB33vBW0OxpUT0yctbmuu50FxgPLyu0T0Lwzn/FXDvSsTSYF9gKGixeeHCmD68
9MZ+Cr6169tzdYo+hG3C5U+aEjll0Y6ru3i0O7PRPBLIcvthNAPFjvSbDYGvP9Mj
vqKRJxFAGkpk5gSBebzkY7DQsKEzbda7ulBTrLwBos0zx9+qRGU=
=BnwD
-----END PGP SIGNATURE-----

--2qwbT0JTInWqknst--
