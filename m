Return-Path: <SRS0=7Twq=6H=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7FB8AC54FD0
	for <linux-rdma@archiver.kernel.org>; Thu, 23 Apr 2020 19:04:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 54C852076C
	for <linux-rdma@archiver.kernel.org>; Thu, 23 Apr 2020 19:04:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1587668651;
	bh=ArveDoHWT4lAz5+VyrcfSb31mwoUIfUC0s4dbYTbeWQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=frVKdzLKBW8IQSTd9o8ZM8KHkPpXXGTnVGRlEhAQynsvMnh5Uv2jCxncZJ29DEo1z
	 8XuvrA8DykNWZsi1fkMXAwovVBXu9qrs6eFixIKruKlWzSEQXY9ymufLpWxD5T+5Dx
	 NKP6syipCyZwxFZAxZLvShu8MJeysNfePHUGTAdY=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728243AbgDWTEK (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Thu, 23 Apr 2020 15:04:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:42256 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728200AbgDWTEK (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Thu, 23 Apr 2020 15:04:10 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1A53A20767;
        Thu, 23 Apr 2020 19:04:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587668649;
        bh=ArveDoHWT4lAz5+VyrcfSb31mwoUIfUC0s4dbYTbeWQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=V3RnUMyafxAGhHaLzhV1Rr9jxAWiPRhQF6fj5UX8gQyzKhzxPgHf/aCJvTIf3Eghv
         TNBoBJoMoRh1coY3qjsRLnlZaXx/52dz/ySVLVXDROGeIUTb6mpWqlBAifQklO1wA8
         dqI+DW7URF+DTFnFn0X4uE5huwinL4gpyevlGyRc=
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Cc:     Leon Romanovsky <leonro@mellanox.com>, linux-rdma@vger.kernel.org,
        Maor Gottlieb <maorg@mellanox.com>
Subject: [PATCH rdma-next 16/18] RDMA/mlx5: Remove redundant destroy QP call
Date:   Thu, 23 Apr 2020 22:03:01 +0300
Message-Id: <20200423190303.12856-17-leon@kernel.org>
X-Mailer: git-send-email 2.25.3
In-Reply-To: <20200423190303.12856-1-leon@kernel.org>
References: <20200423190303.12856-1-leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro@mellanox.com>

After major refactoring in create QP flow, it is no needed to call
to destroy QP in XRC_TGT flow.

Reviewed-by: Maor Gottlieb <maorg@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/infiniband/hw/mlx5/qp.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/qp.c b/drivers/infiniband/hw/mlx5/qp.c
index 8e94a824e29f..0612663868dd 100644
--- a/drivers/infiniband/hw/mlx5/qp.c
+++ b/drivers/infiniband/hw/mlx5/qp.c
@@ -1887,7 +1887,6 @@ static int create_xrc_tgt_qp(struct mlx5_ib_dev *dev, struct mlx5_ib_qp *qp,
 			     struct mlx5_create_qp_params *params)
 {
 	struct ib_qp_init_attr *attr = params->attr;
-	struct ib_udata *udata = params->udata;
 	u32 uidx = params->uidx;
 	struct mlx5_ib_resources *devr = &dev->devr;
 	int inlen = MLX5_ST_SZ_BYTES(create_qp_in);
@@ -1944,10 +1943,8 @@ static int create_xrc_tgt_qp(struct mlx5_ib_dev *dev, struct mlx5_ib_qp *qp,
 	base = &qp->trans_qp.base;
 	err = mlx5_core_create_qp(dev, &base->mqp, in, inlen);
 	kvfree(in);
-	if (err) {
-		destroy_qp(dev, qp, base, udata);
+	if (err)
 		return err;
-	}
 
 	base->container_mibqp = qp;
 	base->mqp.event = mlx5_ib_qp_event;
-- 
2.25.3

