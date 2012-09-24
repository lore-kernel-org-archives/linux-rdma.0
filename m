From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 12/26 v3] rdma/cm: Add support for AF_IB to
 cma_get_service_id
Date: Mon, 24 Sep 2012 20:05:49 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237346A8EE6B@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

cma_get_service_id forms the service ID based on the port space
and port number of the rdma_cm_id.  Extend the call to support
AF_IB, which contains the service ID directly.  This will
be needed to support any arbitrary SID.

Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/core/cma.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
index cd4e197..4e205db 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -1374,6 +1374,9 @@ err1:
 
 static __be64 cma_get_service_id(enum rdma_port_space ps, struct sockaddr *addr)
 {
+	if (addr->sa_family == AF_IB)
+		return ((struct sockaddr_ib *) addr)->sib_sid;
+
 	return cpu_to_be64(((u64)ps << 16) + be16_to_cpu(cma_port(addr)));
 }
 


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
