Return-Path: <SRS0=kW50=7P=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE4CCC433E0
	for <linux-rdma@archiver.kernel.org>; Tue,  2 Jun 2020 12:28:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8BABC2074B
	for <linux-rdma@archiver.kernel.org>; Tue,  2 Jun 2020 12:28:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1591100927;
	bh=pDiJl1gyzrwjGMMxPnFdM5uVIOrIBIqrfMiB10gUho4=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=fJAN2bXvfQQV1D/LLiG47vzX8G7ekgP8ldBEca6+6p7iCk9IRCPxy6mUa1gc0oHgf
	 JIi/b7M6BPp2g9sbcAwv7w3YbzrhUJexFIl4QuldsLJMiBy9sE0AOxejyyp5/UmCmw
	 VbU9UtIg3XTZrlQ/Abec7z8kGDUBiz5D4Pf7FcqA=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726693AbgFBM2q (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Tue, 2 Jun 2020 08:28:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:33174 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725958AbgFBM2q (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Tue, 2 Jun 2020 08:28:46 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5A97D2053B;
        Tue,  2 Jun 2020 12:28:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591100926;
        bh=pDiJl1gyzrwjGMMxPnFdM5uVIOrIBIqrfMiB10gUho4=;
        h=From:To:Cc:Subject:Date:From;
        b=om9nHtQZrI300NFLDRkQyQDjO46NZgNQrvFishErD1mC8LRvrzmv++UuXE1P0z5bK
         DjWq2WhlHsxFz1sQhao518yEQVwC1ZuS9N/EPciD7PtFqjGkuhQ+eNVr8Hu119lTQZ
         cbv1KLPpwV8FaOAQjHHkGir6Uc7BX++iyrneebvQ=
From:   Leon Romanovsky <leon@kernel.org>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Leon Romanovsky <leonro@mellanox.com>,
        clang-built-linux@googlegroups.com, linux-rdma@vger.kernel.org,
        Nathan Chancellor <natechancellor@gmail.com>,
        netdev@vger.kernel.org, Saeed Mahameed <saeedm@mellanox.com>,
        Vu Pham <vuhuong@mellanox.com>
Subject: [PATCH net] net/mlx5: Don't fail driver on failure to create debugfs
Date:   Tue,  2 Jun 2020 15:28:37 +0300
Message-Id: <20200602122837.161519-1-leon@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro@mellanox.com>

Clang warns:

drivers/net/ethernet/mellanox/mlx5/core/main.c:1278:6: warning: variable
'err' is used uninitialized whenever 'if' condition is true
[-Wsometimes-uninitialized]
        if (!priv->dbg_root) {
            ^~~~~~~~~~~~~~~
drivers/net/ethernet/mellanox/mlx5/core/main.c:1303:9: note:
uninitialized use occurs here
        return err;
               ^~~
drivers/net/ethernet/mellanox/mlx5/core/main.c:1278:2: note: remove the
'if' if its condition is always false
        if (!priv->dbg_root) {
        ^~~~~~~~~~~~~~~~~~~~~~
drivers/net/ethernet/mellanox/mlx5/core/main.c:1259:9: note: initialize
the variable 'err' to silence this warning
        int err;
               ^
                = 0
1 warning generated.

The check of returned value of debugfs_create_dir() is wrong because
by the design debugfs failures should never fail the driver and the
check itself was wrong too. The kernel compiled without CONFIG_DEBUG_FS
will return ERR_PTR(-ENODEV) and not NULL as expected.

Fixes: 11f3b84d7068 ("net/mlx5: Split mdev init and pci init")
Link: https://github.com/ClangBuiltLinux/linux/issues/1042
Reported-by: Nathan Chancellor <natechancellor@gmail.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
Original discussion:
https://lore.kernel.org/lkml/20200530055447.1028004-1-natechancellor@gmail.com
---
 drivers/net/ethernet/mellanox/mlx5/core/main.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
index df46b1fce3a7..110e8d277d15 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -1275,11 +1275,6 @@ static int mlx5_mdev_init(struct mlx5_core_dev *dev, int profile_idx)

 	priv->dbg_root = debugfs_create_dir(dev_name(dev->device),
 					    mlx5_debugfs_root);
-	if (!priv->dbg_root) {
-		dev_err(dev->device, "mlx5_core: error, Cannot create debugfs dir, aborting\n");
-		goto err_dbg_root;
-	}
-
 	err = mlx5_health_init(dev);
 	if (err)
 		goto err_health_init;
--
2.26.2

