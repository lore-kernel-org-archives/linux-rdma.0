Return-Path: <SRS0=rh+6=6L=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57910C7C860
	for <linux-rdma@archiver.kernel.org>; Mon, 27 Apr 2020 15:48:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3540720728
	for <linux-rdma@archiver.kernel.org>; Mon, 27 Apr 2020 15:48:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1588002528;
	bh=Q1vqSqYkpQpV+harc5cBAGYfH/UPJSoZou7OVe3GDDY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=pK5Wz3rTjdDxZvaYLV8KS1KITTB0dfA6BPwj621D0ybqCBLnGqmCTAJsGjSmGFe+w
	 4RymtGsTrGbkP9IVqntIKjlX05be17KKM6WaJc2qDRmx9OkaoMjPgNacHwDRDorPZi
	 1SmFI0IdeAHsip8YDogrIxGdRd/oVKi9I5YV5uyc=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728413AbgD0Psr (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Mon, 27 Apr 2020 11:48:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:57412 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728408AbgD0Psq (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Mon, 27 Apr 2020 11:48:46 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C6C5A20661;
        Mon, 27 Apr 2020 15:48:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588002526;
        bh=Q1vqSqYkpQpV+harc5cBAGYfH/UPJSoZou7OVe3GDDY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zuArC1HIKkuWB2WLuwjO3X42HnWZBB1ERvn74W3ca/gOWnw4BuFY4mGILcW5J9CHv
         ADZnlK49P7Qk5rTxBFhPD44hYR+s+HC2i+6dH4qUEkmPHMlSVGfLxWYr5lG2Eu6pWa
         h1iRFxgtbey5auGepCP3GKu0xc2d5FBN7cieqPu4=
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Cc:     Leon Romanovsky <leonro@mellanox.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Aharon Landau <aharonl@mellanox.com>,
        Eli Cohen <eli@mellanox.com>,
        Maor Gottlieb <maorg@mellanox.com>
Subject: [PATCH rdma-next v1 34/36] RDMA/mlx5: Remove redundant destroy QP call
Date:   Mon, 27 Apr 2020 18:46:34 +0300
Message-Id: <20200427154636.381474-35-leon@kernel.org>
X-Mailer: git-send-email 2.25.3
In-Reply-To: <20200427154636.381474-1-leon@kernel.org>
References: <20200427154636.381474-1-leon@kernel.org>
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
index 9ca742189281..d7983a951e8d 100644
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

