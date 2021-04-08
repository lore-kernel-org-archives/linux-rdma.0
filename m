Return-Path: <linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95460C43617
	for <linux-rdma@archiver.kernel.org>; Thu,  8 Apr 2021 11:34:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 56FC661107
	for <linux-rdma@archiver.kernel.org>; Thu,  8 Apr 2021 11:34:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231384AbhDHLer (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Thu, 8 Apr 2021 07:34:47 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:15975 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231396AbhDHLer (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Thu, 8 Apr 2021 07:34:47 -0400
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4FGJyb3LLvzyNMr;
        Thu,  8 Apr 2021 19:32:23 +0800 (CST)
Received: from huawei.com (10.175.112.208) by DGGEMS402-HUB.china.huawei.com
 (10.3.19.202) with Microsoft SMTP Server id 14.3.498.0; Thu, 8 Apr 2021
 19:34:28 +0800
From:   Wang Wensheng <wangwensheng4@huawei.com>
To:     <mike.marciniszyn@cornelisnetworks.com>,
        <dennis.dalessandro@cornelisnetworks.com>, <dledford@redhat.com>,
        <jgg@ziepe.ca>, <brendan.cunningham@intel.com>,
        <ira.weiny@intel.com>, <sudeep.dutt@intel.com>,
        <linux-rdma@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <rui.xiang@huawei.com>
Subject: [PATCH -next] IB/hfi1: Fix error return code in parse_platform_config()
Date:   Thu, 8 Apr 2021 11:31:40 +0000
Message-ID: <20210408113140.103032-1-wangwensheng4@huawei.com>
X-Mailer: git-send-email 2.9.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.112.208]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

Fix to return a negative error code from the error handling
case instead of 0, as done elsewhere in this function.

Fixes: 7724105686e7 ("IB/hfi1: add driver files")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Wang Wensheng <wangwensheng4@huawei.com>
---
 drivers/infiniband/hw/hfi1/firmware.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/infiniband/hw/hfi1/firmware.c b/drivers/infiniband/hw/hfi1/firmware.c
index 0e83d4b..2cf102b 100644
--- a/drivers/infiniband/hw/hfi1/firmware.c
+++ b/drivers/infiniband/hw/hfi1/firmware.c
@@ -1916,6 +1916,7 @@ int parse_platform_config(struct hfi1_devdata *dd)
 			dd_dev_err(dd, "%s: Failed CRC check at offset %ld\n",
 				   __func__, (ptr -
 				   (u32 *)dd->platform_config.data));
+			ret = -EINVAL;
 			goto bail;
 		}
 		/* Jump the CRC DWORD */
-- 
2.9.4

