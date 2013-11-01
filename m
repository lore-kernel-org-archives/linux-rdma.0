From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH opensm] Fix handling of get P_KeyTable on timeout
Date: Fri, 01 Nov 2013 08:10:23 -0400
Message-ID: <52739A2F.9050508@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Dan Ben-Yosef <danby-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jim Mott <jim-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Dan Ben Yosef <danby-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

if the get of pkey tbl times out, remove the node from the subnet
and indicate subnet initialization error so subnet is reswept

Signed-off-by: Dan Ben Yosef <danby-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
diff --git a/include/opensm/osm_pkey.h b/include/opensm/osm_pkey.h
index 54888e6..2ba80b3 100644
--- a/include/opensm/osm_pkey.h
+++ b/include/opensm/osm_pkey.h
@@ -90,6 +90,7 @@ typedef struct osm_pkeybl {
 	uint16_t last_pkey_idx;
 	uint16_t used_blocks;
 	uint16_t max_blocks;
+	uint16_t rcv_blocks_cnt;
 } osm_pkey_tbl_t;
 /*
 * FIELDS
@@ -119,6 +120,11 @@ typedef struct osm_pkeybl {
 *		switch_info updated on receiving the node_info or switch_info
 *		GetResp
 *
+*	rcv_blocks_cnt
+*		Counter for the received GetPKeyTable mads.
+*		For every GetPKeyTable mad we send, increase the counter,
+*		and for every GetRespPKeyTable we decrease the counter.
+*
 * NOTES
 * 'blocks' vector should be used to store pkey values obtained from
 * the port and SM pkey manager should not change it directly, for this
diff --git a/opensm/osm_drop_mgr.c b/opensm/osm_drop_mgr.c
index 4276fe9..85a6f58 100644
--- a/opensm/osm_drop_mgr.c
+++ b/opensm/osm_drop_mgr.c
@@ -500,6 +500,9 @@ void osm_drop_mgr_process(osm_sm_t * sm)
 	cl_qmap_t *p_node_guid_tbl, *p_port_guid_tbl;
 	osm_port_t *p_port, *p_next_port;
 	osm_node_t *p_node, *p_next_node;
+	int max_ports, port_num;
+	osm_physp_t *p_physp;
+	ib_net64_t port_guid;
 
 	CL_ASSERT(sm);
 
@@ -530,6 +533,28 @@ void osm_drop_mgr_process(osm_sm_t * sm)
 		 */
 		if (p_node->discovery_count == 0)
 			drop_mgr_process_node(sm, p_node);
+		else {
+			/*
+			 * Drop port if there was timeout for GetPKeyTable
+			 */
+			if (osm_node_get_type(p_node) == IB_NODE_TYPE_SWITCH)
+				port_num = 0;
+			else
+				port_num = 1;
+			max_ports = osm_node_get_num_physp(p_node);
+			for (; port_num < max_ports; port_num++) {
+				p_physp = osm_node_get_physp_ptr(p_node, port_num);
+				if (!p_physp || p_physp->pkeys.rcv_blocks_cnt == 0)
+					continue;
+				sm->p_subn->subnet_initialization_error = TRUE;
+				if (!port_num || osm_node_get_type(p_node) != IB_NODE_TYPE_SWITCH) {
+					port_guid = osm_physp_get_port_guid(p_physp);
+					p_port = osm_get_port_by_guid(sm->p_subn, port_guid);
+					p_port->discovery_count = 0;
+				} else
+					p_node->physp_discovered[port_num] = 0;
+			}
+		}
 	}
 
 	/*
diff --git a/opensm/osm_pkey.c b/opensm/osm_pkey.c
index 9e4bdd4..7a8ac0a 100644
--- a/opensm/osm_pkey.c
+++ b/opensm/osm_pkey.c
@@ -98,6 +98,7 @@ ib_api_status_t osm_pkey_tbl_init(IN osm_pkey_tbl_t * p_pkey_tbl)
 	p_pkey_tbl->last_pkey_idx = 0;
 	p_pkey_tbl->used_blocks = 0;
 	p_pkey_tbl->max_blocks = 0;
+	p_pkey_tbl->rcv_blocks_cnt = 0;
 	return IB_SUCCESS;
 }
 
diff --git a/opensm/osm_port.c b/opensm/osm_port.c
index 6e73e66..4c42fe9 100644
--- a/opensm/osm_port.c
+++ b/opensm/osm_port.c
@@ -639,6 +639,8 @@ void osm_physp_set_pkey_tbl(IN osm_log_t * p_log, IN const osm_subn_t * p_subn,
 		return;
 	}
 
+	/* decrement block received counter */
+	p_physp->pkeys.rcv_blocks_cnt--;
 	osm_pkey_tbl_set(&p_physp->pkeys, block_num, p_pkey_tbl,
 			 p_subn->opt.allow_both_pkeys);
 }
diff --git a/opensm/osm_port_info_rcv.c b/opensm/osm_port_info_rcv.c
index 1a7377a..30cd096 100644
--- a/opensm/osm_port_info_rcv.c
+++ b/opensm/osm_port_info_rcv.c
@@ -431,6 +431,7 @@ static void get_pkey_table(IN osm_log_t * p_log, IN osm_sm_t * sm,
 			      1) / IB_NUM_PKEY_ELEMENTS_IN_BLOCK;
 	}
 
+	p_physp->pkeys.rcv_blocks_cnt = max_blocks;
 	for (block_num = 0; block_num < max_blocks; block_num++) {
 		if (osm_node_get_type(p_node) != IB_NODE_TYPE_SWITCH ||
 		    osm_physp_get_port_num(p_physp) == 0) {
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
