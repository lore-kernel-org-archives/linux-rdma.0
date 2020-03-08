Return-Path: <SRS0=c/Wa=4Z=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DAB4EC10F28
	for <linux-rdma@archiver.kernel.org>; Sun,  8 Mar 2020 06:54:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BCC6D20828
	for <linux-rdma@archiver.kernel.org>; Sun,  8 Mar 2020 06:54:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726265AbgCHGyw (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Sun, 8 Mar 2020 01:54:52 -0500
Received: from smtp13.smtpout.orange.fr ([80.12.242.135]:17013 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726213AbgCHGyw (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Sun, 8 Mar 2020 01:54:52 -0500
Received: from localhost.localdomain ([90.126.162.40])
        by mwinf5d75 with ME
        id Biul220010scBcy03iulFb; Sun, 08 Mar 2020 07:54:48 +0100
X-ME-Helo: localhost.localdomain
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Sun, 08 Mar 2020 07:54:48 +0100
X-ME-IP: 90.126.162.40
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     selvin.xavier@broadcom.com, devesh.sharma@broadcom.com,
        somnath.kotur@broadcom.com, sriharsha.basavapatna@broadcom.com,
        dledford@redhat.com, jgg@ziepe.ca
Cc:     linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH] RDMA/bnxt_re: Remove a redundant 'memset'
Date:   Sun,  8 Mar 2020 07:54:42 +0100
Message-Id: <20200308065442.5415-1-christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

'wqe' is already zeroed at the top of the 'while' loop, just a few lines
below, and is not used outside of the loop.
So there is no need to zero it here as well.

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
 drivers/infiniband/hw/bnxt_re/ib_verbs.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/infiniband/hw/bnxt_re/ib_verbs.c b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
index ad3e524187e3..15494ca33092 100644
--- a/drivers/infiniband/hw/bnxt_re/ib_verbs.c
+++ b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
@@ -2475,7 +2475,6 @@ static int bnxt_re_post_send_shadow_qp(struct bnxt_re_dev *rdev,
 	unsigned long flags;
 
 	spin_lock_irqsave(&qp->sq_lock, flags);
-	memset(&wqe, 0, sizeof(wqe));
 	while (wr) {
 		/* House keeping */
 		memset(&wqe, 0, sizeof(wqe));
-- 
2.20.1

