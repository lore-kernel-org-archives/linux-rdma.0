Return-Path: <SRS0=ApCo=YT=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A628CA9EBD
	for <linux-rdma@archiver.kernel.org>; Sat, 26 Oct 2019 07:00:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 09792222BD
	for <linux-rdma@archiver.kernel.org>; Sat, 26 Oct 2019 07:00:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726010AbfJZHAP (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Sat, 26 Oct 2019 03:00:15 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:56884 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726189AbfJZHAP (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Sat, 26 Oct 2019 03:00:15 -0400
Received: from DGGEMS408-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id CA10A1A611DBFC48BA22;
        Sat, 26 Oct 2019 15:00:12 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 DGGEMS408-HUB.china.huawei.com (10.3.19.208) with Microsoft SMTP Server id
 14.3.439.0; Sat, 26 Oct 2019 15:00:04 +0800
From:   Weihang Li <liweihang@hisilicon.com>
To:     <dledford@redhat.com>, <jgg@ziepe.ca>
CC:     <linux-rdma@vger.kernel.org>, <linuxarm@huawei.com>
Subject: [PATCH for-rc 0/2] RDMA/hns: Fix memory leaks
Date:   Sat, 26 Oct 2019 14:56:33 +0800
Message-ID: <1572072995-11277-1-git-send-email-liweihang@hisilicon.com>
X-Mailer: git-send-email 2.8.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-CFilter-Loop: Reflected
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

Fix memory leaks about mr and eq in hip08.

Lijun Ou (2):
  RDMA/hns: Fix memory leaks about mr
  RDMA/hns: Prevent memory leaks about eq

 drivers/infiniband/hw/hns/hns_roce_hw_v1.c | 8 +++++---
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c | 6 +++---
 2 files changed, 8 insertions(+), 6 deletions(-)

-- 
2.8.1

