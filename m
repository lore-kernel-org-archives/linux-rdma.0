Return-Path: <SRS0=t5r7=VU=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1D7BC76190
	for <linux-rdma@archiver.kernel.org>; Tue, 23 Jul 2019 06:57:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7A7CB2190F
	for <linux-rdma@archiver.kernel.org>; Tue, 23 Jul 2019 06:57:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1563865063;
	bh=PAKwrsrrYWi35shGU5h3/U8LCrl7JW0tANWchTXqn+k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=NhpXCh+d5lkhHGrQI9FYk/Je/oD6i37PPNg/oX68Oe8xuRKKGBFU/BOuhoYQVFSZd
	 +HDSG3PRg9poBR91f5fO4LCaubKl7hIcDdHOrMCtlmdXLJiz7okF2zDhkS6qKcXQ1b
	 167mNJLJ7KPH4HMSXC819hJmv/ayCmyTMEEkUSFQ=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729831AbfGWG5n (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Tue, 23 Jul 2019 02:57:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:42408 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729469AbfGWG5m (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Tue, 23 Jul 2019 02:57:42 -0400
Received: from localhost (unknown [193.47.165.251])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E9A982239E;
        Tue, 23 Jul 2019 06:57:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563865061;
        bh=PAKwrsrrYWi35shGU5h3/U8LCrl7JW0tANWchTXqn+k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lj143p/SNOqJl73mMuQM5xKt8wUUp2ywgz9Z3WfyLHQvgo5hVpWahldYnPItsV+wq
         esgwJaCe7PwZYPkvZwlw4I/vP7fppFyNuCPhuZIw4wCNIkdrSVKWXJdvjzUZWNAu6u
         BywojbVOogw2eUOY6sULVoWuHvWY2NDtnYVVVtCQ=
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
Subject: [PATCH rdma-rc 02/10] IB/mlx5: Fix unreg_umr to ignore the mkey state
Date:   Tue, 23 Jul 2019 09:57:25 +0300
Message-Id: <20190723065733.4899-3-leon@kernel.org>
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

Fix unreg_umr to ignore the mkey state and do not fail if was freed.
This prevents a case that a user space application already changed the
mkey state to free and then the UMR operation will fail leaving the mkey
in an un-applicable state.

Cc: <stable@vger.kernel.org> # 3.19
Fixes: 968e78dd9644 ("IB/mlx5: Enhance UMR support to allow partial page table update")
Signed-off-by: Yishai Hadas <yishaih@mellanox.com>
Reviewed-by: Artemy Kovalyov <artemyko@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/infiniband/hw/mlx5/mlx5_ib.h |  1 +
 drivers/infiniband/hw/mlx5/mr.c      |  4 ++--
 drivers/infiniband/hw/mlx5/qp.c      | 12 ++++++++----
 3 files changed, 11 insertions(+), 6 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
index c482f19958b3..f6a53455bf8b 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -481,6 +481,7 @@ struct mlx5_umr_wr {
 	u64				length;
 	int				access_flags;
 	u32				mkey;
+	u8				ignore_free_state:1;
 };

 static inline const struct mlx5_umr_wr *umr_wr(const struct ib_send_wr *wr)
diff --git a/drivers/infiniband/hw/mlx5/mr.c b/drivers/infiniband/hw/mlx5/mr.c
index 20ece6e0b2fc..266edaf8029d 100644
--- a/drivers/infiniband/hw/mlx5/mr.c
+++ b/drivers/infiniband/hw/mlx5/mr.c
@@ -1372,10 +1372,10 @@ static int unreg_umr(struct mlx5_ib_dev *dev, struct mlx5_ib_mr *mr)
 	if (mdev->state == MLX5_DEVICE_STATE_INTERNAL_ERROR)
 		return 0;

-	umrwr.wr.send_flags = MLX5_IB_SEND_UMR_DISABLE_MR |
-			      MLX5_IB_SEND_UMR_FAIL_IF_FREE;
+	umrwr.wr.send_flags = MLX5_IB_SEND_UMR_DISABLE_MR;
 	umrwr.wr.opcode = MLX5_IB_WR_UMR;
 	umrwr.mkey = mr->mmkey.key;
+	umrwr.ignore_free_state = 1;

 	return mlx5_ib_post_send_wait(dev, &umrwr);
 }
diff --git a/drivers/infiniband/hw/mlx5/qp.c b/drivers/infiniband/hw/mlx5/qp.c
index 2a97619ed603..615cc6771516 100644
--- a/drivers/infiniband/hw/mlx5/qp.c
+++ b/drivers/infiniband/hw/mlx5/qp.c
@@ -4295,10 +4295,14 @@ static int set_reg_umr_segment(struct mlx5_ib_dev *dev,

 	memset(umr, 0, sizeof(*umr));

-	if (wr->send_flags & MLX5_IB_SEND_UMR_FAIL_IF_FREE)
-		umr->flags = MLX5_UMR_CHECK_FREE; /* fail if free */
-	else
-		umr->flags = MLX5_UMR_CHECK_NOT_FREE; /* fail if not free */
+	if (!umrwr->ignore_free_state) {
+		if (wr->send_flags & MLX5_IB_SEND_UMR_FAIL_IF_FREE)
+			 /* fail if free */
+			umr->flags = MLX5_UMR_CHECK_FREE;
+		else
+			/* fail if not free */
+			umr->flags = MLX5_UMR_CHECK_NOT_FREE;
+	}

 	umr->xlt_octowords = cpu_to_be16(get_xlt_octo(umrwr->xlt_size));
 	if (wr->send_flags & MLX5_IB_SEND_UMR_UPDATE_XLT) {
--
2.20.1

