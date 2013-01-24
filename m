From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH] opensm/osm_dump.c: Remove incorrect assert
Date: Thu, 24 Jan 2013 09:45:48 -0500
Message-ID: <5101491C.9060607@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


In dump_sl2vl_tbl, no need to check remote physp for
CA and router ports. It's not used in code flow there.

Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
diff --git a/opensm/osm_dump.c b/opensm/osm_dump.c
index b29d957..69cc360 100644
--- a/opensm/osm_dump.c
+++ b/opensm/osm_dump.c
@@ -524,7 +524,6 @@ static void dump_sl2vl_tbl(cl_map_item_t * item, FILE * file, void *cxt)
 		}
 	} else {
 		p_physp = p_port->p_physp;
-		CL_ASSERT(p_physp->p_remote_physp);
 		p_tbl = osm_physp_get_slvl_tbl(p_physp, 0);
 		for (i = 0, n = 0; i < 16; i++)
 			n += sprintf(buf + n, " %-2d",
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
