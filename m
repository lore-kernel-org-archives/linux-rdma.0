Return-Path: <linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52059ECAAD5
	for <linux-rdma@archiver.kernel.org>; Mon, 29 Aug 2022 10:51:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229762AbiH2KvC (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Mon, 29 Aug 2022 06:51:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229790AbiH2KvB (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Mon, 29 Aug 2022 06:51:01 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FBEA1AD9C
        for <linux-rdma@vger.kernel.org>; Mon, 29 Aug 2022 03:51:00 -0700 (PDT)
Received: from dggpeml500023.china.huawei.com (unknown [172.30.72.57])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4MGRxY2mQZznTrj;
        Mon, 29 Aug 2022 18:48:33 +0800 (CST)
Received: from dggpeml500017.china.huawei.com (7.185.36.243) by
 dggpeml500023.china.huawei.com (7.185.36.114) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Mon, 29 Aug 2022 18:50:57 +0800
Received: from localhost.localdomain (10.67.165.2) by
 dggpeml500017.china.huawei.com (7.185.36.243) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Mon, 29 Aug 2022 18:50:57 +0800
From:   Wenpeng Liang <liangwenpeng@huawei.com>
To:     <jgg@nvidia.com>, <leon@kernel.org>
CC:     <linux-rdma@vger.kernel.org>, <linuxarm@huawei.com>,
        <liangwenpeng@huawei.com>
Subject: [PATCH for-next 0/4] RDMA/hns: Bugfixes or cleanups for resource specs or numbers
Date:   Mon, 29 Aug 2022 18:50:17 +0800
Message-ID: <20220829105021.1427804-1-liangwenpeng@huawei.com>
X-Mailer: git-send-email 2.30.0
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.67.165.2]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggpeml500017.china.huawei.com (7.185.36.243)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

The following is the outline of each patch:
(1)#1~#3: The earliest code sets the resource specification incorrectly.
(2)#4: The earliest code used this parameter, but the latest code no longer
       needs it.

Chengchang Tang (1):
  RDMA/hns: Fix supported page size

Wenpeng Liang (2):
  RDMA/hns: Fix wrong fixed value of qp->rq.wqe_shift
  RDMA/hns: Remove redundant member doorbell_qpn of struct hns_roce_qp

Yixing Liu (1):
  RDMA/hns: Remove the num_qpc_timer variable

 drivers/infiniband/hw/hns/hns_roce_device.h |  2 --
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c  |  5 ++---
 drivers/infiniband/hw/hns/hns_roce_hw_v2.h  |  4 ++--
 drivers/infiniband/hw/hns/hns_roce_main.c   |  2 +-
 drivers/infiniband/hw/hns/hns_roce_qp.c     | 10 ++--------
 5 files changed, 7 insertions(+), 16 deletions(-)

--
2.30.0

