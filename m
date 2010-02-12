From: "Sean Hefty" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RFC for defining and using AF_IB
Date: Thu, 11 Feb 2010 17:17:30 -0800
Message-ID: <254A1EF506C448E68EA2FBFC7D11D9F6@amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

I want to restart a discussion on adding AF_IB to the rdma_cm.  See the thread
below for more details:

http://www.mail-archive.com/linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org/msg00279.html

In short, AF_IB would allow a user of the rdma_cm to specify native IB
addresses.   Transport neutrality would be maintained by adding a call such as
rdma_getaddrinfo.

I'm specifically asking for ideas on what fields sockaddr_ib should contain, the
use of AF_IB within the rdma_cm, and the definition of IB port space
(RDMA_PS_IB).  I've tried to identify relevant rdma_cm functionality:

rdma_create_id
Specifies a port space, which is used in constructing the SID.
Active: The post space controls the operation of rdma_connect.

rdma_bind_addr
May select a local device based on GID.
Passive: Also selects a port number, which constructs the SID.

rdma_resolve_addr
Calls bind.
Active: Constructs remote SID

rdma_resolve_route
PR query using GIDs, SID, and QoS data.

One issue is that IB has a single SID range, but the rdma_cm needs to know
whether to establish a connection or perform SIDR.  A single RDMA_PS_IB is
insufficient for this purpose.  A more minor observation is that sockaddr_in6
contains a flowinfo field, which could be used by rdma_resolve_route to perform
a PR query.  (I point this out because sockaddr_in6 is a reasonable starting
point for a definition for sockaddr_ib.)  Use of AF_IB may involve manually
setting the path record, but that shouldn't be required.  I'd also like for IBoE
to be able to use AF_IB when it makes it into the kernel.

- Sean

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
