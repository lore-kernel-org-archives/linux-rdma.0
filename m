Return-Path: <SRS0=HMeR=4C=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A509C3B1B2
	for <linux-rdma@archiver.kernel.org>; Fri, 14 Feb 2020 18:06:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E3E0C2168B
	for <linux-rdma@archiver.kernel.org>; Fri, 14 Feb 2020 18:06:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1581703589;
	bh=qj+b2RpW9TJz60O6E8Om1vFFC0f3M1Zglp4/l4ocLbg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=z7ZF9JikKjhbmgoYcuPEGwJ0IMDmjXfrpomRMlBeCxWpB36hKq5yxj2O4Fthn6I80
	 7Ly9Qz9q6V20rLodp80bEkShnZcboGShZ8nxYSZyiAO5Kgy21m7lGen7mgpg1goBjS
	 VXR6BkuBqB6OX7PpS794GTF5lCaKwDP1V5ts+sSw=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391918AbgBNSGY (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Fri, 14 Feb 2020 13:06:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:35422 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731231AbgBNPyy (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Fri, 14 Feb 2020 10:54:54 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B0700222C4;
        Fri, 14 Feb 2020 15:54:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581695694;
        bh=qj+b2RpW9TJz60O6E8Om1vFFC0f3M1Zglp4/l4ocLbg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xMFWI48WVlJrb5mmIDBQXChl+BElITRLXGkoRDwMEn0h45QCG/+VPfTyP+I38yCjW
         gx7CZfndXEzJpwT0M4ukQDWfkhE3ctZT4bmHNMUqqmy/BNcg1VCBn93q7z6WcoSrFl
         2f95LE/ppDA1l1Y0iC8IN8CFdq1goDkX0484naNU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jiewei Ke <kejiewei.cn@gmail.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>, linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 5.5 277/542] RDMA/rxe: Fix error type of mmap_offset
Date:   Fri, 14 Feb 2020 10:44:29 -0500
Message-Id: <20200214154854.6746-277-sashal@kernel.org>
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

From: Jiewei Ke <kejiewei.cn@gmail.com>

[ Upstream commit 6ca18d8927d468c763571f78c9a7387a69ffa020 ]

The type of mmap_offset should be u64 instead of int to match the type of
mminfo.offset. If otherwise, after we create several thousands of CQs, it
will run into overflow issues.

Link: https://lore.kernel.org/r/20191227113613.5020-1-kejiewei.cn@gmail.com
Signed-off-by: Jiewei Ke <kejiewei.cn@gmail.com>
Reviewed-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/sw/rxe/rxe_verbs.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/sw/rxe/rxe_verbs.h b/drivers/infiniband/sw/rxe/rxe_verbs.h
index 95834206c80c3..92de39c4a7c1e 100644
--- a/drivers/infiniband/sw/rxe/rxe_verbs.h
+++ b/drivers/infiniband/sw/rxe/rxe_verbs.h
@@ -408,7 +408,7 @@ struct rxe_dev {
 	struct list_head	pending_mmaps;
 
 	spinlock_t		mmap_offset_lock; /* guard mmap_offset */
-	int			mmap_offset;
+	u64			mmap_offset;
 
 	atomic64_t		stats_counters[RXE_NUM_OF_COUNTERS];
 
-- 
2.20.1

