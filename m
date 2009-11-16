From: Hal Rosenstock <hnrose-Wuw85uim5zDR7s880joybQ@public.gmane.org>
Subject: [PATCH] opensm/libvendor/osm_vendor_ibumad.c: Cosmetic change to
	OSM_LOG message
Date: Mon, 16 Nov 2009 13:43:03 -0500
Message-ID: <20091116184303.GB2417@comcast.net>
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
index 0f5a7ae..5ea79cb 100644
--- a/opensm/libvendor/osm_vendor_ibumad.c
+++ b/opensm/libvendor/osm_vendor_ibumad.c
@@ -353,7 +353,7 @@ static void *umad_receiver(void *p_ptr)
 				OSM_LOG(p_vend->p_log, OSM_LOG_ERROR,
 					"ERR 5412: "
 					"Failed to obtain request madw for timed out MAD"
-					"(method=0x%X attr=0x%X tid=0x%"PRIx64") -- dropping\n",
+					" (method=0x%X attr=0x%X tid=0x%"PRIx64") -- dropping\n",
 					mad->method, cl_ntoh16(mad->attr_id),
 					cl_ntoh64(mad->trans_id));
 			} else {
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
