From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH] opensm/osm_sa_mcmember_record.c: Only use scope from MC group
 in copy_from_create_mc_rec
Date: Thu, 24 Jan 2013 09:45:41 -0500
Message-ID: <51014915.8020807@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
diff --git a/opensm/osm_sa_mcmember_record.c b/opensm/osm_sa_mcmember_record.c
index 96c1139..8099358 100644
--- a/opensm/osm_sa_mcmember_record.c
+++ b/opensm/osm_sa_mcmember_record.c
@@ -97,7 +97,8 @@ static void copy_from_create_mc_rec(IN ib_member_rec_t * dest,
 	dest->tclass = src->tclass;
 	dest->pkey = src->pkey;
 	dest->sl_flow_hop = src->sl_flow_hop;
-	dest->scope_state = src->scope_state;
+	dest->scope_state = ib_member_set_scope_state(src->scope_state >> 4,
+						      dest->scope_state & 0x0F);
 	dest->mtu = src->mtu;
 	dest->rate = src->rate;
 	dest->pkt_life = src->pkt_life;
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
