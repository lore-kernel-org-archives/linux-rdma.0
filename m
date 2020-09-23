Return-Path: <SRS0=cPpa=DA=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B8E3C2D0A8
	for <linux-rdma@archiver.kernel.org>; Wed, 23 Sep 2020 16:50:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DB52320BED
	for <linux-rdma@archiver.kernel.org>; Wed, 23 Sep 2020 16:50:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1600879827;
	bh=YmNJEf8K85A3l2x8+q9PpTrvnVANTDIJiYiMMN//+gw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=ArO/tCuilY5ColwsLdpzpIE/cncIwX5QGXqnFhDuSaioWeWV10kxwh7Yay28k4jx/
	 AWMQvciy1YArml8xOlP7Ha1aHxpTIqGZSNhPFbI393MG8kDSt3f1pRbEBMNxLoILBt
	 7GBJBdBtWA6LwBash5US61ymA4i0b1yY2kfIJ3Nk=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726130AbgIWQu1 (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Wed, 23 Sep 2020 12:50:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:58590 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726381AbgIWQuZ (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Wed, 23 Sep 2020 12:50:25 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0917620936;
        Wed, 23 Sep 2020 16:50:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600879824;
        bh=YmNJEf8K85A3l2x8+q9PpTrvnVANTDIJiYiMMN//+gw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0wIG/BA5iTb4y4z73590zfonIS5pkiWlU6CKzYi8KQ1Fg4cGeiLx4KuGM9UaA2/cq
         wPojFFET5tCrtvYxwl2Ta95X03m2fHRisHkYaI+DlhpVvooC/K7VVaK1+AK4Oh2srp
         QTViQ5dN3ZK76+8e/qkOm0+YkpfxDfIPodyH7xmE=
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Cc:     Avihai Horon <avihaih@nvidia.com>, linux-rdma@vger.kernel.org
Subject: [PATCH rdma-next v3 1/4] RDMA/core: Change rdma_get_gid_attr returned error code
Date:   Wed, 23 Sep 2020 19:50:12 +0300
Message-Id: <20200923165015.2491894-2-leon@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200923165015.2491894-1-leon@kernel.org>
References: <20200923165015.2491894-1-leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

From: Avihai Horon <avihaih@nvidia.com>

Change the error code returned from rdma_get_gid_attr when the GID entry
is invalid but the GID index is in the gid table size range to -ENODATA
instead of -EINVAL.

This change is done in order to provide a more accurate error reporting
to be used by the new GID query API in user space. Nevertheless, -EINVAL
is still returned from sysfs in the aforementioned case to maintain
compatibility with user space that expects -EINVAL.

Signed-off-by: Avihai Horon <avihaih@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/infiniband/core/cache.c | 2 +-
 drivers/infiniband/core/sysfs.c | 3 ++-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/core/cache.c b/drivers/infiniband/core/cache.c
index ffad73bb40ff..6079f1f7e678 100644
--- a/drivers/infiniband/core/cache.c
+++ b/drivers/infiniband/core/cache.c
@@ -1220,7 +1220,7 @@ EXPORT_SYMBOL(ib_get_cached_port_state);
 const struct ib_gid_attr *
 rdma_get_gid_attr(struct ib_device *device, u8 port_num, int index)
 {
-	const struct ib_gid_attr *attr = ERR_PTR(-EINVAL);
+	const struct ib_gid_attr *attr = ERR_PTR(-ENODATA);
 	struct ib_gid_table *table;
 	unsigned long flags;
 
diff --git a/drivers/infiniband/core/sysfs.c b/drivers/infiniband/core/sysfs.c
index c11e50510e49..409675d48614 100644
--- a/drivers/infiniband/core/sysfs.c
+++ b/drivers/infiniband/core/sysfs.c
@@ -387,7 +387,8 @@ static ssize_t _show_port_gid_attr(
 
 	gid_attr = rdma_get_gid_attr(p->ibdev, p->port_num, tab_attr->index);
 	if (IS_ERR(gid_attr))
-		return PTR_ERR(gid_attr);
+		/* -EINVAL is returned for user space compatibility reasons. */
+		return -EINVAL;
 
 	ret = print(gid_attr, buf);
 	rdma_put_gid_attr(gid_attr);
-- 
2.26.2

