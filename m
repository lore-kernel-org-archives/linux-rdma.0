From: Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH] mlx5: Fix formats with line continuation whitespace
Date: Thu, 1 Nov 2018 09:20:40 +0200
Message-ID: <20181101072040.GP3974@mtr-leonro.mtl.com>
References: <e076161b88d0c87f083f28450a130de8eead618f.camel@perches.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="Az4VpBrmI9+OyhK/"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <e076161b88d0c87f083f28450a130de8eead618f.camel@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Joe Perches <joe@perches.com>
Cc: Saeed Mahameed <saeedm@mellanox.com>, "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org


--Az4VpBrmI9+OyhK/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Nov 01, 2018 at 12:09:36AM -0700, Joe Perches wrote:
> The line continuations unintentionally add whitespace so
> instead use coalesced formats to remove the whitespace.
>
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  drivers/net/ethernet/mellanox/mlx5/core/rl.c | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/rl.c b/drivers/net/ethernet/mellanox/mlx5/core/rl.c
> index bc86dffdc43c..377b7e65ecf1 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/rl.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/rl.c
> @@ -188,8 +188,7 @@ int mlx5_rl_add_rate(struct mlx5_core_dev *dev, u16 *index,
>  		/* new rate limit */
>  		err = mlx5_set_pp_rate_limit_cmd(dev, entry->index, rl);
>  		if (err) {
> -			mlx5_core_err(dev, "Failed configuring rate limit(err %d): \
> -				      rate %u, max_burst_sz %u, typical_pkt_sz %u\n",
> +			mlx5_core_err(dev, "Failed configuring rate limit(err %d): rate %u, max_burst_sz %u, typical_pkt_sz %u\n",
>  				      err, rl->rate, rl->max_burst_sz,
>  				      rl->typical_pkt_sz);
>  			goto out;
> @@ -218,8 +217,7 @@ void mlx5_rl_remove_rate(struct mlx5_core_dev *dev, struct mlx5_rate_limit *rl)
>  	mutex_lock(&table->rl_lock);
>  	entry = find_rl_entry(table, rl);
>  	if (!entry || !entry->refcount) {
> -		mlx5_core_warn(dev, "Rate %u, max_burst_sz %u typical_pkt_sz %u \
> -			       are not configured\n",
> +		mlx5_core_warn(dev, "Rate %u, max_burst_sz %u typical_pkt_sz %u  are not configured\n",

                                                                 double space ^^^^^

>  			       rl->rate, rl->max_burst_sz, rl->typical_pkt_sz);
>  		goto out;
>  	}
>

Thanks,
Reviewed-by: Leon Romanovsky <leonro@mellanox.com>

--Az4VpBrmI9+OyhK/
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBAgAGBQJb2qlIAAoJEORje4g2clinIrUP/AkH9vV61DSNFqRmjCZfEb99
VtiIVVwoMu9aDK8AbxC7IYvUOXbZrmYOXG3+GDUY80S5TOWMnPcYu6hLu3HWUKRG
jTxvbvQ1sDnu47NGac+rb+7FMqfhzgxPEu6ldlSUXb+SDOPMA1vXNAny63am5+1s
LnfaifOJiXSa5T8SXwPkz3ghBUtcA7w+WaR4f8Z4VMeMQZR+1gXOh98byyMFgtg+
gZ3rYWCb21hLRa/l9Hb+J2CK5MwrAHjH2vVv/LsFqXS+wS0BN5ODbfs3qp8w2akn
gv6PrGwJH6/PTjrgkq7aWZa00wu7yM7zrMuDT0noC5mJ5JH0fNQ/aUZ7brEoDUao
yoFVbOS1uQEkzO1aI9ifumvuuWTGp1pbPNzLC2DpEc8Xs4Q5WBrB62JpVZ4kQgfk
ITSKkmNOvlv0wf/PtYApivJ0X04xEfWCz3xhZV4GZp2rwbWJRDjDkHDbffN1kD5s
zcJc2Memop1Wr+0Tg78VOXj2mStgaD9Sb5pr3/v6CSpWVkdDhsLulkO1vOicpUmN
K4L9SABlsvoTRmOjKTCuqFWvQc1N7gYfl94ie8uewZSUMo5E7NHHC/GPu8s8nSH5
237+ATjApCf35aFAbsgh/3NaSnmqFYEpwXfO191qowQy5pTohjyggv7aTWXsyfja
RrejBR12uEh0EA7YFJbM
=izpc
-----END PGP SIGNATURE-----

--Az4VpBrmI9+OyhK/--
