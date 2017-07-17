From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH rdma-next V3 1/5] RDMA/netlink: Remove netlink clients
 infrastructure
Date: Mon, 17 Jul 2017 10:02:07 -0400
Message-ID: <7285b9b9-360f-5157-1148-1554db2f4a2c@intel.com>
References: <20170627050028.17902-1-leon@kernel.org>
 <20170627050028.17902-2-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170627050028.17902-2-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, Chien Tin Tung <chien.tin.tung-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 6/27/2017 1:00 AM, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> 
> RDMA netlink has complicated infrastructure to add and remove netlink
> clients to NETLINK_RDMA family. This complicates the code and not in
> use because not many clients are available (3 clients) and most of them
> (2 clients) are statically compiled together with netlink.c.

So here you say there are three clients.

> -	struct ibnl_client *cur;
> -	struct ibnl_client *nl_client;
> +	static const unsigned int max_num_ops[RDMA_NL_NUM_CLIENTS - 1] = {
> +				  RDMA_NL_RDMA_CM_NUM_OPS,
> +				  RDMA_NL_IWPM_NUM_OPS,
> +				  0,
> +				  RDMA_NL_LS_NUM_OPS,
> +				  0 };
> 
> -	nl_client = kmalloc(sizeof *nl_client, GFP_KERNEL);
> -	if (!nl_client)
> -		return -ENOMEM;
> +	/*
> +	 * This BUILD_BUG_ON is intended to catch addition of new
> +	 * RDMA netlink protocol without updating the array above.
> +	 */
> +	BUILD_BUG_ON(RDMA_NL_NUM_CLIENTS != 6);

Yet we are checking for 6? Can you elaborate here.

-Denny
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
