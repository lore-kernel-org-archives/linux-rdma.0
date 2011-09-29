From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH] opensm/osmtest/osmt_multicast.c: Fix multicast flow failures
 on pkey validation
Date: Thu, 29 Sep 2011 08:49:32 -0400
Message-ID: <4E84695C.8080003@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Stan Smith <stan.smith-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org" <ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Found and fixed by Stan Smith <stan.smith-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

commit f7f1ead1b4e9bba741a0d1312513839504cab1e3 introduced an additional
pkey check into osm_sa_mcmember_record.c:mcmr_rcv_join_mgrp

subsequent commit ffdcdec8a6557088b23e273c5d605465501d2d24 fixed only
some of the pkeys in the multicast flow of osmt_multicast.c

This fixes the remainder of the multicast flow for this issue:
osmtest -f m -M1 now passes 

Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
diff --git a/osmtest/osmt_multicast.c b/osmtest/osmt_multicast.c
index 46ed93b..69d1730 100644
--- a/osmtest/osmt_multicast.c
+++ b/osmtest/osmt_multicast.c
@@ -1429,6 +1429,7 @@ ib_api_status_t osmt_run_mcast_flow(IN osmtest_t * const p_osmt)
 	/* no MGID */
 	memset(&mc_req_rec.mgid, 0, sizeof(ib_gid_t));
 	/* Request Join */
+	mc_req_rec.pkey = IB_DEFAULT_PKEY;
 	ib_member_set_join_state(&mc_req_rec, IB_MC_REC_STATE_FULL_MEMBER);
 
 	mc_req_rec.pkt_life = 0 | IB_PATH_SELECTOR_GREATER_THAN << 6;
@@ -1455,6 +1456,7 @@ ib_api_status_t osmt_run_mcast_flow(IN osmtest_t * const p_osmt)
 	/* o15.0.1.6: */
 	/* - Create a new MCG with valid requested MGID. */
 	osmt_init_mc_query_rec(p_osmt, &mc_req_rec);
+	mc_req_rec.pkey = IB_DEFAULT_PKEY;
 	mc_req_rec.mgid = good_mgid;
 
 	OSM_LOG(&p_osmt->log, OSM_LOG_INFO,
@@ -2221,6 +2223,7 @@ ib_api_status_t osmt_run_mcast_flow(IN osmtest_t * const p_osmt)
 		"\t\twith unrealistic MTU greater than 4096 (o15.0.1.8)...\n");
 
 	/* First create new mgrp */
+	mc_req_rec.pkey = IB_DEFAULT_PKEY;
 	ib_member_set_join_state(&mc_req_rec, IB_MC_REC_STATE_FULL_MEMBER);
 	mc_req_rec.mtu = IB_MTU_LEN_1024 | IB_PATH_SELECTOR_EXACTLY << 6;
 	memset(&mc_req_rec.mgid, 0, sizeof(ib_gid_t));
@@ -2308,6 +2311,7 @@ ib_api_status_t osmt_run_mcast_flow(IN osmtest_t * const p_osmt)
 	}
 
 	if (remote_port_guid != 0x0) {
+		mc_req_rec.pkey = IB_DEFAULT_PKEY;
 		ib_member_set_join_state(&mc_req_rec,
 					 IB_MC_REC_STATE_FULL_MEMBER);
 		memset(&mc_req_rec.mgid, 0, sizeof(ib_gid_t));
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
