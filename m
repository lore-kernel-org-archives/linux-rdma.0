From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH opensm] Fix dropping node after setPkey mad
Date: Tue, 05 Nov 2013 13:05:28 -0500
Message-ID: <52793368.3090908@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Dan Ben-Yosef <danby-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


From: Dan Ben Yosef <danby-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Need to check pkey received counter flag only
after get mads and not set.

Signed-off-by: Dan Ben Yosef <danby-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 include/opensm/osm_port.h |    3 ++-
 opensm/osm_pkey_rcv.c     |    3 ++-
 opensm/osm_port.c         |    6 ++++--
 3 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/include/opensm/osm_port.h b/include/opensm/osm_port.h
index a1efc97..f4b7efd 100644
--- a/include/opensm/osm_port.h
+++ b/include/opensm/osm_port.h
@@ -558,7 +558,8 @@ void osm_physp_set_port_info(IN osm_physp_t * p_physp,
 void osm_physp_set_pkey_tbl(IN osm_log_t * p_log, IN const osm_subn_t * p_subn,
 			    IN osm_physp_t * p_physp,
 			    IN ib_pkey_table_t * p_pkey_tbl,
-			    IN uint16_t block_num);
+			    IN uint16_t block_num,
+			    IN boolean_t is_set);
 /*
 * PARAMETERS
 *	p_log
diff --git a/opensm/osm_pkey_rcv.c b/opensm/osm_pkey_rcv.c
index 81da39c..6650766 100644
--- a/opensm/osm_pkey_rcv.c
+++ b/opensm/osm_pkey_rcv.c
@@ -186,7 +186,8 @@ void osm_pkey_rcv_process(IN void *context, IN void *data)
 			       p_pkey_tbl, FILE_ID, OSM_LOG_DEBUG);
 
 	osm_physp_set_pkey_tbl(sm->p_log, sm->p_subn,
-			       p_physp, p_pkey_tbl, block_num);
+			       p_physp, p_pkey_tbl, block_num,
+			       p_context->set_method);
 
 Exit:
 	cl_plock_release(sm->p_lock);
diff --git a/opensm/osm_port.c b/opensm/osm_port.c
index 9dd7992..46152c5 100644
--- a/opensm/osm_port.c
+++ b/opensm/osm_port.c
@@ -646,7 +646,8 @@ boolean_t osm_link_is_healthy(IN const osm_physp_t * p_physp)
 void osm_physp_set_pkey_tbl(IN osm_log_t * p_log, IN const osm_subn_t * p_subn,
 			    IN osm_physp_t * p_physp,
 			    IN ib_pkey_table_t * p_pkey_tbl,
-			    IN uint16_t block_num)
+			    IN uint16_t block_num,
+			    IN boolean_t is_set)
 {
 	uint16_t max_blocks;
 
@@ -687,7 +688,8 @@ void osm_physp_set_pkey_tbl(IN osm_log_t * p_log, IN const osm_subn_t * p_subn,
 	}
 
 	/* decrement block received counter */
-	p_physp->pkeys.rcv_blocks_cnt--;
+	if(!is_set)
+		p_physp->pkeys.rcv_blocks_cnt--;
 	osm_pkey_tbl_set(&p_physp->pkeys, block_num, p_pkey_tbl,
 			 p_subn->opt.allow_both_pkeys);
 }
-- 
1.7.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
