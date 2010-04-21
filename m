From: Line Holen <Line.Holen-UdXhSnd/wVw@public.gmane.org>
Subject: [PATCH] opensm/osm_sa_path_record.c: Lower max number of hops allowed
Date: Wed, 21 Apr 2010 13:22:02 +0200
Message-ID: <4BCEDFDA.7000500@Sun.COM>
Mime-Version: 1.0
Content-Type: text/plain; CHARSET=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Lower max number of hops allowed in a path from 128 to 64.

Signed-off-by: Line Holen <Line.Holen-xsfywfwIY+M@public.gmane.org>

---

diff --git a/opensm/opensm/osm_sa_path_record.c b/opensm/opensm/osm_sa_path_record.c
index 62102f4..9f508db 100644
--- a/opensm/opensm/osm_sa_path_record.c
+++ b/opensm/opensm/osm_sa_path_record.c
@@ -70,7 +70,7 @@
 #include <opensm/osm_prefix_route.h>
 #include <opensm/osm_ucast_lash.h>
 
-#define MAX_HOPS 128
+#define MAX_HOPS 64
 
 typedef struct osm_pr_item {
 	cl_list_item_t list_item;
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
