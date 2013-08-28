From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH V4 for-next 3/4] IB/core: Export ib_create/destroy_flow
 through uverbs
Date: Wed, 28 Aug 2013 10:20:50 -0600
Message-ID: <20130828162050.GA31381@obsidianresearch.com>
References: <1377694075-29287-1-git-send-email-matanb@mellanox.com>
 <1377694075-29287-4-git-send-email-matanb@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1377694075-29287-4-git-send-email-matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Hadar Har-Zion <hadarh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, shawn.bohrer-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, tzahio-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, Aug 28, 2013 at 03:47:54PM +0300, Matan Barak wrote:
> +
> +	if (cmd.comp_mask)
> +		return -EINVAL;

So, how do you propose to interoperate with new user space/old
kernels?

How will user space know what comp_mask values the kernel will
support?

The notion that was established in the verbs patches is that extra
structure fields are ignored by old software.

> +	if ((cmd.flow_attr.type == IB_FLOW_ATTR_SNIFFER &&
> +	     !capable(CAP_NET_ADMIN)) || !capable(CAP_NET_RAW))
> +		return -EPERM;
> +
> +	if (cmd.flow_attr.num_of_specs < 0 ||
> +	    cmd.flow_attr.num_of_specs > IB_FLOW_SPEC_SUPPORT_LAYERS)
> +		return -EINVAL;
> +
> +	kern_attr_size = cmd.flow_attr.size - sizeof(cmd) -
> +			 sizeof(struct ib_uverbs_cmd_hdr_ex);
> +
> +	if (cmd.flow_attr.size < 0 || cmd.flow_attr.size > in_len ||
> +	    kern_attr_size < 0 || kern_attr_size >
> +	    (cmd.flow_attr.num_of_specs * sizeof(struct ib_kern_spec)))
                ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Watch out for integer overflow here..

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
