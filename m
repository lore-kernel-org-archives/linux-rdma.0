From: Yevgeny Kliteynik <kliteyn-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Subject: [PATCH 5/8 v2] opensm/libvendor/osm_vendor_ibumad.c:rename "mad"
 to "p_mad" to indicate pointer
Date: Tue, 11 Sep 2012 18:29:07 +0300
Message-ID: <504F58C3.1060801@mellanox.co.il>
Reply-To: <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Linux RDMA <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Yevgeny Kliteynik <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Signed-off-by: Yevgeny Kliteynik <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>

---
 libvendor/osm_vendor_ibumad.c | 44 +++++++++++++++++++++----------------------
 1 file changed, 22 insertions(+), 22 deletions(-)

diff --git a/libvendor/osm_vendor_ibumad.c b/libvendor/osm_vendor_ibumad.c
index b068443..e0c9f90 100644
--- a/libvendor/osm_vendor_ibumad.c
+++ b/libvendor/osm_vendor_ibumad.c
@@ -288,7 +288,7 @@ static void *umad_receiver(void *p_ptr)
 	osm_umad_bind_info_t *p_bind;
 	osm_mad_addr_t osm_addr;
 	osm_madw_t *p_madw, *p_req_madw;
-	ib_mad_t *mad;
+	ib_mad_t *p_mad;
 	void *umad = 0;
 	int mad_agent, length;

@@ -340,11 +340,11 @@ static void *umad_receiver(void *p_ptr)
 			continue;
 		}

-		mad = (ib_mad_t *) umad_get_mad(umad);
+		p_mad = (ib_mad_t *) umad_get_mad(umad);

 		ib_mad_addr_conv(umad, &osm_addr,
-				 mad->mgmt_class == IB_MCLASS_SUBN_LID ||
-				 mad->mgmt_class == IB_MCLASS_SUBN_DIR);
+				 p_mad->mgmt_class == IB_MCLASS_SUBN_LID ||
+				 p_mad->mgmt_class == IB_MCLASS_SUBN_DIR);

 		if (!(p_madw = osm_mad_pool_get(p_bind->p_mad_pool,
 						(osm_bind_handle_t) p_bind,
@@ -367,15 +367,15 @@ static void *umad_receiver(void *p_ptr)

 		/* if status != 0 then we are handling recv timeout on send */
 		if (umad_status(p_madw->vend_wrap.umad)) {
-			if (!(p_req_madw = get_madw(p_vend, &mad->trans_id,
-						    mad->mgmt_class))) {
+			if (!(p_req_madw = get_madw(p_vend, &p_mad->trans_id,
+						    p_mad->mgmt_class))) {
 				OSM_LOG(p_vend->p_log, OSM_LOG_ERROR,
 					"ERR 5412: "
 					"Failed to obtain request madw for timed out MAD"
 					" (class=0x%X method=0x%X attr=0x%X tid=0x%"PRIx64") -- dropping\n",
-					mad->mgmt_class, mad->method,
-					cl_ntoh16(mad->attr_id),
-					cl_ntoh64(mad->trans_id));
+					p_mad->mgmt_class, p_mad->method,
+					cl_ntoh16(p_mad->attr_id),
+					cl_ntoh64(p_mad->trans_id));
 			} else {
 				p_req_madw->status = IB_TIMEOUT;
 				log_send_error(p_vend, p_req_madw);
@@ -394,30 +394,30 @@ static void *umad_receiver(void *p_ptr)
 		}

 		p_req_madw = 0;
-		if (ib_mad_is_response(mad) &&
-		    !(p_req_madw = get_madw(p_vend, &mad->trans_id,
-					    mad->mgmt_class))) {
+		if (ib_mad_is_response(p_mad) &&
+		    !(p_req_madw = get_madw(p_vend, &p_mad->trans_id,
+					    p_mad->mgmt_class))) {
 			OSM_LOG(p_vend->p_log, OSM_LOG_ERROR, "ERR 5413: "
 				"Failed to obtain request madw for received MAD"
 				" (class=0x%X method=0x%X attr=0x%X tid=0x%"PRIx64") -- dropping\n",
-				mad->mgmt_class, mad->method,
-				cl_ntoh16((mad)->attr_id),
-				cl_ntoh64(mad->trans_id));
+				p_mad->mgmt_class, p_mad->method,
+				cl_ntoh16(p_mad->attr_id),
+				cl_ntoh64(p_mad->trans_id));
 			osm_mad_pool_put(p_bind->p_mad_pool, p_madw);
 			continue;
 		}
 #ifndef VENDOR_RMPP_SUPPORT
-		if ((mad->mgmt_class != IB_MCLASS_SUBN_DIR) &&
-		    (mad->mgmt_class != IB_MCLASS_SUBN_LID) &&
-		    (ib_rmpp_is_flag_set((ib_rmpp_mad_t *) mad,
+		if ((p_mad->mgmt_class != IB_MCLASS_SUBN_DIR) &&
+		    (p_mad->mgmt_class != IB_MCLASS_SUBN_LID) &&
+		    (ib_rmpp_is_flag_set((ib_rmpp_mad_t *) p_mad,
 					 IB_RMPP_FLAG_ACTIVE))) {
 			OSM_LOG(p_vend->p_log, OSM_LOG_ERROR, "ERR 5414: "
 				"class 0x%x method 0x%x RMPP version %d type "
 				"%d flags 0x%x received -- dropping\n",
-				mad->mgmt_class, mad->method,
-				((ib_rmpp_mad_t *) mad)->rmpp_version,
-				((ib_rmpp_mad_t *) mad)->rmpp_type,
-				((ib_rmpp_mad_t *) mad)->rmpp_flags);
+				p_mad->mgmt_class, p_mad->method,
+				((ib_rmpp_mad_t *) p_mad)->rmpp_version,
+				((ib_rmpp_mad_t *) p_mad)->rmpp_type,
+				((ib_rmpp_mad_t *) p_mad)->rmpp_flags);
 			osm_mad_pool_put(p_bind->p_mad_pool, p_madw);
 			continue;
 		}
-- 
1.7.11.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
