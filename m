Return-Path: <linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6DDC7C433EF
	for <linux-rdma@archiver.kernel.org>; Sun, 12 Sep 2021 18:15:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 56B6361051
	for <linux-rdma@archiver.kernel.org>; Sun, 12 Sep 2021 18:15:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233978AbhILSQ6 (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Sun, 12 Sep 2021 14:16:58 -0400
Received: from saphodev.broadcom.com ([192.19.11.229]:34478 "EHLO
        relay.smtp-ext.broadcom.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234680AbhILSQy (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>);
        Sun, 12 Sep 2021 14:16:54 -0400
Received: from dhcp-10-192-206-197.iig.avagotech.net.net (dhcp-10-123-156-118.dhcp.broadcom.net [10.123.156.118])
        by relay.smtp-ext.broadcom.com (Postfix) with ESMTP id B9A267DBA;
        Sun, 12 Sep 2021 11:15:38 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 relay.smtp-ext.broadcom.com B9A267DBA
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=broadcom.com;
        s=dkimrelay; t=1631470539;
        bh=P7OIQEq1H0z2i3fvsEY10u2l149zjsQyse+HoeTNdKA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oqsVSJnpk7yaSnDbF8UlfN67a7tW5wb7ub9SP4nHVjHSitiVc0cWVT0bOGIXAPCos
         DZSLCAI2HDhBRqOwths9pR6HkoT2dWmMeMJnhvRcF554HV+b207GiiUbr081PJ9jhf
         EdNcp6YwYiwfZDbpjJ2ZCsAn7/grmv9iSqs12O6Q=
From:   Selvin Xavier <selvin.xavier@broadcom.com>
To:     dledford@redhat.com, jgg@nvidia.com
Cc:     linux-rdma@vger.kernel.org,
        Selvin Xavier <selvin.xavier@broadcom.com>
Subject: [PATCH for-next 06/12] RDMA/bnxt_re: Suppress unwanted error messages
Date:   Sun, 12 Sep 2021 11:15:20 -0700
Message-Id: <1631470526-22228-7-git-send-email-selvin.xavier@broadcom.com>
X-Mailer: git-send-email 2.5.5
In-Reply-To: <1631470526-22228-1-git-send-email-selvin.xavier@broadcom.com>
References: <1631470526-22228-1-git-send-email-selvin.xavier@broadcom.com>
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

Terminal CQEs are expected during QP destroy. Avoid
the unwanted error messages.

Signed-off-by: Selvin Xavier <selvin.xavier@broadcom.com>
---
 drivers/infiniband/hw/bnxt_re/qplib_fp.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/bnxt_re/qplib_fp.c b/drivers/infiniband/hw/bnxt_re/qplib_fp.c
index d0895e6..539b1a2 100644
--- a/drivers/infiniband/hw/bnxt_re/qplib_fp.c
+++ b/drivers/infiniband/hw/bnxt_re/qplib_fp.c
@@ -2854,6 +2854,7 @@ int bnxt_qplib_poll_cq(struct bnxt_qplib_cq *cq, struct bnxt_qplib_cqe *cqe,
 	struct cq_base *hw_cqe;
 	u32 sw_cons, raw_cons;
 	int budget, rc = 0;
+	u8 type;
 
 	raw_cons = cq->hwq.cons;
 	budget = num_cqes;
@@ -2872,7 +2873,8 @@ int bnxt_qplib_poll_cq(struct bnxt_qplib_cq *cq, struct bnxt_qplib_cqe *cqe,
 		 */
 		dma_rmb();
 		/* From the device's respective CQE format to qplib_wc*/
-		switch (hw_cqe->cqe_type_toggle & CQ_BASE_CQE_TYPE_MASK) {
+		type = hw_cqe->cqe_type_toggle & CQ_BASE_CQE_TYPE_MASK;
+		switch (type) {
 		case CQ_BASE_CQE_TYPE_REQ:
 			rc = bnxt_qplib_cq_process_req(cq,
 						       (struct cq_req *)hw_cqe,
@@ -2919,8 +2921,9 @@ int bnxt_qplib_poll_cq(struct bnxt_qplib_cq *cq, struct bnxt_qplib_cqe *cqe,
 			/* Error while processing the CQE, just skip to the
 			 * next one
 			 */
-			dev_err(&cq->hwq.pdev->dev,
-				"process_cqe error rc = 0x%x\n", rc);
+			if (type != CQ_BASE_CQE_TYPE_TERMINAL)
+				dev_err(&cq->hwq.pdev->dev,
+					"process_cqe error rc = 0x%x\n", rc);
 		}
 		raw_cons++;
 	}
-- 
2.5.5

