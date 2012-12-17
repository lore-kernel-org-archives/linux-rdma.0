From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH] opensm/osm_dump.c: Fix output port on SL2VL table for non
 switch nodes
Date: Mon, 17 Dec 2012 11:55:31 -0500
Message-ID: <50CF4E83.6030501@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Rather than actual port number as out port, use port number 0 for out
port when CA or router as in/out ports are reserved

Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
diff --git a/opensm/osm_dump.c b/opensm/osm_dump.c
index b9bd6ed..aae6a18 100644
--- a/opensm/osm_dump.c
+++ b/opensm/osm_dump.c
@@ -529,8 +529,7 @@ static void dump_sl2vl_tbl(cl_map_item_t * item, FILE * file, void *cxt)
 		for (i = 0, n = 0; i < 16; i++)
 			n += sprintf(buf + n, " %-2d",
 					ib_slvl_table_get(p_tbl, i));
-		fprintf(file, "%-3d %-3d :%s\n",
-			0, p_physp->port_num, buf);
+		fprintf(file, "%-3d %-3d :%s\n", 0, 0, buf);
 	}
 
 	fprintf(file, "%s\n\n", separator_line);
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
