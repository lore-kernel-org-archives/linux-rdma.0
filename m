Return-Path: <SRS0=HMeR=4C=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EAF81C2BA83
	for <linux-rdma@archiver.kernel.org>; Fri, 14 Feb 2020 14:30:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CBAC22168B
	for <linux-rdma@archiver.kernel.org>; Fri, 14 Feb 2020 14:30:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387398AbgBNOac (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Fri, 14 Feb 2020 09:30:32 -0500
Received: from relay12.mail.gandi.net ([217.70.178.232]:38455 "EHLO
        relay12.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729347AbgBNOab (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Fri, 14 Feb 2020 09:30:31 -0500
Received: from localhost (lfbn-lyo-1-1670-129.w90-65.abo.wanadoo.fr [90.65.102.129])
        (Authenticated sender: alexandre.belloni@bootlin.com)
        by relay12.mail.gandi.net (Postfix) with ESMTPSA id 82C6D20000A;
        Fri, 14 Feb 2020 14:30:29 +0000 (UTC)
From:   Alexandre Belloni <alexandre.belloni@bootlin.com>
To:     Boris Pismenny <borisp@mellanox.com>,
        Leon Romanovsky <leon@kernel.org>,
        Saeed Mahameed <saeedm@mellanox.com>
Cc:     Alexandre Belloni <alexandre.belloni@bootlin.com>,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] net/mlx5: fix spelling mistake "reserverd" -> "reserved"
Date:   Fri, 14 Feb 2020 15:30:01 +0100
Message-Id: <20200214143002.23140-1-alexandre.belloni@bootlin.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

The reserved member should be named reserved.

Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
---
 include/linux/mlx5/mlx5_ifc_fpga.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/mlx5/mlx5_ifc_fpga.h b/include/linux/mlx5/mlx5_ifc_fpga.h
index 37e065a80a43..07d77323f78a 100644
--- a/include/linux/mlx5/mlx5_ifc_fpga.h
+++ b/include/linux/mlx5/mlx5_ifc_fpga.h
@@ -608,7 +608,7 @@ struct mlx5_ifc_tls_cmd_bits {
 struct mlx5_ifc_tls_resp_bits {
 	u8         syndrome[0x20];
 	u8         stream_id[0x20];
-	u8         reserverd[0x40];
+	u8         reserved[0x40];
 };
 
 #define MLX5_TLS_COMMAND_SIZE (0x100)
-- 
2.24.1

