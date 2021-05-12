Return-Path: <linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0333C433B4
	for <linux-rdma@archiver.kernel.org>; Wed, 12 May 2021 08:16:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6C627613F8
	for <linux-rdma@archiver.kernel.org>; Wed, 12 May 2021 08:16:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230369AbhELIRa (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Wed, 12 May 2021 04:17:30 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:2453 "EHLO
        szxga07-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230367AbhELIR3 (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Wed, 12 May 2021 04:17:29 -0400
Received: from DGGEMS401-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4Fg6xc0d4bzCrZ7;
        Wed, 12 May 2021 16:13:40 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS401-HUB.china.huawei.com (10.3.19.201) with Microsoft SMTP Server id
 14.3.498.0; Wed, 12 May 2021 16:16:11 +0800
From:   Weihang Li <liweihang@huawei.com>
To:     <dledford@redhat.com>, <jgg@nvidia.com>
CC:     <leon@kernel.org>, <linux-rdma@vger.kernel.org>,
        <linuxarm@huawei.com>, Weihang Li <liweihang@huawei.com>
Subject: [PATCH for-next 0/2] RDMA/hns: Updates on link table
Date:   Wed, 12 May 2021 16:16:08 +0800
Message-ID: <1620807370-9409-1-git-send-email-liweihang@huawei.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

Do a refactor first and then remove some dead code.

Xi Wang (2):
  RDMA/hns: Refactor extend link table allocation
  RDMA/hns: Remove timeout link table for HIP08

 drivers/infiniband/hw/hns/hns_roce_device.h |   3 +-
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c  | 255 ++++++++++++----------------
 drivers/infiniband/hw/hns/hns_roce_hw_v2.h  |  72 +++-----
 3 files changed, 124 insertions(+), 206 deletions(-)

-- 
2.7.4

