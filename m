Return-Path: <SRS0=N7RC=7W=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69B43C433E1
	for <linux-rdma@archiver.kernel.org>; Tue,  9 Jun 2020 12:47:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3BBEA20853
	for <linux-rdma@archiver.kernel.org>; Tue,  9 Jun 2020 12:47:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=ideasonboard.com header.i=@ideasonboard.com header.b="IBCBcaXw"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729637AbgFIMqn (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Tue, 9 Jun 2020 08:46:43 -0400
Received: from perceval.ideasonboard.com ([213.167.242.64]:54342 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729599AbgFIMql (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Tue, 9 Jun 2020 08:46:41 -0400
Received: from Q.local (cpc89242-aztw30-2-0-cust488.18-1.cable.virginm.net [86.31.129.233])
        by perceval.ideasonboard.com (Postfix) with ESMTPSA id 7AE0118DB;
        Tue,  9 Jun 2020 14:46:37 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ideasonboard.com;
        s=mail; t=1591706797;
        bh=yUDqaHQhhkfOJfrOhGeYQXYgQdqAUyO9Sr1tp6uX60I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IBCBcaXwIMaM66OViixlYA8SyKxFiFbHL9Yri62GKuhsNOJMRe3zBQt9R3Yw2k9UH
         fJbDUt4Fru0lRk8QWRxEw90O39W+HKkA8erw4s8brfvYT/+37xP8PiD26J+pdxPZkT
         ZtEH/kPqZDllya2EHmEFhOWf6eXB5ZjMII/eppaU=
From:   Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
To:     Kieran Bingham <kieran.bingham@ideasonboard.com>
Cc:     linux-renesas-soc@vger.kernel.org,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
        Mike Marciniszyn <mike.marciniszyn@intel.com>,
        Dennis Dalessandro <dennis.dalessandro@intel.com>,
        Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Jiri Kosina <trivial@kernel.org>,
        linux-rdma@vger.kernel.org (open list:HFI1 DRIVER),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH 11/17] drivers: infiniband: Fix trivial spelling
Date:   Tue,  9 Jun 2020 13:46:04 +0100
Message-Id: <20200609124610.3445662-12-kieran.bingham+renesas@ideasonboard.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200609124610.3445662-1-kieran.bingham+renesas@ideasonboard.com>
References: <20200609124610.3445662-1-kieran.bingham+renesas@ideasonboard.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

The word 'descriptor' is misspelled throughout the tree.

Fix it up accordingly:
    decriptors -> descriptors

Signed-off-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
---
 drivers/infiniband/hw/hfi1/ipoib_tx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/hfi1/ipoib_tx.c b/drivers/infiniband/hw/hfi1/ipoib_tx.c
index 883cb9d48022..175290c56db9 100644
--- a/drivers/infiniband/hw/hfi1/ipoib_tx.c
+++ b/drivers/infiniband/hw/hfi1/ipoib_tx.c
@@ -364,7 +364,7 @@ static struct ipoib_txreq *hfi1_ipoib_send_dma_common(struct net_device *dev,
 	if (unlikely(!tx))
 		return ERR_PTR(-ENOMEM);
 
-	/* so that we can test if the sdma decriptors are there */
+	/* so that we can test if the sdma descriptors are there */
 	tx->txreq.num_desc = 0;
 	tx->priv = priv;
 	tx->txq = txp->txq;
-- 
2.25.1

