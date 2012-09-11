From: Yevgeny Kliteynik <kliteyn-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Subject: [PATCH 2/8 v2] opensm/complib: define macros for for "if" statements
 with branch prediction hints
Date: Tue, 11 Sep 2012 18:25:49 +0300
Message-ID: <504F57FD.5090703@mellanox.co.il>
Reply-To: <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Linux RDMA <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Yevgeny Kliteynik <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Defined "PT" and "PF" for "predict true"
and "predict false" respectively.

Signed-off-by: Yevgeny Kliteynik <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
---
 include/complib/cl_types_osd.h | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/include/complib/cl_types_osd.h b/include/complib/cl_types_osd.h
index ce1a452..2538913 100644
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
@@ -64,6 +64,18 @@ BEGIN_C_DECLS
 #include <inttypes.h>
 #include <assert.h>
 #include <string.h>
+
+/*
+ * Branch prediction hints
+ */
+#if defined(HAVE_BUILTIN_EXPECT)
+#define PT(exp)    __builtin_expect( ((uintptr_t)(exp)), 1 )
+#define PF(exp)    __builtin_expect( ((uintptr_t)(exp)), 0 )
+#else
+#define PT(exp)    (exp)
+#define PF(exp)    (exp)
+#endif
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
