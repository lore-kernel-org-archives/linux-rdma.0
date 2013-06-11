From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH 4/6] osm_ucast_ftree.c: fix dereferencing null variable
Date: Tue, 11 Jun 2013 14:13:48 -0400
Message-ID: <51B768DC.8060003@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Dan Ben-Yosef <danby-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

>From 35f4419e6f2451f2124e826e8e93b02c733d068c Mon Sep 17 00:00:00 2001
From: Dan Ben Yosef <danby-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Date: Sun, 2 Dec 2012 16:07:49 +0200
Subject: [PATCH 4/6] osm_ucast_ftree.c: fix dereferencing null variable

Dereferencing null variable "p_port".

Signed-off-by: Dan Ben Yosef <danby-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
---
 opensm/osm_ucast_ftree.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/opensm/osm_ucast_ftree.c b/opensm/osm_ucast_ftree.c
index a293803..decfc82 100644
--- a/opensm/osm_ucast_ftree.c
+++ b/opensm/osm_ucast_ftree.c
@@ -2591,6 +2591,8 @@ fabric_route_downgoing_by_going_up(IN ftree_fabric_t * p_ftree,
 		   trying to balance these routes - always pick port 0. */
 		p_min_port = NULL;
 		ports_num = (uint16_t) cl_ptr_vector_get_size(&p_group->ports);
+		if(ports_num == 0)
+			continue;
 		for (j = 0; j < ports_num; j++) {
 			cl_ptr_vector_at(&p_group->ports, j, (void *)&p_port);
 			if (!p_min_port) {
-- 
1.7.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
