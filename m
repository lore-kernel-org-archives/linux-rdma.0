Return-Path: <SRS0=2yMC=XQ=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C50EBC49ED7
	for <linux-rdma@archiver.kernel.org>; Sat, 21 Sep 2019 07:06:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A30B82086A
	for <linux-rdma@archiver.kernel.org>; Sat, 21 Sep 2019 07:06:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437662AbfIUHGo (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Sat, 21 Sep 2019 03:06:44 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:2760 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2437304AbfIUHGn (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Sat, 21 Sep 2019 03:06:43 -0400
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 14F45CDDD8B997AC9757;
        Sat, 21 Sep 2019 15:06:42 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 DGGEMS403-HUB.china.huawei.com (10.3.19.203) with Microsoft SMTP Server id
 14.3.439.0; Sat, 21 Sep 2019 15:06:31 +0800
From:   <liweihang@hisilicon.com>
To:     <dledford@redhat.com>, <jgg@ziepe.ca>
CC:     <linux-rdma@vger.kernel.org>, <linuxarm@huawei.com>
Subject: [PATCH v2 rdma-core 0/5] Support UD on hip08
Date:   Sat, 21 Sep 2019 15:03:08 +0800
Message-ID: <1569049393-10395-1-git-send-email-liweihang@hisilicon.com>
X-Mailer: git-send-email 2.8.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-CFilter-Loop: Reflected
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

From: Weihang Li <liweihang@hisilicon.com>

This patchset enables hip08 to support Unreliable Datagram.

PR: https://github.com/linux-rdma/rdma-core/pull/575

Changelog:
v1->v2: Fix comments from Leon Romanovsky and do some fixes in patch(3/5).

Lijun Ou (2):
  libhns: Add support of handling AH for hip08
  libhns: Add UD support for hip08 in user mode

Weihang Li (1):
  libhns: Support configuring loopback mode by user

Yixian Liu (2):
  libhns: Bugfix for wqe idx calc of post verbs
  libhns: Refactor for post send

 kernel-headers/rdma/hns-abi.h    |   7 +
 providers/hns/hns_roce_u.c       |  17 ++
 providers/hns/hns_roce_u.h       |  42 +++
 providers/hns/hns_roce_u_abi.h   |   3 +-
 providers/hns/hns_roce_u_hw_v1.c |  27 +-
 providers/hns/hns_roce_u_hw_v2.c | 574 +++++++++++++++++++++------------------
 providers/hns/hns_roce_u_hw_v2.h |  91 +++++++
 providers/hns/hns_roce_u_verbs.c |  60 ++++
 8 files changed, 535 insertions(+), 286 deletions(-)

-- 
2.8.1

