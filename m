Return-Path: <SRS0=cc4V=VF=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0546C606AC
	for <linux-rdma@archiver.kernel.org>; Mon,  8 Jul 2019 10:59:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8B3002086D
	for <linux-rdma@archiver.kernel.org>; Mon,  8 Jul 2019 10:59:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1562583565;
	bh=BDn46YWg9Ux5XLJL1GOLw5fuk9ok46YM5fj3zmq/3Dg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=X4XclpBUYbLMy5IOMcge6fqEUrwzDkO0VlUWzvrepreaS9V1b2U6D6CbtqMAjetye
	 whZfMVdsOaqaY4IK+7XoORE0j6FIvafso8U0HmYyPXBl21K+MFcG+8+Ww+P5RybZPj
	 8o0IDeqfmWIoBBsfl1uxF3SpCP8bmxESAV8ckWzk=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730226AbfGHK7Z (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Mon, 8 Jul 2019 06:59:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:51232 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725836AbfGHK7Y (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Mon, 8 Jul 2019 06:59:24 -0400
Received: from localhost (unknown [37.142.3.125])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4220A208C4;
        Mon,  8 Jul 2019 10:59:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562583563;
        bh=BDn46YWg9Ux5XLJL1GOLw5fuk9ok46YM5fj3zmq/3Dg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hW1Yc/KTFVAGV2XmvlHyRQkyAj8rBUVkK1lQHV9B6x/MgJa0PaWm3mjStrU1lwcAe
         i1x3OFrJOgJhUz7NLs4FMCksRmXoQabm7pAymqtH7u3uScMkHgf0xE14nO3qgLp1AL
         fnaw7G4pE1go7mxJQg77BYl/LH6SDvAdbxAbw8Ps=
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Cc:     Leon Romanovsky <leonro@mellanox.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Max Gurtovoy <maxg@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Sagi Grimberg <sagi@grimberg.me>,
        Yamin Friedman <yaminf@mellanox.com>
Subject: [PATCH rdma-next v5 4/4] RDMA/mlx5: Set RDMA DIM to be enabled by default
Date:   Mon,  8 Jul 2019 13:59:05 +0300
Message-Id: <20190708105905.27468-5-leon@kernel.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190708105905.27468-1-leon@kernel.org>
References: <20190708105905.27468-1-leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro@mellanox.com>

Enable RDMA DIM by default for better user experience.

Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/infiniband/hw/mlx5/main.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index 7581571bd9cd..07a05b0b9e42 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -6424,6 +6424,8 @@ static int mlx5_ib_stage_caps_init(struct mlx5_ib_dev *dev)
 	     MLX5_CAP_GEN(dev->mdev, disable_local_lb_mc)))
 		mutex_init(&dev->lb.mutex);
 
+	dev->ib_dev.use_cq_dim = true;
+
 	return 0;
 }
 
-- 
2.20.1

