Return-Path: <linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D7B2C47087
	for <linux-rdma@archiver.kernel.org>; Fri, 28 May 2021 09:38:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1B72D6128B
	for <linux-rdma@archiver.kernel.org>; Fri, 28 May 2021 09:38:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236041AbhE1Jje (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Fri, 28 May 2021 05:39:34 -0400
Received: from szxga08-in.huawei.com ([45.249.212.255]:2334 "EHLO
        szxga08-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235640AbhE1Jjb (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Fri, 28 May 2021 05:39:31 -0400
Received: from dggeml767-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4Frzy72Z6bz1BFvY;
        Fri, 28 May 2021 17:33:19 +0800 (CST)
Received: from dggema753-chm.china.huawei.com (10.1.198.195) by
 dggeml767-chm.china.huawei.com (10.1.199.177) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Fri, 28 May 2021 17:37:55 +0800
Received: from localhost.localdomain (10.69.192.56) by
 dggema753-chm.china.huawei.com (10.1.198.195) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Fri, 28 May 2021 17:37:55 +0800
From:   Weihang Li <liweihang@huawei.com>
To:     <dledford@redhat.com>, <jgg@nvidia.com>
CC:     <leon@kernel.org>, <linux-rdma@vger.kernel.org>,
        <linuxarm@huawei.com>, Weihang Li <liweihang@huawei.com>
Subject: [PATCH v4 for-next 00/12] RDMA: Use refcount_t for reference counting
Date:   Fri, 28 May 2021 17:37:31 +0800
Message-ID: <1622194663-2383-1-git-send-email-liweihang@huawei.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggema753-chm.china.huawei.com (10.1.198.195)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

There are some refcnt in type of atomic_t in RDMA subsystem, almost all of
them is wrote before the refcount_t is acheived in kernel. refcount_t is
better than integer for reference counting, it will WARN on
overflow/underflow and avoid use-after-free risks.

Changes since v3:
* Drop the rdmavt patch because the refcount_t is not suitable for the
  logic.
* Link: https://patchwork.kernel.org/project/linux-rdma/cover/1621925504-33019-1-git-send-email-liweihang@huawei.com/

Changes since v2:
* Drop i40iw related parts because this driver will be removed soon.
* Link: https://patchwork.kernel.org/project/linux-rdma/cover/1621590825-60693-1-git-send-email-liweihang@huawei.com/

Changes since v1:
* Split these patches by variable granularity.
* Fix a warning on refcount of struct mcast_group.
* Add a patch on rdmavt.
* Drop "RDMA/hns: Use refcount_t APIs for HEM".
* Link: https://patchwork.kernel.org/project/linux-rdma/cover/1620958299-4869-1-git-send-email-liweihang@huawei.com/


Weihang Li (12):
  RDMA/core: Use refcount_t instead of atomic_t on refcount of
    iwcm_id_private
  RDMA/core: Use refcount_t instead of atomic_t on refcount of
    iwpm_admin_data
  RDMA/core: Use refcount_t instead of atomic_t on refcount of
    ib_mad_snoop_private
  RDMA/core: Use refcount_t instead of atomic_t on refcount of
    mcast_member
  RDMA/core: Use refcount_t instead of atomic_t on refcount of
    mcast_port
  RDMA/core: Use refcount_t instead of atomic_t on refcount of
    mcast_group
  RDMA/core: Use refcount_t instead of atomic_t on refcount of
    ib_uverbs_device
  RDMA/hns: Use refcount_t instead of atomic_t for CQ reference counting
  RDMA/hns: Use refcount_t instead of atomic_t for SRQ reference
    counting
  RDMA/hns: Use refcount_t instead of atomic_t for QP reference counting
  RDMA/cxgb4: Use refcount_t instead of atomic_t for reference counting
  RDMA/ipoib: Use refcount_t instead of atomic_t for reference counting

 drivers/infiniband/core/iwcm.c              |  9 ++++---
 drivers/infiniband/core/iwcm.h              |  2 +-
 drivers/infiniband/core/iwpm_util.c         | 12 ++++++----
 drivers/infiniband/core/iwpm_util.h         |  2 +-
 drivers/infiniband/core/mad_priv.h          |  2 +-
 drivers/infiniband/core/multicast.c         | 37 ++++++++++++++++-------------
 drivers/infiniband/core/uverbs.h            |  2 +-
 drivers/infiniband/core/uverbs_main.c       | 12 +++++-----
 drivers/infiniband/hw/cxgb4/cq.c            |  6 ++---
 drivers/infiniband/hw/cxgb4/ev.c            |  8 +++----
 drivers/infiniband/hw/cxgb4/iw_cxgb4.h      |  2 +-
 drivers/infiniband/hw/hns/hns_roce_cq.c     |  8 +++----
 drivers/infiniband/hw/hns/hns_roce_device.h |  6 ++---
 drivers/infiniband/hw/hns/hns_roce_qp.c     | 12 +++++-----
 drivers/infiniband/hw/hns/hns_roce_srq.c    |  8 +++----
 drivers/infiniband/ulp/ipoib/ipoib.h        |  4 ++--
 drivers/infiniband/ulp/ipoib/ipoib_main.c   |  8 +++----
 17 files changed, 74 insertions(+), 66 deletions(-)

-- 
2.7.4

