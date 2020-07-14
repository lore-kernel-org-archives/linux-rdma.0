Return-Path: <SRS0=LoKS=AZ=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.1 required=3.0 tests=BAYES_00,
	DATE_IN_FUTURE_06_12,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA055C433E2
	for <linux-rdma@archiver.kernel.org>; Tue, 14 Jul 2020 06:57:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A1251221ED
	for <linux-rdma@archiver.kernel.org>; Tue, 14 Jul 2020 06:57:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725939AbgGNG5l (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Tue, 14 Jul 2020 02:57:41 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:7302 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725853AbgGNG5l (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Tue, 14 Jul 2020 02:57:41 -0400
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 7F2D9418D66DC7410684;
        Tue, 14 Jul 2020 14:57:38 +0800 (CST)
Received: from huawei.com (10.175.124.27) by DGGEMS411-HUB.china.huawei.com
 (10.3.19.211) with Microsoft SMTP Server id 14.3.487.0; Tue, 14 Jul 2020
 14:57:32 +0800
From:   Yang Yingliang <yangyingliang@huawei.com>
To:     <stable@vger.kernel.org>, <linux-rdma@vger.kernel.org>
CC:     <sashal@kernel.org>, <gregkh@linuxfoundation.org>,
        <dledford@redhat.com>, <jgg@ziepe.ca>, <hal.rosenstock@gmail.com>,
        <yangyingliang@huawei.com>
Subject: [PATCH stable-4.14] IB/umem: fix reference count leak in ib_umem_odp_get()
Date:   Tue, 14 Jul 2020 14:56:39 +0000
Message-ID: <20200714145639.1381719-1-yangyingliang@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.124.27]
X-CFilter-Loop: Reflected
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

Add missing mmput() on error path to avoid ref-count leak.

This problem is introduced by 79bb5b7ee177 ("RDMA/umem: Fix missing mmap_sem in get umem ODP call")
and resolved by f27a0d50a4bc ("RDMA/umem: Use umem->owning_mm inside ODP").
So, it's only needed in stable-4.14 and stable-4.19.

Fixes: 79bb5b7ee177 ("RDMA/umem: Fix missing mmap_sem in get umem ODP call")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
---
 drivers/infiniband/core/umem_odp.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/core/umem_odp.c b/drivers/infiniband/core/umem_odp.c
index eeafdc0beec7..08ef654ea9b8 100644
--- a/drivers/infiniband/core/umem_odp.c
+++ b/drivers/infiniband/core/umem_odp.c
@@ -347,7 +347,8 @@ int ib_umem_odp_get(struct ib_ucontext *context, struct ib_umem *umem,
 		vma = find_vma(mm, ib_umem_start(umem));
 		if (!vma || !is_vm_hugetlb_page(vma)) {
 			up_read(&mm->mmap_sem);
-			return -EINVAL;
+			ret_val = -EINVAL;
+			goto out_mm;
 		}
 		h = hstate_vma(vma);
 		umem->page_shift = huge_page_shift(h);
-- 
2.25.1

