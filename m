Return-Path: <linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CDB61C43334
	for <linux-rdma@archiver.kernel.org>; Wed,  8 Jun 2022 04:49:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232804AbiFHEt4 (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Wed, 8 Jun 2022 00:49:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232087AbiFHEts (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Wed, 8 Jun 2022 00:49:48 -0400
Received: from out199-18.us.a.mail.aliyun.com (out199-18.us.a.mail.aliyun.com [47.90.199.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 100B624EC74;
        Tue,  7 Jun 2022 18:14:08 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R521e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04357;MF=yang.lee@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0VFhpbXg_1654650251;
Received: from localhost(mailfrom:yang.lee@linux.alibaba.com fp:SMTPD_---0VFhpbXg_1654650251)
          by smtp.aliyun-inc.com;
          Wed, 08 Jun 2022 09:04:12 +0800
From:   Yang Li <yang.lee@linux.alibaba.com>
To:     chengyou@linux.alibaba.com
Cc:     kaishen@linux.alibaba.com, jgg@ziepe.ca, leon@kernel.org,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yang Li <yang.lee@linux.alibaba.com>,
        Abaci Robot <abaci@linux.alibaba.com>
Subject: [PATCH -next] RDMA/erdma: Remove duplicated include in erdma_cm.c
Date:   Wed,  8 Jun 2022 09:04:10 +0800
Message-Id: <20220608010410.88429-1-yang.lee@linux.alibaba.com>
X-Mailer: git-send-email 2.20.1.7.g153144c
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

Fix following includecheck warning:
./drivers/infiniband/hw/erdma/erdma_cm.c: linux/inetdevice.h is included more than once.

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>
---
 drivers/infiniband/hw/erdma/erdma_cm.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/infiniband/hw/erdma/erdma_cm.c b/drivers/infiniband/hw/erdma/erdma_cm.c
index f97711b3689a..7cc0a99c459e 100644
--- a/drivers/infiniband/hw/erdma/erdma_cm.c
+++ b/drivers/infiniband/hw/erdma/erdma_cm.c
@@ -13,7 +13,6 @@
 #include <linux/errno.h>
 #include <linux/inetdevice.h>
 #include <linux/net.h>
-#include <linux/inetdevice.h>
 #include <net/addrconf.h>
 #include <linux/tcp.h>
 #include <linux/types.h>
-- 
2.20.1.7.g153144c

