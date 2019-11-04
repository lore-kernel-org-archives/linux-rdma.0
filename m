Return-Path: <SRS0=M/HP=Y4=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3DD8CCA9ECF
	for <linux-rdma@archiver.kernel.org>; Mon,  4 Nov 2019 07:41:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 10C13205C9
	for <linux-rdma@archiver.kernel.org>; Mon,  4 Nov 2019 07:41:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1572853306;
	bh=1u/OmclZYDmCL/AXUhElWHqwCkMQxKEiOIdFGBzeeaM=;
	h=Date:From:To:Cc:Subject:List-ID:From;
	b=SKg/T9JXTQc5IQmBgGU/aFWmCKCrOslvp2km6iC2oudBM+FlSAFbTX5hvKzmF6bwc
	 Tp+54T/El/2eDcYYZAVWH7HiNzTdAR8+WHF9qkn9k+Fmom4Ov/aNPBlGV7hZO3AhJY
	 f2RsaG4nbAN0BqFlyX4hNlx/xxsxQKJ1gwsh9qHA=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727267AbfKDHlp (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Mon, 4 Nov 2019 02:41:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:53732 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726891AbfKDHlp (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Mon, 4 Nov 2019 02:41:45 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9CA07205C9;
        Mon,  4 Nov 2019 07:41:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572853304;
        bh=1u/OmclZYDmCL/AXUhElWHqwCkMQxKEiOIdFGBzeeaM=;
        h=Date:From:To:Cc:Subject:From;
        b=OGQ+HXc1XPAbXxyNoKzd3t8Id1dsgnwG4/s8qCIqz2DpPfXlfxPmP02VxzFg3/OOw
         bweVXGzlnMwBmVeHmw/AAGjrngRMmITJM/ojpcxROENeysxLN041pW9RXjgZyJGCud
         D3S35LviwwS/UO+6MerPdqN4ZPSIBUUcQ9FyZuUc=
Date:   Mon, 4 Nov 2019 08:41:41 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Leon Romanovsky <leon@kernel.org>,
        Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>
Cc:     linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] IB: mlx5: no need to check return value of debugfs_create
 functions
Message-ID: <20191104074141.GA1292396@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

When calling debugfs functions, there is no need to ever check the
return value.  The function can work or not, but the code logic should
never do something different based on this.

Cc: Leon Romanovsky <leon@kernel.org>
Cc: Doug Ledford <dledford@redhat.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/infiniband/hw/mlx5/main.c    | 62 +++++++---------------------
 drivers/infiniband/hw/mlx5/mlx5_ib.h |  9 +---
 2 files changed, 16 insertions(+), 55 deletions(-)

Note, I kind of need to take this through my tree now as I broke the
build due to me changing the use of debugfs_create_atomic_t() in my
tree and not noticing this being used here.  Sorry about that, any
objections?

And 0-day seems really broken to have missed this for the past months,
ugh, I need to stop relying on it...


diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index 831539419c30..059db0610445 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -5710,11 +5710,10 @@ static int mlx5_ib_rn_get_params(struct ib_device *device, u8 port_num,
 
 static void delay_drop_debugfs_cleanup(struct mlx5_ib_dev *dev)
 {
-	if (!dev->delay_drop.dbg)
+	if (!dev->delay_drop.dir_debugfs)
 		return;
-	debugfs_remove_recursive(dev->delay_drop.dbg->dir_debugfs);
-	kfree(dev->delay_drop.dbg);
-	dev->delay_drop.dbg = NULL;
+	debugfs_remove_recursive(dev->delay_drop.dir_debugfs);
+	dev->delay_drop.dir_debugfs = NULL;
 }
 
 static void cancel_delay_drop(struct mlx5_ib_dev *dev)
@@ -5765,52 +5764,22 @@ static const struct file_operations fops_delay_drop_timeout = {
 	.read	= delay_drop_timeout_read,
 };
 
-static int delay_drop_debugfs_init(struct mlx5_ib_dev *dev)
+static void delay_drop_debugfs_init(struct mlx5_ib_dev *dev)
 {
-	struct mlx5_ib_dbg_delay_drop *dbg;
+	struct dentry *root;
 
 	if (!mlx5_debugfs_root)
-		return 0;
-
-	dbg = kzalloc(sizeof(*dbg), GFP_KERNEL);
-	if (!dbg)
-		return -ENOMEM;
-
-	dev->delay_drop.dbg = dbg;
-
-	dbg->dir_debugfs =
-		debugfs_create_dir("delay_drop",
-				   dev->mdev->priv.dbg_root);
-	if (!dbg->dir_debugfs)
-		goto out_debugfs;
-
-	dbg->events_cnt_debugfs =
-		debugfs_create_atomic_t("num_timeout_events", 0400,
-					dbg->dir_debugfs,
-					&dev->delay_drop.events_cnt);
-	if (!dbg->events_cnt_debugfs)
-		goto out_debugfs;
-
-	dbg->rqs_cnt_debugfs =
-		debugfs_create_atomic_t("num_rqs", 0400,
-					dbg->dir_debugfs,
-					&dev->delay_drop.rqs_cnt);
-	if (!dbg->rqs_cnt_debugfs)
-		goto out_debugfs;
-
-	dbg->timeout_debugfs =
-		debugfs_create_file("timeout", 0600,
-				    dbg->dir_debugfs,
-				    &dev->delay_drop,
-				    &fops_delay_drop_timeout);
-	if (!dbg->timeout_debugfs)
-		goto out_debugfs;
+		return;
 
-	return 0;
+	root = debugfs_create_dir("delay_drop", dev->mdev->priv.dbg_root);
+	dev->delay_drop.dir_debugfs = root;
 
-out_debugfs:
-	delay_drop_debugfs_cleanup(dev);
-	return -ENOMEM;
+	debugfs_create_atomic_t("num_timeout_events", 0400, root,
+				&dev->delay_drop.events_cnt);
+	debugfs_create_atomic_t("num_rqs", 0400, root,
+				&dev->delay_drop.rqs_cnt);
+	debugfs_create_file("timeout", 0600, root, &dev->delay_drop,
+			    &fops_delay_drop_timeout);
 }
 
 static void init_delay_drop(struct mlx5_ib_dev *dev)
@@ -5826,8 +5795,7 @@ static void init_delay_drop(struct mlx5_ib_dev *dev)
 	atomic_set(&dev->delay_drop.rqs_cnt, 0);
 	atomic_set(&dev->delay_drop.events_cnt, 0);
 
-	if (delay_drop_debugfs_init(dev))
-		mlx5_ib_warn(dev, "Failed to init delay drop debugfs\n");
+	delay_drop_debugfs_init(dev);
 }
 
 static void mlx5_ib_unbind_slave_port(struct mlx5_ib_dev *ibdev,
diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
index 1a98ee2e01c4..55ce599db803 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -792,13 +792,6 @@ enum {
 	MLX5_MAX_DELAY_DROP_TIMEOUT_MS = 100,
 };
 
-struct mlx5_ib_dbg_delay_drop {
-	struct dentry		*dir_debugfs;
-	struct dentry		*rqs_cnt_debugfs;
-	struct dentry		*events_cnt_debugfs;
-	struct dentry		*timeout_debugfs;
-};
-
 struct mlx5_ib_delay_drop {
 	struct mlx5_ib_dev     *dev;
 	struct work_struct	delay_drop_work;
@@ -808,7 +801,7 @@ struct mlx5_ib_delay_drop {
 	bool			activate;
 	atomic_t		events_cnt;
 	atomic_t		rqs_cnt;
-	struct mlx5_ib_dbg_delay_drop *dbg;
+	struct dentry		*dir_debugfs;
 };
 
 enum mlx5_ib_stages {
-- 
2.23.0

