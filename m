Return-Path: <SRS0=WHZh=DD=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF5C3C4727F
	for <linux-rdma@archiver.kernel.org>; Sat, 26 Sep 2020 10:25:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B418C238E5
	for <linux-rdma@archiver.kernel.org>; Sat, 26 Sep 2020 10:25:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1601115918;
	bh=ZK04Bgw2fQu9gn6oGAXik5an4Jc7mSceDCZFr3jYH5g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=ADa8+AcNuyzWtdKUpO/NfExwmhtUFH5FnwHLZxEgBR61oeXJp1gfyOsea1RvDrIPY
	 FBK+Y24sknzoE4drFls1dj7YxenTEwcACSo1om1Q3kcCVB9rcZA4nWKWajyW92Tjh3
	 1PZTYDPVq2sscmRjE44wWwCqC0T4uRlAg8IP9Pvs=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726645AbgIZKZS (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Sat, 26 Sep 2020 06:25:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:40282 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726587AbgIZKZR (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Sat, 26 Sep 2020 06:25:17 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E882D238E2;
        Sat, 26 Sep 2020 10:25:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601115917;
        bh=ZK04Bgw2fQu9gn6oGAXik5an4Jc7mSceDCZFr3jYH5g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mD/awsjbrdF6BT6qZC/tf2sQ0pm++Ht2tteFKzfUgWj8sS9PrXvrovXbdwkByj753
         C0psIwCwttpIidMPpaZ3Pfseq9YOMpSOcFEbHaKBoNZS9w8sY2jHdZ+XZMPN5p0d6y
         icUgiRdp7opeXM2dskJJaB4WNaGtHXkUXfXlmpzc=
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Cc:     Leon Romanovsky <leonro@nvidia.com>, linux-rdma@vger.kernel.org,
        Maor Gottlieb <maorg@mellanox.com>
Subject: [PATCH rdma-next v1 07/10] RDMA/core: Align write and ioctl checks of QP types
Date:   Sat, 26 Sep 2020 13:24:47 +0300
Message-Id: <20200926102450.2966017-8-leon@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200926102450.2966017-1-leon@kernel.org>
References: <20200926102450.2966017-1-leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

The ioctl flow checks that the user provides only a supported
list of QP types, while write flow didn't do it and relied on
the driver to check it. Align those flows to fail as early as
possible.

Reviewed-by: Maor Gottlieb <maorg@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/infiniband/core/uverbs_cmd.c | 17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
index 408a1a4b67f6..c8f5268bb690 100644
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -1275,8 +1275,21 @@ static int create_qp(struct uverbs_attr_bundle *attrs,
 	bool has_sq = true;
 	struct ib_device *ib_dev;
 
-	if (cmd->qp_type == IB_QPT_RAW_PACKET && !capable(CAP_NET_RAW))
-		return -EPERM;
+	switch (cmd->qp_type) {
+	case IB_QPT_RAW_PACKET:
+		if (!capable(CAP_NET_RAW))
+			return -EPERM;
+		break;
+	case IB_QPT_RC:
+	case IB_QPT_UC:
+	case IB_QPT_UD:
+	case IB_QPT_XRC_INI:
+	case IB_QPT_XRC_TGT:
+	case IB_QPT_DRIVER:
+		break;
+	default:
+		return -EINVAL;
+	}
 
 	obj = (struct ib_uqp_object *)uobj_alloc(UVERBS_OBJECT_QP, attrs,
 						 &ib_dev);
-- 
2.26.2

