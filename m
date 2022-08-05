Return-Path: <linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3B80C00140
	for <linux-rdma@archiver.kernel.org>; Fri,  5 Aug 2022 05:34:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235498AbiHEFet (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Fri, 5 Aug 2022 01:34:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231181AbiHEFer (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Fri, 5 Aug 2022 01:34:47 -0400
Received: from ssh248.corpemail.net (ssh248.corpemail.net [210.51.61.248])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21F2C6E2EF;
        Thu,  4 Aug 2022 22:34:45 -0700 (PDT)
Received: from ([60.208.111.195])
        by ssh248.corpemail.net ((D)) with ASMTP (SSL) id ZDN00038;
        Fri, 05 Aug 2022 13:34:38 +0800
Received: from localhost.localdomain (10.200.104.97) by
 jtjnmail201605.home.langchao.com (10.100.2.5) with Microsoft SMTP Server id
 15.1.2507.9; Fri, 5 Aug 2022 13:34:39 +0800
From:   Bo Liu <liubo03@inspur.com>
To:     <bvanassche@acm.org>, <jgg@ziepe.ca>, <leon@kernel.org>
CC:     <linux-rdma@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Bo Liu <liubo03@inspur.com>
Subject: [PATCH] RDMA/srp: Check dev_set_name() return value
Date:   Fri, 5 Aug 2022 01:34:34 -0400
Message-ID: <20220805053434.3944-1-liubo03@inspur.com>
X-Mailer: git-send-email 2.18.2
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.200.104.97]
tUid:   20228051334389b490f9c674bd23283da27a41ff7b287
X-Abuse-Reports-To: service@corp-email.com
Abuse-Reports-To: service@corp-email.com
X-Complaints-To: service@corp-email.com
X-Report-Abuse-To: service@corp-email.com
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

It's possible that dev_set_name() returns -ENOMEM, catch and handle this.

Signed-off-by: Bo Liu <liubo03@inspur.com>
---
 drivers/infiniband/ulp/srp/ib_srp.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index 7720ea270ed8..a6f788e3b84b 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -3905,8 +3905,9 @@ static struct srp_host *srp_add_port(struct srp_device *device, u8 port)
 
 	host->dev.class = &srp_class;
 	host->dev.parent = device->dev->dev.parent;
-	dev_set_name(&host->dev, "srp-%s-%d", dev_name(&device->dev->dev),
-		     port);
+	if (dev_set_name(&host->dev, "srp-%s-%d", dev_name(&device->dev->dev),
+		     port))
+		goto free_host;
 
 	if (device_register(&host->dev))
 		goto free_host;
-- 
2.27.0

