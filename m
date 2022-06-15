Return-Path: <linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98996CCA47A
	for <linux-rdma@archiver.kernel.org>; Wed, 15 Jun 2022 01:52:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345126AbiFOBwg (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Tue, 14 Jun 2022 21:52:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345057AbiFOBwe (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Tue, 14 Jun 2022 21:52:34 -0400
Received: from out30-43.freemail.mail.aliyun.com (out30-43.freemail.mail.aliyun.com [115.124.30.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CCDA2ADB
        for <linux-rdma@vger.kernel.org>; Tue, 14 Jun 2022 18:52:32 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R311e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045170;MF=chengyou@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0VGQPa9R_1655257949;
Received: from localhost(mailfrom:chengyou@linux.alibaba.com fp:SMTPD_---0VGQPa9R_1655257949)
          by smtp.aliyun-inc.com;
          Wed, 15 Jun 2022 09:52:30 +0800
From:   Cheng Xu <chengyou@linux.alibaba.com>
To:     jgg@ziepe.ca, leon@kernel.org
Cc:     linux-rdma@vger.kernel.org, KaiShen@linux.alibaba.com,
        chengyou@linux.alibaba.com, tonylu@linux.alibaba.com,
        BMT@zurich.ibm.com, dan.carpenter@oracle.com
Subject: [PATCH for-next v11 01/11] RDMA: Add ERDMA to rdma_driver_id definition
Date:   Wed, 15 Jun 2022 09:52:17 +0800
Message-Id: <20220615015227.65686-2-chengyou@linux.alibaba.com>
X-Mailer: git-send-email 2.32.1 (Apple Git-133)
In-Reply-To: <20220615015227.65686-1-chengyou@linux.alibaba.com>
References: <20220615015227.65686-1-chengyou@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

Signed-off-by: Cheng Xu <chengyou@linux.alibaba.com>
---
 include/uapi/rdma/ib_user_ioctl_verbs.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/uapi/rdma/ib_user_ioctl_verbs.h b/include/uapi/rdma/ib_user_ioctl_verbs.h
index 3072e5d6b692..7dd56210226f 100644
--- a/include/uapi/rdma/ib_user_ioctl_verbs.h
+++ b/include/uapi/rdma/ib_user_ioctl_verbs.h
@@ -250,6 +250,7 @@ enum rdma_driver_id {
 	RDMA_DRIVER_QIB,
 	RDMA_DRIVER_EFA,
 	RDMA_DRIVER_SIW,
+	RDMA_DRIVER_ERDMA,
 };
 
 enum ib_uverbs_gid_type {
-- 
2.27.0

