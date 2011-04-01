From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH 9/11] osmtest/osmt_multicast.c: Fixed a couple of typos in
 OSM_LOG messages
Date: Fri, 01 Apr 2011 14:38:21 -0400
Message-ID: <4D961B9D.3030203@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
diff --git a/osmtest/osmt_multicast.c b/osmtest/osmt_multicast.c
index b6dfdfc..4f0deb5 100644
--- a/osmtest/osmt_multicast.c
+++ b/osmtest/osmt_multicast.c
@@ -742,7 +742,7 @@ ib_api_status_t osmt_run_mcast_flow(IN osmtest_t *
const p_osmt)
 	    ((ib_net16_t) (sa_mad->status & IB_SMP_STATUS_MASK)) !=
 	    IB_SA_MAD_STATUS_INSUF_COMPS) {
 		OSM_LOG(&p_osmt->log, OSM_LOG_ERROR, "ERR 02EE: "
-			"Expectedd REMOTE ERROR IB_SA_MAD_STATUS_INSUF_COMPS got:%s/%s\n",
+			"Expected REMOTE ERROR IB_SA_MAD_STATUS_INSUF_COMPS got:%s/%s\n",
 			ib_get_err_str(status),
 			ib_get_mad_status_str((ib_mad_t *) sa_mad));
 		status = IB_ERROR;
@@ -773,7 +773,7 @@ ib_api_status_t osmt_run_mcast_flow(IN osmtest_t *
const p_osmt)
 	    ((ib_net16_t) (sa_mad->status & IB_SMP_STATUS_MASK)) !=
 	    IB_SA_MAD_STATUS_INSUF_COMPS) {
 		OSM_LOG(&p_osmt->log, OSM_LOG_ERROR, "ERR 02ED: "
-			"Expectedd REMOTE ERROR IB_SA_MAD_STATUS_INSUF_COMPS got:%s/%s\n",
+			"Expected REMOTE ERROR IB_SA_MAD_STATUS_INSUF_COMPS got:%s/%s\n",
 			ib_get_err_str(status),
 			ib_get_mad_status_str((ib_mad_t *) sa_mad));
 		status = IB_ERROR;
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
