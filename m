From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH rdma-next v1 12/15] RDMA/mlx5: Add a new flow action verb
 - modify header
Date: Tue, 4 Sep 2018 15:58:23 -0600
Message-ID: <20180904215823.GA3792@ziepe.ca>
References: <20180828111854.14367-1-leon@kernel.org>
 <20180828111854.14367-13-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180828111854.14367-13-leon@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Leon Romanovsky <leon@kernel.org>
Cc: Doug Ledford <dledford@redhat.com>, Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Ariel Levkovich <lariel@mellanox.com>, Mark Bloch <markb@mellanox.com>, Or Gerlitz <ogerlitz@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Aug 28, 2018 at 02:18:51PM +0300, Leon Romanovsky wrote:

> +static int UVERBS_HANDLER(MLX5_IB_METHOD_FLOW_ACTION_CREATE_MODIFY_HEADER)(
> +	struct ib_uverbs_file *file,
> +	struct uverbs_attr_bundle *attrs)
> +{
> +	struct ib_uobject *uobj = uverbs_attr_get_uobject(
> +		attrs, MLX5_IB_ATTR_CREATE_MODIFY_HEADER_HANDLE);
> +	struct mlx5_ib_dev *mdev = to_mdev(uobj->context->device);
> +	enum mlx5_ib_uapi_flow_table_type ft_type;
> +	struct ib_flow_action *action;
> +	size_t num_actions;
> +	void *in;
> +	int len;
> +	int ret;
> +
> +	if (!mlx5_ib_modify_header_supported(mdev))
> +		return -EOPNOTSUPP;
> +
> +	in = uverbs_attr_get_alloced_ptr(attrs,
> +		MLX5_IB_ATTR_CREATE_MODIFY_HEADER_ACTIONS_PRM);
> +	len = uverbs_attr_get_len(attrs,
> +		MLX5_IB_ATTR_CREATE_MODIFY_HEADER_ACTIONS_PRM);
> +
> +	if (len % MLX5_UN_SZ_BYTES(set_action_in_add_action_in_auto))
> +		return -EINVAL;
> +
> +	ret = uverbs_get_const(&ft_type, attrs,
> +			       MLX5_IB_ATTR_CREATE_MODIFY_HEADER_FT_TYPE);
> +	if (ret)
> +		return -EINVAL;

This should be

	if (ret)
		return ret;

Every call to uverbs_get_const is wrong in this same way..

I can probably fix it if this is the only thing though..

Jason
