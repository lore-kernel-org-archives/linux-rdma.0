From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH] osmtest/osmt_multicast.c: Fix 02BF error
Date: Wed, 05 Sep 2012 13:02:23 -0400
Message-ID: <5047859F.6020402@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


when running osmtest -f m -M 2

Reported-by: Daniel Klein <danielk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Sep 04 20:27:28 920578 [D2499700] 0x02 -> osmt_run_mcast_flow: Checking partial JoinState delete request - removing NonMember (o15.0.1.14)...
Sep 04 20:27:28 920863 [D2499700] 0x02 -> osmt_run_mcast_flow: Validating Join State removal of Non Member bit (o15.0.1.14)...
Sep 04 20:27:28 921510 [D2499700] 0x02 -> osmt_run_mcast_flow: Validating Join State update remove (o15.0.1.14)...
Sep 04 20:27:28 921518 [D2499700] 0x01 -> osmt_run_mcast_flow: ERR 02BF: Validating JoinState update failed. Expected 0x25 got: 0x20
Sep 04 20:27:28 921527 [D2499700] 0x01 -> osmtest_run: ERR 0152: Multicast Flow failed: (IB_ERROR)
OSMTEST: TEST "Multicast" FAIL

Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
diff --git a/osmtest/osmt_multicast.c b/osmtest/osmt_multicast.c
index b861ad4..052ab1a 100644
--- a/osmtest/osmt_multicast.c
+++ b/osmtest/osmt_multicast.c
@@ -2096,7 +2096,7 @@ ib_api_status_t osmt_run_mcast_flow(IN osmtest_t * const p_osmt)
 	OSM_LOG(&p_osmt->log, OSM_LOG_INFO,
 		"Validating Join State update remove (o15.0.1.14)...\n");
 
-	if (p_mc_res->scope_state != 0x25) {	/* scope is MSB - now only 0x0 so port is removed from MCG */
+	if (p_mc_res->scope_state != 0x20) {	/* scope is MSB - now only 0x0 so port is removed from MCG */
 		OSM_LOG(&p_osmt->log, OSM_LOG_ERROR, "ERR 02BF: "
 			"Validating JoinState update failed. Expected 0x25 got: 0x%02X\n",
 			p_mc_res->scope_state);
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
