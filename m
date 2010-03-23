From: "Sean Hefty" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [RFC] [PATCH 0/22] [for 2.6.36] rdma/cm: add support for native IB addressing
Date: Tue, 23 Mar 2010 10:48:12 -0700
Message-ID: <2F3826558E79459EAD2A457A604221C1@amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The following patch series extends the rdma_cm to support native
Infiniband addressing through the use of a new AF_IB address family.
It defines a new struct sockaddr_ib that may be used to specify an
IB GID, along with other IB address attributes, such as the pkey and
service ID.

The higher level intent is to support a user space call, rdma_getaddrinfo,
which can return AF_IB addresses to an application.  This allows the
rdma_cm to support transport specific features, such as failover and
non-reversible paths.  (An implementation of rdma_getaddrinfo is included
in a separate patch set to the librdmacm.)

This set is very lightly tested, but I wanted to start soliciting feedback
with more extensive testing ongoing in parallel.  For more casual reviewers
of patches, the first patch in the series is probably the most important,
as it defines struct sockaddr_ib.

I think a reasonable kernel target for these patches would be 2.6.36.

Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
