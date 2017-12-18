From: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH v1 for-rc 0/8] vmw_pvrdma fixes for 4.15
Date: Mon, 18 Dec 2017 11:25:11 -0700
Message-ID: <20171218182511.GH19070@mellanox.com>
References: <20171214001753.GA9780@bryantan-devbox.prom.eng.vmware.com.prom.eng.vmware.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171214001753.GA9780-qXbCdz4EeRo1jLI2hToXVI42T8aCTgcwy4vvyvUx+exJXi8ZT2ovy+oDBWuYMCC/JZORHMmSJCU@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bryan Tan <bryantan-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, Dec 13, 2017 at 04:17:59PM -0800, Bryan Tan wrote:
> 
> Do some cleanup and fixes related to the comments received during SRQ
> support upstreaming that applied to existing code. Also add in two
> missed macros used by the userlevel library for SRQs, a missed
> ib_umem_release, an incorrect usage of the new refcount_t type,
> and switched from use of wait queues to completions.
> 
> v0 -> v1 changelog:
> - Removed use of BIT() in UAPI header
> - Make setting/usage of is_kernel consistent between QP/CQ/SRQ
> - Use completions instead of wait queues for resource destroy
> - Cleaned up commit messages

This series would be fine for -next, the patches look OK to me now.

But there are too many non-rc things to be for-rc.

If you want this in -rc for some reason then you need to send a series
with just those commits, otherwise it will go to -next.

These fix actual bugs and could be for-rc

>   RDMA/vmw_pvrdma: Call ib_umem_release on destroy QP path
>   RDMA/vmw_pvrdma: Use refcount_dec_and_test to avoid warning
>   RDMA/vmw_pvrdma: Use completion instead of wait queue

These are clearly not for-rc:

>   RDMA/vmw_pvrdma: Use more specific sizeof in kcalloc
>   RDMA/vmw_pvrdma: Use refcount_t instead of atomic_t

Does this fix a bug or is it just a style change? Can't tell:

>   RDMA/vmw_pvrdma: Clarify QP and CQ is_kernel logic

These two are boarder line. Would need a better commit message explaining
why these need to be in -rc:

>   RDMA/vmw_pvrdma: Remove usage of BIT() from UAPI header
>   RDMA/vmw_pvrdma: Add UAR SRQ macros in ABI header file

Let me know what you want.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
