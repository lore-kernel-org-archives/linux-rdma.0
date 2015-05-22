From: arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH 5/7] dapl cma: report correct CM req private data size on query
Date: Fri, 22 May 2015 12:22:45 -0700
Message-ID: <1432322567-9349-5-git-send-email-arlin.r.davis@intel.com>
References: <1432322567-9349-1-git-send-email-arlin.r.davis@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1432322567-9349-1-git-send-email-arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Arlin Davis <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Arlin Davis <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Signed-off-by: Arlin Davis <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 dapl/openib_cma/cm.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/dapl/openib_cma/cm.c b/dapl/openib_cma/cm.c
index 79578e1..405db9a 100644
--- a/dapl/openib_cma/cm.c
+++ b/dapl/openib_cma/cm.c
@@ -1,6 +1,6 @@
 /*
  * Copyright (c) 2005 Voltaire Inc.  All rights reserved.
- * Copyright (c) 2005-2007 Intel Corporation. All rights reserved.
+ * Copyright (c) 2005-2015 Intel Corporation. All rights reserved.
  * Copyright (c) 2004-2005, Mellanox Technologies, Inc. All rights reserved. 
  * Copyright (c) 2003 Topspin Corporation.  All rights reserved. 
  * Copyright (c) 2005 Sun Microsystems, Inc. All rights reserved.
@@ -1095,7 +1095,7 @@ dapls_ib_cm_remote_addr(IN DAT_HANDLE dat_handle, OUT DAT_SOCK_ADDR6 * raddr)
  */
 int dapls_ib_private_data_size(IN DAPL_HCA * hca_ptr)
 {
-	return RDMA_MAX_PRIVATE_DATA;
+	return IB_MAX_REQ_PDATA_SIZE;
 }
 
 void dapli_cma_event_cb(void)
-- 
1.7.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
