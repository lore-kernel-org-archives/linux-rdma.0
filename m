Return-Path: <linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED0DEC433F5
	for <linux-rdma@archiver.kernel.org>; Tue, 14 Sep 2021 23:11:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D58BF60F3A
	for <linux-rdma@archiver.kernel.org>; Tue, 14 Sep 2021 23:11:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235806AbhINXMy (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Tue, 14 Sep 2021 19:12:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:46772 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235845AbhINXMy (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Tue, 14 Sep 2021 19:12:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 447BD6008E;
        Tue, 14 Sep 2021 23:11:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631661096;
        bh=jiouLZz/Q+SP5VeEmlrPZJs67Kq3f6zq2uFUufcpsU8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JwjftfBlPoLg5cBH8NiXntfUwHnW5+ZvFkEg2txYpmexzC15yrI2ktUbX8UdIdRWi
         27cQhtoGNapZmLs2wY8gVby7DrCA31V/l8P6W5pPI8CIObCb9wsH5kotS/blda86E1
         Op99CayZEarLYVSWS8q76nE0GDYbupHD8kDynTkx166nwKsKjKk1Kt1kX30F2xPha3
         jOEq/Qyf5sQre7Iz76e3JbXEZxVcNnpKSBQERKJpsasiVFN62ygTOqgPn3jMEMEDkP
         yxxd9XDX0Fa3JnQ71c08rU0prV3sG7OJJveXZPVbe/GDkPso+ac0zL5vUrY7W7sQ3n
         dOCl6i9Dr1/Mw==
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Cc:     Meir Lichtinger <meirl@nvidia.com>, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        Saeed Mahameed <saeedm@nvidia.com>,
        Yishai Hadas <yishaih@nvidia.com>
Subject: [PATCH mlx5-next 1/2] net/mlx5: Add uid field to UAR allocation structures
Date:   Wed, 15 Sep 2021 02:11:22 +0300
Message-Id: <036da1f928405ad2786f1a0086f565353873edbf.1631660943.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1631660943.git.leonro@nvidia.com>
References: <cover.1631660943.git.leonro@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

From: Meir Lichtinger <meirl@nvidia.com>

Add uid field to mlx5_ifc_alloc_uar_in_bits and
mlx5_ifc_dealloc_uar_out_bits structs.

This field will be used by FW to manage UAR according to uid.

Signed-off-by: Meir Lichtinger <meirl@nvidia.com>
Reviewed-by: Yishai Hadas <yishaih@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 include/linux/mlx5/mlx5_ifc.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index 52e5baad3b93..4a7e6914ed9b 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -7573,7 +7573,7 @@ struct mlx5_ifc_dealloc_uar_out_bits {
 
 struct mlx5_ifc_dealloc_uar_in_bits {
 	u8         opcode[0x10];
-	u8         reserved_at_10[0x10];
+	u8         uid[0x10];
 
 	u8         reserved_at_20[0x10];
 	u8         op_mod[0x10];
@@ -8420,7 +8420,7 @@ struct mlx5_ifc_alloc_uar_out_bits {
 
 struct mlx5_ifc_alloc_uar_in_bits {
 	u8         opcode[0x10];
-	u8         reserved_at_10[0x10];
+	u8         uid[0x10];
 
 	u8         reserved_at_20[0x10];
 	u8         op_mod[0x10];
-- 
2.31.1

