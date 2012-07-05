From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH] mcm_rereg_test.c: Fix a couple of output messages
Date: Thu, 05 Jul 2012 14:25:50 -0400
Message-ID: <4FF5DC2E.6000904@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


In rereg_send, it's not a leave but query
Fix endian of guid in rereg_send_all

Signed-off-by: Hal Rosenstock <hal-rOwS8X3CFV5BDgjK7y7TUQ@public.gmane.org>
---
diff --git a/src/mcm_rereg_test.c b/src/mcm_rereg_test.c
index ec979d7..a8cce8b 100644
--- a/src/mcm_rereg_test.c
+++ b/src/mcm_rereg_test.c
@@ -101,7 +101,9 @@ static int rereg_send(int port, int agent, ib_portid_t * dport,
 
 	build_mcm_rec_umad(umad, dport, method, comp_mask, data);
 	if (umad_send(port, agent, umad, len, TMO, 0) < 0) {
-		err("umad_send leave failed: %s\n", strerror(errno));
+		err("umad_send %s failed: %s\n",
+		    (method == IB_MAD_METHOD_GET) ? "query" : "non query",
+		    strerror(errno));
 		return -1;
 	}
 	dbg("umad_send %d: tid = 0x%016" PRIx64 "\n", method,
@@ -164,7 +166,7 @@ static int rereg_send_all(int port, int agent, ib_portid_t * dport,
 		    rereg_port_gid(port, agent, dport, umad, len, list[i].gid);
 		if (ret < 0) {
 			err("rereg_send_all: rereg_port_gid 0x%016" PRIx64
-			    " failed\n", list[i].guid);
+			    " failed\n", ntohll(list[i].guid));
 			continue;
 		}
 		list[i].trid = mad_get_field64(umad_get_mad(umad), 0,
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
