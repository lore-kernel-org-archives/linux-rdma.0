Return-Path: <SRS0=S6Iu=3E=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A33A3C33CB1
	for <linux-rdma@archiver.kernel.org>; Wed, 15 Jan 2020 12:44:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7651C222C3
	for <linux-rdma@archiver.kernel.org>; Wed, 15 Jan 2020 12:44:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1579092242;
	bh=Zf0+GJQjYf6AXgHmCibOV3TXV9ObrfJdzXmLmxSuYbs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=uXuVUQhTeF8+tnooTSFteCt4xZMmdm5TaDWT4fXBH5EzywKkLT7u9xVwyYyuYdkso
	 SAKveihbmq2mXY8ZEUdFr+aMA8ePA5zABQZryfmgPUsrux8v20uyXl9XafWcV7uzis
	 Fn88jvF5yHePtiIgKHji9UTevUL9GRDtfocSmOxI=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729098AbgAOMoB (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Wed, 15 Jan 2020 07:44:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:57376 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725999AbgAOMoB (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Wed, 15 Jan 2020 07:44:01 -0500
Received: from localhost (unknown [193.47.165.251])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 67BDE2467D;
        Wed, 15 Jan 2020 12:44:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579092241;
        bh=Zf0+GJQjYf6AXgHmCibOV3TXV9ObrfJdzXmLmxSuYbs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CBxu2CTNIPuAWQvnUuf6MyAmjEEx31XrI8sGLlwCmwglUgmbuHmq6B0W0hTGgLwZ6
         ecLRCteZTXfh4dhRsWct9UkKw7/6q6epAWbGu6tWIhtXmLaqt4eSn9GtS1c4+UY4ZZ
         V7E1SHkXSxazF6XDygSMsAy2+whaCmiDK57tYLTQ=
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        "David S . Miller" <davem@davemloft.net>,
        Santosh Shilimkar <santosh.shilimkar@oracle.com>
Cc:     Leon Romanovsky <leonro@mellanox.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Hans Westgaard Ry <hans.westgaard.ry@oracle.com>,
        Moni Shoua <monis@mellanox.com>,
        linux-netdev <netdev@vger.kernel.org>
Subject: [PATCH mlx5-next 06/10] IB/mlx5: Mask out unsupported ODP capabilities for kernel QPs
Date:   Wed, 15 Jan 2020 14:43:36 +0200
Message-Id: <20200115124340.79108-7-leon@kernel.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200115124340.79108-1-leon@kernel.org>
References: <20200115124340.79108-1-leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

From: Moni Shoua <monis@mellanox.com>

The ODP handler for WQEs in RQ or SRQ is not implented for kernel QPs.
Therefore don't report support in these if query comes from a kernel user.

Signed-off-by: Moni Shoua <monis@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/infiniband/hw/mlx5/main.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index e34531d5c806..01fc09f3ddd3 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -1015,6 +1015,23 @@ static int mlx5_ib_query_device(struct ib_device *ibdev,
 		if (dev->odp_caps.general_caps & IB_ODP_SUPPORT)
 			props->device_cap_flags |= IB_DEVICE_ON_DEMAND_PAGING;
 		props->odp_caps = dev->odp_caps;
+		if (!uhw) {
+			/* ODP for kernel QPs is not implemented for receive
+			 * WQEs and SRQ WQEs
+			 */
+			props->odp_caps.per_transport_caps.rc_odp_caps &=
+				~(IB_ODP_SUPPORT_READ |
+				  IB_ODP_SUPPORT_SRQ_RECV);
+			props->odp_caps.per_transport_caps.uc_odp_caps &=
+				~(IB_ODP_SUPPORT_READ |
+				  IB_ODP_SUPPORT_SRQ_RECV);
+			props->odp_caps.per_transport_caps.ud_odp_caps &=
+				~(IB_ODP_SUPPORT_READ |
+				  IB_ODP_SUPPORT_SRQ_RECV);
+			props->odp_caps.per_transport_caps.xrc_odp_caps &=
+				~(IB_ODP_SUPPORT_READ |
+				  IB_ODP_SUPPORT_SRQ_RECV);
+		}
 	}

 	if (MLX5_CAP_GEN(mdev, cd))
--
2.20.1

