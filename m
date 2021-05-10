Return-Path: <linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3AC5EC43617
	for <linux-rdma@archiver.kernel.org>; Mon, 10 May 2021 13:22:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0715B6128B
	for <linux-rdma@archiver.kernel.org>; Mon, 10 May 2021 13:22:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240770AbhEJNXF (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Mon, 10 May 2021 09:23:05 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:2551 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234099AbhEJMIc (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Mon, 10 May 2021 08:08:32 -0400
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4Ff09D25ZxzkYDK;
        Mon, 10 May 2021 20:04:48 +0800 (CST)
Received: from thunder-town.china.huawei.com (10.174.177.72) by
 DGGEMS414-HUB.china.huawei.com (10.3.19.214) with Microsoft SMTP Server id
 14.3.498.0; Mon, 10 May 2021 20:07:17 +0800
From:   Zhen Lei <thunder.leizhen@huawei.com>
To:     Mike Marciniszyn <mike.marciniszyn@cornelisnetworks.com>,
        "Dennis Dalessandro" <dennis.dalessandro@cornelisnetworks.com>,
        Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        linux-rdma <linux-rdma@vger.kernel.org>
CC:     Zhen Lei <thunder.leizhen@huawei.com>
Subject: [PATCH 1/1] IB/hfi1: Delete an unneeded bool conversion
Date:   Mon, 10 May 2021 20:06:35 +0800
Message-ID: <20210510120635.3636-1-thunder.leizhen@huawei.com>
X-Mailer: git-send-email 2.26.0.windows.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.174.177.72]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

The result of an expression consisting of a single relational operator is
already of the bool type and does not need to be evaluated explicitly.

No functional change.

Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>
---
 drivers/infiniband/hw/hfi1/tid_rdma.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/hfi1/tid_rdma.c b/drivers/infiniband/hw/hfi1/tid_rdma.c
index 0b1f9e4d038b06c..233ea48b72c80c0 100644
--- a/drivers/infiniband/hw/hfi1/tid_rdma.c
+++ b/drivers/infiniband/hw/hfi1/tid_rdma.c
@@ -1115,7 +1115,7 @@ static u32 kern_find_pages(struct tid_rdma_flow *flow,
 	}
 
 	flow->length = flow->req->seg_len - length;
-	*last = req->isge == ss->num_sge ? false : true;
+	*last = req->isge != ss->num_sge;
 	return i;
 }
 
-- 
2.26.0.106.g9fadedd


