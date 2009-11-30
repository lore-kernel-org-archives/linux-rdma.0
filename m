From: Yevgeny Kliteynik <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH] opensm/osm_vendor_mlx_txn.c: eliminate bunch of compilation
 warnings
Date: Mon, 30 Nov 2009 16:41:51 +0200
Message-ID: <4B13D9AF.9040202@dev.mellanox.co.il>
Reply-To: kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>, Linux RDMA <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Eliminate bunch of compilation warnings in printing
64-bit values to log.

Signed-off-by: Yevgeny Kliteynik <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
---
 opensm/libvendor/osm_vendor_mlx_txn.c |   33 +++++++++++++++++++--------------
 1 files changed, 19 insertions(+), 14 deletions(-)

diff --git a/opensm/libvendor/osm_vendor_mlx_txn.c b/opensm/libvendor/osm_vendor_mlx_txn.c
index 6b3cb72..93d17c8 100644
--- a/opensm/libvendor/osm_vendor_mlx_txn.c
+++ b/opensm/libvendor/osm_vendor_mlx_txn.c
@@ -76,7 +76,8 @@ osmv_txn_init(IN osm_bind_handle_t h_bind,
 	CL_ASSERT(NULL != h_bind && NULL != pp_txn);

 	osm_log(p_bo->p_vendor->p_log, OSM_LOG_DEBUG,
-		"Starting transaction 0x%llX (key=0x%llX)\n", tid, key);
+		"Starting transaction 0x%016" PRIx64
+		" (key=0x%016" PRIx64 ")\n", tid, key);

 	p_txn = malloc(sizeof(osmv_txn_ctx_t));
 	if (!p_txn) {
@@ -95,7 +96,8 @@ osmv_txn_init(IN osm_bind_handle_t h_bind,
 	if (IB_SUCCESS != st) {
 		osm_log(p_bo->p_vendor->p_log, OSM_LOG_ERROR,
 			"osmv_txn_init: ERR 6703: "
-			"Failed to insert to transaction 0x%llX (key=0x%llX) to manager DB\n",
+			"Failed to insert to transaction 0x%016" PRIx64
+			" (key=0x%016" PRIx64 ") to manager DB\n",
 			tid, key);
 		goto insert_txn_failed;
 	}
@@ -371,7 +373,7 @@ __osmv_txnmgr_lookup(IN osmv_txn_mgr_t * p_tx_mgr,

 	osm_log(p_tx_mgr->p_log, OSM_LOG_DEBUG,
 		"__osmv_txnmgr_lookup: "
-		"Looking for key: 0x%llX in map ptr:%p\n", key,
+		"Looking for key: 0x%016" PRIx64 " in map ptr:%p\n", key,
 		p_tx_mgr->p_txn_map);

 	p_item = cl_qmap_head(p_tx_mgr->p_txn_map);
@@ -379,7 +381,7 @@ __osmv_txnmgr_lookup(IN osmv_txn_mgr_t * p_tx_mgr,
 		tmp_key = cl_qmap_key(p_item);
 		osm_log(p_tx_mgr->p_log, OSM_LOG_DEBUG,
 			"__osmv_txnmgr_lookup: "
-			"Found key 0x%llX \n", tmp_key);
+			"Found key 0x%016" PRIx64 "\n", tmp_key);
 		p_item = cl_qmap_next(p_item);
 	}

@@ -413,7 +415,7 @@ __osmv_txnmgr_insert_txn(IN osmv_txn_mgr_t * p_tx_mgr,

 	osm_log(p_tx_mgr->p_log, OSM_LOG_DEBUG,
 		"__osmv_txnmgr_insert_txn: "
-		"Inserting key: 0x%llX to map ptr:%p\n", key,
+		"Inserting key: 0x%016" PRIx64 " to map ptr:%p\n", key,
 		p_tx_mgr->p_txn_map);

 	memset(p_obj, 0, sizeof(cl_map_obj_t));
@@ -427,7 +429,7 @@ __osmv_txnmgr_insert_txn(IN osmv_txn_mgr_t * p_tx_mgr,
 		tmp_key = cl_qmap_key(p_item);
 		osm_log(p_tx_mgr->p_log, OSM_LOG_DEBUG,
 			"__osmv_txnmgr_insert_txn: "
-			"Found key 0x%llX \n", tmp_key);
+			"Found key 0x%016" PRIx64 "\n", tmp_key);
 		p_item = cl_qmap_next(p_item);
 	}

@@ -452,7 +454,7 @@ __osmv_txnmgr_remove_txn(IN osmv_txn_mgr_t * p_tx_mgr,

 		osm_log(p_tx_mgr->p_log, OSM_LOG_ERROR,
 			"__osmv_txnmgr_remove_txn: ERR 6701: "
-			"Could not remove the transaction 0x%llX - "
+			"Could not remove the transaction 0x%016" PRIx64 " - "
 			"something is really wrong!\n", key);
 		OSM_LOG_EXIT(p_tx_mgr->p_log);
 		return IB_NOT_FOUND;
@@ -562,8 +564,8 @@ __osmv_txn_timeout_cb(IN uint64_t key,
 			 */
 			osm_log(p_bo->p_vendor->p_log, OSM_LOG_DEBUG,
 				"__osmv_txn_timeout_cb: "
-				"The transaction request (tid=0x%llX) timed out %d times. "
-				"Retrying the send.\n",
+				"The transaction request (tid=0x%016" PRIx64 ")"
+				" timed out %d times. Retrying the send.\n",
 				osmv_txn_get_tid(p_txn), num_regs);

 			/* resend this mad */
@@ -572,7 +574,8 @@ __osmv_txn_timeout_cb(IN uint64_t key,
 			if (ret != IB_SUCCESS) {
 				osm_log(p_bo->p_vendor->p_log, OSM_LOG_ERROR,
 					"__osmv_txn_timeout_cb: "
-					"Fail to send retry for transaction request (tid=0x%llX).\n",
+					"Fail to send retry for transaction"
+					"request (tid=0x%016" PRIx64 ").\n",
 					osmv_txn_get_tid(p_txn));

 				osmv_txn_done((osm_bind_handle_t) p_bo, key,
@@ -599,7 +602,8 @@ __osmv_txn_timeout_cb(IN uint64_t key,
 		} else {
 			osm_log(p_bo->p_vendor->p_log, OSM_LOG_ERROR,
 				"__osmv_txn_timeout_cb: ERR 6702: "
-				"The transaction request (tid=0x%llX) timed out (after %d retries). "
+				"The transaction request (0x%016" PRIx64 ") "
+				"timed out (after %d retries). "
 				"Invoking the error callback.\n",
 				osmv_txn_get_tid(p_txn), num_regs);

@@ -613,7 +617,7 @@ __osmv_txn_timeout_cb(IN uint64_t key,

 	case OSMV_TXN_RMPP_SENDER:
 		osm_log(p_bo->p_vendor->p_log, OSM_LOG_DEBUG,
-			"RMPP sender (tid=0x%llX) did not receive ACK "
+			"RMPP sender (tid=0x%016" PRIx64 ") did not receive ACK "
 			"on every segment in the current send window.\n",
 			osmv_txn_get_tid(p_txn));

@@ -643,8 +647,9 @@ __osmv_txn_timeout_cb(IN uint64_t key,

 	case OSMV_TXN_RMPP_RECEIVER:
 		osm_log(p_bo->p_vendor->p_log, OSM_LOG_DEBUG,
-			"Transaction timeout on an RMPP receiver (tid=0x%llX). "
-			"Dropping the transaction.\n", osmv_txn_get_tid(p_txn));
+			"Transaction timeout on an RMPP receiver "
+			"(tid=0x%016" PRIx64 "). Dropping the transaction.\n",
+			osmv_txn_get_tid(p_txn));

 		osmv_txn_done((osm_bind_handle_t) p_bo, key,
 			      TRUE /*in timeout callback */ );
-- 
1.5.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
