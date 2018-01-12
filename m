From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH] net/mlx4_en: ensure rx_desc updating reaches HW before
 prod db updating
Date: Fri, 12 Jan 2018 09:32:47 -0700
Message-ID: <20180112163247.GB15974@ziepe.ca>
References: <1515728542-3060-1-git-send-email-jianchao.w.wang@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1515728542-3060-1-git-send-email-jianchao.w.wang@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jianchao Wang <jianchao.w.wang@oracle.com>
Cc: tariqt@mellanox.com, junxiao.bi@oracle.com, netdev@vger.kernel.org, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, Saeed Mahameed <saeedm@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

On Fri, Jan 12, 2018 at 11:42:22AM +0800, Jianchao Wang wrote:
> Customer reported memory corruption issue on previous mlx4_en driver
> version where the order-3 pages and multiple page reference counting
> were still used.
> 
> Finally, find out one of the root causes is that the HW may see stale
> rx_descs due to prod db updating reaches HW before rx_desc. Especially
> when cross order-3 pages boundary and update a new one, HW may write
> on the pages which may has been freed and allocated again by others.
> 
> To fix it, add a wmb between rx_desc and prod db updating to ensure
> the order. Even thougth order-0 and page recycling has been introduced,
> the disorder between rx_desc and prod db still could lead to corruption
> on different inbound packages.
> 
> Signed-off-by: Jianchao Wang <jianchao.w.wang@oracle.com>
>  drivers/net/ethernet/mellanox/mlx4/en_rx.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/mellanox/mlx4/en_rx.c b/drivers/net/ethernet/mellanox/mlx4/en_rx.c
> index 85e28ef..eefa82c 100644
> +++ b/drivers/net/ethernet/mellanox/mlx4/en_rx.c
> @@ -555,7 +555,7 @@ static void mlx4_en_refill_rx_buffers(struct mlx4_en_priv *priv,
>  			break;
>  		ring->prod++;
>  	} while (likely(--missing));
> -
> +	wmb(); /* ensure rx_desc updating reaches HW before prod db updating */
>  	mlx4_en_update_rx_prod_db(ring);
>  }
>  

Does this need to be dma_wmb(), and should it be in
mlx4_en_update_rx_prod_db ?

Jason
