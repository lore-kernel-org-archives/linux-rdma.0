Return-Path: <SRS0=V7/i=4P=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1FCAC4BA2D
	for <linux-rdma@archiver.kernel.org>; Thu, 27 Feb 2020 12:54:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B3A0924698
	for <linux-rdma@archiver.kernel.org>; Thu, 27 Feb 2020 12:54:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1582808052;
	bh=O089r3ypnzy/o9hOEMIp1idAy5PNLWAXmZu9IzZ32tY=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=fhlkDms7KypPKqxC0pu7s2eBUuaECW+J/oa7hlwK/rJV4G1g51hh+Qpggn1vB0P8f
	 mGKyZsSRMWvkHnZ8EpO26l6FbDj5PzILdNZMFYEOpicSx7YeW3/4iWuJ28I862tERx
	 ONbZzDkmaNoFoobe494kRakcrGRTjEHeqKuBphzE=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728986AbgB0MyM (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Thu, 27 Feb 2020 07:54:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:43800 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728977AbgB0MyL (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Thu, 27 Feb 2020 07:54:11 -0500
Received: from localhost (unknown [193.47.165.251])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BB00D24693;
        Thu, 27 Feb 2020 12:54:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582808051;
        bh=O089r3ypnzy/o9hOEMIp1idAy5PNLWAXmZu9IzZ32tY=;
        h=From:To:Cc:Subject:Date:From;
        b=KwFBfqoSIOfphHXjJ3GQfVCw4pispnLaS+gcyH00b8KXEcYd99mYZtJ9uEO4N8Bpa
         8TeROwpsKSJqaHhSlAFIyUMT7KbBXPQxPXRQSXvnDoBrdiGx2mDPMS6yzxTL0X1zKG
         ms3vmAm5dOUHhOvfKIEQ9DTjR+YQjzYdFLiAvESo=
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Cc:     Parav Pandit <parav@mellanox.com>, linux-rdma@vger.kernel.org,
        Mark Bloch <markb@mellanox.com>
Subject: [PATCH rdma-next] IB/mlx5: Fix missing congestion control debugfs on rep rdma device
Date:   Thu, 27 Feb 2020 14:54:07 +0200
Message-Id: <20200227125407.99803-1-leon@kernel.org>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

From: Parav Pandit <parav@mellanox.com>

Cited commit missed to include low level congestion control
related debugfs stage initialization.
This resulted in missing debugfs entries for cc_params of
a RDMA device.

Add them back.

Fixes: b5ca15ad7e61 ("IB/mlx5: Add proper representors support")
Signed-off-by: Parav Pandit <parav@mellanox.com>
Reviewed-by: Mark Bloch <markb@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/infiniband/hw/mlx5/main.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index ec8ed90d2b60..f5d42985113c 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -7080,6 +7080,9 @@ const struct mlx5_ib_profile raw_eth_profile = {
 	STAGE_CREATE(MLX5_IB_STAGE_COUNTERS,
 		     mlx5_ib_stage_counters_init,
 		     mlx5_ib_stage_counters_cleanup),
+	STAGE_CREATE(MLX5_IB_STAGE_CONG_DEBUGFS,
+		     mlx5_ib_stage_cong_debugfs_init,
+		     mlx5_ib_stage_cong_debugfs_cleanup),
 	STAGE_CREATE(MLX5_IB_STAGE_UAR,
 		     mlx5_ib_stage_uar_init,
 		     mlx5_ib_stage_uar_cleanup),
--
2.24.1

