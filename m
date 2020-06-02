Return-Path: <SRS0=kW50=7P=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E41FC433DF
	for <linux-rdma@archiver.kernel.org>; Tue,  2 Jun 2020 12:56:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7481E206E2
	for <linux-rdma@archiver.kernel.org>; Tue,  2 Jun 2020 12:56:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1591102566;
	bh=unVZinT2gOU7hsvGVZzqxKhEy6rv8KylXMvMylvWtn8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=ZAgwNWaK7yvgH6S51l2Zywk0dIHOHPl1v/n6l0QB0PFmExWgQrEAaKbFDb/s3aioT
	 0zPW8HUnH8KM5MkGjaudNVyDlyU3sfWeNMcwJ5856xel5+afKoxaSwDF3WH6YpJVtZ
	 ke+RLAv8lze4rMJGKrzZsNe9m4uSElCOFOFlAkxc=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726185AbgFBM4F (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Tue, 2 Jun 2020 08:56:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:50432 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726139AbgFBM4F (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Tue, 2 Jun 2020 08:56:05 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A040620663;
        Tue,  2 Jun 2020 12:56:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591102565;
        bh=unVZinT2gOU7hsvGVZzqxKhEy6rv8KylXMvMylvWtn8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=snqXsQqBm+XLfkVmClAMt5X7Y5RmlvI7ClfoH5C6VthUw0/FKH0wRtAytsBcsygyb
         FG6TyW4wgMCozdZwE7u+TCYsxnJg2TAv1LArnxYI26gFdlH49pUL6zk0MhfXQDnhAm
         WDhu5f83otchg6OatfvKyqSOaMVcXA/5QfMoHi/0=
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Cc:     Leon Romanovsky <leonro@mellanox.com>, linux-rdma@vger.kernel.org,
        Mark Zhang <markz@mellanox.com>
Subject: [PATCH rdma-next 2/3] RDMA/mlx5: Don't rely on FW to set zeros in ECE response
Date:   Tue,  2 Jun 2020 15:55:47 +0300
Message-Id: <20200602125548.172654-3-leon@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200602125548.172654-1-leon@kernel.org>
References: <20200602125548.172654-1-leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro@mellanox.com>

The FW returns zeros in case feature is not enabled, but it is better
to have the capability check and ensure that returned result is cleared.

Fixes: 3e09a427ae7a ("RDMA/mlx5: Get ECE options from FW during create QP")
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/infiniband/hw/mlx5/qp.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/qp.c b/drivers/infiniband/hw/mlx5/qp.c
index e8427231cf15..494e305cf761 100644
--- a/drivers/infiniband/hw/mlx5/qp.c
+++ b/drivers/infiniband/hw/mlx5/qp.c
@@ -1906,7 +1906,8 @@ static int create_xrc_tgt_qp(struct mlx5_ib_dev *dev, struct mlx5_ib_qp *qp,
 
 	base->container_mibqp = qp;
 	base->mqp.event = mlx5_ib_qp_event;
-	params->resp.ece_options = MLX5_GET(create_qp_out, out, ece);
+	if (MLX5_CAP_GEN(mdev, ece_support))
+		params->resp.ece_options = MLX5_GET(create_qp_out, out, ece);
 
 	spin_lock_irqsave(&dev->reset_flow_resource_lock, flags);
 	list_add_tail(&qp->qps_list, &dev->qp_list);
@@ -2082,7 +2083,8 @@ static int create_user_qp(struct mlx5_ib_dev *dev, struct ib_pd *pd,
 
 	base->container_mibqp = qp;
 	base->mqp.event = mlx5_ib_qp_event;
-	params->resp.ece_options = MLX5_GET(create_qp_out, out, ece);
+	if (MLX5_CAP_GEN(mdev, ece_support))
+		params->resp.ece_options = MLX5_GET(create_qp_out, out, ece);
 
 	get_cqs(qp->type, init_attr->send_cq, init_attr->recv_cq,
 		&send_cq, &recv_cq);
-- 
2.26.2

