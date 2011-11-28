From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: Node based multicast membership (was Independent server
 management of Multicasting connections)
Date: Mon, 28 Nov 2011 19:09:18 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237316E9C68E@ORSMSX101.amr.corp.intel.com>
References: <CAND8VyAtWDCP0XS_GraCmr9f9P6b=BYGTwsX7Tr4=9nbmen6ow@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAND8VyAtWDCP0XS_GraCmr9f9P6b=BYGTwsX7Tr4=9nbmen6ow-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kelly Burkhart <kelly.burkhart-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: "dev-x2spCj9RiN0z5UmgcLIfJQ@public.gmane.org" <dev-x2spCj9RiN0z5UmgcLIfJQ@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> Yikes!   So on a single node, if there are two independent
> applications that join then leave group membership, the first to leave
> will affect the second app?  That's surprising.  Could rdma_cm or some
> other local resource maintain a count and only really drop node
> membership when the count drops to zero?

Reference counting of multicast memberships is maintained by the kernel.  The rdma_cm will track join/leave requests correctly.  The mentioned issue only applies to applications that send their own MADs directly to the SA (i.e. use the umad interface).
 
- Sean
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
