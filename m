Return-Path: <linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D32EDC433ED
	for <linux-rdma@archiver.kernel.org>; Sun,  9 May 2021 11:41:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A03B5610A0
	for <linux-rdma@archiver.kernel.org>; Sun,  9 May 2021 11:41:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229593AbhEILmr (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Sun, 9 May 2021 07:42:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:58504 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229585AbhEILmq (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Sun, 9 May 2021 07:42:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B8DB2610A0;
        Sun,  9 May 2021 11:41:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620560503;
        bh=ZS3YEvtc2pR0lhtS1vLZ7khrYTL9Kd4ze0vI/bUnaCk=;
        h=From:To:Cc:Subject:Date:From;
        b=HA1tW33FkDopR1x122eN0p6+4VSRxXxE8yeGnuOiioitQ6/0hsg7nO0xIMj9Sr/zl
         JXNA9TkQDmGPQ8yh3URWq7CcrscQBT2n5ZwVwrt9ZBUVbz2XiKKvjV8xwRmpwvb8PO
         3idFGHGyg57SGZYuxhQAz3pFV9TbvlZirbxmUDFeA9zvMFBtxmGe3xUYGj0EV2DLe7
         cOlwKHXBGG83VUVUox1EW0CogZmxrMz80PDfteadA2Jheb5k0wsHKBIKd1Jr9aujUc
         6RlDMDLwLjY19N5Hbs5cG7ZEgBJ1ECkYKLhtLqGiyw+0W2FrlCya25OtOgY+4ChG5e
         64VOUEuoHanUg==
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        Bernard Metzler <bmt@zurich.ibm.com>,
        linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org
Subject: [PATCH rdma-rc] RDMA/siw: Release xarray entry
Date:   Sun,  9 May 2021 14:41:38 +0300
Message-Id: <f070b59d5a1114d5a4e830346755c2b3f141cde5.1620560472.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

The xarray entry is allocated in siw_qp_add(), but release was
missed in case zero-sized SQ was discovered.

Fixes: 661f385961f0 ("RDMA/siw: Fix handling of zero-sized Read and Receive Queues.")
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/infiniband/sw/siw/siw_verbs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/sw/siw/siw_verbs.c b/drivers/infiniband/sw/siw/siw_verbs.c
index 917c8a919f38..3f175f220a22 100644
--- a/drivers/infiniband/sw/siw/siw_verbs.c
+++ b/drivers/infiniband/sw/siw/siw_verbs.c
@@ -375,7 +375,7 @@ struct ib_qp *siw_create_qp(struct ib_pd *pd,
 	else {
 		/* Zero sized SQ is not supported */
 		rv = -EINVAL;
-		goto err_out;
+		goto err_out_xa;
 	}
 	if (num_rqe)
 		num_rqe = roundup_pow_of_two(num_rqe);
-- 
2.31.1

