From: "Sean Hefty" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 0/26] rdma/cm: add support for native IB addressing
Date: Thu, 1 Apr 2010 10:08:41 -0700
Message-ID: <89AE9706C9204A1CB3CFBE07EFBA2C36@amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

The following patch series extends the rdma_cm to support native
Infiniband addressing through the use of a new AF_IB address family
and RDMA_PS_IB port space.

It defines a new struct sockaddr_ib that may be used to specify an
IB GID, along with other IB address attributes, such as the pkey and
service ID.

The higher level intent is to support a user space call, rdma_getaddrinfo,
which can return AF_IB addresses to an application.  This allows the
rdma_cm to support transport specific features, such as failover and
non-reversible paths, and eliminates the need for the kernel to perform
address and route resolution.  (An implementation of rdma_getaddrinfo is included in a separate patch set to the librdmacm.)

This patch series is also available from:

	git://git.openfabrics.org/~shefty/rdma-dev.git af_ib

Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
Changes from RFC patch series:
Added RDMA_PS_IB for use with AF_IB

 drivers/infiniband/core/addr.c           |   20 +
 drivers/infiniband/core/cma.c            |  442 +++++++++++++++++++++++--------
 drivers/infiniband/core/sa_query.c       |    6
 drivers/infiniband/core/ucma.c           |  365 ++++++++++++++++++++++---
 drivers/infiniband/ulp/iser/iser_verbs.c |    2
 include/linux/socket.h                   |    2
 include/rdma/ib.h                        |   89 ++++++
 include/rdma/ib_addr.h                   |    6
 include/rdma/ib_sa.h                     |    6
 include/rdma/rdma_cm.h                   |   18 +
 include/rdma/rdma_user_cm.h              |   84 ++++-
 net/9p/trans_rdma.c                      |    3
 net/rds/ib.c                             |    2
 net/rds/ib_cm.c                          |    2
 net/rds/iw.c                             |    2
 net/rds/iw_cm.c                          |    2
 net/rds/rdma_transport.c                 |    3
 net/sunrpc/xprtrdma/svc_rdma_transport.c |    3
 net/sunrpc/xprtrdma/verbs.c              |    2
 19 files changed, 863 insertions(+), 196 deletions(-)

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
