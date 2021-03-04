Return-Path: <linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92231C433E0
	for <linux-rdma@archiver.kernel.org>; Thu,  4 Mar 2021 13:06:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 63AA564F04
	for <linux-rdma@archiver.kernel.org>; Thu,  4 Mar 2021 13:06:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241053AbhCDNFz (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Thu, 4 Mar 2021 08:05:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:43092 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241092AbhCDNFw (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Thu, 4 Mar 2021 08:05:52 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0893C64E74;
        Thu,  4 Mar 2021 13:05:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614863111;
        bh=2niGf22sG4KWUEf+dEoBkKZWtiMbUqUBHT0C5WNBM9U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Um9LSr0ARVlbwWC8J3dFnsSakdQfiq3uJhTViU8KFix4Vklv5fjoOVtAVyNAJWNsc
         CysUbtP5hkmhmxZolvhN+lQvrrGZmbbx9D75c9iT0xlmLT6KWtVpBu4L6+Mw9zi+D0
         fB/NScCyorWznQNad9aKSdUkEM9kqngF+KHWdM25Wspo+WH3GbJ+caB5z2f5j8gK+U
         bxufBkXfTJKQ82L32Uy0aKBwgXiuYeydreju3cnXxLCPc8Oy45e81JgzZk5AGMoeBz
         CPNXlE3eaTOXWV/QU+kbZCzns2jjRFK4KesPIb5KYCxmANcgOxHE/8VzAmVVfP2SOm
         6548Jm3PT0Q0A==
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Cc:     Yishai Hadas <yishaih@nvidia.com>, linux-rdma@vger.kernel.org
Subject: [PATCH rdma-next 1/3] IB/core: Drop WARN_ON() from ib_umem_find_best_pgsz()
Date:   Thu,  4 Mar 2021 15:04:59 +0200
Message-Id: <20210304130501.1102577-2-leon@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210304130501.1102577-1-leon@kernel.org>
References: <20210304130501.1102577-1-leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

From: Yishai Hadas <yishaih@nvidia.com>

The WARN_ON() issued as part of ib_umem_find_best_pgsz() blocked cases
when only page sizes larger than PAGE_SIZE were set, drop it to enable
those cases.

In addition, there is no need to have a specific check for zero
pgsz_bitmap, the function will do its job and return 0 at the end if
nothing match will be found.

Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/infiniband/core/umem.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/infiniband/core/umem.c b/drivers/infiniband/core/umem.c
index 2dde99a9ba07..2cd64649005b 100644
--- a/drivers/infiniband/core/umem.c
+++ b/drivers/infiniband/core/umem.c
@@ -100,10 +100,6 @@ unsigned long ib_umem_find_best_pgsz(struct ib_umem *umem,
 	 */
 	pgsz_bitmap &= GENMASK(BITS_PER_LONG - 1, PAGE_SHIFT);
 
-	/* At minimum, drivers must support PAGE_SIZE or smaller */
-	if (WARN_ON(!(pgsz_bitmap & GENMASK(PAGE_SHIFT, 0))))
-		return 0;
-
 	umem->iova = va = virt;
 	/* The best result is the smallest page size that results in the minimum
 	 * number of required pages. Compute the largest page size that could
-- 
2.29.2

