Return-Path: <SRS0=q+lP=53=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95164C352BE
	for <linux-rdma@archiver.kernel.org>; Sat, 11 Apr 2020 23:50:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7102620CC7
	for <linux-rdma@archiver.kernel.org>; Sat, 11 Apr 2020 23:50:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1586649010;
	bh=bWe9TyO+BEOJERZoFu6CknnWm3u8T2fd8Nn4tYI6FTQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=mvqsJlrIRaMEs7TU+M/8/7IX1Y2d5zPP4RvKEEn6GcLaekWJulRfACYJX8AFN7HTV
	 MdrD6+J/tHrgMQyk7g+lUZJtJkT2Hz1RF9oo8Huhrm1pHSB8lMNCjOD7duZplO8I1a
	 9odcsjqUYQskqYoONiU7dfY2stDkgJm7s6iwpAO4=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727113AbgDKXuI (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Sat, 11 Apr 2020 19:50:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:37476 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727035AbgDKXEM (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Sat, 11 Apr 2020 19:04:12 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5609521744;
        Sat, 11 Apr 2020 23:04:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586646253;
        bh=bWe9TyO+BEOJERZoFu6CknnWm3u8T2fd8Nn4tYI6FTQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2oR9YrSJIsm0S1ldKwMK7Flq6RG332P2rnhx0ljUHz3Oe7qqFTV6GI3wk3ff4+rli
         +tHAAKMljRK2pgRjAfjoOGjDes+kIozbi6VyjaqFfzPgRC6T2k2o1CNrSHZhMAHY+U
         jS+4QyLnXfV0qGo8Xemf9qy8dzqbRJzzrGb9F2ZQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jason Gunthorpe <jgg@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>,
        Sasha Levin <sashal@kernel.org>, linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 5.6 020/149] RDMA/cm: Fix ordering of xa_alloc_cyclic() in ib_create_cm_id()
Date:   Sat, 11 Apr 2020 19:01:37 -0400
Message-Id: <20200411230347.22371-20-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200411230347.22371-1-sashal@kernel.org>
References: <20200411230347.22371-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

From: Jason Gunthorpe <jgg@mellanox.com>

[ Upstream commit e8dc4e885c459343970b25acd9320fe9ee5492e7 ]

xa_alloc_cyclic() is a SMP release to be paired with some later acquire
during xa_load() as part of cm_acquire_id().

As such, xa_alloc_cyclic() must be done after the cm_id is fully
initialized, in particular, it absolutely must be after the
refcount_set(), otherwise the refcount_inc() in cm_acquire_id() may not
see the set.

As there are several cases where a reader will be able to use the
id.local_id after cm_acquire_id in the IB_CM_IDLE state there needs to be
an unfortunate split into a NULL allocate and a finalizing xa_store.

Fixes: a977049dacde ("[PATCH] IB: Add the kernel CM implementation")
Link: https://lore.kernel.org/r/20200310092545.251365-2-leon@kernel.org
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/core/cm.c | 27 +++++++++++----------------
 1 file changed, 11 insertions(+), 16 deletions(-)

diff --git a/drivers/infiniband/core/cm.c b/drivers/infiniband/core/cm.c
index 15e99a8884275..3b2b9a3546a13 100644
--- a/drivers/infiniband/core/cm.c
+++ b/drivers/infiniband/core/cm.c
@@ -572,18 +572,6 @@ static int cm_init_av_by_path(struct sa_path_rec *path,
 	return 0;
 }
 
-static int cm_alloc_id(struct cm_id_private *cm_id_priv)
-{
-	int err;
-	u32 id;
-
-	err = xa_alloc_cyclic_irq(&cm.local_id_table, &id, cm_id_priv,
-			xa_limit_32b, &cm.local_id_next, GFP_KERNEL);
-
-	cm_id_priv->id.local_id = (__force __be32)id ^ cm.random_id_operand;
-	return err;
-}
-
 static u32 cm_local_id(__be32 local_id)
 {
 	return (__force u32) (local_id ^ cm.random_id_operand);
@@ -825,6 +813,7 @@ struct ib_cm_id *ib_create_cm_id(struct ib_device *device,
 				 void *context)
 {
 	struct cm_id_private *cm_id_priv;
+	u32 id;
 	int ret;
 
 	cm_id_priv = kzalloc(sizeof *cm_id_priv, GFP_KERNEL);
@@ -836,9 +825,6 @@ struct ib_cm_id *ib_create_cm_id(struct ib_device *device,
 	cm_id_priv->id.cm_handler = cm_handler;
 	cm_id_priv->id.context = context;
 	cm_id_priv->id.remote_cm_qpn = 1;
-	ret = cm_alloc_id(cm_id_priv);
-	if (ret)
-		goto error;
 
 	spin_lock_init(&cm_id_priv->lock);
 	init_completion(&cm_id_priv->comp);
@@ -847,11 +833,20 @@ struct ib_cm_id *ib_create_cm_id(struct ib_device *device,
 	INIT_LIST_HEAD(&cm_id_priv->altr_list);
 	atomic_set(&cm_id_priv->work_count, -1);
 	refcount_set(&cm_id_priv->refcount, 1);
+
+	ret = xa_alloc_cyclic_irq(&cm.local_id_table, &id, NULL, xa_limit_32b,
+				  &cm.local_id_next, GFP_KERNEL);
+	if (ret)
+		goto error;
+	cm_id_priv->id.local_id = (__force __be32)id ^ cm.random_id_operand;
+	xa_store_irq(&cm.local_id_table, cm_local_id(cm_id_priv->id.local_id),
+		     cm_id_priv, GFP_KERNEL);
+
 	return &cm_id_priv->id;
 
 error:
 	kfree(cm_id_priv);
-	return ERR_PTR(-ENOMEM);
+	return ERR_PTR(ret);
 }
 EXPORT_SYMBOL(ib_create_cm_id);
 
-- 
2.20.1

