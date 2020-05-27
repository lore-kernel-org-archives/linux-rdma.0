Return-Path: <SRS0=0PZL=7J=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE412C433E2
	for <linux-rdma@archiver.kernel.org>; Wed, 27 May 2020 13:54:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C8AF6207D8
	for <linux-rdma@archiver.kernel.org>; Wed, 27 May 2020 13:54:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1590587697;
	bh=2oGe1j9FCrx6ilF7A6SkipjO7u9D5c6ZnWuFMapH/wo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=yOYtVkpL/S29ZlhvyaLnPeV8b2SJnLeKBi8+hWEgdryvf/Wqel4jpXAiF62qoeBgJ
	 4vmEfgjLJrv6hkHCZiZ6g0IqgJXZz/npnCuG0TIp9kq1iHoO0UdVU3vzAtLhUsdUWC
	 Ug6nEnb/hB5XYZXPDARqO9pe86kzYS9zWc2rWFR8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388983AbgE0Ny5 (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Wed, 27 May 2020 09:54:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:51070 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388875AbgE0Ny4 (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Wed, 27 May 2020 09:54:56 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 871B7208E4;
        Wed, 27 May 2020 13:54:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590587696;
        bh=2oGe1j9FCrx6ilF7A6SkipjO7u9D5c6ZnWuFMapH/wo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xXjRDI7Vz8AIHKDNGYWQ+/PJylN0U/Mf9QOMUABgEDfpqga3ASSY6UG9i33WOFgSE
         x5qwZACzJkRS9NQo6SQAIAdjynC6EPfdr5yomk0o+YUzLW1T3Udlk2Mns/25PUNHix
         nt9PxWtfKTw0c+K+Eq428ArEoeTZryIRJ5hvBvQg=
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Cc:     Maor Gottlieb <maorg@mellanox.com>, linux-rdma@vger.kernel.org
Subject: [PATCH rdma-next v1 11/11] RDMA/mlx5: Add support to get MR resource in RAW format
Date:   Wed, 27 May 2020 16:54:08 +0300
Message-Id: <20200527135408.480878-12-leon@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200527135408.480878-1-leon@kernel.org>
References: <20200527135408.480878-1-leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

From: Maor Gottlieb <maorg@mellanox.com>

Add support to get MR (mkey) resource dump in RAW format.

Signed-off-by: Maor Gottlieb <maorg@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/infiniband/hw/mlx5/restrack.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/mlx5/restrack.c b/drivers/infiniband/hw/mlx5/restrack.c
index 9e1389b8dd9f..834886536127 100644
--- a/drivers/infiniband/hw/mlx5/restrack.c
+++ b/drivers/infiniband/hw/mlx5/restrack.c
@@ -116,7 +116,8 @@ int mlx5_ib_fill_res_mr_entry(struct sk_buff *msg,
 	struct nlattr *table_attr;
 
 	if (raw)
-		return -EOPNOTSUPP;
+		return fill_res_raw(msg, mr->dev, MLX5_SGMT_TYPE_PRM_QUERY_MKEY,
+				    mlx5_mkey_to_idx(mr->mmkey.key));
 
 	if (!(mr->access_flags & IB_ACCESS_ON_DEMAND))
 		return 0;
-- 
2.26.2

