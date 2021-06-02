Return-Path: <linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01F1EC47092
	for <linux-rdma@archiver.kernel.org>; Wed,  2 Jun 2021 10:09:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DFD88613D0
	for <linux-rdma@archiver.kernel.org>; Wed,  2 Jun 2021 10:09:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229822AbhFBKLF (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Wed, 2 Jun 2021 06:11:05 -0400
Received: from out30-130.freemail.mail.aliyun.com ([115.124.30.130]:53392 "EHLO
        out30-130.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230021AbhFBKLF (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Wed, 2 Jun 2021 06:11:05 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R541e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04420;MF=yang.lee@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0Ub2Yybc_1622628559;
Received: from j63c13417.sqa.eu95.tbsite.net(mailfrom:yang.lee@linux.alibaba.com fp:SMTPD_---0Ub2Yybc_1622628559)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 02 Jun 2021 18:09:21 +0800
From:   Yang Li <yang.lee@linux.alibaba.com>
To:     saeedm@nvidia.com
Cc:     leon@kernel.org, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org, Yang Li <yang.lee@linux.alibaba.com>
Subject: [PATCH] net/mlx5e: Fix an error code in mlx5e_arfs_create_tables()
Date:   Wed,  2 Jun 2021 18:09:13 +0800
Message-Id: <1622628553-89257-1-git-send-email-yang.lee@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

When the code execute 'if (!priv->fs.arfs->wq)', the value of err is 0.
So, we use -ENOMEM to indicate that the function 
create_singlethread_workqueue() return NULL.

Clean up smatch warning:
drivers/net/ethernet/mellanox/mlx5/core/en_arfs.c:373
mlx5e_arfs_create_tables() warn: missing error code 'err'.

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Fixes: 'commit f6755b80d693 ("net/mlx5e: Dynamic alloc arfs table for netdev when needed")'
Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_arfs.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_arfs.c b/drivers/net/ethernet/mellanox/mlx5/core/en_arfs.c
index 5cd466e..2949437 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_arfs.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_arfs.c
@@ -369,8 +369,10 @@ int mlx5e_arfs_create_tables(struct mlx5e_priv *priv)
 	spin_lock_init(&priv->fs.arfs->arfs_lock);
 	INIT_LIST_HEAD(&priv->fs.arfs->rules);
 	priv->fs.arfs->wq = create_singlethread_workqueue("mlx5e_arfs");
-	if (!priv->fs.arfs->wq)
+	if (!priv->fs.arfs->wq) {
+		err = -ENOMEM;
 		goto err;
+	}
 
 	for (i = 0; i < ARFS_NUM_TYPES; i++) {
 		err = arfs_create_table(priv, i);
-- 
1.8.3.1

