Return-Path: <SRS0=rh+6=6L=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0F77C54FCB
	for <linux-rdma@archiver.kernel.org>; Mon, 27 Apr 2020 15:47:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 85DF22064C
	for <linux-rdma@archiver.kernel.org>; Mon, 27 Apr 2020 15:47:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1588002422;
	bh=uVrWBamoc2S4hvtjD3T5Ou1pjarbe0V4kOjs6rnnvwQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=xumU884aBxjR80FXNfEyrpuCuNv6ZSVafeKoTlVHdQeEwi43ODkJAKJ8myzuYMgWL
	 0Y14acVNiZwrvtCOJVQmIqeMn+Omf6EMCxkDqAdKBYxaj6wTgmTkvgRsBiTYR2U1XC
	 Ngl9lrg9sy3oCxzSE4v0Lcp0bxQhgR3bSYFNCuVE=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728204AbgD0PrB (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Mon, 27 Apr 2020 11:47:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:53004 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727077AbgD0PrB (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Mon, 27 Apr 2020 11:47:01 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A514C20661;
        Mon, 27 Apr 2020 15:47:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588002421;
        bh=uVrWBamoc2S4hvtjD3T5Ou1pjarbe0V4kOjs6rnnvwQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GpNLFeESq2VLhr9cZsvOUskzfCUB2hktRvToo8a6ePohSpsFdz+V8bs3hjvEvaKnC
         4tAwtu3hnamU5GcTIhp1/9KosrVvSfrBvKikPMTyDhkT+GCmYgzaLmHwH+LsqUbMgX
         xS9pm7tbTQ8eEb2xSP+83/7H9+8cHSp9552+3pgc=
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Cc:     Leon Romanovsky <leonro@mellanox.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Aharon Landau <aharonl@mellanox.com>,
        Eli Cohen <eli@mellanox.com>,
        Maor Gottlieb <maorg@mellanox.com>
Subject: [PATCH rdma-next v1 05/36] RDMA/mlx5: Avoid setting redundant NULL for XRC QPs
Date:   Mon, 27 Apr 2020 18:46:05 +0300
Message-Id: <20200427154636.381474-6-leon@kernel.org>
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

There is no need to set NULL in recv_cq and send_cq, they are already
set to NULL by the IB/core logic.

Reviewed-by: Maor Gottlieb <maorg@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/infiniband/hw/mlx5/qp.c | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/qp.c b/drivers/infiniband/hw/mlx5/qp.c
index 07df470e0d58..86933a2023dc 100644
--- a/drivers/infiniband/hw/mlx5/qp.c
+++ b/drivers/infiniband/hw/mlx5/qp.c
@@ -2771,14 +2771,8 @@ struct ib_qp *mlx5_ib_create_qp(struct ib_pd *pd,
 		}
 	}
 
-	if (init_attr->qp_type == IB_QPT_XRC_TGT) {
-		init_attr->recv_cq = NULL;
+	if (init_attr->qp_type == IB_QPT_XRC_TGT)
 		xrcdn = to_mxrcd(init_attr->xrcd)->xrcdn;
-		init_attr->send_cq = NULL;
-	}
-
-	if (init_attr->qp_type == IB_QPT_XRC_INI)
-		init_attr->recv_cq = NULL;
 
 	err = create_qp_common(dev, pd, init_attr, udata, qp);
 	if (err) {
-- 
2.25.3

