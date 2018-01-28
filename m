From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: Re: [PATCH rdma-next v7 7/8] RDMA/nldev: Provide global resource
 utilization
Date: Sun, 28 Jan 2018 13:45:13 -0700
Message-ID: <20180128204513.GH23869@ziepe.ca>
References: <20180128091725.13103-1-leon@kernel.org>
 <20180128091725.13103-8-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20180128091725.13103-8-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Sun, Jan 28, 2018 at 11:17:24AM +0200, Leon Romanovsky wrote:

> @@ -52,6 +54,11 @@ static const struct nla_policy nldev_policy[RDMA_NLDEV_ATTR_MAX] = {
>  	[RDMA_NLDEV_ATTR_PORT_STATE]	= { .type = NLA_U8 },
>  	[RDMA_NLDEV_ATTR_PORT_PHYS_STATE] = { .type = NLA_U8 },
>  	[RDMA_NLDEV_ATTR_DEV_NODE_TYPE] = { .type = NLA_U8 },
> +	[RDMA_NLDEV_ATTR_RES_SUMMARY]	= { .type = NLA_NESTED },
> +	[RDMA_NLDEV_ATTR_RES_SUMMARY_ENTRY]	= { .type = NLA_NESTED },
> +	[RDMA_NLDEV_ATTR_RES_SUMMARY_ENTRY_NAME] = { .type = NLA_NUL_STRING,
> +					     .len = 16 },
> +	[RDMA_NLDEV_ATTR_RES_SUMMARY_ENTRY_CURR] = { .type = NLA_U64 },

nla_policy is only used during kernel parsing, it shouldn't have
anything the kernel will not accept as input, right? ie it should omit
things that are output only?

>  static const struct rdma_nl_cbs nldev_cb_table[RDMA_NLDEV_NUM_OPS] = {
>  	[RDMA_NLDEV_CMD_GET] = {
>  		.doit = nldev_get_doit,
> @@ -338,6 +485,10 @@ static const struct rdma_nl_cbs nldev_cb_table[RDMA_NLDEV_NUM_OPS] = {
>  		.doit = nldev_port_get_doit,
>  		.dump = nldev_port_get_dumpit,
>  	},
> +	[RDMA_NLDEV_CMD_RES_GET] = {
> +		.doit = nldev_res_get_doit,
> +		.dump = nldev_res_get_dumpit,
> +	},
>  };
>  
>  void __init nldev_init(void)
> diff --git a/include/uapi/rdma/rdma_netlink.h b/include/uapi/rdma/rdma_netlink.h
> index cc002e316d09..e0f5cdc81541 100644
> +++ b/include/uapi/rdma/rdma_netlink.h
> @@ -236,6 +236,11 @@ enum rdma_nldev_command {
>  	RDMA_NLDEV_CMD_PORT_NEW,
>  	RDMA_NLDEV_CMD_PORT_DEL,
>  
> +	RDMA_NLDEV_CMD_RES_GET, /* can dump */
> +	RDMA_NLDEV_CMD_RES_SET,
> +	RDMA_NLDEV_CMD_RES_NEW,
> +	RDMA_NLDEV_CMD_RES_DEL,

Confused why all thse have get/set/new/del tuples and then don't
implement all of them. Is there some reason for this?

AFAIK netlink doesn't have any rules for numbering get/set/new/del, so
why can't we just add when we need?

> @@ -303,6 +308,11 @@ enum rdma_nldev_attr {
>  
>  	RDMA_NLDEV_ATTR_DEV_NODE_TYPE,		/* u8 */
>  
> +	RDMA_NLDEV_ATTR_RES_SUMMARY,		/* nested table */
> +	RDMA_NLDEV_ATTR_RES_SUMMARY_ENTRY,	/* nested table */
> +	RDMA_NLDEV_ATTR_RES_SUMMARY_ENTRY_NAME,	/* string */
> +	RDMA_NLDEV_ATTR_RES_SUMMARY_ENTRY_CURR,	/* u64 */

Had to look it up to figure out what CURR was..

ENTRY_NUM_OBJECTS ?

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
