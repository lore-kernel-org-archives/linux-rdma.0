Return-Path: <SRS0=u98Z=43=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7339FC1975A
	for <linux-rdma@archiver.kernel.org>; Tue, 10 Mar 2020 09:25:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 400D424686
	for <linux-rdma@archiver.kernel.org>; Tue, 10 Mar 2020 09:25:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1583832359;
	bh=n0J9XtYrIiOcXNTZCcv7Uu0rf1UwHcjszoNR1geGe0E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=aLTDwqGLkj755ZB8shIQNGnNxDHkYu2Jh/YFv6aZNYleuH+y+OsyLEbOWQiNZuEO7
	 0A0E1UXCSEM+tFk7xsA8BKGbyke/0onL2SWYUfvyTK+mAo05jkW+dzQdxw32wlhKhr
	 x4wGeSIavH3FPffFVj7hF+jBNPc4wDvu2/ilJ/EM=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726331AbgCJJZ6 (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Tue, 10 Mar 2020 05:25:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:57098 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726199AbgCJJZ4 (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Tue, 10 Mar 2020 05:25:56 -0400
Received: from localhost (unknown [193.47.165.251])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B94922051A;
        Tue, 10 Mar 2020 09:25:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583832356;
        bh=n0J9XtYrIiOcXNTZCcv7Uu0rf1UwHcjszoNR1geGe0E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XCShIQpXm2SnbkS7b8iQ4sKp9H0HvQ38V7o6ktuERDNSD7xMee9ZNAvkdl4KxBM5i
         fmt5i4AyPMbyegLXlBOgmoL4pjuNmoTZPqMAyp7rllYUlxYcMi+BHW5e8iF0CErhSj
         MPy9Kh6HFTSxDu+Vh/9v+l9SZuDk159Ax1p9L/Z4=
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Cc:     Haggai Eran <haggaie@mellanox.com>, linux-rdma@vger.kernel.org
Subject: [PATCH rdma-next 02/15] RDMA/cm: Fix checking for allowed duplicate listens
Date:   Tue, 10 Mar 2020 11:25:32 +0200
Message-Id: <20200310092545.251365-3-leon@kernel.org>
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

The test here typod the cm_id_priv to use, it used the one that was
freshly allocated. By definition the allocated one has the matching
cm_handler and zero context, so the condition was always true.

Instead check that the existing listening ID is compatible with the
proposed handler so that it can be shared, as was originally intended.

Fixes: 067b171b8679 ("IB/cm: Share listening CM IDs")
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/infiniband/core/cm.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/core/cm.c b/drivers/infiniband/core/cm.c
index b1fccbf6ebd8..67b36b8b34ba 100644
--- a/drivers/infiniband/core/cm.c
+++ b/drivers/infiniband/core/cm.c
@@ -1185,7 +1185,8 @@ struct ib_cm_id *ib_cm_insert_listen(struct ib_device *device,
 	/* Find an existing ID */
 	cm_id_priv = cm_find_listen(device, service_id);
 	if (cm_id_priv) {
-		if (cm_id->cm_handler != cm_handler || cm_id->context) {
+		if (cm_id_priv->id.cm_handler != cm_handler ||
+		    cm_id_priv->id.context) {
 			/* Sharing an ib_cm_id with different handlers is not
 			 * supported */
 			spin_unlock_irqrestore(&cm.lock, flags);
-- 
2.24.1

