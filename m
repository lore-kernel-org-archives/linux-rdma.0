Return-Path: <linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5FDB7C4743D
	for <linux-rdma@archiver.kernel.org>; Sat,  5 Jun 2021 12:21:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 42F77611C2
	for <linux-rdma@archiver.kernel.org>; Sat,  5 Jun 2021 12:21:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230245AbhFEMWz (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Sat, 5 Jun 2021 08:22:55 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:47939 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229924AbhFEMWx (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Sat, 5 Jun 2021 08:22:53 -0400
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <colin.king@canonical.com>)
        id 1lpVIS-0006jg-4y; Sat, 05 Jun 2021 12:21:00 +0000
From:   Colin King <colin.king@canonical.com>
To:     Mustafa Ismail <mustafa.ismail@intel.com>,
        Shiraz Saleem <shiraz.saleem@intel.com>,
        Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>, linux-rdma@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH][next] RDMA/irdma: Fix issues with u8 left shift operation
Date:   Sat,  5 Jun 2021 13:20:59 +0100
Message-Id: <20210605122059.25105-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

The shifting of the u8 integer info->map[i] the left will be promoted
to a 32 bit signed int and then sign-extended to a u64. In the event
that the top bit of the u8 is set then all then all the upper 32 bits
of the u64 end up as also being set because of the sign-extension.
Fix this by casting the u8 values to a u64 before the left shift. This

Addresses-Coverity: ("Unitentional integer overflow / bad shift operation")
Fixes: 3f49d6842569 ("RDMA/irdma: Implement HW Admin Queue OPs")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/infiniband/hw/irdma/ctrl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/irdma/ctrl.c b/drivers/infiniband/hw/irdma/ctrl.c
index 5aa112067bce..8bd3aecadaf6 100644
--- a/drivers/infiniband/hw/irdma/ctrl.c
+++ b/drivers/infiniband/hw/irdma/ctrl.c
@@ -2157,7 +2157,7 @@ static enum irdma_status_code irdma_sc_set_up_map(struct irdma_sc_cqp *cqp,
 		return IRDMA_ERR_RING_FULL;
 
 	for (i = 0; i < IRDMA_MAX_USER_PRIORITY; i++)
-		temp |= info->map[i] << (i * 8);
+		temp |= (u64)info->map[i] << (i * 8);
 
 	set_64bit_val(wqe, 0, temp);
 	set_64bit_val(wqe, 40,
-- 
2.31.1

