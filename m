Return-Path: <linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A821C8301F
	for <linux-rdma@archiver.kernel.org>; Sat, 28 Nov 2020 22:05:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F37BA24640
	for <linux-rdma@archiver.kernel.org>; Sat, 28 Nov 2020 22:05:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730418AbgK1VuZ (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Sat, 28 Nov 2020 16:50:25 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:8162 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730425AbgK1SlC (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Sat, 28 Nov 2020 13:41:02 -0500
Received: from DGGEMS401-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4CjnfC0QHFz15LLm;
        Sat, 28 Nov 2020 18:24:03 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 DGGEMS401-HUB.china.huawei.com (10.3.19.201) with Microsoft SMTP Server id
 14.3.487.0; Sat, 28 Nov 2020 18:24:18 +0800
From:   Weihang Li <liweihang@huawei.com>
To:     <dledford@redhat.com>, <jgg@ziepe.ca>
CC:     <leon@kernel.org>, <linux-rdma@vger.kernel.org>,
        <linuxarm@huawei.com>
Subject: [PATCH for-next 0/3] RDMA/hns: Fixes for calculation of sge
Date:   Sat, 28 Nov 2020 18:22:36 +0800
Message-ID: <1606558959-48510-1-git-send-email-liweihang@huawei.com>
X-Mailer: git-send-email 2.8.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

There are two issues with calculation of extended sge, one is about page
alignment and another is about the 0-length sges. Then, the path #3
refactor the code.

Lang Cheng (1):
  RDMA/hns: Fix 0-length sge calculation error

Weihang Li (1):
  RDMA/hns: Refactor process of setting extended sge

Yangyang Li (1):
  RDMA/hns: Bugfix for calculation of extended sge

 drivers/infiniband/hw/hns/hns_roce_hw_v2.c | 24 +++++-------
 drivers/infiniband/hw/hns/hns_roce_qp.c    | 61 +++++++++++++++---------------
 2 files changed, 41 insertions(+), 44 deletions(-)

-- 
2.8.1

