From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH][TRIVIAL] opensm/cl_atomic_osd.h: Cosmetic formatting change
Date: Sun, 29 Jul 2012 07:26:30 -0400
Message-ID: <50151DE6.2010304@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
diff --git a/include/complib/cl_atomic_osd.h b/include/complib/cl_atomic_osd.h
index ac14f8a..4df9618 100644
--- a/include/complib/cl_atomic_osd.h
+++ b/include/complib/cl_atomic_osd.h
@@ -52,7 +52,9 @@
 #  define END_C_DECLS
 #endif				/* __cplusplus */
 
-BEGIN_C_DECLS extern cl_spinlock_t cl_atomic_spinlock;
+BEGIN_C_DECLS
+
+extern cl_spinlock_t cl_atomic_spinlock;
 
 static inline int32_t cl_atomic_inc(IN atomic32_t * const p_value)
 {
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
