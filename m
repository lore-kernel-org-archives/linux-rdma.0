Return-Path: <SRS0=H8yA=36=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD430C352A4
	for <linux-rdma@archiver.kernel.org>; Mon, 10 Feb 2020 09:12:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8CF7121927
	for <linux-rdma@archiver.kernel.org>; Mon, 10 Feb 2020 09:12:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726584AbgBJJMq (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Mon, 10 Feb 2020 04:12:46 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:9715 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726376AbgBJJMp (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Mon, 10 Feb 2020 04:12:45 -0500
Received: from DGGEMS407-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id A0DBA61B9E41DD77860B;
        Mon, 10 Feb 2020 17:12:43 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 DGGEMS407-HUB.china.huawei.com (10.3.19.207) with Microsoft SMTP Server id
 14.3.439.0; Mon, 10 Feb 2020 17:12:36 +0800
From:   Weihang Li <liweihang@huawei.com>
To:     <dledford@redhat.com>, <jgg@ziepe.ca>
CC:     <leon@kernel.org>, <linux-rdma@vger.kernel.org>,
        <linuxarm@huawei.com>
Subject: [PATCH v2 for-next 0/7] RDMA/hns: Refactor qp related code
Date:   Mon, 10 Feb 2020 17:08:33 +0800
Message-ID: <1581325720-12975-1-git-send-email-liweihang@huawei.com>
X-Mailer: git-send-email 2.8.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-CFilter-Loop: Reflected
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

This series refactor qp related code, including creating, destroying qp and
so on to make the processs easier to understand and maintain.

Previous disscussion can be found at:
https://patchwork.kernel.org/cover/11341265/

Changes since v1:
- Reduce the number of prints as Leon suggested.
- Fix a wrong function name in description of patch 4/7.

Xi Wang (7):
  RDMA/hns: Optimize qp destroy flow
  RDMA/hns: Optimize qp context create and destroy flow
  RDMA/hns: Optimize qp number assign flow
  RDMA/hns: Optimize qp buffer allocation flow
  RDMA/hns: Optimize qp param setup flow
  RDMA/hns: Optimize kernel qp wrid allocation flow
  RDMA/hns: Optimize qp doorbell allocation flow

 drivers/infiniband/hw/hns/hns_roce_device.h |   6 +-
 drivers/infiniband/hw/hns/hns_roce_hw_v1.c  |  19 +-
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c  |  43 +-
 drivers/infiniband/hw/hns/hns_roce_qp.c     | 788 ++++++++++++++++------------
 4 files changed, 446 insertions(+), 410 deletions(-)

-- 
2.8.1

