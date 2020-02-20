Return-Path: <SRS0=rt4E=4I=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7186C761A1
	for <linux-rdma@archiver.kernel.org>; Thu, 20 Feb 2020 03:00:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AFCF124671
	for <linux-rdma@archiver.kernel.org>; Thu, 20 Feb 2020 03:00:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727469AbgBTDAV (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Wed, 19 Feb 2020 22:00:21 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:10646 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727208AbgBTDAV (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Wed, 19 Feb 2020 22:00:21 -0500
Received: from DGGEMS401-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 171C6883C30BB2C6B99C;
        Thu, 20 Feb 2020 11:00:18 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 DGGEMS401-HUB.china.huawei.com (10.3.19.201) with Microsoft SMTP Server id
 14.3.439.0; Thu, 20 Feb 2020 11:00:07 +0800
From:   Weihang Li <liweihang@huawei.com>
To:     <dledford@redhat.com>, <jgg@ziepe.ca>
CC:     <leon@kernel.org>, <linux-rdma@vger.kernel.org>,
        <linuxarm@huawei.com>
Subject: [PATCH v3 for-next 0/7] RDMA/hns: Refactor qp related code
Date:   Thu, 20 Feb 2020 10:56:00 +0800
Message-ID: <1582167367-50380-1-git-send-email-liweihang@huawei.com>
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
https://patchwork.kernel.org/cover/11372841/
https://patchwork.kernel.org/cover/11341265/

Changes since v2:
- Change some macros into static inline functions as Jason suggested.
- Unify all prints into format of "Failed to xxx".
- Rebase against Jason's for-next branch.

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
 drivers/infiniband/hw/hns/hns_roce_qp.c     | 808 ++++++++++++++++------------
 4 files changed, 465 insertions(+), 411 deletions(-)

-- 
2.8.1

