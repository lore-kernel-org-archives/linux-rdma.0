Return-Path: <linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DDCC5C43334
	for <linux-rdma@archiver.kernel.org>; Mon,  4 Jul 2022 08:54:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231871AbiGDIyr (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Mon, 4 Jul 2022 04:54:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230499AbiGDIyq (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Mon, 4 Jul 2022 04:54:46 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4177204
        for <linux-rdma@vger.kernel.org>; Mon,  4 Jul 2022 01:54:44 -0700 (PDT)
X-IronPort-AV: E=McAfee;i="6400,9594,10397"; a="283805389"
X-IronPort-AV: E=Sophos;i="5.92,243,1650956400"; 
   d="scan'208";a="283805389"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jul 2022 01:54:37 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,243,1650956400"; 
   d="scan'208";a="567104476"
Received: from unknown (HELO intel-71.bj.intel.com) ([10.238.154.71])
  by orsmga006.jf.intel.com with ESMTP; 04 Jul 2022 01:54:35 -0700
From:   yanjun.zhu@linux.dev
To:     jgg@ziepe.ca, leon@kernel.org, linux-rdma@vger.kernel.org,
        yanjun.zhu@linux.dev
Subject: [PATCH 1/1] RDMA/rxe: Fix BUG: KASAN: null-ptr-deref in rxe_qp_do_cleanup
Date:   Mon,  4 Jul 2022 21:22:12 -0400
Message-Id: <20220705012212.294534-1-yanjun.zhu@linux.dev>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

From: Zhu Yanjun <yanjun.zhu@linux.dev>

In some error handlers, both scq and rcq are set to NULL before
calling rxe_qp_do_cleanup.

Fixes: 4703b4f0d94a ("RDMA/rxe: Enforce IBA C11-17")
Signed-off-by: Zhu Yanjun <yanjun.zhu@linux.dev>
---
 drivers/infiniband/sw/rxe/rxe_qp.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/sw/rxe/rxe_qp.c b/drivers/infiniband/sw/rxe/rxe_qp.c
index 22e9b85344c3..b79e1b43454e 100644
--- a/drivers/infiniband/sw/rxe/rxe_qp.c
+++ b/drivers/infiniband/sw/rxe/rxe_qp.c
@@ -804,13 +804,15 @@ static void rxe_qp_do_cleanup(struct work_struct *work)
 	if (qp->rq.queue)
 		rxe_queue_cleanup(qp->rq.queue);
 
-	atomic_dec(&qp->scq->num_wq);
-	if (qp->scq)
+	if (qp->scq) {
+		atomic_dec(&qp->scq->num_wq);
 		rxe_put(qp->scq);
+	}
 
-	atomic_dec(&qp->rcq->num_wq);
-	if (qp->rcq)
+	if (qp->rcq) {
+		atomic_dec(&qp->rcq->num_wq);
 		rxe_put(qp->rcq);
+	}
 
 	if (qp->pd)
 		rxe_put(qp->pd);
-- 
2.34.1

