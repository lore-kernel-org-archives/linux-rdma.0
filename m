Return-Path: <linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9C89C433F5
	for <linux-rdma@archiver.kernel.org>; Thu, 30 Sep 2021 08:42:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 84C4D61261
	for <linux-rdma@archiver.kernel.org>; Thu, 30 Sep 2021 08:42:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348681AbhI3Ino (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Thu, 30 Sep 2021 04:43:44 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:27944 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348487AbhI3Ino (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Thu, 30 Sep 2021 04:43:44 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4HKmpG3N78zbmyk;
        Thu, 30 Sep 2021 16:37:42 +0800 (CST)
Received: from dggpeml500017.china.huawei.com (7.185.36.243) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Thu, 30 Sep 2021 16:41:56 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggpeml500017.china.huawei.com (7.185.36.243) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Thu, 30 Sep 2021 16:41:56 +0800
From:   Wenpeng Liang <liangwenpeng@huawei.com>
To:     <jgg@nvidia.com>, <leon@kernel.org>
CC:     <linux-rdma@vger.kernel.org>, <linuxarm@huawei.com>
Subject: [PATCH rdma-core 0/2] libhns: Add a new mmap implementation
Date:   Thu, 30 Sep 2021 16:37:44 +0800
Message-ID: <20210930083746.19136-1-liangwenpeng@huawei.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggpeml500017.china.huawei.com (7.185.36.243)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

Add a new mmap implementation for hns by using the new mmap entry API.

The "context->cq_tptr_base" is useless code and will be deleted later, so
its mmap implementation is no longer considered.

The related kernelspace series is named "RDMA/hns: Add a new mmap implementation".

Chengchang Tang (1):
  libhns: Add a new mmap implementation

Wenpeng Liang (1):
  Update kernel headers

 kernel-headers/CMakeLists.txt   |  5 ++
 kernel-headers/rdma/hns-abi.h   | 21 +++++++-
 kernel-headers/rdma/irdma-abi.h |  2 +-
 providers/hns/hns_roce_u.c      | 86 ++++++++++++++++++++++++---------
 providers/hns/hns_roce_u.h      |  1 +
 providers/hns/hns_roce_u_abi.h  |  2 +-
 6 files changed, 90 insertions(+), 27 deletions(-)

--
2.33.0

