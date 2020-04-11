Return-Path: <SRS0=q+lP=53=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6BB17C2BBFD
	for <linux-rdma@archiver.kernel.org>; Sat, 11 Apr 2020 23:40:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3C0A1206E9
	for <linux-rdma@archiver.kernel.org>; Sat, 11 Apr 2020 23:40:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1586648420;
	bh=rH4WRTa5PlCyvEaj6wcN65nVyw5uc5y3HjUjXAhYAd8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=ne5ndfyI2Yh2saTxd5r4vQUfc2uCNsMtqd82EPGZPo5NrXHQlSDxabObmrK7aRUNs
	 azwQsQNb0/AeORpsnzoeWeB64QfazuwetMblHUpdWxmEPhOk8GsyA6wGPu2yIcB6vD
	 2fcyxaTZN0b0S/bRTFLuj7yjCvG/wapYfXdwlgpU=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728654AbgDKXH1 (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Sat, 11 Apr 2020 19:07:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:43324 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728651AbgDKXH0 (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Sat, 11 Apr 2020 19:07:26 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CE311216FD;
        Sat, 11 Apr 2020 23:07:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586646446;
        bh=rH4WRTa5PlCyvEaj6wcN65nVyw5uc5y3HjUjXAhYAd8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pBBDZ14GEfvuCmdlo+f1tb0GMjhgTnx8We6kI25X8tn2/fCUHx87xr7JUF5deZuBK
         QVj8BZF1LRKCGswPtyDd16Xa/v7v8KvKg5RaLxgGclVXe1vwVUd9cQwQMiyGw5i/YT
         2e2pYuNNOHHKJXhnc1ACTFHEuGxphOjo3rbxqlIg=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jason Gunthorpe <jgg@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>,
        Sasha Levin <sashal@kernel.org>, linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 5.5 017/121] RDMA/cm: Add missing locking around id.state in cm_dup_req_handler
Date:   Sat, 11 Apr 2020 19:05:22 -0400
Message-Id: <20200411230706.23855-17-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200411230706.23855-1-sashal@kernel.org>
References: <20200411230706.23855-1-sashal@kernel.org>
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
index 1c7984bae7ab2..f7afa1c75746b 100644
--- a/drivers/infiniband/core/cm.c
+++ b/drivers/infiniband/core/cm.c
@@ -1770,8 +1770,12 @@ static void cm_dup_req_handler(struct cm_work *work,
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

