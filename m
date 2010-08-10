From: Arputham Benjamin <abenjamin-sJ/iWh9BUns@public.gmane.org>
Subject: [PATCH] libibumad: Increase the limit of UMAD_MAX_DEVICES
Date: Tue, 10 Aug 2010 16:30:30 -0700
Message-ID: <4C61E116.9060204@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

ibstat command doesn't show all HCAs when the number of HCAs in one system
exceeds 20. We need to change this limit. Increase it to 32 to be consistent
with the define "IB_UVERBS_MAX_DEVICES = 32"

Signed-off-by: Arputham Benjamin <abenjamin-sJ/iWh9BUns@public.gmane.org>
---
diff -rup a/libibumad-1.3.5/include/infiniband/umad.h b/libibumad-1.3.5/include/infiniband/umad.h
--- a/libibumad-1.3.5/include/infiniband/umad.h	2010-08-10 14:45:01.611516578 -0700
+++ b/libibumad-1.3.5/include/infiniband/umad.h	2010-08-10 14:45:45.427516376 -0700
@@ -44,7 +44,7 @@
 #endif				/* __cplusplus */
 
 BEGIN_C_DECLS
-#define UMAD_MAX_DEVICES 20
+#define UMAD_MAX_DEVICES 32
 #define UMAD_ANY_PORT	0
 typedef struct ib_mad_addr {
 	uint32_t qpn;
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
