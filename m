Return-Path: <SRS0=q+lP=53=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32A73C2BB86
	for <linux-rdma@archiver.kernel.org>; Sat, 11 Apr 2020 23:39:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0DCE820CC7
	for <linux-rdma@archiver.kernel.org>; Sat, 11 Apr 2020 23:39:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1586648355;
	bh=8dfx3TFr55L01u2UiTLlYyea/1cGYV7ld0fs3BRL5wo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=ofzJIwUKR+J8TIfFqCN3k+YBiHLgrK26mu8ALuqnXI+ik2i/iqrzVSb6XwrGrJ2ea
	 Da2wrkqYY/I+LNVNK949PC7m7XFdpKUXWmMnrgGz0cMedoWv3GeNzcM2+YMQg/yq+3
	 DNS9vwx964Dh4xlaCZ7S2cTLIKiKN4BYt4qVQARM=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729011AbgDKXjJ (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Sat, 11 Apr 2020 19:39:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:43998 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728719AbgDKXHq (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Sat, 11 Apr 2020 19:07:46 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 38F9A20787;
        Sat, 11 Apr 2020 23:07:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586646467;
        bh=8dfx3TFr55L01u2UiTLlYyea/1cGYV7ld0fs3BRL5wo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WgBZz80FZfbKOVz8CDH17ntEw0cWy/rfX7G5lzsn6bZEI1RZtBNddgQpMfnTK7a4J
         EJF+1rXWj+Ggj7bxZZ7IA/R5ELUNlh3fI4RtjUTmvc/RpDH2b0NhTo6lDTydzR2pfU
         un1i9GDtqyAEiNUPWEFV/gu+sggRNkAsr7yCK4hE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Parav Pandit <parav@mellanox.com>, Mark Bloch <markb@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>, linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 5.5 034/121] IB/mlx5: Fix missing congestion control debugfs on rep rdma device
Date:   Sat, 11 Apr 2020 19:05:39 -0400
Message-Id: <20200411230706.23855-34-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200411230706.23855-1-sashal@kernel.org>
References: <20200411230706.23855-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

From: Parav Pandit <parav@mellanox.com>

[ Upstream commit 79db784e794b6e7b7fb9b1dd464a34e4c0c039af ]

Cited commit missed to include low level congestion control related
debugfs stage initialization.  This resulted in missing debugfs entries
for cc_params of a RDMA device.

Add them back.

Fixes: b5ca15ad7e61 ("IB/mlx5: Add proper representors support")
Link: https://lore.kernel.org/r/20200227125407.99803-1-leon@kernel.org
Signed-off-by: Parav Pandit <parav@mellanox.com>
Reviewed-by: Mark Bloch <markb@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/mlx5/main.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index f3c73dc40078c..2a8c82cfb5148 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -6845,6 +6845,9 @@ const struct mlx5_ib_profile raw_eth_profile = {
 	STAGE_CREATE(MLX5_IB_STAGE_COUNTERS,
 		     mlx5_ib_stage_counters_init,
 		     mlx5_ib_stage_counters_cleanup),
+	STAGE_CREATE(MLX5_IB_STAGE_CONG_DEBUGFS,
+		     mlx5_ib_stage_cong_debugfs_init,
+		     mlx5_ib_stage_cong_debugfs_cleanup),
 	STAGE_CREATE(MLX5_IB_STAGE_UAR,
 		     mlx5_ib_stage_uar_init,
 		     mlx5_ib_stage_uar_cleanup),
-- 
2.20.1

