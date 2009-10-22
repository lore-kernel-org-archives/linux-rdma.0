From: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: [PATCH] osmtest/osmt_multicast: kill some duplications
Date: Thu, 22 Oct 2009 13:04:58 +0200
Message-ID: <20091022110458.GX20210@me>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Kill variable p_recvd_rec which duplicates p_mc_res. Remove a lot of
repeated re-initializations.

Signed-off-by: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
---
 opensm/osmtest/osmt_multicast.c |  151 +++++++++++----------------------------
 1 files changed, 43 insertions(+), 108 deletions(-)

diff --git a/opensm/osmtest/osmt_multicast.c b/opensm/osmtest/osmt_multicast.c
index 8a3342c..6b56ffd 100644
--- a/opensm/osmtest/osmt_multicast.c
+++ b/opensm/osmtest/osmt_multicast.c
@@ -488,7 +488,6 @@ ib_api_status_t osmt_run_mcast_flow(IN osmtest_t * const p_osmt)
 	uint32_t num_recs = 0, i;
 	uint8_t mtu_phys = 0, rate_phys = 0;
 	cl_map_t test_created_mlids;	/* List of all mlids created in this test */
-	ib_member_rec_t *p_recvd_rec;
 	boolean_t got_error = FALSE;
 
 	static ib_gid_t good_mgid = {
@@ -631,7 +630,6 @@ ib_api_status_t osmt_run_mcast_flow(IN osmtest_t * const p_osmt)
 			goto Exit;
 		}
 		/* Check MTU & Rate Value and resend with SA suggested values */
-		p_mc_res = ib_sa_mad_get_payload_ptr(&res_sa_mad);
 
 		/* Prepare the mc_req_rec for the rest of the flow */
 		osmt_init_mc_query_rec(p_osmt, &mc_req_rec);
@@ -809,8 +807,6 @@ ib_api_status_t osmt_run_mcast_flow(IN osmtest_t * const p_osmt)
 
 	mc_req_rec.mgid.raw[15] = 0x01;
 
-	p_mc_res = ib_sa_mad_get_payload_ptr(&res_sa_mad);
-
 	OSM_LOG(&p_osmt->log, OSM_LOG_INFO,
 		"Checking Join with insufficient comp mask - flow label (o15.0.1.3)...\n");
 
@@ -843,8 +839,6 @@ ib_api_status_t osmt_run_mcast_flow(IN osmtest_t * const p_osmt)
 
 	osmt_init_mc_query_rec(p_osmt, &mc_req_rec);
 
-	p_mc_res = ib_sa_mad_get_payload_ptr(&res_sa_mad);
-
 	OSM_LOG(&p_osmt->log, OSM_LOG_INFO,
 		"Checking Join with insufficient comp mask - tclass (o15.0.1.3)...\n");
 
@@ -879,8 +873,6 @@ ib_api_status_t osmt_run_mcast_flow(IN osmtest_t * const p_osmt)
 
 	osmt_init_mc_query_rec(p_osmt, &mc_req_rec);
 
-	p_mc_res = ib_sa_mad_get_payload_ptr(&res_sa_mad);
-
 	OSM_LOG(&p_osmt->log, OSM_LOG_INFO,
 		"Checking Join with insufficient comp mask - tclass qkey (o15.0.1.3)...\n");
 
@@ -1105,8 +1097,6 @@ ib_api_status_t osmt_run_mcast_flow(IN osmtest_t * const p_osmt)
 
 	osmt_init_mc_query_rec(p_osmt, &mc_req_rec);
 
-	p_mc_res = ib_sa_mad_get_payload_ptr(&res_sa_mad);
-
 	/* no MGID */
 	memset(&mc_req_rec.mgid, 0, sizeof(ib_gid_t));
 	/* Request Join */
@@ -1166,8 +1156,6 @@ ib_api_status_t osmt_run_mcast_flow(IN osmtest_t * const p_osmt)
 
 	osmt_init_mc_query_rec(p_osmt, &mc_req_rec);
 
-	p_mc_res = ib_sa_mad_get_payload_ptr(&res_sa_mad);
-
 	/* no MGID */
 	memset(&mc_req_rec.mgid, 0, sizeof(ib_gid_t));
 	/* Request Join */
@@ -1204,8 +1192,6 @@ ib_api_status_t osmt_run_mcast_flow(IN osmtest_t * const p_osmt)
 
 	osmt_init_mc_query_rec(p_osmt, &mc_req_rec);
 
-	p_mc_res = ib_sa_mad_get_payload_ptr(&res_sa_mad);
-
 	/* no MGID */
 	memset(&mc_req_rec.mgid, 0, sizeof(ib_gid_t));
 	/* Request Join */
@@ -1264,13 +1250,10 @@ ib_api_status_t osmt_run_mcast_flow(IN osmtest_t * const p_osmt)
 	}
 
 	/* Save the mlid created in test_created_mlids map */
-	p_recvd_rec =
-	    (ib_member_rec_t *) ib_sa_mad_get_payload_ptr(&res_sa_mad);
 	OSM_LOG(&p_osmt->log, OSM_LOG_VERBOSE, "created MGID:%s MLID:0x%04X\n",
-		inet_ntop(AF_INET6, p_recvd_rec->mgid.raw, gid_str,
-			  sizeof gid_str), cl_ntoh16(p_recvd_rec->mlid));
-	cl_map_insert(&test_created_mlids, cl_ntoh16(p_recvd_rec->mlid),
-		      p_recvd_rec);
+		inet_ntop(AF_INET6, p_mc_res->mgid.raw, gid_str,
+			  sizeof gid_str), cl_ntoh16(p_mc_res->mlid));
+	cl_map_insert(&test_created_mlids, cl_ntoh16(p_mc_res->mlid), p_mc_res);
 
 	/* Good Flow - mgid is 0 while giving all required fields for join : P_Key, Q_Key, SL, FlowLabel, Tclass */
 
@@ -1291,13 +1274,10 @@ ib_api_status_t osmt_run_mcast_flow(IN osmtest_t * const p_osmt)
 	}
 
 	/* Save the mlid created in test_created_mlids map */
-	p_recvd_rec =
-	    (ib_member_rec_t *) ib_sa_mad_get_payload_ptr(&res_sa_mad);
 	OSM_LOG(&p_osmt->log, OSM_LOG_VERBOSE, "Created MGID:%s MLID:0x%04X\n",
-		inet_ntop(AF_INET6, p_recvd_rec->mgid.raw, gid_str,
-			  sizeof gid_str), cl_ntoh16(p_recvd_rec->mlid));
-	cl_map_insert(&test_created_mlids, cl_ntoh16(p_recvd_rec->mlid),
-		      p_recvd_rec);
+		inet_ntop(AF_INET6, p_mc_res->mgid.raw, gid_str,
+			  sizeof gid_str), cl_ntoh16(p_mc_res->mlid));
+	cl_map_insert(&test_created_mlids, cl_ntoh16(p_mc_res->mlid), p_mc_res);
 
 	/* Good Flow - mgid is 0 while giving all required fields for join : P_Key, Q_Key, SL, FlowLabel, Tclass */
 
@@ -1317,13 +1297,10 @@ ib_api_status_t osmt_run_mcast_flow(IN osmtest_t * const p_osmt)
 	}
 
 	/* Save the mlid created in test_created_mlids map */
-	p_recvd_rec =
-	    (ib_member_rec_t *) ib_sa_mad_get_payload_ptr(&res_sa_mad);
 	OSM_LOG(&p_osmt->log, OSM_LOG_VERBOSE, "Created MGID:%s MLID:0x%04X\n",
-		inet_ntop(AF_INET6, p_recvd_rec->mgid.raw, gid_str,
-			  sizeof gid_str), cl_ntoh16(p_recvd_rec->mlid));
-	cl_map_insert(&test_created_mlids, cl_ntoh16(p_recvd_rec->mlid),
-		      p_recvd_rec);
+		inet_ntop(AF_INET6, p_mc_res->mgid.raw, gid_str,
+			  sizeof gid_str), cl_ntoh16(p_mc_res->mlid));
+	cl_map_insert(&test_created_mlids, cl_ntoh16(p_mc_res->mlid), p_mc_res);
 
 	/* Good Flow - mgid is 0 while giving all required fields for join : P_Key, Q_Key, SL, FlowLabel, Tclass */
 	mc_req_rec.mtu = IB_MTU_LEN_256 | IB_PATH_SELECTOR_GREATER_THAN << 6;
@@ -1342,13 +1319,10 @@ ib_api_status_t osmt_run_mcast_flow(IN osmtest_t * const p_osmt)
 	}
 
 	/* Save the mlid created in test_created_mlids map */
-	p_recvd_rec =
-	    (ib_member_rec_t *) ib_sa_mad_get_payload_ptr(&res_sa_mad);
 	OSM_LOG(&p_osmt->log, OSM_LOG_VERBOSE, "Created MGID:%s MLID:0x%04X\n",
-		inet_ntop(AF_INET6, p_recvd_rec->mgid.raw, gid_str,
-			  sizeof gid_str), cl_ntoh16(p_recvd_rec->mlid));
-	cl_map_insert(&test_created_mlids, cl_ntoh16(p_recvd_rec->mlid),
-		      p_recvd_rec);
+		inet_ntop(AF_INET6, p_mc_res->mgid.raw, gid_str,
+			  sizeof gid_str), cl_ntoh16(p_mc_res->mlid));
+	cl_map_insert(&test_created_mlids, cl_ntoh16(p_mc_res->mlid), p_mc_res);
 
 	/* Good Flow - mgid is 0 while giving all required fields for join : P_Key, Q_Key, SL, FlowLabel, Tclass */
 	/* Using Exact feasible MTU & RATE */
@@ -1377,13 +1351,10 @@ ib_api_status_t osmt_run_mcast_flow(IN osmtest_t * const p_osmt)
 	}
 
 	/* Save the mlid created in test_created_mlids map */
-	p_recvd_rec =
-	    (ib_member_rec_t *) ib_sa_mad_get_payload_ptr(&res_sa_mad);
 	OSM_LOG(&p_osmt->log, OSM_LOG_VERBOSE, "Created MGID:%s MLID:0x%04X\n",
-		inet_ntop(AF_INET6, p_recvd_rec->mgid.raw, gid_str,
-			  sizeof gid_str), cl_ntoh16(p_recvd_rec->mlid));
-	cl_map_insert(&test_created_mlids, cl_ntoh16(p_recvd_rec->mlid),
-		      p_recvd_rec);
+		inet_ntop(AF_INET6, p_mc_res->mgid.raw, gid_str,
+			  sizeof gid_str), cl_ntoh16(p_mc_res->mlid));
+	cl_map_insert(&test_created_mlids, cl_ntoh16(p_mc_res->mlid), p_mc_res);
 
 	/* Good Flow - mgid is 0 while giving all required fields for join : P_Key, Q_Key, SL, FlowLabel, Tclass */
 	/* Using Exact feasible RATE */
@@ -1407,13 +1378,10 @@ ib_api_status_t osmt_run_mcast_flow(IN osmtest_t * const p_osmt)
 	}
 
 	/* Save the mlid created in test_created_mlids map */
-	p_recvd_rec =
-	    (ib_member_rec_t *) ib_sa_mad_get_payload_ptr(&res_sa_mad);
 	OSM_LOG(&p_osmt->log, OSM_LOG_VERBOSE, "Created MGID:%s MLID:0x%04X\n",
-		inet_ntop(AF_INET6, p_recvd_rec->mgid.raw, gid_str,
-			  sizeof gid_str), cl_ntoh16(p_recvd_rec->mlid));
-	cl_map_insert(&test_created_mlids, cl_ntoh16(p_recvd_rec->mlid),
-		      p_recvd_rec);
+		inet_ntop(AF_INET6, p_mc_res->mgid.raw, gid_str,
+			  sizeof gid_str), cl_ntoh16(p_mc_res->mlid));
+	cl_map_insert(&test_created_mlids, cl_ntoh16(p_mc_res->mlid), p_mc_res);
 
 	/* Good Flow - mgid is 0 while giving all required fields for join : P_Key, Q_Key, SL, FlowLabel, Tclass */
 	/* Using Exact feasible MTU */
@@ -1437,13 +1405,10 @@ ib_api_status_t osmt_run_mcast_flow(IN osmtest_t * const p_osmt)
 	}
 
 	/* Save the mlid created in test_created_mlids map */
-	p_recvd_rec =
-	    (ib_member_rec_t *) ib_sa_mad_get_payload_ptr(&res_sa_mad);
 	OSM_LOG(&p_osmt->log, OSM_LOG_VERBOSE, "Created MGID:%s MLID:0x%04X\n",
-		inet_ntop(AF_INET6, p_recvd_rec->mgid.raw, gid_str,
-			  sizeof gid_str), cl_ntoh16(p_recvd_rec->mlid));
-	cl_map_insert(&test_created_mlids, cl_ntoh16(p_recvd_rec->mlid),
-		      p_recvd_rec);
+		inet_ntop(AF_INET6, p_mc_res->mgid.raw, gid_str,
+			  sizeof gid_str), cl_ntoh16(p_mc_res->mlid));
+	cl_map_insert(&test_created_mlids, cl_ntoh16(p_mc_res->mlid), p_mc_res);
 
 	/* o15.0.1.5: */
 	/* - Check the returned MGID is valid. (p 804) */
@@ -1473,8 +1438,6 @@ ib_api_status_t osmt_run_mcast_flow(IN osmtest_t * const p_osmt)
 
 	osmt_init_mc_query_rec(p_osmt, &mc_req_rec);
 
-	p_mc_res = ib_sa_mad_get_payload_ptr(&res_sa_mad);
-
 	/* no MGID */
 	memset(&mc_req_rec.mgid, 0, sizeof(ib_gid_t));
 	/* Request Join */
@@ -1496,13 +1459,10 @@ ib_api_status_t osmt_run_mcast_flow(IN osmtest_t * const p_osmt)
 	}
 
 	/* Save the mlid created in test_created_mlids map */
-	p_recvd_rec =
-	    (ib_member_rec_t *) ib_sa_mad_get_payload_ptr(&res_sa_mad);
 	OSM_LOG(&p_osmt->log, OSM_LOG_VERBOSE, "Created MGID:%s MLID:0x%04X\n",
-		inet_ntop(AF_INET6, p_recvd_rec->mgid.raw, gid_str,
-			  sizeof gid_str), cl_ntoh16(p_recvd_rec->mlid));
-	cl_map_insert(&test_created_mlids, cl_ntoh16(p_recvd_rec->mlid),
-		      p_recvd_rec);
+		inet_ntop(AF_INET6, p_mc_res->mgid.raw, gid_str,
+			  sizeof gid_str), cl_ntoh16(p_mc_res->mlid));
+	cl_map_insert(&test_created_mlids, cl_ntoh16(p_mc_res->mlid), p_mc_res);
 
 	/* o15.0.1.6: */
 	/* - Create a new MCG with valid requested MGID. */
@@ -1555,13 +1515,10 @@ ib_api_status_t osmt_run_mcast_flow(IN osmtest_t * const p_osmt)
 	}
 
 	/* Save the mlid created in test_created_mlids map */
-	p_recvd_rec =
-	    (ib_member_rec_t *) ib_sa_mad_get_payload_ptr(&res_sa_mad);
 	OSM_LOG(&p_osmt->log, OSM_LOG_VERBOSE, "Created MGID:%s MLID:0x%04X\n",
-		inet_ntop(AF_INET6, p_recvd_rec->mgid.raw, gid_str,
-			  sizeof gid_str), cl_ntoh16(p_recvd_rec->mlid));
-	cl_map_insert(&test_created_mlids, cl_ntoh16(p_recvd_rec->mlid),
-		      p_recvd_rec);
+		inet_ntop(AF_INET6, p_mc_res->mgid.raw, gid_str,
+			  sizeof gid_str), cl_ntoh16(p_mc_res->mlid));
+	cl_map_insert(&test_created_mlids, cl_ntoh16(p_mc_res->mlid), p_mc_res);
 
 	OSM_LOG(&p_osmt->log, OSM_LOG_INFO,
 		"Validating resulting MGID (o15.0.1.6)...\n");
@@ -1669,13 +1626,10 @@ ib_api_status_t osmt_run_mcast_flow(IN osmtest_t * const p_osmt)
 	}
 
 	/* Save the mlid created in test_created_mlids map */
-	p_recvd_rec =
-	    (ib_member_rec_t *) ib_sa_mad_get_payload_ptr(&res_sa_mad);
 	OSM_LOG(&p_osmt->log, OSM_LOG_VERBOSE, "Created MGID:%s MLID:0x%04X\n",
-		inet_ntop(AF_INET6, p_recvd_rec->mgid.raw, gid_str,
-			  sizeof gid_str), cl_ntoh16(p_recvd_rec->mlid));
-	cl_map_insert(&test_created_mlids, cl_ntoh16(p_recvd_rec->mlid),
-		      p_recvd_rec);
+		inet_ntop(AF_INET6, p_mc_res->mgid.raw, gid_str,
+			  sizeof gid_str), cl_ntoh16(p_mc_res->mlid));
+	cl_map_insert(&test_created_mlids, cl_ntoh16(p_mc_res->mlid), p_mc_res);
 
 	/* Change the flags to invalid value 0x2 - get back INVALID REQ */
 
@@ -1721,13 +1675,10 @@ ib_api_status_t osmt_run_mcast_flow(IN osmtest_t * const p_osmt)
 	}
 
 	/* Save the mlid created in test_created_mlids map */
-	p_recvd_rec =
-	    (ib_member_rec_t *) ib_sa_mad_get_payload_ptr(&res_sa_mad);
 	OSM_LOG(&p_osmt->log, OSM_LOG_VERBOSE, "Created MGID:%s MLID:0x%04X\n",
-		inet_ntop(AF_INET6, p_recvd_rec->mgid.raw, gid_str,
-			  sizeof gid_str), cl_ntoh16(p_recvd_rec->mlid));
-	cl_map_insert(&test_created_mlids, cl_ntoh16(p_recvd_rec->mlid),
-		      p_recvd_rec);
+		inet_ntop(AF_INET6, p_mc_res->mgid.raw, gid_str,
+			  sizeof gid_str), cl_ntoh16(p_mc_res->mlid));
+	cl_map_insert(&test_created_mlids, cl_ntoh16(p_mc_res->mlid), p_mc_res);
 
 	/* o15.0.1.7 - implicitlly checked during the prev steps. */
 	/* o15.0.1.8 - implicitlly checked during the prev steps. */
@@ -1777,13 +1728,10 @@ ib_api_status_t osmt_run_mcast_flow(IN osmtest_t * const p_osmt)
 	}
 
 	/* Save the mlid created in test_created_mlids map */
-	p_recvd_rec =
-	    (ib_member_rec_t *) ib_sa_mad_get_payload_ptr(&res_sa_mad);
 	OSM_LOG(&p_osmt->log, OSM_LOG_VERBOSE, "Created MGID:%s MLID:0x%04X\n",
-		inet_ntop(AF_INET6, p_recvd_rec->mgid.raw, gid_str,
-			  sizeof gid_str), cl_ntoh16(p_recvd_rec->mlid));
-	cl_map_insert(&test_created_mlids, cl_ntoh16(p_recvd_rec->mlid),
-		      p_recvd_rec);
+		inet_ntop(AF_INET6, p_mc_res->mgid.raw, gid_str,
+			  sizeof gid_str), cl_ntoh16(p_mc_res->mlid));
+	cl_map_insert(&test_created_mlids, cl_ntoh16(p_mc_res->mlid), p_mc_res);
 
 	/* Lets try another invalid join scope state */
 	OSM_LOG(&p_osmt->log, OSM_LOG_INFO,
@@ -1832,18 +1780,14 @@ ib_api_status_t osmt_run_mcast_flow(IN osmtest_t * const p_osmt)
 	}
 
 	/* Save the mlid created in test_created_mlids map */
-	p_recvd_rec =
-	    (ib_member_rec_t *) ib_sa_mad_get_payload_ptr(&res_sa_mad);
 	OSM_LOG(&p_osmt->log, OSM_LOG_VERBOSE, "Created MGID:%s MLID:0x%04X\n",
-		inet_ntop(AF_INET6, p_recvd_rec->mgid.raw, gid_str,
-			  sizeof gid_str), cl_ntoh16(p_recvd_rec->mlid));
-	cl_map_insert(&test_created_mlids, cl_ntoh16(p_recvd_rec->mlid),
-		      p_recvd_rec);
+		inet_ntop(AF_INET6, p_mc_res->mgid.raw, gid_str,
+			  sizeof gid_str), cl_ntoh16(p_mc_res->mlid));
+	cl_map_insert(&test_created_mlids, cl_ntoh16(p_mc_res->mlid), p_mc_res);
 
 	/* o15.0.1.10 - can't check on a single client .-- obsolete -
 	   checked by SilverStorm bug o15-0.2.4, never the less recheck */
 	/* o15-0.2.4 - Check a join request to already created MCG */
-	p_mc_res = ib_sa_mad_get_payload_ptr(&res_sa_mad);
 	OSM_LOG(&p_osmt->log, OSM_LOG_INFO, "Check o15-0.2.4 statement...\n");
 	/* Try to join */
 	memcpy(&mc_req_rec.mgid, &p_mc_res->mgid, sizeof(ib_gid_t));
@@ -1862,7 +1806,6 @@ ib_api_status_t osmt_run_mcast_flow(IN osmtest_t * const p_osmt)
 		goto Exit;
 	}
 
-	p_mc_res = ib_sa_mad_get_payload_ptr(&res_sa_mad);
 	if ((p_mc_res->scope_state & 0x7) != 0x7) {
 		OSM_LOG(&p_osmt->log, OSM_LOG_ERROR, "ERR 02D0: "
 			"Validating JoinState update failed. "
@@ -1955,7 +1898,6 @@ ib_api_status_t osmt_run_mcast_flow(IN osmtest_t * const p_osmt)
 		goto Exit;
 	}
 
-	p_mc_res = ib_sa_mad_get_payload_ptr(&res_sa_mad);
 	if (p_mc_res->scope_state != 0x21) {
 		OSM_LOG(&p_osmt->log, OSM_LOG_ERROR, "ERR 02D4: "
 			"Failed to partially update JoinState : "
@@ -2311,7 +2253,6 @@ ib_api_status_t osmt_run_mcast_flow(IN osmtest_t * const p_osmt)
 
 	status = osmt_send_mcast_request(p_osmt, 1,
 					 &mc_req_rec, comp_mask, &res_sa_mad);
-	p_mc_res = ib_sa_mad_get_payload_ptr(&res_sa_mad);
 	if (status != IB_SUCCESS) {
 		OSM_LOG(&p_osmt->log, OSM_LOG_ERROR, "ERR 02EB: "
 			"Failed to create new mgrp\n");
@@ -2413,7 +2354,6 @@ ib_api_status_t osmt_run_mcast_flow(IN osmtest_t * const p_osmt)
 			goto Exit;
 		}
 
-		p_mc_res = ib_sa_mad_get_payload_ptr(&res_sa_mad);
 		memcpy(&proxy_mgid, &p_mc_res->mgid, sizeof(ib_gid_t));
 
 		/* First try a bad deletion then good one */
@@ -2513,7 +2453,6 @@ ib_api_status_t osmt_run_mcast_flow(IN osmtest_t * const p_osmt)
 							 comp_mask,
 							 &res_sa_mad);
 
-			p_mc_res = ib_sa_mad_get_payload_ptr(&res_sa_mad);
 			if (status != IB_SUCCESS) {
 
 				if (cur_mlid > cl_ntoh16(max_mlid)) {
@@ -2538,18 +2477,14 @@ ib_api_status_t osmt_run_mcast_flow(IN osmtest_t * const p_osmt)
 			} else {
 				cur_mlid = cl_ntoh16(p_mc_res->mlid);
 				/* Save the mlid created in test_created_mlids map */
-				p_recvd_rec =
-				    (ib_member_rec_t *)
-				    ib_sa_mad_get_payload_ptr(&res_sa_mad);
 				OSM_LOG(&p_osmt->log, OSM_LOG_VERBOSE,
 					"Created MGID:%s MLID:0x%04X\n",
-					inet_ntop(AF_INET6,
-						  p_recvd_rec->mgid.raw,
+					inet_ntop(AF_INET6, p_mc_res->mgid.raw,
 						  gid_str, sizeof gid_str),
-					cl_ntoh16(p_recvd_rec->mlid));
+					cl_ntoh16(p_mc_res->mlid));
 				cl_map_insert(&test_created_mlids,
-					      cl_ntoh16(p_recvd_rec->mlid),
-					      p_recvd_rec);
+					      cl_ntoh16(p_mc_res->mlid),
+					      p_mc_res);
 			}
 			tmp_mlid--;
 		}
-- 
1.6.5.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
