Return-Path: <SRS0=yC1B=ZO=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE741C432C0
	for <linux-rdma@archiver.kernel.org>; Fri, 22 Nov 2019 06:19:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9C1362053B
	for <linux-rdma@archiver.kernel.org>; Fri, 22 Nov 2019 06:19:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1574403564;
	bh=z8Iyzpjt8JKb+vgUozi+1J3dLfGgj3QCzA7NIlEf3K4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=AMittplXNk3dykasb1Ot/Tk8fzDGAdYBqSorbu2cXyHXnW4aUYiqmFlwOt73fwqUL
	 YKDalUOKP4Md0Q8S6w53Bb+0nuznzVDfyRBAJfHP6+kOv1XPbh8ienqCmdeVi1zbip
	 wK7jjkFQ00qZGsativ9zS0NfJz9jcLa4gzKHa1uI=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727533AbfKVGTX (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Fri, 22 Nov 2019 01:19:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:33642 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728971AbfKVFz5 (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Fri, 22 Nov 2019 00:55:57 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DCC552071F;
        Fri, 22 Nov 2019 05:55:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574402156;
        bh=z8Iyzpjt8JKb+vgUozi+1J3dLfGgj3QCzA7NIlEf3K4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=c8WNone71pn1pHUiHJNQF92ui1Ki/ftyrsMBBae2tjEarHOLXOTJtteq9azUWZh8p
         xicbUWb6o6WQbYyw3S4+xzdusc0QC8RVlLJf1YhxfPr7CY7oTU3wgIxA8/A93Gb2tH
         /8PQA1upBKLYDCk7vjl7hV7CWS0LgdTZKjAscc2Q=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Gal Pressman <galpress@amazon.com>,
        Adit Ranadive <aditr@vmware.com>,
        Yuval Shaia <yuval.shaia@oracle.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>, linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 011/127] RDMA/vmw_pvrdma: Use atomic memory allocation in create AH
Date:   Fri, 22 Nov 2019 00:53:49 -0500
Message-Id: <20191122055544.3299-10-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191122055544.3299-1-sashal@kernel.org>
References: <20191122055544.3299-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

From: Gal Pressman <galpress@amazon.com>

[ Upstream commit a276a4d93bf1580d737f38d1810e5f4b166f3edd ]

Create address handle callback should not sleep, use GFP_ATOMIC instead of
GFP_KERNEL for memory allocation.

Fixes: 29c8d9eba550 ("IB: Add vmw_pvrdma driver")
Cc: Adit Ranadive <aditr@vmware.com>
Signed-off-by: Gal Pressman <galpress@amazon.com>
Reviewed-by: Yuval Shaia <yuval.shaia@oracle.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/vmw_pvrdma/pvrdma_verbs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/vmw_pvrdma/pvrdma_verbs.c b/drivers/infiniband/hw/vmw_pvrdma/pvrdma_verbs.c
index aa533f08e0171..5c7aa6ff15382 100644
--- a/drivers/infiniband/hw/vmw_pvrdma/pvrdma_verbs.c
+++ b/drivers/infiniband/hw/vmw_pvrdma/pvrdma_verbs.c
@@ -550,7 +550,7 @@ struct ib_ah *pvrdma_create_ah(struct ib_pd *pd, struct rdma_ah_attr *ah_attr,
 	if (!atomic_add_unless(&dev->num_ahs, 1, dev->dsr->caps.max_ah))
 		return ERR_PTR(-ENOMEM);
 
-	ah = kzalloc(sizeof(*ah), GFP_KERNEL);
+	ah = kzalloc(sizeof(*ah), GFP_ATOMIC);
 	if (!ah) {
 		atomic_dec(&dev->num_ahs);
 		return ERR_PTR(-ENOMEM);
-- 
2.20.1

