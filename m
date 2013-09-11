From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH librdmacm] man/rdma_create_id.3: Add RDMA_PS_IB port space
 description
Date: Wed, 11 Sep 2013 14:44:28 -0400
Message-ID: <5230BA0C.4080504@dev.mellanox.co.il>
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
diff --git a/man/rdma_create_id.3 b/man/rdma_create_id.3
index da333fb..81acc9b 100644
--- a/man/rdma_create_id.3
+++ b/man/rdma_create_id.3
@@ -47,6 +47,8 @@ port space provides message, not stream, based communication.
 .IP RDMA_PS_UDP
 Provides unreliable, connectionless QP communication.  Supports both datagram
 and multicast communication.
+.IP RDMA_PS_IB
+Provides for any IB services (UD, UC, RC, XRC, etc.).
 .SH "SEE ALSO"
 rdma_cm(7), rdma_create_event_channel(3), rdma_destroy_id(3), rdma_get_devices(3),
 rdma_bind_addr(3), rdma_resolve_addr(3), rdma_connect(3), rdma_listen(3),
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
