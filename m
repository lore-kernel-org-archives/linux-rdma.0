Return-Path: <SRS0=Pj7p=WE=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06435C433FF
	for <linux-rdma@archiver.kernel.org>; Thu,  8 Aug 2019 14:58:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D2C0021883
	for <linux-rdma@archiver.kernel.org>; Thu,  8 Aug 2019 14:58:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733142AbfHHO6R (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Thu, 8 Aug 2019 10:58:17 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:4201 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1732667AbfHHO6R (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Thu, 8 Aug 2019 10:58:17 -0400
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 5A224DD422F73A2A8244;
        Thu,  8 Aug 2019 22:58:12 +0800 (CST)
Received: from linux-ioko.site (10.71.200.31) by
 DGGEMS403-HUB.china.huawei.com (10.3.19.203) with Microsoft SMTP Server id
 14.3.439.0; Thu, 8 Aug 2019 22:58:04 +0800
From:   Lijun Ou <oulijun@huawei.com>
To:     <dledford@redhat.com>, <jgg@ziepe.ca>
CC:     <leon@kernel.org>, <linux-rdma@vger.kernel.org>,
        <linuxarm@huawei.com>
Subject: [PATCH V4 for-next 00/14] Updates for 5.3-rc2
Date:   Thu, 8 Aug 2019 22:53:40 +0800
Message-ID: <1565276034-97329-1-git-send-email-oulijun@huawei.com>
X-Mailer: git-send-email 1.9.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.71.200.31]
X-CFilter-Loop: Reflected
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

Here are some updates for hns driver based 5.3-rc2, mainly
include some codes optimization and comments style modification.

Change from V3:
1. Separate ibdev print replace for a single patch
2. Fix the comments gived by Doug Ledford

Change from V2:
1. Remove the unncessary memset opertion for the tenth patch

Change from V1:
1. Fix the checkpatch warning
2. Use ibdev print interface instead of dev print interface in
   this patchset.

Lang Cheng (6):
  RDMA/hns: Clean up unnecessary initial assignment
  RDMA/hns: Update some comments style
  RDMA/hns: Handling the error return value of hem function
  RDMA/hns: Split bool statement and assign statement
  RDMA/hns: Refactor irq request code
  RDMA/hns: Remove unnecessary kzalloc

Lijun Ou (3):
  RDMA/hns: Encapsulate some lines for setting sq size in user mode
  RDMA/hns: Optimize hns_roce_modify_qp function
  RDMA/hns: Use the new APIs for printing log

Weihang Li (2):
  RDMA/hns: Remove redundant print in hns_roce_v2_ceq_int()
  RDMA/hns: Disable alw_lcl_lpbk of SSU

Yangyang Li (1):
  RDMA/hns: Refactor hns_roce_v2_set_hem for hip08

Yixian Liu (2):
  RDMA/hns: Update the prompt message for creating and destroy qp
  RDMA/hns: Remove unnessary init for cmq reg

 drivers/infiniband/hw/hns/hns_roce_device.h |  65 +++++----
 drivers/infiniband/hw/hns/hns_roce_hem.c    |  15 +-
 drivers/infiniband/hw/hns/hns_roce_hem.h    |   6 +-
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c  | 212 ++++++++++++++--------------
 drivers/infiniband/hw/hns/hns_roce_hw_v2.h  |   2 -
 drivers/infiniband/hw/hns/hns_roce_mr.c     |   1 -
 drivers/infiniband/hw/hns/hns_roce_qp.c     | 176 ++++++++++++++---------
 7 files changed, 258 insertions(+), 219 deletions(-)

-- 
1.9.1

