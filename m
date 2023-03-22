Return-Path: <linux-rdma-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1722CC6FD1C
	for <linux-rdma@archiver.kernel.org>; Wed, 22 Mar 2023 09:33:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229686AbjCVJd3 (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Wed, 22 Mar 2023 05:33:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230145AbjCVJd2 (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Wed, 22 Mar 2023 05:33:28 -0400
Received: from out30-130.freemail.mail.aliyun.com (out30-130.freemail.mail.aliyun.com [115.124.30.130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFED114983
        for <linux-rdma@vger.kernel.org>; Wed, 22 Mar 2023 02:33:24 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R111e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046049;MF=chengyou@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0VeQFuRW_1679477601;
Received: from localhost(mailfrom:chengyou@linux.alibaba.com fp:SMTPD_---0VeQFuRW_1679477601)
          by smtp.aliyun-inc.com;
          Wed, 22 Mar 2023 17:33:22 +0800
From:   Cheng Xu <chengyou@linux.alibaba.com>
To:     jgg@ziepe.ca, leon@kernel.org
Cc:     linux-rdma@vger.kernel.org, KaiShen@linux.alibaba.com
Subject: [PATCH for-next 0/3] RDMA/erdma: erdma updates 3-22-2023
Date:   Wed, 22 Mar 2023 17:33:16 +0800
Message-Id: <20230322093319.84045-1-chengyou@linux.alibaba.com>
X-Mailer: git-send-email 2.37.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

Hi,

This series has some updates for erdma driver:
- #1 unifies the byte ordering API usage in erdma, removes APIs
  prefixing with underlines and introduces be32_to_cpu_array
  to copy and swap byte order.
- #2 eliminates unnecessary casting of EQ doorbells.
- #3 refactors the initialization flow to make code cleaner.

Thanks,
Cheng Xu

Cheng Xu (3):
  RDMA/erdma: Unify byte ordering APIs usage
  RDMA/erdma: Eliminate unnecessary casting of EQ doorbells
  RDMA/erdma: Minor refactor of device init flow

 drivers/infiniband/hw/erdma/erdma.h      |  2 +-
 drivers/infiniband/hw/erdma/erdma_cm.h   | 10 +++---
 drivers/infiniband/hw/erdma/erdma_cmdq.c | 42 ++++--------------------
 drivers/infiniband/hw/erdma/erdma_cq.c   |  2 +-
 drivers/infiniband/hw/erdma/erdma_eq.c   |  9 +++--
 drivers/infiniband/hw/erdma/erdma_main.c | 39 ++++++++++++++++++----
 6 files changed, 51 insertions(+), 53 deletions(-)

-- 
2.31.1

