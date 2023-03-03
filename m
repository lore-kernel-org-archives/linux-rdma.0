Return-Path: <linux-rdma-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E873FC678D4
	for <linux-rdma@archiver.kernel.org>; Fri,  3 Mar 2023 12:44:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229541AbjCCMoR (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Fri, 3 Mar 2023 07:44:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbjCCMoR (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Fri, 3 Mar 2023 07:44:17 -0500
Received: from exchange.fintech.ru (e10edge.fintech.ru [195.54.195.159])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F28991815F;
        Fri,  3 Mar 2023 04:44:14 -0800 (PST)
Received: from Ex16-01.fintech.ru (10.0.10.18) by exchange.fintech.ru
 (195.54.195.159) with Microsoft SMTP Server (TLS) id 14.3.498.0; Fri, 3 Mar
 2023 15:44:11 +0300
Received: from KANASHIN1.fintech.ru (10.0.253.125) by Ex16-01.fintech.ru
 (10.0.10.18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2242.4; Fri, 3 Mar 2023
 15:44:11 +0300
From:   Natalia Petrova <n.petrova@fintech.ru>
To:     Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>
CC:     Natalia Petrova <n.petrova@fintech.ru>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Leon Romanovsky <leon@kernel.org>,
        <linux-rdma@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <ldv-project@linuxtesting.org>
Subject: [PATCH v2] rdmavt: delete unnecessary NULL check
Date:   Fri, 3 Mar 2023 15:44:08 +0300
Message-ID: <20230303124408.16685-1-n.petrova@fintech.ru>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <4c6939b5-05b9-1346-5376-82011b4cc093@cornelisnetworks.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.0.253.125]
X-ClientProxiedBy: Ex16-02.fintech.ru (10.0.10.19) To Ex16-01.fintech.ru
 (10.0.10.18)
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

There is no need to check 'rdi->qp_dev' for NULL. The field 'qp_dev'
is created in rvt_register_device() which will fail if the 'qp_dev'
allocation fails in rvt_driver_qp_init(). Overwise this pointer
doesn't changed and passed to rvt_qp_exit() by the next step.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: 0acb0cc7ecc1 ("IB/rdmavt: Initialize and teardown of qpn table")
Signed-off-by: Natalia Petrova <n.petrova@fintech.ru>
---
v2: The remark about non-null value of 'rdi->qp_dev' by Leon Romanovsky <leon@kernel.org>
and Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com> was taken into account.
 drivers/infiniband/sw/rdmavt/qp.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/infiniband/sw/rdmavt/qp.c b/drivers/infiniband/sw/rdmavt/qp.c
index 3acab569fbb9..2bdc4486c3da 100644
--- a/drivers/infiniband/sw/rdmavt/qp.c
+++ b/drivers/infiniband/sw/rdmavt/qp.c
@@ -464,8 +464,6 @@ void rvt_qp_exit(struct rvt_dev_info *rdi)
 	if (qps_inuse)
 		rvt_pr_err(rdi, "QP memory leak! %u still in use\n",
 			   qps_inuse);
-	if (!rdi->qp_dev)
-		return;
 
 	kfree(rdi->qp_dev->qp_table);
 	free_qpn_table(&rdi->qp_dev->qpn_table);
-- 
2.34.1

