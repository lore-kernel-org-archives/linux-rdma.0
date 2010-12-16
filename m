From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: Re: rdma provider module references
Date: Thu, 16 Dec 2010 09:48:32 -0600
Message-ID: <4D0A34D0.4000404@opengridcomputing.com>
References: <4D08E989.5020307@aoot.com> <adapqt3gdzb.fsf@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <adapqt3gdzb.fsf-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: Steve Wise <swise-10udUCx4aRo@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Tom Tucker <tom-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

However I guess NFS/RDMA is behind the RDMA CM, which is supposed to
> handle device removal.  In that code it seems to end up in
> cma_process_remove(), which appears at first glance to do the right
> things to destroy all connections etc.
>

Function cma_process_remove() calls cma_remove_id_dev() for each cm_id bound to the device being removed.  Function 
cma_remove_id_dev() calls the event handler function for each cm_id and passes a RDMA_CM_EVENT_DEVICE_REMOVAL event.  
The NFSRDMA server marks the RPC transport as XPT_CLOSE, but doesn't immediately destroy the cm_id in the event handler 
function.  This is in net/sunrpc/xprtrdma/svc_rdma_transport.c / rdma_cma_handler(). That's the issue methinks.  Each 
RDMA kernel user must destroy all the resources in the event handler function itself.  These cannot be scheduled or 
deferred in any way given the current design.


Steve.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
