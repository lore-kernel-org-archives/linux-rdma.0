Return-Path: <SRS0=pTjR=77=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2918C433E0
	for <linux-rdma@archiver.kernel.org>; Thu, 18 Jun 2020 02:45:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A49F421974
	for <linux-rdma@archiver.kernel.org>; Thu, 18 Jun 2020 02:45:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1592448348;
	bh=/5CTNdM+F7gp4IC14sNl6sz4EKBucflwPUzL4O4i0n0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=m98p5HPDR2VDM5of26CblGb/yeoTN3JxXc23wEKnb4VB0s5U+tXbMAwJxTFfQlgmn
	 wA3ko8SRuHa0svqjPEuQQ4hTLWitN48z3QpKTy20yPZhovHBq2ExGPp7Kzg0HWZdQq
	 M0M82fgumAALxPFN1nFFWQXKuWOs5oSWQ4PhYOuY=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728634AbgFRBKw (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Wed, 17 Jun 2020 21:10:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:38380 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728626AbgFRBKv (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Wed, 17 Jun 2020 21:10:51 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C2DED21924;
        Thu, 18 Jun 2020 01:10:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592442650;
        bh=/5CTNdM+F7gp4IC14sNl6sz4EKBucflwPUzL4O4i0n0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1Er9sbcQ7PIBWiAx+YlbbAU4F/4e14FMmyF95Xe+B5nyfngitw0f8J6shQxhm52PW
         XVkU/Q1ElXDg8hAYrt4elr3keCfeQC42Fc6PAXqHng25oiFweJHJ8AwnkSqpcmUuKm
         Bx1DeCynDg6DnIVuV/LFUad2aiqI+EXJAY4AtWQU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yishai Hadas <yishaih@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>, linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 5.7 123/388] RDMA/mlx5: Fix udata response upon SRQ creation
Date:   Wed, 17 Jun 2020 21:03:40 -0400
Message-Id: <20200618010805.600873-123-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200618010805.600873-1-sashal@kernel.org>
References: <20200618010805.600873-1-sashal@kernel.org>
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
index b1a8a9175040..6d1ff13d2283 100644
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

