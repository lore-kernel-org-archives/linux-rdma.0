Return-Path: <SRS0=uWV+=4X=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94DBEC3F2D1
	for <linux-rdma@archiver.kernel.org>; Fri,  6 Mar 2020 02:48:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 653B821556
	for <linux-rdma@archiver.kernel.org>; Fri,  6 Mar 2020 02:48:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726382AbgCFCsm (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Thu, 5 Mar 2020 21:48:42 -0500
Received: from szxga06-in.huawei.com ([45.249.212.32]:57714 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726378AbgCFCsm (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Thu, 5 Mar 2020 21:48:42 -0500
Received: from DGGEMS407-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 315CFB8778C2DE59DCC8;
        Fri,  6 Mar 2020 10:48:40 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 DGGEMS407-HUB.china.huawei.com (10.3.19.207) with Microsoft SMTP Server id
 14.3.439.0; Fri, 6 Mar 2020 10:48:31 +0800
From:   Weihang Li <liweihang@huawei.com>
To:     <dledford@redhat.com>, <jgg@ziepe.ca>
CC:     <leon@kernel.org>, <linux-rdma@vger.kernel.org>,
        <linuxarm@huawei.com>
Subject: [PATCH v2 for-next 0/5] RDMA/hns: Refactor wqe related codes
Date:   Fri, 6 Mar 2020 10:44:49 +0800
Message-ID: <1583462694-43908-1-git-send-email-liweihang@huawei.com>
X-Mailer: git-send-email 2.8.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-CFilter-Loop: Reflected
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

Process of wqe is hard to understand and maintain in hns, this series
refactor wqe related code, especially in hns_roce_v2_post_send().

Previous discussion could be found at:
https://patchwork.kernel.org/cover/11415395/

Changes since v1:
- Fix comments from Leon about the inplementation of to_hr_opcode() in
  patch 3/5.
- Patch 4/5 couldn't be applied. Just do a rebase.

Xi Wang (5):
  RDMA/hns: Rename wqe buffer related functions
  RDMA/hns: Optimize wqe buffer filling process for post send
  RDMA/hns: Optimize the wr opcode conversion from ib to hns
  RDMA/hns: Optimize base address table config flow for qp buffer
  RDMA/hns: Optimize wqe buffer set flow for post send

 drivers/infiniband/hw/hns/hns_roce_device.h |  10 +-
 drivers/infiniband/hw/hns/hns_roce_hem.c    |  16 +-
 drivers/infiniband/hw/hns/hns_roce_hw_v1.c  |   9 +-
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c  | 588 ++++++++++++++--------------
 drivers/infiniband/hw/hns/hns_roce_qp.c     |  48 +--
 5 files changed, 319 insertions(+), 352 deletions(-)

-- 
2.8.1

