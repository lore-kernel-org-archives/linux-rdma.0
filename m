Return-Path: <SRS0=nHGB=X7=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49F4BC4360C
	for <linux-rdma@archiver.kernel.org>; Sun,  6 Oct 2019 16:00:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1D88120862
	for <linux-rdma@archiver.kernel.org>; Sun,  6 Oct 2019 16:00:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1570377609;
	bh=WNz1a8CGkE/BgbIBV0IQjx7q1KkYuYpJiLnoaB6fPdU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=W1505OD0wksKvf1fuGzeR/TY/t/GXbhLSUCfB2BKzkNDMhwz0+u5oaEM+IaXfL6Cz
	 OesN+fwVrCGk6Nt/xD6JczVQuyxd0/BiX2gC+dL3HZ/g9PKV47bK0fv2sxzW1Fz/a9
	 sTMCHzkPsjeU219dfK6PaaUyWgHGUZZyvPnNWHME=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726474AbfJFQAI (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Sun, 6 Oct 2019 12:00:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:35008 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726349AbfJFQAI (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Sun, 6 Oct 2019 12:00:08 -0400
Received: from localhost (unknown [77.137.89.37])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A4DFA2084B;
        Sun,  6 Oct 2019 16:00:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570377607;
        bh=WNz1a8CGkE/BgbIBV0IQjx7q1KkYuYpJiLnoaB6fPdU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2GwLl6BYMQAXCYXBa8jIX+8bhqOCGDvNgLhtVeVvOdUixZ3HrrVWRbaaS6qw7t46Q
         OxLl4CbmaI8iSaNgMO/7nlN9GHaZmBPE1g6enJLKN5r7bWhpaqm+og7SWJQgvvHVJm
         Wi2wEMGA2AUg+L6gA8G8D2F0iDIAtT5uHVM0rZtM=
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Cc:     Leon Romanovsky <leonro@mellanox.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Or Gerlitz <ogerlitz@mellanox.com>,
        Yamin Friedman <yaminf@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        linux-netdev <netdev@vger.kernel.org>
Subject: [PATCH mlx5-next 1/3] net/mlx5: Expose optimal performance scatter entries capability
Date:   Sun,  6 Oct 2019 18:59:53 +0300
Message-Id: <20191006155955.31445-2-leon@kernel.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191006155955.31445-1-leon@kernel.org>
References: <20191006155955.31445-1-leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

From: Yamin Friedman <yaminf@mellanox.com>

Expose maximum scatter entries per RDMA READ for optimal performance.

Signed-off-by: Yamin Friedman <yaminf@mellanox.com>
Reviewed-by: Or Gerlitz <ogerlitz@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 include/linux/mlx5/mlx5_ifc.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index 138c50d5a353..c0bfb1d90dd2 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -1153,7 +1153,7 @@ struct mlx5_ifc_cmd_hca_cap_bits {
 	u8         log_max_srq[0x5];
 	u8         reserved_at_b0[0x10];
 
-	u8         reserved_at_c0[0x8];
+	u8         max_sgl_for_optimized_performance[0x8];
 	u8         log_max_cq_sz[0x8];
 	u8         reserved_at_d0[0xb];
 	u8         log_max_cq[0x5];
-- 
2.20.1

