Return-Path: <SRS0=kLQv=CM=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D037DC43461
	for <linux-rdma@archiver.kernel.org>; Thu,  3 Sep 2020 07:39:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 946B62071B
	for <linux-rdma@archiver.kernel.org>; Thu,  3 Sep 2020 07:39:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1599118755;
	bh=UA6+FnwzEBlOqgJ2vGvrQRZNUwgYY8tUP/X2Tykv1cE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=GZPO1HVOVr+NzAIw/GxyzQIZsSho8AwA5dLqdtg8rcuBPY2q1d4haZiKaBrnFD/Ju
	 VSGWFkA+qV9IOg71CAk0EVNxcqT1ZplvPQG8hmF0HhykRO1RT8Aij4AkS4Wsit5i82
	 nPzcxaqUjO8iiV7aebXDR/QTxuJtLp9aKmP1GLPw=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728232AbgICHjP (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Thu, 3 Sep 2020 03:39:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:58838 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726109AbgICHjK (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Thu, 3 Sep 2020 03:39:10 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B44AD2071B;
        Thu,  3 Sep 2020 07:39:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599118750;
        bh=UA6+FnwzEBlOqgJ2vGvrQRZNUwgYY8tUP/X2Tykv1cE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mxDc7VA9DU1kPrHp2WYYU+v52bM9DZ7cl//qprx9w2L8DW1Zh45zSgEG3AVwUQGQQ
         G8ewzkNusl45BXmmElGBz266K0CX+8IAUkhxv35/MZgbyEkEoXnK3gvzObtsumHWK5
         WlDFFd3IFcJ/s2v38l9lBoRwvbK7iqy1dO+zMxDM=
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Cc:     Alex Vesker <valex@nvidia.com>, linux-rdma@vger.kernel.org
Subject: [PATCH rdma-next 2/3] RDMA/mlx5: Allow DM allocation for sw_owner_v2 enabled devices
Date:   Thu,  3 Sep 2020 10:38:56 +0300
Message-Id: <20200903073857.1129166-3-leon@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200903073857.1129166-1-leon@kernel.org>
References: <20200903073857.1129166-1-leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

From: Alex Vesker <valex@nvidia.com>

sw_owner_v2 will replace sw_owner for future devices, this means
that if sw_owner_v2 is set sw_owner should be ignored and DM
allocation is required for sw_owner_v2 devices to function.

Signed-off-by: Alex Vesker <valex@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/infiniband/hw/mlx5/main.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index 99dbef0bccbc..8963b806ad19 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -2343,7 +2343,9 @@ static inline int check_dm_type_support(struct mlx5_ib_dev *dev,
 			return -EPERM;
 
 		if (!(MLX5_CAP_FLOWTABLE_NIC_RX(dev->mdev, sw_owner) ||
-		      MLX5_CAP_FLOWTABLE_NIC_TX(dev->mdev, sw_owner)))
+		      MLX5_CAP_FLOWTABLE_NIC_TX(dev->mdev, sw_owner) ||
+		      MLX5_CAP_FLOWTABLE_NIC_RX(dev->mdev, sw_owner_v2) ||
+		      MLX5_CAP_FLOWTABLE_NIC_TX(dev->mdev, sw_owner_v2)))
 			return -EOPNOTSUPP;
 		break;
 	}
-- 
2.26.2

