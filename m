From: lokesh agarwal <lokesh.agarwal1986-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: RDMA CM EVENT rejected with status = 4 (timeout)
Date: Fri, 23 Aug 2013 11:34:28 -0700
Message-ID: <CABqF1pZSmv1S-07pGxwoSaLB7zYWRhuFxiAtz6S-hFYtyEOY5w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hello,
I am looking at a very peculiar race condition and dont quite
understand why rdma cm
is generating a certain event.

The race is as follows.
Lets say Process P1 is connection to Process P2 (RC connection) using RDMA CM.
Also the connection is asynchronous, i.e the fd associated with the cm
event channel has been converted to non blocking.

Consider Time along the vertical access.

P1-> addr_resolve()
      select(cm_event_fd)
      gets RDMA_CM_ADDR_RESOLVED

       rout_resolve()
       gets RDMA_CM_ROUTE_RESOLVE

       connect():

P2: Gets Connect request

P1: -> Dies

P2: create_qp() -> Fails -> deletes the cmid associated

P2: select(cm_fd)

P2: gets RDMA_CM_EVENT_REJECTED -> event->status = 4...


P2 does not have ANY outstanding connections. It is not trying to connect to
anything. It is just passively accepting connections.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
