Return-Path: <SRS0=QgBH=CC=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05C0CC433E1
	for <linux-rdma@archiver.kernel.org>; Mon, 24 Aug 2020 10:33:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C6863214F1
	for <linux-rdma@archiver.kernel.org>; Mon, 24 Aug 2020 10:33:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1598265207;
	bh=JaspX95wfYtN1z/T9fZT+PXfqr3ytNl13OdOmuiZ9ms=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=YlVdDn25rrOIHPq35s1C7GRPftu0EFW9LmtNE3jrzNUqBn7pq58937HVaPIwZ68nB
	 bHMi6OVtTcbqGCcW2hpSaWzipBhjOEJzaCQ2fXvBmR0XtmhOF8UFwdNzkPQGl7iC4L
	 f8uR4RCis6k01z+NF3q7+8Q406TjGfG7VkTtzXnU=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725968AbgHXKdJ (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Mon, 24 Aug 2020 06:33:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:55526 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726956AbgHXKdA (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Mon, 24 Aug 2020 06:33:00 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2B4B92075B;
        Mon, 24 Aug 2020 10:32:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598265179;
        bh=JaspX95wfYtN1z/T9fZT+PXfqr3ytNl13OdOmuiZ9ms=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OiCYzudqISG1ZLt+FJfs8hNGPFbgM4VWd+0fTAYDPIiA4gnUv1R0eih9c8Kz++LeF
         UVUer5WMyr6sHjIKhfL9q7jfbjMNTtTDJVu6eE9HY9QpjDi7N4OpKGC4yWhScrQTXe
         n2oIyCNpRWk9z4fOWo6jMI/yS2M8eHsXEk4QvmwE=
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Cc:     Leon Romanovsky <leonro@mellanox.com>, linux-rdma@vger.kernel.org
Subject: [PATCH rdma-next 03/10] RDMA/mlx5: Issue FW command to destroy SRQ on reentry
Date:   Mon, 24 Aug 2020 13:32:40 +0300
Message-Id: <20200824103247.1088464-4-leon@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200824103247.1088464-1-leon@kernel.org>
References: <20200824103247.1088464-1-leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro@mellanox.com>

The HW release can fail and leave the system in limbo state,
where SRQ is removed from the table, but can't be destroyed later.
In every reentry, the initial xa_erase_irq() check will fail.

Rewrite the erase logic to keep index, but don't store the entry
itself. By doing it, we can safely reinsert entry back in the case
of destroy failure and be safe from any xa_store_irq() error.

Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/infiniband/hw/mlx5/srq_cmd.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/srq_cmd.c b/drivers/infiniband/hw/mlx5/srq_cmd.c
index 37aaacebd3f2..c6d807f04d9d 100644
--- a/drivers/infiniband/hw/mlx5/srq_cmd.c
+++ b/drivers/infiniband/hw/mlx5/srq_cmd.c
@@ -596,13 +596,22 @@ void mlx5_cmd_destroy_srq(struct mlx5_ib_dev *dev, struct mlx5_core_srq *srq)
 	struct mlx5_core_srq *tmp;
 	int err;
 
-	tmp = xa_erase_irq(&table->array, srq->srqn);
-	if (!tmp || tmp != srq)
+	/* Delete entry, but leave index occupied */
+	tmp = xa_store_irq(&table->array, srq->srqn, NULL, 0);
+	if (WARN_ON(!tmp || tmp != srq))
 		return;
 
 	err = destroy_srq_split(dev, srq);
-	if (err)
+	if (err) {
+		/*
+		 * We don't need to check returned result for an error,
+		 * because  we are storing in pre-allocated space xarray
+		 * entry and it can't fail at this stage.
+		 */
+		xa_store_irq(&table->array, srq->srqn, srq, 0);
 		return;
+	}
+	xa_erase_irq(&table->array, srq->srqn);
 
 	mlx5_core_res_put(&srq->common);
 	wait_for_completion(&srq->common.free);
-- 
2.26.2

