Return-Path: <linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C787C43214
	for <linux-rdma@archiver.kernel.org>; Wed, 25 Aug 2021 09:47:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 61FDA61153
	for <linux-rdma@archiver.kernel.org>; Wed, 25 Aug 2021 09:47:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239525AbhHYJrx (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Wed, 25 Aug 2021 05:47:53 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:18039 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239403AbhHYJrx (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Wed, 25 Aug 2021 05:47:53 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4GvgyY0gtfzbj5m;
        Wed, 25 Aug 2021 17:43:17 +0800 (CST)
Received: from dggpeml500017.china.huawei.com (7.185.36.243) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 25 Aug 2021 17:47:03 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggpeml500017.china.huawei.com (7.185.36.243) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 25 Aug 2021 17:47:03 +0800
From:   Wenpeng Liang <liangwenpeng@huawei.com>
To:     <dledford@redhat.com>, <jgg@nvidia.com>
CC:     <linux-rdma@vger.kernel.org>, <linuxarm@huawei.com>,
        <liangwenpeng@huawei.com>
Subject: [PATCH for-next 0/3] RDMA/hns: Fix some errors in the congestion control algorithm
Date:   Wed, 25 Aug 2021 17:43:09 +0800
Message-ID: <1629884592-23424-1-git-send-email-liangwenpeng@huawei.com>
X-Mailer: git-send-email 2.8.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggpeml500017.china.huawei.com (7.185.36.243)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

Fix three dip_idx related errors.

Junxian Huang (3):
  RDMA/hns: Bugfix for data type of dip_idx
  RDMA/hns: Bugfix for the missing assignment for dip_idx
  RDMA/hns: Bugfix for incorrect association between dip_idx and dgid

 drivers/infiniband/hw/hns/hns_roce_device.h |  9 ++++++++-
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c  | 13 +++++++++++--
 drivers/infiniband/hw/hns/hns_roce_hw_v2.h  |  2 +-
 drivers/infiniband/hw/hns/hns_roce_main.c   |  8 ++++++--
 drivers/infiniband/hw/hns/hns_roce_qp.c     | 10 +++++++++-
 5 files changed, 35 insertions(+), 7 deletions(-)

--
2.8.1

