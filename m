Return-Path: <SRS0=/rP3=X3=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17627C35280
	for <linux-rdma@archiver.kernel.org>; Wed,  2 Oct 2019 12:25:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D34A321A4A
	for <linux-rdma@archiver.kernel.org>; Wed,  2 Oct 2019 12:25:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1570019132;
	bh=ZkRlWJ/nqTMW7dVzOTjs9T7NWikdMThBZiyjvwzhryY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=QDE+seJuWoSH1jAMaoNHeqtWTdaAD/6OPuQ4WNoFMESoiFy9L2OvrY4mfaGVL+lLC
	 pAEEaRbru/10Q7bhuz141AeVqXJWscuNS1tMV0iIlBC7WqfX3qCbK5wDa8D0Ur6rdb
	 RP8Fv+72e+CXz3X+iSI6QLSmSzZuayrttna0c564=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726043AbfJBMZc (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Wed, 2 Oct 2019 08:25:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:59870 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725935AbfJBMZc (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Wed, 2 Oct 2019 08:25:32 -0400
Received: from localhost (unknown [193.47.165.251])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1CA6221920;
        Wed,  2 Oct 2019 12:25:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570019131;
        bh=ZkRlWJ/nqTMW7dVzOTjs9T7NWikdMThBZiyjvwzhryY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mm6Ob2ytDxZX67xeNW1abcU5yQWJCO9LDjXzn5Ao9y7VMNyTEpO5YN1d7oKUdOz/3
         BZBqtRplvyO3xYYWj2uy6KRMinZTzLWoO5s1K3ZWzv3HwTyc0JOIpkyX2XN+W1IGog
         fwdGmxUPEZVSAQPLjPrjBx4/9REohetiZdRgozuo=
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Cc:     Leon Romanovsky <leonro@mellanox.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Erez Alfasi <ereza@mellanox.com>,
        Parav Pandit <parav@mellanox.com>
Subject: [PATCH rdma-next 4/4] IB/cm: Use container_of() instead of typecast
Date:   Wed,  2 Oct 2019 15:25:17 +0300
Message-Id: <20191002122517.17721-5-leon@kernel.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191002122517.17721-1-leon@kernel.org>
References: <20191002122517.17721-1-leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

From: Parav Pandit <parav@mellanox.com>

Use container_of() macro to get to timewait info structure instead of
typecasting.

Signed-off-by: Parav Pandit <parav@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/infiniband/core/cm.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/core/cm.c b/drivers/infiniband/core/cm.c
index da10e6ccb43c..c0aa3a4b4cfd 100644
--- a/drivers/infiniband/core/cm.c
+++ b/drivers/infiniband/core/cm.c
@@ -246,7 +246,7 @@ struct cm_work {
 };
 
 struct cm_timewait_info {
-	struct cm_work work;			/* Must be first. */
+	struct cm_work work;
 	struct list_head list;
 	struct rb_node remote_qp_node;
 	struct rb_node remote_id_node;
@@ -3434,7 +3434,7 @@ static int cm_timewait_handler(struct cm_work *work)
 	struct cm_id_private *cm_id_priv;
 	int ret;
 
-	timewait_info = (struct cm_timewait_info *)work;
+	timewait_info = container_of(work, struct cm_timewait_info, work);
 	spin_lock_irq(&cm.lock);
 	list_del(&timewait_info->list);
 	spin_unlock_irq(&cm.lock);
-- 
2.20.1

