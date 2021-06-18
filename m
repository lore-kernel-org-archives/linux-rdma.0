Return-Path: <linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43FB2C49361
	for <linux-rdma@archiver.kernel.org>; Fri, 18 Jun 2021 10:06:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 21A2F60C41
	for <linux-rdma@archiver.kernel.org>; Fri, 18 Jun 2021 10:06:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231565AbhFRKJB (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Fri, 18 Jun 2021 06:09:01 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:11065 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232016AbhFRKIn (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Fri, 18 Jun 2021 06:08:43 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4G5vdM4S5rzZgCg;
        Fri, 18 Jun 2021 18:03:35 +0800 (CST)
Received: from dggema753-chm.china.huawei.com (10.1.198.195) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Fri, 18 Jun 2021 18:06:32 +0800
Received: from localhost.localdomain (10.69.192.56) by
 dggema753-chm.china.huawei.com (10.1.198.195) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Fri, 18 Jun 2021 18:06:32 +0800
From:   Weihang Li <liweihang@huawei.com>
To:     <dledford@redhat.com>, <jgg@nvidia.com>
CC:     <leon@kernel.org>, <linux-rdma@vger.kernel.org>,
        <linuxarm@huawei.com>, Weihang Li <liweihang@huawei.com>
Subject: [PATCH v4 for-next 0/8] RDMA/hns: Use new interfaces to write/read fields
Date:   Fri, 18 Jun 2021 18:05:57 +0800
Message-ID: <1624010765-1029-1-git-send-email-liweihang@huawei.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggema753-chm.china.huawei.com (10.1.198.195)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

hr_reg_*() is simpler than roce_set_*(), and the field/bit can be generated
automatically and accurately. This series first fix two issues on
hr_reg_*(), then do the replacement.

Changes since v3:
* Use "val ? 1 : 0" instead of "!!val" for hr_reg_write to avoid sparse
  warnings.
* Link: https://patchwork.kernel.org/project/linux-rdma/cover/1623915111-43630-1-git-send-email-liweihang@huawei.com/

Changes since v2:
* Add a patch to solve the gcc warnings about PREP_FIELD() by adding a
  check for mtu. Therefore only the parts which fix the sparse warning is
  reserved in #1.
* Link: https://patchwork.kernel.org/project/linux-rdma/cover/1622624265-44796-1-git-send-email-liweihang@huawei.com/

Changes since v1:
* Add a patch to fix gcc warnings about PREP_FIELD().
* Fix a typo in #5.
* Link: https://patchwork.kernel.org/project/linux-rdma/cover/1622281154-49867-1-git-send-email-liweihang@huawei.com/

Lang Cheng (2):
  RDMA/hns: Use new interface to modify QP context
  RDMA/hns: Use new interface to get CQE fields

Weihang Li (2):
  RDMA/hns: Fix sparse warnings about hr_reg_write()
  RDMA/hns: Add a check to ensure integer mtu is positive

Xi Wang (1):
  RDMA/hns: Clean SRQC structure definition

Yixing Liu (3):
  RDMA/hns: Use new interface to write CQ context.
  RDMA/hns: Use new interface to write FRMR fields
  RDMA/hns: Use new interface to write DB related fields

 drivers/infiniband/hw/hns/hns_roce_hw_v2.c | 1110 ++++++++++------------------
 drivers/infiniband/hw/hns/hns_roce_hw_v2.h |  862 +++++++--------------
 2 files changed, 667 insertions(+), 1305 deletions(-)

-- 
2.7.4

