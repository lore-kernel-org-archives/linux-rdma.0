From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: Re: [patch 2/6] infiniband: remove dependency on __GFP_NOFAIL
Date: Tue, 20 Jul 2010 22:19:12 -0500
Message-ID: <4C466730.1070809@opengridcomputing.com>
References: <alpine.DEB.2.00.1007201936210.8728@chino.kir.corp.google.com> <alpine.DEB.2.00.1007201938570.8728@chino.kir.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.DEB.2.00.1007201938570.8728-X6Q0R45D7oAcqpCFd4KODRPsWskHk0ljAL8bYrjMMd8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Steve Wise <swise-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Acked-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>

David Rientjes wrote:
> The alloc_skb() in various allocations are failable, so remove
> __GFP_NOFAIL from their masks.
>
> Cc: Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
> Signed-off-by: David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> ---
>  drivers/infiniband/hw/cxgb4/cq.c  |    4 ++--
>  drivers/infiniband/hw/cxgb4/mem.c |    2 +-
>  drivers/infiniband/hw/cxgb4/qp.c  |    6 +++---
>  3 files changed, 6 insertions(+), 6 deletions(-)
>   

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
