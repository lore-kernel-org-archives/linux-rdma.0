From: Hal Rosenstock <hnrose-Wuw85uim5zDR7s880joybQ@public.gmane.org>
Subject: [PATCH] opensm/osm_base.h: Update IBA reference to use 1.2.1
Date: Fri, 6 Nov 2009 09:08:08 -0500
Message-ID: <20091106140808.GB19678@comcast.net>
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
diff --git a/opensm/include/opensm/osm_base.h b/opensm/include/opensm/osm_base.h
index a38ae2b..9d8bf98 100644
--- a/opensm/include/opensm/osm_base.h
+++ b/opensm/include/opensm/osm_base.h
@@ -668,7 +668,7 @@ typedef enum _osm_thread_state {
 /***********/
 
 /*
- * OSM_CAP are from Table 117 and C15-0.1.7 Table 186
+ * OSM_CAP are from IBA 1.2.1 Table 117 and Table 188
  */
 
 /****d* OpenSM: Base/OSM_CAP_IS_TRAP_SUP
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
