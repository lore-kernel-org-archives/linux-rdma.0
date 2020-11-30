Return-Path: <linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-20.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3992C5519F
	for <linux-rdma@archiver.kernel.org>; Mon, 30 Nov 2020 07:59:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6CF9320709
	for <linux-rdma@archiver.kernel.org>; Mon, 30 Nov 2020 07:59:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="0IA7NNK+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727804AbgK3H7d (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Mon, 30 Nov 2020 02:59:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:56612 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727777AbgK3H7d (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Mon, 30 Nov 2020 02:59:33 -0500
Received: from localhost (searspoint.nvidia.com [216.228.112.21])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4F36F20731;
        Mon, 30 Nov 2020 07:58:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606723133;
        bh=iD+NVYWBJzu2teVDTwoggpgoSvZcQYNd0CG35DtRLZo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0IA7NNK+Oe/oY8m8gENosZQcI5V4tQhwn5ymd+DY4wtPTq9o5ddFt7kukKBd088zl
         Vjt+mJMPJI2rhfVWQcukyZykRsqbpFq9YJ7R83IrSLirtgT5vUlHsixkygwB+npzNY
         QWBBO/ZENmtgug7/PUiI3b25Y97zgO5SPAaweNq0=
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Cc:     linux-rdma@vger.kernel.org
Subject: [PATCH rdma-next 1/5] RDMA/uverbs: Tidy input validation of ib_uverbs_rereg_mr()
Date:   Mon, 30 Nov 2020 09:58:35 +0200
Message-Id: <20201130075839.278575-2-leon@kernel.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201130075839.278575-1-leon@kernel.org>
References: <20201130075839.278575-1-leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

From: Jason Gunthorpe <jgg@nvidia.com>

Unknown flags should be EOPNOTSUPP, only zero flags is EINVAL. Flags is
actually the rereg action to perform.

The checking of the start/hca_va/etc is also redundant and ib_umem_get()
does these checks and returns proper error codes.

Fixes: 7e6edb9b2e0b ("IB/core: Add user MR re-registration support")
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/infiniband/core/uverbs_cmd.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
index a43c3d6d92a2..c0b4aaf724de 100644
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -781,13 +781,15 @@ static int ib_uverbs_rereg_mr(struct uverbs_attr_bundle *attrs)
 	if (ret)
 		return ret;

-	if (cmd.flags & ~IB_MR_REREG_SUPPORTED || !cmd.flags)
+	if (!cmd.flags)
 		return -EINVAL;

+	if (cmd.flags & ~IB_MR_REREG_SUPPORTED)
+		return -EOPNOTSUPP;
+
 	if ((cmd.flags & IB_MR_REREG_TRANS) &&
-	    (!cmd.start || !cmd.hca_va || 0 >= cmd.length ||
-	     (cmd.start & ~PAGE_MASK) != (cmd.hca_va & ~PAGE_MASK)))
-			return -EINVAL;
+	    (cmd.start & ~PAGE_MASK) != (cmd.hca_va & ~PAGE_MASK))
+		return -EINVAL;

 	uobj = uobj_get_write(UVERBS_OBJECT_MR, cmd.mr_handle, attrs);
 	if (IS_ERR(uobj))
--
2.28.0

