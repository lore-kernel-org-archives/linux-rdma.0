Return-Path: <linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2050C433B4
	for <linux-rdma@archiver.kernel.org>; Thu,  1 Apr 2021 07:36:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8716B61029
	for <linux-rdma@archiver.kernel.org>; Thu,  1 Apr 2021 07:36:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230291AbhDAHfb (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Thu, 1 Apr 2021 03:35:31 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:14662 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233438AbhDAHfF (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Thu, 1 Apr 2021 03:35:05 -0400
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4F9vyp5RCQznWTV;
        Thu,  1 Apr 2021 15:32:18 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 DGGEMS409-HUB.china.huawei.com (10.3.19.209) with Microsoft SMTP Server id
 14.3.498.0; Thu, 1 Apr 2021 15:34:51 +0800
From:   Weihang Li <liweihang@huawei.com>
To:     <dledford@redhat.com>, <jgg@nvidia.com>
CC:     <leon@kernel.org>, <linux-rdma@vger.kernel.org>,
        <linuxarm@huawei.com>
Subject: [PATCH for-next 0/3] RDMA/hns: Updates of CMDQ
Date:   Thu, 1 Apr 2021 15:32:18 +0800
Message-ID: <1617262341-37571-1-git-send-email-liweihang@huawei.com>
X-Mailer: git-send-email 2.8.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

This series contains few changes about CMDQ of HIP08/09. The ibdev may be
null while the driver is resetting, so we don't use ibdev_err for prints.

Lang Cheng (2):
  RDMA/hns: Enable all CMDQ context
  RDMA/hns: Support more return types of command queue

Wenpeng Liang (1):
  RDMA/hns: Modify prints for mailbox and command queue

 drivers/infiniband/hw/hns/hns_roce_cmd.c    | 79 ++++++++++++++---------------
 drivers/infiniband/hw/hns/hns_roce_device.h |  6 +--
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c  |  9 +++-
 drivers/infiniband/hw/hns/hns_roce_hw_v2.h  | 18 +++++--
 4 files changed, 59 insertions(+), 53 deletions(-)

-- 
2.8.1

