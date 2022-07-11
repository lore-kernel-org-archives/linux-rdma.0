Return-Path: <linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28076C433EF
	for <linux-rdma@archiver.kernel.org>; Mon, 11 Jul 2022 15:13:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232207AbiGKPNA (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Mon, 11 Jul 2022 11:13:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230496AbiGKPM7 (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Mon, 11 Jul 2022 11:12:59 -0400
Received: from mail.ispras.ru (mail.ispras.ru [83.149.199.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 816F574E1E;
        Mon, 11 Jul 2022 08:12:58 -0700 (PDT)
Received: from andrey-lpc.intra.ispras.ru (unknown [83.149.199.65])
        by mail.ispras.ru (Postfix) with ESMTPS id C568D40737D8;
        Mon, 11 Jul 2022 15:12:56 +0000 (UTC)
From:   Andrey Strachuk <strochuk@ispras.ru>
To:     Bernard Metzler <bmt@zurich.ibm.com>
Cc:     Andrey Strachuk <strochuk@ispras.ru>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Leon Romanovsky <leon@kernel.org>, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org, ldv-project@linuxtesting.org
Subject: [PATCH] RDMA: remove useless condition in siw_create_cq()
Date:   Mon, 11 Jul 2022 18:12:51 +0300
Message-Id: <20220711151251.17089-1-strochuk@ispras.ru>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

Comparison of 'cq' with NULL is useless since
'cq' is a result of container_of and cannot be NULL
in any reasonable scenario.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Signed-off-by: Andrey Strachuk <strochuk@ispras.ru>
Fixes: 303ae1cdfdf7 ("rdma/siw: application interface")
---
 drivers/infiniband/sw/siw/siw_verbs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/sw/siw/siw_verbs.c b/drivers/infiniband/sw/siw/siw_verbs.c
index 09316072b789..8dedae7ae79e 100644
--- a/drivers/infiniband/sw/siw/siw_verbs.c
+++ b/drivers/infiniband/sw/siw/siw_verbs.c
@@ -1167,7 +1167,7 @@ int siw_create_cq(struct ib_cq *base_cq, const struct ib_cq_init_attr *attr,
 err_out:
 	siw_dbg(base_cq->device, "CQ creation failed: %d", rv);
 
-	if (cq && cq->queue) {
+	if (cq->queue) {
 		struct siw_ucontext *ctx =
 			rdma_udata_to_drv_context(udata, struct siw_ucontext,
 						  base_ucontext);
-- 
2.25.1

