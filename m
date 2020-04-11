Return-Path: <SRS0=q+lP=53=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6FD20C2BBC7
	for <linux-rdma@archiver.kernel.org>; Sat, 11 Apr 2020 23:25:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 482DA20674
	for <linux-rdma@archiver.kernel.org>; Sat, 11 Apr 2020 23:25:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1586647535;
	bh=4mKEhK51gM1N5fc6QfhQWUi5yHTul4dwyuvmSusVWvk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=aNeRtcfMkO1ZNOqHw2J9w0zJT/b5qbVt2uPz97xprtDTz56/+ZTggK/AvWQKZY+ww
	 UjxbC+PgcAADkIkl3PB0taqiG5JvAfWfWw3i0dsITn7CUA4lH8RfBSBaBi8DZrNbPy
	 yPdVqA1d48XhStzojukKUXx7WBay/m08jUUJ/Rcs=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730102AbgDKXMM (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Sat, 11 Apr 2020 19:12:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:52164 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729701AbgDKXMM (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Sat, 11 Apr 2020 19:12:12 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DB676216FD;
        Sat, 11 Apr 2020 23:12:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586646732;
        bh=4mKEhK51gM1N5fc6QfhQWUi5yHTul4dwyuvmSusVWvk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lqvLAXk88Pw/jYFhErKQ7Le7tvtpYkoqxquA7nKIgSlBQvTHYbq22EtgG56TlqbRT
         7CTnQPQ1PcDMpda+BoDarDLIDs8VaxsQq5mVtbRelLgA/f5X7vHH3flJFGG8APx1NY
         4qyO6Nyrmn2ouFSR5vdpHFdvWQZjqNyIaKIJbyPY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jason Gunthorpe <jgg@mellanox.com>,
        Selvin Xavier <selvin.xavier@broadcom.com>,
        Sasha Levin <sashal@kernel.org>, linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 07/66] RDMA/bnxt_re: Fix lifetimes in bnxt_re_task
Date:   Sat, 11 Apr 2020 19:11:04 -0400
Message-Id: <20200411231203.25933-7-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200411231203.25933-1-sashal@kernel.org>
References: <20200411231203.25933-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

From: Jason Gunthorpe <jgg@mellanox.com>

[ Upstream commit 8a6c61704746d3a1e004e054504ae8d98ed95697 ]

A work queue cannot just rely on the ib_device not being freed, it must
hold a kref on the memory so that the BNXT_RE_FLAG_IBDEV_REGISTERED check
works.

Fixes: 1ac5a4047975 ("RDMA/bnxt_re: Add bnxt_re RoCE driver")
Link: https://lore.kernel.org/r/1584117207-2664-3-git-send-email-selvin.xavier@broadcom.com
Signed-off-by: Selvin Xavier <selvin.xavier@broadcom.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/bnxt_re/main.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/infiniband/hw/bnxt_re/main.c b/drivers/infiniband/hw/bnxt_re/main.c
index 589b0d4677d52..75fe489a70b0c 100644
--- a/drivers/infiniband/hw/bnxt_re/main.c
+++ b/drivers/infiniband/hw/bnxt_re/main.c
@@ -1505,6 +1505,7 @@ static void bnxt_re_task(struct work_struct *work)
 	smp_mb__before_atomic();
 	atomic_dec(&rdev->sched_count);
 exit:
+	put_device(&rdev->ibdev.dev);
 	kfree(re_work);
 }
 
@@ -1581,6 +1582,7 @@ static int bnxt_re_netdev_event(struct notifier_block *notifier,
 		/* Allocate for the deferred task */
 		re_work = kzalloc(sizeof(*re_work), GFP_ATOMIC);
 		if (re_work) {
+			get_device(&rdev->ibdev.dev);
 			re_work->rdev = rdev;
 			re_work->event = event;
 			re_work->vlan_dev = (real_dev == netdev ?
-- 
2.20.1

