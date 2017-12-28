From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: Re: [PATCH for-next 0/4] vmw_pvrdma cleanup and style fixes
Date: Wed, 27 Dec 2017 21:49:31 -0700
Message-ID: <20171228044931.GD5343@ziepe.ca>
References: <20171220192305.GA28403@bryantan-devbox.prom.eng.vmware.com.prom.eng.vmware.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171220192305.GA28403-qXbCdz4EeRo1jLI2hToXVI42T8aCTgcwy4vvyvUx+exJXi8ZT2ovy+oDBWuYMCC/JZORHMmSJCU@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bryan Tan <bryantan-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, Dec 20, 2017 at 11:23:11AM -0800, Bryan Tan wrote:
> Do some cleanup and fixes related to comments received when going
> through the review process for the change to enable SRQs on vmw_pvrdma.
> 
> Note, as there are dependencies on the 4.15 fixes, this patch series
> is based on top of the for-rc fixes for 4.15. The patch series is
> named "vmw_pvrdma fixes for 4.15" and the last commit of the series
> is "RDMA/vmw_pvrdma: Avoid use after free due to QP/CQ/SRQ destroy".
> 
> Bryan Tan (4):
>   RDMA/vmw_pvrdma: Clarify QP and CQ is_kernel logic
>   RDMA/vmw_pvrdma: Use more specific sizeof in kcalloc
>   RDMA/vmw_pvrdma: Use refcount_t instead of atomic_t
>   RDMA/vmw_pvrdma: Remove usage of BIT() from UAPI header

All of these are applied to for-next, thanks

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
