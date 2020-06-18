Return-Path: <SRS0=pTjR=77=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ABDA3C433E0
	for <linux-rdma@archiver.kernel.org>; Thu, 18 Jun 2020 02:07:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8343821D6C
	for <linux-rdma@archiver.kernel.org>; Thu, 18 Jun 2020 02:07:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1592446032;
	bh=1CjNh4IAkmtHBplhmUA60VGWBjx2+lXxBppXNT/XFZg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=YfN2ws29AG4UKQ6FjWxp6T2YXOfry4+OVMDrZ3yt6nwJiKD79j+kJ/wzLepnauVkd
	 ihnocW5rXHS7zb53qO68O8NVOD1BYhRD5pbV4DjrS/UENJ94ywlcZqx2CpJzgbnMJy
	 K7TF+tr2A4kI1nW1WWGRtjEwMijQSUHV4wN2JXJs=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730739AbgFRBWZ (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Wed, 17 Jun 2020 21:22:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:55382 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729683AbgFRBWY (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Wed, 17 Jun 2020 21:22:24 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1745420776;
        Thu, 18 Jun 2020 01:22:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592443343;
        bh=1CjNh4IAkmtHBplhmUA60VGWBjx2+lXxBppXNT/XFZg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PTRFHtjssE0Ue5JtLQPeRBdkUCdZwKUWzGRO1OpZqzvCSd3KGPQwJIGOgUzXxJ4gh
         lioXele3XY4idzvEH1bFBiEHDID8oJUI2TP3wJbRjyLRsGDkTSxlWyqE5M4PJkm9lu
         tysEj5qTrZmdC4pc0rUUv3jwzdO9Xyc8zK7p8IQg=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jason Gunthorpe <jgg@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>,
        Sasha Levin <sashal@kernel.org>, linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 004/172] RDMA/uverbs: Make the event_queue fds return POLLERR when disassociated
Date:   Wed, 17 Jun 2020 21:19:30 -0400
Message-Id: <20200618012218.607130-4-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200618012218.607130-1-sashal@kernel.org>
References: <20200618012218.607130-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

From: Jason Gunthorpe <jgg@mellanox.com>

[ Upstream commit eb356e6dc15a30af604f052cd0e170450193c254 ]

If is_closed is set, and the event list is empty, then read() will return
-EIO without blocking. After setting is_closed in
ib_uverbs_free_event_queue(), we do trigger a wake_up on the poll_wait,
but the fops->poll() function does not check it, so poll will continue to
sleep on an empty list.

Fixes: 14e23bd6d221 ("RDMA/core: Fix locking in ib_uverbs_event_read")
Link: https://lore.kernel.org/r/0-v1-ace813388969+48859-uverbs_poll_fix%25jgg@mellanox.com
Reviewed-by: Leon Romanovsky <leonro@mellanox.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/core/uverbs_main.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/infiniband/core/uverbs_main.c b/drivers/infiniband/core/uverbs_main.c
index 5404717998b0..fc4b46258c75 100644
--- a/drivers/infiniband/core/uverbs_main.c
+++ b/drivers/infiniband/core/uverbs_main.c
@@ -360,6 +360,8 @@ static __poll_t ib_uverbs_event_poll(struct ib_uverbs_event_queue *ev_queue,
 	spin_lock_irq(&ev_queue->lock);
 	if (!list_empty(&ev_queue->event_list))
 		pollflags = EPOLLIN | EPOLLRDNORM;
+	else if (ev_queue->is_closed)
+		pollflags = EPOLLERR;
 	spin_unlock_irq(&ev_queue->lock);
 
 	return pollflags;
-- 
2.25.1

