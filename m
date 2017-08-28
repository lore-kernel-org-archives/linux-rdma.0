From: Doug Ledford <dledford@redhat.com>
Subject: Re: [PATCH] net/mlx5: add a missing tab
Date: Mon, 28 Aug 2017 19:09:47 -0400
Message-ID: <1503961787.52034.6.camel@redhat.com>
References: <20170801110101.mf2i5e2mes4ftmkj@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <kernel-janitors-owner@vger.kernel.org>
In-Reply-To: <20170801110101.mf2i5e2mes4ftmkj@mwanda>
Sender: kernel-janitors-owner@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>, Saeed Mahameed <saeedm@mellanox.com>
Cc: Matan Barak <matanb@mellanox.com>, Leon Romanovsky <leonro@mellanox.com>, linux-rdma@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Tue, 2017-08-01 at 14:01 +0300, Dan Carpenter wrote:
> The code works as intended, but the indenting is confusing.
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

You didn't include netdev on this patch, and I haven't seen a note from
janitors that they took it, so I decided to send it on through.  It's
minor enough it shouldn't be an issue conflicting with Dave's tree I
would think.  I'll know I was wrong if I get yelled at.

> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/sriov.c
> b/drivers/net/ethernet/mellanox/mlx5/core/sriov.c
> index 28d8472b36f1..c410360da58d 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/sriov.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/sriov.c
> @@ -113,7 +113,7 @@ static int mlx5_device_enable_sriov(struct
> mlx5_core_dev *dev, int num_vfs)
>  				mlx5_core_warn(dev,
>  					       "failed to restore VF
> %d settings, err %d\n",
>  					       vf, err);
> -			continue;
> +				continue;
>  			}
>  		}
>  		mlx5_core_dbg(dev, "successfully enabled VF* %d\n",
> vf);
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" 
> in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
-- 
Doug Ledford <dledford@redhat.com>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD

