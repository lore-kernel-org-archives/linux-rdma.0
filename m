From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 0/26 v3] rdma/cm: Add support for native InfiniBand
 addressing
Date: Mon, 24 Sep 2012 20:05:43 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237346A8EE01@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

I'm Sean Hefty, and I approve this message.

This patch series adds the ability to handle native Infiniband addressing
to the rdma_cm.

In addition to supporting native addresses, this support allows us to offload
name and/or address translation services to a user space daemon, providing the
user greater control over path selection.  The primary motivation is to support 
large scale fabrics, with address and name services either cached or bypassed 
completely (information is exchanged out of band by an MPI process manager).

The intended usage model is for applications to call rdma_getaddrinfo.  This 
call is similar to getaddrinfo, but specific for RDMA devices.  
rdma_getaddrinfo takes as input a name, IP address, GID, or LID, and returns 
full connection information.

The patch set introduces af_ib and sockaddr_ib.  The kernel rdma_cm is updated 
accordingly, mainly to make its handling of addresses more generic.  However, 
since sockaddr_ib is larger than sockaddr_in6, the rdma_ucm requires changes to 
its user to kernel interface.  To provide backwards compatibility, the 
userspace ABI is extended to support the larger address size.

Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

changes from v2:
updated to later kernel
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
