Return-Path: <SRS0=Etr7=XH=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83E28C49ED9
	for <linux-rdma@archiver.kernel.org>; Thu, 12 Sep 2019 10:36:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 65CBE206A5
	for <linux-rdma@archiver.kernel.org>; Thu, 12 Sep 2019 10:36:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731099AbfILKgO (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Thu, 12 Sep 2019 06:36:14 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:32954 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1731176AbfILKgN (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Thu, 12 Sep 2019 06:36:13 -0400
Received: from Internal Mail-Server by MTLPINE1 (envelope-from sergeygo@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 12 Sep 2019 13:36:10 +0300
Received: from rsws38.mtr.labs.mlnx (rsws38.mtr.labs.mlnx [10.209.40.117])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id x8CAaAFY028251;
        Thu, 12 Sep 2019 13:36:10 +0300
From:   Sergey Gorenko <sergeygo@mellanox.com>
To:     linux-rdma@vger.kernel.org
Cc:     sagi@grimberg.me, maxg@mellanox.com,
        Sergey Gorenko <sergeygo@mellanox.com>
Subject: [PATCH v1] IB/iser: Support up to 16MB data transfer in a single command
Date:   Thu, 12 Sep 2019 10:35:34 +0000
Message-Id: <20190912103534.18210-1-sergeygo@mellanox.com>
X-Mailer: git-send-email 2.17.2
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

Maximum supported IO size is 8MB for the iSER driver. The
current value is limited by the ISCSI_ISER_MAX_SG_TABLESIZE
macro. But the driver is able to handle 16MB IOs without any
significant changes. Increasing this limit can be useful for
the storage arrays which are fine tuned for IOs larger than
8 MB.

This commit allows to configure maximum IO size up to 16MB
using the max_sectors module parameter.

Signed-off-by: Sergey Gorenko <sergeygo@mellanox.com>
Reviewed-by: Max Gurtovoy <maxg@mellanox.com>
Acked-by: Sagi Grimberg <sagi@grimberg.me>
---
Changes from v0:
- Change 512 to SECTOR_SIZE (suggested by Sagi)

 drivers/infiniband/ulp/iser/iscsi_iser.h | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/ulp/iser/iscsi_iser.h b/drivers/infiniband/ulp/iser/iscsi_iser.h
index 39bf213444cb..52ce63592dcf 100644
--- a/drivers/infiniband/ulp/iser/iscsi_iser.h
+++ b/drivers/infiniband/ulp/iser/iscsi_iser.h
@@ -102,9 +102,10 @@
 
 /* Default support is 512KB I/O size */
 #define ISER_DEF_MAX_SECTORS		1024
-#define ISCSI_ISER_DEF_SG_TABLESIZE	((ISER_DEF_MAX_SECTORS * 512) >> SHIFT_4K)
-/* Maximum support is 8MB I/O size */
-#define ISCSI_ISER_MAX_SG_TABLESIZE	((16384 * 512) >> SHIFT_4K)
+#define ISCSI_ISER_DEF_SG_TABLESIZE                                            \
+	((ISER_DEF_MAX_SECTORS * SECTOR_SIZE) >> SHIFT_4K)
+/* Maximum support is 16MB I/O size */
+#define ISCSI_ISER_MAX_SG_TABLESIZE	((32768 * SECTOR_SIZE) >> SHIFT_4K)
 
 #define ISER_DEF_XMIT_CMDS_DEFAULT		512
 #if ISCSI_DEF_XMIT_CMDS_MAX > ISER_DEF_XMIT_CMDS_DEFAULT
-- 
2.17.2

