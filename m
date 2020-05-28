Return-Path: <SRS0=4t+U=7K=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6808EC433DF
	for <linux-rdma@archiver.kernel.org>; Thu, 28 May 2020 12:03:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3D897215A4
	for <linux-rdma@archiver.kernel.org>; Thu, 28 May 2020 12:03:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1590667436;
	bh=uHF9LVztK7xAXHrQMw09M/B8iqVnOc+f7djTgun59M0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=GMnQdFR6UYzDyF/72jygNCwLuVqQ95zjgbkBngVrP0H+mSaA0idk7HNroyO4/uWB9
	 p3cWi7esYwwwaIrmWyRXEWXiPeL5vpY/N0Lzsg1aXNFD6aCsvotLA5RvvWAaS0Miib
	 0sKV9n8FpMsdGgC8o/R7a9gz8+S+1PSLGRx2s62c=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389001AbgE1MDs (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Thu, 28 May 2020 08:03:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:49806 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388992AbgE1L5V (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Thu, 28 May 2020 07:57:21 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0AFBB21655;
        Thu, 28 May 2020 11:57:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590667040;
        bh=uHF9LVztK7xAXHrQMw09M/B8iqVnOc+f7djTgun59M0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Kpz9sa5LaP27t89bt+OpiXqM/vXKA8m+4A6WmD8ZTvD1vaMk/0tTS29pVT6HN868S
         iqYh/mWKwE6qqkGEdzNGwiYGli5LJbBtMeLaM0SN48YIrjYTQrtPfJax41k8NljeTQ
         X7Q2g2f7xP/BaKbf1ls2+HPlC+Evm4/CjDSh1gjU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Shay Drory <shayd@mellanox.com>,
        Moshe Shemesh <moshe@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 23/26] net/mlx5: Fix error flow in case of function_setup failure
Date:   Thu, 28 May 2020 07:56:51 -0400
Message-Id: <20200528115654.1406165-23-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200528115654.1406165-1-sashal@kernel.org>
References: <20200528115654.1406165-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

From: Shay Drory <shayd@mellanox.com>

[ Upstream commit 4f7400d5cbaef676e00cdffb0565bf731c6bb09e ]

Currently, if an error occurred during mlx5_function_setup(), we
keep dev->state as DEVICE_STATE_UP.
Fixing it by adding a goto label.

Fixes: e161105e58da ("net/mlx5: Function setup/teardown procedures")
Signed-off-by: Shay Drory <shayd@mellanox.com>
Reviewed-by: Moshe Shemesh <moshe@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/main.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
index c96a0e501007..7dcdda9ca351 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -1183,7 +1183,7 @@ static int mlx5_load_one(struct mlx5_core_dev *dev, bool boot)
 
 	err = mlx5_function_setup(dev, boot);
 	if (err)
-		goto out;
+		goto err_function;
 
 	if (boot) {
 		err = mlx5_init_once(dev);
@@ -1229,6 +1229,7 @@ err_load:
 		mlx5_cleanup_once(dev);
 function_teardown:
 	mlx5_function_teardown(dev, boot);
+err_function:
 	dev->state = MLX5_DEVICE_STATE_INTERNAL_ERROR;
 	mutex_unlock(&dev->intf_state_mutex);
 
-- 
2.25.1

