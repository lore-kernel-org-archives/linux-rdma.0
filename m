From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: [PATCH 2.6.36] RDMA/cxgb3: Don't exceed the max HW CQ depth.
Date: Sat, 28 Aug 2010 08:35:05 -0500
Message-ID: <20100828133505.14439.81049.stgit@build.ogc.int>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

The max depth supported by T3 is 64K entries.

This bug will cause stalls and possibly crashes in large MPI clusters.

Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
---

 drivers/infiniband/hw/cxgb3/cxio_hal.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb3/cxio_hal.h b/drivers/infiniband/hw/cxgb3/cxio_hal.h
index 8f0caf7..78fbe9f 100644
--- a/drivers/infiniband/hw/cxgb3/cxio_hal.h
+++ b/drivers/infiniband/hw/cxgb3/cxio_hal.h
@@ -53,7 +53,7 @@
 #define T3_MAX_PBL_SIZE 256
 #define T3_MAX_RQ_SIZE 1024
 #define T3_MAX_QP_DEPTH (T3_MAX_RQ_SIZE-1)
-#define T3_MAX_CQ_DEPTH 262144
+#define T3_MAX_CQ_DEPTH 65536
 #define T3_MAX_NUM_STAG (1<<15)
 #define T3_MAX_MR_SIZE 0x100000000ULL
 #define T3_PAGESIZE_MASK 0xffff000  /* 4KB-128MB */

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
