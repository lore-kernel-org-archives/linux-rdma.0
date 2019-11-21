Return-Path: <SRS0=NZET=ZN=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8AED4C43215
	for <linux-rdma@archiver.kernel.org>; Thu, 21 Nov 2019 01:23:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6C92B20895
	for <linux-rdma@archiver.kernel.org>; Thu, 21 Nov 2019 01:23:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726774AbfKUBXB (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Wed, 20 Nov 2019 20:23:01 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:7152 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727114AbfKUBXB (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Wed, 20 Nov 2019 20:23:01 -0500
Received: from DGGEMS412-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 19B268F1013406B69AB4;
        Thu, 21 Nov 2019 09:22:59 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 DGGEMS412-HUB.china.huawei.com (10.3.19.212) with Microsoft SMTP Server id
 14.3.439.0; Thu, 21 Nov 2019 09:22:51 +0800
From:   Weihang Li <liweihang@hisilicon.com>
To:     <jgg@ziepe.ca>, <leon@kernel.org>
CC:     <dledford@redhat.com>, <linux-rdma@vger.kernel.org>,
        <linuxarm@huawei.com>
Subject: [PATCH rdma-core 2/7] libhns: Optimize bind_mw for fixing null pointer access
Date:   Thu, 21 Nov 2019 09:19:24 +0800
Message-ID: <1574299169-31457-3-git-send-email-liweihang@hisilicon.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1574299169-31457-1-git-send-email-liweihang@hisilicon.com>
References: <1574299169-31457-1-git-send-email-liweihang@hisilicon.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-CFilter-Loop: Reflected
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

From: Xi Wang <wangxi11@huawei.com>

The argument checking flow in hns_roce_u_bind_mw() will leads to access on
a null address when the mr is not initialized in mw_bind.

Fixes: 47eff6e8624d ("libhns: Adjust the order of parameter checking")
Signed-off-by: Xi Wang <wangxi11@huawei.com>
Signed-off-by: Weihang Li <liweihang@hisilicon.com>
---
 providers/hns/hns_roce_u_verbs.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/providers/hns/hns_roce_u_verbs.c b/providers/hns/hns_roce_u_verbs.c
index bd5060d..0acfd9a 100644
--- a/providers/hns/hns_roce_u_verbs.c
+++ b/providers/hns/hns_roce_u_verbs.c
@@ -186,7 +186,10 @@ int hns_roce_u_bind_mw(struct ibv_qp *qp, struct ibv_mw *mw,
 	if (!bind_info->mr && bind_info->length)
 		return EINVAL;
 
-	if ((mw->pd != qp->pd) || (mw->pd != bind_info->mr->pd))
+	if (mw->pd != qp->pd)
+		return EINVAL;
+
+	if (bind_info->mr && (mw->pd != bind_info->mr->pd))
 		return EINVAL;
 
 	if (mw->type != IBV_MW_TYPE_1)
-- 
2.8.1

