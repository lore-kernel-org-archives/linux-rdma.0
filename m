Return-Path: <linux-rdma-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7172EEB64DC
	for <linux-rdma@archiver.kernel.org>; Mon, 17 Jul 2023 06:06:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231397AbjGQGGV (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Mon, 17 Jul 2023 02:06:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231287AbjGQGGP (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Mon, 17 Jul 2023 02:06:15 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D337CE60;
        Sun, 16 Jul 2023 23:06:13 -0700 (PDT)
Received: from kwepemi500006.china.huawei.com (unknown [172.30.72.56])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4R4BMH0WrRzNmFK;
        Mon, 17 Jul 2023 14:02:51 +0800 (CST)
Received: from localhost.localdomain (10.67.165.2) by
 kwepemi500006.china.huawei.com (7.221.188.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Mon, 17 Jul 2023 14:06:09 +0800
From:   Junxian Huang <huangjunxian6@hisilicon.com>
To:     <jgg@nvidia.com>, <leon@kernel.org>
CC:     <linux-rdma@vger.kernel.org>, <linuxarm@huawei.com>,
        <linux-kernel@vger.kernel.org>, <huangjunxian6@hisilicon.com>
Subject: [PATCH v2 for-rc 0/3] RDMA/hns: Improvements for function resource configuration
Date:   Mon, 17 Jul 2023 14:03:37 +0800
Message-ID: <20230717060340.453850-1-huangjunxian6@hisilicon.com>
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

Here are 3 patches involving function resource configuration.

1. #1: The first patch supports getting xrcd num from firmware.

2. #2: The second patch removes a redundant configuration in driver,
       which is now handled by firmware.

3. #3: The third patch adds validity check for function resource and
       adjusts the invalid ones.

V2 removes 'inline' before function names in the third patch.

Junxian Huang (2):
  RDMA/hns: Remove VF extend configuration
  RDMA/hns: Add check and adjust for function resource values

Luoyouming (1):
  RDMA/hns: support get xrcd num from firmware

 drivers/infiniband/hw/hns/hns_roce_device.h |   1 -
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c  | 194 ++++++++++++--------
 drivers/infiniband/hw/hns/hns_roce_hw_v2.h  |  50 +++--
 3 files changed, 157 insertions(+), 88 deletions(-)

--
2.30.0

