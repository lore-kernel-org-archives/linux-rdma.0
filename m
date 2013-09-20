From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH perftest] multicast_resources.h: Guard against duplicated
 definitions of ntohll/htonll
Date: Fri, 20 Sep 2013 19:14:54 -0400
Message-ID: <523CD6EE.7050106@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ido Shamay <idos-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
diff --git a/src/multicast_resources.h b/src/multicast_resources.h
index bc85bae..1bfa043 100644
--- a/src/multicast_resources.h
+++ b/src/multicast_resources.h
@@ -80,8 +80,12 @@
 #define DEF_FLOW_LABLE                 0
 
 // Macro for 64 bit variables to switch to from net
+#ifndef ntohll
 #define ntohll(x) (((uint64_t)(ntohl((int)((x << 32) >> 32))) << 32) | (unsigned int)ntohl(((int)(x >> 32))))
+#endif
+#ifndef htonll
 #define htonll(x) ntohll(x)
+#endif
 
 // generate a bit mask S bits width
 #define MASK32(S)  ( ((uint32_t) ~0L) >> (32-(S)) )
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
