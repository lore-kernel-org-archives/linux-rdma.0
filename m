From: Bryan Tan <bryantan-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v1 for-rc 0/8] vmw_pvrdma fixes for 4.15
Date: Mon, 18 Dec 2017 13:42:44 -0800
Message-ID: <20171218214244.GA19558@bryantan-devbox.prom.eng.vmware.com.prom.eng.vmware.com>
References: <20171214001753.GA9780@bryantan-devbox.prom.eng.vmware.com.prom.eng.vmware.com>
 <20171218182511.GH19070@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171218182511.GH19070-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Mon, Dec 18, 2017 at 11:25:11AM -0700, Jason Gunthorpe wrote:
> On Wed, Dec 13, 2017 at 04:17:59PM -0800, Bryan Tan wrote:
> > 
> > Do some cleanup and fixes related to the comments received during SRQ
> > support upstreaming that applied to existing code. Also add in two
> > missed macros used by the userlevel library for SRQs, a missed
> > ib_umem_release, an incorrect usage of the new refcount_t type,
> > and switched from use of wait queues to completions.
> > 
> > v0 -> v1 changelog:
> > - Removed use of BIT() in UAPI header
> > - Make setting/usage of is_kernel consistent between QP/CQ/SRQ
> > - Use completions instead of wait queues for resource destroy
> > - Cleaned up commit messages
> 
> This series would be fine for -next, the patches look OK to me now.
> 
> But there are too many non-rc things to be for-rc.
> 
> If you want this in -rc for some reason then you need to send a series
> with just those commits, otherwise it will go to -next.

I will send out a series with the following commits:

>   RDMA/vmw_pvrdma: Call ib_umem_release on destroy QP path
>   RDMA/vmw_pvrdma: Use refcount_dec_and_test to avoid warning
>   RDMA/vmw_pvrdma: Use completion instead of wait queue
>   RDMA/vmw_pvrdma: Add UAR SRQ macros in ABI header file

And I will clarify the commit message in the last commit there.

Thanks!
Bryan
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
