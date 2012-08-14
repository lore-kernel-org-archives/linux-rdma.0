From: Yevgeny Kliteynik <kliteyn-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Subject: [PATCH 2/8] opensm/complib: define "if" statements with branch prediction
 hints
Date: Wed, 15 Aug 2012 00:32:12 +0300
Message-ID: <502AC3DC.9090102@mellanox.co.il>
Reply-To: <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linux RDMA <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Yevgeny Kliteynik <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Defined "if_PT" and "if_PF" for "predict true"
and "predict false" respectively.

Signed-off-by: Yevgeny Kliteynik <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
---
 include/complib/cl_types_osd.h | 17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

diff --git a/include/complib/cl_types_osd.h b/include/complib/cl_types_osd.h
index ce1a452..f9abb28 100644
--- a/include/complib/cl_types_osd.h
+++ b/include/complib/cl_types_osd.h
@@ -1,6 +1,6 @@
 /*
  * Copyright (c) 2004-2009 Voltaire, Inc. All rights reserved.
- * Copyright (c) 2002-2005 Mellanox Technologies LTD. All rights reserved.
+ * Copyright (c) 2002-2012 Mellanox Technologies LTD. All rights reserved.
  * Copyright (c) 1996-2003 Intel Corporation. All rights reserved.
  *
  * This software is available to you under a choice of one of two
@@ -64,6 +64,21 @@ BEGIN_C_DECLS
 #include <inttypes.h>
 #include <assert.h>
 #include <string.h>
+
+/*
+ * Branch prediction hints
+ */
+#if defined(HAVE_BUILTIN_EXPECT)
+#define CL_PREDICT_TRUE(exp)	__builtin_expect( ((uintptr_t)(exp)), 1 )
+#define CL_PREDICT_FALSE(exp)	__builtin_expect( ((uintptr_t)(exp)), 0 )
+#else
+#define CL_PREDICT_TRUE(exp)	(exp)
+#define CL_PREDICT_FALSE(exp)	(exp)
+#endif
+
+#define if_PF(cond)		if(CL_PREDICT_FALSE(cond))
+#define if_PT(cond)		if(CL_PREDICT_TRUE(cond))
+
 #if defined (_DEBUG_)
 #define CL_ASSERT	assert
 #else				/* _DEBUG_ */
-- 
1.7.11.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
