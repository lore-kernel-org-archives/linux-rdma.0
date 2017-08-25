From: Himanshu Jha <himanshujha199640@gmail.com>
Subject: [PATCH] RDMA/bnxt_re: remove unnecessary call to memset
Date: Fri, 25 Aug 2017 21:41:02 +0530
Message-ID: <1503677462-24238-1-git-send-email-himanshujha199640@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: selvin.xavier@broadcom.com
Cc: devesh.sharma@broadcom.com, somnath.kotur@broadcom.com, dledford@redhat.com, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, Himanshu Jha <himanshujha199640@gmail.com>
List-Id: linux-rdma@vger.kernel.org

call to memset to assign 0 value immediately after allocating
memory with kzalloc is unnecesaary as kzalloc allocates the memory
filled with 0 value.

Signed-off-by: Himanshu Jha <himanshujha199640@gmail.com>
---
 drivers/infiniband/hw/bnxt_re/ib_verbs.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/infiniband/hw/bnxt_re/ib_verbs.c b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
index f0e01b3..fa6fbac 100644
--- a/drivers/infiniband/hw/bnxt_re/ib_verbs.c
+++ b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
@@ -969,7 +969,6 @@ static struct bnxt_re_ah *bnxt_re_create_shadow_qp_ah
 	if (!ah)
 		return NULL;
 
-	memset(ah, 0, sizeof(*ah));
 	ah->rdev = rdev;
 	ah->qplib_ah.pd = &pd->qplib_pd;
 
@@ -1016,7 +1015,6 @@ static struct bnxt_re_qp *bnxt_re_create_shadow_qp
 	if (!qp)
 		return NULL;
 
-	memset(qp, 0, sizeof(*qp));
 	qp->rdev = rdev;
 
 	/* Initialize the shadow QP structure from the QP1 values */
-- 
2.7.4
