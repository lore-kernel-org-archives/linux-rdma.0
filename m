Return-Path: <linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88F3FC433ED
	for <linux-rdma@archiver.kernel.org>; Fri,  2 Apr 2021 09:10:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 645FC61008
	for <linux-rdma@archiver.kernel.org>; Fri,  2 Apr 2021 09:10:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234397AbhDBJKP (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Fri, 2 Apr 2021 05:10:15 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:15531 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234630AbhDBJKN (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Fri, 2 Apr 2021 05:10:13 -0400
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4FBZ295Z4XzNs89;
        Fri,  2 Apr 2021 17:07:29 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 DGGEMS403-HUB.china.huawei.com (10.3.19.203) with Microsoft SMTP Server id
 14.3.498.0; Fri, 2 Apr 2021 17:10:04 +0800
From:   Weihang Li <liweihang@huawei.com>
To:     <dledford@redhat.com>, <jgg@nvidia.com>
CC:     <leon@kernel.org>, <linux-rdma@vger.kernel.org>,
        <linuxarm@huawei.com>, Weihang Li <liweihang@huawei.com>
Subject: [PATCH for-next 0/9] RDMA/hns: Misc updates for 5.13
Date:   Fri, 2 Apr 2021 17:07:25 +0800
Message-ID: <1617354454-47840-1-git-send-email-liweihang@huawei.com>
X-Mailer: git-send-email 2.8.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

There are some cleanups for the -next branch as usual:
- #1, #2 fix issues about inline.
- #3 ~ #6 remove some dead code and redunant check.
- #7 ~ #9 are miscellaneous changes.

Lang Cheng (1):
  RDMA/hns: Prevent le32 from being implicitly converted to u32

Weihang Li (2):
  RDMA/hns: Avoid enabling RQ inline on UD
  RDMA/hns: Fix missing assignment of max_inline_data

Wenpeng Liang (3):
  RDMA/hns: Delete redundant abnormal interrupt status
  RDMA/hns: Remove unsupported QP types
  RDMA/hns: Add XRC subtype in QPC and XRC type in SRQC

Yangyang Li (2):
  RDMA/hns: Delete redundant condition judgment related to eq
  RDMA/hns: Delete unused members in the structure hns_roce_hw

Yixing Liu (1):
  RDMA/hns: Simplify the function config_eqc()

 drivers/infiniband/hw/hns/hns_roce_common.h |  15 +-
 drivers/infiniband/hw/hns/hns_roce_device.h |  16 --
 drivers/infiniband/hw/hns/hns_roce_hw_v1.c  |   9 +-
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c  | 220 ++++++++--------------------
 drivers/infiniband/hw/hns/hns_roce_hw_v2.h  | 116 ++++-----------
 drivers/infiniband/hw/hns/hns_roce_qp.c     |   6 +-
 6 files changed, 105 insertions(+), 277 deletions(-)

-- 
2.8.1

