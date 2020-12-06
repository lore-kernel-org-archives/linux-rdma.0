Return-Path: <linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 617DDC433FE
	for <linux-rdma@archiver.kernel.org>; Sun,  6 Dec 2020 15:33:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1DF542333D
	for <linux-rdma@archiver.kernel.org>; Sun,  6 Dec 2020 15:33:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726043AbgLFPdd (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Sun, 6 Dec 2020 10:33:33 -0500
Received: from smtp-fw-2101.amazon.com ([72.21.196.25]:57204 "EHLO
        smtp-fw-2101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725730AbgLFPdd (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Sun, 6 Dec 2020 10:33:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1607268812; x=1638804812;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=y+dJuLwJCRQIzI4hWuAA2WgkPX98s+4KlI96b0Qbwb0=;
  b=C91Vt/IdjuFtJGZtWPdnuRa2Lrulm/N1NJPHpFHdJfASPCGMxw1susoY
   SUdQpgYGpvdY+P8WI+JFWkl7N2QZIImn39xTXBGm2wKtF1+R2J2GW4csw
   qNlmYC69iyWRQNP2mE8l9Fmp2dgn7Pbf1f/TITTwSIhwcHkPcSHes4XVX
   k=;
X-IronPort-AV: E=Sophos;i="5.78,397,1599523200"; 
   d="scan'208";a="67554190"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-2c-2225282c.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-out-2101.iad2.amazon.com with ESMTP; 06 Dec 2020 15:32:45 +0000
Received: from EX13D19EUA003.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-2c-2225282c.us-west-2.amazon.com (Postfix) with ESMTPS id 57964A0827;
        Sun,  6 Dec 2020 15:32:44 +0000 (UTC)
Received: from EX13MTAUEE002.ant.amazon.com (10.43.62.24) by
 EX13D19EUA003.ant.amazon.com (10.43.165.175) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Sun, 6 Dec 2020 15:32:42 +0000
Received: from 8c85908914bf.ant.amazon.com (10.1.212.12) by
 mail-relay.amazon.com (10.43.62.224) with Microsoft SMTP Server id
 15.0.1497.2 via Frontend Transport; Sun, 6 Dec 2020 15:32:40 +0000
From:   Gal Pressman <galpress@amazon.com>
To:     Jason Gunthorpe <jgg@ziepe.ca>, Doug Ledford <dledford@redhat.com>
CC:     <linux-rdma@vger.kernel.org>, Gal Pressman <galpress@amazon.com>,
        Avihai Horon <avihaih@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>
Subject: [PATCH for-rc] RDMA/core: Fix empty gid table for non IB/RoCE devices
Date:   Sun, 6 Dec 2020 17:32:38 +0200
Message-ID: <20201206153238.34878-1-galpress@amazon.com>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

The query_gid_table ioctl skips non IB/RoCE ports, which as a result
returns an empty gid table for devices such as EFA which have a GID
table, but are not IB/RoCE.

Fixes: c4b4d548fabc ("RDMA/core: Introduce new GID table query API")
Signed-off-by: Gal Pressman <galpress@amazon.com>
---
 drivers/infiniband/core/cache.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/infiniband/core/cache.c b/drivers/infiniband/core/cache.c
index 8017c40dd110..7989b7e1d1c0 100644
--- a/drivers/infiniband/core/cache.c
+++ b/drivers/infiniband/core/cache.c
@@ -1269,9 +1269,6 @@ ssize_t rdma_query_gid_table(struct ib_device *device,
 	unsigned long flags;
 
 	rdma_for_each_port(device, port_num) {
-		if (!rdma_ib_or_roce(device, port_num))
-			continue;
-
 		table = rdma_gid_table(device, port_num);
 		read_lock_irqsave(&table->rwlock, flags);
 		for (i = 0; i < table->sz; i++) {

base-commit: b65054597872ce3aefbc6a666385eabdf9e288da
-- 
2.29.2

