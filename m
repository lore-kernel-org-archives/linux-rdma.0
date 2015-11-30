From: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 2/2] IB/qib: Fix qib_mr structure
Date: Mon, 30 Nov 2015 09:34:26 -0500
Message-ID: <20151130143426.24060.87964.stgit@phlsvslse11.ph.intel.com>
References: <20151130143326.24060.35941.stgit@phlsvslse11.ph.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20151130143326.24060.35941.stgit-K+u1se/DcYrLESAwzcoQNrvm/XP+8Wra@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

struct qib_mr requires the mr member be the last because struct
qib_mregion contains a dynamic array at the end.  The additions
of members should have been placed before this structure as the
comment noted.

Failure to do so was causing random memory corruption.  Reproducing
this bug was easy to do by running the client and server of
ib_write_bw -s 8 -n 5 on the same node.

This BUG() was tripped in a slab debug kernel:

kernel BUG at mm/slab.c:2572!

Fixes: 38071a461f0a ("IB/qib: Support the new memory registration API")
Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/qib/qib_verbs.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/qib/qib_verbs.h b/drivers/infiniband/hw/qib/qib_verbs.h
index 2baf5ad..bc803f3 100644
--- a/drivers/infiniband/hw/qib/qib_verbs.h
+++ b/drivers/infiniband/hw/qib/qib_verbs.h
@@ -329,9 +329,9 @@ struct qib_sge {
 struct qib_mr {
 	struct ib_mr ibmr;
 	struct ib_umem *umem;
-	struct qib_mregion mr;  /* must be last */
 	u64 *pages;
 	u32 npages;
+	struct qib_mregion mr;  /* must be last */
 };
 
 /*

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
