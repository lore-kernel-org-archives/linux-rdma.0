Return-Path: <SRS0=tE8X=3C=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3FF8C33CAE
	for <linux-rdma@archiver.kernel.org>; Mon, 13 Jan 2020 07:31:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C15212073D
	for <linux-rdma@archiver.kernel.org>; Mon, 13 Jan 2020 07:31:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728731AbgAMHbl (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Mon, 13 Jan 2020 02:31:41 -0500
Received: from smtprelay0033.hostedemail.com ([216.40.44.33]:40108 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728646AbgAMHbl (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>);
        Mon, 13 Jan 2020 02:31:41 -0500
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay07.hostedemail.com (Postfix) with ESMTP id 0D0DF181D3417;
        Mon, 13 Jan 2020 07:31:39 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-HE-Tag: fear63_658d484eb9418
X-Filterd-Recvd-Size: 5014
Received: from XPS-9350.home (unknown [47.151.135.224])
        (Authenticated sender: joe@perches.com)
        by omf08.hostedemail.com (Postfix) with ESMTPA;
        Mon, 13 Jan 2020 07:31:37 +0000 (UTC)
Message-ID: <3b91c274164d1ae9d81dce9f3b398d691cc6765e.camel@perches.com>
Subject: [PATCH net-next] mlx5: Use proper logging and tracing line
 terminations
From:   Joe Perches <joe@perches.com>
To:     Saeed Mahameed <saeedm@mellanox.com>,
        Leon Romanovsky <leon@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Sun, 12 Jan 2020 23:30:43 -0800
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.34.1-2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

netdev_err should use newline termination but mlx5_health_report
is used in a trace output function devlink_health_report where
no newline should be used.

Remove the newlines from a couple formats and add a format string
of "%s\n" to the netdev_err call to not directly output the
logging string.

Also use snprintf to avoid any possible output string overrun.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/health.c      |  2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/reporter_rx.c |  9 +++++----
 drivers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c | 10 +++++-----
 3 files changed, 11 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/health.c b/drivers/net/ethernet/mellanox/mlx5/core/en/health.c
index 3a9756..75a35f1 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/health.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/health.c
@@ -197,7 +197,7 @@ int mlx5e_health_report(struct mlx5e_priv *priv,
 			struct devlink_health_reporter *reporter, char *err_str,
 			struct mlx5e_err_ctx *err_ctx)
 {
-	netdev_err(priv->netdev, err_str);
+	netdev_err(priv->netdev, "%s\n", err_str);
 
 	if (!reporter)
 		return err_ctx->recover(&err_ctx->ctx);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_rx.c
index 6c72b59..67d2f70 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_rx.c
@@ -110,7 +110,7 @@ void mlx5e_reporter_icosq_cqe_err(struct mlx5e_icosq *icosq)
 
 	err_ctx.ctx = icosq;
 	err_ctx.recover = mlx5e_rx_reporter_err_icosq_cqe_recover;
-	sprintf(err_str, "ERR CQE on ICOSQ: 0x%x", icosq->sqn);
+	snprintf(err_str, sizeof(err_str), "ERR CQE on ICOSQ: 0x%x", icosq->sqn);
 
 	mlx5e_health_report(priv, priv->rx_reporter, err_str, &err_ctx);
 }
@@ -179,7 +179,7 @@ void mlx5e_reporter_rq_cqe_err(struct mlx5e_rq *rq)
 
 	err_ctx.ctx = rq;
 	err_ctx.recover = mlx5e_rx_reporter_err_rq_cqe_recover;
-	sprintf(err_str, "ERR CQE on RQ: 0x%x", rq->rqn);
+	snprintf(err_str, sizeof(err_str), "ERR CQE on RQ: 0x%x", rq->rqn);
 
 	mlx5e_health_report(priv, priv->rx_reporter, err_str, &err_ctx);
 }
@@ -210,8 +210,9 @@ void mlx5e_reporter_rx_timeout(struct mlx5e_rq *rq)
 
 	err_ctx.ctx = rq;
 	err_ctx.recover = mlx5e_rx_reporter_timeout_recover;
-	sprintf(err_str, "RX timeout on channel: %d, ICOSQ: 0x%x RQ: 0x%x, CQ: 0x%x\n",
-		icosq->channel->ix, icosq->sqn, rq->rqn, rq->cq.mcq.cqn);
+	snprintf(err_str, sizeof(err_str),
+		 "RX timeout on channel: %d, ICOSQ: 0x%x RQ: 0x%x, CQ: 0x%x",
+		 icosq->channel->ix, icosq->sqn, rq->rqn, rq->cq.mcq.cqn);
 
 	mlx5e_health_report(priv, priv->rx_reporter, err_str, &err_ctx);
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c b/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c
index b46854..5ecb986 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c
@@ -90,7 +90,7 @@ void mlx5e_reporter_tx_err_cqe(struct mlx5e_txqsq *sq)
 
 	err_ctx.ctx = sq;
 	err_ctx.recover = mlx5e_tx_reporter_err_cqe_recover;
-	sprintf(err_str, "ERR CQE on SQ: 0x%x", sq->sqn);
+	snprintf(err_str, sizeof(err_str), "ERR CQE on SQ: 0x%x", sq->sqn);
 
 	mlx5e_health_report(priv, priv->tx_reporter, err_str, &err_ctx);
 }
@@ -118,10 +118,10 @@ int mlx5e_reporter_tx_timeout(struct mlx5e_txqsq *sq)
 
 	err_ctx.ctx = sq;
 	err_ctx.recover = mlx5e_tx_reporter_timeout_recover;
-	sprintf(err_str,
-		"TX timeout on queue: %d, SQ: 0x%x, CQ: 0x%x, SQ Cons: 0x%x SQ Prod: 0x%x, usecs since last trans: %u\n",
-		sq->channel->ix, sq->sqn, sq->cq.mcq.cqn, sq->cc, sq->pc,
-		jiffies_to_usecs(jiffies - sq->txq->trans_start));
+	snprintf(err_str, sizeof(err_str),
+		 "TX timeout on queue: %d, SQ: 0x%x, CQ: 0x%x, SQ Cons: 0x%x SQ Prod: 0x%x, usecs since last trans: %u",
+		 sq->channel->ix, sq->sqn, sq->cq.mcq.cqn, sq->cc, sq->pc,
+		 jiffies_to_usecs(jiffies - sq->txq->trans_start));
 
 	return mlx5e_health_report(priv, priv->tx_reporter, err_str, &err_ctx);
 }



