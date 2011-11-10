From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH] libibmad/rpc.c: On receive, add debug info for dumping incoming
 MAD address
Date: Thu, 10 Nov 2011 08:48:46 -0500
Message-ID: <4EBBD63E.7090405@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
diff --git a/src/rpc.c b/src/rpc.c
index 19a5a70..6312d42 100644
--- a/src/rpc.c
+++ b/src/rpc.c
@@ -166,6 +166,8 @@ _do_madrpc(int port_id, void *sndbuf, void *rcvbuf, int agentid, int len,
 				return -1;
 			}
 
+			if (ibdebug > 2)
+				umad_addr_dump(umad_get_mad_addr(rcvbuf));
 			if (ibdebug > 1) {
 				IBWARN("rcv buf:");
 				xdump(stderr, "rcv buf\n", umad_get_mad(rcvbuf),
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
