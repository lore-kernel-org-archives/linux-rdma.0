Return-Path: <SRS0=pJc0=6O=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A43A7C28CBC
	for <linux-rdma@archiver.kernel.org>; Thu, 30 Apr 2020 14:02:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8254220870
	for <linux-rdma@archiver.kernel.org>; Thu, 30 Apr 2020 14:02:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1588255322;
	bh=ARzt+QRGNF/8fnvNLUN8Z+j7aZMWVm22ICAbuRC5tLk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=aJEcQTmB1YYU5l2QF7aJ09BHwGahOV4JiNA2SGuAXKydDL+tVY1mhT3S9PJdl/W4V
	 3xNWo+instY8SM+yNVKWG41kTk43qN9At2Xc9GxicRabzU6QlSSCN3DN0CPqYD6SVv
	 4pQ8vXGrQvL4OSggYqc/lZVaifY8BZRj4Euqr5PU=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728774AbgD3OBz (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Thu, 30 Apr 2020 10:01:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:35742 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728805AbgD3Nxs (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Thu, 30 Apr 2020 09:53:48 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 87DB520870;
        Thu, 30 Apr 2020 13:53:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588254828;
        bh=ARzt+QRGNF/8fnvNLUN8Z+j7aZMWVm22ICAbuRC5tLk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=slk8kbE64pkhcKAYzVj0R75zNGZCTlUuzcKk24Zbv2WbLHNszYdHSwTDfCTVGKDMe
         Z36Xqyce7Yktn4cmxX1ht83Wmk5zQWkIth4QLbVt2sehIQCsJ4dbrlrGA6oMkf8yU2
         RpBnu4vFtLMc5g+YmhdeU8gQKzMRptihQaVd7Vt8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Niklas Schnelle <schnelle@linux.ibm.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 20/30] net/mlx5: Fix failing fw tracer allocation on s390
Date:   Thu, 30 Apr 2020 09:53:15 -0400
Message-Id: <20200430135325.20762-20-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200430135325.20762-1-sashal@kernel.org>
References: <20200430135325.20762-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

From: Niklas Schnelle <schnelle@linux.ibm.com>

[ Upstream commit a019b36123aec9700b21ae0724710f62928a8bc1 ]

On s390 FORCE_MAX_ZONEORDER is 9 instead of 11, thus a larger kzalloc()
allocation as done for the firmware tracer will always fail.

Looking at mlx5_fw_tracer_save_trace(), it is actually the driver itself
that copies the debug data into the trace array and there is no need for
the allocation to be contiguous in physical memory. We can therefor use
kvzalloc() instead of kzalloc() and get rid of the large contiguous
allcoation.

Fixes: f53aaa31cce7 ("net/mlx5: FW tracer, implement tracer logic")
Signed-off-by: Niklas Schnelle <schnelle@linux.ibm.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c b/drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c
index d4ec93bde4ded..2266c09b741a2 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c
@@ -796,7 +796,7 @@ struct mlx5_fw_tracer *mlx5_fw_tracer_create(struct mlx5_core_dev *dev)
 		return NULL;
 	}
 
-	tracer = kzalloc(sizeof(*tracer), GFP_KERNEL);
+	tracer = kvzalloc(sizeof(*tracer), GFP_KERNEL);
 	if (!tracer)
 		return ERR_PTR(-ENOMEM);
 
@@ -842,7 +842,7 @@ destroy_workqueue:
 	tracer->dev = NULL;
 	destroy_workqueue(tracer->work_queue);
 free_tracer:
-	kfree(tracer);
+	kvfree(tracer);
 	return ERR_PTR(err);
 }
 
@@ -919,7 +919,7 @@ void mlx5_fw_tracer_destroy(struct mlx5_fw_tracer *tracer)
 	mlx5_fw_tracer_destroy_log_buf(tracer);
 	flush_workqueue(tracer->work_queue);
 	destroy_workqueue(tracer->work_queue);
-	kfree(tracer);
+	kvfree(tracer);
 }
 
 void mlx5_fw_tracer_event(struct mlx5_core_dev *dev, struct mlx5_eqe *eqe)
-- 
2.20.1

