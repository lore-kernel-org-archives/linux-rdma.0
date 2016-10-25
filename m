From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: RDMA_CM_EVENT_REJECTED
Date: Tue, 25 Oct 2016 17:08:15 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A82373AB0A2BA6@ORSMSX109.amr.corp.intel.com>
References: <00c901d22ecd$79a9f300$6cfdd900$@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <00c901d22ecd$79a9f300$6cfdd900$@opengridcomputing.com>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> While working on the reject helper functions, I notice that some of the
> rdma_cm
> kernel users have handlers for RDMA_CM_EVENT_REJECTED even for cm_ids
> that are
> spawned from listening cm_ids as the result of a
> RDMA_CM_EVENT_CONNECT_REQUEST,
> and that issue an rdma_accept() or rdma_reject() in response.
> 
> Q: is it possible for a REJECTED event to get posted to these cm_ids?
> It is not
> for iWARP, but I'm not sure about IB.  I'm guessing this is just due to
> cut/paste process of adding event handlers, but I wanted to make sure.

If I'm following this correctly, then, yes, I believe those cm_id's can be rejected.  The active side of a connection can give up waiting for the passive side to act.  As a final gesture, the active side will send a reject message to notify the passive side that it's aborting the connection request.

- Sean
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
