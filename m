From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH mlx5-next v2 11/13] IB/mlx5: Add flow counters binding
 support
Date: Tue, 29 May 2018 13:56:27 -0600
Message-ID: <20180529195627.GA31423@ziepe.ca>
References: <20180529130917.13592-1-leon@kernel.org>
 <20180529130917.13592-12-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180529130917.13592-12-leon@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Leon Romanovsky <leon@kernel.org>
Cc: Doug Ledford <dledford@redhat.com>, Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Boris Pismenny <borisp@mellanox.com>, Matan Barak <matanb@mellanox.com>, Raed Salem <raeds@mellanox.com>, Yishai Hadas <yishaih@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>, Alex Rosenbaum <alexr@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

On Tue, May 29, 2018 at 04:09:15PM +0300, Leon Romanovsky wrote:
> diff --git a/include/uapi/rdma/mlx5-abi.h b/include/uapi/rdma/mlx5-abi.h
> index 508ea8c82da7..ef3f430a7050 100644
> +++ b/include/uapi/rdma/mlx5-abi.h
> @@ -443,4 +443,18 @@ enum {
>  enum {
>  	MLX5_IB_CLOCK_INFO_V1              = 0,
>  };
> +
> +struct mlx5_ib_flow_counters_data {
> +	__aligned_u64   counters_data;
> +	__u32   ncounters;
> +	__u32   reserved;
> +};
> +
> +struct mlx5_ib_create_flow {
> +	__u32   ncounters_data;
> +	__u32   reserved;
> +	/* Following are counters data based on ncounters_data */
> +	struct mlx5_ib_flow_counters_data data[];
> +};
> +
>  #endif /* MLX5_ABI_USER_H */

This uapi thing still needs to be fixed as I pointed out before.

I still can't figure out why this should be a 2d array. I think it
should be written simply as:

struct mlx5_ib_flow_counter_desc {
        __u32 description;
        __u32 index;
};

struct mlx5_ib_create_flow {
	RDMA_UAPI_PTR(struct mlx5_ib_flow_counter_desc, counters_data);
	__u32   ncounters;
	__u32   reserved;
};

With the corresponding changes elsewhere.

A flex array at the end of a struct means that the struct can never be
extended again which seems like a terrible idea, especially since I
can't fathom why we'd need more that one array of counters and the
current code doesn't even support more than one..

Jason
