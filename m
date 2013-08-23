From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: RDMA CM EVENT rejected with status = 4 (timeout)
Date: Fri, 23 Aug 2013 19:27:08 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237388CA7FBA@ORSMSX109.amr.corp.intel.com>
References: <CABqF1pZSmv1S-07pGxwoSaLB7zYWRhuFxiAtz6S-hFYtyEOY5w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CABqF1pZSmv1S-07pGxwoSaLB7zYWRhuFxiAtz6S-hFYtyEOY5w-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: lokesh agarwal <lokesh.agarwal1986-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> P1-> addr_resolve()
>       select(cm_event_fd)
>       gets RDMA_CM_ADDR_RESOLVED
> 
>        rout_resolve()
>        gets RDMA_CM_ROUTE_RESOLVE
> 
>        connect():
> 
> P2: Gets Connect request
> 
> P1: -> Dies

When process 1 dies after trying to establish a connection, this generates a connection reject.  This notifies the remote side that the connection request has been aborted.

The destruction of the cm_id on process 2 should remove all unreported events for that id.

There was a kernel bug that could result in reporting events like you are seeing, but that was fixed a while ago.  If you're running an older kernel, this could be the reason you see the unexpected event.

- Sean
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
