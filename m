From: Hal Rosenstock <hnrose-Wuw85uim5zDR7s880joybQ@public.gmane.org>
Subject: [PATCH] opensm: Add some additional HP vendor IDs/OUIs
Date: Mon, 19 Oct 2009 09:00:28 -0400
Message-ID: <20091019130028.GA18483@comcast.net>
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
index 06223ce..34646cd 100644
--- a/opensm/include/opensm/osm_base.h
+++ b/opensm/include/opensm/osm_base.h
@@ -906,6 +906,8 @@ typedef enum _osm_sm_signal {
 #define OSM_VENDOR_ID_HP2           0x0018FE
 #define OSM_VENDOR_ID_DELL          0x00188B
 #define OSM_VENDOR_ID_SUPERMICRO    0x003048
+#define OSM_VENDOR_ID_HP3           0x0019BB
+#define OSM_VENDOR_ID_HP4           0x00237D
 
 /**********/
 
diff --git a/opensm/opensm/osm_helper.c b/opensm/opensm/osm_helper.c
index 40dea10..4f520ba 100644
--- a/opensm/opensm/osm_helper.c
+++ b/opensm/opensm/osm_helper.c
@@ -2210,6 +2210,8 @@ const char *osm_get_manufacturer_str(IN uint64_t guid_ho)
 		return (panta_str);
 	case OSM_VENDOR_ID_HP:
 	case OSM_VENDOR_ID_HP2:
+	case OSM_VENDOR_ID_HP3:
+	case OSM_VENDOR_ID_HP4:
 		return (hp_str);
 	case OSM_VENDOR_ID_RIOWORKS:
 		return (rioworks_str);
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
