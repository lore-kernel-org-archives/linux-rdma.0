From: Hal Rosenstock <hnrose-Wuw85uim5zDR7s880joybQ@public.gmane.org>
Subject: [PATCH] opensm/osm_subnet.h: Add mgrp_mgid_tbl description
Date: Wed, 14 Oct 2009 15:51:50 -0400
Message-ID: <20091014195150.GA18033@comcast.net>
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
diff --git a/opensm/include/opensm/osm_subnet.h b/opensm/include/opensm/osm_subnet.h
index 9488225..b63c97e 100644
--- a/opensm/include/opensm/osm_subnet.h
+++ b/opensm/include/opensm/osm_subnet.h
@@ -634,6 +634,10 @@ typedef struct osm_subn {
 *		This flag should be on during first non-master heavy
 *		(including pre-master discovery stage)
 *
+*	mgrp_mgid_tbl
+*		Container of pointers to all Multicast group objects in
+*		the subnet. Indexed by MGID.
+*
 *	mgroups
 *		Array of pointers to all Multicast Group objects in the subnet.
 *		Indexed by MLID offset from base MLID.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
