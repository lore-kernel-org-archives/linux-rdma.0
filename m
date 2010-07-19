From: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: sense remote hardware address change by rdma-cm applications
Date: Tue, 20 Jul 2010 00:42:06 +0300
Message-ID: <AANLkTimmWiNqHJIqSEKbY-X6mSx6zA19p__JDYPEmp8b@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sean Hefty <mshefty-+/W+9+QloQG75v1z/vFq2g@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Today, the kernel neighbouring maintainance state-machine / engine
doesn't come into play for neighbours created on behalf of rdma-cm
consumers. This is b/c the send path is offloaded away from the
network-stack to the app QP, and as such the neighbour created
follwing the ARP request / reply initiated by rdma_resolve_address is
quickly getting aged and deleted, am I correct in that?

This behaviour makes rdma-cm RC apps to sense remote hardware address
change based only on the RC QP timeout, where UD  apps have no way
other then implementing some sort of keep-alive / probing mechanism to
make sure their AH is valid,  so how about


A. ref a neighbour created on behalf of or used by an rdma-cm ID  (*)

B. enhance the rdma-cm address_change event to report on remote
hardware address change, based on neighbour events

Or.

(*) would per ID neigh_hold() call (paired with neigh_release() when
the ID gets destroyed) work for that end?
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
