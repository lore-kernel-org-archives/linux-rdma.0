Return-Path: <SRS0=t5r7=VU=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D05DEC76190
	for <linux-rdma@archiver.kernel.org>; Tue, 23 Jul 2019 06:57:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9B6122239E
	for <linux-rdma@archiver.kernel.org>; Tue, 23 Jul 2019 06:57:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1563865069;
	bh=pL35KDH1zIU8WZiUNeX0BwO4rsSPPHW4YTqjVs60RpI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=HSwBpHQPq/LPHqUSBVhmnVltwLHwyJEs0mnPrWTdC5+nUwhJoJO8Y2817+TdoCbEt
	 PFVf7/JI37wehndmf1Uf8vCb6W+aYjdWFSELdZrT2h2jAqXUtUFvNPrmE8UXes4BXI
	 GoK3o3CKXn1E7Us7Jxq7+y07EvcIPF/yx/2YOo9A=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731015AbfGWG5t (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Tue, 23 Jul 2019 02:57:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:42474 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730829AbfGWG5t (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Tue, 23 Jul 2019 02:57:49 -0400
Received: from localhost (unknown [193.47.165.251])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A61982190F;
        Tue, 23 Jul 2019 06:57:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563865068;
        bh=pL35KDH1zIU8WZiUNeX0BwO4rsSPPHW4YTqjVs60RpI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zREazr0nEgBbCh02j0TqGgltJ8QQmItuKaVbx2qmpdoIy0+FFV22HllY1oriThyEH
         bCFsMkm6Gt5EGSuZWm0oGJqUqiv56BLBbq6z1fm3UDImXrtJ8EOmD51xkQY7KqS4fI
         J/QmJsjFs8wSreZgz0hIz5Om3Mep06g+zrJ97FuA=
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Cc:     Leon Romanovsky <leonro@mellanox.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Alex Vainman <alexv@mellanox.com>,
        Artemy Kovalyov <artemyko@mellanox.com>,
        Daniel Jurgens <danielj@mellanox.com>,
        Eli Cohen <eli@mellanox.com>,
        Haggai Eran <haggaie@mellanox.com>,
        Mark Zhang <markz@mellanox.com>,
        Moni Shoua <monis@mellanox.com>,
        Parav Pandit <parav@mellanox.com>,
        Sagi Grimberg <sagig@mellanox.com>,
        Yishai Hadas <yishaih@mellanox.com>
Subject: [PATCH rdma-rc 04/10] IB/mlx5: Fix unreg_umr to set a device PD
Date:   Tue, 23 Jul 2019 09:57:27 +0300
Message-Id: <20190723065733.4899-5-leon@kernel.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190723065733.4899-1-leon@kernel.org>
References: <20190723065733.4899-1-leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

From: Yishai Hadas <yishaih@mellanox.com>

Fix unreg_umr to set a device PD (i.e. UMR PD) which can't be given
outside to the kernel.

As the MR addresses are still in place we must ensure that this MR can't
be used by a user space that will get the original PD number and guess
the MR lkey.

Cc: <stable@vger.kernel.org> # 3.10
Fixes: e126ba97dba9 ("mlx5: Add driver for Mellanox Connect-IB adapters")
Signed-off-by: Yishai Hadas <yishaih@mellanox.com>
Reviewed-by: Artemy Kovalyov <artemyko@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/infiniband/hw/mlx5/mr.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/mlx5/mr.c b/drivers/infiniband/hw/mlx5/mr.c
index b83361aebf28..7274a9b9df58 100644
--- a/drivers/infiniband/hw/mlx5/mr.c
+++ b/drivers/infiniband/hw/mlx5/mr.c
@@ -1375,8 +1375,10 @@ static int unreg_umr(struct mlx5_ib_dev *dev, struct mlx5_ib_mr *mr)
 	if (mdev->state == MLX5_DEVICE_STATE_INTERNAL_ERROR)
 		return 0;

-	umrwr.wr.send_flags = MLX5_IB_SEND_UMR_DISABLE_MR;
+	umrwr.wr.send_flags = MLX5_IB_SEND_UMR_DISABLE_MR |
+			      MLX5_IB_SEND_UMR_UPDATE_PD_ACCESS;
 	umrwr.wr.opcode = MLX5_IB_WR_UMR;
+	umrwr.pd = dev->umrc.pd;
 	umrwr.mkey = mr->mmkey.key;
 	umrwr.ignore_free_state = 1;

--
2.20.1

