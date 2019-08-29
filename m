Return-Path: <SRS0=TqN+=WZ=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30336C3A59F
	for <linux-rdma@archiver.kernel.org>; Thu, 29 Aug 2019 18:27:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F0A3D21726
	for <linux-rdma@archiver.kernel.org>; Thu, 29 Aug 2019 18:27:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1567103269;
	bh=koxCPy5DUegL9f1JbTv6u/+jKYiW7/zmbZvd+ZOA9lQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=Px25Rk+f5CeF1vuyZbqo9sHzNeh0iBkeYw1TP23NyhGyKGXt217LNfgugds3jU1vR
	 V/AX9b2ygRTNiiFNqkBOnU2zDSS8G2GTncXCAcmQnrxr7b8qOB8CUINtYZ9vzPj/TE
	 HBHFrDpPGUWUk22I8U4sQBuoyBOdCJiXH6lhaji0=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729205AbfH2SPN (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Thu, 29 Aug 2019 14:15:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:56908 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729194AbfH2SPN (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Thu, 29 Aug 2019 14:15:13 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6EF092339E;
        Thu, 29 Aug 2019 18:15:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567102512;
        bh=koxCPy5DUegL9f1JbTv6u/+jKYiW7/zmbZvd+ZOA9lQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nzNzCH3SPq9bWTHecob1o5QITF1REMHQQHN7nZABCVh0z4Y/+SApAuZ1iIRMNwOHa
         P7ZxEejjVjHmxKz6uW1IV04SaNRwCI3V5AILHOsv8sG0SxhBzFw8UxodtzuMgqBiTx
         oleYp4Nn4PVwcGqk1qwlNTTynKFnSQgRmwM9URJY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Wenwen Wang <wenwen@cs.uga.edu>,
        Leon Romanovsky <leonro@mellanox.com>,
        Doug Ledford <dledford@redhat.com>,
        Sasha Levin <sashal@kernel.org>, linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 5.2 60/76] IB/mlx4: Fix memory leaks
Date:   Thu, 29 Aug 2019 14:12:55 -0400
Message-Id: <20190829181311.7562-60-sashal@kernel.org>
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

From: Wenwen Wang <wenwen@cs.uga.edu>

[ Upstream commit 5c1baaa82cea2c815a5180ded402a7cd455d1810 ]

In mlx4_ib_alloc_pv_bufs(), 'tun_qp->tx_ring' is allocated through
kcalloc(). However, it is not always deallocated in the following execution
if an error occurs, leading to memory leaks. To fix this issue, free
'tun_qp->tx_ring' whenever an error occurs.

Signed-off-by: Wenwen Wang <wenwen@cs.uga.edu>
Acked-by: Leon Romanovsky <leonro@mellanox.com>
Link: https://lore.kernel.org/r/1566159781-4642-1-git-send-email-wenwen@cs.uga.edu
Signed-off-by: Doug Ledford <dledford@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/mlx4/mad.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/mlx4/mad.c b/drivers/infiniband/hw/mlx4/mad.c
index 68c951491a08a..57079110af9b5 100644
--- a/drivers/infiniband/hw/mlx4/mad.c
+++ b/drivers/infiniband/hw/mlx4/mad.c
@@ -1677,8 +1677,6 @@ static int mlx4_ib_alloc_pv_bufs(struct mlx4_ib_demux_pv_ctx *ctx,
 				    tx_buf_size, DMA_TO_DEVICE);
 		kfree(tun_qp->tx_ring[i].buf.addr);
 	}
-	kfree(tun_qp->tx_ring);
-	tun_qp->tx_ring = NULL;
 	i = MLX4_NUM_TUNNEL_BUFS;
 err:
 	while (i > 0) {
@@ -1687,6 +1685,8 @@ static int mlx4_ib_alloc_pv_bufs(struct mlx4_ib_demux_pv_ctx *ctx,
 				    rx_buf_size, DMA_FROM_DEVICE);
 		kfree(tun_qp->ring[i].addr);
 	}
+	kfree(tun_qp->tx_ring);
+	tun_qp->tx_ring = NULL;
 	kfree(tun_qp->ring);
 	tun_qp->ring = NULL;
 	return -ENOMEM;
-- 
2.20.1

