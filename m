Return-Path: <linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4952C83020
	for <linux-rdma@archiver.kernel.org>; Mon, 16 Nov 2020 12:38:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A7EDC20855
	for <linux-rdma@archiver.kernel.org>; Mon, 16 Nov 2020 12:38:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726614AbgKPMAZ (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Mon, 16 Nov 2020 07:00:25 -0500
Received: from szxga07-in.huawei.com ([45.249.212.35]:7917 "EHLO
        szxga07-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726274AbgKPMAZ (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Mon, 16 Nov 2020 07:00:25 -0500
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4CZSLc14r6z6xlb;
        Mon, 16 Nov 2020 20:00:08 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 DGGEMS409-HUB.china.huawei.com (10.3.19.209) with Microsoft SMTP Server id
 14.3.487.0; Mon, 16 Nov 2020 20:00:12 +0800
From:   Weihang Li <liweihang@huawei.com>
To:     <dledford@redhat.com>, <jgg@ziepe.ca>
CC:     <leon@kernel.org>, <linux-rdma@vger.kernel.org>,
        <linuxarm@huawei.com>
Subject: [PATCH v2 for-next 0/2] RDMA/hns: Add supports for stash
Date:   Mon, 16 Nov 2020 19:58:37 +0800
Message-ID: <1605527919-48769-1-git-send-email-liweihang@huawei.com>
X-Mailer: git-send-email 2.8.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

Stash is a mechanism that uses the core information carried by the ARM AXI
bus to access the L3 cache. The CPU and I/O subsystems can access the L3
cache consistently by enabling stash, so the performance can be improved.

Changes since v1:
- Fix comments from Jason about the unused macros.
- Rewrite hr_reg_set() to make it easier for driver to define and set a
  field.
link: https://patchwork.kernel.org/project/linux-rdma/cover/1601458452-55263-1-git-send-email-liweihang@huawei.com/

Lang Cheng (2):
  RDMA/hns: Add support for CQ stash
  RDMA/hns: Add support for QP stash

 drivers/infiniband/hw/hns/hns_roce_common.h | 12 +++++++++
 drivers/infiniband/hw/hns/hns_roce_device.h |  1 +
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c  |  9 +++++++
 drivers/infiniband/hw/hns/hns_roce_hw_v2.h  | 41 ++++++++++++++++++-----------
 4 files changed, 47 insertions(+), 16 deletions(-)

-- 
2.8.1

