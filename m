Return-Path: <linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84FDBC32792
	for <linux-rdma@archiver.kernel.org>; Tue, 23 Aug 2022 13:48:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229784AbiHWNs2 (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Tue, 23 Aug 2022 09:48:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241161AbiHWNsE (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Tue, 23 Aug 2022 09:48:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40A43AB42E
        for <linux-rdma@vger.kernel.org>; Tue, 23 Aug 2022 03:52:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8644C6131B
        for <linux-rdma@vger.kernel.org>; Tue, 23 Aug 2022 10:51:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67F6BC433C1;
        Tue, 23 Aug 2022 10:51:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661251915;
        bh=cSeA/Lb2KOnRR6RG9cGyeczlx313cuolkz0aySOz338=;
        h=From:To:Cc:Subject:Date:From;
        b=klGxn2onLyQU88YRSycDgWPA0byqqpe5eomYcrNGn80IBoUyIjIMCpybT58/njIiR
         2Ktv7i1GSPvgaFSF47E2GATkaBjwioqpYZoiWL8zKu/WRrf9JuDK6o5e8OvENP88o5
         pWYAV1rY0ZwmsAKK1MM69m9G/eluEPS6/KqZql7B6O5+N4JDz+IdSN6ZxQ7JChaKp8
         21BmwEISa1BPAwib/nC5l+Vgi/infZ7xz+4P9tWjK8s1nWzjSHZBVSD0g8mpA0CU8y
         eWClSaa3Q+OsqANyigZa8mC9hbHPMphKHhMRYlnjgZ/dpj8tGae54Gj8W8TwJs2FHW
         chTIPFSZoao6Q==
From:   Leon Romanovsky <leon@kernel.org>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Michael Guralnik <michaelgur@nvidia.com>,
        linux-rdma@vger.kernel.org
Subject: [PATCH rdma-rc] RDMA/cma: Fix arguments order in net device validation
Date:   Tue, 23 Aug 2022 13:51:50 +0300
Message-Id: <1c1ec2277a131d277ebcceec987fd338d35b775f.1661251872.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.37.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

From: Michael Guralnik <michaelgur@nvidia.com>

Fix the order of source and destination addresses when resolving the
route between server and client to validate use of correct net device.

The reverse order we had so far didn't actually validate the net device
as the server would try to resolve the route to itself, thus always
getting the server's net device.

The issue was discovered when running cm applications on a single host
between 2 interfaces with same subnet and source based routing rules.
When resolving the reverse route the source based route rules were
ignored.

Fixes: f887f2ac87c2 ("IB/cma: Validate routing of incoming requests")
Signed-off-by: Michael Guralnik <michaelgur@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/infiniband/core/cma.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
index ee8f40b5ac99..81ded412a39e 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -1841,8 +1841,8 @@ cma_ib_id_from_event(struct ib_cm_id *cm_id,
 		}
 
 		if (!validate_net_dev(*net_dev,
-				 (struct sockaddr *)&req->listen_addr_storage,
-				 (struct sockaddr *)&req->src_addr_storage)) {
+				 (struct sockaddr *)&req->src_addr_storage,
+				 (struct sockaddr *)&req->listen_addr_storage)) {
 			id_priv = ERR_PTR(-EHOSTUNREACH);
 			goto err;
 		}
-- 
2.37.2

