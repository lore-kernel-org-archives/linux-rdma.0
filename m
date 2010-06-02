From: Hal Rosenstock <hnrose-Wuw85uim5zDR7s880joybQ@public.gmane.org>
Subject: [PATCH] infiniband-diags/ibnetdiscover.c: Cosmetic changes
Date: Wed, 2 Jun 2010 09:05:19 -0400
Message-ID: <20100602130519.GC4715@comcast.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org
Cc: weiny2-i2BcT+NCU+M@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


Eliminate unneeded comment
Also, cosmetic formatting change

Signed-off-by: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 infiniband-diags/src/ibnetdiscover.c |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/infiniband-diags/src/ibnetdiscover.c b/infiniband-diags/src/ibnetdiscover.c
index 8f08f06..347e7b2 100644
--- a/infiniband-diags/src/ibnetdiscover.c
+++ b/infiniband-diags/src/ibnetdiscover.c
@@ -501,11 +501,7 @@ int dump_topology(int group, ibnd_fabric_t * fabric)
 			if (!ch->chassisnum)
 				continue;
 			chguid = out_chassis(fabric, ch->chassisnum);
-
 			chname = NULL;
-/**
- * Will this work for Xsigo?
- */
 			if (ibnd_is_xsigo_guid(chguid)) {
 				for (node = ch->nodes; node;
 				     node = node->next_chassis_node) {
-- 
1.5.6.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
