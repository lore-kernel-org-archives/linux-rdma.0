Return-Path: <SRS0=q+lP=53=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68513C2BB86
	for <linux-rdma@archiver.kernel.org>; Sat, 11 Apr 2020 23:14:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 38CDD215A4
	for <linux-rdma@archiver.kernel.org>; Sat, 11 Apr 2020 23:14:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1586646894;
	bh=kWhqS6PRCwpLgVe5t7lJXrCy5B5JTSxtre3T0XaC0Oc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=YoPukR5AyiYVKFNEv8ASoXVI9ptkjVupIvHT2zm3vAJGueaIQopXU9IxNLFdTjcqa
	 WsUCDFC8nqPIURgQRwr/ZsoEP0LaIh/oNmNHIKrWqk8FFtgmXyaa2S3geouYLPk7HQ
	 GHeeZQ1NLWFfI5eX9srwC32GjYlHIGlX3kcnY/uY=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730089AbgDKXOv (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Sat, 11 Apr 2020 19:14:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:56872 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730145AbgDKXOu (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Sat, 11 Apr 2020 19:14:50 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 642A820CC7;
        Sat, 11 Apr 2020 23:14:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586646891;
        bh=kWhqS6PRCwpLgVe5t7lJXrCy5B5JTSxtre3T0XaC0Oc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HHAOkSEQy7Y/ogwBIdHSUUmzgV8q7LMS557+ueXU2uJNoweMaeZb9XVNJ+ZW52oiO
         uPdhQSlsPMiKRIxYxMQWcMESDjIGQ5fsQyy8z2dfcIJiE8j6mBAjZU8eQIXILZBS6k
         C8PCkuEiOrX7RqqdOcvK7kbpNXIvGJqvZQZyMiOI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jason Gunthorpe <jgg@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>,
        Sasha Levin <sashal@kernel.org>, linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 03/16] RDMA/cm: Add missing locking around id.state in cm_dup_req_handler
Date:   Sat, 11 Apr 2020 19:14:33 -0400
Message-Id: <20200411231447.27182-3-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200411231447.27182-1-sashal@kernel.org>
References: <20200411231447.27182-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

From: Jason Gunthorpe <jgg@mellanox.com>

[ Upstream commit d1de9a88074b66482443f0cd91618d7b51a7c9b6 ]

All accesses to id.state must be done under the spinlock.

Fixes: a977049dacde ("[PATCH] IB: Add the kernel CM implementation")
Link: https://lore.kernel.org/r/20200310092545.251365-10-leon@kernel.org
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/core/cm.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/core/cm.c b/drivers/infiniband/core/cm.c
index 53c622c99ee40..7bf98d72a4559 100644
--- a/drivers/infiniband/core/cm.c
+++ b/drivers/infiniband/core/cm.c
@@ -1544,8 +1544,12 @@ static void cm_dup_req_handler(struct cm_work *work,
 			counter[CM_REQ_COUNTER]);
 
 	/* Quick state check to discard duplicate REQs. */
-	if (cm_id_priv->id.state == IB_CM_REQ_RCVD)
+	spin_lock_irq(&cm_id_priv->lock);
+	if (cm_id_priv->id.state == IB_CM_REQ_RCVD) {
+		spin_unlock_irq(&cm_id_priv->lock);
 		return;
+	}
+	spin_unlock_irq(&cm_id_priv->lock);
 
 	ret = cm_alloc_response_msg(work->port, work->mad_recv_wc, &msg);
 	if (ret)
-- 
2.20.1

