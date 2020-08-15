Return-Path: <SRS0=W1Yx=BZ=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38F0CC433E3
	for <linux-rdma@archiver.kernel.org>; Sat, 15 Aug 2020 22:06:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0910E205CB
	for <linux-rdma@archiver.kernel.org>; Sat, 15 Aug 2020 22:06:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SyOBAWcq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728417AbgHOWGh (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Sat, 15 Aug 2020 18:06:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728395AbgHOVut (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Sat, 15 Aug 2020 17:50:49 -0400
Received: from mail-oi1-x236.google.com (mail-oi1-x236.google.com [IPv6:2607:f8b0:4864:20::236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BB38C0612B0
        for <linux-rdma@vger.kernel.org>; Fri, 14 Aug 2020 22:00:04 -0700 (PDT)
Received: by mail-oi1-x236.google.com with SMTP id n128so6180020oif.0
        for <linux-rdma@vger.kernel.org>; Fri, 14 Aug 2020 22:00:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=+Dx1W7Pc1FkT5qtletWAtG1Oo4D9aKHZMfp3GhhOA64=;
        b=SyOBAWcqHY0EydWOuYRVcWLjGnBOiDFvK7VvdVIbcq7Ld5apSDSNRUkNZeU4G6XLlK
         ODq7hl/sgqrelIyGPiAqUagxExZPpSQLYLd1qPM+6KHzgADJEv+4T4WNenxrjob4Qi4C
         P8VTKRnZSPu3q6g0tzdfzPn9QCUtOWvVht0z3Zo8Xxn9nEneRd617WKb+rOS8fhpD7bo
         xGlxTpM49JfCAWbE3HB5Vqj0csjha8Ju6rHFS8P2PsC6n3M28zj+wkFW5k840HLrgnqS
         FkWDA4vS8BC4RBGgMHuJwYx1gNwUSobPxrJWXeIRi1TZFXe+DAY+4I6+AEJjBnDPZYAq
         yiVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+Dx1W7Pc1FkT5qtletWAtG1Oo4D9aKHZMfp3GhhOA64=;
        b=E5gUdXxKiNxLveCkrHbypUf1DLgMq7vmYCni1skikHuUgMv7dRDdfkb1yq/05gWX7W
         8FqOxK4gmP4Z073OkTptkEeaFkstLiqInouS4wzgh4M/96bQQf2ueWSwcP6Nj4lXC7Bd
         eRcWCOk/6uLkFpgJYJfIjxCG5hwczrlfRER9OHV5ZMB0xR+0WpZSO9aFp9S3UkeqPb09
         L+Snqjh1VPOB/vPqn8kcjVdnwLk0/a+xXIl0+6uI3ekTOzPIvz+0RdjZehaqLdrZYGkt
         k07pfcKFzf8yrUh+g1C1o8zZfIFw3DUYR68WNWCgY4cWnnXymVY5apGIG/kdydyvfXcv
         2yZA==
X-Gm-Message-State: AOAM530cXmXR1xUVRHAqr9wzUkUR7GwiIqVclXRUfgy4IDaLcR39adA4
        7P+BYMdbjWtyXLxfLT8v8Y9yikv23ZkNwQ==
X-Google-Smtp-Source: ABdhPJyNQKDo/i+Efoa30CKCHJ+7RkdksqKaB4eA/VUylyr2uuuAiwr+Rst6y91gCpYMK+1+u1FC+Q==
X-Received: by 2002:aca:aa13:: with SMTP id t19mr3553194oie.59.1597467603875;
        Fri, 14 Aug 2020 22:00:03 -0700 (PDT)
Received: from localhost ([2605:6000:8b03:f000:b453:c5f2:2895:a54c])
        by smtp.gmail.com with ESMTPSA id l17sm2100611otp.70.2020.08.14.22.00.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Aug 2020 22:00:03 -0700 (PDT)
From:   Bob Pearson <rpearsonhpe@gmail.com>
X-Google-Original-From: Bob Pearson <rpearson@hpe.com>
To:     linux-rdma@vger.kernel.org
Cc:     Bob Pearson <rpearson@hpe.com>
Subject: [PATCH 12/20] Cleanup after git pull
Date:   Fri, 14 Aug 2020 23:58:36 -0500
Message-Id: <20200815045912.8626-13-rpearson@hpe.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200815045912.8626-1-rpearson@hpe.com>
References: <20200815045912.8626-1-rpearson@hpe.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

An experiment with rebase made a tiny mess which I cleaned up.
This one slipped through.

Signed-off-by: Bob Pearson <rpearson@hpe.com>
---
 drivers/infiniband/sw/rxe/rxe_loc.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/sw/rxe/rxe_loc.h b/drivers/infiniband/sw/rxe/rxe_loc.h
index 87d323b1ba07..03eb74947d62 100644
--- a/drivers/infiniband/sw/rxe/rxe_loc.h
+++ b/drivers/infiniband/sw/rxe/rxe_loc.h
@@ -105,7 +105,7 @@ enum copy_direction {
 	from_mr_obj,
 };
 
-int rxe_mr_init_dma(struct rxe_pd *pd,
+void rxe_mr_init_dma(struct rxe_pd *pd,
 		     int access, struct rxe_mr *mr);
 
 int rxe_mr_init_user(struct rxe_pd *pd, u64 start,
-- 
2.25.1

