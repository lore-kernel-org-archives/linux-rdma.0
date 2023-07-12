Return-Path: <linux-rdma-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2FA34C001DC
	for <linux-rdma@archiver.kernel.org>; Wed, 12 Jul 2023 06:03:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232008AbjGLGDU (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Wed, 12 Jul 2023 02:03:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230329AbjGLGDQ (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Wed, 12 Jul 2023 02:03:16 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49155173F;
        Tue, 11 Jul 2023 23:03:04 -0700 (PDT)
Received: from kwepemi500006.china.huawei.com (unknown [172.30.72.53])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4R16X00kJKzMqbW;
        Wed, 12 Jul 2023 13:59:44 +0800 (CST)
Received: from localhost.localdomain (10.67.165.2) by
 kwepemi500006.china.huawei.com (7.221.188.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Wed, 12 Jul 2023 14:03:00 +0800
From:   Junxian Huang <huangjunxian6@hisilicon.com>
To:     <jgg@nvidia.com>, <leon@kernel.org>
CC:     <linux-rdma@vger.kernel.org>, <linuxarm@huawei.com>,
        <linux-kernel@vger.kernel.org>, <huangjunxian6@hisilicon.com>
Subject: [PATCH for-rc 0/3] RDMA/hns: Improvements for function resource configuration
Date:   Wed, 12 Jul 2023 14:00:30 +0800
Message-ID: <20230712060033.15961-1-huangjunxian6@hisilicon.com>
X-Mailer: git-send-email 2.30.0
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.67.165.2]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
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

Junxian Huang (2):
  RDMA/hns: Remove VF extend configuration
  RDMA/hns: Add check and adjust for function resource values

Luoyouming (1):
  RDMA/hns: support get xrcd num from firmware

 drivers/infiniband/hw/hns/hns_roce_device.h |   1 -
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c  | 195 ++++++++++++--------
 drivers/infiniband/hw/hns/hns_roce_hw_v2.h  |  50 +++--
 3 files changed, 158 insertions(+), 88 deletions(-)

--
2.30.0

