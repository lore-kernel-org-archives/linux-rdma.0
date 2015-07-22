From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH WIP 39/43] IB/core: Add arbitrary sg_list support
Date: Wed, 22 Jul 2015 11:22:55 -0600
Message-ID: <20150722172255.GD26909@obsidianresearch.com>
References: <1437548143-24893-1-git-send-email-sagig@mellanox.com>
 <1437548143-24893-40-git-send-email-sagig@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1437548143-24893-40-git-send-email-sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Oren Duer <oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Jul 22, 2015 at 09:55:39AM +0300, Sagi Grimberg wrote:
> +enum ib_mr_flags {
> +	IB_MR_MAP_ARB_SG = 1,
> +};

Something about this just seems ugly. We are back to what we were
trying to avoid: Adding more types of MRs..

Is this really necessary? Do you really need to know the MR type when
the MR is created, or can the adaptor change types on the fly during
registration?

iSER for example has a rarely used corner case where it needs this,
but it just turns on the feature unconditionally right away. This
incures 2x the overhead in the MR allocations and who knows what
performance impact on the adaptor side.

It would be so much better if it could switch to this mode on a SG by
SG list basis.

Same for signature.

In other words: It would be so much cleaner if ib_map_mr_sg set the
MR type based on the need.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
