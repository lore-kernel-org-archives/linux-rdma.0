Return-Path: <linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F07B1C433ED
	for <linux-rdma@archiver.kernel.org>; Thu,  1 Apr 2021 07:36:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B57D26101A
	for <linux-rdma@archiver.kernel.org>; Thu,  1 Apr 2021 07:36:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232565AbhDAHfc (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Thu, 1 Apr 2021 03:35:32 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:15565 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233445AbhDAHfF (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Thu, 1 Apr 2021 03:35:05 -0400
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4F9vzY1qhwz17PRW;
        Thu,  1 Apr 2021 15:32:57 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 DGGEMS409-HUB.china.huawei.com (10.3.19.209) with Microsoft SMTP Server id
 14.3.498.0; Thu, 1 Apr 2021 15:34:51 +0800
From:   Weihang Li <liweihang@huawei.com>
To:     <dledford@redhat.com>, <jgg@nvidia.com>
CC:     <leon@kernel.org>, <linux-rdma@vger.kernel.org>,
        <linuxarm@huawei.com>
Subject: [PATCH for-next 2/3] RDMA/hns: Support more return types of command queue
Date:   Thu, 1 Apr 2021 15:32:20 +0800
Message-ID: <1617262341-37571-3-git-send-email-liweihang@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1617262341-37571-1-git-send-email-liweihang@huawei.com>
References: <1617262341-37571-1-git-send-email-liweihang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

From: Lang Cheng <chenglang@huawei.com>

Add error code definition according to the return code from firmware to
help find out more detailed reasons why a command fails to be sent.

Signed-off-by: Lang Cheng <chenglang@huawei.com>
Signed-off-by: Weihang Li <liweihang@huawei.com>
---
 drivers/infiniband/hw/hns/hns_roce_hw_v2.h | 18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.h b/drivers/infiniband/hw/hns/hns_roce_hw_v2.h
index ffdae15..95bee6b 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.h
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.h
@@ -257,10 +257,20 @@ enum {
 };
 
 enum hns_roce_cmd_return_status {
-	CMD_EXEC_SUCCESS	= 0,
-	CMD_NO_AUTH		= 1,
-	CMD_NOT_EXEC		= 2,
-	CMD_QUEUE_FULL		= 3,
+	CMD_EXEC_SUCCESS,
+	CMD_NO_AUTH,
+	CMD_NOT_EXIST,
+	CMD_CRQ_FULL,
+	CMD_NEXT_ERR,
+	CMD_NOT_EXEC,
+	CMD_PARA_ERR,
+	CMD_RESULT_ERR,
+	CMD_TIMEOUT,
+	CMD_HILINK_ERR,
+	CMD_INFO_ILLEGAL,
+	CMD_INVALID,
+	CMD_ROH_CHECK_FAIL,
+	CMD_OTHER_ERR = 0xff
 };
 
 enum hns_roce_sgid_type {
-- 
2.8.1

