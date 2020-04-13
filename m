Return-Path: <SRS0=wxv4=55=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DFC43C2BA19
	for <linux-rdma@archiver.kernel.org>; Mon, 13 Apr 2020 13:22:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BCA9120767
	for <linux-rdma@archiver.kernel.org>; Mon, 13 Apr 2020 13:22:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1586784161;
	bh=VkAmD2dVzO7DcTs0bAj1cn7YJGih5O8sQvxyN7xIT4c=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=KlfI5eTjTgS07AGJYxZVzRqR5LHd5hiBDf2YVF0SR7JF6R9gpvyc63x0AlaeeE9il
	 QXFm8C7Nk+UbXFGbhyq7FKHQN1dGHfd8E7wH4jrmT7GoHa/3PTD4Tnh7fVpTl5J0nA
	 EqRd2Jt9fxh9LsisBU93RnTInkXPR5rBP5KA2Cs8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729806AbgDMNWl (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Mon, 13 Apr 2020 09:22:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:59586 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728135AbgDMNWk (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Mon, 13 Apr 2020 09:22:40 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 356E320692;
        Mon, 13 Apr 2020 13:22:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586784159;
        bh=VkAmD2dVzO7DcTs0bAj1cn7YJGih5O8sQvxyN7xIT4c=;
        h=From:To:Cc:Subject:Date:From;
        b=yFwCMdw1LGMGPmx7Sn92RU1DPv1W77wBtS9K1FSyDoR8J2Dd+PFdprg3QYSz0f+dY
         Y4BCKhhylbuYBwl3tVrOxph5RkzgXSifBGaBCCgexTboZoFfYVH8WODQytpPzbLQ/O
         93OjgBVObFXxHc/4TuTPNlS2SVRszKvyvDycEiXc=
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Cc:     Alaa Hleihel <alaa@mellanox.com>, linux-rdma@vger.kernel.org,
        Maor Gottlieb <maorg@mellanox.com>,
        Or Gerlitz <ogerlitz@mellanox.com>,
        Roland Dreier <roland@purestorage.com>,
        Yishai Hadas <yishaih@mellanox.com>
Subject: [PATCH rdma-rc] RDMA/mlx4: Initialize ib_spec on the stack
Date:   Mon, 13 Apr 2020 16:22:35 +0300
Message-Id: <20200413132235.930642-1-leon@kernel.org>
X-Mailer: git-send-email 2.25.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

From: Alaa Hleihel <alaa@mellanox.com>

Initialize ib_spec on the stack before using it, otherwise we will
have garbage values that will break creating default rules with
invalid parsing error.

Fixes: a37a1a428431 ("IB/mlx4: Add mechanism to support flow steering over IB links")
Signed-off-by: Alaa Hleihel <alaa@mellanox.com>
Reviewed-by: Maor Gottlieb <maorg@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/infiniband/hw/mlx4/main.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/mlx4/main.c b/drivers/infiniband/hw/mlx4/main.c
index a66518a5c938..275722cec8c6 100644
--- a/drivers/infiniband/hw/mlx4/main.c
+++ b/drivers/infiniband/hw/mlx4/main.c
@@ -1499,8 +1499,9 @@ static int __mlx4_ib_create_default_rules(
 	int i;
 
 	for (i = 0; i < ARRAY_SIZE(pdefault_rules->rules_create_list); i++) {
+		union ib_flow_spec ib_spec = {};
 		int ret;
-		union ib_flow_spec ib_spec;
+
 		switch (pdefault_rules->rules_create_list[i]) {
 		case 0:
 			/* no rule */
-- 
2.25.2

