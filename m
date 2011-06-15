From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 0/8] librdmacm: Support XRC QPs
Date: Wed, 15 Jun 2011 17:31:28 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237302129C@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Add the ability to establish communication using XRC QPs.  We
define a new port space specific for IB that will be used to
setup XRC connections.  (The new port space is not tied to any
specific QP type, so could also support UC in the future.)
Unlike the AF_IB patch set, the RDMA_PS_IB is usable with
sockaddr_sin and sockaddr_sin6 addresses.

XRC QPs are only usable through the newer librdmacm APIs:
rdma_create_ep and rdma_getaddrinfo.  Connection setup is
similar to other QPs, but additional steps are required
in order to obtain remote SRQ numbers.  Currently,
the sample apps make use of UD QP resolution for
this.  A request has been submitted to the IBTA to standardize
SRQN resolution, which is likely to result in changes in this
area.

Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
