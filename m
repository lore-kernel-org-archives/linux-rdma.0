From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH] librdmacm/man/rdma_getaddrinfo.3: Add RDMA_PS_IB to supported
 port spaces
Date: Thu, 31 May 2012 15:49:25 -0400
Message-ID: <4FC7CB45.6040608@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
diff --git a/man/rdma_getaddrinfo.3 b/man/rdma_getaddrinfo.3
index 31c233d..86e00ca 100755
--- a/man/rdma_getaddrinfo.3
+++ b/man/rdma_getaddrinfo.3
@@ -55,7 +55,8 @@ are: AF_INET, AF_INET6, and AF_IB.
 Indicates the type of RDMA QP used for communication.  Supported types are:
 IBV_UD (unreliable datagram) and IBV_RC (reliable connected).
 .IP "ai_port_space" 12
-RDMA port space in use.  Supported values are: RDMA_PS_UDP and RDMA_PS_TCP.
+RDMA port space in use.  Supported values are: RDMA_PS_UDP, RDMA_PS_TCP,
+and RDMA_PS_IB.
 .IP "ai_src_len" 12
 The length of the source address referenced by ai_src_addr.  This will be 0
 if an appropriate source address could not be discovered for a given
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
