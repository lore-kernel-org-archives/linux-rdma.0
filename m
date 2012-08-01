From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: [PATCH] opensm/perfmgr: update new error codes to '54' prefix
Date: Wed, 1 Aug 2012 15:36:33 -0700
Message-ID: <20120801153633.1c76a894a8db267e8333fb53@llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



Signed-off-by: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
---
 opensm/osm_perfmgr.c |   26 +++++++++++++-------------
 1 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/opensm/osm_perfmgr.c b/opensm/osm_perfmgr.c
index 32357d9..ee2392c 100644
--- a/opensm/osm_perfmgr.c
+++ b/opensm/osm_perfmgr.c
@@ -1095,18 +1095,18 @@ static void perfmgr_log_errors(osm_perfmgr_t * pm,
 			reading->counter_name - prev_read.counter_name, \
 			mon_node->name, mon_node->guid, port);
 
-	LOG_ERR_CNT("SymbolErrorCounter",           "4C31", symbol_err_cnt);
-	LOG_ERR_CNT("LinkErrorRecoveryCounter",     "4C32", link_err_recover);
-	LOG_ERR_CNT("LinkDownedCounter",            "4C33", link_downed);
-	LOG_ERR_CNT("PortRcvErrors",                "4C34", rcv_err);
-	LOG_ERR_CNT("PortRcvRemotePhysicalErrors",  "4C35", rcv_rem_phys_err);
-	LOG_ERR_CNT("PortRcvSwitchRelayErrors",     "4C36", rcv_switch_relay_err);
-	LOG_ERR_CNT("PortXmitDiscards",             "4C37", xmit_discards);
-	LOG_ERR_CNT("PortXmitConstraintErrors",     "4C38", xmit_constraint_err);
-	LOG_ERR_CNT("PortRcvConstraintErrors",      "4C39", rcv_constraint_err);
-	LOG_ERR_CNT("LocalLinkIntegrityErrors",     "4C3A", link_integrity);
-	LOG_ERR_CNT("ExcessiveBufferOverrunErrors", "4C3B", buffer_overrun);
-	LOG_ERR_CNT("VL15Dropped",                  "4C3C", vl15_dropped);
+	LOG_ERR_CNT("SymbolErrorCounter",           "5431", symbol_err_cnt);
+	LOG_ERR_CNT("LinkErrorRecoveryCounter",     "5432", link_err_recover);
+	LOG_ERR_CNT("LinkDownedCounter",            "5433", link_downed);
+	LOG_ERR_CNT("PortRcvErrors",                "5434", rcv_err);
+	LOG_ERR_CNT("PortRcvRemotePhysicalErrors",  "5435", rcv_rem_phys_err);
+	LOG_ERR_CNT("PortRcvSwitchRelayErrors",     "5436", rcv_switch_relay_err);
+	LOG_ERR_CNT("PortXmitDiscards",             "5437", xmit_discards);
+	LOG_ERR_CNT("PortXmitConstraintErrors",     "5438", xmit_constraint_err);
+	LOG_ERR_CNT("PortRcvConstraintErrors",      "5439", rcv_constraint_err);
+	LOG_ERR_CNT("LocalLinkIntegrityErrors",     "543A", link_integrity);
+	LOG_ERR_CNT("ExcessiveBufferOverrunErrors", "543B", buffer_overrun);
+	LOG_ERR_CNT("VL15Dropped",                  "543C", vl15_dropped);
 }
 
 static int16_t validate_redir_pkey(osm_perfmgr_t *pm, ib_net16_t pkey)
@@ -1152,7 +1152,7 @@ static int16_t validate_redir_pkey(osm_perfmgr_t *pm, ib_net16_t pkey)
 		} else {
 			CL_PLOCK_RELEASE(pm->sm->p_lock);
 			OSM_LOG(pm->log, OSM_LOG_ERROR,
-				"ERR 0x4C1F: Failed to obtain P_Key 0x%04x "
+				"ERR 541F: Failed to obtain P_Key 0x%04x "
 				"block and index for PerfMgr port\n",
 				cl_ntoh16(pkey));
 		}
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
