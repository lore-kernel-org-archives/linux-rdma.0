From: Kelly Burkhart <kelly.burkhart-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: rdma_cm UD sendto without connect
Date: Thu, 3 Nov 2011 10:20:08 -0500
Message-ID: <CAND8VyAYHTg3T2rMmPPMMjXbkN4dZJSDukXhQZFJnVYT2fW+1Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Is it possible to send/recv datagrams with no previous connection
similar to UDP sendto/recvfrom?  UD examples I've seen are connection
oriented and listen/connect/accept, establishing a connection prior to
conversing.

It appears that in order to do what I want, I need an ibv_ah to put in
the send wr.  But how do I create one of these from an IP address/port
without doing an rdma_connect and waiting for
RDMA_CM_EVENT_ESTABLISHED?

>From the receiving side, it looks like I can construct an ah from the
wc.  Is that a low-cost operation?

Thanks,

-Kelly
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
