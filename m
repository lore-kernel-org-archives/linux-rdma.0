From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH rdma-next v2 17/17] RDMA/nldev: Allow get default counter
 statistics through RDMA netlink
Date: Wed, 22 May 2019 14:30:11 -0300
Message-ID: <20190522173011.GG15023@ziepe.ca>
References: <20190429083453.16654-1-leon@kernel.org>
 <20190429083453.16654-18-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190429083453.16654-18-leon@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Leon Romanovsky <leon@kernel.org>
Cc: Doug Ledford <dledford@redhat.com>, Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Majd Dibbiny <majd@mellanox.com>, Mark Zhang <markz@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Apr 29, 2019 at 11:34:53AM +0300, Leon Romanovsky wrote:
> From: Mark Zhang <markz@mellanox.com>
> 
> This patch adds the ability to return the hwstats of per-port default
> counters (which can also be queried through sysfs nodes).
> 
> Signed-off-by: Mark Zhang <markz@mellanox.com>
> Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
>  drivers/infiniband/core/nldev.c | 101 +++++++++++++++++++++++++++++++-
>  1 file changed, 99 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/infiniband/core/nldev.c b/drivers/infiniband/core/nldev.c
> index 53c1d2d82a06..cb2dd38f49f1 100644
> +++ b/drivers/infiniband/core/nldev.c
> @@ -1709,6 +1709,98 @@ static int nldev_stat_del_doit(struct sk_buff *skb, struct nlmsghdr *nlh,
>  	return ret;
>  }
>  
> +static int nldev_res_get_default_counter_doit(struct sk_buff *skb,
> +					      struct nlmsghdr *nlh,
> +					      struct netlink_ext_ack *extack,
> +					      struct nlattr *tb[])
> +{
> +	struct rdma_hw_stats *stats;
> +	struct nlattr *table_attr;
> +	struct ib_device *device;
> +	int ret, num_cnts, i;
> +	struct sk_buff *msg;
> +	u32 index, port;
> +	u64 v;
> +
> +	if (!tb[RDMA_NLDEV_ATTR_DEV_INDEX] || !tb[RDMA_NLDEV_ATTR_PORT_INDEX])
> +		return -EINVAL;
> +
> +	index = nla_get_u32(tb[RDMA_NLDEV_ATTR_DEV_INDEX]);
> +	device = ib_device_get_by_index(sock_net(skb->sk), index);
> +	if (!device)
> +		return -EINVAL;
> +
> +	if (!device->ops.alloc_hw_stats || !device->ops.get_hw_stats) {
> +		ret = -EINVAL;
> +		goto err;
> +	}
> +
> +	port = nla_get_u32(tb[RDMA_NLDEV_ATTR_PORT_INDEX]);
> +	if (!rdma_is_port_valid(device, port)) {
> +		ret = -EINVAL;
> +		goto err;
> +	}
> +
> +	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
> +	if (!msg) {
> +		ret = -ENOMEM;
> +		goto err;
> +	}
> +
> +	nlh = nlmsg_put(msg, NETLINK_CB(skb).portid, nlh->nlmsg_seq,
> +			RDMA_NL_GET_TYPE(RDMA_NL_NLDEV,
> +					 RDMA_NLDEV_CMD_STAT_GET),
> +			0, 0);
> +
> +	if (fill_nldev_handle(msg, device) ||
> +	    nla_put_u32(msg, RDMA_NLDEV_ATTR_PORT_INDEX, port)) {
> +		ret = -EMSGSIZE;
> +		goto err_msg;
> +	}
> +
> +	stats = device->ops.alloc_hw_stats(device, port);
> +	if (!stats) {
> +		ret = -ENOMEM;
> +		goto err_msg;
> +	}

Why do we need yet another one of these to be allocated?

> +	num_cnts = device->ops.get_hw_stats(device, stats, port, 0);

Is '0' right here?

Jason
