Return-Path: <SRS0=sZ6g=XS=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79A1AC432C1
	for <linux-rdma@archiver.kernel.org>; Mon, 23 Sep 2019 21:32:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4A058206C2
	for <linux-rdma@archiver.kernel.org>; Mon, 23 Sep 2019 21:32:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389665AbfIWVc6 (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Mon, 23 Sep 2019 17:32:58 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:35238 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729120AbfIWVc6 (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Mon, 23 Sep 2019 17:32:58 -0400
Received: from Internal Mail-Server by MTLPINE1 (envelope-from maxg@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 24 Sep 2019 00:32:51 +0300
Received: from r-vnc12.mtr.labs.mlnx (r-vnc12.mtr.labs.mlnx [10.208.0.12])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id x8NLWp5F012417;
        Tue, 24 Sep 2019 00:32:51 +0300
From:   Max Gurtovoy <maxg@mellanox.com>
To:     jgg@mellanox.com, linux-rdma@vger.kernel.org, dledford@redhat.com,
        leonro@mellanox.com, sagi@grimberg.me
Cc:     Max Gurtovoy <maxg@mellanox.com>
Subject: [PATCH 1/1] IB/iser: add unlikely checks in the fast path
Date:   Tue, 24 Sep 2019 00:32:49 +0300
Message-Id: <1569274369-29217-1-git-send-email-maxg@mellanox.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

ib_post_send, ib_post_recv and ib_dma_map_sg  operations should succeed
unless something unusual happened to the ib device.

Signed-off-by: Max Gurtovoy <maxg@mellanox.com>
---
 drivers/infiniband/ulp/iser/iser_memory.c | 2 +-
 drivers/infiniband/ulp/iser/iser_verbs.c  | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/ulp/iser/iser_memory.c b/drivers/infiniband/ulp/iser/iser_memory.c
index 2cc89a9..3a26e5b 100644
--- a/drivers/infiniband/ulp/iser/iser_memory.c
+++ b/drivers/infiniband/ulp/iser/iser_memory.c
@@ -170,7 +170,7 @@ int iser_dma_map_task_data(struct iscsi_iser_task *iser_task,
 	dev = iser_task->iser_conn->ib_conn.device->ib_device;
 
 	data->dma_nents = ib_dma_map_sg(dev, data->sg, data->size, dma_dir);
-	if (data->dma_nents == 0) {
+	if (unlikely(data->dma_nents == 0)) {
 		iser_err("dma_map_sg failed!!!\n");
 		return -EINVAL;
 	}
diff --git a/drivers/infiniband/ulp/iser/iser_verbs.c b/drivers/infiniband/ulp/iser/iser_verbs.c
index a6548de..94b5011 100644
--- a/drivers/infiniband/ulp/iser/iser_verbs.c
+++ b/drivers/infiniband/ulp/iser/iser_verbs.c
@@ -1019,7 +1019,7 @@ int iser_post_recvm(struct iser_conn *iser_conn, int count)
 
 	ib_conn->post_recv_buf_count += count;
 	ib_ret = ib_post_recv(ib_conn->qp, ib_conn->rx_wr, NULL);
-	if (ib_ret) {
+	if (unlikely(ib_ret)) {
 		iser_err("ib_post_recv failed ret=%d\n", ib_ret);
 		ib_conn->post_recv_buf_count -= count;
 	} else
@@ -1060,7 +1060,7 @@ int iser_post_send(struct ib_conn *ib_conn, struct iser_tx_desc *tx_desc,
 		first_wr = wr;
 
 	ib_ret = ib_post_send(ib_conn->qp, first_wr, NULL);
-	if (ib_ret)
+	if (unlikely(ib_ret))
 		iser_err("ib_post_send failed, ret:%d opcode:%d\n",
 			 ib_ret, wr->opcode);
 
-- 
1.8.3.1

