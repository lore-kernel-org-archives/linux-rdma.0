From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-next 0/5] iw_cxgb4: handle fw reply timeouts
Date: Fri, 29 Sep 2017 11:48:54 -0400
Message-ID: <1506700134.2919.23.camel@redhat.com>
References: <cover.1506545745.git.swise@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1506545745.git.swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, 2017-09-27 at 13:55 -0700, Steve Wise wrote:
> For messages sent from the host to fw that solicit a reply from fw,
> the c4iw_wr_wait struct pointer is passed in the host->fw message,
> and
> included in the fw->host fw6_msg reply.  This allows the sender to
> wait
> until the reply is received, and the code processing the ingress
> reply
> to wake up the sender.
> 
> If c4iw_wait_for_reply() times out, however, we need to keep the
> c4iw_wr_wait object around in case the reply eventually does arrive.
> Otherwise we have touch-after-free bugs in the wake_up paths.
> 
> This series refactors the c4iw_wait_wr users and the wait API to
> handle
> this case.  The first 4 patches change the users to allocate the wait
> object vs using it locally on the stack, and the 5th patch
> implmements the
> new kref for the wait objects.
> 
> Steve Wise (5):
>   iw_cxgb4: allocate wait object for each memory object
>   iw_cxgb4: allocate wait object for each cq object
>   iw_cxgb4: allocate wait object for each qp object
>   iw_cxgb4: allocate wait object for each ep object
>   iw_cxgb4: add referencing to wait objects
> 
>  drivers/infiniband/hw/cxgb4/cm.c       |  40 +++---
>  drivers/infiniband/hw/cxgb4/cq.c       |  69 +++++-----
>  drivers/infiniband/hw/cxgb4/device.c   |  21 +++
>  drivers/infiniband/hw/cxgb4/iw_cxgb4.h |  66 ++++++++-
>  drivers/infiniband/hw/cxgb4/mem.c      | 242 ++++++++++++++++++++---
> ----------
>  drivers/infiniband/hw/cxgb4/qp.c       |  82 +++++------
>  6 files changed, 330 insertions(+), 190 deletions(-)

Thanks Steve, applied.

-- 
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
