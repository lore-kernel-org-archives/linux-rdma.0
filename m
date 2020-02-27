Return-Path: <SRS0=V7/i=4P=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9928CC4BA24
	for <linux-rdma@archiver.kernel.org>; Thu, 27 Feb 2020 11:38:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 61EF224693
	for <linux-rdma@archiver.kernel.org>; Thu, 27 Feb 2020 11:38:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1582803520;
	bh=mtd9qpgUiU6N4wQBc9WIWkXfByz7o88hLKpjm2a1w3w=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=KqxQhzi/KCDNICnANz3jPhHlZaeyvSiDDr3daua3FmEi8CR1yEzUvyDV3Uo0mqDNI
	 p45unYsY4cWpjjGjdSYSevh6XOqd+s+Kit9gtKo74uLaOO8FDMub/nka+3Mz4i/29P
	 VLnNFtdtYSOY8Qfn+KWrSqKVG+A8eUhkdS+e6j2o=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728872AbgB0Lij (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Thu, 27 Feb 2020 06:38:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:48814 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728856AbgB0Lij (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Thu, 27 Feb 2020 06:38:39 -0500
Received: from localhost (unknown [193.47.165.251])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A8D2224690;
        Thu, 27 Feb 2020 11:38:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582803519;
        bh=mtd9qpgUiU6N4wQBc9WIWkXfByz7o88hLKpjm2a1w3w=;
        h=From:To:Cc:Subject:Date:From;
        b=n9qmKzQDOYVZ1oMBL+iq3nv6vCAfuRsnI+bO7wP/gHW5Zyiso16m3tSrbl2d7vX+K
         p97mlDqjMhTipP4e4lj07iWVvWan7zd54MnU6p3ceawYXJsYHkgaIziOgk/hncZ+Gu
         1bCdOcDeokH80a0Uhr/p7Q+erkpfmmB9ppumfEgg=
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Cc:     Michael Guralnik <michaelgur@mellanox.com>,
        linux-rdma@vger.kernel.org, Maor Gottlieb <maorg@mellanox.com>,
        Yishai Hadas <yishaih@mellanox.com>
Subject: [PATCH rdma-rc] RDMA/mlx5: Prevent UMR usage with RO only when we have RO caps
Date:   Thu, 27 Feb 2020 13:38:34 +0200
Message-Id: <20200227113834.94233-1-leon@kernel.org>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

From: Michael Guralnik <michaelgur@mellanox.com>

Relaxed ordering is not supported in UMR so we are disabling UMR usage
when user passes relaxed ordering access flag.

Enable using UMR when user requested relaxed ordering but there are no
relaxed ordering capabilities.
This will prevent user from unnecessarily registering a new mkey.

Fixes: d6de0bb1850f ("RDMA/mlx5: Set relaxed ordering when requested")
Signed-off-by: Michael Guralnik <michaelgur@mellanox.com>
Reviewed-by: Maor Gottlieb <maorg@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/infiniband/hw/mlx5/mlx5_ib.h | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
index d9bffcc93587..f21d446249b8 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -1532,7 +1532,9 @@ static inline bool mlx5_ib_can_use_umr(struct mlx5_ib_dev *dev,
 	    MLX5_CAP_GEN(dev->mdev, umr_modify_atomic_disabled))
 		return false;
 
-	if (access_flags & IB_ACCESS_RELAXED_ORDERING)
+	if (access_flags & IB_ACCESS_RELAXED_ORDERING &&
+	    (MLX5_CAP_GEN(dev->mdev, relaxed_ordering_write) ||
+	     MLX5_CAP_GEN(dev->mdev, relaxed_ordering_read)))
 		return false;
 
 	return true;
-- 
2.24.1

