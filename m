Return-Path: <linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02C20C433F5
	for <linux-rdma@archiver.kernel.org>; Thu, 12 May 2022 19:51:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358186AbiELTve (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Thu, 12 May 2022 15:51:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358162AbiELTvb (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Thu, 12 May 2022 15:51:31 -0400
Received: from mail-ot1-x335.google.com (mail-ot1-x335.google.com [IPv6:2607:f8b0:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 117F166F96
        for <linux-rdma@vger.kernel.org>; Thu, 12 May 2022 12:51:29 -0700 (PDT)
Received: by mail-ot1-x335.google.com with SMTP id a22-20020a9d3e16000000b00606aeb12ab6so3455851otd.7
        for <linux-rdma@vger.kernel.org>; Thu, 12 May 2022 12:51:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=1pOaLacqVxa1Tw/8UBT7hlttoHgFcz/sMZIAh+3kI2Q=;
        b=VpavkPi29f5lPwXfqijc005ABWRihmkPlndDU8b30t5bbP2gXSzf2nAoUSqg+msS1/
         XyPT2ZX61q7Cep0zuXYb9lVRxH+QuUDYGmEJw4xj1jsl+nWWS4ggqhdzFS1IdThsoIRv
         p7d2iud1TIl4pRplWo0TtLor1IdbmctNQhi/t+XUOwkGsI8xI2a5iUwx2axJoDXk8/yf
         Y5bsIo69+ZyB3s/hVgAkNgE8t8Y733QlqVF4p6Ndgu/nSqYL/JmyCWdUO+IrFFlf6pKz
         OviWLWqzd+qWuDwiBUz/taReSxiGooCXlVyAfVIwPR64Yp0oLxNorsPZllPQ26lrMy/g
         9NhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=1pOaLacqVxa1Tw/8UBT7hlttoHgFcz/sMZIAh+3kI2Q=;
        b=Y8/g9AN9PyZUdGYeaF3OwfAFrOFjUWASZM4oHoURScj3pURfnh9UvrKeazDK6M+m1t
         1Vz3aWpngvXh79RTuheSIh9QbPNyqLEqmuPaEWcMRE1PcrEwsxISK6d3fyo1YGrXjmZk
         SE8z5UYfFe+jiTkv7cq6/jkOzYSuClteG8wzlg4UL6kAZOlygZz1sWb/euMHF30ZLape
         /jkXxY+pyQsnfJt0qqX/VlTKrJvTciTQLCur6SuCzdenhsPhwcfnFJtthOKgG+wIa2bp
         M79uK2t9Oy8GxtmbrjQfE+Rt4/SDUKmq3n3imUGW4cmr7TxYpTC9KPs5bIDnIn+kSYpB
         w2/A==
X-Gm-Message-State: AOAM530z2M3kAF1+OTPrgDThBbrw9Nd/ZjLA9K7XTNQJAj5TtZ9cUeMt
        x/DeqZYIhxpJMAI4+/sODP0=
X-Google-Smtp-Source: ABdhPJyOP5oTiYqM81qgQjCaWJujf4MT8h+zZXozyFPA8hyC6Z42bI6QuRlXCJpC/7BSWFvq7XwKIA==
X-Received: by 2002:a9d:22e9:0:b0:605:d008:c1d7 with SMTP id y96-20020a9d22e9000000b00605d008c1d7mr632917ota.186.1652385085758;
        Thu, 12 May 2022 12:51:25 -0700 (PDT)
Received: from u-22.tx.rr.com (2603-8081-140c-1a00-2668-8102-5357-772c.res6.spectrum.com. [2603:8081:140c:1a00:2668:8102:5357:772c])
        by smtp.googlemail.com with ESMTPSA id w133-20020acadf8b000000b00326414c1bb7sm274413oig.35.2022.05.12.12.51.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 May 2022 12:51:25 -0700 (PDT)
From:   Bob Pearson <rpearsonhpe@gmail.com>
To:     jgg@nvidia.com, zyjzyj2000@gmail.com, linux-rdma@vger.kernel.org
Cc:     Bob Pearson <rpearsonhpe@gmail.com>
Subject: [PATCH for-rc] RDMA/rxe: Fix rnr retry behavior
Date:   Thu, 12 May 2022 14:49:02 -0500
Message-Id: <20220512194901.76696-1-rpearsonhpe@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

Currently the completer tasklet when it sets the retransmit timer or the
nak timer sets the same flag (qp->req.need_retry) so that if either
timer fires it will attempt to perform a retry flow on the send queue.
This has the effect of responding to an RNR NAK at the first retransmit
timer event which does not allow for the requested rnr timeout.

This patch adds a new flag (qp->req.need_rnr_timeout) which, if set,
prevents a retry flow until the rnr nak timer fires.

This patch fixes rnr retry errors which can be observed by running the
pyverbs test suite 50-100X. With this patch applied they do not occur.

Link: https://lore.kernel.org/linux-rdma/a8287823-1408-4273-bc22-99a0678db640@gmail.com/
Fixes: 8700e3e7c485 ("Soft RoCE (RXE) - The software RoCE driver")
Signed-off-by: Bob Pearson <rpearsonhpe@gmail.com>
---
 drivers/infiniband/sw/rxe/rxe_comp.c  | 4 +---
 drivers/infiniband/sw/rxe/rxe_qp.c    | 1 +
 drivers/infiniband/sw/rxe/rxe_req.c   | 6 ++++--
 drivers/infiniband/sw/rxe/rxe_verbs.h | 1 +
 4 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/infiniband/sw/rxe/rxe_comp.c b/drivers/infiniband/sw/rxe/rxe_comp.c
index 138b3e7d3a5f..bc668cb211b1 100644
--- a/drivers/infiniband/sw/rxe/rxe_comp.c
+++ b/drivers/infiniband/sw/rxe/rxe_comp.c
@@ -733,9 +733,7 @@ int rxe_completer(void *arg)
 				if (qp->comp.rnr_retry != 7)
 					qp->comp.rnr_retry--;
 
-				qp->req.need_retry = 1;
-				pr_debug("qp#%d set rnr nak timer\n",
-					 qp_num(qp));
+				qp->req.need_rnr_timeout = 1;
 				mod_timer(&qp->rnr_nak_timer,
 					  jiffies + rnrnak_jiffies(aeth_syn(pkt)
 						& ~AETH_TYPE_MASK));
diff --git a/drivers/infiniband/sw/rxe/rxe_qp.c b/drivers/infiniband/sw/rxe/rxe_qp.c
index 62acf890af6c..1c962468714e 100644
--- a/drivers/infiniband/sw/rxe/rxe_qp.c
+++ b/drivers/infiniband/sw/rxe/rxe_qp.c
@@ -513,6 +513,7 @@ static void rxe_qp_reset(struct rxe_qp *qp)
 	atomic_set(&qp->ssn, 0);
 	qp->req.opcode = -1;
 	qp->req.need_retry = 0;
+	qp->req.need_rnr_timeout = 0;
 	qp->req.noack_pkts = 0;
 	qp->resp.msn = 0;
 	qp->resp.opcode = -1;
diff --git a/drivers/infiniband/sw/rxe/rxe_req.c b/drivers/infiniband/sw/rxe/rxe_req.c
index ae5fbc79dd5c..770ae4279f73 100644
--- a/drivers/infiniband/sw/rxe/rxe_req.c
+++ b/drivers/infiniband/sw/rxe/rxe_req.c
@@ -103,7 +103,8 @@ void rnr_nak_timer(struct timer_list *t)
 {
 	struct rxe_qp *qp = from_timer(qp, t, rnr_nak_timer);
 
-	pr_debug("qp#%d rnr nak timer fired\n", qp_num(qp));
+	qp->req.need_retry = 1;
+	qp->req.need_rnr_timeout = 0;
 	rxe_run_task(&qp->req.task, 1);
 }
 
@@ -624,10 +625,11 @@ int rxe_requester(void *arg)
 		qp->req.need_rd_atomic = 0;
 		qp->req.wait_psn = 0;
 		qp->req.need_retry = 0;
+		qp->req.need_rnr_timeout = 0;
 		goto exit;
 	}
 
-	if (unlikely(qp->req.need_retry)) {
+	if (unlikely(qp->req.need_retry && !qp->req.need_rnr_timeout)) {
 		req_retry(qp);
 		qp->req.need_retry = 0;
 	}
diff --git a/drivers/infiniband/sw/rxe/rxe_verbs.h b/drivers/infiniband/sw/rxe/rxe_verbs.h
index e7eff1ca75e9..ab3186478c3f 100644
--- a/drivers/infiniband/sw/rxe/rxe_verbs.h
+++ b/drivers/infiniband/sw/rxe/rxe_verbs.h
@@ -123,6 +123,7 @@ struct rxe_req_info {
 	int			need_rd_atomic;
 	int			wait_psn;
 	int			need_retry;
+	int			need_rnr_timeout;
 	int			noack_pkts;
 	struct rxe_task		task;
 };

base-commit: c5eb0a61238dd6faf37f58c9ce61c9980aaffd7a
-- 
2.34.1

