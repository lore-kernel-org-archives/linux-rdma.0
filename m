Return-Path: <SRS0=HMeR=4C=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20005C3B1AF
	for <linux-rdma@archiver.kernel.org>; Fri, 14 Feb 2020 17:51:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EE4AD206D7
	for <linux-rdma@archiver.kernel.org>; Fri, 14 Feb 2020 17:51:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1581702680;
	bh=PLNrytnzgF1eAeTHEjvYL517Oe7v9++dJm1YPKnNc2U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=QD3ix4o/5JOI/W93IJnX/GZhLuljYoJc+YjKpPU8odKu2/pHLa1Hn3+Z2E1Ituuhf
	 u1F9xtAom7nG0kYn2Y0uQGSaF6ksS49W/fwlEQs7lCGCFp6OrjtNHk0IkZmk5lMC4u
	 Pg21Y+U5LFTqm54OueCuGcTbBKut+iDzdobpFFyA=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388736AbgBNP6z (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Fri, 14 Feb 2020 10:58:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:43300 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388400AbgBNP6y (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Fri, 14 Feb 2020 10:58:54 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5FF04222C4;
        Fri, 14 Feb 2020 15:58:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581695934;
        bh=PLNrytnzgF1eAeTHEjvYL517Oe7v9++dJm1YPKnNc2U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=S5lqIXlvgeFHkmc3ms1vvR9ZrOlliLaSHMZt8hbDRq5o8Su/Pi0Cdn4lWnBQkG6+y
         6CtaL4hC4eQCuHTIbvlRi8zqerUp/CsRZPuOY3eQ3d9XvVumnUw1TTliU7600UaHab
         8Eb03El6glPRq30+Ig9+gJoii2/YFwTW73hCL+yg=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jason Gunthorpe <jgg@mellanox.com>,
        Gal Pressman <galpress@amazon.com>,
        Michal Kalderon <michal.kalderon@marvell.com>,
        Sasha Levin <sashal@kernel.org>, linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 5.5 469/542] RDMA/core: Ensure that rdma_user_mmap_entry_remove() is a fence
Date:   Fri, 14 Feb 2020 10:47:41 -0500
Message-Id: <20200214154854.6746-469-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214154854.6746-1-sashal@kernel.org>
References: <20200214154854.6746-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

From: Jason Gunthorpe <jgg@mellanox.com>

[ Upstream commit 6b3712c0246ca7b2b8fa05eab2362cf267410f7e ]

The set of entry->driver_removed is missing locking, protect it with
xa_lock() which is held by the only reader.

Otherwise readers may continue to see driver_removed = false after
rdma_user_mmap_entry_remove() returns and may continue to try and
establish new mmaps.

Fixes: 3411f9f01b76 ("RDMA/core: Create mmap database and cookie helper functions")
Link: https://lore.kernel.org/r/20200115202041.GA17199@ziepe.ca
Reviewed-by: Gal Pressman <galpress@amazon.com>
Acked-by: Michal Kalderon <michal.kalderon@marvell.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/core/ib_core_uverbs.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/infiniband/core/ib_core_uverbs.c b/drivers/infiniband/core/ib_core_uverbs.c
index b7cb59844ece4..b51bd7087a881 100644
--- a/drivers/infiniband/core/ib_core_uverbs.c
+++ b/drivers/infiniband/core/ib_core_uverbs.c
@@ -232,7 +232,9 @@ void rdma_user_mmap_entry_remove(struct rdma_user_mmap_entry *entry)
 	if (!entry)
 		return;
 
+	xa_lock(&entry->ucontext->mmap_xa);
 	entry->driver_removed = true;
+	xa_unlock(&entry->ucontext->mmap_xa);
 	kref_put(&entry->ref, rdma_user_mmap_entry_free);
 }
 EXPORT_SYMBOL(rdma_user_mmap_entry_remove);
-- 
2.20.1

