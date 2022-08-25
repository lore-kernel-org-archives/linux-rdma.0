Return-Path: <linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5FC8CC04AA5
	for <linux-rdma@archiver.kernel.org>; Thu, 25 Aug 2022 02:39:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229490AbiHYCjN (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Wed, 24 Aug 2022 22:39:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230022AbiHYCjL (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Wed, 24 Aug 2022 22:39:11 -0400
Received: from out30-131.freemail.mail.aliyun.com (out30-131.freemail.mail.aliyun.com [115.124.30.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64F479AFBA
        for <linux-rdma@vger.kernel.org>; Wed, 24 Aug 2022 19:39:09 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R171e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045176;MF=chengyou@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0VNBJu3m_1661395146;
Received: from localhost(mailfrom:chengyou@linux.alibaba.com fp:SMTPD_---0VNBJu3m_1661395146)
          by smtp.aliyun-inc.com;
          Thu, 25 Aug 2022 10:39:06 +0800
From:   Cheng Xu <chengyou@linux.alibaba.com>
To:     jgg@ziepe.ca, leon@kernel.org
Cc:     linux-rdma@vger.kernel.org, KaiShen@linux.alibaba.com
Subject: [PATCH for-next v2 0/2] RDMA/erdma: Introduce custom implementation of drain_sq and drain_rq
Date:   Thu, 25 Aug 2022 10:39:03 +0800
Message-Id: <20220825023905.28274-1-chengyou@linux.alibaba.com>
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

Changes since V1:
* Add drain_rq/drain_sq assignments in struct ib_device_ops of erdma.

Thanks,
Cheng Xu

Cheng Xu (2):
  RDMA/erdma: Introduce internal post_send/post_recv for qp drain
  RDMA/erdma: Add drain_sq and drain_rq support

 drivers/infiniband/hw/erdma/erdma_main.c  |   6 +-
 drivers/infiniband/hw/erdma/erdma_qp.c    | 116 +++++++++++++++++++++-
 drivers/infiniband/hw/erdma/erdma_verbs.h |  27 ++++-
 3 files changed, 138 insertions(+), 11 deletions(-)

-- 
2.27.0

