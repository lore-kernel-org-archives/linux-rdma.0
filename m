Return-Path: <SRS0=HMeR=4C=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D727C3B1B7
	for <linux-rdma@archiver.kernel.org>; Fri, 14 Feb 2020 18:17:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 65AC122314
	for <linux-rdma@archiver.kernel.org>; Fri, 14 Feb 2020 18:17:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1581704235;
	bh=ZAZQ4pdAnry+OBx1ralUNrdcqcjYjEJG1WhPRjFjRNM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=WviNj0C5WRklH6jImdvlSE+YMxwhdTeoaDsywmRt99QBGYLup/032m8jQn419HrbP
	 aQP2LK5Pw27tXikO8iRG5EMxb0p1TbLs0vTZ7bxnhb9sGyaESKfbWI0Q/mrVzPyybr
	 dVKLYfvzOO3uuSLs6WmF9CdNcB6S8zfbvyRPIUBY=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730714AbgBNPvQ (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Fri, 14 Feb 2020 10:51:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:56078 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730231AbgBNPvP (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Fri, 14 Feb 2020 10:51:15 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E454424650;
        Fri, 14 Feb 2020 15:51:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581695474;
        bh=ZAZQ4pdAnry+OBx1ralUNrdcqcjYjEJG1WhPRjFjRNM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IXSK7n/8iCwGj+bov0T2iLiAXvUr8TjUpAtl699it57Hax1t3U6apBgB16rceiWw9
         06fxShkte0/m9v8wbPdsh65mzXLI2ccjumxC9RhGdhStjGiYr60qncTpeW9FFdSyuA
         JHO126BHNJrgAg9Fo7ZXRn5XJ30PFbc4mB0M48JE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Danit Goldberg <danitg@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>, linux-rdma@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.5 108/542] IB/mlx5: Return the administrative GUID if exists
Date:   Fri, 14 Feb 2020 10:41:40 -0500
Message-Id: <20200214154854.6746-108-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214154854.6746-1-sashal@kernel.org>
References: <20200214154854.6746-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

From: Danit Goldberg <danitg@mellanox.com>

[ Upstream commit 4bbd4923d1f5627b0c47a9d7dfb5cc91224cfe0c ]

A user can change the operational GUID (a.k.a affective GUID) through
link/infiniband. Therefore it is preferred to return the currently set
GUID if it exists instead of the operational.

This way the PF can query which VF GUID will be set in the next bind.  In
order to align with MAC address, zero is returned if administrative GUID
is not set.

For example, before setting administrative GUID:
 $ ip link show
 ib0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 4092 qdisc mq state UP mode DEFAULT group default qlen 256
 link/infiniband 00:00:00:08:fe:80:00:00:00:00:00:00:52:54:00:c0:fe:12:34:55 brd 00:ff:ff:ff:ff:12:40:1b:ff:ff:00:00:00:00:00:00:ff:ff:ff:ff
 vf 0     link/infiniband 00:00:00:08:fe:80:00:00:00:00:00:00:52:54:00:c0:fe:12:34:55 brd 00:ff:ff:ff:ff:12:40:1b:ff:ff:00:00:00:00:00:00:ff:ff:ff:ff,
 spoof checking off, NODE_GUID 00:00:00:00:00:00:00:00, PORT_GUID 00:00:00:00:00:00:00:00, link-state auto, trust off, query_rss off

Then:

 $ ip link set ib0 vf 0 node_guid 11:00:af:21:cb:05:11:00
 $ ip link set ib0 vf 0 port_guid 22:11:af:21:cb:05:11:00

After setting administrative GUID:
 $ ip link show
 ib0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 4092 qdisc mq state UP mode DEFAULT group default qlen 256
 link/infiniband 00:00:00:08:fe:80:00:00:00:00:00:00:52:54:00:c0:fe:12:34:55 brd 00:ff:ff:ff:ff:12:40:1b:ff:ff:00:00:00:00:00:00:ff:ff:ff:ff
 vf 0     link/infiniband 00:00:00:08:fe:80:00:00:00:00:00:00:52:54:00:c0:fe:12:34:55 brd 00:ff:ff:ff:ff:12:40:1b:ff:ff:00:00:00:00:00:00:ff:ff:ff:ff,
 spoof checking off, NODE_GUID 11:00:af:21:cb:05:11:00, PORT_GUID 22:11:af:21:cb:05:11:00, link-state auto, trust off, query_rss off

Fixes: 9c0015ef0928 ("IB/mlx5: Implement callbacks for getting VFs GUID attributes")
Link: https://lore.kernel.org/r/20200116120048.12744-1-leon@kernel.org
Signed-off-by: Danit Goldberg <danitg@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/mlx5/ib_virt.c | 28 ++++++++++++----------------
 include/linux/mlx5/driver.h          |  5 +++++
 2 files changed, 17 insertions(+), 16 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/ib_virt.c b/drivers/infiniband/hw/mlx5/ib_virt.c
index 4f0edd4832bdf..b61165359954e 100644
--- a/drivers/infiniband/hw/mlx5/ib_virt.c
+++ b/drivers/infiniband/hw/mlx5/ib_virt.c
@@ -164,8 +164,10 @@ static int set_vf_node_guid(struct ib_device *device, int vf, u8 port, u64 guid)
 	in->field_select = MLX5_HCA_VPORT_SEL_NODE_GUID;
 	in->node_guid = guid;
 	err = mlx5_core_modify_hca_vport_context(mdev, 1, 1, vf + 1, in);
-	if (!err)
+	if (!err) {
 		vfs_ctx[vf].node_guid = guid;
+		vfs_ctx[vf].node_guid_valid = 1;
+	}
 	kfree(in);
 	return err;
 }
@@ -185,8 +187,10 @@ static int set_vf_port_guid(struct ib_device *device, int vf, u8 port, u64 guid)
 	in->field_select = MLX5_HCA_VPORT_SEL_PORT_GUID;
 	in->port_guid = guid;
 	err = mlx5_core_modify_hca_vport_context(mdev, 1, 1, vf + 1, in);
-	if (!err)
+	if (!err) {
 		vfs_ctx[vf].port_guid = guid;
+		vfs_ctx[vf].port_guid_valid = 1;
+	}
 	kfree(in);
 	return err;
 }
@@ -208,20 +212,12 @@ int mlx5_ib_get_vf_guid(struct ib_device *device, int vf, u8 port,
 {
 	struct mlx5_ib_dev *dev = to_mdev(device);
 	struct mlx5_core_dev *mdev = dev->mdev;
-	struct mlx5_hca_vport_context *rep;
-	int err;
-
-	rep = kzalloc(sizeof(*rep), GFP_KERNEL);
-	if (!rep)
-		return -ENOMEM;
+	struct mlx5_vf_context *vfs_ctx = mdev->priv.sriov.vfs_ctx;
 
-	err = mlx5_query_hca_vport_context(mdev, 1, 1, vf+1, rep);
-	if (err)
-		goto ex;
+	node_guid->guid =
+		vfs_ctx[vf].node_guid_valid ? vfs_ctx[vf].node_guid : 0;
+	port_guid->guid =
+		vfs_ctx[vf].port_guid_valid ? vfs_ctx[vf].port_guid : 0;
 
-	port_guid->guid = rep->port_guid;
-	node_guid->guid = rep->node_guid;
-ex:
-	kfree(rep);
-	return err;
+	return 0;
 }
diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
index 27200dea02977..a24937fc56b91 100644
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -461,6 +461,11 @@ struct mlx5_vf_context {
 	int	enabled;
 	u64	port_guid;
 	u64	node_guid;
+	/* Valid bits are used to validate administrative guid only.
+	 * Enabled after ndo_set_vf_guid
+	 */
+	u8	port_guid_valid:1;
+	u8	node_guid_valid:1;
 	enum port_state_policy	policy;
 };
 
-- 
2.20.1

