From: Hal Rosenstock <hnrose-Wuw85uim5zDR7s880joybQ@public.gmane.org>
Subject: [PATCH] opensm/osm_vendor_ibumad.c: Add transaction ID to
	osm_vendor_send log message
Date: Wed, 16 Dec 2009 08:57:24 -0500
Message-ID: <20091216135724.GA22488@comcast.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


Signed-off-by: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
diff --git a/opensm/libvendor/osm_vendor_ibumad.c b/opensm/libvendor/osm_vendor_ibumad.c
index 6927060..f360cf4 100644
--- a/opensm/libvendor/osm_vendor_ibumad.c
+++ b/opensm/libvendor/osm_vendor_ibumad.c
@@ -1074,8 +1074,8 @@ Resp:
 			     resp_expected ? p_bind->timeout : 0,
 			     p_bind->max_retries)) < 0) {
 		OSM_LOG(p_vend->p_log, OSM_LOG_ERROR, "ERR 5430: "
-			"Send p_madw = %p of size %d failed %d (%m)\n",
-			p_madw, sent_mad_size, ret);
+			"Send p_madw = %p of size %d TID 0x%" PRIx64 " failed %d (%m)\n",
+			p_madw, sent_mad_size, cl_ntoh64(p_mad->trans_id), ret);
 		if (resp_expected) {
 			get_madw(p_vend, &p_mad->trans_id);	/* remove from aging table */
 			p_madw->status = IB_ERROR;
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
