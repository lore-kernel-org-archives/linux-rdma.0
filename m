Return-Path: <SRS0=lJT2=CS=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BCC61C2D0E1
	for <linux-rdma@archiver.kernel.org>; Wed,  9 Sep 2020 08:58:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 70D2C21919
	for <linux-rdma@archiver.kernel.org>; Wed,  9 Sep 2020 08:58:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729741AbgIII64 (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Wed, 9 Sep 2020 04:58:56 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:11291 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730145AbgIII6u (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Wed, 9 Sep 2020 04:58:50 -0400
Received: from DGGEMS410-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id BE28A262946BA4DC1937;
        Wed,  9 Sep 2020 16:58:48 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 DGGEMS410-HUB.china.huawei.com (10.3.19.210) with Microsoft SMTP Server id
 14.3.487.0; Wed, 9 Sep 2020 16:58:40 +0800
From:   Weihang Li <liweihang@huawei.com>
To:     <dledford@redhat.com>, <jgg@ziepe.ca>
CC:     <leon@kernel.org>, <linux-rdma@vger.kernel.org>,
        <linuxarm@huawei.com>
Subject: [PATCH v2 for-next 0/9] RDMA/hns: Misc Updates
Date:   Wed, 9 Sep 2020 16:57:25 +0800
Message-ID: <1599641854-23160-1-git-send-email-liweihang@huawei.com>
X-Mailer: git-send-email 2.8.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-CFilter-Loop: Reflected
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

There arm some cleanups and bugfix for hns driver:
- Patch #1 ~ #5 are cleanups, include refactor, some newly added checks and
  fix for a comment.
- Patch #6 ~ #9 are miscellaneous fixes.

Previous discussion:
v1: https://patchwork.kernel.org/cover/11761647/

Changes since v1:
- Fix a missing assignment of owner_bit in set_rc_wqe()

Jiaran Zhang (2):
  RDMA/hns: Add check for the validity of sl configuration
  RDMA/hns: Solve the overflow of the calc_pg_sz()

Lang Cheng (2):
  RDMA/hns: Add type check in get/set hw field
  RDMA/hns: Correct typo of hns_roce_create_cq()

Weihang Li (3):
  RDMA/hns: Refactor process about opcode in post_send()
  RDMA/hns: Fix configuration of ack_req_freq in QPC
  RDMA/hns: Fix missing sq_sig_type when querying QP

Wenpeng Liang (1):
  RDMA/hns: Fix the wrong value of rnr_retry when querying qp

Yangyang Li (1):
  RDMA/hns: Add interception for resizing SRQs

 drivers/infiniband/hw/hns/hns_roce_common.h |  14 ++-
 drivers/infiniband/hw/hns/hns_roce_cq.c     |   2 +-
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c  | 177 ++++++++++++++++++----------
 drivers/infiniband/hw/hns/hns_roce_hw_v2.h  |   2 +
 4 files changed, 127 insertions(+), 68 deletions(-)

-- 
2.8.1

