From: Hal Rosenstock <hnrose-Wuw85uim5zDR7s880joybQ@public.gmane.org>
Subject: [PATCH 1/2] infiniband-diags/libibnetdisc/chassis.c: In
	group_nodes, pass on all nodes
Date: Wed, 2 Jun 2010 09:02:54 -0400
Message-ID: <20100602130254.GA4715@comcast.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org
Cc: weiny2-i2BcT+NCU+M@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


rather than just switches for common SystemImageGUID
Now consistent with original grouping.c from which this was ported

Signed-off-by: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 infiniband-diags/libibnetdisc/src/chassis.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/infiniband-diags/libibnetdisc/src/chassis.c b/infiniband-diags/libibnetdisc/src/chassis.c
index cd2113f..f5f683e 100644
--- a/infiniband-diags/libibnetdisc/src/chassis.c
+++ b/infiniband-diags/libibnetdisc/src/chassis.c
@@ -1059,7 +1059,7 @@ int group_nodes(ibnd_fabric_t * fabric)
 
 	/* now make pass on nodes for chassis which are not Voltaire */
 	/* grouped by common SystemImageGUID */
-	for (node = fabric->switches; node; node = node->type_next) {
+	for (node = fabric->nodes; node; node = node->next) {
 		if (mad_get_field(node->info, 0,
 				  IB_NODE_VENDORID_F) == VTR_VENDOR_ID)
 			continue;
-- 
1.5.6.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
