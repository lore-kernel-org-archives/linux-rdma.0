From: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH 18/27] opensm/osm_sa*.c: Log requester port GUID at DEBUG level
Date: Tue, 31 Jul 2012 19:04:46 +0300
Message-ID: <1343750695-28063-18-git-send-email-alexne@mellanox.com>
References: <1343750695-28063-1-git-send-email-alexne@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1343750695-28063-1-git-send-email-alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 opensm/osm_sa_guidinfo_record.c  |  3 +++
 opensm/osm_sa_informinfo.c       |  8 ++++++--
 opensm/osm_sa_lft_record.c       |  6 +++++-
 opensm/osm_sa_link_record.c      |  8 ++++++--
 opensm/osm_sa_mft_record.c       |  5 ++++-
 opensm/osm_sa_multipath_record.c |  8 ++++++--
 opensm/osm_sa_node_record.c      |  8 ++++++--
 opensm/osm_sa_pkey_record.c      |  5 ++++-
 opensm/osm_sa_portinfo_record.c  |  8 ++++++--
 opensm/osm_sa_service_record.c   | 13 ++++++++++---
 opensm/osm_sa_slvl_record.c      |  5 ++++-
 opensm/osm_sa_sminfo_record.c    |  8 ++++++--
 opensm/osm_sa_sw_info_record.c   |  8 ++++++--
 opensm/osm_sa_vlarb_record.c     |  5 ++++-
 14 files changed, 76 insertions(+), 22 deletions(-)

diff --git a/opensm/osm_sa_guidinfo_record.c b/opensm/osm_sa_guidinfo_record.c
index f9d7d3d..92f3b1a 100644
--- a/opensm/osm_sa_guidinfo_record.c
+++ b/opensm/osm_sa_guidinfo_record.c
@@ -753,6 +753,9 @@ void osm_gir_rcv_process(IN void *ctx, IN void *data)
 			"Cannot find requester physical port\n");
 		goto Exit;
 	}
+	OSM_LOG(sa->p_log, OSM_LOG_DEBUG,
+		"Requester port GUID 0x%" PRIx64 "\n",
+		cl_ntoh64(osm_physp_get_port_guid(p_req_physp)));
 
 	switch(p_rcvd_mad->method) {
 	case IB_MAD_METHOD_GET:
diff --git a/opensm/osm_sa_informinfo.c b/opensm/osm_sa_informinfo.c
index 6ab6c21..f20d834 100644
--- a/opensm/osm_sa_informinfo.c
+++ b/opensm/osm_sa_informinfo.c
@@ -328,7 +328,7 @@ static void infr_rcv_process_get_method(osm_sa_t * sa, IN osm_madw_t * p_madw)
 	p_rcvd_rec =
 	    (ib_inform_info_record_t *) ib_sa_mad_get_payload_ptr(p_rcvd_mad);
 
-	/* update the requester physical port. */
+	/* update the requester physical port */
 	p_req_physp = osm_get_physp_by_mad_addr(sa->p_log, sa->p_subn,
 						osm_madw_get_mad_addr_ptr
 						(p_madw));
@@ -338,9 +338,13 @@ static void infr_rcv_process_get_method(osm_sa_t * sa, IN osm_madw_t * p_madw)
 		goto Exit;
 	}
 
-	if (OSM_LOG_IS_ACTIVE_V2(sa->p_log, OSM_LOG_DEBUG))
+	if (OSM_LOG_IS_ACTIVE_V2(sa->p_log, OSM_LOG_DEBUG)) {
+		OSM_LOG(sa->p_log, OSM_LOG_DEBUG,
+			"Requester port GUID 0x%" PRIx64 "\n",
+			cl_ntoh64(osm_physp_get_port_guid(p_req_physp)));
 		osm_dump_inform_info_record_v2(sa->p_log, p_rcvd_rec,
 					       FILE_ID, OSM_LOG_DEBUG);
+	}
 
 	cl_qlist_init(&rec_list);
 
diff --git a/opensm/osm_sa_lft_record.c b/opensm/osm_sa_lft_record.c
index 113b9a8..248d8f1 100644
--- a/opensm/osm_sa_lft_record.c
+++ b/opensm/osm_sa_lft_record.c
@@ -206,7 +206,7 @@ void osm_lftr_rcv_process(IN void *ctx, IN void *data)
 		goto Exit;
 	}
 
-	/* update the requester physical port. */
+	/* update the requester physical port */
 	p_req_physp = osm_get_physp_by_mad_addr(sa->p_log, sa->p_subn,
 						osm_madw_get_mad_addr_ptr
 						(p_madw));
@@ -216,6 +216,10 @@ void osm_lftr_rcv_process(IN void *ctx, IN void *data)
 		goto Exit;
 	}
 
+	OSM_LOG(sa->p_log, OSM_LOG_DEBUG,
+		"Requester port GUID 0x%" PRIx64 "\n",
+		cl_ntoh64(osm_physp_get_port_guid(p_req_physp)));
+
 	cl_qlist_init(&rec_list);
 
 	context.p_rcvd_rec = p_rcvd_rec;
diff --git a/opensm/osm_sa_link_record.c b/opensm/osm_sa_link_record.c
index 6c426be..f91b654 100644
--- a/opensm/osm_sa_link_record.c
+++ b/opensm/osm_sa_link_record.c
@@ -445,7 +445,7 @@ void osm_lr_rcv_process(IN void *context, IN void *data)
 		goto Exit;
 	}
 
-	/* update the requester physical port. */
+	/* update the requester physical port */
 	p_req_physp = osm_get_physp_by_mad_addr(sa->p_log, sa->p_subn,
 						osm_madw_get_mad_addr_ptr
 						(p_madw));
@@ -455,8 +455,12 @@ void osm_lr_rcv_process(IN void *context, IN void *data)
 		goto Exit;
 	}
 
-	if (OSM_LOG_IS_ACTIVE_V2(sa->p_log, OSM_LOG_DEBUG))
+	if (OSM_LOG_IS_ACTIVE_V2(sa->p_log, OSM_LOG_DEBUG)) {
+		OSM_LOG(sa->p_log, OSM_LOG_DEBUG,
+			"Requester port GUID 0x%" PRIx64 "\n",
+			cl_ntoh64(osm_physp_get_port_guid(p_req_physp)));
 		osm_dump_link_record_v2(sa->p_log, p_lr, FILE_ID, OSM_LOG_DEBUG);
+	}
 
 	cl_qlist_init(&lr_list);
 
diff --git a/opensm/osm_sa_mft_record.c b/opensm/osm_sa_mft_record.c
index 9823d31..c67c923 100644
--- a/opensm/osm_sa_mft_record.c
+++ b/opensm/osm_sa_mft_record.c
@@ -239,7 +239,7 @@ void osm_mftr_rcv_process(IN void *ctx, IN void *data)
 		goto Exit;
 	}
 
-	/* update the requester physical port. */
+	/* update the requester physical port */
 	p_req_physp = osm_get_physp_by_mad_addr(sa->p_log, sa->p_subn,
 						osm_madw_get_mad_addr_ptr
 						(p_madw));
@@ -248,6 +248,9 @@ void osm_mftr_rcv_process(IN void *ctx, IN void *data)
 			"Cannot find requester physical port\n");
 		goto Exit;
 	}
+	OSM_LOG(sa->p_log, OSM_LOG_DEBUG,
+		"Requester port GUID 0x%" PRIx64 "\n",
+		cl_ntoh64(osm_physp_get_port_guid(p_req_physp)));
 
 	cl_qlist_init(&rec_list);
 
diff --git a/opensm/osm_sa_multipath_record.c b/opensm/osm_sa_multipath_record.c
index 712bd4f..99628af 100644
--- a/opensm/osm_sa_multipath_record.c
+++ b/opensm/osm_sa_multipath_record.c
@@ -1549,7 +1549,7 @@ void osm_mpr_rcv_process(IN void *context, IN void *data)
 		goto Exit;
 	}
 
-	/* update the requester physical port. */
+	/* update the requester physical port */
 	requester_port = osm_get_port_by_mad_addr(sa->p_log, sa->p_subn,
 						  osm_madw_get_mad_addr_ptr
 						  (p_madw));
@@ -1559,8 +1559,12 @@ void osm_mpr_rcv_process(IN void *context, IN void *data)
 		goto Exit;
 	}
 
-	if (OSM_LOG_IS_ACTIVE_V2(sa->p_log, OSM_LOG_DEBUG))
+	if (OSM_LOG_IS_ACTIVE_V2(sa->p_log, OSM_LOG_DEBUG)) {
+		OSM_LOG(sa->p_log, OSM_LOG_DEBUG,
+			"Requester port GUID 0x%" PRIx64 "\n",
+			cl_ntoh64(osm_port_get_guid(requester_port)));
 		osm_dump_multipath_record_v2(sa->p_log, p_mpr, FILE_ID, OSM_LOG_DEBUG);
+	}
 
 	/* Validatg rate if supplied */
 	if ((p_sa_mad->comp_mask & IB_MPR_COMPMASK_RATESELEC) &&
diff --git a/opensm/osm_sa_node_record.c b/opensm/osm_sa_node_record.c
index 5cb64b5..c7a079e 100644
--- a/opensm/osm_sa_node_record.c
+++ b/opensm/osm_sa_node_record.c
@@ -314,7 +314,7 @@ void osm_nr_rcv_process(IN void *ctx, IN void *data)
 		goto Exit;
 	}
 
-	/* update the requester physical port. */
+	/* update the requester physical port */
 	p_req_physp = osm_get_physp_by_mad_addr(sa->p_log, sa->p_subn,
 						osm_madw_get_mad_addr_ptr
 						(p_madw));
@@ -324,8 +324,12 @@ void osm_nr_rcv_process(IN void *ctx, IN void *data)
 		goto Exit;
 	}
 
-	if (OSM_LOG_IS_ACTIVE_V2(sa->p_log, OSM_LOG_DEBUG))
+	if (OSM_LOG_IS_ACTIVE_V2(sa->p_log, OSM_LOG_DEBUG)) {
+		OSM_LOG(sa->p_log, OSM_LOG_DEBUG,
+			"Requester port GUID 0x%" PRIx64 "\n",
+			cl_ntoh64(osm_physp_get_port_guid(p_req_physp)));
 		osm_dump_node_record_v2(sa->p_log, p_rcvd_rec, FILE_ID, OSM_LOG_DEBUG);
+	}
 
 	cl_qlist_init(&rec_list);
 
diff --git a/opensm/osm_sa_pkey_record.c b/opensm/osm_sa_pkey_record.c
index fdbb3bf..691a716 100644
--- a/opensm/osm_sa_pkey_record.c
+++ b/opensm/osm_sa_pkey_record.c
@@ -261,7 +261,7 @@ void osm_pkey_rec_rcv_process(IN void *ctx, IN void *data)
 		goto Exit;
 	}
 
-	/* update the requester physical port. */
+	/* update the requester physical port */
 	p_req_physp = osm_get_physp_by_mad_addr(sa->p_log, sa->p_subn,
 						osm_madw_get_mad_addr_ptr
 						(p_madw));
@@ -270,6 +270,9 @@ void osm_pkey_rec_rcv_process(IN void *ctx, IN void *data)
 			"Cannot find requester physical port\n");
 		goto Exit;
 	}
+	OSM_LOG(sa->p_log, OSM_LOG_DEBUG,
+		"Requester port GUID 0x%" PRIx64 "\n",
+		cl_ntoh64(osm_physp_get_port_guid(p_req_physp)));
 
 	cl_qlist_init(&rec_list);
 
diff --git a/opensm/osm_sa_portinfo_record.c b/opensm/osm_sa_portinfo_record.c
index 38c52f2..b9627c9 100644
--- a/opensm/osm_sa_portinfo_record.c
+++ b/opensm/osm_sa_portinfo_record.c
@@ -540,7 +540,7 @@ void osm_pir_rcv_process(IN void *ctx, IN void *data)
 		goto Exit;
 	}
 
-	/* update the requester physical port. */
+	/* update the requester physical port */
 	p_req_physp = osm_get_physp_by_mad_addr(sa->p_log, sa->p_subn,
 						osm_madw_get_mad_addr_ptr
 						(p_madw));
@@ -550,8 +550,12 @@ void osm_pir_rcv_process(IN void *ctx, IN void *data)
 		goto Exit;
 	}
 
-	if (OSM_LOG_IS_ACTIVE_V2(sa->p_log, OSM_LOG_DEBUG))
+	if (OSM_LOG_IS_ACTIVE_V2(sa->p_log, OSM_LOG_DEBUG)) {
+		OSM_LOG(sa->p_log, OSM_LOG_DEBUG,
+			"Requester port GUID 0x%" PRIx64 "\n",
+			cl_ntoh64(osm_physp_get_port_guid(p_req_physp)));
 		osm_dump_portinfo_record_v2(sa->p_log, p_rcvd_rec, FILE_ID, OSM_LOG_DEBUG);
+	}
 
 	cl_qlist_init(&rec_list);
 
diff --git a/opensm/osm_sa_service_record.c b/opensm/osm_sa_service_record.c
index b274878..c8b2a9c 100644
--- a/opensm/osm_sa_service_record.c
+++ b/opensm/osm_sa_service_record.c
@@ -89,7 +89,7 @@ match_service_pkey_with_ports_pkey(IN osm_sa_t * sa,
 	ib_net64_t service_guid;
 	osm_port_t *service_port;
 
-	/* update the requester physical port. */
+	/* update the requester physical port */
 	p_req_physp = osm_get_physp_by_mad_addr(sa->p_log, sa->p_subn,
 						osm_madw_get_mad_addr_ptr
 						(p_madw));
@@ -99,6 +99,9 @@ match_service_pkey_with_ports_pkey(IN osm_sa_t * sa,
 		valid = FALSE;
 		goto Exit;
 	}
+	OSM_LOG(sa->p_log, OSM_LOG_DEBUG,
+		"Requester port GUID 0x%" PRIx64 "\n",
+		cl_ntoh64(osm_physp_get_port_guid(p_req_physp)));
 
 	if ((comp_mask & IB_SR_COMPMASK_SPKEY) == IB_SR_COMPMASK_SPKEY) {
 		/* We have a ServiceP_Key - check matching on requester port,
@@ -451,7 +454,7 @@ static void sr_rcv_process_get_method(osm_sa_t * sa, IN osm_madw_t * p_madw)
 
 	CL_ASSERT(p_madw);
 
-	/* update the requester physical port. */
+	/* update the requester physical port */
 	p_req_physp = osm_get_physp_by_mad_addr(sa->p_log, sa->p_subn,
 						osm_madw_get_mad_addr_ptr
 						(p_madw));
@@ -465,9 +468,13 @@ static void sr_rcv_process_get_method(osm_sa_t * sa, IN osm_madw_t * p_madw)
 	p_recvd_service_rec =
 	    (ib_service_record_t *) ib_sa_mad_get_payload_ptr(p_sa_mad);
 
-	if (OSM_LOG_IS_ACTIVE_V2(sa->p_log, OSM_LOG_DEBUG))
+	if (OSM_LOG_IS_ACTIVE_V2(sa->p_log, OSM_LOG_DEBUG)) {
+		OSM_LOG(sa->p_log, OSM_LOG_DEBUG,
+			"Requester port GUID 0x%" PRIx64 "\n",
+			cl_ntoh64(osm_physp_get_port_guid(p_req_physp)));
 		osm_dump_service_record_v2(sa->p_log, p_recvd_service_rec,
 					   FILE_ID, OSM_LOG_DEBUG);
+	}
 
 	cl_qlist_init(&sr_match_item.sr_list);
 	sr_match_item.p_service_rec = p_recvd_service_rec;
diff --git a/opensm/osm_sa_slvl_record.c b/opensm/osm_sa_slvl_record.c
index 253f82d..6ff8bae 100644
--- a/opensm/osm_sa_slvl_record.c
+++ b/opensm/osm_sa_slvl_record.c
@@ -232,7 +232,7 @@ void osm_slvl_rec_rcv_process(IN void *ctx, IN void *data)
 		goto Exit;
 	}
 
-	/* update the requester physical port. */
+	/* update the requester physical port */
 	p_req_physp = osm_get_physp_by_mad_addr(sa->p_log, sa->p_subn,
 						osm_madw_get_mad_addr_ptr
 						(p_madw));
@@ -241,6 +241,9 @@ void osm_slvl_rec_rcv_process(IN void *ctx, IN void *data)
 			"Cannot find requester physical port\n");
 		goto Exit;
 	}
+	OSM_LOG(sa->p_log, OSM_LOG_DEBUG,
+		"Requester port GUID 0x%" PRIx64 "\n",
+		cl_ntoh64(osm_physp_get_port_guid(p_req_physp)));
 
 	cl_qlist_init(&rec_list);
 
diff --git a/opensm/osm_sa_sminfo_record.c b/opensm/osm_sa_sminfo_record.c
index 23eda1d..c60316d 100644
--- a/opensm/osm_sa_sminfo_record.c
+++ b/opensm/osm_sa_sminfo_record.c
@@ -210,7 +210,7 @@ void osm_smir_rcv_process(IN void *ctx, IN void *data)
 		goto Exit;
 	}
 
-	/* update the requester physical port. */
+	/* update the requester physical port */
 	p_req_physp = osm_get_physp_by_mad_addr(sa->p_log, sa->p_subn,
 						osm_madw_get_mad_addr_ptr
 						(p_madw));
@@ -220,8 +220,12 @@ void osm_smir_rcv_process(IN void *ctx, IN void *data)
 		goto Exit;
 	}
 
-	if (OSM_LOG_IS_ACTIVE_V2(sa->p_log, OSM_LOG_DEBUG))
+	if (OSM_LOG_IS_ACTIVE_V2(sa->p_log, OSM_LOG_DEBUG)) {
+		OSM_LOG(sa->p_log, OSM_LOG_DEBUG,
+			"Requester port GUID 0x%" PRIx64 "\n",
+			cl_ntoh64(osm_physp_get_port_guid(p_req_physp)));
 		osm_dump_sm_info_record_v2(sa->p_log, p_rcvd_rec, FILE_ID, OSM_LOG_DEBUG);
+	}
 
 	p_smi = &p_rcvd_rec->sm_info;
 
diff --git a/opensm/osm_sa_sw_info_record.c b/opensm/osm_sa_sw_info_record.c
index ee0ef81..d83e621 100644
--- a/opensm/osm_sa_sw_info_record.c
+++ b/opensm/osm_sa_sw_info_record.c
@@ -224,7 +224,7 @@ void osm_sir_rcv_process(IN void *ctx, IN void *data)
 		goto Exit;
 	}
 
-	/* update the requester physical port. */
+	/* update the requester physical port */
 	p_req_physp = osm_get_physp_by_mad_addr(sa->p_log, sa->p_subn,
 						osm_madw_get_mad_addr_ptr
 						(p_madw));
@@ -234,9 +234,13 @@ void osm_sir_rcv_process(IN void *ctx, IN void *data)
 		goto Exit;
 	}
 
-	if (OSM_LOG_IS_ACTIVE_V2(sa->p_log, OSM_LOG_DEBUG))
+	if (OSM_LOG_IS_ACTIVE_V2(sa->p_log, OSM_LOG_DEBUG)) {
+		OSM_LOG(sa->p_log, OSM_LOG_DEBUG,
+			"Requester port GUID 0x%" PRIx64 "\n",
+			cl_ntoh64(osm_physp_get_port_guid(p_req_physp)));
 		osm_dump_switch_info_record_v2(sa->p_log, p_rcvd_rec,
 					       FILE_ID, OSM_LOG_DEBUG);
+	}
 
 	cl_qlist_init(&rec_list);
 
diff --git a/opensm/osm_sa_vlarb_record.c b/opensm/osm_sa_vlarb_record.c
index 98c23a7..2ada36b 100644
--- a/opensm/osm_sa_vlarb_record.c
+++ b/opensm/osm_sa_vlarb_record.c
@@ -241,7 +241,7 @@ void osm_vlarb_rec_rcv_process(IN void *ctx, IN void *data)
 		goto Exit;
 	}
 
-	/* update the requester physical port. */
+	/* update the requester physical port */
 	p_req_physp = osm_get_physp_by_mad_addr(sa->p_log, sa->p_subn,
 						osm_madw_get_mad_addr_ptr
 						(p_madw));
@@ -250,6 +250,9 @@ void osm_vlarb_rec_rcv_process(IN void *ctx, IN void *data)
 			"Cannot find requester physical port\n");
 		goto Exit;
 	}
+	OSM_LOG(sa->p_log, OSM_LOG_DEBUG,
+		"Requester port GUID 0x%" PRIx64 "\n",
+		cl_ntoh64(osm_physp_get_port_guid(p_req_physp)));
 
 	cl_qlist_init(&rec_list);
 
-- 
1.7.11.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
