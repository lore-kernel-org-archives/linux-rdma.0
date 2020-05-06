Return-Path: <SRS0=O4aQ=6U=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 955A1C28CBC
	for <linux-rdma@archiver.kernel.org>; Wed,  6 May 2020 07:47:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 78F13206D5
	for <linux-rdma@archiver.kernel.org>; Wed,  6 May 2020 07:47:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1588751245;
	bh=G0O61ehG1CGYJiPHNmwRw+zNCqfjX02urKClHgeFfOE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=jni7LhfPrv0DnsNMNp1W7KRYevBA+AjcQ8i9TTlr0uQLSRLLmYy7omPSsCoLMAdNh
	 qy12Vtb7yc0WVI4MREYxBaHJd+7V747/zJrhOr5oKWZjfe24cfkETeC407LCYKlJs2
	 5Ff+emBlpLDhV4q5QEjWGofAMEFtIuKYq0KPz9/0=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728386AbgEFHrZ (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Wed, 6 May 2020 03:47:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:41202 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728355AbgEFHrY (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Wed, 6 May 2020 03:47:24 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EC1E920714;
        Wed,  6 May 2020 07:47:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588751244;
        bh=G0O61ehG1CGYJiPHNmwRw+zNCqfjX02urKClHgeFfOE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=t2qEff8o21VEv9ppJR1QgViSkzEeDiY34EQJ4lNbfaA4lIL08OZQerMX5Ea9DSKVb
         +PcTuNqz7CgVKSmroMeKaq8JQWHTknmBa3O6Zg/RK6YcFebmi3SM/JMaG4nbq0hpAr
         lV3Bt40u+8fudJMyLCn7OF4eqpE4rR4YPoZjPChU=
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Cc:     linux-rdma@vger.kernel.org
Subject: [PATCH rdma-next 06/10] RDMA/cm: Add a note explaining how the timewait is eventually freed
Date:   Wed,  6 May 2020 10:46:57 +0300
Message-Id: <20200506074701.9775-7-leon@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200506074701.9775-1-leon@kernel.org>
References: <20200506074701.9775-1-leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

From: Jason Gunthorpe <jgg@mellanox.com>

The way the cm_timewait_info is converted into a work and then freed
is very subtle and surprising, add a note clarifying the lifetime
here.

Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/infiniband/core/cm.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/infiniband/core/cm.c b/drivers/infiniband/core/cm.c
index 3899e9d88eb1..acb0c5c5c5cf 100644
--- a/drivers/infiniband/core/cm.c
+++ b/drivers/infiniband/core/cm.c
@@ -1029,6 +1029,11 @@ static void cm_enter_timewait(struct cm_id_private *cm_id_priv)
 				   msecs_to_jiffies(wait_time));
 	spin_unlock_irqrestore(&cm.lock, flags);
 
+	/*
+	 * The timewait_info is converted into a work and gets freed during
+	 * cm_free_work() in cm_timewait_handler().
+	 */
+	BUILD_BUG_ON(offsetof(struct cm_timewait_info, work) != 0);
 	cm_id_priv->timewait_info = NULL;
 }
 
-- 
2.26.2

