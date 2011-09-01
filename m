From: Albert Chu <chu11-i2BcT+NCU+M@public.gmane.org>
Subject: [opensm] [PATCH] Fix invalid error check, which lead to segfault
Date: Thu, 01 Sep 2011 16:30:47 -0700
Message-ID: <1314919847.25283.446.camel@auk59.llnl.gov>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-e6pQ+F5q3LAi7lP/T98P"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--=-e6pQ+F5q3LAi7lP/T98P
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

This patch fixes a bug from:

commit 350c6e49fe3ee492b397346633dee76d3cad9ade
Author: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Date:   Mon Mar 7 10:03:59 2011 +0000

    opensm: fixed potential memory leak in osm_ucast_ftree()

    Need to free all the allocated variables in case of error.

The invalid error check would lead to sw_create() always returning NULL,
leading to fabric_add_sw() never adding a switch to sw_tbl, leading to
fabric_get_sw_by_guid() always returning NULL (i.e. can't find switch),
leading to rank_leaf_switches() segfaulting.

Al

-- 
Albert Chu
chu11-i2BcT+NCU+M@public.gmane.org
Computer Scientist
High Performance Systems Division
Lawrence Livermore National Laboratory


--=-e6pQ+F5q3LAi7lP/T98P
Content-Disposition: attachment; filename=0001-Fix-invalid-error-check-which-lead-to-segfault.patch
Content-Type: message/rfc822; name=0001-Fix-invalid-error-check-which-lead-to-segfault.patch

From: Albert Chu <chu11-i2BcT+NCU+M@public.gmane.org>
Date: Thu, 1 Sep 2011 16:24:27 -0700
Subject: [PATCH] Fix invalid error check, which lead to segfault
Message-Id: <1314919834.25283.445.camel-akkeaxHeDKRliZ7u+bvwcg@public.gmane.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit

The invalid error check would lead to sw_create() always
returning NULL, leading to fabric_add_sw() never adding a
switch to sw_tbl, leading to fabric_get_sw_by_guid() always
returning NULL (i.e. can't find switch), leading to rank_leaf_switches()
segfaulting.

Signed-off-by: Albert Chu <chu11-i2BcT+NCU+M@public.gmane.org>
---
 opensm/osm_ucast_ftree.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/opensm/osm_ucast_ftree.c b/opensm/osm_ucast_ftree.c
index 99a526d..06508c8 100644
--- a/opensm/osm_ucast_ftree.c
+++ b/opensm/osm_ucast_ftree.c
@@ -560,7 +560,7 @@ static ftree_sw_t *sw_create(IN ftree_fabric_t * p_ftree,
 	p_sw->up_port_groups =
 	    (ftree_port_group_t **) malloc(ports_num *
 					   sizeof(ftree_port_group_t *));
-	if (p_sw->sibling_port_groups == NULL)
+	if (p_sw->up_port_groups == NULL)
 		goto FREE_DOWN;
 
 	p_sw->sibling_port_groups =
-- 
1.7.1


--=-e6pQ+F5q3LAi7lP/T98P--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
