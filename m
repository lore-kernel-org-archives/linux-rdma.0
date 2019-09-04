Return-Path: <SRS0=wk0f=W7=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B44EC3A5A2
	for <linux-rdma@archiver.kernel.org>; Wed,  4 Sep 2019 03:18:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 096CD22CEA
	for <linux-rdma@archiver.kernel.org>; Wed,  4 Sep 2019 03:18:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727940AbfIDDSK (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Tue, 3 Sep 2019 23:18:10 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:49682 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727709AbfIDDSK (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Tue, 3 Sep 2019 23:18:10 -0400
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 8B7F217842C9A297495E;
        Wed,  4 Sep 2019 11:18:08 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 DGGEMS409-HUB.china.huawei.com (10.3.19.209) with Microsoft SMTP Server id
 14.3.439.0; Wed, 4 Sep 2019 11:17:59 +0800
From:   Weihang Li <liweihang@hisilicon.com>
To:     <dledford@redhat.com>, <jgg@ziepe.ca>
CC:     <linux-rdma@vger.kernel.org>, <linuxarm@huawei.com>
Subject: [PATCH for-next 0/5] Some bugfixes and cleanups for hip08
Date:   Wed, 4 Sep 2019 11:14:40 +0800
Message-ID: <1567566885-23088-1-git-send-email-liweihang@hisilicon.com>
X-Mailer: git-send-email 2.8.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-CFilter-Loop: Reflected
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

This patchset fixes two bugs in previous patches, and does some cleanups
to increase readability.

Lang Cheng (1):
  RDMA/hns: Modify return value of restrack fucntions

Weihang Li (3):
  RDMA/hns: remove a redundant le16_to_cpu
  RDMA/hns: Fix wrong parameters when initial mtt of srq->idx_que
  RDMA/hns: Modify variable/field name from vlan to vlan_id

Yixing Liu (1):
  RDMA/hns: Fix a spelling mistake in a macro

 drivers/infiniband/hw/hns/hns_roce_ah.c       | 14 +++++++-------
 drivers/infiniband/hw/hns/hns_roce_device.h   |  4 ++--
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c    | 10 +++++-----
 drivers/infiniband/hw/hns/hns_roce_qp.c       | 24 ++++++++++++------------
 drivers/infiniband/hw/hns/hns_roce_restrack.c |  2 +-
 drivers/infiniband/hw/hns/hns_roce_srq.c      | 24 ++++++++++++++----------
 6 files changed, 41 insertions(+), 37 deletions(-)

-- 
2.8.1

