Return-Path: <SRS0=nLh4=YL=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5532ECA9EAC
	for <linux-rdma@archiver.kernel.org>; Fri, 18 Oct 2019 22:26:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2A42720872
	for <linux-rdma@archiver.kernel.org>; Fri, 18 Oct 2019 22:26:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1571437602;
	bh=ZN/G0DCHvmoMD9ezTpP+BUSAzatO5A2Gky/EnJq3BiM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=g9dEXg0ZvnZ5/XUXu/zGNPlPV0F+b4mWEeDSXeH9TfC5hl2mVi6bVBVf70FFAJW9Z
	 oysJl3yH6ZUiWRJISTEZepDcHLUEDwUZJdnV2bNcAPmsnpThTJjIsQKGIn+3bT3NGy
	 tu5VFxqFeQQwrgXR+0iYXl6iGi1hE7bOso37KV2c=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727967AbfJRW0a (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Fri, 18 Oct 2019 18:26:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:35898 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727924AbfJRWEP (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Fri, 18 Oct 2019 18:04:15 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7033120679;
        Fri, 18 Oct 2019 22:04:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571436255;
        bh=ZN/G0DCHvmoMD9ezTpP+BUSAzatO5A2Gky/EnJq3BiM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hsWxSdDwK+PvFfE1qh/kwbekwpXPI1ClrhtTEgiBzB/3MTFMm5FA/d/jSR5pdPTCz
         VGyNQQTsOh3hJKQalifA3Qd3HzxLeH+eoBLvlO/2Q/36+RIZtiG4gmfjvgWXoP+lXD
         Z8UCLEpaufK3MabXh2vaa67h4vn5kwfo6eHRquJU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jason Gunthorpe <jgg@mellanox.com>,
        Artemy Kovalyov <artemyko@mellanox.com>,
        Sasha Levin <sashal@kernel.org>, linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 5.3 38/89] RDMA/mlx5: Order num_pending_prefetch properly with synchronize_srcu
Date:   Fri, 18 Oct 2019 18:02:33 -0400
Message-Id: <20191018220324.8165-38-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191018220324.8165-1-sashal@kernel.org>
References: <20191018220324.8165-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

From: Jason Gunthorpe <jgg@mellanox.com>

[ Upstream commit aa116b810ac9077a263ed8679fb4d595f180e0eb ]

During destroy setting live = 0 and then synchronize_srcu() prevents
num_pending_prefetch from incrementing, and also, ensures that all work
holding that count is queued on the WQ. Testing before causes races of the
form:

    CPU0                                         CPU1
  dereg_mr()
                                          mlx5_ib_advise_mr_prefetch()
            				   srcu_read_lock()
                                            num_pending_prefetch_inc()
					      if (!live)
   live = 0
   atomic_read() == 0
     // skip flush_workqueue()
                                              atomic_inc()
 					      queue_work();
            				   srcu_read_unlock()
   WARN_ON(atomic_read())  // Fails

Swap the order so that the synchronize_srcu() prevents this.

Fixes: a6bc3875f176 ("IB/mlx5: Protect against prefetch of invalid MR")
Link: https://lore.kernel.org/r/20191001153821.23621-5-jgg@ziepe.ca
Reviewed-by: Artemy Kovalyov <artemyko@mellanox.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/mlx5/mr.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/mr.c b/drivers/infiniband/hw/mlx5/mr.c
index c4ba8838d2c46..96c8a6835592d 100644
--- a/drivers/infiniband/hw/mlx5/mr.c
+++ b/drivers/infiniband/hw/mlx5/mr.c
@@ -1591,13 +1591,14 @@ static void dereg_mr(struct mlx5_ib_dev *dev, struct mlx5_ib_mr *mr)
 		 */
 		mr->live = 0;
 
+		/* Wait for all running page-fault handlers to finish. */
+		synchronize_srcu(&dev->mr_srcu);
+
 		/* dequeue pending prefetch requests for the mr */
 		if (atomic_read(&mr->num_pending_prefetch))
 			flush_workqueue(system_unbound_wq);
 		WARN_ON(atomic_read(&mr->num_pending_prefetch));
 
-		/* Wait for all running page-fault handlers to finish. */
-		synchronize_srcu(&dev->mr_srcu);
 		/* Destroy all page mappings */
 		if (umem_odp->page_list)
 			mlx5_ib_invalidate_range(umem_odp,
-- 
2.20.1

