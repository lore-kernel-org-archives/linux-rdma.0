Return-Path: <SRS0=DDZm=D7=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66993C388F9
	for <linux-rdma@archiver.kernel.org>; Sat, 24 Oct 2020 03:08:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 18C7C206ED
	for <linux-rdma@archiver.kernel.org>; Sat, 24 Oct 2020 03:08:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1759257AbgJXDIv (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Fri, 23 Oct 2020 23:08:51 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:2174 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1759253AbgJXDIu (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Fri, 23 Oct 2020 23:08:50 -0400
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 0409AE525F016034042B;
        Sat, 24 Oct 2020 11:08:48 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 DGGEMS403-HUB.china.huawei.com (10.3.19.203) with Microsoft SMTP Server id
 14.3.487.0; Sat, 24 Oct 2020 11:08:37 +0800
From:   Weihang Li <liweihang@huawei.com>
To:     <dledford@redhat.com>, <jgg@ziepe.ca>
CC:     <leon@kernel.org>, <linux-rdma@vger.kernel.org>,
        <linuxarm@huawei.com>
Subject: [PATCH for-next 0/2] RDMA/hns: Support GMV table
Date:   Sat, 24 Oct 2020 11:07:14 +0800
Message-ID: <1603508836-33054-1-git-send-email-liweihang@huawei.com>
X-Mailer: git-send-email 2.8.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

GMV(GID/MAC/VLAN) table is used for HIP09 to store above information
together instead of filling them in different table respectively, so that
the users can just provide the index to the hardware when post send.

Weihang Li (2):
  RDMA/hns: Add support for configuring GMV table
  RDMA/hns: Add support for filling GMV table

 drivers/infiniband/hw/hns/hns_roce_device.h |  10 ++
 drivers/infiniband/hw/hns/hns_roce_hem.c    |  15 ++
 drivers/infiniband/hw/hns/hns_roce_hem.h    |   1 +
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c  | 222 +++++++++++++++++++++-------
 drivers/infiniband/hw/hns/hns_roce_hw_v2.h  |  60 +++++++-
 drivers/infiniband/hw/hns/hns_roce_main.c   |  26 +++-
 6 files changed, 275 insertions(+), 59 deletions(-)

-- 
2.8.1

