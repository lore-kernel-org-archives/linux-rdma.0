From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: Re: [PATCH rdma-next 6/8] RDMA/netlink: Protect device query from
 device removal
Date: Wed, 27 Dec 2017 16:05:52 -0700
Message-ID: <20171227230552.GL25436@ziepe.ca>
References: <20171224134328.17398-1-leon@kernel.org>
 <20171224134328.17398-7-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171224134328.17398-7-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Sun, Dec 24, 2017 at 03:43:26PM +0200, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> 
> There is a chance that device will be removed during device query
> operations and it will cause to kernel panic in the flows which
> doesn't hold lists_rwsem semaphore.
> 
> Fixes: e5c9469efcb1 ("RDMA/netlink: Add nldev device doit implementation")
> Reviewed-by: Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Signed-off-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>  drivers/infiniband/core/nldev.c | 25 +++++++++++++++----------
>  1 file changed, 15 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/infiniband/core/nldev.c b/drivers/infiniband/core/nldev.c
> index 2b631307349d..e3033d7a4029 100644
> +++ b/drivers/infiniband/core/nldev.c
> @@ -141,36 +141,41 @@ static int nldev_get_doit(struct sk_buff *skb, struct nlmsghdr *nlh,
>  	struct ib_device *device;
>  	struct sk_buff *msg;
>  	u32 index;
> -	int err;
> +	int ret = -ENOMEM;
>  
> -	err = nlmsg_parse(nlh, 0, tb, RDMA_NLDEV_ATTR_MAX - 1,
> +	ret = nlmsg_parse(nlh, 0, tb, RDMA_NLDEV_ATTR_MAX - 1,
>  			  nldev_policy, extack);
> -	if (err || !tb[RDMA_NLDEV_ATTR_DEV_INDEX])
> +	if (ret || !tb[RDMA_NLDEV_ATTR_DEV_INDEX])
>  		return -EINVAL;
>  
>  	index = nla_get_u32(tb[RDMA_NLDEV_ATTR_DEV_INDEX]);
>  
> -	device = __ib_device_get_by_index(index);

It is not possible to correctly use __ib_device_get_by_index without
grabbing one of the locks which are static to device.c

Thus it should not be in core_priv.h and every single user must be
wrong, please fix them all here and make it static again.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
