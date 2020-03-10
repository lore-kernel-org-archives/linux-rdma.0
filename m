Return-Path: <SRS0=u98Z=43=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8ACEFC10F27
	for <linux-rdma@archiver.kernel.org>; Tue, 10 Mar 2020 09:26:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 667232051A
	for <linux-rdma@archiver.kernel.org>; Tue, 10 Mar 2020 09:26:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1583832391;
	bh=meu0nE9dggEmN7KiFKvFa6jvHUbGyuczmyogi5NYfDg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=hXpdeSZBktiw/pJOb93nQS/V9ekSQVggpfxGjqgUBqJcBalgjIwv0NimGsJeZ6Snw
	 mH0m7ZVgOlTMB+A99Bp7alcbDuoELZLTgWOQcheDriGifWzEv8JuicUIjvBjwVnQ/K
	 SkEVexEUnJIme6IRK6VnG0L8bY9RRYSwENzDJSO4=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726224AbgCJJ0a (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Tue, 10 Mar 2020 05:26:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:58032 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726199AbgCJJ0a (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Tue, 10 Mar 2020 05:26:30 -0400
Received: from localhost (unknown [193.47.165.251])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B7A3524681;
        Tue, 10 Mar 2020 09:26:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583832390;
        bh=meu0nE9dggEmN7KiFKvFa6jvHUbGyuczmyogi5NYfDg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dSwNvDUvy0cHyRyYjZIf7IPHj35ljBa63xRfKli+a/wEyBgaBhdlG5cXigE5ojf1V
         1JJpDRyfHKVuF8gnUp8qFLoNdDbEiEQ5d/B79dJ0g/ygSmJZ/1tRXNPmBvcuUukmJx
         Oh6RkVbkfqs6e6SIUBPc8Wswt+DblC33uxSU/aY4=
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Cc:     linux-rdma@vger.kernel.org, Sean Hefty <sean.hefty@intel.com>
Subject: [PATCH rdma-next 09/15] RDMA/cm: Add missing locking around id.state in cm_dup_req_handler
Date:   Tue, 10 Mar 2020 11:25:39 +0200
Message-Id: <20200310092545.251365-10-leon@kernel.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200310092545.251365-1-leon@kernel.org>
References: <20200310092545.251365-1-leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

From: Jason Gunthorpe <jgg@mellanox.com>

All accesses to id.state must be done under the spinlock.

Fixes: a977049dacde ("[PATCH] IB: Add the kernel CM implementation")
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/infiniband/core/cm.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/core/cm.c b/drivers/infiniband/core/cm.c
index d00eb4751ae5..d002b34bd5a3 100644
--- a/drivers/infiniband/core/cm.c
+++ b/drivers/infiniband/core/cm.c
@@ -1887,8 +1887,12 @@ static void cm_dup_req_handler(struct cm_work *work,
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
2.24.1

