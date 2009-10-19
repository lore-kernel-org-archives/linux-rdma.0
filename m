From: Hal Rosenstock <hnrose-Wuw85uim5zDR7s880joybQ@public.gmane.org>
Subject: [PATCH] opensm/osm_vendor_ibumad.c: Add environment variable to
	change max retries
Date: Mon, 19 Oct 2009 14:33:42 -0400
Message-ID: <20091019183342.GA28926@comcast.net>
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
index 8d3c680..01250fb 100644
--- a/opensm/libvendor/osm_vendor_ibumad.c
+++ b/opensm/libvendor/osm_vendor_ibumad.c
@@ -446,6 +446,17 @@ osm_vendor_init(IN osm_vendor_t * const p_vend,
 	p_vend->p_log = p_log;
 	p_vend->timeout = timeout;
 	p_vend->max_retries = OSM_DEFAULT_RETRY_COUNT;
+
+	if ((max = getenv("OSM_UMAD_MAX_RETRIES")) != NULL) {
+		int tmp = strtol(max, NULL, 0);
+		if (tmp > 0)
+			p_vend->max_retries = tmp;
+		else
+			OSM_LOG(p_vend->p_log, OSM_LOG_ERROR, "Error:"
+				"OSM_UMAD_MAX_RETRIES=%d is invalid\n",
+				tmp);
+        }
+
 	pthread_mutex_init(&p_vend->cb_mutex, NULL);
 	pthread_mutex_init(&p_vend->match_tbl_mutex, NULL);
 	p_vend->umad_port_id = -1;
@@ -476,12 +487,13 @@ osm_vendor_init(IN osm_vendor_t * const p_vend,
 			p_vend->mtbl.max = tmp;
 		else
 			OSM_LOG(p_vend->p_log, OSM_LOG_ERROR, "Error:"
-				"OSM_UMAD_MAX_PENDING=%d is invalid",
+				"OSM_UMAD_MAX_PENDING=%d is invalid\n",
 				tmp);
 	}
 
-	OSM_LOG(p_vend->p_log, OSM_LOG_INFO, "%d pending umads specified\n",
-		p_vend->mtbl.max);
+	OSM_LOG(p_vend->p_log, OSM_LOG_INFO,
+		"%d max retries %d max pending umads specified\n",
+		p_vend->max_retries, p_vend->mtbl.max);
 
 	p_vend->mtbl.tbl = calloc(p_vend->mtbl.max, sizeof(*(p_vend->mtbl.tbl)));
 	if (!p_vend->mtbl.tbl) {
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
