Return-Path: <SRS0=iu+b=YZ=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5FBAFCA9ECB
	for <linux-rdma@archiver.kernel.org>; Fri,  1 Nov 2019 02:37:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2E02A2083E
	for <linux-rdma@archiver.kernel.org>; Fri,  1 Nov 2019 02:37:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727486AbfKAChM (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Thu, 31 Oct 2019 22:37:12 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:5244 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727419AbfKAChM (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Thu, 31 Oct 2019 22:37:12 -0400
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 628865E24FB6613E6C25;
        Fri,  1 Nov 2019 10:37:10 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 DGGEMS404-HUB.china.huawei.com (10.3.19.204) with Microsoft SMTP Server id
 14.3.439.0; Fri, 1 Nov 2019 10:37:02 +0800
From:   Weihang Li <liweihang@hisilicon.com>
To:     <dledford@redhat.com>, <jgg@ziepe.ca>
CC:     <linux-rdma@vger.kernel.org>, <linuxarm@huawei.com>
Subject: [PATCH for-rc 0/2] RDMA/hns: Fix incorrect assignments
Date:   Fri, 1 Nov 2019 10:33:28 +0800
Message-ID: <1572575610-52530-1-git-send-email-liweihang@hisilicon.com>
X-Mailer: git-send-email 2.8.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-CFilter-Loop: Reflected
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

1. HNS_ROCE_HEM_CHUNK_LEN in patch 1/2 is used to initialize sg table, its
current value is larger than needed.
2. srq_desc_size in patch 2/2 is used to allocate srq buffer, buffer size
may be less than expected.

Sirong Wang (1):
  RDMA/hns: Correct the value of HNS_ROCE_HEM_CHUNK_LEN

Wenpeng Liang (1):
  RDMA/hns: Correct the value of srq_desc_size

 drivers/infiniband/hw/hns/hns_roce_hem.h | 2 +-
 drivers/infiniband/hw/hns/hns_roce_srq.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

-- 
2.8.1

