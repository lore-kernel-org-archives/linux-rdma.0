Return-Path: <SRS0=zL3b=ZI=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3BDAC432C3
	for <linux-rdma@archiver.kernel.org>; Sat, 16 Nov 2019 15:41:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9277620740
	for <linux-rdma@archiver.kernel.org>; Sat, 16 Nov 2019 15:41:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1573918918;
	bh=N6n1vejcjZHQsQPa2gtPju+sXlhGmVg6/fyj4DwkZCs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=ST8lWYNeOxs8zniNGskLdxFyDjttMGofUx60vw1zcImxzVKai+Ttj7amarJS8nIDN
	 fF3kEtFRgIX5uvxLS8ZtHNlh+/CLb6WTfdPjUEOWJQkdsfhecNd0RGFVxZjBOiOrNv
	 js2soHdDYgCidicnJ2Gyznw+5+GPVqbvhXuyH7a8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728065AbfKPPl5 (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Sat, 16 Nov 2019 10:41:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:45320 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728049AbfKPPl4 (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Sat, 16 Nov 2019 10:41:56 -0500
Received: from sasha-vm.mshome.net (unknown [50.234.116.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C06DC2084C;
        Sat, 16 Nov 2019 15:41:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573918916;
        bh=N6n1vejcjZHQsQPa2gtPju+sXlhGmVg6/fyj4DwkZCs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DWAAZuMg6V3d8LWqETHEg9d/DUOkl2ZdWb/GLiPW1Drv2WAOsRKdUNwss2BxH/Pss
         MzlvVjDKjIcjQn49Cn5UYF0dyh5FnV7VaTU9D47XvEv3jrCfMo7Rru2beK/rS0Xw1y
         WolKpug1qa7QsuETe42xYyUPQcPVWb5GAmAO087Q=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Devesh Sharma <devesh.sharma@broadcom.com>,
        Selvin Xavier <selvin.xavier@broadcom.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>, linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 039/237] RDMA/bnxt_re: Fix qp async event reporting
Date:   Sat, 16 Nov 2019 10:37:54 -0500
Message-Id: <20191116154113.7417-39-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191116154113.7417-1-sashal@kernel.org>
References: <20191116154113.7417-1-sashal@kernel.org>
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
index 22bd9784fa2ea..7ffad368c5fa1 100644
--- a/drivers/infiniband/hw/bnxt_re/main.c
+++ b/drivers/infiniband/hw/bnxt_re/main.c
@@ -989,12 +989,17 @@ static void bnxt_re_dispatch_event(struct ib_device *ibdev, struct ib_qp *qp,
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

