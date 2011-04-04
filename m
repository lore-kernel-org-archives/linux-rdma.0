From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH] opensm/osm_subnet.c: Fix description of max_msg_fifo_timeout
Date: Mon, 04 Apr 2011 14:45:58 -0400
Message-ID: <4D9A11E6.6070506@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


MAD status of BUSY is not currently sent

Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
diff --git a/opensm/osm_subnet.c b/opensm/osm_subnet.c
index 228418f..61a59e4 100644
--- a/opensm/osm_subnet.c
+++ b/opensm/osm_subnet.c
@@ -1489,7 +1489,7 @@ int osm_subn_output_conf(FILE *out, IN
osm_subn_opt_t * p_opts)
 		"# Maximal time in [msec] a message can stay in the incoming message
queue.\n"
 		"# If there is more than one message in the queue and the last message\n"
 		"# stayed in the queue more than this value, any SA request will be\n"
-		"# immediately returned with a BUSY status.\n"
+		"# immediately be dropped but BUSY status is not currently returned.\n"
 		"max_msg_fifo_timeout %u\n\n"
 		"# Use a single thread for handling SA queries\n"
 		"single_thread %s\n\n",
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
