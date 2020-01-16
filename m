Return-Path: <SRS0=Ta2D=3F=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 150D9C33CB6
	for <linux-rdma@archiver.kernel.org>; Thu, 16 Jan 2020 17:19:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D5FCE22522
	for <linux-rdma@archiver.kernel.org>; Thu, 16 Jan 2020 17:19:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1579195142;
	bh=KPnjpl96N2d7rCs0uOIvKJYlAl/Kz6G527NiVyU+Zlg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=aVl80HkirijrMseN0Ve5/lN3WBX9LD4BGssTU+3M1UZlCy+RhVFYrHWFEE6SNvnjJ
	 5xd+gVFcb+3cFCm/5x8cK/BhE/EVksskYDuFrBa6EfcTaonqJEVPJBlAov3TeoJA/5
	 Rv2Va/cuLTDbYpEpqgrEvEcXzoiJsxZS2I8sMyI0=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391521AbgAPRSh (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Thu, 16 Jan 2020 12:18:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:46452 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391515AbgAPRSg (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Thu, 16 Jan 2020 12:18:36 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 71418246B1;
        Thu, 16 Jan 2020 17:18:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579195116;
        bh=KPnjpl96N2d7rCs0uOIvKJYlAl/Kz6G527NiVyU+Zlg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AUVs8Kr5pijvoV+Sz2eqpm7DraNWkDrU7Cj7Dp1fBKV+1/kV+rBhVAQPF7GYhPZR7
         0UWsSYYDaWmdRI2BI4MuyIe5/JqVn3M7ffnqTAvb32WhHRvl9aeDX0EEO4SV0R26kV
         CrFYg5Tq42AH2ygLzoZx1lOIn9LSpGMSzfK/PT1E=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Raju Rangoju <rajur@chelsio.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>, linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 056/371] RDMA/iw_cxgb4: Fix the unchecked ep dereference
Date:   Thu, 16 Jan 2020 12:12:04 -0500
Message-Id: <20200116171719.16965-56-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116171719.16965-1-sashal@kernel.org>
References: <20200116171719.16965-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

From: Raju Rangoju <rajur@chelsio.com>

[ Upstream commit 3352976c892301fd576a2e9ff0ac7337b2e2ca48 ]

The patch 944661dd97f4: "RDMA/iw_cxgb4: atomically lookup ep and get a
reference" from May 6, 2016, leads to the following Smatch complaint:

    drivers/infiniband/hw/cxgb4/cm.c:2953 terminate()
    error: we previously assumed 'ep' could be null (see line 2945)

Fixes: 944661dd97f4 ("RDMA/iw_cxgb4: atomically lookup ep and get a reference")
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Raju Rangoju <rajur@chelsio.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/cxgb4/cm.c | 17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb4/cm.c b/drivers/infiniband/hw/cxgb4/cm.c
index bb36cdf82a8d..3668cc71b47e 100644
--- a/drivers/infiniband/hw/cxgb4/cm.c
+++ b/drivers/infiniband/hw/cxgb4/cm.c
@@ -2923,15 +2923,18 @@ static int terminate(struct c4iw_dev *dev, struct sk_buff *skb)
 	ep = get_ep_from_tid(dev, tid);
 	BUG_ON(!ep);
 
-	if (ep && ep->com.qp) {
-		pr_warn("TERM received tid %u qpid %u\n",
-			tid, ep->com.qp->wq.sq.qid);
-		attrs.next_state = C4IW_QP_STATE_TERMINATE;
-		c4iw_modify_qp(ep->com.qp->rhp, ep->com.qp,
-			       C4IW_QP_ATTR_NEXT_STATE, &attrs, 1);
+	if (ep) {
+		if (ep->com.qp) {
+			pr_warn("TERM received tid %u qpid %u\n", tid,
+				ep->com.qp->wq.sq.qid);
+			attrs.next_state = C4IW_QP_STATE_TERMINATE;
+			c4iw_modify_qp(ep->com.qp->rhp, ep->com.qp,
+				       C4IW_QP_ATTR_NEXT_STATE, &attrs, 1);
+		}
+
+		c4iw_put_ep(&ep->com);
 	} else
 		pr_warn("TERM received tid %u no ep/qp\n", tid);
-	c4iw_put_ep(&ep->com);
 
 	return 0;
 }
-- 
2.20.1

