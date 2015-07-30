From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH for-4.3 00/15] Modify MR allocation API
Date: Thu, 30 Jul 2015 11:22:42 -0600
Message-ID: <20150730172242.GB25282@obsidianresearch.com>
References: <1438241568-3685-1-git-send-email-sagig@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1438241568-3685-1-git-send-email-sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, Jul 30, 2015 at 10:32:33AM +0300, Sagi Grimberg wrote:
> This patch set is detached from my WIP for modifying our
> fast registration kernel API. I incorporated some comments
> from Jason and Christoph. The current set is a drop-in replacement
> of ib_alloc_fast_reg_mr to ib_alloc_mr which receives a memory
> region type (whcih can be IB_MR_TYPE_MEM_REG for normal memory
> registration, IB_MR_TYPE_SIGNATURE for a data-integrity capable
> memory region and future arbitrary SG support capable memory
> region).

Looks good to me now..

Reviewed-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
