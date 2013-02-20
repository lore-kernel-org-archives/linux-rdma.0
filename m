From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH] libvendor/osm_vendor_ibumad.c: fix mad validation in case
 of multipath record response
Date: Wed, 20 Feb 2013 09:47:18 -0500
Message-ID: <5124E1F6.3060501@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Daniel Klein <danielk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


o15-0.2-1.11: SA response to a SubnAdmGetMulti() containing
MultiPathRecord shall have PathRecord attribute ID.

Signed-off-by: Daniel Klein <danielk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Yevgeny Kliteynik <kliteyn-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

diff --git a/libvendor/osm_vendor_ibumad.c b/libvendor/osm_vendor_ibumad.c
index 63b9594..f0427a3 100644
--- a/libvendor/osm_vendor_ibumad.c
+++ b/libvendor/osm_vendor_ibumad.c
@@ -415,10 +415,18 @@ static void *umad_receiver(void *p_ptr)
 			 * and make sure that attribute ID, attribute
 			 * modifier and transaction ID are the same in
 			 * request and response.
+			 *
+			 * Exception for o15-0.2-1.11:
+			 * SA response to a SubnAdmGetMulti() containing a
+			 * MultiPathRecord shall have PathRecord attribute ID.
 			 */
 			p_req_mad = osm_madw_get_mad_ptr(p_req_madw);
 			if (PF(ib_mad_is_response(p_req_mad) ||
-			       p_mad->attr_id != p_req_mad->attr_id ||
+			       (p_mad->attr_id != p_req_mad->attr_id &&
+                                !(p_mad->mgmt_class == IB_MCLASS_SUBN_ADM &&
+                                  p_req_mad->attr_id ==
+					IB_MAD_ATTR_MULTIPATH_RECORD &&
+                                  p_mad->attr_id == IB_MAD_ATTR_PATH_RECORD)) ||
 			       p_mad->attr_mod != p_req_mad->attr_mod ||
 			       p_mad->trans_id != p_req_mad->trans_id)) {
 				OSM_LOG(p_vend->p_log, OSM_LOG_ERROR,
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
