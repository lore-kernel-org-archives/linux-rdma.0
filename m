From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH] opensm/libvendor: Fix compile warnings on 64 bit machines
 when building --with-osmv=sim
Date: Thu, 02 Jun 2011 15:03:06 -0400
Message-ID: <4DE7DE6A.9040100@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


osm_vendor_mlx.c: In function '__osmv_get_send_txn':
osm_vendor_mlx.c:708: warning: format '%llX' expects type 'long long unsigned int', but argument 4 has type 'uint64_t'
osm_vendor_mlx.c:723: warning: format '%llX' expects type 'long long unsigned int', but argument 4 has type 'uint64_t'
osm_vendor_mlx.c:733: warning: format '%llX' expects type 'long long unsigned int', but argument 4 has type 'uint64_t'
osm_vendor_mlx.c:746: warning: format '%llX' expects type 'long long unsigned int', but argument 4 has type 'uint64_t'

osm_vendor_mlx_hca_sim.c: In function '__parse_ca_info_file':
osm_vendor_mlx_hca_sim.c:268: warning: format '%016llx' expects type 'long long unsigned int', but argument 5 has type 'uint64_t'

osm_vendor_mlx_dispatcher.c: In function '__osmv_dispatch_route':
osm_vendor_mlx_dispatcher.c:208: warning: format '%llX' expects type 'long long unsigned int', but argument 4 has type 'uint64_t'
osm_vendor_mlx_dispatcher.c:221: warning: format '%llX' expects type 'long long unsigned int', but argument 4 has type 'uint64_t'
osm_vendor_mlx_dispatcher.c: In function '__osmv_dispatch_simple_mad':
osm_vendor_mlx_dispatcher.c:276: warning: format '%llX' expects type 'long long unsigned int', but argument 4 has type 'long unsigned int'
osm_vendor_mlx_dispatcher.c: In function '__osmv_dispatch_rmpp_mad':
osm_vendor_mlx_dispatcher.c:331: warning: format '%llX' expects type 'long long unsigned int', but argument 4 has type 'uint64_t'
osm_vendor_mlx_dispatcher.c: In function '__osmv_dispatch_rmpp_rcv':
osm_vendor_mlx_dispatcher.c:570: warning: format '%llX' expects type 'long long unsigned int', but argument 4 has type 'uint64_t'
osm_vendor_mlx_dispatcher.c:624: warning: format '%llX' expects type 'long long unsigned int', but argument 5 has type 'uint64_t'
osm_vendor_mlx_dispatcher.c:629: warning: format '%llX' expects type 'long long unsigned int', but argument 4 has type 'long unsigned int'
osm_vendor_mlx_dispatcher.c: In function '__osmv_dispatch_accept_seg':
osm_vendor_mlx_dispatcher.c:661: warning: format '%llX' expects type 'long long unsigned int', but argument 4 has type 'uint64_t'
osm_vendor_mlx_dispatcher.c:674: warning: format '%llX' expects type 'long long unsigned int', but argument 4 has type 'uint64_t'

osm_vendor_mlx_sender.c: In function '__osmv_rmpp_send_segment':
osm_vendor_mlx_sender.c:345: warning: format '%llX' expects type 'long long unsigned int', but argument 5 has type 'ib_net64_t'

Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
diff --git a/libvendor/osm_vendor_mlx.c b/libvendor/osm_vendor_mlx.c
index 9ae59a9..7a40fa5 100644
--- a/libvendor/osm_vendor_mlx.c
+++ b/libvendor/osm_vendor_mlx.c
@@ -704,7 +704,7 @@ __osmv_get_send_txn(IN osm_bind_handle_t h_bind,
 		if (IB_SUCCESS != ret) {
 			osm_log(p_bo->p_vendor->p_log, OSM_LOG_ERROR,
 				"__osmv_get_send_txn: ERR 7313: "
-				"The transaction id=0x%llX failed to init.\n",
+				"The transaction id=0x%" PRIx64 " failed to init.\n",
 				tid);
 			goto get_send_txn_done;
 		}
@@ -719,7 +719,7 @@ __osmv_get_send_txn(IN osm_bind_handle_t h_bind,
 		    || FALSE == osmv_txn_is_rmpp_init_by_peer(*pp_txn)) {
 			osm_log(p_bo->p_vendor->p_log, OSM_LOG_ERROR,
 				"__osmv_get_send_txn: ERR 7314: "
-				"The transaction id=0x%llX is not unique. Send failed.\n",
+				"The transaction id=0x%" PRIx64 " is not unique. Send failed.\n",
 				tid);
 
 			ret = IB_INVALID_SETTING;
@@ -729,7 +729,7 @@ __osmv_get_send_txn(IN osm_bind_handle_t h_bind,
 		if (TRUE == resp_expected) {
 			osm_log(p_bo->p_vendor->p_log, OSM_LOG_ERROR,
 				"__osmv_get_send_txn: ERR 7315: "
-				"The transaction id=%llX can't expect a response. Send failed.\n",
+				"The transaction id=0x%" PRIx64 " can't expect a response. Send failed.\n",
 				tid);
 
 			ret = IB_INVALID_PARAMETER;
@@ -742,7 +742,7 @@ __osmv_get_send_txn(IN osm_bind_handle_t h_bind,
 		if (IB_SUCCESS != ret) {
 			osm_log(p_bo->p_vendor->p_log, OSM_LOG_ERROR,
 				"__osmv_get_send_txn: ERR 7316: "
-				"The transaction id=%llX failed to init the rmpp mad. Send failed.\n",
+				"The transaction id=0x%" PRIx64 " failed to init the rmpp mad. Send failed.\n",
 				tid);
 			osmv_txn_done(h_bind, tid, FALSE);
 			goto get_send_txn_done;
diff --git a/libvendor/osm_vendor_mlx_dispatcher.c b/libvendor/osm_vendor_mlx_dispatcher.c
index fa5fc1f..ba6c4e8 100644
--- a/libvendor/osm_vendor_mlx_dispatcher.c
+++ b/libvendor/osm_vendor_mlx_dispatcher.c
@@ -204,7 +204,7 @@ __osmv_dispatch_route(IN osm_bind_handle_t h_bind,
 
 	if (FALSE == is_txn && TRUE == is_resp) {
 		osm_log(p_bo->p_vendor->p_log, OSM_LOG_DEBUG,
-			"Received a response to a non-started/aged-out transaction (tid=0x%llX). "
+			"Received a response to a non-started/aged-out transaction (tid=0x%" PRIx64 "). "
 			"Dropping the MAD.\n", key);
 		return OSMV_ROUTE_DROP;
 	}
@@ -217,7 +217,7 @@ __osmv_dispatch_route(IN osm_bind_handle_t h_bind,
 	if (TRUE == is_txn && FALSE == is_resp) {
 		/* Does this MAD try to start a transaction with duplicate tid? */
 		osm_log(p_bo->p_vendor->p_log, OSM_LOG_DEBUG,
-			"Duplicate TID 0x%llX received (not a response). "
+			"Duplicate TID 0x%" PRIx64 " received (not a response). "
 			"Dropping the MAD.\n", key);
 
 		return OSMV_ROUTE_DROP;
@@ -272,7 +272,7 @@ __osmv_dispatch_simple_mad(IN osm_bind_handle_t h_bind,
 
 		p_mad_buf->trans_id = cl_hton64(osmv_txn_get_tid(p_txn));
 		osm_log(p_bo->p_vendor->p_log, OSM_LOG_DEBUG,
-			"Restoring the original TID to 0x%llX\n",
+			"Restoring the original TID to 0x%" PRIx64 "\n",
 			cl_ntoh64(p_mad_buf->trans_id));
 
 		/* Reply matched, transaction complete */
@@ -327,7 +327,7 @@ __osmv_dispatch_rmpp_mad(IN osm_bind_handle_t h_bind,
 
 		is_init_by_peer = TRUE;
 		osm_log(p_bo->p_vendor->p_log, OSM_LOG_DEBUG,
-			"A new sender-initiated transfer (TID=0x%llX) started\n",
+			"A new sender-initiated transfer (TID=0x%" PRIx64 ") started\n",
 			key);
 	}
 
@@ -567,7 +567,7 @@ __osmv_dispatch_rmpp_rcv(IN osm_bind_handle_t h_bind,
 
 	if (TRUE != is_last1) {
 		osm_log(p_bo->p_vendor->p_log, OSM_LOG_DEBUG,
-			"RMPP MADW assembly continues, TID=0x%llX\n", tid);
+			"RMPP MADW assembly continues, TID=0x%" PRIx64 "\n", tid);
 		goto dispatch_rmpp_rcv_done;
 	}
 
@@ -620,12 +620,12 @@ __osmv_dispatch_rmpp_rcv(IN osm_bind_handle_t h_bind,
 	}
 
 	osm_log(p_bo->p_vendor->p_log, OSM_LOG_DEBUG,
-		"RMPP MADW %p assembly complete, TID=0x%llX\n", p_new_madw,
+		"RMPP MADW %p assembly complete, TID=0x%" PRIx64 "\n", p_new_madw,
 		tid);
 
 	p_mad_buf->trans_id = cl_hton64(tid);
 	osm_log(p_bo->p_vendor->p_log, OSM_LOG_DEBUG,
-		"Restoring the original TID to 0x%llX\n",
+		"Restoring the original TID to 0x%" PRIx64 "\n",
 		cl_ntoh64(p_mad_buf->trans_id));
 
 	/* Finally, do the job! */
@@ -657,7 +657,7 @@ __osmv_dispatch_accept_seg(IN osm_bind_handle_t h_bind,
 
 	if (seg_num != p_recv_ctx->expected_seg) {
 		osm_log(p_bo->p_vendor->p_log, OSM_LOG_DEBUG,
-			"TID 0x%llX: can't accept this segment (%d) - "
+			"TID 0x%" PRIx64 ": can't accept this segment (%d) - "
 			"this is a Go-Back-N implementation\n", tid, seg_num);
 		return IB_INSUFFICIENT_RESOURCES;
 	}
@@ -671,7 +671,7 @@ __osmv_dispatch_accept_seg(IN osm_bind_handle_t h_bind,
 	}
 
 	osm_log(p_bo->p_vendor->p_log, OSM_LOG_DEBUG,
-		"TID 0x%llX: segment %d accepted\n", tid, seg_num);
+		"TID 0x%" PRIx64 ": segment %d accepted\n", tid, seg_num);
 	p_recv_ctx->expected_seg = seg_num + 1;
 
 	OSM_LOG_EXIT(p_bo->p_vendor->p_log);
diff --git a/libvendor/osm_vendor_mlx_hca_sim.c b/libvendor/osm_vendor_mlx_hca_sim.c
index c5e2106..15df23e 100644
--- a/libvendor/osm_vendor_mlx_hca_sim.c
+++ b/libvendor/osm_vendor_mlx_hca_sim.c
@@ -264,7 +264,7 @@ __parse_ca_info_file(IN osm_vendor_t * const p_vend,
 
 	osm_log(p_vend->p_log, OSM_LOG_DEBUG,
 		"__parse_ca_info_file: "
-		"CA1 = name:%s guid:0x%016llx ports:%d\n",
+		"CA1 = name:%s guid:0x%" PRIx64 " ports:%d\n",
 		sim_ca_info->name, sim_ca_info->guid, sim_ca_info->num_ports);
 
 	status = IB_SUCCESS;
diff --git a/libvendor/osm_vendor_mlx_sender.c b/libvendor/osm_vendor_mlx_sender.c
index fc1bf32..319a54e 100644
--- a/libvendor/osm_vendor_mlx_sender.c
+++ b/libvendor/osm_vendor_mlx_sender.c
@@ -341,7 +341,7 @@ __osmv_rmpp_send_segment(IN osm_bind_handle_t h_bind,
 		p_mad->trans_id = cl_hton64(key);
 
 		osm_log(p_bo->p_vendor->p_log, OSM_LOG_DEBUG,
-			"Sending RMPP segment #%d, on-wire TID=0x%llX\n",
+			"Sending RMPP segment #%d, on-wire TID=0x%" PRIx64 "\n",
 			seg_num, p_mad->trans_id);
 
 		/*
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
