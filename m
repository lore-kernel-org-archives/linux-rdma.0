From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 1/7] IB/rdmavt: Check lkey_table_size value before use
Date: Fri, 26 Feb 2016 13:33:08 -0800
Message-ID: <20160226213307.16535.52542.stgit@scvm10.sc.intel.com>
References: <20160226213022.16535.8149.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160226213022.16535.8149.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

The lkey_table_size driver specific parameter value is used before its
value is sanity checked and restricted to RVT_MAX_LKEY_TABLE_BITS.

This causes a vmalloc allocation failure for large values. Fix this
by moving the value check before the first usage of the value.

Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/sw/rdmavt/mr.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/sw/rdmavt/mr.c b/drivers/infiniband/sw/rdmavt/mr.c
index 4d5ef73..0ff765b 100644
--- a/drivers/infiniband/sw/rdmavt/mr.c
+++ b/drivers/infiniband/sw/rdmavt/mr.c
@@ -76,8 +76,6 @@ int rvt_driver_mr_init(struct rvt_dev_info *rdi)
 
 	spin_lock_init(&rdi->lkey_table.lock);
 
-	rdi->lkey_table.max = 1 << lkey_table_size;
-
 	/* ensure generation is at least 4 bits */
 	if (lkey_table_size > RVT_MAX_LKEY_TABLE_BITS) {
 		rvt_pr_warn(rdi, "lkey bits %u too large, reduced to %u\n",
@@ -85,6 +83,7 @@ int rvt_driver_mr_init(struct rvt_dev_info *rdi)
 		rdi->dparms.lkey_table_size = RVT_MAX_LKEY_TABLE_BITS;
 		lkey_table_size = rdi->dparms.lkey_table_size;
 	}
+	rdi->lkey_table.max = 1 << lkey_table_size;
 	lk_tab_size = rdi->lkey_table.max * sizeof(*rdi->lkey_table.table);
 	rdi->lkey_table.table = (struct rvt_mregion __rcu **)
 			       vmalloc_node(lk_tab_size, rdi->dparms.node);

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
