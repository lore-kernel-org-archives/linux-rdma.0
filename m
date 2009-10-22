From: Hal Rosenstock <hnrose-Wuw85uim5zDR7s880joybQ@public.gmane.org>
Subject: [PATCH] opensm/osm_sa_mcmember_record.c: Validate P_Key on IPoIB
	signed MGIDs
Date: Thu, 22 Oct 2009 10:59:46 -0400
Message-ID: <20091022145946.GA7932@comcast.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


Per RFC 4391 rules for P_Key portion of MGIDs needing to be 
full member and valid P_Key

Signed-off-by: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
diff --git a/opensm/opensm/osm_sa_mcmember_record.c b/opensm/opensm/osm_sa_mcmember_record.c
index dd01eed..a185238 100644
--- a/opensm/opensm/osm_sa_mcmember_record.c
+++ b/opensm/opensm/osm_sa_mcmember_record.c
@@ -3,6 +3,7 @@
  * Copyright (c) 2002-2005 Mellanox Technologies LTD. All rights reserved.
  * Copyright (c) 1996-2003 Intel Corporation. All rights reserved.
  * Copyright (c) 2008 Xsigo Systems Inc.  All rights reserved.
+ * Copyright (c) 2009 HNR Consulting.  All rights reserved.
  *
  * This software is available to you under a choice of one of two
  * licenses.  You may choose to be licensed under the terms of the GNU
@@ -516,6 +517,7 @@ static ib_api_status_t validate_requested_mgid(IN osm_sa_t * sa,
 					       p_mcm_rec)
 {
 	uint16_t signature;
+	ib_net16_t pkey;
 	boolean_t valid = TRUE;
 
 	OSM_LOG_ENTER(sa->p_log);
@@ -555,6 +557,16 @@ static ib_api_status_t validate_requested_mgid(IN osm_sa_t * sa,
 	 *
 	 */
 	if (signature == 0x401B || signature == 0x601B) {
+		/* Validate P_Key portion of MGID per RFC 4391 */
+		memcpy(&pkey, &(p_mcm_rec->mgid.raw[4]), sizeof(pkey));
+		if (!ib_pkey_is_full_member(pkey) || ib_pkey_is_invalid(pkey)) {
+			OSM_LOG(sa->p_log, OSM_LOG_ERROR, "ERR 1B27: "
+				"MGID uses limited or invalid P_Key 0x%x\n",
+				cl_ntoh16(pkey));
+			valid = FALSE;
+			goto Exit;
+		}
+
 		OSM_LOG(sa->p_log, OSM_LOG_DEBUG,
 			"Skipping MGID Validation for IPoIB Signed (0x%04X) MGIDs\n",
 			signature);
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
