From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH 2/6] opensm: fix possible double free in osm_ucast_ftree.c
Date: Tue, 11 Jun 2013 14:13:37 -0400
Message-ID: <51B768D1.90503@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Dan Ben-Yosef <danby-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

>From 49f1a71299e4aa28a8319334c772525f67cbd1ca Mon Sep 17 00:00:00 2001
From: Dan Ben Yosef <danby-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Date: Thu, 16 Aug 2012 16:33:55 +0300
Subject: [PATCH 2/6] opensm: fix possible double free in osm_ucast_ftree.c

Only if cl_ptr_vector_at return "CL_SUCCESS"  ,the pointer "p_port" needed to be freed

Signed-off-by: Dan Ben Yosef <danby-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 opensm/osm_ucast_ftree.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/opensm/osm_ucast_ftree.c b/opensm/osm_ucast_ftree.c
index fecc902..dfcd418 100644
--- a/opensm/osm_ucast_ftree.c
+++ b/opensm/osm_ucast_ftree.c
@@ -453,10 +453,10 @@ static void port_group_destroy(IN ftree_port_group_t * p_group)
 
 	/* remove all the elements of p_group->ports vector */
 	size = cl_ptr_vector_get_size(&p_group->ports);
-	for (i = 0; i < size; i++) {
-		cl_ptr_vector_at(&p_group->ports, i, (void *)&p_port);
-		port_destroy(p_port);
-	}
+	for (i = 0; i < size; i++)
+		if (cl_ptr_vector_at(&p_group->ports, i, (void *)&p_port) == CL_SUCCESS)
+			port_destroy(p_port);
+
 	cl_ptr_vector_destroy(&p_group->ports);
 	free(p_group);
 }				/* port_group_destroy() */
-- 
1.7.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
