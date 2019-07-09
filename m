Return-Path: <SRS0=3zC3=VG=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0CE5AC73C5C
	for <linux-rdma@archiver.kernel.org>; Tue,  9 Jul 2019 22:13:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C805820693
	for <linux-rdma@archiver.kernel.org>; Tue,  9 Jul 2019 22:13:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NhWK3RQH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726133AbfGIWNt (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Tue, 9 Jul 2019 18:13:49 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:43410 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725816AbfGIWNs (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Tue, 9 Jul 2019 18:13:48 -0400
Received: by mail-wr1-f66.google.com with SMTP id p13so376458wru.10;
        Tue, 09 Jul 2019 15:13:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=qFvDzlxiFD6DDZKfIlqp1XR84wt2H+iEO1EU/utM7ok=;
        b=NhWK3RQHETf/QaeVtOQQeGPxiWXIRlWK9GlmEbc9kCQTYfmTxL9k/5WnzEOQSmoust
         i06Ncbo+LwREnCrn7iwGdnUfXfB00AXy5LsKYTyMUehkxiehTHOBktTfx6w0SmhLtVbn
         yH5x1vaby5TYWXbfSQvbKVFZYoC6LPmFg0bItiRNGHsottgaeMWtFwGQRlDbGhNfLd66
         NDS1vFah4pafXjwmAx6hD17M1HAwp4t605yPiPLvjf73C70Fe8P+B9ZEtji85z3Egj3X
         TEHIQocyJH+lJyLZEozeJoRRHxAFAIuENcpNBsUhAcziNYnnQ2hTkZGFAFarJSJJj4A5
         XIEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=qFvDzlxiFD6DDZKfIlqp1XR84wt2H+iEO1EU/utM7ok=;
        b=tEqjmf2UxjtvB2MQcxBe0wkfpvs1/dmvmgjdBPQmrEAmCXplS/4PZyM4NZE0yTglID
         t1OEgg7t+g5RsxWFXzfIo60bx6oAc/dTkfwLWCYh8pB+LUfkrkLtPpo7YQoSUWF1Gw8u
         RQKXOD/oJM3gWSpOb7J+jScELnUpoiCCBH1H71kW69EkIEyejSZ9bBV7ip+UQO2N66Ur
         uGlbrQQJsQBRJdD8NGSrLOp3GE8MRKDvopzOMWs4i1jaGGr/L4ZuIbN1w/Oc2Ba08z1z
         INavroL241mHrabxqOdNM5UbvunWx8oagn+OtylPT6A6AuIIkifh+hwshtWwE3gSDgmi
         Bv2g==
X-Gm-Message-State: APjAAAWAJpEsH+Z2DwsAntxyufwnPzcKVysWCrDpVYPnbPsrDDXvr5gs
        yFRW7n6p2lq9rbzOR228BZ0=
X-Google-Smtp-Source: APXvYqw7UqVFmBGFIMkjrblY90I3+y3Lqh2r976LXSkatfh1QjD6z91brm36mJ935w9lFickK6l0gQ==
X-Received: by 2002:adf:f646:: with SMTP id x6mr22912454wrp.18.1562710426876;
        Tue, 09 Jul 2019 15:13:46 -0700 (PDT)
Received: from localhost.localdomain ([2a01:4f8:222:2f1b::2])
        by smtp.gmail.com with ESMTPSA id t6sm258623wmb.29.2019.07.09.15.13.45
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 09 Jul 2019 15:13:46 -0700 (PDT)
From:   Nathan Chancellor <natechancellor@gmail.com>
To:     Dennis Dalessandro <dennis.dalessandro@intel.com>,
        Mike Marciniszyn <mike.marciniszyn@intel.com>,
        Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>
Cc:     Kamenee Arumugam <kamenee.arumugam@intel.com>,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
        clang-built-linux@googlegroups.com,
        Nathan Chancellor <natechancellor@gmail.com>
Subject: [PATCH] IB/rdmavt: Remove err declaration in if statement in rvt_create_cq
Date:   Tue,  9 Jul 2019 15:13:12 -0700
Message-Id: <20190709221312.7089-1-natechancellor@gmail.com>
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
X-Patchwork-Bot: notify
Content-Transfer-Encoding: 8bit
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

clang warns:

drivers/infiniband/sw/rdmavt/cq.c:260:7: warning: variable 'err' is used
uninitialized whenever 'if' condition is true
[-Wsometimes-uninitialized]
                if (err)
                    ^~~
drivers/infiniband/sw/rdmavt/cq.c:310:9: note: uninitialized use occurs
here
        return err;
               ^~~
drivers/infiniband/sw/rdmavt/cq.c:260:3: note: remove the 'if' if its
condition is always false
                if (err)
                ^~~~~~~~
drivers/infiniband/sw/rdmavt/cq.c:253:7: warning: variable 'err' is used
uninitialized whenever 'if' condition is true
[-Wsometimes-uninitialized]
                if (!cq->ip) {
                    ^~~~~~~
drivers/infiniband/sw/rdmavt/cq.c:310:9: note: uninitialized use occurs
here
        return err;
               ^~~
drivers/infiniband/sw/rdmavt/cq.c:253:3: note: remove the 'if' if its
condition is always false
                if (!cq->ip) {
                ^~~~~~~~~~~~~~
drivers/infiniband/sw/rdmavt/cq.c:211:9: note: initialize the variable
'err' to silence this warning
        int err;
               ^
                = 0
2 warnings generated.

There are two err declarations in this function: at the top and within
an if statement; clang warns because the assignments to err in the if
statement are local to the if statement so err will be used
uninitialized if this error handling is used. Remove the if statement's
err declaration so that everything works properly.

Fixes: 239b0e52d8aa ("IB/hfi1: Move rvt_cq_wc struct into uapi directory")
Link: https://github.com/ClangBuiltLinux/linux/issues/594
Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
---
 drivers/infiniband/sw/rdmavt/cq.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/infiniband/sw/rdmavt/cq.c b/drivers/infiniband/sw/rdmavt/cq.c
index fac87b13329d..a85571a4cf57 100644
--- a/drivers/infiniband/sw/rdmavt/cq.c
+++ b/drivers/infiniband/sw/rdmavt/cq.c
@@ -247,8 +247,6 @@ int rvt_create_cq(struct ib_cq *ibcq, const struct ib_cq_init_attr *attr,
 	 * See rvt_mmap() for details.
 	 */
 	if (udata && udata->outlen >= sizeof(__u64)) {
-		int err;
-
 		cq->ip = rvt_create_mmap_info(rdi, sz, udata, u_wc);
 		if (!cq->ip) {
 			err = -ENOMEM;
-- 
2.22.0

