Return-Path: <SRS0=Ta2D=3F=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5FB9CC33CAF
	for <linux-rdma@archiver.kernel.org>; Thu, 16 Jan 2020 18:26:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3DC2520684
	for <linux-rdma@archiver.kernel.org>; Thu, 16 Jan 2020 18:26:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1579199182;
	bh=7tfVyXX4bFsIsuLvzod+ayf9c7B7NeaPg52+j0naU1Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=w27Ktc9JUyoQBpfngMSH/IPg5O1Cb/Yh6hqvfGuWUVMA/si1AckGCLw2fwoRnbJPp
	 PzQ6LSlw/KVEkjsz9xcBEfhMrLP7fKkBXTsaaZuhHwD9aFv8cvWgUF7epuepgu8b9C
	 bT9WtgnsLJBqmpfFrst0oBhNyYwwWNqL/Bai1/EQ=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730583AbgAPS0L (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Thu, 16 Jan 2020 13:26:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:35852 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2403988AbgAPR0q (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Thu, 16 Jan 2020 12:26:46 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C2C9C246BE;
        Thu, 16 Jan 2020 17:26:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579195605;
        bh=7tfVyXX4bFsIsuLvzod+ayf9c7B7NeaPg52+j0naU1Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EAf+K7eV5Lv+pRZ7gOPvQZHPOICyTFwVHGjv4INJP821uU9OTsZNuGR8rNczdR9oi
         t7uxn36gBSoAlIeNw6B6Pl3+6TXvG6kXNFwAseC6CHUgeq85Omp36GojVOUpquq+Wa
         vXyBkwc+7vSVE9Md4F5sYDlrX3JoCvADFlvpiei0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jack Morgenstein <jackm@dev.mellanox.co.il>,
        Leon Romanovsky <leonro@mellanox.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>, linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 180/371] IB/mlx5: Add missing XRC options to QP optional params mask
Date:   Thu, 16 Jan 2020 12:20:52 -0500
Message-Id: <20200116172403.18149-123-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116172403.18149-1-sashal@kernel.org>
References: <20200116172403.18149-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

From: Jack Morgenstein <jackm@dev.mellanox.co.il>

[ Upstream commit 8f4426aa19fcdb9326ac44154a117b1a3a5ae126 ]

The QP transition optional parameters for the various transition for XRC
QPs are identical to those for RC QPs.

Many of the XRC QP transition optional parameter bits are missing from the
QP optional mask table.  These omissions caused failures when doing XRC QP
state transitions.

For example, when trying to change the response timer of an XRC receive QP
via the RTS2RTS transition, the new timer value was ignored because
MLX5_QP_OPTPAR_RNR_TIMEOUT bit was missing from the optional params mask
for XRC qps for the RTS2RTS transition.

Fix this by adding the missing XRC optional parameters for all QP
transitions to the opt_mask table.

Fixes: e126ba97dba9 ("mlx5: Add driver for Mellanox Connect-IB adapters")
Fixes: a4774e9095de ("IB/mlx5: Fix opt param mask according to firmware spec")
Signed-off-by: Jack Morgenstein <jackm@dev.mellanox.co.il>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/mlx5/qp.c | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/drivers/infiniband/hw/mlx5/qp.c b/drivers/infiniband/hw/mlx5/qp.c
index 5a7dcb5afe6e..84c962820aa2 100644
--- a/drivers/infiniband/hw/mlx5/qp.c
+++ b/drivers/infiniband/hw/mlx5/qp.c
@@ -2357,6 +2357,11 @@ static enum mlx5_qp_optpar opt_mask[MLX5_QP_NUM_STATE][MLX5_QP_NUM_STATE][MLX5_Q
 			[MLX5_QP_ST_UD] = MLX5_QP_OPTPAR_PKEY_INDEX	|
 					  MLX5_QP_OPTPAR_Q_KEY		|
 					  MLX5_QP_OPTPAR_PRI_PORT,
+			[MLX5_QP_ST_XRC] = MLX5_QP_OPTPAR_RRE		|
+					  MLX5_QP_OPTPAR_RAE		|
+					  MLX5_QP_OPTPAR_RWE		|
+					  MLX5_QP_OPTPAR_PKEY_INDEX	|
+					  MLX5_QP_OPTPAR_PRI_PORT,
 		},
 		[MLX5_QP_STATE_RTR] = {
 			[MLX5_QP_ST_RC] = MLX5_QP_OPTPAR_ALT_ADDR_PATH  |
@@ -2390,6 +2395,12 @@ static enum mlx5_qp_optpar opt_mask[MLX5_QP_NUM_STATE][MLX5_QP_NUM_STATE][MLX5_Q
 					  MLX5_QP_OPTPAR_RWE		|
 					  MLX5_QP_OPTPAR_PM_STATE,
 			[MLX5_QP_ST_UD] = MLX5_QP_OPTPAR_Q_KEY,
+			[MLX5_QP_ST_XRC] = MLX5_QP_OPTPAR_ALT_ADDR_PATH	|
+					  MLX5_QP_OPTPAR_RRE		|
+					  MLX5_QP_OPTPAR_RAE		|
+					  MLX5_QP_OPTPAR_RWE		|
+					  MLX5_QP_OPTPAR_PM_STATE	|
+					  MLX5_QP_OPTPAR_RNR_TIMEOUT,
 		},
 	},
 	[MLX5_QP_STATE_RTS] = {
@@ -2406,6 +2417,12 @@ static enum mlx5_qp_optpar opt_mask[MLX5_QP_NUM_STATE][MLX5_QP_NUM_STATE][MLX5_Q
 			[MLX5_QP_ST_UD] = MLX5_QP_OPTPAR_Q_KEY		|
 					  MLX5_QP_OPTPAR_SRQN		|
 					  MLX5_QP_OPTPAR_CQN_RCV,
+			[MLX5_QP_ST_XRC] = MLX5_QP_OPTPAR_RRE		|
+					  MLX5_QP_OPTPAR_RAE		|
+					  MLX5_QP_OPTPAR_RWE		|
+					  MLX5_QP_OPTPAR_RNR_TIMEOUT	|
+					  MLX5_QP_OPTPAR_PM_STATE	|
+					  MLX5_QP_OPTPAR_ALT_ADDR_PATH,
 		},
 	},
 	[MLX5_QP_STATE_SQER] = {
@@ -2417,6 +2434,10 @@ static enum mlx5_qp_optpar opt_mask[MLX5_QP_NUM_STATE][MLX5_QP_NUM_STATE][MLX5_Q
 					   MLX5_QP_OPTPAR_RWE		|
 					   MLX5_QP_OPTPAR_RAE		|
 					   MLX5_QP_OPTPAR_RRE,
+			[MLX5_QP_ST_XRC]  = MLX5_QP_OPTPAR_RNR_TIMEOUT	|
+					   MLX5_QP_OPTPAR_RWE		|
+					   MLX5_QP_OPTPAR_RAE		|
+					   MLX5_QP_OPTPAR_RRE,
 		},
 	},
 };
-- 
2.20.1

