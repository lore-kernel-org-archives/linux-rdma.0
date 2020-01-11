Return-Path: <SRS0=TJc5=3A=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E5F2C33CA4
	for <linux-rdma@archiver.kernel.org>; Sat, 11 Jan 2020 10:36:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4E28B208E4
	for <linux-rdma@archiver.kernel.org>; Sat, 11 Jan 2020 10:36:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728861AbgAKKgf (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Sat, 11 Jan 2020 05:36:35 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:9156 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729408AbgAKKgf (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Sat, 11 Jan 2020 05:36:35 -0500
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 45C9FDC514740EBB6DA4;
        Sat, 11 Jan 2020 18:36:33 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 DGGEMS411-HUB.china.huawei.com (10.3.19.211) with Microsoft SMTP Server id
 14.3.439.0; Sat, 11 Jan 2020 18:36:25 +0800
From:   Weihang Li <liweihang@huawei.com>
To:     <dledford@redhat.com>, <jgg@ziepe.ca>
CC:     <leon@kernel.org>, <linux-rdma@vger.kernel.org>,
        <linuxarm@huawei.com>
Subject: [PATCH for-next 0/3] RDMA/hns: Get pf capabilities from firmware
Date:   Sat, 11 Jan 2020 18:32:38 +0800
Message-ID: <1578738761-3176-1-git-send-email-liweihang@huawei.com>
X-Mailer: git-send-email 2.8.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-CFilter-Loop: Reflected
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

This series add new interfaces to get capablities from firmware of
different types of hardware. If it fails, all capabilities will be set
with a default value. In addition, we remove some redundant fields in
struct hns_roce_caps.

Lijun Ou (2):
  RDMA/hns: Add interfaces to get pf capabilities from firmware
  RDMA/hns: Get pf capabilities from firmware

Weihang Li (1):
  RDMA/hns: Remove some redundant variables related to capbilities

 drivers/infiniband/hw/hns/hns_roce_device.h |   9 +-
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c  | 437 ++++++++++++++++++++++------
 drivers/infiniband/hw/hns/hns_roce_hw_v2.h  | 156 ++++++++++
 drivers/infiniband/hw/hns/hns_roce_main.c   |   2 +-
 4 files changed, 511 insertions(+), 93 deletions(-)

-- 
2.8.1

