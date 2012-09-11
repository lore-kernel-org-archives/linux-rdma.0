From: Yevgeny Kliteynik <kliteyn-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Subject: [PATCH 6/8 v2] opensm/libvendor/osm_vendor_ibumad.c: validate response
 MAD properties
Date: Tue, 11 Sep 2012 18:29:52 +0300
Message-ID: <504F58F0.5000009@mellanox.co.il>
Reply-To: <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Linux RDMA <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Yevgeny Kliteynik <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Check that attribute ID, attribute modifier and
transaction ID are the same in request and response.

Note that just by checking these we cover a very wide
range of possible bugs in SMAs. Attribute modifier is
used in PortInfo, LFT, MFT, and others.

Signed-off-by: Yevgeny Kliteynik <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
---
 libvendor/osm_vendor_ibumad.c | 57 ++++++++++++++++++++++++++++++++++---------
 1 file changed, 45 insertions(+), 12 deletions(-)

diff --git a/libvendor/osm_vendor_ibumad.c b/libvendor/osm_vendor_ibumad.c
index e0c9f90..ca320a6 100644
--- a/libvendor/osm_vendor_ibumad.c
+++ b/libvendor/osm_vendor_ibumad.c
@@ -288,7 +288,7 @@ static void *umad_receiver(void *p_ptr)
 	osm_umad_bind_info_t *p_bind;
 	osm_mad_addr_t osm_addr;
 	osm_madw_t *p_madw, *p_req_madw;
-	ib_mad_t *p_mad;
+	ib_mad_t *p_mad, *p_req_mad;
 	void *umad = 0;
 	int mad_agent, length;

@@ -394,18 +394,51 @@ static void *umad_receiver(void *p_ptr)
 		}

 		p_req_madw = 0;
-		if (ib_mad_is_response(p_mad) &&
-		    !(p_req_madw = get_madw(p_vend, &p_mad->trans_id,
-					    p_mad->mgmt_class))) {
-			OSM_LOG(p_vend->p_log, OSM_LOG_ERROR, "ERR 5413: "
-				"Failed to obtain request madw for received MAD"
-				" (class=0x%X method=0x%X attr=0x%X tid=0x%"PRIx64") -- dropping\n",
-				p_mad->mgmt_class, p_mad->method,
-				cl_ntoh16(p_mad->attr_id),
-				cl_ntoh64(p_mad->trans_id));
-			osm_mad_pool_put(p_bind->p_mad_pool, p_madw);
-			continue;
+		if (ib_mad_is_response(p_mad)) {
+			p_req_madw = get_madw(p_vend, &p_mad->trans_id,
+					      p_mad->mgmt_class);
+			if (PF(!p_req_madw)) {
+				OSM_LOG(p_vend->p_log, OSM_LOG_ERROR,
+					"ERR 5413: Failed to obtain request "
+					"madw for received MAD "
+					"(class=0x%X method=0x%X attr=0x%X "
+					"tid=0x%"PRIx64") -- dropping\n",
+					p_mad->mgmt_class, p_mad->method,
+					cl_ntoh16(p_mad->attr_id),
+					cl_ntoh64(p_mad->trans_id));
+				osm_mad_pool_put(p_bind->p_mad_pool, p_madw);
+				continue;
+			}
+
+			/*
+			 * Check that request MAD was really a request,
+			 * and make sure that attribute ID, attribute
+			 * modifier and transaction ID are the same in
+			 * request and response.
+			 */
+			p_req_mad = osm_madw_get_mad_ptr(p_req_madw);
+			if (PF(ib_mad_is_response(p_req_mad) ||
+			       p_mad->attr_id != p_req_mad->attr_id ||
+			       p_mad->attr_mod != p_req_mad->attr_mod ||
+			       p_mad->trans_id != p_req_mad->trans_id)) {
+				OSM_LOG(p_vend->p_log, OSM_LOG_ERROR,
+					"ERR 541A: "
+					"Response MAD validation failed "
+					"(request attr=0x%X modif=0x%X "
+					"tid=0x%"PRIx64", "
+					"response attr=0x%X modif=0x%X "
+					"tid=0x%"PRIx64") -- dropping\n",
+					cl_ntoh16(p_req_mad->attr_id),
+					cl_ntoh32(p_req_mad->attr_mod),
+					cl_ntoh64(p_req_mad->trans_id),
+					cl_ntoh16(p_mad->attr_id),
+					cl_ntoh32(p_mad->attr_mod),
+					cl_ntoh64(p_mad->trans_id));
+				osm_mad_pool_put(p_bind->p_mad_pool, p_madw);
+				continue;
+			}
 		}
+
 #ifndef VENDOR_RMPP_SUPPORT
 		if ((p_mad->mgmt_class != IB_MCLASS_SUBN_DIR) &&
 		    (p_mad->mgmt_class != IB_MCLASS_SUBN_LID) &&
-- 
1.7.11.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
