Return-Path: <linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2EE7FC00140
	for <linux-rdma@archiver.kernel.org>; Wed, 24 Aug 2022 09:42:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235985AbiHXJm4 (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Wed, 24 Aug 2022 05:42:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236160AbiHXJmz (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Wed, 24 Aug 2022 05:42:55 -0400
Received: from out30-132.freemail.mail.aliyun.com (out30-132.freemail.mail.aliyun.com [115.124.30.132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB8756F540
        for <linux-rdma@vger.kernel.org>; Wed, 24 Aug 2022 02:42:54 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R841e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045192;MF=chengyou@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0VN7.kQr_1661334171;
Received: from localhost(mailfrom:chengyou@linux.alibaba.com fp:SMTPD_---0VN7.kQr_1661334171)
          by smtp.aliyun-inc.com;
          Wed, 24 Aug 2022 17:42:52 +0800
From:   Cheng Xu <chengyou@linux.alibaba.com>
To:     jgg@ziepe.ca, leon@kernel.org
Cc:     linux-rdma@vger.kernel.org, KaiShen@linux.alibaba.com
Subject: [PATCH for-next 0/2] RDMA/erdma: Introduce custom implementation of drain_sq and drain_rq
Date:   Wed, 24 Aug 2022 17:42:49 +0800
Message-Id: <20220824094251.23190-1-chengyou@linux.alibaba.com>
X-Mailer: git-send-email 2.37.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

Hi,

This series introduces erdma's implementation of drain_sq and drain_rq.
Our hardware will stop processing any new WRs if QP state is error.
So the default __ib_drain_sq and __ib_drain_rq in core code can not work
for erdma. For this reason, we implement the drain_sq and drain_rq
interfaces.

In SQ draining or RQ draining, we post both drain send wr and drain
recv wr, and then modify_qp to error. At last, we wait the corresponding
completion in the separated interface.

The first patch introduces internal post_send/post_recv for qp drain, and
the second patch implements the drain_sq and drain_rq of erdma.

Thanks,
Cheng Xu

Cheng Xu (2):
  RDMA/erdma: Introduce internal post_send/post_recv for qp drain
  RDMA/erdma: Add drain_sq and drain_rq support

 drivers/infiniband/hw/erdma/erdma_main.c  |   4 +-
 drivers/infiniband/hw/erdma/erdma_qp.c    | 116 +++++++++++++++++++++-
 drivers/infiniband/hw/erdma/erdma_verbs.h |  27 ++++-
 3 files changed, 136 insertions(+), 11 deletions(-)

-- 
2.27.0

