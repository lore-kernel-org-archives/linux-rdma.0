Return-Path: <SRS0=u98Z=43=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2DB4C10F27
	for <linux-rdma@archiver.kernel.org>; Tue, 10 Mar 2020 07:57:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A0B562467C
	for <linux-rdma@archiver.kernel.org>; Tue, 10 Mar 2020 07:57:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1583827031;
	bh=QwkGaezB0q4S4ZRUMlf9yDk5Ni2Mh/CJnHv+3+tp09w=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=PXuOebxtwqN80yTzd3UEMUfyq3nJY5O59SmaLZmR9fPL73LProBgc2tq1tNCxEJrc
	 M1oQCEJ/S1N7RHrKbFX1E2o0faxwCv7D0SMCLeX9rlegsnK36HomlLhtUXFFUNPcqS
	 lnBwIzj7prKeme+nG6hVMxvzOidO/awqDpNLMdN4=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726220AbgCJH5L (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Tue, 10 Mar 2020 03:57:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:40060 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725919AbgCJH5L (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Tue, 10 Mar 2020 03:57:11 -0400
Received: from localhost (unknown [193.47.165.251])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E523624673;
        Tue, 10 Mar 2020 07:57:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583827030;
        bh=QwkGaezB0q4S4ZRUMlf9yDk5Ni2Mh/CJnHv+3+tp09w=;
        h=From:To:Cc:Subject:Date:From;
        b=ihQtWuTRMQMrk+59dQ/Z0chzAH7XSOnE77nQEErEASW8XNrrovB4yTT2Pdzw39hN/
         K/Iv4f8wvWDmjn0jkb16QB9UYJYe83NbP/fz/UJuuZ/+NmFs0qesD4Fic9D06aG3hm
         xkushBmLflSWsUnP6SxCOq9+KUVYHZlBGmsoV1Ok=
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Cc:     Erez Shitrit <erezsh@mellanox.com>,
        Alex Vesker <valex@mellanox.com>,
        Ariel Levkovich <lariel@mellanox.com>,
        linux-rdma@vger.kernel.org,
        Yevgeny Kliteynik <kliteyn@mellanox.com>
Subject: [PATCH rdma-next] RDMA/mlx5: Remove duplicate definitions of SW_ICM macros
Date:   Tue, 10 Mar 2020 09:57:06 +0200
Message-Id: <20200310075706.238592-1-leon@kernel.org>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

From: Erez Shitrit <erezsh@mellanox.com>

Those macros are already defined in include/linux/mlx5/driver.h,
so delete their duplicate variants.

Signed-off-by: Ariel Levkovich <lariel@mellanox.com>
Signed-off-by: Yevgeny Kliteynik <kliteyn@mellanox.com>
Signed-off-by: Erez Shitrit <erezsh@mellanox.com>
Reviewed-by: Alex Vesker <valex@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/infiniband/hw/mlx5/mlx5_ib.h | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
index aae88311e714..8eb9b5e29365 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -126,10 +126,6 @@ enum mlx5_ib_mmap_type {
 	MLX5_IB_MMAP_TYPE_VAR = 2,
 };
 
-#define MLX5_LOG_SW_ICM_BLOCK_SIZE(dev)                                        \
-	(MLX5_CAP_DEV_MEM(dev, log_sw_icm_alloc_granularity))
-#define MLX5_SW_ICM_BLOCK_SIZE(dev) (1 << MLX5_LOG_SW_ICM_BLOCK_SIZE(dev))
-
 struct mlx5_ib_ucontext {
 	struct ib_ucontext	ibucontext;
 	struct list_head	db_page_list;
-- 
2.24.1

