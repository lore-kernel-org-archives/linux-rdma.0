Return-Path: <linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30D74C433DB
	for <linux-rdma@archiver.kernel.org>; Thu, 11 Mar 2021 07:10:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E3CBB6501A
	for <linux-rdma@archiver.kernel.org>; Thu, 11 Mar 2021 07:10:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231829AbhCKHJ6 (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Thu, 11 Mar 2021 02:09:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:52330 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231963AbhCKHJk (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Thu, 11 Mar 2021 02:09:40 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B15A76501F;
        Thu, 11 Mar 2021 07:09:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615446580;
        bh=YRMEFSdWj/GWucEy0gNovB73REQQQx2/nigGTwxmyig=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FA0iIWhX1MNaTxpHp1GmQSetz29MHvX5kkjHkXJXG/PihyHpN1npm0pCYfLCallZc
         Kh24ilKjNR6PvjXOFnDyZQjsMVKrhRm3h+6SLJ/C18AIF5bHi7Zay5HLS9qHUsjymi
         VlbkIDRtl9QYoK9wsj3ICyQTuNAFUJW/zJpxpFPh6ejv/n7vYR5ugYFJqSeFPhhERI
         BhUVxq2w3AA+TmHqpgkZWE0Noy10Mf1X7tR5Q9OBUffc6qqkya3FN7tYHfp3DIoWNj
         YHNu9CbKrC6qnUH6hO/6a9YIDJSPaeeisLXVSbQLS/UlTcpKXiu+R+2Bg+7bQ3PM4v
         lh8Ob69m9mThQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org
Cc:     Zheng Yongjun <zhengyongjun3@huawei.com>
Subject: [PATCH mlx5-next 2/9] net/mlx5: simplify the return expression of mlx5_esw_offloads_pair()
Date:   Wed, 10 Mar 2021 23:09:08 -0800
Message-Id: <20210311070915.321814-3-saeed@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210311070915.321814-1-saeed@kernel.org>
References: <20210311070915.321814-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

From: Zheng Yongjun <zhengyongjun3@huawei.com>

Simplify the return expression.

Signed-off-by: Zheng Yongjun <zhengyongjun3@huawei.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index 94cb0217b4f3..107b1f208b72 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -2288,13 +2288,8 @@ void esw_offloads_unload_rep(struct mlx5_eswitch *esw, u16 vport_num)
 static int mlx5_esw_offloads_pair(struct mlx5_eswitch *esw,
 				  struct mlx5_eswitch *peer_esw)
 {
-	int err;
 
-	err = esw_add_fdb_peer_miss_rules(esw, peer_esw->dev);
-	if (err)
-		return err;
-
-	return 0;
+	return esw_add_fdb_peer_miss_rules(esw, peer_esw->dev);
 }
 
 static void mlx5_esw_offloads_unpair(struct mlx5_eswitch *esw)
-- 
2.29.2

