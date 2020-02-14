Return-Path: <SRS0=HMeR=4C=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2EA48C2BA83
	for <linux-rdma@archiver.kernel.org>; Fri, 14 Feb 2020 17:53:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F1D40206D7
	for <linux-rdma@archiver.kernel.org>; Fri, 14 Feb 2020 17:53:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1581702796;
	bh=A3r53Ti4W7H0MZfUrZJ9EtnHYp8kTdo1d+21a3Ib3lc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=PHt1afL395xWcKcUJYDZPLrE10aMEVSqPK4PIfoieUoF6bRA9g+5m20EMey/AFuam
	 hBEIl3hFZVnsLeJPwrPGlKJfph6z6A+Wy45cKeQFCoeOPQsEgfi4BhTULoO3LvmNhP
	 wQv+GMQ7eLF1f7ApqTmRCs/5o+kYVVptzdTQYOFE=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389849AbgBNRxP (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Fri, 14 Feb 2020 12:53:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:42156 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388564AbgBNP6W (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Fri, 14 Feb 2020 10:58:22 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7C50F24654;
        Fri, 14 Feb 2020 15:58:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581695902;
        bh=A3r53Ti4W7H0MZfUrZJ9EtnHYp8kTdo1d+21a3Ib3lc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HNFIVg4Q5AogweM0gaVK/J+nhd8P3hdMIcF44FZXXyVzJryFMz+7uxd1ibC9SUIF0
         BaezzsPvxqAmK4YbrRnWbc+Lgq+CmiRNk/6/O5RJVYC+JokCYTIxcq0vX/JfU2C6L9
         z6gl6Bz4mmzhMGw4ahnSLegIyZN+gM+O5ZdoXDOo=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Olof Johansson <olof@lixom.net>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 5.5 443/542] net/mlx5e: Fix printk format warning
Date:   Fri, 14 Feb 2020 10:47:15 -0500
Message-Id: <20200214154854.6746-443-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214154854.6746-1-sashal@kernel.org>
References: <20200214154854.6746-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

From: Olof Johansson <olof@lixom.net>

[ Upstream commit ca9c74ae9be5e78541c2058db9a754947a7d4a9b ]

Use "%zu" for size_t. Seen on ARM allmodconfig:

drivers/net/ethernet/mellanox/mlx5/core/wq.c: In function 'mlx5_wq_cyc_wqe_dump':
include/linux/kern_levels.h:5:18: warning: format '%ld' expects argument of type 'long int', but argument 5 has type 'size_t' {aka 'unsigned int'} [-Wformat=]

Fixes: 130c7b46c93d ("net/mlx5e: TX, Dump WQs wqe descriptors on CQE with error events")
Signed-off-by: Olof Johansson <olof@lixom.net>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/wq.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/wq.c b/drivers/net/ethernet/mellanox/mlx5/core/wq.c
index f2a0e72285bac..02f7e4a39578a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/wq.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/wq.c
@@ -89,7 +89,7 @@ void mlx5_wq_cyc_wqe_dump(struct mlx5_wq_cyc *wq, u16 ix, u8 nstrides)
 	len = nstrides << wq->fbc.log_stride;
 	wqe = mlx5_wq_cyc_get_wqe(wq, ix);
 
-	pr_info("WQE DUMP: WQ size %d WQ cur size %d, WQE index 0x%x, len: %ld\n",
+	pr_info("WQE DUMP: WQ size %d WQ cur size %d, WQE index 0x%x, len: %zu\n",
 		mlx5_wq_cyc_get_size(wq), wq->cur_sz, ix, len);
 	print_hex_dump(KERN_WARNING, "", DUMP_PREFIX_OFFSET, 16, 1, wqe, len, false);
 }
-- 
2.20.1

