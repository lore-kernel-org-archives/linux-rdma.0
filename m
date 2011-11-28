From: Kelly Burkhart <kelly.burkhart-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Node based multicast membership (was Independent server management of
 Multicasting connections)
Date: Mon, 28 Nov 2011 10:49:38 -0600
Message-ID: <CAND8VyAtWDCP0XS_GraCmr9f9P6b=BYGTwsX7Tr4=9nbmen6ow@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "dev-x2spCj9RiN0z5UmgcLIfJQ@public.gmane.org" <dev-x2spCj9RiN0z5UmgcLIfJQ@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Nov 22, 2011 at 2:01 PM, Hefty, Sean <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wro=
te:
> Also, be aware that the SA manages multicast joins per node and not p=
er request. =A0I.e. If node X joins a group twice, followed by 1 leave =
request, the node will be removed from the group. =A0The SA does not pe=
rform reference counting. =A0(It cannot distinguish between 2 separate =
requests, versus a single request that may have been retried.)

Yikes!   So on a single node, if there are two independent
applications that join then leave group membership, the first to leave
will affect the second app?  That's surprising.  Could rdma_cm or some
other local resource maintain a count and only really drop node
membership when the count drops to zero?

Also, the rdma_leave_multicast man page states: "Destroying an
rdma_cm_id will automatically leave all multicast groups."  So this
would indicate that I can't prevent the above problem by not leaving
the group before my app exits.  Is that correct?

-K
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
