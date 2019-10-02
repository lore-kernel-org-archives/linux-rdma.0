Return-Path: <SRS0=/rP3=X3=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B581C352AA
	for <linux-rdma@archiver.kernel.org>; Wed,  2 Oct 2019 12:25:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 133B121A4A
	for <linux-rdma@archiver.kernel.org>; Wed,  2 Oct 2019 12:25:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1570019136;
	bh=Wd2ZqlbtGVBYphmLFX9XaYvx2NCUTPSX7E/zoQHRU1k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=a6posh5PNHugoUpGsuGEBHe11Xha6YzcVE+uD/ni5gllLYEIkV7i4M+Ox0CSu03Ua
	 VVLVhdb7MGPB9zARW3m2hECfIgcVIkrkcA4mX1sYU+hrFdS4BcW5cg4rjRumUBtpe3
	 qOqxLTEn3VPyr35AnmwRsEJPnZg2gWByLmIXs8/Y=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725935AbfJBMZf (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Wed, 2 Oct 2019 08:25:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:59892 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725875AbfJBMZf (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Wed, 2 Oct 2019 08:25:35 -0400
Received: from localhost (unknown [193.47.165.251])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5052D21920;
        Wed,  2 Oct 2019 12:25:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570019134;
        bh=Wd2ZqlbtGVBYphmLFX9XaYvx2NCUTPSX7E/zoQHRU1k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hLn4azveN9mLKgObLHuuWDCp3Krd73NxdZHbQ2USaoVAbfGyq3eqx2XlEjt4v9mhu
         Emrq6YH/192D8kGZxvcua5dd1BhhPTXBurTKbAdUmdtg5Ar/iE3xXSsT/UwM3e1SB2
         +aoZjv4QZUkGSDKg5XBxLnb+a1+lbpLicq2pNo9w=
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Cc:     Leon Romanovsky <leonro@mellanox.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Erez Alfasi <ereza@mellanox.com>,
        Parav Pandit <parav@mellanox.com>
Subject: [PATCH rdma-next 1/4] RDMA/mlx5: Group boolean parameters to take less space
Date:   Wed,  2 Oct 2019 15:25:14 +0300
Message-Id: <20191002122517.17721-2-leon@kernel.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191002122517.17721-1-leon@kernel.org>
References: <20191002122517.17721-1-leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro@mellanox.com>

Clean the code to store all boolean parameters inside one variable.

Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/infiniband/hw/mlx5/mlx5_ib.h | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
index 2ceaef3ea3fb..bf30d53d94dc 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -958,7 +958,10 @@ struct mlx5_ib_dev {
 	/* serialize update of capability mask
 	 */
 	struct mutex			cap_mask_mutex;
-	bool				ib_active;
+	u8				ib_active:1;
+	u8				fill_delay:1;
+	u8				is_rep:1;
+	u8				lag_active:1;
 	struct umr_common		umrc;
 	/* sync used page count stats
 	 */
@@ -967,7 +970,6 @@ struct mlx5_ib_dev {
 	struct timer_list		delay_timer;
 	/* Prevents soft lock on massive reg MRs */
 	struct mutex			slow_path_mutex;
-	int				fill_delay;
 	struct ib_odp_caps	odp_caps;
 	u64			odp_max_size;
 	struct mlx5_ib_pf_eq	odp_pf_eq;
@@ -988,8 +990,6 @@ struct mlx5_ib_dev {
 	struct mlx5_sq_bfreg	fp_bfreg;
 	struct mlx5_ib_delay_drop	delay_drop;
 	const struct mlx5_ib_profile	*profile;
-	bool			is_rep;
-	int				lag_active;
 
 	struct mlx5_ib_lb_state		lb;
 	u8			umr_fence;
-- 
2.20.1

