Return-Path: <SRS0=Ytdr=76=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 474F4C433E0
	for <linux-rdma@archiver.kernel.org>; Wed, 17 Jun 2020 14:04:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 28D8120734
	for <linux-rdma@archiver.kernel.org>; Wed, 17 Jun 2020 14:04:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726851AbgFQOEr (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Wed, 17 Jun 2020 10:04:47 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:52724 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725894AbgFQOEr (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Wed, 17 Jun 2020 10:04:47 -0400
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 5B33BB4F90B46736D7A0;
        Wed, 17 Jun 2020 22:04:44 +0800 (CST)
Received: from localhost.localdomain.localdomain (10.175.113.25) by
 DGGEMS403-HUB.china.huawei.com (10.3.19.203) with Microsoft SMTP Server id
 14.3.487.0; Wed, 17 Jun 2020 22:04:37 +0800
From:   Jing Xiangfeng <jingxiangfeng@huawei.com>
To:     <bvanassche@acm.org>, <dledford@redhat.com>, <jgg@ziepe.ca>
CC:     <linux-rdma@vger.kernel.org>, <target-devel@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
        <jingxiangfeng@huawei.com>
Subject: [PATCH v3] IB/srpt: Remove WARN_ON from srpt_cm_req_recv
Date:   Wed, 17 Jun 2020 22:08:03 +0800
Message-ID: <20200617140803.181333-1-jingxiangfeng@huawei.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.113.25]
X-CFilter-Loop: Reflected
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

The callers pass the pointer '&req' or 'private_data' to
srpt_cm_req_recv(), and 'private_data' is initialized in srp_send_req().
'sdev' is allocated and stored in srpt_add_one(). It's easy to show that
sdev and req are always valid. So we remove unnecessary WARN_ON.

Signed-off-by: Jing Xiangfeng <jingxiangfeng@huawei.com>
---
 drivers/infiniband/ulp/srpt/ib_srpt.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
index ef7fcd3..0fa65c6 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.c
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
@@ -2156,9 +2156,6 @@ static int srpt_cm_req_recv(struct srpt_device *const sdev,
 
 	WARN_ON_ONCE(irqs_disabled());
 
-	if (WARN_ON(!sdev || !req))
-		return -EINVAL;
-
 	it_iu_len = be32_to_cpu(req->req_it_iu_len);
 
 	pr_info("Received SRP_LOGIN_REQ with i_port_id %pI6, t_port_id %pI6 and it_iu_len %d on port %d (guid=%pI6); pkey %#04x\n",
-- 
1.8.3.1

