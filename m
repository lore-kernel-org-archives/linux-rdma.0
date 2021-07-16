Return-Path: <linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32A22C636CA
	for <linux-rdma@archiver.kernel.org>; Fri, 16 Jul 2021 10:52:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 17E9D613C3
	for <linux-rdma@archiver.kernel.org>; Fri, 16 Jul 2021 10:52:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232248AbhGPKzX (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Fri, 16 Jul 2021 06:55:23 -0400
Received: from out30-43.freemail.mail.aliyun.com ([115.124.30.43]:45854 "EHLO
        out30-43.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232214AbhGPKzW (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>);
        Fri, 16 Jul 2021 06:55:22 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R771e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04394;MF=jiapeng.chong@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0UfyVi1S_1626432729;
Received: from j63c13417.sqa.eu95.tbsite.net(mailfrom:jiapeng.chong@linux.alibaba.com fp:SMTPD_---0UfyVi1S_1626432729)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 16 Jul 2021 18:52:26 +0800
From:   Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
To:     saeedm@nvidia.com
Cc:     leon@kernel.org, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Subject: [PATCH] net/mlx5: Fix missing error code in  mlx5_devlink_eswitch_inline_mode_set()
Date:   Fri, 16 Jul 2021 18:52:08 +0800
Message-Id: <1626432728-118051-1-git-send-email-jiapeng.chong@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

The error code is missing in this code scenario, add the error code
'-EINVAL' to the return value 'err'.

Eliminate the follow smatch warning:

vers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c:3083
mlx5_devlink_eswitch_inline_mode_set() warn: missing error code 'err'.

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index 7579f34..b38b6c1 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -3079,8 +3079,10 @@ int mlx5_devlink_eswitch_inline_mode_set(struct devlink *devlink, u8 mode,
 
 	switch (MLX5_CAP_ETH(dev, wqe_inline_mode)) {
 	case MLX5_CAP_INLINE_MODE_NOT_REQUIRED:
-		if (mode == DEVLINK_ESWITCH_INLINE_MODE_NONE)
+		if (mode == DEVLINK_ESWITCH_INLINE_MODE_NONE) {
+			err = -EINVAL;
 			goto out;
+		}
 		fallthrough;
 	case MLX5_CAP_INLINE_MODE_L2:
 		NL_SET_ERR_MSG_MOD(extack, "Inline mode can't be set");
-- 
1.8.3.1

