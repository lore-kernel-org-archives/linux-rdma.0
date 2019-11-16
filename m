Return-Path: <SRS0=zL3b=ZI=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59476C432C3
	for <linux-rdma@archiver.kernel.org>; Sat, 16 Nov 2019 16:14:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3126E21479
	for <linux-rdma@archiver.kernel.org>; Sat, 16 Nov 2019 16:14:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1573920847;
	bh=lk+Xh0MaiD1FoRGNeq29i40Di3Mj0VgeUVYmCBBoJno=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=etLx6slDeVysK260jqfhsev01It8kau7kvWkkNJYTwED2vUg6ltM93pLt89W7X5rQ
	 s7rxpQcwyzDfJCzfBk7uZzm+aZfZLDgmj8w9IsJEnK+ISp4vqiwGNR7x+D6Nx8YT79
	 WYCdLG8ZZot3Ylb4xqjqOc7u/LwFr5NdPRT1WFl8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730301AbfKPQOB (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Sat, 16 Nov 2019 11:14:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:54730 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728458AbfKPPry (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Sat, 16 Nov 2019 10:47:54 -0500
Received: from sasha-vm.mshome.net (unknown [50.234.116.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0C2652086A;
        Sat, 16 Nov 2019 15:47:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573919274;
        bh=lk+Xh0MaiD1FoRGNeq29i40Di3Mj0VgeUVYmCBBoJno=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ygkS7N6wjRqLBg1qvRb0YJ9C0VtBqo/ewZavPGUdPnleUCANYrJRVQ2/aFrA/F4LJ
         ibpRvoMnZNBPTKcVdKWap1i8d8u86uermwstMP3lYGWqTFc78tm9/eN/9GcZZJcjqG
         Depv/gkmwN4TmOM3KJBDJTWDkYd+8zb6SYofi3YA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Devesh Sharma <devesh.sharma@broadcom.com>,
        Selvin Xavier <selvin.xavier@broadcom.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>, linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 022/150] RDMA/bnxt_re: Fix qp async event reporting
Date:   Sat, 16 Nov 2019 10:45:20 -0500
Message-Id: <20191116154729.9573-22-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191116154729.9573-1-sashal@kernel.org>
References: <20191116154729.9573-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

From: Devesh Sharma <devesh.sharma@broadcom.com>

[ Upstream commit 4c01f2e3a906a0d2d798be5751c331cf501bc129 ]

Reports affiliated async event on the qp-async event channel instead of
global event channel.

Signed-off-by: Devesh Sharma <devesh.sharma@broadcom.com>
Signed-off-by: Selvin Xavier <selvin.xavier@broadcom.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/bnxt_re/main.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/hw/bnxt_re/main.c b/drivers/infiniband/hw/bnxt_re/main.c
index bf811b23bc953..7d00b6a53ed8c 100644
--- a/drivers/infiniband/hw/bnxt_re/main.c
+++ b/drivers/infiniband/hw/bnxt_re/main.c
@@ -782,12 +782,17 @@ static void bnxt_re_dispatch_event(struct ib_device *ibdev, struct ib_qp *qp,
 	struct ib_event ib_event;
 
 	ib_event.device = ibdev;
-	if (qp)
+	if (qp) {
 		ib_event.element.qp = qp;
-	else
+		ib_event.event = event;
+		if (qp->event_handler)
+			qp->event_handler(&ib_event, qp->qp_context);
+
+	} else {
 		ib_event.element.port_num = port_num;
-	ib_event.event = event;
-	ib_dispatch_event(&ib_event);
+		ib_event.event = event;
+		ib_dispatch_event(&ib_event);
+	}
 }
 
 #define HWRM_QUEUE_PRI2COS_QCFG_INPUT_FLAGS_IVLAN      0x02
-- 
2.20.1

