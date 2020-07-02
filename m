Return-Path: <SRS0=kzXy=AN=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A58FDC433E0
	for <linux-rdma@archiver.kernel.org>; Thu,  2 Jul 2020 08:29:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 794732089D
	for <linux-rdma@archiver.kernel.org>; Thu,  2 Jul 2020 08:29:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1593678586;
	bh=sxbbjMBwXKAWwy9HwdH3BFNCd1dwyprJIjiWujRDivQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=Y9qlnnrKnALMRNBwpZqVmeWIFz5ct5OMrtMoujd9bcPCWK/OPKkNweaGu7gIT9j6b
	 VEhnRM2WmJpKXCq99xyvEmasCo//F9Dy1vgDq+b8VrVsvm/Q+H0IBBODDXtSog8+yX
	 x/9A0WjLAUl5eOkJePvQnqSdCs9/ZPihQB9NoGa8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727057AbgGBI3p (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Thu, 2 Jul 2020 04:29:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:54684 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726980AbgGBI3p (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Thu, 2 Jul 2020 04:29:45 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B6C4F20899;
        Thu,  2 Jul 2020 08:29:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593678585;
        bh=sxbbjMBwXKAWwy9HwdH3BFNCd1dwyprJIjiWujRDivQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=P8jVTyJDcxjMnwOAvPvok5tmj+b67GOp8BWjISQRxzV1I2T2DC8/s0tg9oSBo/KSX
         kDDdOKh7mp2qVpYPs8lFoxJ/NSsZr6Tljn7Cqp8/n0NaEauaj+cf2wE5uhTUjbG4p4
         qeH4nwQQTjFlZJJy5Lr3NpjHcCCt0HFQU2BfeiH8=
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Cc:     Mark Zhang <markz@mellanox.com>, linux-rdma@vger.kernel.org,
        Majd Dibbiny <majd@mellanox.com>,
        Maor Gottlieb <maorg@mellanox.com>
Subject: [PATCH rdma-next 3/3] RDMA/counter: Allow manually bind QPs with different pids to same counter
Date:   Thu,  2 Jul 2020 11:29:33 +0300
Message-Id: <20200702082933.424537-4-leon@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200702082933.424537-1-leon@kernel.org>
References: <20200702082933.424537-1-leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

From: Mark Zhang <markz@mellanox.com>

In manual mode allow bind user QPs with different pids to same counter,
since this is allowed in auto mode.
Bind kernel QPs and user QPs to the same counter are not allowed.

Fixes: 1bd8e0a9d0fd ("RDMA/counter: Allow manual mode configuration support")
Signed-off-by: Mark Zhang <markz@mellanox.com>
Reviewed-by: Maor Gottlieb <maorg@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/infiniband/core/counters.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/core/counters.c b/drivers/infiniband/core/counters.c
index 104df52e9bdb..636166880442 100644
--- a/drivers/infiniband/core/counters.c
+++ b/drivers/infiniband/core/counters.c
@@ -473,7 +473,7 @@ int rdma_counter_bind_qpn(struct ib_device *dev, u8 port,
 		goto err;
 	}
 
-	if (counter->res.task != qp->res.task) {
+	if (rdma_is_kernel_res(&counter->res) != rdma_is_kernel_res(&qp->res)) {
 		ret = -EINVAL;
 		goto err_task;
 	}
-- 
2.26.2

