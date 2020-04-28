Return-Path: <SRS0=o1Ax=6M=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5096C8300A
	for <linux-rdma@archiver.kernel.org>; Tue, 28 Apr 2020 11:04:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9EDA52072A
	for <linux-rdma@archiver.kernel.org>; Tue, 28 Apr 2020 11:04:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726364AbgD1LED (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Tue, 28 Apr 2020 07:04:03 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:3369 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726512AbgD1LED (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Tue, 28 Apr 2020 07:04:03 -0400
Received: from DGGEMS407-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id A2D477F374969E36C4EF;
        Tue, 28 Apr 2020 19:03:58 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 DGGEMS407-HUB.china.huawei.com (10.3.19.207) with Microsoft SMTP Server id
 14.3.487.0; Tue, 28 Apr 2020 19:03:48 +0800
From:   Weihang Li <liweihang@huawei.com>
To:     <dledford@redhat.com>, <jgg@ziepe.ca>
CC:     <leon@kernel.org>, <linux-rdma@vger.kernel.org>,
        <linuxarm@huawei.com>
Subject: [PATCH v4 for-next 0/5] RDMA/hns: Optimize PBL buffer allocation process
Date:   Tue, 28 Apr 2020 19:03:38 +0800
Message-ID: <1588071823-40200-1-git-send-email-liweihang@huawei.com>
X-Mailer: git-send-email 2.8.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-CFilter-Loop: Reflected
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

Patch #1 and #2 aim to use MTR interfaces for PBL buffer instead of MTT,
and after this, MTT can be removed completely. Patch #3 and #5 refactor
buffer size calculation process for WQE and SRQ. #4 can be considered as a
preparation for #5, which just moves code of SRQ together to a more
suitable place.

This series looks huge, but most of the modification is to replace and
remove old interfaces, and patch #4 also contribute a lot. Actually, the
original logic is not changed so much.

Changes since v3:
- Fix a sparce warning about a function that should be static reported by
  kbuild test robot.

Changes since v2:
- Just do a rebase to current for-next branch.

Changes since v1:
- Remove meaningless judgment of count in some inline functions in #3.
- Add more information into commit messages of #3 and #5.

Xi Wang (4):
  RDMA/hns: Optimize PBL buffer allocation process
  RDMA/hns: Remove unused MTT functions
  RDMA/hns: Optimize WQE buffer size calculating process
  RDMA/hns: Optimize SRQ buffer size calculating process

Yixian Liu (1):
  RDMA/hns: Move SRQ code to the reasonable place

 drivers/infiniband/hw/hns/hns_roce_alloc.c  |   43 -
 drivers/infiniband/hw/hns/hns_roce_device.h |  110 +--
 drivers/infiniband/hw/hns/hns_roce_hem.c    |  105 ---
 drivers/infiniband/hw/hns/hns_roce_hem.h    |    6 -
 drivers/infiniband/hw/hns/hns_roce_hw_v1.c  |   45 +-
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c  |  943 ++++++++++----------
 drivers/infiniband/hw/hns/hns_roce_main.c   |   70 +-
 drivers/infiniband/hw/hns/hns_roce_mr.c     | 1247 +++------------------------
 drivers/infiniband/hw/hns/hns_roce_qp.c     |  313 +++----
 drivers/infiniband/hw/hns/hns_roce_srq.c    |   16 +-
 10 files changed, 767 insertions(+), 2131 deletions(-)

-- 
2.8.1

