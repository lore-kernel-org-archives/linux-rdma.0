Return-Path: <SRS0=8Neo=75=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03017C433E0
	for <linux-rdma@archiver.kernel.org>; Tue, 16 Jun 2020 10:46:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C95CE20767
	for <linux-rdma@archiver.kernel.org>; Tue, 16 Jun 2020 10:46:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1592304368;
	bh=qIsIoireSBbRW2heF90H9q3ZBm2zwtGz3y5Iz5H0o1Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=CxP+NSfiGcHYl96tl7viSHnuunwuJHu9sTNm7lZDEJ6WW2tzIvK29QgoDFHo2vMaX
	 4vu308UbPUjipPTWQTLkZZvd5fHFssL7tqW7s4DAVMiYbgZbZ1GZHL0UviAsgaX0FN
	 IqJfK2LGFTFLm0897Q9pWOuuD+UlOUrmKm5MPN6I=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728144AbgFPKqH (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Tue, 16 Jun 2020 06:46:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:59644 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725775AbgFPKqG (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Tue, 16 Jun 2020 06:46:06 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 398DA20734;
        Tue, 16 Jun 2020 10:46:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592304365;
        bh=qIsIoireSBbRW2heF90H9q3ZBm2zwtGz3y5Iz5H0o1Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BXTmcayN9s+4z2+QWlOlV6rn8ZOZHKhOQRI6ctZRrd5h+CJWRxTDQ3873D9qzu1Xu
         rA4c0ZoOVnCU6kjZeeNKQSu2daT/iNPgmcP8BHpxPqG4Lc/RIG0V7rLLmA8fxj1spI
         +Ne+AcjF6y8zan+0MYT2koDE6mXgol7VQmOUWUoQ=
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Cc:     Maor Gottlieb <maorg@mellanox.com>, linux-rdma@vger.kernel.org
Subject: [PATCH rdma-next v2 03/11] RDMA/core: Don't call fill_res_entry for PD
Date:   Tue, 16 Jun 2020 13:39:58 +0300
Message-Id: <20200616104006.2425549-4-leon@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200616104006.2425549-1-leon@kernel.org>
References: <20200616104006.2425549-1-leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

From: Maor Gottlieb <maorg@mellanox.com>

None of the vendor implement it, remove it.

Signed-off-by: Maor Gottlieb <maorg@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/infiniband/core/nldev.c | 9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

diff --git a/drivers/infiniband/core/nldev.c b/drivers/infiniband/core/nldev.c
index e16105be2eb2..8548f09746ab 100644
--- a/drivers/infiniband/core/nldev.c
+++ b/drivers/infiniband/core/nldev.c
@@ -653,7 +653,6 @@ static int fill_res_pd_entry(struct sk_buff *msg, bool has_cap_net_admin,
 			     struct rdma_restrack_entry *res, uint32_t port)
 {
 	struct ib_pd *pd = container_of(res, struct ib_pd, res);
-	struct ib_device *dev = pd->device;
 
 	if (has_cap_net_admin) {
 		if (nla_put_u32(msg, RDMA_NLDEV_ATTR_RES_LOCAL_DMA_LKEY,
@@ -676,13 +675,7 @@ static int fill_res_pd_entry(struct sk_buff *msg, bool has_cap_net_admin,
 			pd->uobject->context->res.id))
 		goto err;
 
-	if (fill_res_name_pid(msg, res))
-		goto err;
-
-	if (fill_res_entry(dev, msg, res))
-		goto err;
-
-	return 0;
+	return fill_res_name_pid(msg, res);
 
 err:	return -EMSGSIZE;
 }
-- 
2.26.2

