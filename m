Return-Path: <SRS0=4t+U=7K=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C14B8C433E0
	for <linux-rdma@archiver.kernel.org>; Thu, 28 May 2020 12:06:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 899BA215A4
	for <linux-rdma@archiver.kernel.org>; Thu, 28 May 2020 12:06:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1590667609;
	bh=rLPYZy8BfA6VlzlWQXP+dW2j7mV2wYkXIstlwBNSK4M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=v6iW85uSOSjuEgtNS9A7MINDXFfZ2TRoy1kzeT75OsrKD41EZKrunb5Fq+TswD8vS
	 L79aYtyoDapRXr9lXLhy2JwkuUf43hoFk5puAFJ/J7vmdlKK15DCEdb0CLx3faXbfh
	 IoxYoaCfjc72l3HqBSYYh2NH3UwzTVbzEONEEsNM=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388819AbgE1L4r (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Thu, 28 May 2020 07:56:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:48880 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388809AbgE1L4q (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Thu, 28 May 2020 07:56:46 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3E08C207D3;
        Thu, 28 May 2020 11:56:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590667006;
        bh=rLPYZy8BfA6VlzlWQXP+dW2j7mV2wYkXIstlwBNSK4M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=S5mVgIKQjjpxnx6RS36+Imb4OZWp9A2AGmlPz1AY13u1FuS/AvXQl21EqPSVqTfl5
         a0hqn89sBZt3uDPUoV+b+eChLX+sf5k1FEZ/KD183f/MPELwgFbD7JMZUTvNNtguOs
         nbGyCGFW3rCfwfIS3MThmsuTRrg13GAMeDFaufa8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Moshe Shemesh <moshe@mellanox.com>,
        Tariq Toukan <tariqt@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 5.6 40/47] net/mlx5: Fix memory leak in mlx5_events_init
Date:   Thu, 28 May 2020 07:55:53 -0400
Message-Id: <20200528115600.1405808-40-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200528115600.1405808-1-sashal@kernel.org>
References: <20200528115600.1405808-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

From: Moshe Shemesh <moshe@mellanox.com>

[ Upstream commit df14ad1eccb04a4a28c90389214dbacab085b244 ]

Fix memory leak in mlx5_events_init(), in case
create_single_thread_workqueue() fails, events
struct should be freed.

Fixes: 5d3c537f9070 ("net/mlx5: Handle event of power detection in the PCIE slot")
Signed-off-by: Moshe Shemesh <moshe@mellanox.com>
Reviewed-by: Tariq Toukan <tariqt@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/events.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/events.c b/drivers/net/ethernet/mellanox/mlx5/core/events.c
index 8bcf3426b9c6..3ce17c3d7a00 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/events.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/events.c
@@ -346,8 +346,10 @@ int mlx5_events_init(struct mlx5_core_dev *dev)
 	events->dev = dev;
 	dev->priv.events = events;
 	events->wq = create_singlethread_workqueue("mlx5_events");
-	if (!events->wq)
+	if (!events->wq) {
+		kfree(events);
 		return -ENOMEM;
+	}
 	INIT_WORK(&events->pcie_core_work, mlx5_pcie_event);
 
 	return 0;
-- 
2.25.1

