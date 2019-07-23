Return-Path: <SRS0=t5r7=VU=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22926C76188
	for <linux-rdma@archiver.kernel.org>; Tue, 23 Jul 2019 06:57:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EB8782239E
	for <linux-rdma@archiver.kernel.org>; Tue, 23 Jul 2019 06:57:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1563865073;
	bh=kAp/WEsDoFogVI/6Z603r1fuO6zztm9RBhUZg+sBmc0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=IA+fDBUr8E9Li+rdbMR97TX7SbcDtqaVHJ0Pg/3qadnphSVAjnd4t7UkF5WADDPIS
	 sQ3DHJ+4xt1oGw9WZEgu5hvsE/k4jy2Ubm/GOE5f3TtOurqidS/18oKPN60291IoqT
	 Sg0d6klyCQEYXsiHAj4VZ+lw1h0fJ8zJsTVMYqys=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730602AbfGWG5w (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Tue, 23 Jul 2019 02:57:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:42496 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729469AbfGWG5w (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Tue, 23 Jul 2019 02:57:52 -0400
Received: from localhost (unknown [193.47.165.251])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 045512190F;
        Tue, 23 Jul 2019 06:57:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563865071;
        bh=kAp/WEsDoFogVI/6Z603r1fuO6zztm9RBhUZg+sBmc0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Pu05Rzo/36zAps9zi9lG8v4hnlu4+nNxx0kAX3cquG7RmIEgW+5wPqQu69FdnCP5J
         6ND6KMB0lf7W6fgGnMx8+GqCe4tZ6JFG7kSURojpD1W12GqRuFD6obZvZ+VKCkV66z
         4CQb62ErEOalC86y1mByQRUXsrayq2F39/tt2EQ8=
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Cc:     Leon Romanovsky <leonro@mellanox.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Alex Vainman <alexv@mellanox.com>,
        Artemy Kovalyov <artemyko@mellanox.com>,
        Daniel Jurgens <danielj@mellanox.com>,
        Eli Cohen <eli@mellanox.com>,
        Haggai Eran <haggaie@mellanox.com>,
        Mark Zhang <markz@mellanox.com>,
        Moni Shoua <monis@mellanox.com>,
        Parav Pandit <parav@mellanox.com>,
        Sagi Grimberg <sagig@mellanox.com>,
        Yishai Hadas <yishaih@mellanox.com>
Subject: [PATCH rdma-rc 01/10] RDMA/core: Annotate destroy of mutex to ensure that it is released as unlocked
Date:   Tue, 23 Jul 2019 09:57:24 +0300
Message-Id: <20190723065733.4899-2-leon@kernel.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190723065733.4899-1-leon@kernel.org>
References: <20190723065733.4899-1-leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

From: Parav Pandit <parav@mellanox.com>

While compiled with CONFIG_DEBUG_MUTEXES, the kernel ensures that mutex
is not held during destroy.
Hence add mutex_destroy() for mutexes used in RDMA modules.

Signed-off-by: Parav Pandit <parav@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/infiniband/core/cache.c        | 1 +
 drivers/infiniband/core/cma_configfs.c | 8 +++++++-
 drivers/infiniband/core/device.c       | 3 +++
 drivers/infiniband/core/user_mad.c     | 2 +-
 drivers/infiniband/core/uverbs_main.c  | 4 ++++
 drivers/infiniband/core/verbs.c        | 1 +
 6 files changed, 17 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/core/cache.c b/drivers/infiniband/core/cache.c
index 18e476b3ced0..00fb3eacda19 100644
--- a/drivers/infiniband/core/cache.c
+++ b/drivers/infiniband/core/cache.c
@@ -810,6 +810,7 @@ static void release_gid_table(struct ib_device *device,
 	if (leak)
 		return;

+	mutex_destroy(&table->lock);
 	kfree(table->data_vec);
 	kfree(table);
 }
diff --git a/drivers/infiniband/core/cma_configfs.c b/drivers/infiniband/core/cma_configfs.c
index 3ec2c415bb70..8b0b5ae22e4c 100644
--- a/drivers/infiniband/core/cma_configfs.c
+++ b/drivers/infiniband/core/cma_configfs.c
@@ -342,12 +342,18 @@ static struct configfs_subsystem cma_subsys = {

 int __init cma_configfs_init(void)
 {
+	int ret;
+
 	config_group_init(&cma_subsys.su_group);
 	mutex_init(&cma_subsys.su_mutex);
-	return configfs_register_subsystem(&cma_subsys);
+	ret = configfs_register_subsystem(&cma_subsys);
+	if (ret)
+		mutex_destroy(&cma_subsys.su_mutex);
+	return ret;
 }

 void __exit cma_configfs_exit(void)
 {
 	configfs_unregister_subsystem(&cma_subsys);
+	mutex_destroy(&cma_subsys.su_mutex);
 }
diff --git a/drivers/infiniband/core/device.c b/drivers/infiniband/core/device.c
index c56993e5e5ea..c3576c7d2e8f 100644
--- a/drivers/infiniband/core/device.c
+++ b/drivers/infiniband/core/device.c
@@ -497,6 +497,9 @@ static void ib_device_release(struct device *device)
 			  rcu_head);
 	}

+	mutex_destroy(&dev->unregistration_lock);
+	mutex_destroy(&dev->compat_devs_mutex);
+
 	xa_destroy(&dev->compat_devs);
 	xa_destroy(&dev->client_data);
 	kfree_rcu(dev, rcu_head);
diff --git a/drivers/infiniband/core/user_mad.c b/drivers/infiniband/core/user_mad.c
index 9f8a48016b41..e0512aef033c 100644
--- a/drivers/infiniband/core/user_mad.c
+++ b/drivers/infiniband/core/user_mad.c
@@ -1038,7 +1038,7 @@ static int ib_umad_close(struct inode *inode, struct file *filp)
 				ib_unregister_mad_agent(file->agent[i]);

 	mutex_unlock(&file->port->file_mutex);
-
+	mutex_destroy(&file->mutex);
 	kfree(file);
 	return 0;
 }
diff --git a/drivers/infiniband/core/uverbs_main.c b/drivers/infiniband/core/uverbs_main.c
index 11c13c1381cf..02b57240176c 100644
--- a/drivers/infiniband/core/uverbs_main.c
+++ b/drivers/infiniband/core/uverbs_main.c
@@ -120,6 +120,8 @@ static void ib_uverbs_release_dev(struct device *device)

 	uverbs_destroy_api(dev->uapi);
 	cleanup_srcu_struct(&dev->disassociate_srcu);
+	mutex_destroy(&dev->lists_mutex);
+	mutex_destroy(&dev->xrcd_tree_mutex);
 	kfree(dev);
 }

@@ -212,6 +214,8 @@ void ib_uverbs_release_file(struct kref *ref)

 	if (file->disassociate_page)
 		__free_pages(file->disassociate_page, 0);
+	mutex_destroy(&file->umap_lock);
+	mutex_destroy(&file->ucontext_lock);
 	kfree(file);
 }

diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/core/verbs.c
index 92349bf37589..f974b6854224 100644
--- a/drivers/infiniband/core/verbs.c
+++ b/drivers/infiniband/core/verbs.c
@@ -2259,6 +2259,7 @@ int ib_dealloc_xrcd(struct ib_xrcd *xrcd, struct ib_udata *udata)
 		if (ret)
 			return ret;
 	}
+	mutex_destroy(&xrcd->tgt_qp_mutex);

 	return xrcd->device->ops.dealloc_xrcd(xrcd, udata);
 }
--
2.20.1

