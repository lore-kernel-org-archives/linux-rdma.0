Return-Path: <SRS0=CiuV=2K=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14D4DC47409
	for <linux-rdma@archiver.kernel.org>; Fri, 20 Dec 2019 14:32:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DEF8A21D7E
	for <linux-rdma@archiver.kernel.org>; Fri, 20 Dec 2019 14:32:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1576852328;
	bh=yLVIhH+swugmzM/oMFaJtbU7LLW0/139xHCniGzhzic=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=qX91yB0yXlTykCoQvoxKExs/QViPPvACKOUdjUjZg37SOGB1m4o//9wyGhyQMhsWY
	 qSYj4GZAWIM9RK+0VroGPz71skTYJKi8P5/LhgDtKvitdoqMCqrCJQRjWvQyfYQFqD
	 I7Yozka62M7sTwf1jmClUFeumneNUz1mWVMbhVIU=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727402AbfLTOcF (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Fri, 20 Dec 2019 09:32:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:35084 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727968AbfLTObA (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Fri, 20 Dec 2019 09:31:00 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0821321D7E;
        Fri, 20 Dec 2019 14:30:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576852259;
        bh=yLVIhH+swugmzM/oMFaJtbU7LLW0/139xHCniGzhzic=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ImqkofKcK1LnNNf/Wzj3YG4MIePYQBtC8YjMWslj+TKDaRWWu4olnmlJlhB+a2mh+
         +M/4eZqMiVMjeVVKnsJKwXdxcQjBGuPHc4iKPWkYH++c6l5J8AfYdG9SFedcAZLwDg
         jqSPhyrCdXMhvnz7cx1mCcUKtPayGcspmhQZoUiM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Maor Gottlieb <maorg@mellanox.com>,
        Raed Salem <raeds@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>,
        Doug Ledford <dledford@redhat.com>,
        Sasha Levin <sashal@kernel.org>, linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 49/52] IB/mlx5: Fix steering rule of drop and count
Date:   Fri, 20 Dec 2019 09:29:51 -0500
Message-Id: <20191220142954.9500-49-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191220142954.9500-1-sashal@kernel.org>
References: <20191220142954.9500-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

From: Maor Gottlieb <maorg@mellanox.com>

[ Upstream commit ed9085fed9d95d5921582e3c8474f3736c5d2782 ]

There are two flow rule destinations: QP and packet. While users are
setting DROP packet rule, the QP should not be set as a destination.

Fixes: 3b3233fbf02e ("IB/mlx5: Add flow counters binding support")
Signed-off-by: Maor Gottlieb <maorg@mellanox.com>
Reviewed-by: Raed Salem <raeds@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
Link: https://lore.kernel.org/r/20191212091214.315005-4-leon@kernel.org
Signed-off-by: Doug Ledford <dledford@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/mlx5/main.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index 831539419c301..e1cfbedefcbc9 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -3548,10 +3548,6 @@ static struct mlx5_ib_flow_handler *_create_flow_rule(struct mlx5_ib_dev *dev,
 	}
 
 	INIT_LIST_HEAD(&handler->list);
-	if (dst) {
-		memcpy(&dest_arr[0], dst, sizeof(*dst));
-		dest_num++;
-	}
 
 	for (spec_index = 0; spec_index < flow_attr->num_of_specs; spec_index++) {
 		err = parse_flow_attr(dev->mdev, spec,
@@ -3564,6 +3560,11 @@ static struct mlx5_ib_flow_handler *_create_flow_rule(struct mlx5_ib_dev *dev,
 		ib_flow += ((union ib_flow_spec *)ib_flow)->size;
 	}
 
+	if (dst && !(flow_act.action & MLX5_FLOW_CONTEXT_ACTION_DROP)) {
+		memcpy(&dest_arr[0], dst, sizeof(*dst));
+		dest_num++;
+	}
+
 	if (!flow_is_multicast_only(flow_attr))
 		set_underlay_qp(dev, spec, underlay_qpn);
 
@@ -3604,10 +3605,8 @@ static struct mlx5_ib_flow_handler *_create_flow_rule(struct mlx5_ib_dev *dev,
 	}
 
 	if (flow_act.action & MLX5_FLOW_CONTEXT_ACTION_DROP) {
-		if (!(flow_act.action & MLX5_FLOW_CONTEXT_ACTION_COUNT)) {
+		if (!dest_num)
 			rule_dst = NULL;
-			dest_num = 0;
-		}
 	} else {
 		if (is_egress)
 			flow_act.action |= MLX5_FLOW_CONTEXT_ACTION_ALLOW;
-- 
2.20.1

