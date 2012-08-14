From: Yevgeny Kliteynik <kliteyn-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Subject: [PATCH 8/8] opensm/osm_port_info_rcv.c: use if_PF() on fatal conditions
Date: Wed, 15 Aug 2012 00:46:01 +0300
Message-ID: <502AC719.8010806@mellanox.co.il>
Reply-To: <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linux RDMA <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Yevgeny Kliteynik <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Signed-off-by: Yevgeny Kliteynik <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
---
 opensm/osm_port_info_rcv.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/opensm/osm_port_info_rcv.c b/opensm/osm_port_info_rcv.c
index 442bc3f..829628f 100644
--- a/opensm/osm_port_info_rcv.c
+++ b/opensm/osm_port_info_rcv.c
@@ -1,6 +1,6 @@
 /*
  * Copyright (c) 2004-2009 Voltaire, Inc. All rights reserved.
- * Copyright (c) 2002-2011 Mellanox Technologies LTD. All rights reserved.
+ * Copyright (c) 2002-2012 Mellanox Technologies LTD. All rights reserved.
  * Copyright (c) 1996-2003 Intel Corporation. All rights reserved.
  * Copyright (c) 2009 HNR Consulting. All rights reserved.
  *
@@ -69,7 +69,7 @@
 static void pi_rcv_check_and_fix_lid(osm_log_t * log, ib_port_info_t * pi,
 				     osm_physp_t * p)
 {
-	if (cl_ntoh16(pi->base_lid) > IB_LID_UCAST_END_HO) {
+	if_PF (cl_ntoh16(pi->base_lid) > IB_LID_UCAST_END_HO) {
 		OSM_LOG(log, OSM_LOG_ERROR, "ERR 0F04: "
 			"Got invalid base LID %u from the network. "
 			"Corrected to %u\n", cl_ntoh16(pi->base_lid),
@@ -545,7 +545,7 @@ void osm_pi_rcv_process(IN void *context, IN void *data)

 	CL_PLOCK_EXCL_ACQUIRE(sm->p_lock);
 	p_port = osm_get_port_by_guid(sm->p_subn, port_guid);
-	if (!p_port) {
+	if_PF (!p_port) {
 		CL_PLOCK_RELEASE(sm->p_lock);
 		OSM_LOG(sm->p_log, OSM_LOG_ERROR, "ERR 0F06: "
 			"No port object for port with GUID 0x%" PRIx64
@@ -559,7 +559,7 @@ void osm_pi_rcv_process(IN void *context, IN void *data)
 	p_node = p_port->p_node;
 	CL_ASSERT(p_node);

-	if (p_pi->local_port_num > p_node->node_info.num_ports) {
+	if_PF (p_pi->local_port_num > p_node->node_info.num_ports) {
 		CL_PLOCK_RELEASE(sm->p_lock);
 		OSM_LOG(sm->p_log, OSM_LOG_ERROR, "ERR 0F15: "
 			"Received PortInfo for port GUID 0x%" PRIx64 " is "
-- 
1.7.11.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
