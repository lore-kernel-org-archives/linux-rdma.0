From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH OpenSM] osm_vendor_ibumad.c: Improve ERR 5430 log message
Date: Mon, 07 Oct 2013 16:35:36 -0400
Message-ID: <52531B18.1010304@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Add in class, method and attribute so have better idea on failure without
increasing log verbosity

Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
diff --git a/libvendor/osm_vendor_ibumad.c b/libvendor/osm_vendor_ibumad.c
index ee14f5b..19551a5 100644
--- a/libvendor/osm_vendor_ibumad.c
+++ b/libvendor/osm_vendor_ibumad.c
@@ -1138,8 +1138,10 @@ Resp:
 			     resp_expected ? p_bind->timeout : 0,
 			     p_bind->max_retries)) < 0) {
 		OSM_LOG(p_vend->p_log, OSM_LOG_ERROR, "ERR 5430: "
-			"Send p_madw = %p of size %d TID 0x%" PRIx64 " failed %d (%m)\n",
-			p_madw, sent_mad_size, tid, ret);
+			"Send p_madw = %p of size %d, Class 0x%x, Method 0x%X, "
+			"Attr 0x%X, TID 0x%" PRIx64 " failed %d (%m)\n",
+			p_madw, sent_mad_size, p_mad->mgmt_class,
+			p_mad->method, cl_ntoh16(p_mad->attr_id), tid, ret);
 		if (resp_expected) {
 			get_madw(p_vend, &p_mad->trans_id,
 				 p_mad->mgmt_class);	/* remove from aging table */
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
