From: "Davis, Arlin R" <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 4/5] dapl-2.0 - cma: remove dependency on rdma_cma_abi.h
Date: Wed, 16 Jun 2010 10:21:37 -0700
Message-ID: <E3280858FA94444CA49D2BA02341C9830103BF2436@orsmsx506.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, ofw_list <ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Signed-off-by: Arlin Davis <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 dapl/openib_cma/dapl_ib_util.h     |    8 ++++++++
 dapl/openib_cma/linux/openib_osd.h |    1 -
 2 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/dapl/openib_cma/dapl_ib_util.h b/dapl/openib_cma/dapl_ib_util.h
index 96061b3..a710195 100755
--- a/dapl/openib_cma/dapl_ib_util.h
+++ b/dapl/openib_cma/dapl_ib_util.h
@@ -47,6 +47,14 @@
 #define IB_MAX_AT_RETRY		3
 
 /* CMA private data areas, use CMA max with known transport definitions */
+#ifndef RDMA_MAX_PRIVATE_DATA
+#if defined(_WIN64) || defined(_WIN32)
+#define RDMA_MAX_PRIVATE_DATA 64 
+#else
+#define RDMA_MAX_PRIVATE_DATA 256
+#endif
+#endif
+
 #define CMA_PDATA_HDR		36
 #define	IB_MAX_REQ_PDATA_SIZE	DAPL_MIN((92-CMA_PDATA_HDR),RDMA_MAX_PRIVATE_DATA)
 #define	IB_MAX_REP_PDATA_SIZE	DAPL_MIN((196-CMA_PDATA_HDR),RDMA_MAX_PRIVATE_DATA)
diff --git a/dapl/openib_cma/linux/openib_osd.h b/dapl/openib_cma/linux/openib_osd.h
index c537df3..a67018b 100644
--- a/dapl/openib_cma/linux/openib_osd.h
+++ b/dapl/openib_cma/linux/openib_osd.h
@@ -2,7 +2,6 @@
 #define OPENIB_OSD_H
 
 #include <rdma/rdma_cma.h>
-#include <rdma/rdma_cma_abi.h>
 #include <byteswap.h>
 #include <sys/poll.h>
 
-- 
1.5.2.5

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
