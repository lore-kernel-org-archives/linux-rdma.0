Return-Path: <SRS0=zqf9=YA=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09F83C352AA
	for <linux-rdma@archiver.kernel.org>; Mon,  7 Oct 2019 10:42:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DA3832070B
	for <linux-rdma@archiver.kernel.org>; Mon,  7 Oct 2019 10:42:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727345AbfJGKmk (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Mon, 7 Oct 2019 06:42:40 -0400
Received: from stargate.chelsio.com ([12.32.117.8]:19715 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727252AbfJGKmk (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Mon, 7 Oct 2019 06:42:40 -0400
Received: from localhost (budha.blr.asicdesigners.com [10.193.185.4])
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id x97AgZfb028700;
        Mon, 7 Oct 2019 03:42:37 -0700
From:   Krishnamraju Eraparaju <krishna2@chelsio.com>
To:     jgg@ziepe.ca, bmt@zurich.ibm.com
Cc:     linux-rdma@vger.kernel.org, bharat@chelsio.com,
        nirranjan@chelsio.com,
        Krishnamraju Eraparaju <krishna2@chelsio.com>
Subject: [PATCH v1,for-rc] RDMA/siw: free siw_base_qp in kref release routine
Date:   Mon,  7 Oct 2019 16:12:29 +0530
Message-Id: <20191007104229.29412-1-krishna2@chelsio.com>
X-Mailer: git-send-email 2.23.0.rc0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

As siw_free_qp() is the last routine to access 'siw_base_qp' structure,
freeing this structure early in siw_destroy_qp() could cause
touch-after-free issue.
Hence, moved kfree(siw_base_qp) from siw_destroy_qp() to siw_free_qp().

Fixes: 303ae1cdfdf7 ("rdma/siw: application interface")
Signed-off-by: Krishnamraju Eraparaju <krishna2@chelsio.com>
---
v0 -> v1:
- added "Fixes" line.
---
 drivers/infiniband/sw/siw/siw_qp.c    | 2 ++
 drivers/infiniband/sw/siw/siw_verbs.c | 2 --
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/sw/siw/siw_qp.c b/drivers/infiniband/sw/siw/siw_qp.c
index 430314c8abd9..c317f6e18ea8 100644
--- a/drivers/infiniband/sw/siw/siw_qp.c
+++ b/drivers/infiniband/sw/siw/siw_qp.c
@@ -1305,6 +1305,7 @@ int siw_qp_add(struct siw_device *sdev, struct siw_qp *qp)
 void siw_free_qp(struct kref *ref)
 {
 	struct siw_qp *found, *qp = container_of(ref, struct siw_qp, ref);
+	struct siw_base_qp *siw_base_qp = to_siw_base_qp(qp->ib_qp);
 	struct siw_device *sdev = qp->sdev;
 	unsigned long flags;
 
@@ -1327,4 +1328,5 @@ void siw_free_qp(struct kref *ref)
 	atomic_dec(&sdev->num_qp);
 	siw_dbg_qp(qp, "free QP\n");
 	kfree_rcu(qp, rcu);
+	kfree(siw_base_qp);
 }
diff --git a/drivers/infiniband/sw/siw/siw_verbs.c b/drivers/infiniband/sw/siw/siw_verbs.c
index 869e02b69a01..b18a677832e1 100644
--- a/drivers/infiniband/sw/siw/siw_verbs.c
+++ b/drivers/infiniband/sw/siw/siw_verbs.c
@@ -604,7 +604,6 @@ int siw_verbs_modify_qp(struct ib_qp *base_qp, struct ib_qp_attr *attr,
 int siw_destroy_qp(struct ib_qp *base_qp, struct ib_udata *udata)
 {
 	struct siw_qp *qp = to_siw_qp(base_qp);
-	struct siw_base_qp *siw_base_qp = to_siw_base_qp(base_qp);
 	struct siw_ucontext *uctx =
 		rdma_udata_to_drv_context(udata, struct siw_ucontext,
 					  base_ucontext);
@@ -641,7 +640,6 @@ int siw_destroy_qp(struct ib_qp *base_qp, struct ib_udata *udata)
 	qp->scq = qp->rcq = NULL;
 
 	siw_qp_put(qp);
-	kfree(siw_base_qp);
 
 	return 0;
 }
-- 
2.23.0.rc0

