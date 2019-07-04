Return-Path: <SRS0=m4pY=VB=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D664DC06513
	for <linux-rdma@archiver.kernel.org>; Thu,  4 Jul 2019 12:50:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B552E21850
	for <linux-rdma@archiver.kernel.org>; Thu,  4 Jul 2019 12:50:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726964AbfGDMua (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Thu, 4 Jul 2019 08:50:30 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42388 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725945AbfGDMua (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Thu, 4 Jul 2019 08:50:30 -0400
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.0:RSA_AES_256_CBC_SHA1:32)
        (Exim 4.76)
        (envelope-from <colin.king@canonical.com>)
        id 1hj1Bz-0005US-L7; Thu, 04 Jul 2019 12:50:27 +0000
From:   Colin King <colin.king@canonical.com>
To:     Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>,
        linux-rdma@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] RDMA/uverbs: remove redundant assignment to variable ret
Date:   Thu,  4 Jul 2019 13:50:27 +0100
Message-Id: <20190704125027.4514-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

The variable ret is being initialized with a value that is never
read and it is being updated later with a new value. The
initialization is redundant and can be removed.

Addresses-Coverity: ("Unused value")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/infiniband/core/uverbs_cmd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
index 750c4d484329..7ddd0e5bc6b3 100644
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -2548,7 +2548,7 @@ static int ib_uverbs_detach_mcast(struct uverbs_attr_bundle *attrs)
 	struct ib_uqp_object         *obj;
 	struct ib_qp                 *qp;
 	struct ib_uverbs_mcast_entry *mcast;
-	int                           ret = -EINVAL;
+	int                           ret;
 	bool                          found = false;
 
 	ret = uverbs_request(attrs, &cmd, sizeof(cmd));
-- 
2.20.1

