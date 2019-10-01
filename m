Return-Path: <SRS0=4noh=X2=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA259ECE587
	for <linux-rdma@archiver.kernel.org>; Tue,  1 Oct 2019 16:56:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9498C21924
	for <linux-rdma@archiver.kernel.org>; Tue,  1 Oct 2019 16:56:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1569948986;
	bh=a2MGscU/Bb+I5eSQfmvlq8/dgcZNCypX6u8kDBlQeqo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=ff872b6psa8It490RoD8UNOPNJxWNETGRMW78Ch2DASHhP6Y3aq1kGcfTQKh87j8u
	 1W6Jz6l47UXEbKRGoEKoqRogqzP7O821BgoyGH7txBu/jQinqss/9ijnfcu9GS/x+Q
	 h2eKMKycftyVb6zNTkjrgaqy6j01Vvmak796l1lM=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730862AbfJAQ4N (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Tue, 1 Oct 2019 12:56:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:54090 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731768AbfJAQmO (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Tue, 1 Oct 2019 12:42:14 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6F32D205C9;
        Tue,  1 Oct 2019 16:42:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569948134;
        bh=a2MGscU/Bb+I5eSQfmvlq8/dgcZNCypX6u8kDBlQeqo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NvlgAk5NDIhTvK2bFhVrRMhT0AoZXhZSM6Ib5QyU3bwWY2u/k29b/eL+CmHf6LM5Q
         naTYwW/Xo+OX/kRLFFq9tV3p3UdtHrUBec0FjdTRf7wCYQACRucXwqPVkkoCOkoOfZ
         bT3ZZMCBVD3L70FT7/4Cp6U1HIxBeX/NxiYYr+3M=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Saeed Mahameed <saeedm@mellanox.com>,
        Maor Gottlieb <maorg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 5.2 34/63] net/mlx5e: Fix traffic duplication in ethtool steering
Date:   Tue,  1 Oct 2019 12:40:56 -0400
Message-Id: <20191001164125.15398-34-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191001164125.15398-1-sashal@kernel.org>
References: <20191001164125.15398-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

From: Saeed Mahameed <saeedm@mellanox.com>

[ Upstream commit d22fcc806b84b9818de08b32e494f3c05dd236c7 ]

Before this patch, when adding multiple ethtool steering rules with
identical classification, the driver used to append the new destination
to the already existing hw rule, which caused the hw to forward the
traffic to all destinations (rx queues).

Here we avoid this by setting the "no append" mlx5 fs core flag when
adding a new ethtool rule.

Fixes: 6dc6071cfcde ("net/mlx5e: Add ethtool flow steering support")
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
Reviewed-by: Maor Gottlieb <maorg@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_fs_ethtool.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_fs_ethtool.c b/drivers/net/ethernet/mellanox/mlx5/core/en_fs_ethtool.c
index 4421c10f58ae5..baed9e93794ff 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_fs_ethtool.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_fs_ethtool.c
@@ -397,10 +397,10 @@ add_ethtool_flow_rule(struct mlx5e_priv *priv,
 		      struct mlx5_flow_table *ft,
 		      struct ethtool_rx_flow_spec *fs)
 {
+	struct mlx5_flow_act flow_act = { .flags = FLOW_ACT_NO_APPEND };
 	struct mlx5_flow_destination *dst = NULL;
-	struct mlx5_flow_act flow_act = {0};
-	struct mlx5_flow_spec *spec;
 	struct mlx5_flow_handle *rule;
+	struct mlx5_flow_spec *spec;
 	int err = 0;
 
 	spec = kvzalloc(sizeof(*spec), GFP_KERNEL);
-- 
2.20.1

