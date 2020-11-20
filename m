Return-Path: <linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B472FC83012
	for <linux-rdma@archiver.kernel.org>; Fri, 20 Nov 2020 23:04:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 71EE12408E
	for <linux-rdma@archiver.kernel.org>; Fri, 20 Nov 2020 23:04:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=nvidia.com header.i=@nvidia.com header.b="EBbGZowa"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726739AbgKTXEG (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Fri, 20 Nov 2020 18:04:06 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:12659 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727367AbgKTXEF (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Fri, 20 Nov 2020 18:04:05 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fb84b690002>; Fri, 20 Nov 2020 15:04:09 -0800
Received: from sx1.mtl.com (172.20.13.39) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 20 Nov
 2020 23:03:59 +0000
From:   Saeed Mahameed <saeedm@nvidia.com>
To:     Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leonro@mellanox.com>
CC:     <netdev@vger.kernel.org>, <linux-rdma@vger.kernel.org>,
        Parav Pandit <parav@nvidia.com>
Subject: [PATCH mlx5-next 06/16] net/mlx5: Avoid exposing driver internal command helpers
Date:   Fri, 20 Nov 2020 15:03:29 -0800
Message-ID: <20201120230339.651609-7-saeedm@nvidia.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201120230339.651609-1-saeedm@nvidia.com>
References: <20201120230339.651609-1-saeedm@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-Originating-IP: [172.20.13.39]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1605913449; bh=yc/5TXOvPWPrPN0DnVMdQ2jQoOJIp4xmeY34kecALGE=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
         References:MIME-Version:Content-Transfer-Encoding:Content-Type:
         X-Originating-IP:X-ClientProxiedBy;
        b=EBbGZowa+xCBPSWRjGrDCFqoZhVOS13eYdKZ+r7v9halG70ciFETVcFtox080wfrj
         ywCrTaZuAEGiOAbt6lrMfbuWnQO3QjGkEgOFRQQk3+fdyqf2cC5956isB1DybXnzfY
         uP1VRpmqfnUktX7LnWsSErAueF+moCg+mmbB5Cj29jxSmV6YQm1EBWv8t2s4pLnOyN
         PSmRN8Cc3L0+xywEOT7O6rPJrrEs9EKv19PoaYY+tqDvOQvmP/jWS+mM5BD8TiBEDC
         eRXvvOzi+dXZC7fN6GTpNrzIrqnhzfk9C/RmUQHDXP2JlNcKd34Uby7mRXCxwYcZof
         jneFOgaFTCOBw==
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

From: Parav Pandit <parav@nvidia.com>

mlx5 command init and cleanup routines are internal to mlx5_core driver.
Hence, avoid exporting them and move their definition to mlx5_core
driver's internal file mlx5_core.h

Signed-off-by: Parav Pandit <parav@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/cmd.c       | 3 ---
 drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h | 4 ++++
 include/linux/mlx5/driver.h                         | 4 ----
 3 files changed, 4 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/cmd.c b/drivers/net/et=
hernet/mellanox/mlx5/core/cmd.c
index e49387dbef98..50c7b9ee80c3 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
@@ -2142,7 +2142,6 @@ int mlx5_cmd_init(struct mlx5_core_dev *dev)
 	kvfree(cmd->stats);
 	return err;
 }
-EXPORT_SYMBOL(mlx5_cmd_init);
=20
 void mlx5_cmd_cleanup(struct mlx5_core_dev *dev)
 {
@@ -2155,11 +2154,9 @@ void mlx5_cmd_cleanup(struct mlx5_core_dev *dev)
 	dma_pool_destroy(cmd->pool);
 	kvfree(cmd->stats);
 }
-EXPORT_SYMBOL(mlx5_cmd_cleanup);
=20
 void mlx5_cmd_set_state(struct mlx5_core_dev *dev,
 			enum mlx5_cmdif_state cmdif_state)
 {
 	dev->cmd.state =3D cmdif_state;
 }
-EXPORT_SYMBOL(mlx5_cmd_set_state);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h b/drivers/=
net/ethernet/mellanox/mlx5/core/mlx5_core.h
index 8cec85ab419d..9d00efa9e6bc 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h
@@ -122,6 +122,10 @@ enum mlx5_semaphore_space_address {
=20
 int mlx5_query_hca_caps(struct mlx5_core_dev *dev);
 int mlx5_query_board_id(struct mlx5_core_dev *dev);
+int mlx5_cmd_init(struct mlx5_core_dev *dev);
+void mlx5_cmd_cleanup(struct mlx5_core_dev *dev);
+void mlx5_cmd_set_state(struct mlx5_core_dev *dev,
+			enum mlx5_cmdif_state cmdif_state);
 int mlx5_cmd_init_hca(struct mlx5_core_dev *dev, uint32_t *sw_owner_id);
 int mlx5_cmd_teardown_hca(struct mlx5_core_dev *dev);
 int mlx5_cmd_force_teardown_hca(struct mlx5_core_dev *dev);
diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
index add85094f9a5..5e84b1d53650 100644
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -888,10 +888,6 @@ enum {
 	CMD_ALLOWED_OPCODE_ALL,
 };
=20
-int mlx5_cmd_init(struct mlx5_core_dev *dev);
-void mlx5_cmd_cleanup(struct mlx5_core_dev *dev);
-void mlx5_cmd_set_state(struct mlx5_core_dev *dev,
-			enum mlx5_cmdif_state cmdif_state);
 void mlx5_cmd_use_events(struct mlx5_core_dev *dev);
 void mlx5_cmd_use_polling(struct mlx5_core_dev *dev);
 void mlx5_cmd_allowed_opcode(struct mlx5_core_dev *dev, u16 opcode);
--=20
2.26.2

