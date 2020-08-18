Return-Path: <SRS0=zb6h=B4=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0471C433DF
	for <linux-rdma@archiver.kernel.org>; Tue, 18 Aug 2020 12:05:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7D70E204EA
	for <linux-rdma@archiver.kernel.org>; Tue, 18 Aug 2020 12:05:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597752342;
	bh=HZwW0RbYZNYIbSeERFmaA5TS6W/lmYnndJUjLuE13dA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=OB0DocFKwZkqTPfogD4XlYC1tYU4QvL1ntuUP0yt3FeJvrl9vJR9aRCV+puuRBhck
	 I/UKAbm0CnKrUHXKS0mQiP/6cffUEsK0lqIQdQbo8gQkZ9itUdysK8bZp2HruukcPK
	 6XplNMKPt3mdDDXoTEbexHAx3AIzTM+1lRAAFIdI=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726482AbgHRMFl (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Tue, 18 Aug 2020 08:05:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:60978 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726145AbgHRMFf (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Tue, 18 Aug 2020 08:05:35 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8569D204EA;
        Tue, 18 Aug 2020 12:05:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597752335;
        bh=HZwW0RbYZNYIbSeERFmaA5TS6W/lmYnndJUjLuE13dA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TMGun8L3C2eXPJsSrKzck1IEHhdHIOqs8orzw3KTu45eSWElAvfO5LZdtrHbNkzWQ
         bzOLvQAeu45DUD4ZuDmT5fR/CsApAeHP0nwFFbV8MnQsciWfm5ASQZCPw/TsIY9xY/
         IxY8UMiVmqsERdpzIFinQzC9AHLdf7NHP2iOjnXc=
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Cc:     Leon Romanovsky <leonro@mellanox.com>, linux-rdma@vger.kernel.org
Subject: [PATCH rdma-next 01/14] RDMA/ucma: Fix refcount 0 incr in ucma_get_ctx()
Date:   Tue, 18 Aug 2020 15:05:13 +0300
Message-Id: <20200818120526.702120-2-leon@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200818120526.702120-1-leon@kernel.org>
References: <20200818120526.702120-1-leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

From: Jason Gunthorpe <jgg@nvidia.com>

Both ucma_destroy_id() and ucma_close_id() (triggered from an event via a
wq) can drive the refcount to zero. ucma_get_ctx() was wrongly assuming
that the refcount can only go to zero from ucma_destroy_id() which also
removes it from the xarray.

Use refcount_inc_not_zero() instead.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/infiniband/core/ucma.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/core/ucma.c b/drivers/infiniband/core/ucma.c
index d03dacaef788..625168563443 100644
--- a/drivers/infiniband/core/ucma.c
+++ b/drivers/infiniband/core/ucma.c
@@ -153,8 +153,8 @@ static struct ucma_context *ucma_get_ctx(struct ucma_file *file, int id)
 	if (!IS_ERR(ctx)) {
 		if (ctx->closing)
 			ctx = ERR_PTR(-EIO);
-		else
-			refcount_inc(&ctx->ref);
+		else if (!refcount_inc_not_zero(&ctx->ref))
+			ctx = ERR_PTR(-ENXIO);
 	}
 	xa_unlock(&ctx_table);
 	return ctx;
-- 
2.26.2

