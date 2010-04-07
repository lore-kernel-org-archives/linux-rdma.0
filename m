From: "Sean Hefty" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 28/37] librdmacm: define RDMA_PS_IB
Date: Wed, 7 Apr 2010 10:12:43 -0700
Message-ID: <6BF499F0C00B4B93BA70C51F7FDAAEDA@amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
References: 
In-Reply-To: 
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

AF_IB uses the IB port space.

Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---

 include/rdma/rdma_cma.h |   12 +++++++++---
 1 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/include/rdma/rdma_cma.h b/include/rdma/rdma_cma.h
index 289b728..8f72201 100644
--- a/include/rdma/rdma_cma.h
+++ b/include/rdma/rdma_cma.h
@@ -67,11 +67,17 @@ enum rdma_cm_event_type {
 };
 
 enum rdma_port_space {
-	RDMA_PS_IPOIB= 0x0002,
-	RDMA_PS_TCP  = 0x0106,
-	RDMA_PS_UDP  = 0x0111,
+	RDMA_PS_IPOIB = 0x0002,
+	RDMA_PS_IB    = 0x0003,
+	RDMA_PS_TCP   = 0x0106,
+	RDMA_PS_UDP   = 0x0111,
 };
 
+#define RDMA_IB_IP_PS_MASK   0xFFFFFFFFFFFF0000ULL
+#define RDMA_IB_IP_PORT_MASK 0x000000000000FFFFULL
+#define RDMA_IB_IP_PS_TCP    0x0000000001060000ULL
+#define RDMA_IB_IP_PS_UDP    0x0000000001110000ULL
+
 /*
  * Global qkey value for UDP QPs and multicast groups created via the 
  * RDMA CM.



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
