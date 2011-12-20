From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 0/25 v2] rdma/cm: Add support for native Infiniband
 addressing
Date: Tue, 20 Dec 2011 21:49:58 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237325661C89@ORSMSX102.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Cc: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is the full patch series for adding the ability to handle native Infiniband addressing to the rdma_cm.  It is also available from:

	git://git.openfabrics.org/~shefty/rdma-dev.git af-ib

Adding support for native IB addressing allows us to offload name and/or address translation services to a user space daemon and provide the user greater control over path selection.  The primary motivation is to support large scale fabrics, with address and name services either cached or bypassed completely (information is exchanged out of band by an MPI process manager).

The intended usage model is for applications to call rdma_getaddrinfo.  This call is similar to getaddrinfo, but specific for RDMA devices.  rdma_getaddrinfo takes as input a name, IP address, GID, or LID, and returns full connection information.

The patch set introduces af_ib and sockaddr_ib.  The kernel rdma_cm is updated accordingly, mainly to make its handling of addresses more generic.  However, since sockaddr_ib is larger than sockaddr_in6, the rdma_ucm requires changes to its user to kernel interface.  To provide backwards compatibility, the userspace ABI is extended to support the larger address size.

Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

changes from v1:
Update to patch 4 to address a sparse error
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
