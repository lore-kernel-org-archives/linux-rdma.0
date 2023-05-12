Return-Path: <linux-rdma-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5BEEC7EE25
	for <linux-rdma@archiver.kernel.org>; Fri, 12 May 2023 09:24:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240418AbjELJYw (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Fri, 12 May 2023 05:24:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240343AbjELJYt (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Fri, 12 May 2023 05:24:49 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C32A0E702;
        Fri, 12 May 2023 02:24:46 -0700 (PDT)
Received: from kwepemi500006.china.huawei.com (unknown [172.30.72.55])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4QHjsp3xbkzqSKb;
        Fri, 12 May 2023 17:20:30 +0800 (CST)
Received: from localhost.localdomain (10.67.165.2) by
 kwepemi500006.china.huawei.com (7.221.188.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Fri, 12 May 2023 17:24:44 +0800
From:   Junxian Huang <huangjunxian6@hisilicon.com>
To:     <jgg@nvidia.com>, <leon@kernel.org>
CC:     <linux-rdma@vger.kernel.org>, <linuxarm@huawei.com>,
        <linux-kernel@vger.kernel.org>, <huangjunxian6@hisilicon.com>
Subject: [PATCH for-rc 0/3] Bugfixes for HNS RoCE
Date:   Fri, 12 May 2023 17:22:42 +0800
Message-ID: <20230512092245.344442-1-huangjunxian6@hisilicon.com>
X-Mailer: git-send-email 2.30.0
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.67.165.2]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 kwepemi500006.china.huawei.com (7.221.188.68)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

1.#1: The first patch fixes an error of queried timeout attr on HIP08.

2.#2: The second patch checks and adjusts the BT page size to ensure
      successful resource allocation.

3.#3: The third patch modifies the value of long message loopback slice
      to improve traffic balance.

Chengchang Tang (2):
  RDMA/hns: Fix timeout attr in query qp for HIP08
  RDMA/hns: Fix base address table allocation

Yangyang Li (1):
  RDMA/hns: Modify the value of long message loopback slice

 drivers/infiniband/hw/hns/hns_roce_hw_v2.c | 25 +++++++++----
 drivers/infiniband/hw/hns/hns_roce_hw_v2.h |  2 +
 drivers/infiniband/hw/hns/hns_roce_mr.c    | 43 ++++++++++++++++++++++
 3 files changed, 62 insertions(+), 8 deletions(-)

--
2.30.0

