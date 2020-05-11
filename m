Return-Path: <SRS0=4PuW=6Z=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4CD58C47255
	for <linux-rdma@archiver.kernel.org>; Mon, 11 May 2020 07:43:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 322532082E
	for <linux-rdma@archiver.kernel.org>; Mon, 11 May 2020 07:43:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725916AbgEKHnZ (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Mon, 11 May 2020 03:43:25 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:4325 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725790AbgEKHnZ (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Mon, 11 May 2020 03:43:25 -0400
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 7F48F77A0B0A7225CAC2;
        Mon, 11 May 2020 15:43:18 +0800 (CST)
Received: from linux-ibm.site (10.175.102.37) by
 DGGEMS414-HUB.china.huawei.com (10.3.19.214) with Microsoft SMTP Server id
 14.3.487.0; Mon, 11 May 2020 15:43:11 +0800
From:   Xiongfeng Wang <wangxiongfeng2@huawei.com>
To:     <bvanassche@acm.org>, <dledford@redhat.com>, <jgg@ziepe.ca>
CC:     <linux-rdma@vger.kernel.org>, <target-devel@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <wangxiongfeng2@huawei.com>
Subject: [PATCH] RDMA/srpt: Add a newline when printing parameter 'srpt_service_guid' by sysfs
Date:   Mon, 11 May 2020 15:37:09 +0800
Message-ID: <1589182629-27743-1-git-send-email-wangxiongfeng2@huawei.com>
X-Mailer: git-send-email 1.7.12.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.102.37]
X-CFilter-Loop: Reflected
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

When I cat module parameter 'srpt_service_guid', it displays as follows.
It is better to add a newline for easy reading.

[root@hulk-202 ~]# cat /sys/module/ib_srpt/parameters/srpt_service_guid
0x0205cdfffe8346b9[root@hulk-202 ~]#

Signed-off-by: Xiongfeng Wang <wangxiongfeng2@huawei.com>
---
 drivers/infiniband/ulp/srpt/ib_srpt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
index 9855274..79b6341 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.c
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
@@ -81,7 +81,7 @@
 
 static int srpt_get_u64_x(char *buffer, const struct kernel_param *kp)
 {
-	return sprintf(buffer, "0x%016llx", *(u64 *)kp->arg);
+	return sprintf(buffer, "0x%016llx\n", *(u64 *)kp->arg);
 }
 module_param_call(srpt_service_guid, NULL, srpt_get_u64_x, &srpt_service_guid,
 		  0444);
-- 
1.7.12.4

