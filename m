Return-Path: <SRS0=anP4=CX=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7390EC433E2
	for <linux-rdma@archiver.kernel.org>; Mon, 14 Sep 2020 11:13:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2D422208DB
	for <linux-rdma@archiver.kernel.org>; Mon, 14 Sep 2020 11:13:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1600082014;
	bh=73OoPP5FPeuvl68OR4SJuTFTIQqP9of8VvOUt1/AWoQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=iTF/PRbUvXwCJteG/YqCnRnSwwqXx0ys3Iky5SI9Q0pWz2vXjOKqhBVn968srDmNe
	 LsgWKnFtiqptJHgoFoetDHkFhbY8vniQWl5wcL7Y8qVdmnku8m4y7TkbUgabJjqn4K
	 BBFcdldw1YtwOFfHM61B21jEv0hezKCBqu3nncws=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726043AbgINLN2 (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Mon, 14 Sep 2020 07:13:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:42454 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725980AbgINLMW (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Mon, 14 Sep 2020 07:12:22 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 58C8821D1A;
        Mon, 14 Sep 2020 11:11:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600081910;
        bh=73OoPP5FPeuvl68OR4SJuTFTIQqP9of8VvOUt1/AWoQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Oh+fpWfiQBNwtjvRqQiWH1u87V89ghN3J5EUSWNkWBjJFPS+7KOkxfgZigVbmulCX
         HbGM370YE4D167gSZTI/SeoaI6anN8UVF1IvatSNNlKvN34V9XgX5mLG3XCjjlNX0v
         gqPyUdYka6apamb61Xy1WFJNc4QX5IUj6WwoOrHQ=
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Cc:     Avihai Horon <avihaih@nvidia.com>, linux-rdma@vger.kernel.org
Subject: [PATCH rdma-next v1 1/4] RDMA/core: Change rdma_get_gid_attr returned error code
Date:   Mon, 14 Sep 2020 14:11:26 +0300
Message-Id: <20200914111129.343651-2-leon@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200914111129.343651-1-leon@kernel.org>
References: <20200914111129.343651-1-leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-rdma-owner@vger.kernel.org
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
index 01d85da00187..1a5507b79437 100644
--- a/drivers/infiniband/core/sysfs.c
+++ b/drivers/infiniband/core/sysfs.c
@@ -391,7 +391,8 @@ static ssize_t _show_port_gid_attr(

 	gid_attr = rdma_get_gid_attr(p->ibdev, p->port_num, tab_attr->index);
 	if (IS_ERR(gid_attr))
-		return PTR_ERR(gid_attr);
+		/* -EINVAL is returned for user space compatibility reasons. */
+		return -EINVAL;

 	ret = print(gid_attr, buf);
 	rdma_put_gid_attr(gid_attr);
--
2.26.2

