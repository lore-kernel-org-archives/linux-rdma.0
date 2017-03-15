From: Dasaratharaman Chandramouli
        <dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH rdma-core 2/7] IB/SA: Add braces when using sizeof
Date: Wed, 15 Mar 2017 17:24:21 -0400
Message-ID: <1489613066-61684-3-git-send-email-dasaratharaman.chandramouli@intel.com>
References: <1489613066-61684-1-git-send-email-dasaratharaman.chandramouli@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1489613066-61684-1-git-send-email-dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Don Hiatt <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This fixes a checkpatch issue. The fix is needed
so that some of these functions can be moved around
in the forthcoming patches

Reviewed-by: Don Hiatt <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dasaratharaman Chandramouli <dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/core/sa_query.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/core/sa_query.c b/drivers/infiniband/core/sa_query.c
index 60c0405..8cfe636 100644
--- a/drivers/infiniband/core/sa_query.c
+++ b/drivers/infiniband/core/sa_query.c
@@ -944,7 +944,7 @@ static void update_sm_ah(struct work_struct *work)
 		return;
 	}
 
-	new_ah = kmalloc(sizeof *new_ah, GFP_KERNEL);
+	new_ah = kmalloc(sizeof(*new_ah), GFP_KERNEL);
 	if (!new_ah) {
 		return;
 	}
@@ -957,7 +957,7 @@ static void update_sm_ah(struct work_struct *work)
 			 IB_DEFAULT_PKEY_FULL, &new_ah->pkey_index))
 		pr_err("Couldn't find index for default PKey\n");
 
-	memset(&ah_attr, 0, sizeof ah_attr);
+	memset(&ah_attr, 0, sizeof(ah_attr));
 	ah_attr.dlid     = port_attr.sm_lid;
 	ah_attr.sl       = port_attr.sm_sl;
 	ah_attr.port_num = port->port_num;
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
