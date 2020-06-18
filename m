Return-Path: <SRS0=pTjR=77=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0BE09C433E0
	for <linux-rdma@archiver.kernel.org>; Thu, 18 Jun 2020 02:49:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D286B2098B
	for <linux-rdma@archiver.kernel.org>; Thu, 18 Jun 2020 02:49:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1592448597;
	bh=z3NrrAnXzMSia+WEXJZRjOlIbKvpqYiFsRlB/iLCqUA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=yh9BCBSU8KgJfU2uG8HHY0re7O9DQWirJ1R4yA3ewf2pfYWyprV+sGzY2Z7/Y0YiL
	 wJiS5gEZNhLZyOSWAVziDzl5EceVUFgNen9sgp7oEzWHeqVKRPrrXmjyDpy6xuPkA7
	 Kn+rqQK8XUAUpIH3km1e5Buzzf68JsuEzhBmooMs=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728212AbgFRCtw (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Wed, 17 Jun 2020 22:49:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:35874 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728177AbgFRBJa (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Wed, 17 Jun 2020 21:09:30 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B13D521D81;
        Thu, 18 Jun 2020 01:09:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592442569;
        bh=z3NrrAnXzMSia+WEXJZRjOlIbKvpqYiFsRlB/iLCqUA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cbwXCMqIeE5eebVZzeopU24J2Zx6MDc5YbOXv0P/43tXw5pPrGnRWT6wg2/wuAPAU
         PKJMjk/dYZ8H6jFglDhH2KK4RST9MyE5mr6JyBZXoH0FkATpyh1LbKey/0IATo8y9t
         XzQyCemUjnlOI9mWd5ZS3TOzHD9rqLcF68LQBr8c=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Aharon Landau <aharonl@mellanox.com>,
        Maor Gottlieb <maorg@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>, linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 5.7 063/388] RDMA/mlx5: Add init2init as a modify command
Date:   Wed, 17 Jun 2020 21:02:40 -0400
Message-Id: <20200618010805.600873-63-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200618010805.600873-1-sashal@kernel.org>
References: <20200618010805.600873-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

From: Aharon Landau <aharonl@mellanox.com>

[ Upstream commit 819f7427bafd494ef7ca4942ec6322db20722d7b ]

Missing INIT2INIT entry in the list of modify commands caused DEVX
applications to be unable to modify_qp for this transition state. Add the
MLX5_CMD_OP_INIT2INIT_QP opcode to the list of allowed DEVX opcodes.

Fixes: e662e14d801b ("IB/mlx5: Add DEVX support for modify and query commands")
Link: https://lore.kernel.org/r/20200513095550.211345-1-leon@kernel.org
Signed-off-by: Aharon Landau <aharonl@mellanox.com>
Reviewed-by: Maor Gottlieb <maorg@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/mlx5/devx.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/infiniband/hw/mlx5/devx.c b/drivers/infiniband/hw/mlx5/devx.c
index 46e1ab771f10..d0742823ab49 100644
--- a/drivers/infiniband/hw/mlx5/devx.c
+++ b/drivers/infiniband/hw/mlx5/devx.c
@@ -819,6 +819,7 @@ static bool devx_is_obj_modify_cmd(const void *in)
 	case MLX5_CMD_OP_SET_L2_TABLE_ENTRY:
 	case MLX5_CMD_OP_RST2INIT_QP:
 	case MLX5_CMD_OP_INIT2RTR_QP:
+	case MLX5_CMD_OP_INIT2INIT_QP:
 	case MLX5_CMD_OP_RTR2RTS_QP:
 	case MLX5_CMD_OP_RTS2RTS_QP:
 	case MLX5_CMD_OP_SQERR2RTS_QP:
-- 
2.25.1

