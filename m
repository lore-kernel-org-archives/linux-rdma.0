From: Line Holen <line.holen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] osm_sa_mcmember_record.c Reduce number of error messages the
 for same event
Date: Mon, 3 Jun 2013 04:39:46 -0700 (PDT)
Message-ID: <7489621d-6395-4e59-896e-d7419aacbd01@default>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

ERR msg 0x1B22 info is put into the error messages of the tests in the
same subfunction. No information is lost, but you get one error message
instead of two.

Also changed a couple of messages to make them more end user friendly

Signed-off-by: Line Holen <Line.Holen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>

---

diff --git a/opensm/osm_sa_mcmember_record.c b/opensm/osm_sa_mcmember_record.c
index 242fcde..286d0e8 100644
--- a/opensm/osm_sa_mcmember_record.c
+++ b/opensm/osm_sa_mcmember_record.c
@@ -3,6 +3,7 @@
  * Copyright (c) 2002-2011 Mellanox Technologies LTD. All rights reserved.
  * Copyright (c) 1996-2003 Intel Corporation. All rights reserved.
  * Copyright (c) 2008 Xsigo Systems Inc.  All rights reserved.
+ * Copyright (c) 2013 Oracle and/or its affiliates. All rights reserved.
  *
  * This software is available to you under a choice of one of two
  * licenses.  You may choose to be licensed under the terms of the GNU
@@ -565,7 +566,8 @@ static ib_api_status_t validate_requested_mgid(IN osm_sa_t * sa,
 	/* 14-a: mcast GID must start with 0xFF */
 	if (p_mcm_rec->mgid.multicast.header[0] != 0xFF) {
 		OSM_LOG(sa->p_log, OSM_LOG_ERROR, "ERR 1B01: "
-			"Wrong MGID Prefix 0x%02X must be 0xFF\n",
+			"Invalid prefix 0x%02X in requested MGID, "
+			"must be 0xFF\n",
 			cl_ntoh16(p_mcm_rec->mgid.multicast.header[0]));
 		valid = FALSE;
 		goto Exit;
@@ -606,7 +608,7 @@ static ib_api_status_t validate_requested_mgid(IN osm_sa_t * sa,
 	/* 14-b: the 3 upper bits in the "flags" should be zero: */
 	if (p_mcm_rec->mgid.multicast.header[1] & 0xE0) {
 		OSM_LOG(sa->p_log, OSM_LOG_ERROR, "ERR 1B28: "
-			"MGID uses Reserved Flags: flags=0x%X\n",
+			"Requested MGID invalid, uses Reserved Flags: flags=0x%X\n",
 			(p_mcm_rec->mgid.multicast.header[1] & 0xE0) >> 4);
 		valid = FALSE;
 		goto Exit;
@@ -618,7 +620,8 @@ static ib_api_status_t validate_requested_mgid(IN osm_sa_t * sa,
 	    (p_mcm_rec->mgid.multicast.header[1] & 0x0F) ==
 	    IB_MC_SCOPE_LINK_LOCAL) {
 		OSM_LOG(sa->p_log, OSM_LOG_ERROR, "ERR 1B24: "
-			"MGID uses 0xA01B signature but with link-local scope\n");
+			"Requested MGID invalid, "
+			"uses 0xA01B signature but with link-local scope\n");
 		valid = FALSE;
 		goto Exit;
 	}
@@ -830,8 +833,6 @@ static ib_api_status_t mcmr_rcv_create_new_mgrp(IN osm_sa_t * sa,
 				  sizeof gid_str));
 	} else if (!validate_requested_mgid(sa, &mcm_rec)) {
 		/* a specific MGID was requested so validate the resulting MGID */
-		OSM_LOG(sa->p_log, OSM_LOG_ERROR, "ERR 1B22: "
-			"Invalid requested MGID\n");
 		status = IB_SA_MAD_STATUS_REQ_INVALID;
 		goto Exit;
 	}
@@ -1102,8 +1103,8 @@ static void mcmr_rcv_join_mgrp(IN osm_sa_t * sa, IN osm_madw_t * p_madw)
 			char gid_str[INET6_ADDRSTRLEN];
 			CL_PLOCK_RELEASE(sa->p_lock);
 			OSM_LOG(sa->p_log, OSM_LOG_ERROR, "ERR 1B10: "
-				"Provided Join State != FullMember - "
-				"required for create, "
+				"Failed to create multicast group "
+				"because Join State != FullMember, "
 				"MGID: %s from port 0x%016" PRIx64 " (%s)\n",
 				inet_ntop(AF_INET6,
 					  p_recvd_mcmember_rec->mgid.raw,
@@ -1121,19 +1122,15 @@ static void mcmr_rcv_join_mgrp(IN osm_sa_t * sa, IN osm_madw_t * p_madw)
 			char gid_str[INET6_ADDRSTRLEN];
 			CL_PLOCK_RELEASE(sa->p_lock);
 			OSM_LOG(sa->p_log, OSM_LOG_ERROR, "ERR 1B11: "
-				"method = %s, scope_state = 0x%x, "
-				"component mask = 0x%016" PRIx64 ", "
-				"expected comp mask = 0x%016" PRIx64 ", "
-				"MGID: %s from port 0x%016" PRIx64 " (%s)\n",
-				ib_get_sa_method_str(p_sa_mad->method),
-				p_recvd_mcmember_rec->scope_state,
-				cl_ntoh64(p_sa_mad->comp_mask),
-				CL_NTOH64(REQUIRED_MC_CREATE_COMP_MASK),
+				"Port 0x%016" PRIx64 " (%s) failed to join "
+				"non-existing multicast group with MGID %s, "
+				"insufficient components specified for "
+				"implicit create (comp_mask 0x%" PRIx64 ")\n",
+				cl_ntoh64(portguid), p_port->p_node->print_desc,
 				inet_ntop(AF_INET6,
 					  p_recvd_mcmember_rec->mgid.raw,
 					  gid_str, sizeof gid_str),
-				cl_ntoh64(portguid),
-				p_port->p_node->print_desc);
+				cl_ntoh64(p_sa_mad->comp_mask));
 			osm_sa_send_error(sa, p_madw,
 					  IB_SA_MAD_STATUS_INSUF_COMPS);
 			goto Exit;
@@ -1186,7 +1183,7 @@ static void mcmr_rcv_join_mgrp(IN osm_sa_t * sa, IN osm_madw_t * p_madw)
 		OSM_LOG(sa->p_log, OSM_LOG_ERROR, "ERR 1B12: "
 			"validate_more_comp_fields, validate_port_caps, "
 			"or JoinState = 0 failed for MGID: %s port 0x%016" PRIx64
-			" (%s), " "sending IB_SA_MAD_STATUS_REQ_INVALID\n",
+			" (%s), sending IB_SA_MAD_STATUS_REQ_INVALID\n",
 			   inet_ntop(AF_INET6, p_mgrp->mcmember_rec.mgid.raw,
 				     gid_str, sizeof gid_str),
 			cl_ntoh64(portguid), p_port->p_node->print_desc);
@@ -1629,7 +1626,7 @@ void osm_mcmr_rcv_process(IN void *context, IN void *data)
 		break;
 	default:
 		OSM_LOG(sa->p_log, OSM_LOG_ERROR, "ERR 1B21: "
-			"Unsupported Method (%s)\n",
+			"Unsupported Method (%s) for MCMemberRecord requests\n",
 			ib_get_sa_method_str(p_sa_mad->method));
 		osm_sa_send_error(sa, p_madw, IB_MAD_STATUS_UNSUP_METHOD_ATTR);
 		break;
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
