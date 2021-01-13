Return-Path: <linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A00D6C433E6
	for <linux-rdma@archiver.kernel.org>; Wed, 13 Jan 2021 12:18:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 574FD233F9
	for <linux-rdma@archiver.kernel.org>; Wed, 13 Jan 2021 12:18:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727670AbhAMMSC (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Wed, 13 Jan 2021 07:18:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:55116 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727669AbhAMMSB (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Wed, 13 Jan 2021 07:18:01 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4F1F4233FA;
        Wed, 13 Jan 2021 12:17:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610540241;
        bh=sORMEYekq9FAugpNkYH85VRw6nWTEkNd20YQV1TOO9E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WEutGyx/ViQw+kB4NEYJLMb9oI1JWP/UN75Id2493j7Fw8sgt6hsgR43JqbqC111v
         sQVvNHE1CoKuzYE6R/zp6EusdP5Tfoe7ROeaTroKxhHJFf8B92IFM7bEwtceRvLBnp
         Vzxj50hIL+kc9SRPxSKBO1ea7c3taR9/1CQnVIYefkb6DWLTqE25wheNfcTAPMGA1z
         d7xrjQ3DZDWr0GURkHdg1OSswcAuY3QBPEjK+zXQl2zkrObqtiPyvdBqCmhWcmpYtR
         xO8tGpqDesX41TPvac23ctXjDZVTZ20WbQdFwtncqTQWxlt2B64Zku+i4PLP1PB1do
         lxo9IVoQETcYg==
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Cc:     Parav Pandit <parav@nvidia.com>,
        Aharon Landau <aharonl@nvidia.com>, linux-rdma@vger.kernel.org,
        Maor Gottlieb <maorg@mellanox.com>,
        Mark Bloch <mbloch@nvidia.com>
Subject: [PATCH rdma-next 4/5] IB/mlx5: Make function static
Date:   Wed, 13 Jan 2021 14:17:02 +0200
Message-Id: <20210113121703.559778-5-leon@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210113121703.559778-1-leon@kernel.org>
References: <20210113121703.559778-1-leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

From: Parav Pandit <parav@nvidia.com>

mlx5_query_mad_ifc_smp_attr_node_info() is internal to mad.c
Hence, make it static.

Signed-off-by: Parav Pandit <parav@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/infiniband/hw/mlx5/mad.c     | 4 ++--
 drivers/infiniband/hw/mlx5/mlx5_ib.h | 2 --
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/mad.c b/drivers/infiniband/hw/mlx5/mad.c
index 9bb9bb058932..53dec6063245 100644
--- a/drivers/infiniband/hw/mlx5/mad.c
+++ b/drivers/infiniband/hw/mlx5/mad.c
@@ -308,8 +308,8 @@ int mlx5_query_ext_port_caps(struct mlx5_ib_dev *dev, u8 port)
 	return err;
 }

-int mlx5_query_mad_ifc_smp_attr_node_info(struct ib_device *ibdev,
-					  struct ib_smp *out_mad)
+static int mlx5_query_mad_ifc_smp_attr_node_info(struct ib_device *ibdev,
+						 struct ib_smp *out_mad)
 {
 	struct ib_smp *in_mad = NULL;
 	int err = -ENOMEM;
diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
index b0fdc1b08e06..acc56eaa7356 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -1280,8 +1280,6 @@ int mlx5_ib_process_mad(struct ib_device *ibdev, int mad_flags, u8 port_num,
 int mlx5_ib_alloc_xrcd(struct ib_xrcd *xrcd, struct ib_udata *udata);
 int mlx5_ib_dealloc_xrcd(struct ib_xrcd *xrcd, struct ib_udata *udata);
 int mlx5_query_ext_port_caps(struct mlx5_ib_dev *dev, u8 port);
-int mlx5_query_mad_ifc_smp_attr_node_info(struct ib_device *ibdev,
-					  struct ib_smp *out_mad);
 int mlx5_query_mad_ifc_system_image_guid(struct ib_device *ibdev,
 					 __be64 *sys_image_guid);
 int mlx5_query_mad_ifc_max_pkeys(struct ib_device *ibdev,
--
2.29.2

