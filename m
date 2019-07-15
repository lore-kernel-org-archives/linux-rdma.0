Return-Path: <SRS0=EqZ5=VM=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7CD97C76180
	for <linux-rdma@archiver.kernel.org>; Mon, 15 Jul 2019 03:18:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4623F20C01
	for <linux-rdma@archiver.kernel.org>; Mon, 15 Jul 2019 03:18:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="uznpD+Zy"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729188AbfGODSW (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Sun, 14 Jul 2019 23:18:22 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:34444 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728999AbfGODSW (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Sun, 14 Jul 2019 23:18:22 -0400
Received: by mail-pg1-f194.google.com with SMTP id n9so778009pgc.1;
        Sun, 14 Jul 2019 20:18:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=rAUMXzHwviit3EWOrZi2p+vSW9wN4kYz9UnlLQwtU3g=;
        b=uznpD+ZyqkFc2z3C4topCy403sbzlzEdtqDizLvP0EEvUhnO/INmCYnPl6+Dv0APNM
         CH3KDp77QkPPIHIV+1Ci4a3AUzaQ99xp1ev6aSd5XE1UydzpTBSuOmQODPRlcCnNMbzP
         vhwNIZT33HYj/XqwDtLQBVs9s1OnFyEbgT+f10ujcgzFMGHq8ylzRbSqeHrY1h+RHeGP
         3G4eKpWLBafPpNLDU7AtAdu70LYqK30ght9Mxq7QTy3JuVUgaM9ThsJdOdwmfZjgIg6t
         GeiRdGeH4JfTEHxaVe+VRm85M5C8lpbqkSU78Z7obPxx8gvAtVfdFiOU2LitTxO4h0ON
         tENg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=rAUMXzHwviit3EWOrZi2p+vSW9wN4kYz9UnlLQwtU3g=;
        b=P1e/8/ACOJOZM8UX/MfJ/2eGgvpk9UMXMrMfM97eKQy4B7b2GVdsuRF5MEXXxizOQ6
         0ZnjvPHglcoOc0BQGeZ560uxgaHtiDAbo1HEsSb/ZWj9w1jefmJZ/s+7qvCa6ofzAg54
         q83UUg45QnNqhljsDLi7mwwwjyfGVdWK71Hngp/WXKn+JmIzZenPdoc/PTVstDb5ttpX
         ItVKvaysBj8nFIGw1Nyq5M+pf3tH76kbt7At+l/0/VnZhIzBWKOsKYRTZADW1BbP6trG
         qFFKZK6B+Ze6VuiGWksvhWRXBNsuyZRIv8PJ643D2Epi6HPLqQ0uvttJnKHn4wuik1Fr
         J/vw==
X-Gm-Message-State: APjAAAV2z7VnCFavG0ww87ruupiHnTabLRbDkgZ+zA2D7Cjv24UlDhda
        NOgQ9Na/yk9psb+vZxrsNJYwkywvmiE=
X-Google-Smtp-Source: APXvYqzjOGeLU7KZRLb5Y0Pc5Gc78pi3lWltHGoUMhshuWGRXqJ4E4yxMXoDOFtIVpevm9LJkG02uw==
X-Received: by 2002:a17:90a:37ac:: with SMTP id v41mr25623284pjb.6.1563160701890;
        Sun, 14 Jul 2019 20:18:21 -0700 (PDT)
Received: from hfq-skylake.ipads-lab.se.sjtu.edu.cn ([202.120.40.82])
        by smtp.googlemail.com with ESMTPSA id f14sm14662328pfn.53.2019.07.14.20.18.20
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 14 Jul 2019 20:18:21 -0700 (PDT)
From:   Fuqian Huang <huangfq.daxian@gmail.com>
Cc:     Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
        Fuqian Huang <huangfq.daxian@gmail.com>
Subject: [PATCH v3 10/24] IB/mthca: Remove call to memset after dma_alloc_coherent
Date:   Mon, 15 Jul 2019 11:18:16 +0800
Message-Id: <20190715031816.6657-1-huangfq.daxian@gmail.com>
X-Mailer: git-send-email 2.11.0
To:     unlisted-recipients:; (no To-header on input)
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

In commit 518a2f1925c3
("dma-mapping: zero memory returned from dma_alloc_*"),
dma_alloc_coherent has already zeroed the memory.
So memset is not needed.

Signed-off-by: Fuqian Huang <huangfq.daxian@gmail.com>
---
Changes in v3:
  - Use actual commit rather than the merge commit in the commit message

 drivers/infiniband/hw/mthca/mthca_allocator.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/infiniband/hw/mthca/mthca_allocator.c b/drivers/infiniband/hw/mthca/mthca_allocator.c
index aaf10dd5364d..aef1d274a14e 100644
--- a/drivers/infiniband/hw/mthca/mthca_allocator.c
+++ b/drivers/infiniband/hw/mthca/mthca_allocator.c
@@ -214,8 +214,6 @@ int mthca_buf_alloc(struct mthca_dev *dev, int size, int max_direct,
 
 		dma_unmap_addr_set(&buf->direct, mapping, t);
 
-		memset(buf->direct.buf, 0, size);
-
 		while (t & ((1 << shift) - 1)) {
 			--shift;
 			npages *= 2;
-- 
2.11.0

