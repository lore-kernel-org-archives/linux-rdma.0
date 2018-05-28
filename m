From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH rdma-next v1 11/13] IB/mlx5: Add flow counters binding
 support
Date: Mon, 28 May 2018 11:27:52 -0600
Message-ID: <20180528172752.GD17505@ziepe.ca>
References: <20180527102346.15149-1-leon@kernel.org>
 <20180527102346.15149-12-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180527102346.15149-12-leon@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Leon Romanovsky <leon@kernel.org>
Cc: Doug Ledford <dledford@redhat.com>, Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Boris Pismenny <borisp@mellanox.com>, Matan Barak <matanb@mellanox.com>, Raed Salem <raeds@mellanox.com>, Yishai Hadas <yishaih@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Sun, May 27, 2018 at 01:23:44PM +0300, Leon Romanovsky wrote:

> +	if (!mcounters->hw_cntrs_hndl) {
> +		mcounters->hw_cntrs_hndl =
> +			(void *)mlx5_fc_create(to_mdev(ibcounters->device)->mdev,
> +					       false);

No unnecessary casts

> +struct mlx5_ib_flow_counters_data {
> +	__aligned_u64   counters_data;

I think this is supposed to use RDMA_UAPI_PTR() these days.

Jason
