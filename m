From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH] opensm/osm_sa_slvl_record.c: Fix out port for CAs and routers
Date: Mon, 17 Dec 2012 11:55:27 -0500
Message-ID: <50CF4E7F.6040305@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Also, no need to set in port there as already 0 due to memset

Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
diff --git a/opensm/osm_sa_slvl_record.c b/opensm/osm_sa_slvl_record.c
index 8f6d7b8..12c87f7 100644
--- a/opensm/osm_sa_slvl_record.c
+++ b/opensm/osm_sa_slvl_record.c
@@ -103,8 +103,10 @@ static void sa_slvl_create(IN osm_sa_t * sa, IN const osm_physp_t * p_physp,
 	memset(p_rec_item, 0, sizeof(*p_rec_item));
 
 	p_rec_item->rec.lid = lid;
-	p_rec_item->rec.out_port_num = osm_physp_get_port_num(p_physp);
-	p_rec_item->rec.in_port_num = in_port_idx;
+	if (p_physp->p_node->node_info.node_type == IB_NODE_TYPE_SWITCH) {
+		p_rec_item->rec.out_port_num = osm_physp_get_port_num(p_physp);
+		p_rec_item->rec.in_port_num = in_port_idx;
+	}
 	p_rec_item->rec.slvl_tbl =
 	    *(osm_physp_get_slvl_tbl(p_physp, in_port_idx));
 
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
