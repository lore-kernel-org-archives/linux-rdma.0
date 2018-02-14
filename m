From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: Re: [PATCH rdma-next 07/14] RDMA/uverbs: Refactor command header
 processing
Date: Wed, 14 Feb 2018 16:49:51 -0700
Message-ID: <20180214234951.GF1718@ziepe.ca>
References: <20180214123844.30321-1-leon@kernel.org>
 <20180214123844.30321-8-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20180214123844.30321-8-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Noa Osherovich <noaos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Feb 14, 2018 at 02:38:37PM +0200, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> 
> Move all command header processing into separate function
> and perform those checks before acquiring SRCU read lock.
> 
> Signed-off-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>  drivers/infiniband/core/uverbs_main.c | 62 ++++++++++++++++++-----------------
>  1 file changed, 32 insertions(+), 30 deletions(-)
> 
> diff --git a/drivers/infiniband/core/uverbs_main.c b/drivers/infiniband/core/uverbs_main.c
> index 90e0b16aed1a..50d43c300112 100644
> +++ b/drivers/infiniband/core/uverbs_main.c
> @@ -660,6 +660,29 @@ static bool verify_command_idx(__u32 command, bool extended)
>  	       uverbs_cmd_table[command];
>  }
>  
> +static ssize_t process_hdr(struct ib_uverbs_cmd_hdr *hdr,
> +			   __u32 *command, bool *extended)
> +{
> +	__u32 flags;
> +
> +	if (hdr->command & ~(__u32)(IB_USER_VERBS_CMD_FLAGS_MASK |
> +				   IB_USER_VERBS_CMD_COMMAND_MASK))
> +		return -EINVAL;
> +
> +	*command = hdr->command & IB_USER_VERBS_CMD_COMMAND_MASK;
> +	flags = (hdr->command &
> +		 IB_USER_VERBS_CMD_FLAGS_MASK) >> IB_USER_VERBS_CMD_FLAGS_SHIFT;
> +
> +	*extended = flags & IB_USER_VERBS_CMD_FLAG_EXTENDED;
> +	if (flags & ~IB_USER_VERBS_CMD_FLAG_EXTENDED)
> +		return -EINVAL;

er..

We don't need both

	if (hdr->command & ~(__u32)(IB_USER_VERBS_CMD_FLAGS_MASK |
				   IB_USER_VERBS_CMD_COMMAND_MASK))

and

        if (flags & ~IB_USER_VERBS_CMD_FLAG_EXTENDED)
		return -EINVAL;

They test the same condition.

So my earlier comment about needing a stronger flags check is bogus -
we already have the stronger check. The original code was just
checking it twice, so it doesn't need this extra if.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
