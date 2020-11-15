Return-Path: <linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47564C2D0E4
	for <linux-rdma@archiver.kernel.org>; Sun, 15 Nov 2020 08:26:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1754B223FB
	for <linux-rdma@archiver.kernel.org>; Sun, 15 Nov 2020 08:26:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726723AbgKOI0K (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Sun, 15 Nov 2020 03:26:10 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:7240 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726230AbgKOI0K (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Sun, 15 Nov 2020 03:26:10 -0500
Received: from DGGEMS408-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4CYldk0YLlzkY8Q;
        Sun, 15 Nov 2020 16:25:46 +0800 (CST)
Received: from huawei.com (10.175.124.27) by DGGEMS408-HUB.china.huawei.com
 (10.3.19.208) with Microsoft SMTP Server id 14.3.487.0; Sun, 15 Nov 2020
 16:25:55 +0800
From:   Wang ShaoBo <bobo.shaobowang@huawei.com>
To:     <jgg@ziepe.ca>
CC:     <dennis.dalessandro@cornelisnetworks.com>,
        <mike.marciniszyn@cornelisnetworks.com>,
        <linux-rdma@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <huawei.libin@huawei.com>, <cj.chengjian@huawei.com>
Subject: [PATCH] IB/hfi1: Fix error return code in hfi1_init_dd()
Date:   Sun, 15 Nov 2020 16:25:48 +0800
Message-ID: <20201115082548.35793-1-bobo.shaobowang@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.124.27]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

Fix to return the error code from hfi1_netdev_alloc() instaed of 0
in hfi1_init_dd(), as done elsewhere in this function.

Fixes: 4730f4a6c6b2 ("IB/hfi1: Activate the dummy netdev")
Signed-off-by: Wang ShaoBo <bobo.shaobowang@huawei.com>
---
 drivers/infiniband/hw/hfi1/chip.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/hfi1/chip.c b/drivers/infiniband/hw/hfi1/chip.c
index 7eaf99538216..c87b94ea2939 100644
--- a/drivers/infiniband/hw/hfi1/chip.c
+++ b/drivers/infiniband/hw/hfi1/chip.c
@@ -15245,7 +15245,8 @@ int hfi1_init_dd(struct hfi1_devdata *dd)
 		    & CCE_REVISION_SW_MASK);
 
 	/* alloc netdev data */
-	if (hfi1_netdev_alloc(dd))
+	ret = hfi1_netdev_alloc(dd);
+	if (ret)
 		goto bail_cleanup;
 
 	ret = set_up_context_variables(dd);
-- 
2.25.1

