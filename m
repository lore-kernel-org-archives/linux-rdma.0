Return-Path: <SRS0=gM5Z=5E=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 557A8C4332B
	for <linux-rdma@archiver.kernel.org>; Thu, 19 Mar 2020 13:29:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2C1DF207FC
	for <linux-rdma@archiver.kernel.org>; Thu, 19 Mar 2020 13:29:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729976AbgCSN3G (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Thu, 19 Mar 2020 09:29:06 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:12156 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729236AbgCSN3C (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Thu, 19 Mar 2020 09:29:02 -0400
Received: from DGGEMS405-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id B267A74C6AE4F842419A;
        Thu, 19 Mar 2020 21:28:47 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 DGGEMS405-HUB.china.huawei.com (10.3.19.205) with Microsoft SMTP Server id
 14.3.487.0; Thu, 19 Mar 2020 21:28:41 +0800
From:   Weihang Li <liweihang@huawei.com>
To:     <dledford@redhat.com>, <jgg@ziepe.ca>
CC:     <leon@kernel.org>, <linux-rdma@vger.kernel.org>,
        <linuxarm@huawei.com>
Subject: [PATCH for-next 00/11] RDMA/hns: Various cleanups
Date:   Thu, 19 Mar 2020 21:24:47 +0800
Message-ID: <1584624298-23841-1-git-send-email-liweihang@huawei.com>
X-Mailer: git-send-email 2.8.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-CFilter-Loop: Reflected
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

This series contains some cleanups for the hns driver:
- patch 1 unifies format of prints in hns_roce_hw_v2.c and hns_roce_pd.c.
- patch 2 ~ 6 are some simple modifications.
- patch 7 ~ 11 remove some dead codes.

Lang Cheng (4):
  RDMA/hns: Simplify attribute judgment code
  RDMA/hns: Adjust the qp status value sequence of the hardware
  RDMA/hns: Remove definition of cq doorbell structure
  RDMA/hns: Remove redundant qpc setup operations

Lijun Ou (2):
  RDMA/hns: Unify format of prints
  RDMA/hns: Optimize hns_roce_alloc_vf_resource()

Weihang Li (3):
  RDMA/hns: Fix a wrong judgment of return value
  RDMA/hns: Remove redundant assignment of wc->smac when polling cq
  RDMA/hns: Remove redundant judgment of qp_type

Wenpeng Liang (1):
  RDMA/hns: Remove meaningless prints

Yixian Liu (1):
  RDMA/hns: Check return value of kmalloc with macro

 drivers/infiniband/hw/hns/hns_roce_cmd.c   |   2 +-
 drivers/infiniband/hw/hns/hns_roce_hw_v1.c |   9 +-
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c | 560 ++++++++---------------------
 drivers/infiniband/hw/hns/hns_roce_hw_v2.h |   7 +-
 drivers/infiniband/hw/hns/hns_roce_mr.c    |   2 +-
 drivers/infiniband/hw/hns/hns_roce_pd.c    |   6 +-
 6 files changed, 160 insertions(+), 426 deletions(-)

-- 
2.8.1

