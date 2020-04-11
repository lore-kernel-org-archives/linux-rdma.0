Return-Path: <SRS0=q+lP=53=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43B31C2BB86
	for <linux-rdma@archiver.kernel.org>; Sat, 11 Apr 2020 23:24:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 12C5420787
	for <linux-rdma@archiver.kernel.org>; Sat, 11 Apr 2020 23:24:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1586647480;
	bh=Pzk753ttBnPULrgcv1Ia+ix0c6xqkGzhYsndfaY9kwc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=tM5K1RlXlDyNf/LNByOv8a8xLKHSGHY+FUaTjUrjvw+a5TNV5VmGlRxNeHYP7/F0X
	 Y8k6JGSY0Q0Tem5MdZpB5tVOIzm2hH0JEXRmTvZRHbkIkHTCup9c45RPtcp4FelXTZ
	 em2TRDjo17SQDIpv3sxPwHl+V7mkT49MBRWxVxaA=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730176AbgDKXM3 (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Sat, 11 Apr 2020 19:12:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:52630 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729568AbgDKXM3 (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Sat, 11 Apr 2020 19:12:29 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 51E4A20787;
        Sat, 11 Apr 2020 23:12:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586646749;
        bh=Pzk753ttBnPULrgcv1Ia+ix0c6xqkGzhYsndfaY9kwc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xnqL/GnG4iFl4Qze/mOkNUkDj2IKaPxkomyt720RmIDebw6aaEDAJESID0eK3iToT
         wjm7UIJRhbSOamS7RSQDbfrztEBIxgMDEuV0woIR5wc/GUw0mbnP4/nmz6AGDPwM/u
         1xMLhsQLrEWIMNUmxwN0IMQN+L53wm27XaHPgxto=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Parav Pandit <parav@mellanox.com>, Mark Bloch <markb@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>, linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 21/66] IB/mlx5: Fix missing congestion control debugfs on rep rdma device
Date:   Sat, 11 Apr 2020 19:11:18 -0400
Message-Id: <20200411231203.25933-21-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200411231203.25933-1-sashal@kernel.org>
References: <20200411231203.25933-1-sashal@kernel.org>
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
index 2db34f7b5ced1..c9983838e3493 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -6288,6 +6288,9 @@ static const struct mlx5_ib_profile nic_rep_profile = {
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

