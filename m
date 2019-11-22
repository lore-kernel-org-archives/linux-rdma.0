Return-Path: <SRS0=yC1B=ZO=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9541AC43215
	for <linux-rdma@archiver.kernel.org>; Fri, 22 Nov 2019 06:07:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 54CB52068F
	for <linux-rdma@archiver.kernel.org>; Fri, 22 Nov 2019 06:07:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1574402861;
	bh=8rpbA/I/vOJX++ZcZmL05DkRyFxZUOMgDCs+tabDovA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=NFvoUioh7RDxcAxLUgK3tg1v5+GFx4wVNQsmHr0ggCo+LamGo4VZjaQsmJUvg9Rpl
	 B7EQ8VklDQcstf6ihno6/JYN1noBcild8xI6Y4GOLSCuyXa9LJ5CV2qT2QGFyiVPdM
	 XGlZJjX3jEHZmt67HSbJOeeeqer3VrmzF/r4w2Kw=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727874AbfKVGHc (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Fri, 22 Nov 2019 01:07:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:40400 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728666AbfKVGB7 (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Fri, 22 Nov 2019 01:01:59 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C4B0E2068F;
        Fri, 22 Nov 2019 06:01:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574402518;
        bh=8rpbA/I/vOJX++ZcZmL05DkRyFxZUOMgDCs+tabDovA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1vZoCTmKOxyHFxicJqjW54jbnaNLG3e7LCdveY4BdhrisKYyq5Evq4RHPjQC4dA+y
         /04a1z/wMMwZMYwdH+GThvJaYM5cne6rDe2o/NspQ6vaywGkbFP6rb1TwH270VRpI+
         Bnl7YjZUCkhbhJy+cIpjFaYtPG+xZbIVeFfOqqqA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Leon Romanovsky <leonro@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 27/91] net/mlx5: Continue driver initialization despite debugfs failure
Date:   Fri, 22 Nov 2019 01:00:25 -0500
Message-Id: <20191122060129.4239-26-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191122060129.4239-1-sashal@kernel.org>
References: <20191122060129.4239-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro@mellanox.com>

[ Upstream commit 199fa087dc6b503baad06712716fac645a983e8a ]

The failure to create debugfs entry is unpleasant event, but not enough
to abort drier initialization. Align the mlx5_core code to debugfs design
and continue execution whenever debugfs_create_dir() successes or not.

Fixes: e126ba97dba9 ("mlx5: Add driver for Mellanox Connect-IB adapters")
Reviewed-by: Saeed Mahameed <saeedm@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/main.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
index d676088512cf8..c9fb589690ee9 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -786,11 +786,9 @@ static int mlx5_pci_init(struct mlx5_core_dev *dev, struct mlx5_priv *priv)
 
 	priv->numa_node = dev_to_node(&dev->pdev->dev);
 
-	priv->dbg_root = debugfs_create_dir(dev_name(&pdev->dev), mlx5_debugfs_root);
-	if (!priv->dbg_root) {
-		dev_err(&pdev->dev, "Cannot create debugfs dir, aborting\n");
-		return -ENOMEM;
-	}
+	if (mlx5_debugfs_root)
+		priv->dbg_root =
+			debugfs_create_dir(pci_name(pdev), mlx5_debugfs_root);
 
 	err = mlx5_pci_enable_device(dev);
 	if (err) {
-- 
2.20.1

