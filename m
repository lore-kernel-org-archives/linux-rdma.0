Return-Path: <SRS0=3e36=VX=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92AC4C7618F
	for <linux-rdma@archiver.kernel.org>; Fri, 26 Jul 2019 18:27:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 714E9218B8
	for <linux-rdma@archiver.kernel.org>; Fri, 26 Jul 2019 18:27:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726791AbfGZS1C (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Fri, 26 Jul 2019 14:27:02 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:58337 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726539AbfGZS1C (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Fri, 26 Jul 2019 14:27:02 -0400
Received: from Internal Mail-Server by MTLPINE2 (envelope-from parav@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 26 Jul 2019 21:26:59 +0300
Received: from sw-mtx-036.mtx.labs.mlnx (sw-mtx-036.mtx.labs.mlnx [10.12.150.149])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id x6QIQwpr003484;
        Fri, 26 Jul 2019 21:26:58 +0300
From:   Parav Pandit <parav@mellanox.com>
To:     linux-rdma@vger.kernel.org
Cc:     jgg@ziepe.ca, dledford@redhat.com, selvin.xavier@broadcom.com,
        Parav Pandit <parav@mellanox.com>
Subject: [PATCH rdma-next] IB/bnxt_re: Do not notifify GID change event
Date:   Fri, 26 Jul 2019 13:26:52 -0500
Message-Id: <20190726182652.50037-1-parav@mellanox.com>
X-Mailer: git-send-email 2.19.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

GID table entry operations such as add/remove/modify are triggered
by the IB core for RoCE ports.
Hence, remove GID change notification from hw driver.

Reviewed-by: Selvin Xavier <selvin.xavier@broadcom.com>
Tested-by: Selvin Xavier <selvin.xavier@broadcom.com>
Signed-off-by: Parav Pandit <parav@mellanox.com>
---
 drivers/infiniband/hw/bnxt_re/main.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/infiniband/hw/bnxt_re/main.c b/drivers/infiniband/hw/bnxt_re/main.c
index 814f959c7db9..efcfa5441991 100644
--- a/drivers/infiniband/hw/bnxt_re/main.c
+++ b/drivers/infiniband/hw/bnxt_re/main.c
@@ -1471,7 +1471,6 @@ static int bnxt_re_ib_reg(struct bnxt_re_dev *rdev)
 			 &rdev->active_width);
 	set_bit(BNXT_RE_FLAG_ISSUE_ROCE_STATS, &rdev->flags);
 	bnxt_re_dispatch_event(&rdev->ibdev, NULL, 1, IB_EVENT_PORT_ACTIVE);
-	bnxt_re_dispatch_event(&rdev->ibdev, NULL, 1, IB_EVENT_GID_CHANGE);
 
 	return 0;
 free_sctx:
-- 
2.19.2

