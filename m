Return-Path: <SRS0=cc4V=VF=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79DF4C606AC
	for <linux-rdma@archiver.kernel.org>; Mon,  8 Jul 2019 13:44:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5808220844
	for <linux-rdma@archiver.kernel.org>; Mon,  8 Jul 2019 13:44:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731413AbfGHNor (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Mon, 8 Jul 2019 09:44:47 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:46180 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728124AbfGHNor (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Mon, 8 Jul 2019 09:44:47 -0400
Received: from DGGEMS408-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 4E122F598F09DA991E14;
        Mon,  8 Jul 2019 21:44:44 +0800 (CST)
Received: from linux-ioko.site (10.71.200.31) by
 DGGEMS408-HUB.china.huawei.com (10.3.19.208) with Microsoft SMTP Server id
 14.3.439.0; Mon, 8 Jul 2019 21:44:38 +0800
From:   Lijun Ou <oulijun@huawei.com>
To:     <dledford@redhat.com>, <jgg@ziepe.ca>
CC:     <leon@kernel.org>, <linux-rdma@vger.kernel.org>,
        <linuxarm@huawei.com>
Subject: [PATCH for-next 0/9] Codes optimization for hip08
Date:   Mon, 8 Jul 2019 21:41:16 +0800
Message-ID: <1562593285-8037-1-git-send-email-oulijun@huawei.com>
X-Mailer: git-send-email 1.9.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.71.200.31]
X-CFilter-Loop: Reflected
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

Here are codes optimization in order to reduce complexity and
add readability.

Lijun Ou (6):
  RDMA/hns: Package the flow of creating cq
  RDMA/hns: Refactor the code of creating srq
  RDMA/hns: Refactor for hns_roce_v2_modify_qp function
  RDMA/hns: Use a separated function for setting extend sge paramters
  RDMA/hns: Package for hns_roce_rereg_user_mr function
  RDMA/hns: Refactor hem table mhop check and calculation

Xi Wang (1):
  RDMA/hns: optimize the duplicated code for qpc setting flow

Yixian Liu (1):
  RDMA/hns: Refactor eq table init for hip08

chenglang (1):
  RDMA/hns: Optimize hns_roce_mhop_alloc function.

 drivers/infiniband/hw/hns/hns_roce_cq.c     | 186 +++++---
 drivers/infiniband/hw/hns/hns_roce_device.h |   2 -
 drivers/infiniband/hw/hns/hns_roce_hem.c    | 180 ++++----
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c  | 628 ++++++++++++++++------------
 drivers/infiniband/hw/hns/hns_roce_mr.c     | 428 +++++++++++--------
 drivers/infiniband/hw/hns/hns_roce_qp.c     |  61 ++-
 drivers/infiniband/hw/hns/hns_roce_srq.c    | 310 ++++++++------
 7 files changed, 1015 insertions(+), 780 deletions(-)

-- 
1.9.1

