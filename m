Return-Path: <linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B438EC07E99
	for <linux-rdma@archiver.kernel.org>; Mon,  5 Jul 2021 16:42:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9629661961
	for <linux-rdma@archiver.kernel.org>; Mon,  5 Jul 2021 16:42:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229652AbhGEQo4 (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Mon, 5 Jul 2021 12:44:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229560AbhGEQo4 (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Mon, 5 Jul 2021 12:44:56 -0400
Received: from mail-ot1-x329.google.com (mail-ot1-x329.google.com [IPv6:2607:f8b0:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D01DC061574
        for <linux-rdma@vger.kernel.org>; Mon,  5 Jul 2021 09:42:19 -0700 (PDT)
Received: by mail-ot1-x329.google.com with SMTP id o13-20020a9d404d0000b0290466630039caso18858419oti.6
        for <linux-rdma@vger.kernel.org>; Mon, 05 Jul 2021 09:42:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=p5IjKnSTmw8301oRc6L9LSJLTO34moUULtUlikzI7m4=;
        b=q1wQDBSObIwedA1gjC1POTZJjLGwhstBVkLDKqTLdGluC1khgrDGmqZMXculCOGsYO
         OZ+wlZeZOg1zehE/3Sp/zhhzDYLz2w02jN6J+alJYjNuHT4IXklQzzPk1/6Pyl1T9KnE
         E1lzi8o2/e+2pwZaaE4ZQJU0i2L+dwe2w+yU7NDyYw2vJt1fGWAAP+/izFs5+8oI1prL
         k4jYfEOc9JW6UQhk3w6Lfz4CT3ReME8dsZc6M1wnRBRMkQh8JQSGJUDaOigOAkinNitL
         /IBiOFGdQJRb8BIjAFExysa1EjXLlwDCMUya1Q6zedg21qdw1GQyS0Lsz7eWycoGeY07
         DcdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=p5IjKnSTmw8301oRc6L9LSJLTO34moUULtUlikzI7m4=;
        b=LEyO0egTGJ74btuZSqq2XMRM8/73yZPFeccwzPEDJp9+DQdVlGOol8jYydVfdFhiU1
         GqVekG7vExyHEo36JH5vk6lDDDJ60asy3XOBKIabQvABrN9s3jUv4t0Y/kZrWWVjMI16
         M13ciGk9cSFZAB+qHrVT7C6FS/9TC08jMnOzpTHKyc67S+fIma+HJ/ajkavfoonyh3dr
         9QMQ85AcHPGDTeM7ZU1QzfflvVbM20uvmRWeynyiDA90A9Zg1Wdx3wfYKc77CEHf/7u3
         GUztUPOm0f8CiN1BL+QNHyZg4lal3+4yA4DLhwnHx834JuMBsTZhbusXfK1/jMDN0Dqd
         rWww==
X-Gm-Message-State: AOAM532FHiWa+Y39EuomVw2VKPnA34yK4AH+yNhKcmsXfHwWO7CuWkmJ
        5+H3TNJnXsHl2uNC8ftQ2yA=
X-Google-Smtp-Source: ABdhPJzbqkJLN0ohTX6vn1gVjnOwiV2Wl9O2eZVc0si2mD/Z/xjjuxqi/ocZIjSnqViFlyj2p0UIlw==
X-Received: by 2002:a9d:7d83:: with SMTP id j3mr5154898otn.283.1625503338681;
        Mon, 05 Jul 2021 09:42:18 -0700 (PDT)
Received: from localhost (2603-8081-140c-1a00-213d-64e7-bcac-e2c2.res6.spectrum.com. [2603:8081:140c:1a00:213d:64e7:bcac:e2c2])
        by smtp.gmail.com with ESMTPSA id c14sm2797581oic.50.2021.07.05.09.42.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Jul 2021 09:42:18 -0700 (PDT)
From:   Bob Pearson <rpearsonhpe@gmail.com>
To:     jgg@nvidia.com, zyjzyj2000@gmail.com, linux-rdma@vger.kernel.org,
        haakon.brugge@oracle.com, yang.jy@fujitsu.com
Cc:     Bob Pearson <rpearsonhpe@gmail.com>
Subject: [PATCH for-next v2] RDMA/rxe: Fix memory leak in error path code
Date:   Mon,  5 Jul 2021 11:41:54 -0500
Message-Id: <20210705164153.17652-1-rpearsonhpe@gmail.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

In rxe_mr_init_user() in rxe_mr.c at the third error the driver fails to
free the memory at mr->map. This patch adds code to do that.
This error only occurs if page_address() fails to return a non zero address
which should never happen for 64 bit architectures.

Fixes: 8700e3e7c485 ("Soft RoCE driver")
Reported by: Haakon Bugge <haakon.bugge@oracle.com>
Signed-off-by: Bob Pearson <rpearsonhpe@gmail.com>
---
v2:
  Left out white space changes.

 drivers/infiniband/sw/rxe/rxe_mr.c | 27 +++++++++++++++++----------
 1 file changed, 17 insertions(+), 10 deletions(-)

diff --git a/drivers/infiniband/sw/rxe/rxe_mr.c b/drivers/infiniband/sw/rxe/rxe_mr.c
index 6aabcb4de235..be4bcb420fab 100644
--- a/drivers/infiniband/sw/rxe/rxe_mr.c
+++ b/drivers/infiniband/sw/rxe/rxe_mr.c
@@ -113,13 +113,14 @@ int rxe_mr_init_user(struct rxe_pd *pd, u64 start, u64 length, u64 iova,
 	int			num_buf;
 	void			*vaddr;
 	int err;
+	int i;
 
 	umem = ib_umem_get(pd->ibpd.device, start, length, access);
 	if (IS_ERR(umem)) {
-		pr_warn("err %d from rxe_umem_get\n",
-			(int)PTR_ERR(umem));
+		pr_warn("%s: Unable to pin memory region err = %d\n",
+			__func__, (int)PTR_ERR(umem));
 		err = PTR_ERR(umem);
-		goto err1;
+		goto err_out;
 	}
 
 	mr->umem = umem;
@@ -129,9 +130,9 @@ int rxe_mr_init_user(struct rxe_pd *pd, u64 start, u64 length, u64 iova,
 
 	err = rxe_mr_alloc(mr, num_buf);
 	if (err) {
-		pr_warn("err %d from rxe_mr_alloc\n", err);
-		ib_umem_release(umem);
-		goto err1;
+		pr_warn("%s: Unable to allocate memory for map\n",
+				__func__);
+		goto err_release_umem;
 	}
 
 	mr->page_shift = PAGE_SHIFT;
@@ -151,10 +152,10 @@ int rxe_mr_init_user(struct rxe_pd *pd, u64 start, u64 length, u64 iova,
 
 			vaddr = page_address(sg_page_iter_page(&sg_iter));
 			if (!vaddr) {
-				pr_warn("null vaddr\n");
-				ib_umem_release(umem);
+				pr_warn("%s: Unable to get virtual address\n",
+						__func__);
 				err = -ENOMEM;
-				goto err1;
+				goto err_cleanup_map;
 			}
 
 			buf->addr = (uintptr_t)vaddr;
@@ -177,7 +178,13 @@ int rxe_mr_init_user(struct rxe_pd *pd, u64 start, u64 length, u64 iova,
 
 	return 0;
 
-err1:
+err_cleanup_map:
+	for (i = 0; i < mr->num_map; i++)
+		kfree(mr->map[i]);
+	kfree(mr->map);
+err_release_umem:
+	ib_umem_release(umem);
+err_out:
 	return err;
 }
 
-- 
2.30.2

