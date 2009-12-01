From: Hal Rosenstock <hnrose-Wuw85uim5zDR7s880joybQ@public.gmane.org>
Subject: [PATCH] opensm/osm_vendor_ibumad.c: Change LID format to decimal
	in log message
Date: Tue, 1 Dec 2009 08:14:56 -0500
Message-ID: <20091201131456.GB12753@comcast.net>
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
index 5ea79cb..8f9bbf5 100644
--- a/opensm/libvendor/osm_vendor_ibumad.c
+++ b/opensm/libvendor/osm_vendor_ibumad.c
@@ -334,7 +334,7 @@ static void *umad_receiver(void *p_ptr)
 			if (mad->mgmt_class != IB_MCLASS_SUBN_DIR) {
 				/* LID routed */
 				OSM_LOG(p_vend->p_log, OSM_LOG_ERROR,
-					"ERR 5410: class 0x%x LID 0x%x\n",
+					"ERR 5410: class 0x%x LID %u\n",
 					mad->mgmt_class,
 					cl_ntoh16(ib_mad_addr->lid));
 			} else {
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
