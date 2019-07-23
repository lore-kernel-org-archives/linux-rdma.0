Return-Path: <SRS0=t5r7=VU=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13057C76190
	for <linux-rdma@archiver.kernel.org>; Tue, 23 Jul 2019 06:58:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D60AD21901
	for <linux-rdma@archiver.kernel.org>; Tue, 23 Jul 2019 06:58:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1563865086;
	bh=Bq+4n4NufWFru7XzsdDvpaKZaFbljkkOYwmoL3kLBaw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=UUTZrtrdcAWhkqLyWGN4WiEX2QL8oEC2iZ0v24C27LvjQ/A6wRlhsqeq/I6LPhRwl
	 Q23uw5MqH24bBvEiLc8AZO6A1OX6VvsUkC6xUNmKX+4AnbIxz3Y6QwPbw8LTRd5OOY
	 5Wze9ROH54R6zoVLcUeXNe8QKbKfra32p08bSakY=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732523AbfGWG6G (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Tue, 23 Jul 2019 02:58:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:42642 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731708AbfGWG6G (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Tue, 23 Jul 2019 02:58:06 -0400
Received: from localhost (unknown [193.47.165.251])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5C5E420644;
        Tue, 23 Jul 2019 06:58:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563865085;
        bh=Bq+4n4NufWFru7XzsdDvpaKZaFbljkkOYwmoL3kLBaw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aFwpj4PMywTak4mU8BkRAuSnROFVhmkU7Pj1tcPLqVYbQYuJF4gwt52mpnVYUR18v
         t9dDVnUu84c4HvEw+7sxdSR07Vq24UNYqurUnZh9fDOf+84N67xipBf022RI06uFCL
         cWzqUtsfW51vOtdNpckYuHTd91xTHKIFAzr7HS9I=
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
Subject: [PATCH rdma-rc 05/10] IB/mlx5: Fix clean_mr() to work in the expected order
Date:   Tue, 23 Jul 2019 09:57:28 +0300
Message-Id: <20190723065733.4899-6-leon@kernel.org>
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

Any dma map underlying the MR should only be freed once the MR is fenced
at the hardware.

As of the above we first destroy the MKEY and just after that can safely
call to dma_unmap_single().

Cc: <stable@vger.kernel.org> # 4.3
Fixes: 8a187ee52b04 ("IB/mlx5: Support the new memory registration API")
Signed-off-by: Yishai Hadas <yishaih@mellanox.com>
Reviewed-by: Artemy Kovalyov <artemyko@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/infiniband/hw/mlx5/mr.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/mr.c b/drivers/infiniband/hw/mlx5/mr.c
index 7274a9b9df58..2c77456f359f 100644
--- a/drivers/infiniband/hw/mlx5/mr.c
+++ b/drivers/infiniband/hw/mlx5/mr.c
@@ -1582,10 +1582,10 @@ static void clean_mr(struct mlx5_ib_dev *dev, struct mlx5_ib_mr *mr)
 		mr->sig = NULL;
 	}

-	mlx5_free_priv_descs(mr);
-
-	if (!allocated_from_cache)
+	if (!allocated_from_cache) {
 		destroy_mkey(dev, mr);
+		mlx5_free_priv_descs(mr);
+	}
 }

 static void dereg_mr(struct mlx5_ib_dev *dev, struct mlx5_ib_mr *mr)
--
2.20.1

