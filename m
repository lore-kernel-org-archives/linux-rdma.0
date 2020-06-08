Return-Path: <SRS0=N7RC=7W=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0DFCBC433E1
	for <linux-rdma@archiver.kernel.org>; Tue,  9 Jun 2020 00:25:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C2D1E20810
	for <linux-rdma@archiver.kernel.org>; Tue,  9 Jun 2020 00:25:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1591662333;
	bh=Fq08WiGXR6FwbLRZUz7UkKFRbZajXaHYhJA5CPalye4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=m/84L0PnzlPtKAL7S4G7h40zF4gZeKH6Oct5lQDI5QnttuEXVWRhrYyld3CpdPM/u
	 qwGDyGi/VPRG6/WZIBI9ryFx4djjXInSzxdEFp9fnPSIn8RWA7wOcfUPhFoT/NbG0Q
	 2Rr/41zxnUJ8/LYAhHhmvjHO2BN1tgKsbm8fYnnA=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731356AbgFIAZb (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Mon, 8 Jun 2020 20:25:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:38350 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730368AbgFHXQ4 (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Mon, 8 Jun 2020 19:16:56 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9166B2086A;
        Mon,  8 Jun 2020 23:16:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591658216;
        bh=Fq08WiGXR6FwbLRZUz7UkKFRbZajXaHYhJA5CPalye4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QOZi2ymahb+IfL4B35bBNUnYcCh737K8CxPG9B9tAfi7JSK2Bj2W9ly+a+62g67aQ
         roJ3f0VJNDicKFwkAfXskQyyGyAWpgdMSzOR46C5Re4cVFOdcQOPT1f0NkHu10QuAg
         Gm9YzoRKOZjikeJar4b5R5Xa2qw6pY35tuI2DwvM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Moshe Shemesh <moshe@mellanox.com>,
        Tariq Toukan <tariqt@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 5.6 232/606] net/mlx5e: Update netdev txq on completions during closure
Date:   Mon,  8 Jun 2020 19:05:57 -0400
Message-Id: <20200608231211.3363633-232-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200608231211.3363633-1-sashal@kernel.org>
References: <20200608231211.3363633-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

From: Moshe Shemesh <moshe@mellanox.com>

[ Upstream commit 5e911e2c06bd8c17df29147a5e2d4b17fafda024 ]

On sq closure when we free its descriptors, we should also update netdev
txq on completions which would not arrive. Otherwise if we reopen sqs
and attach them back, for example on fw fatal recovery flow, we may get
tx timeout.

Fixes: 29429f3300a3 ("net/mlx5e: Timeout if SQ doesn't flush during close")
Signed-off-by: Moshe Shemesh <moshe@mellanox.com>
Reviewed-by: Tariq Toukan <tariqt@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_tx.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
index ee60383adc5b..c2b801b435cf 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
@@ -538,10 +538,9 @@ bool mlx5e_poll_tx_cq(struct mlx5e_cq *cq, int napi_budget)
 void mlx5e_free_txqsq_descs(struct mlx5e_txqsq *sq)
 {
 	struct mlx5e_tx_wqe_info *wi;
+	u32 dma_fifo_cc, nbytes = 0;
+	u16 ci, sqcc, npkts = 0;
 	struct sk_buff *skb;
-	u32 dma_fifo_cc;
-	u16 sqcc;
-	u16 ci;
 	int i;
 
 	sqcc = sq->cc;
@@ -566,11 +565,15 @@ void mlx5e_free_txqsq_descs(struct mlx5e_txqsq *sq)
 		}
 
 		dev_kfree_skb_any(skb);
+		npkts++;
+		nbytes += wi->num_bytes;
 		sqcc += wi->num_wqebbs;
 	}
 
 	sq->dma_fifo_cc = dma_fifo_cc;
 	sq->cc = sqcc;
+
+	netdev_tx_completed_queue(sq->txq, npkts, nbytes);
 }
 
 #ifdef CONFIG_MLX5_CORE_IPOIB
-- 
2.25.1

