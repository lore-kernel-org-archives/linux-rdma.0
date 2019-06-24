From: Jason Gunthorpe <jgg@mellanox.com>
Subject: Re: [PATCH rdma-next v1 09/12] IB/mlx5: Register DEVX with mlx5_core
 to get async events
Date: Mon, 24 Jun 2019 11:52:09 +0000
Message-ID: <20190624115206.GB5479@mellanox.com>
References: <20190618171540.11729-1-leon@kernel.org>
 <20190618171540.11729-10-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190618171540.11729-10-leon@kernel.org>
Content-Language: en-US
Content-ID: <1F657B3CC5700043B1A9E3388CC60FC5@eurprd05.prod.outlook.com>
Sender: netdev-owner@vger.kernel.org
To: Leon Romanovsky <leon@kernel.org>
Cc: Doug Ledford <dledford@redhat.com>, Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Yishai Hadas <yishaih@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Jun 18, 2019 at 08:15:37PM +0300, Leon Romanovsky wrote:
>  void __mlx5_ib_remove(struct mlx5_ib_dev *dev,
> diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw=
/mlx5/mlx5_ib.h
> index 9cf23ae6324e..556af34b788b 100644
> +++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
> @@ -944,6 +944,13 @@ struct mlx5_ib_pf_eq {
>  	mempool_t *pool;
>  };
> =20
> +struct mlx5_devx_event_table {
> +	struct mlx5_nb devx_nb;
> +	/* serialize updating the event_xa */
> +	struct mutex event_xa_lock;
> +	struct xarray event_xa;
> +};
> +
>  struct mlx5_ib_dev {
>  	struct ib_device		ib_dev;
>  	struct mlx5_core_dev		*mdev;
> @@ -994,6 +1001,7 @@ struct mlx5_ib_dev {
>  	struct mlx5_srq_table   srq_table;
>  	struct mlx5_async_ctx   async_ctx;
>  	int			free_port;
> +	struct mlx5_devx_event_table devx_event_table;

I really question if adding all these structs really does anything for
readability..

Jason
