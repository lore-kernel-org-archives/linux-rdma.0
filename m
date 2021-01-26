Return-Path: <linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0C6EC433E6
	for <linux-rdma@archiver.kernel.org>; Tue, 26 Jan 2021 12:50:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BE86E23123
	for <linux-rdma@archiver.kernel.org>; Tue, 26 Jan 2021 12:50:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392140AbhAZMuA (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Tue, 26 Jan 2021 07:50:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2392106AbhAZMt4 (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Tue, 26 Jan 2021 07:49:56 -0500
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BCD4C08EB24
        for <linux-rdma@vger.kernel.org>; Tue, 26 Jan 2021 04:47:50 -0800 (PST)
Received: by mail-wr1-x435.google.com with SMTP id b5so16308477wrr.10
        for <linux-rdma@vger.kernel.org>; Tue, 26 Jan 2021 04:47:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=bWXDn1Q9e79o1Ahbq11jdzTrjLD5igFdf2jngDni798=;
        b=GPuwh5UMbRYTIAqxWcuNWJoL/UZWeUSNS+EYoNcJ91J1TkfsGI0YNqhubB8RQGeReP
         neR90OV2gzOy6VqYlffob/ri5kelHkNcePX6VgL5r6gjn53vWKYh1VhkWeVMupGxgm6L
         Kyk2/aynygYowh/ZUb+kJT+/UzEgzQh8/S39Aj5luzRPazsi5gYNnVxOy25nQ2hIWfrW
         oEqQPDq0lO6Fu0Mc+7vHtAf6nkQJaDUyF6Lz4A2Ljfwt/JxlLysavqwwH2dYXWr97Er0
         tP+eCmUz7yoWJoSEEQm/BxcMxpvB5T0xjZLLveUJp5jFyX56K967T7uxSIKonfYu4t1T
         mj3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=bWXDn1Q9e79o1Ahbq11jdzTrjLD5igFdf2jngDni798=;
        b=H7Rk3lnvBlc+Ald9cK+csH5NoAYD0aKYBoR/zBIC79yeB0iIMbeqE7TSa8tJ44PFo1
         ajRzZV2mpX0qtVG5Eo7BEuk8UzlP1VcIkawfELJ92YnOSv+0TlFyC7kzkQMGnwmPgvzl
         mHSkAqFRTcXWa+w3WVa3z8BAge/lng/peDicfdBmFwVJfO85mhV3aD68ojdF40rkZRpq
         wr/6rEAN4gNU8JsL9YwARKDaV10LqEUMvcYlma++aDzlf2pv2NHhP1sZ008bEuIe9JVy
         rd2DVeF2v3/+Ao3oLB96ihYgBAQ1kGtHr66cAxEFDcS93TUQIoWHhB0+HTgx7FcbJiD8
         hVmA==
X-Gm-Message-State: AOAM5318Pt2AvFEbp+vr5hW2L2sXbq/jtEMYC2iq1BzpN0p/VDVST37q
        AvGJAGbV+mRGp2Jy31tl1+qqsg==
X-Google-Smtp-Source: ABdhPJyoqraqYP5Lncuk2TmsiQknmS5tV0xjuVaaRBE6kIXCodS8Icxj6NLW9Dse8QaRWrHHIWGA5g==
X-Received: by 2002:adf:f403:: with SMTP id g3mr5943566wro.212.1611665269305;
        Tue, 26 Jan 2021 04:47:49 -0800 (PST)
Received: from dell.default ([91.110.221.188])
        by smtp.gmail.com with ESMTPSA id p15sm26942190wrt.15.2021.01.26.04.47.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Jan 2021 04:47:48 -0800 (PST)
From:   Lee Jones <lee.jones@linaro.org>
To:     lee.jones@linaro.org
Cc:     linux-kernel@vger.kernel.org,
        Mike Marciniszyn <mike.marciniszyn@cornelisnetworks.com>,
        Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>,
        Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>, linux-rdma@vger.kernel.org
Subject: [PATCH 12/20] RDMA/hw/hfi1/qp: Fix some formatting issues and demote kernel-doc abuse
Date:   Tue, 26 Jan 2021 12:47:24 +0000
Message-Id: <20210126124732.3320971-13-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210126124732.3320971-1-lee.jones@linaro.org>
References: <20210126124732.3320971-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

Fixes the following W=1 kernel build warning(s):

 drivers/infiniband/hw/hfi1/qp.c:195: warning: Function parameter or member 'dev' not described in 'verbs_mtu_enum_to_int'
 drivers/infiniband/hw/hfi1/qp.c:195: warning: Function parameter or member 'mtu' not described in 'verbs_mtu_enum_to_int'
 drivers/infiniband/hw/hfi1/qp.c:306: warning: Function parameter or member 'qp' not described in 'hfi1_setup_wqe'
 drivers/infiniband/hw/hfi1/qp.c:306: warning: Function parameter or member 'wqe' not described in 'hfi1_setup_wqe'
 drivers/infiniband/hw/hfi1/qp.c:306: warning: Function parameter or member 'call_send' not described in 'hfi1_setup_wqe'
 drivers/infiniband/hw/hfi1/qp.c:922: warning: Function parameter or member 'qp' not described in 'hfi1_qp_iter_cb'
 drivers/infiniband/hw/hfi1/qp.c:922: warning: Function parameter or member 'v' not described in 'hfi1_qp_iter_cb'

Cc: Mike Marciniszyn <mike.marciniszyn@cornelisnetworks.com>
Cc: Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>
Cc: Doug Ledford <dledford@redhat.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: linux-rdma@vger.kernel.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/infiniband/hw/hfi1/qp.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/qp.c b/drivers/infiniband/hw/hfi1/qp.c
index 681bb4e918c92..e037df9115127 100644
--- a/drivers/infiniband/hw/hfi1/qp.c
+++ b/drivers/infiniband/hw/hfi1/qp.c
@@ -186,7 +186,7 @@ static void flush_iowait(struct rvt_qp *qp)
 	write_sequnlock_irqrestore(lock, flags);
 }
 
-/**
+/*
  * This function is what we would push to the core layer if we wanted to be a
  * "first class citizen".  Instead we hide this here and rely on Verbs ULPs
  * to blindly pass the MTU enum value from the PathRecord to us.
@@ -289,9 +289,9 @@ void hfi1_modify_qp(struct rvt_qp *qp, struct ib_qp_attr *attr,
 
 /**
  * hfi1_setup_wqe - set up the wqe
- * @qp - The qp
- * @wqe - The built wqe
- * @call_send - Determine if the send should be posted or scheduled.
+ * @qp: The qp
+ * @wqe: The built wqe
+ * @call_send: Determine if the send should be posted or scheduled.
  *
  * Perform setup of the wqe.  This is called
  * prior to inserting the wqe into the ring but after
@@ -595,7 +595,7 @@ struct sdma_engine *qp_to_sdma_engine(struct rvt_qp *qp, u8 sc5)
 	return sde;
 }
 
-/*
+/**
  * qp_to_send_context - map a qp to a send context
  * @qp: the QP
  * @sc5: the 5 bit sc
@@ -912,8 +912,8 @@ void notify_error_qp(struct rvt_qp *qp)
 
 /**
  * hfi1_qp_iter_cb - callback for iterator
- * @qp - the qp
- * @v - the sl in low bits of v
+ * @qp: the qp
+ * @v: the sl in low bits of v
  *
  * This is called from the iterator callback to work
  * on an individual qp.
-- 
2.25.1

