Return-Path: <linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6B83C43600
	for <linux-rdma@archiver.kernel.org>; Fri,  2 Apr 2021 09:10:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7AF1161104
	for <linux-rdma@archiver.kernel.org>; Fri,  2 Apr 2021 09:10:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234872AbhDBJKW (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Fri, 2 Apr 2021 05:10:22 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:14683 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234876AbhDBJKT (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Fri, 2 Apr 2021 05:10:19 -0400
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4FBZ2H42TYznYBX;
        Fri,  2 Apr 2021 17:07:35 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 DGGEMS403-HUB.china.huawei.com (10.3.19.203) with Microsoft SMTP Server id
 14.3.498.0; Fri, 2 Apr 2021 17:10:07 +0800
From:   Weihang Li <liweihang@huawei.com>
To:     <dledford@redhat.com>, <jgg@nvidia.com>
CC:     <leon@kernel.org>, <linux-rdma@vger.kernel.org>,
        <linuxarm@huawei.com>, Lang Cheng <chenglang@huawei.com>,
        Weihang Li <liweihang@huawei.com>
Subject: [PATCH for-next 9/9] RDMA/hns: Prevent le32 from being implicitly converted to u32
Date:   Fri, 2 Apr 2021 17:07:34 +0800
Message-ID: <1617354454-47840-10-git-send-email-liweihang@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1617354454-47840-1-git-send-email-liweihang@huawei.com>
References: <1617354454-47840-1-git-send-email-liweihang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

From: Lang Cheng <chenglang@huawei.com>

Replace BUILD_BUG_ON_ZERO() with BUILD_BUG_ON() to avoid sparse
complaining "restricted __le32 degrades to integer".

Signed-off-by: Lang Cheng <chenglang@huawei.com>
Signed-off-by: Weihang Li <liweihang@huawei.com>
---
 drivers/infiniband/hw/hns/hns_roce_common.h | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_common.h b/drivers/infiniband/hw/hns/hns_roce_common.h
index 23c438c..f6e7984 100644
--- a/drivers/infiniband/hw/hns/hns_roce_common.h
+++ b/drivers/infiniband/hw/hns/hns_roce_common.h
@@ -48,7 +48,8 @@
 #define roce_set_field(origin, mask, shift, val)                               \
 	do {                                                                   \
 		(origin) &= ~cpu_to_le32(mask);                                \
-		(origin) |= cpu_to_le32(((u32)(val) << (u32)(shift)) & (mask));     \
+		(origin) |=                                                    \
+			cpu_to_le32(((u32)(val) << (u32)(shift)) & (mask));    \
 	} while (0)
 
 #define roce_set_bit(origin, shift, val)                                       \
@@ -59,9 +60,9 @@
 #define _hr_reg_enable(ptr, field_type, field_h, field_l)                      \
 	({                                                                     \
 		const field_type *_ptr = ptr;                                  \
-		*((__le32 *)_ptr + (field_h) / 32) |=                          \
-			cpu_to_le32(BIT((field_l) % 32)) +                     \
-			BUILD_BUG_ON_ZERO((field_h) != (field_l));             \
+		*((__le32 *)_ptr + (field_h) / 32) |= cpu_to_le32(             \
+			BIT((field_l) % 32) +                                  \
+			BUILD_BUG_ON_ZERO((field_h) != (field_l)));            \
 	})
 
 #define hr_reg_enable(ptr, field) _hr_reg_enable(ptr, field)
@@ -69,11 +70,9 @@
 #define _hr_reg_clear(ptr, field_type, field_h, field_l)                       \
 	({                                                                     \
 		const field_type *_ptr = ptr;                                  \
+		BUILD_BUG_ON(((field_h) / 32) != ((field_l) / 32));            \
 		*((__le32 *)_ptr + (field_h) / 32) &=                          \
-			cpu_to_le32(                                           \
-				~GENMASK((field_h) % 32, (field_l) % 32)) +    \
-			BUILD_BUG_ON_ZERO(((field_h) / 32) !=                  \
-					  ((field_l) / 32));                   \
+			~cpu_to_le32(GENMASK((field_h) % 32, (field_l) % 32)); \
 	})
 
 #define hr_reg_clear(ptr, field) _hr_reg_clear(ptr, field)
-- 
2.8.1

