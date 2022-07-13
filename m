Return-Path: <linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 741E0C43334
	for <linux-rdma@archiver.kernel.org>; Wed, 13 Jul 2022 09:28:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230442AbiGMJ20 (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Wed, 13 Jul 2022 05:28:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230218AbiGMJ2Z (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Wed, 13 Jul 2022 05:28:25 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53A81F32E5
        for <linux-rdma@vger.kernel.org>; Wed, 13 Jul 2022 02:28:22 -0700 (PDT)
Received: from dggpeml500021.china.huawei.com (unknown [172.30.72.56])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4LjXLs5qptzlVxr;
        Wed, 13 Jul 2022 17:26:45 +0800 (CST)
Received: from dggpeml500017.china.huawei.com (7.185.36.243) by
 dggpeml500021.china.huawei.com (7.185.36.21) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Wed, 13 Jul 2022 17:28:20 +0800
Received: from localhost.localdomain (10.69.192.56) by
 dggpeml500017.china.huawei.com (7.185.36.243) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Wed, 13 Jul 2022 17:28:20 +0800
From:   Wenpeng Liang <liangwenpeng@huawei.com>
To:     <jgg@nvidia.com>, <leon@kernel.org>
CC:     <linux-rdma@vger.kernel.org>, <linuxarm@huawei.com>,
        <liangwenpeng@huawei.com>
Subject: [PATCH v2 for-next 0/5] RDMA/hns: Supports recovery of on-chip RAM 1bit ECC errors
Date:   Wed, 13 Jul 2022 17:26:25 +0800
Message-ID: <20220713092630.1657-1-liangwenpeng@huawei.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.69.192.56]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggpeml500017.china.huawei.com (7.185.36.243)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

Add support for the 1bit ECC error recovery by abnormal interrupt reporting
and adjusts the structure of the abnormal interrupt handler.

The following is the outline of each patch:
(1)#1~#4: Cleanup and bugfix for the abnormal interrupt handler.
(2)#5: Support for the 1bit ECC error recovery.

Changes since v1:
* Embed ecc_work into structure hns_roce_dev, no longer dynamically allocated in #5.
* Add the const keyword to the string array that does not change in #5.
* v1 Link: https://patchwork.kernel.org/project/linux-rdma/cover/20220624110845.48184-1-liangwenpeng@huawei.com/

Haoyue Xu (5):
  RDMA/hns: Remove unused abnormal interrupt of type RAS
  RDMA/hns: Fix the wrong type of return value of the interrupt handler
  RDMA/hns: Fix incorrect clearing of interrupt status register
  RDMA/hns: Refactor the abnormal interrupt handler function
  RDMA/hns: Recover 1bit-ECC error of RAM on chip

 drivers/infiniband/hw/hns/hns_roce_device.h |   1 +
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c  | 250 +++++++++++++++++---
 drivers/infiniband/hw/hns/hns_roce_hw_v2.h  |  13 +-
 3 files changed, 229 insertions(+), 35 deletions(-)

--
2.33.0

