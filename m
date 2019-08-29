Return-Path: <SRS0=TqN+=WZ=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2FE1C3A5A6
	for <linux-rdma@archiver.kernel.org>; Thu, 29 Aug 2019 18:34:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9BEC2205C9
	for <linux-rdma@archiver.kernel.org>; Thu, 29 Aug 2019 18:34:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1567103667;
	bh=hmKdjn+vbAP1QfonYOqWbHhhmRBh/rVxCGF7ivjgQXU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=GceL1mSw2N+D0s8sJxkW8xSrh7IOOaqJhwgqv6h7zLStSyM4B3rGgdm+xqc7bTeG7
	 WNdkfwNDtbSowaQlVkt5Fam6vhc2MUwF9zjtdDPAVyR+Z2yUG4IXJEiA+HAQlXZMLq
	 kftWLyuw1YfQIE5RhWlxVsldhAAtzJk6z2GZf/X8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728217AbfH2SN3 (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Thu, 29 Aug 2019 14:13:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:55182 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728153AbfH2SN3 (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Thu, 29 Aug 2019 14:13:29 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1911722CF5;
        Thu, 29 Aug 2019 18:13:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567102407;
        bh=hmKdjn+vbAP1QfonYOqWbHhhmRBh/rVxCGF7ivjgQXU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=udi51MTLn//10gZdglmnCsdcmj9SaIVd/d0CxssUhzYet64czPvZ2Nr3X/n/2XPXq
         SOD4lR3nacLkehi1lbdN5s1L3pkKlBnEq6eJP7sM7cQbjtatkPh0O2UURSDEXGoMWQ
         F1zw6NtbN8uCpCI0S/G4nivNh/z9G/somtRKZaBg=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Aya Levin <ayal@mellanox.com>, Tariq Toukan <tariqt@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 5.2 05/76] net/mlx5e: Fix error flow of CQE recovery on tx reporter
Date:   Thu, 29 Aug 2019 14:12:00 -0400
Message-Id: <20190829181311.7562-5-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190829181311.7562-1-sashal@kernel.org>
References: <20190829181311.7562-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

From: Aya Levin <ayal@mellanox.com>

[ Upstream commit 276d197e70bcc47153592f4384675b51c7d83aba ]

CQE recovery function begins with test and set of recovery bit. Add an
error flow which ensures clearing of this bit when leaving the recovery
function, to allow further recoveries to take place. This allows removal
of clearing recovery bit on sq activate.

Fixes: de8650a82071 ("net/mlx5e: Add tx reporter support")
Signed-off-by: Aya Levin <ayal@mellanox.com>
Reviewed-by: Tariq Toukan <tariqt@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/mellanox/mlx5/core/en/reporter_tx.c | 12 ++++++++----
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c    |  1 -
 2 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c b/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c
index c1caf14bc3346..c7f86453c6384 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c
@@ -80,17 +80,17 @@ static int mlx5e_tx_reporter_err_cqe_recover(struct mlx5e_txqsq *sq)
 	if (err) {
 		netdev_err(dev, "Failed to query SQ 0x%x state. err = %d\n",
 			   sq->sqn, err);
-		return err;
+		goto out;
 	}
 
 	if (state != MLX5_SQC_STATE_ERR)
-		return 0;
+		goto out;
 
 	mlx5e_tx_disable_queue(sq->txq);
 
 	err = mlx5e_wait_for_sq_flush(sq);
 	if (err)
-		return err;
+		goto out;
 
 	/* At this point, no new packets will arrive from the stack as TXQ is
 	 * marked with QUEUE_STATE_DRV_XOFF. In addition, NAPI cleared all
@@ -99,13 +99,17 @@ static int mlx5e_tx_reporter_err_cqe_recover(struct mlx5e_txqsq *sq)
 
 	err = mlx5e_sq_to_ready(sq, state);
 	if (err)
-		return err;
+		goto out;
 
 	mlx5e_reset_txqsq_cc_pc(sq);
 	sq->stats->recover++;
+	clear_bit(MLX5E_SQ_STATE_RECOVERING, &sq->state);
 	mlx5e_activate_txqsq(sq);
 
 	return 0;
+out:
+	clear_bit(MLX5E_SQ_STATE_RECOVERING, &sq->state);
+	return err;
 }
 
 static int mlx5_tx_health_report(struct devlink_health_reporter *tx_reporter,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 882d26b8095da..bbdfdaf06391a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -1279,7 +1279,6 @@ static int mlx5e_open_txqsq(struct mlx5e_channel *c,
 void mlx5e_activate_txqsq(struct mlx5e_txqsq *sq)
 {
 	sq->txq = netdev_get_tx_queue(sq->channel->netdev, sq->txq_ix);
-	clear_bit(MLX5E_SQ_STATE_RECOVERING, &sq->state);
 	set_bit(MLX5E_SQ_STATE_ENABLED, &sq->state);
 	netdev_tx_reset_queue(sq->txq);
 	netif_tx_start_queue(sq->txq);
-- 
2.20.1

