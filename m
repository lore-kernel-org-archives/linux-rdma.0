From: Line Holen <Line.Holen-UdXhSnd/wVw@public.gmane.org>
Subject: [PATCH] opensm/osm_vendor_ibumad.c: Move error info into single message
Date: Fri, 04 Dec 2009 10:41:50 +0100
Message-ID: <4B18D95E.1090007@Sun.COM>
Mime-Version: 1.0
Content-Type: text/plain; CHARSET=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

The information in ERR 5409 is moved into 5410/5411 to reduce
number of messages

Signed-off-by: Line Holen <Line.Holen-xsfywfwIY+M@public.gmane.org>

---

diff --git a/opensm/libvendor/osm_vendor_ibumad.c b/opensm/libvendor/osm_vendor_ibumad.c
index 8f9bbf5..b4319cd 100644
--- a/opensm/libvendor/osm_vendor_ibumad.c
+++ b/opensm/libvendor/osm_vendor_ibumad.c
@@ -3,6 +3,7 @@
  * Copyright (c) 2002-2005 Mellanox Technologies LTD. All rights reserved.
  * Copyright (c) 1996-2003 Intel Corporation. All rights reserved.
  * Copyright (c) 2009 HNR Consulting. All rights reserved.
+ * Copyright (c) 2009 Sun Microsystems, Inc. All rights reserved.
  *
  * This software is available to you under a choice of one of two
  * licenses.  You may choose to be licensed under the terms of the GNU
@@ -325,28 +326,30 @@ static void *umad_receiver(void *p_ptr)
 
 		/* if status != 0 then we are handling recv timeout on send */
 		if (umad_status(p_madw->vend_wrap.umad)) {
-			OSM_LOG(p_vend->p_log, OSM_LOG_ERROR, "ERR 5409: "
-				"send completed with error"
-				" (method=0x%X attr=0x%X trans_id=0x%" PRIx64
-				") -- dropping\n",
-				mad->method, cl_ntoh16(mad->attr_id),
-				cl_ntoh64(mad->trans_id));
+
 			if (mad->mgmt_class != IB_MCLASS_SUBN_DIR) {
 				/* LID routed */
-				OSM_LOG(p_vend->p_log, OSM_LOG_ERROR,
-					"ERR 5410: class 0x%x LID %u\n",
-					mad->mgmt_class,
+				OSM_LOG(p_vend->p_log, OSM_LOG_ERROR, "ERR 5410: "
+					"Send completed with error -- dropping\n"
+					"\t\t\tClass 0x%x, Method 0x%X, Attr 0x%X, "
+					"TID 0x%" PRIx64 ", LID %u\n",
+					mad->mgmt_class, mad->method,
+					cl_ntoh16(mad->attr_id),
+					cl_ntoh64(mad->trans_id),
 					cl_ntoh16(ib_mad_addr->lid));
 			} else {
 				ib_smp_t *smp;
 
 				/* Direct routed SMP */
 				smp = (ib_smp_t *) mad;
-				OSM_LOG(p_vend->p_log, OSM_LOG_ERROR,
-					"ERR 5411: DR SMP Hop Ptr: 0x%X\n",
-					smp->hop_ptr);
+				OSM_LOG(p_vend->p_log, OSM_LOG_ERROR, "ERR 5411: "
+					"DR SMP Send completed with error -- dropping\n"
+					"\t\t\tMethod 0x%X, Attr 0x%X, TID 0x%" PRIx64
+					", Hop Ptr: 0x%X\n",
+					mad->method, cl_ntoh16(mad->attr_id),
+					cl_ntoh64(mad->trans_id), smp->hop_ptr);
 				osm_dump_smp_dr_path(p_vend->p_log, smp,
-						     OSM_LOG_ERROR);
+						     OSM_LOG_VERBOSE);
 			}
 
 			if (!(p_req_madw = get_madw(p_vend, &mad->trans_id))) {
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
