From: Hal Rosenstock <hnrose-Wuw85uim5zDR7s880joybQ@public.gmane.org>
Subject: [PATCH] opensm/osm_helper.c: Add some missing message names to
	disp_msg_str
Date: Fri, 9 Jul 2010 10:27:05 -0400
Message-ID: <20100709142705.GA29153@comcast.net>
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
diff --git a/opensm/opensm/osm_helper.c b/opensm/opensm/osm_helper.c
index 60724f2..196d5aa 100644
--- a/opensm/opensm/osm_helper.c
+++ b/opensm/opensm/osm_helper.c
@@ -2021,6 +2021,8 @@ static const char *disp_msg_str[] = {
 	"OSM_MSG_MAD_SLVL",
 	"OSM_MSG_MAD_GUIDINFO_RECORD",
 	"OSM_MSG_MAD_INFORM_INFO_RECORD",
+	"OSM_MSG_MAD_SWITCH_INFO_RECORD",
+	"OSM_MSG_MAD_MFT_RECORD",
 #if defined (VENDOR_RMPP_SUPPORT) && defined (DUAL_SIDED_RMPP)
 	"OSM_MSG_MAD_MULTIPATH_RECORD",
 #endif
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
