Return-Path: <SRS0=wk0f=W7=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99D4BC3A5A9
	for <linux-rdma@archiver.kernel.org>; Wed,  4 Sep 2019 19:38:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7D07F22CED
	for <linux-rdma@archiver.kernel.org>; Wed,  4 Sep 2019 19:38:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730993AbfIDTip (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Wed, 4 Sep 2019 15:38:45 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:37453 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730197AbfIDTip (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Wed, 4 Sep 2019 15:38:45 -0400
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.0:RSA_AES_256_CBC_SHA1:32)
        (Exim 4.76)
        (envelope-from <colin.king@canonical.com>)
        id 1i5b73-0003Lx-OF; Wed, 04 Sep 2019 19:38:41 +0000
From:   Colin King <colin.king@canonical.com>
To:     Saeed Mahameed <saeedm@mellanox.com>,
        Leon Romanovsky <leon@kernel.org>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH][next] net/mlx5: fix spelling mistake "offlaods" -> "offloads"
Date:   Wed,  4 Sep 2019 20:38:41 +0100
Message-Id: <20190904193841.20138-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

There is a spelling mistake in a NL_SET_ERR_MSG_MOD error message.
Fix it.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/devlink.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
index 7bf7b6fbc776..381925c90d94 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
@@ -133,7 +133,7 @@ static int mlx5_devlink_fs_mode_validate(struct devlink *devlink, u32 id,
 
 		else if (eswitch_mode == MLX5_ESWITCH_OFFLOADS) {
 			NL_SET_ERR_MSG_MOD(extack,
-					   "Software managed steering is not supported when eswitch offlaods enabled.");
+					   "Software managed steering is not supported when eswitch offloads enabled.");
 			err = -EOPNOTSUPP;
 		}
 	} else {
-- 
2.20.1

