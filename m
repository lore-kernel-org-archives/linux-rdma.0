From: "Steve Wise" <swise@opengridcomputing.com>
Subject: RE: [PATCH iproute2 rdma: Ignore unknown netlink attributes
Date: Tue, 3 Apr 2018 08:32:36 -0500
Message-ID: <016b01d3cb50$3adc88b0$b0959a10$@opengridcomputing.com>
References: <20180403072842.32153-1-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain;
        charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180403072842.32153-1-leon@kernel.org>
Content-Language: en-us
Sender: netdev-owner@vger.kernel.org
To: 'Leon Romanovsky' <leon@kernel.org>, 'Stephen Hemminger' <stephen@networkplumber.org>
Cc: 'Leon Romanovsky' <leonro@mellanox.com>, 'netdev' <netdev@vger.kernel.org>, 'RDMA mailing list' <linux-rdma@vger.kernel.org>, 'David Ahern' <dsahern@gmail.com>
List-Id: linux-rdma@vger.kernel.org



> -----Original Message-----
> From: Leon Romanovsky <leon@kernel.org>
> Sent: Tuesday, April 3, 2018 2:29 AM
> To: Stephen Hemminger <stephen@networkplumber.org>
> Cc: Leon Romanovsky <leonro@mellanox.com>; netdev
> <netdev@vger.kernel.org>; RDMA mailing list <linux-
> rdma@vger.kernel.org>; David Ahern <dsahern@gmail.com>; Steve Wise
> <swise@opengridcomputing.com>
> Subject: [PATCH iproute2 rdma: Ignore unknown netlink attributes
> 
> From: Leon Romanovsky <leonro@mellanox.com>
> 
> The check if netlink attributes supplied more than maximum supported
> is to strict and may lead to backward compatibility issues with old
> application with a newer kernel that supports new attribute.
> 
> CC: Steve Wise <swise@opengridcomputing.com>
> Fixes: 74bd75c2b68d ("rdma: Add basic infrastructure for RDMA tool")
> Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
> ---
>  rdma/utils.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/rdma/utils.c b/rdma/utils.c
> index a2e08e91..5c1e736a 100644
> --- a/rdma/utils.c
> +++ b/rdma/utils.c
> @@ -399,7 +399,8 @@ int rd_attr_cb(const struct nlattr *attr, void *data)
>  	int type;
> 
>  	if (mnl_attr_type_valid(attr, RDMA_NLDEV_ATTR_MAX) < 0)
> -		return MNL_CB_ERROR;
> +		/* We received uknown attribute */
> +		return MNL_CB_OK;
> 
>  	type = mnl_attr_get_type(attr);
> 

Hey Leon,

So the resource parsing functions correctly ignore the unkown attrs and
print everything else?

Looks good.

Reviewed-by: Steve Wise <swise@opengridcomputing.com>
