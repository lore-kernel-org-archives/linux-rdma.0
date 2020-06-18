Return-Path: <SRS0=pTjR=77=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E4BBC433E0
	for <linux-rdma@archiver.kernel.org>; Thu, 18 Jun 2020 02:21:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3A95721924
	for <linux-rdma@archiver.kernel.org>; Thu, 18 Jun 2020 02:21:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1592446907;
	bh=s92cz/KclSxPalblzdGD4uhIFYB5I4LCbjOIdDePFDc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=oazfeEWeuy5mS9sdSNXROL2kljaMqGgyQ+Rzqqe+6LQ+90MPpq5pf/m8Kg9sIiOcA
	 t0FDCtKFrLWCk5g8BXvIamSdBReunXjoLhMPGXEOhBAoAHeNi+N7qOi9Moc4Xo6P1y
	 FyZVnSMlvhgYO2NSlohfU5zuONh1stFQ3ZqaPxa8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730122AbgFRCVp (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Wed, 17 Jun 2020 22:21:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:50042 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728710AbgFRBSg (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Wed, 17 Jun 2020 21:18:36 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C4B0221D82;
        Thu, 18 Jun 2020 01:18:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592443115;
        bh=s92cz/KclSxPalblzdGD4uhIFYB5I4LCbjOIdDePFDc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nBcEg+WlICR3rwl1rFl/RkiOf1x8mRdjkFVGNasob/qmuW+dphrGIhbOVZVxP4p/9
         ZdcRQeOmi9L4H3QXc8FflQH+VZTlwqq9oYQS/s7sFn3G88R9TFBbqo07gioCkKFR+u
         9lbd+R8Y44mGOJaX7glsO84z/NMZy26ZPbmiPLgI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yishai Hadas <yishaih@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>, linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 091/266] RDMA/mlx5: Fix udata response upon SRQ creation
Date:   Wed, 17 Jun 2020 21:13:36 -0400
Message-Id: <20200618011631.604574-91-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200618011631.604574-1-sashal@kernel.org>
References: <20200618011631.604574-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

From: Yishai Hadas <yishaih@mellanox.com>

[ Upstream commit cf26deff9036cd3270af562dbec545239e5c7f07 ]

Fix udata response upon SRQ creation to use the UAPI structure (i.e.
mlx5_ib_create_srq_resp). It did not zero the reserved field in userspace.

Fixes: e126ba97dba9 ("mlx5: Add driver for Mellanox Connect-IB adapters")
Link: https://lore.kernel.org/r/20200406173540.1466477-1-leon@kernel.org
Signed-off-by: Yishai Hadas <yishaih@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/mlx5/srq.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/srq.c b/drivers/infiniband/hw/mlx5/srq.c
index 4e7fde86c96b..c29c1f7da4a1 100644
--- a/drivers/infiniband/hw/mlx5/srq.c
+++ b/drivers/infiniband/hw/mlx5/srq.c
@@ -310,12 +310,18 @@ int mlx5_ib_create_srq(struct ib_srq *ib_srq,
 	srq->msrq.event = mlx5_ib_srq_event;
 	srq->ibsrq.ext.xrc.srq_num = srq->msrq.srqn;
 
-	if (udata)
-		if (ib_copy_to_udata(udata, &srq->msrq.srqn, sizeof(__u32))) {
+	if (udata) {
+		struct mlx5_ib_create_srq_resp resp = {
+			.srqn = srq->msrq.srqn,
+		};
+
+		if (ib_copy_to_udata(udata, &resp, min(udata->outlen,
+				     sizeof(resp)))) {
 			mlx5_ib_dbg(dev, "copy to user failed\n");
 			err = -EFAULT;
 			goto err_core;
 		}
+	}
 
 	init_attr->attr.max_wr = srq->msrq.max - 1;
 
-- 
2.25.1

