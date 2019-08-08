Return-Path: <SRS0=Pj7p=WE=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71982C433FF
	for <linux-rdma@archiver.kernel.org>; Thu,  8 Aug 2019 08:44:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3E1252173C
	for <linux-rdma@archiver.kernel.org>; Thu,  8 Aug 2019 08:44:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1565253847;
	bh=zaHHuFxkhBeWR/gXLWjLQSd6uyzBP6ST0xkshvh1jQs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=KpY6w1Xv1Hz2dBXhqvHtW/jYTvqrHGKEof5PqU6ZfDQss1ILzZevde8k2A3/cnLeJ
	 yMzvbcXtlvbdWedQ04V0A/aFjXSCxenvx//4tlqV+VvmeYvXXh3vXMD6tiqQJuC1ZI
	 ofIGDRiQO14dX3g0Z0m3gH64EUIMJGhGEDgn6K0o=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731076AbfHHIoG (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Thu, 8 Aug 2019 04:44:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:50660 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730678AbfHHIoG (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Thu, 8 Aug 2019 04:44:06 -0400
Received: from localhost (unknown [193.47.165.251])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F3EB0217F4;
        Thu,  8 Aug 2019 08:44:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565253845;
        bh=zaHHuFxkhBeWR/gXLWjLQSd6uyzBP6ST0xkshvh1jQs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hi3rHL+64Tp5jPQ9JT7/oQVa6Iqg16g3fBhZl/L4r4WQ2SWpLtfSirw4ScmT52EkZ
         m+gciXXox/f2P+93Wf43WEr7zORA03GoYVRabNJBJiJZZF7M6hlL+ivgqmgX92Iwmu
         MV8sCzz9EaQtR22jkAVSeJ24LaOfFImtBm1G7dug=
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Cc:     Leon Romanovsky <leonro@mellanox.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Edward Srouji <edwards@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Yishai Hadas <yishaih@mellanox.com>,
        linux-netdev <netdev@vger.kernel.org>
Subject: [PATCH mlx5-next 1/4] net/mlx5: Use debug message instead of warn
Date:   Thu,  8 Aug 2019 11:43:55 +0300
Message-Id: <20190808084358.29517-2-leon@kernel.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190808084358.29517-1-leon@kernel.org>
References: <20190808084358.29517-1-leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

From: Yishai Hadas <yishaih@mellanox.com>

As QP may be created by DEVX, it may be valid to not find the rsn in
mlx5 core tree, change the level to be debug.

Signed-off-by: Yishai Hadas <yishaih@mellanox.com>
Reviewed-by: Saeed Mahameed <saeedm@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/qp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/qp.c b/drivers/net/ethernet/mellanox/mlx5/core/qp.c
index b8ba74de9555..f0f3abe331da 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/qp.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/qp.c
@@ -162,7 +162,7 @@ static int rsc_event_notifier(struct notifier_block *nb,
 
 	common = mlx5_get_rsc(table, rsn);
 	if (!common) {
-		mlx5_core_warn(dev, "Async event for bogus resource 0x%x\n", rsn);
+		mlx5_core_dbg(dev, "Async event for unknown resource 0x%x\n", rsn);
 		return NOTIFY_OK;
 	}
 
-- 
2.20.1

