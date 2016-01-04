From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: Re: [PATCH] svc_rdma: use local_dma_lkey
Date: Mon, 4 Jan 2016 10:57:56 -0600
Message-ID: <568AA494.6000907@opengridcomputing.com>
References: <1450789915-22032-1-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1450789915-22032-1-git-send-email-hch-jcswGhMUV9g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, bfields-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


On 12/22/2015 7:11 AM, Christoph Hellwig wrote:
> We now alwasy have a per-PD local_dma_lkey available.  Make use of that
> fact in svc_rdma and stop registering our own MR.
>
> Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
> Reviewed-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Reviewed-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
> Reviewed-by: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> ---
>   include/linux/sunrpc/svc_rdma.h            |  2 --
>   net/sunrpc/xprtrdma/svc_rdma_backchannel.c |  2 +-
>   net/sunrpc/xprtrdma/svc_rdma_recvfrom.c    |  4 ++--
>   net/sunrpc/xprtrdma/svc_rdma_sendto.c      |  6 ++---
>   net/sunrpc/xprtrdma/svc_rdma_transport.c   | 36 ++++--------------------------
>   5 files changed, 10 insertions(+), 40 deletions(-)

Reviewed-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
