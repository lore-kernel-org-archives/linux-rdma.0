From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH] infiniband-diags/libibnetdisc/ibnetdisc_cache.c: Fix a couple
 of memory leaks
Date: Wed, 08 Jun 2011 08:47:34 -0400
Message-ID: <4DEF6F66.9070507@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
diff --git a/libibnetdisc/src/ibnetdisc_cache.c b/libibnetdisc/src/ibnetdisc_cache.c
index 199bf33..2690373 100644
--- a/libibnetdisc/src/ibnetdisc_cache.c
+++ b/libibnetdisc/src/ibnetdisc_cache.c
@@ -326,6 +326,7 @@ static int _load_node(int fd, ibnd_fabric_cache_t * fabric_cache)
 	node = (ibnd_node_t *) malloc(sizeof(ibnd_node_t));
 	if (!node) {
 		IBND_DEBUG("OOM: node\n");
+		free(node_cache);
 		return -1;
 	}
 	memset(node, '\0', sizeof(ibnd_node_t));
@@ -426,6 +427,7 @@ static int _load_port(int fd, ibnd_fabric_cache_t * fabric_cache)
 	port = (ibnd_port_t *) malloc(sizeof(ibnd_port_t));
 	if (!port) {
 		IBND_DEBUG("OOM: port\n");
+		free(port_cache);
 		return -1;
 	}
 	memset(port, '\0', sizeof(ibnd_port_t));
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
