From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: Re: [PATCH rdma-rc] RDMA/vmw_pvrdma: Fix usage of user response
 structures in ABI file
Date: Thu, 15 Feb 2018 15:31:15 -0700
Message-ID: <20180215223115.GD30721@ziepe.ca>
References: <1518727006-4073-1-git-send-email-aditr@vmware.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1518727006-4073-1-git-send-email-aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, pv-drivers-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, Feb 15, 2018 at 12:36:46PM -0800, Adit Ranadive wrote:
> Hi Doug, Jason,
> 
> Here is a patch for the vmw_pvrdma driver for the 4.16 RC.
> 
> Thanks,
> Adit
> This ensures that we return the right structures back to userspace.
> Otherwise, it looks like the reserved fields in the response structures
> in userspace might have uninitialized data in them.
> 
> Fixes: 8b10ba783c9d ("RDMA/vmw_pvrdma: Add shared receive queue support")
> Fixes: 29c8d9eba550 ("IB: Add vmw_pvrdma driver")
> Suggested-by: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Reviewed-by: Bryan Tan <bryantan-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
> Reviewed-by: Aditya Sarwade <asarwade-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
> Reviewed-by: Jorgen Hansen <jhansen-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
> Signed-off-by: Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
>  drivers/infiniband/hw/vmw_pvrdma/pvrdma_cq.c    | 4 +++-
>  drivers/infiniband/hw/vmw_pvrdma/pvrdma_srq.c   | 4 +++-
>  drivers/infiniband/hw/vmw_pvrdma/pvrdma_verbs.c | 4 +++-
>  3 files changed, 9 insertions(+), 3 deletions(-)

Applied to -rc, but next time please send patches in the cannonical
format the commit message did not apply properly. See
Documentation/process/submitting-patches.rst

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
