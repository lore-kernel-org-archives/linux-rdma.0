Return-Path: <SRS0=lJT2=CS=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9CFBCC433E2
	for <linux-rdma@archiver.kernel.org>; Wed,  9 Sep 2020 17:07:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6D17521919
	for <linux-rdma@archiver.kernel.org>; Wed,  9 Sep 2020 17:07:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730261AbgIIRHD (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Wed, 9 Sep 2020 13:07:03 -0400
Received: from stargate.chelsio.com ([12.32.117.8]:28684 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730400AbgIIPhV (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Wed, 9 Sep 2020 11:37:21 -0400
Received: from localhost (mehrangarh.blr.asicdesigners.com [10.193.185.169])
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id 089FbBeX012435;
        Wed, 9 Sep 2020 08:37:12 -0700
From:   Potnuri Bharat Teja <bharat@chelsio.com>
To:     jgg@ziepe.ca, dledford@redhat.com
Cc:     linux-rdma@vger.kernel.org, bharat@chelsio.com
Subject: [PATCH for-next] RDMA/iw_cxgb4: disable delayed ack by default
Date:   Wed,  9 Sep 2020 21:07:07 +0530
Message-Id: <20200909153707.2795-1-bharat@chelsio.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

Receive side delayed ack mode is needed only for certain area networks/
connections. Therefore disable it by default.

Signed-off-by: Potnuri Bharat Teja <bharat@chelsio.com>
---
 drivers/infiniband/hw/cxgb4/cm.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb4/cm.c b/drivers/infiniband/hw/cxgb4/cm.c
index 1f288c73ccfc..8769e7aa097f 100644
--- a/drivers/infiniband/hw/cxgb4/cm.c
+++ b/drivers/infiniband/hw/cxgb4/cm.c
@@ -77,9 +77,9 @@ static int enable_ecn;
 module_param(enable_ecn, int, 0644);
 MODULE_PARM_DESC(enable_ecn, "Enable ECN (default=0/disabled)");
 
-static int dack_mode = 1;
+static int dack_mode;
 module_param(dack_mode, int, 0644);
-MODULE_PARM_DESC(dack_mode, "Delayed ack mode (default=1)");
+MODULE_PARM_DESC(dack_mode, "Delayed ack mode (default=0)");
 
 uint c4iw_max_read_depth = 32;
 module_param(c4iw_max_read_depth, int, 0644);
-- 
2.24.0

