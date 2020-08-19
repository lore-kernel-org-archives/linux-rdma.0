Return-Path: <SRS0=Fixc=B5=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36378C433E1
	for <linux-rdma@archiver.kernel.org>; Wed, 19 Aug 2020 03:43:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 10265204EC
	for <linux-rdma@archiver.kernel.org>; Wed, 19 Aug 2020 03:43:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YPJYH8p2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726533AbgHSDno (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Tue, 18 Aug 2020 23:43:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726410AbgHSDnm (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Tue, 18 Aug 2020 23:43:42 -0400
Received: from mail-ot1-x343.google.com (mail-ot1-x343.google.com [IPv6:2607:f8b0:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDA88C061389
        for <linux-rdma@vger.kernel.org>; Tue, 18 Aug 2020 20:43:41 -0700 (PDT)
Received: by mail-ot1-x343.google.com with SMTP id q9so18010757oth.5
        for <linux-rdma@vger.kernel.org>; Tue, 18 Aug 2020 20:43:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=liKNP0E95pCjhc56klSus48fMWqC+4o/+SlPQR6CzQw=;
        b=YPJYH8p2+6M5fj2vQUTGlKkbyr7cBYw5XQNWC+BAqDZ0eedvnbgY9pxe9Kl1RkaS98
         Bjn6934m7H+FBdUxxv05sqOoI42BkhuQbqIaN4L16TDDutW64/t1OM85QTZMXx4sIaNV
         17T3Urhe6Kg8DlQO9qrbCr57iKHZgy6EfqDl4kJH0LN9xF+hI6cs62mwid2VaY7t3nKG
         SUC7Kj3uM+r9On6A3gg7NtDT0GHSKimmtFloayW6O3z1eUhSq0Zx7O2u9nzMbMwhlfPL
         v/BsehEbuzrBms55ETmddzsjeteDqAm/RuIK1Z/ZPz46p+Str0L25NUfm3yWBw9axuL6
         vivw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=liKNP0E95pCjhc56klSus48fMWqC+4o/+SlPQR6CzQw=;
        b=CXVjuK75lv+MWhZbuHZx+22UZ6NPeMVbf+kwa0bpzB18kJ23eM9YSE91HNORzFWdwf
         MqbnVZKYxlZ4f9Nv8dhrQRuhti0wb6Q7UdybMpEX92WDn+jEwtnWGZ4tqEOV1hXAXkeq
         TroMyheyHgX1ZPP9qAy01zKN+trAeE3UtFx7ix4FHqb9fPH5OSaZ4JTpO7ds3SNk+Eiw
         CMVQnscjjroK2g1fchMsXRW157Jc19T8IO+9u157gUwIYL1qzvqpZ+JS5v+d+gJMmCWq
         BwDT1Ll6+NKLF/Rl1hJxInpLSglK/XFKWiJYqcKI9cR8ge4FNB3NEb+IKvByS6L7fLwC
         wv3A==
X-Gm-Message-State: AOAM530f9vuLGi2MaY8LU7wL3daavYjpqqyLsytWHydkPZn+XbHN+Yrj
        3TmnvyE5iFmc3t/tDeYxElNrKCxUzS/XQA==
X-Google-Smtp-Source: ABdhPJxsf/VctCSaX1/obO61mjDhlUrc1pC5Eb5nJB1b+srNUtQagayL3e4JsgHimHfidJwwuRmD6g==
X-Received: by 2002:a9d:5f0c:: with SMTP id f12mr16385737oti.141.1597808621375;
        Tue, 18 Aug 2020 20:43:41 -0700 (PDT)
Received: from localhost ([2605:6000:8b03:f000:2731:80e6:14c6:1150])
        by smtp.gmail.com with ESMTPSA id z189sm4360112oia.33.2020.08.18.20.43.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Aug 2020 20:43:41 -0700 (PDT)
From:   Bob Pearson <rpearsonhpe@gmail.com>
X-Google-Original-From: Bob Pearson <rpearson@hpe.com>
To:     zyjzyj2000@gmail.com, linux-rdma@vger.kernel.org
Cc:     Bob Pearson <rpearson@hpe.com>
Subject: [PATCH v2 11/16] rdma_rxe: Address an issue with hardened user copy
Date:   Tue, 18 Aug 2020 22:40:08 -0500
Message-Id: <20200819034002.8835-12-rpearson@hpe.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200819034002.8835-1-rpearson@hpe.com>
References: <20200819034002.8835-1-rpearson@hpe.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

Added a new feature to pools to let driver white list a region of
a pool object. This removes a kernel oops caused when create qp
returns the qp number so the next patch will work without errors.

Signed-off-by: Bob Pearson <rpearson@hpe.com>
---
 drivers/infiniband/sw/rxe/rxe_pool.c | 20 +++++++++++++++++---
 drivers/infiniband/sw/rxe/rxe_pool.h |  4 ++++
 2 files changed, 21 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/sw/rxe/rxe_pool.c b/drivers/infiniband/sw/rxe/rxe_pool.c
index 5679714827ec..374e56689d30 100644
--- a/drivers/infiniband/sw/rxe/rxe_pool.c
+++ b/drivers/infiniband/sw/rxe/rxe_pool.c
@@ -40,9 +40,12 @@ struct rxe_type_info rxe_type_info[RXE_NUM_TYPES] = {
 		.name		= "rxe-qp",
 		.size		= sizeof(struct rxe_qp),
 		.cleanup	= rxe_qp_cleanup,
-		.flags		= RXE_POOL_INDEX,
+		.flags		= RXE_POOL_INDEX
+				| RXE_POOL_WHITELIST,
 		.min_index	= RXE_MIN_QP_INDEX,
 		.max_index	= RXE_MAX_QP_INDEX,
+		.user_offset	= offsetof(struct rxe_qp, ibqp.qp_num),
+		.user_size	= sizeof(u32),
 	},
 	[RXE_TYPE_CQ] = {
 		.name		= "rxe-cq",
@@ -116,10 +119,21 @@ int rxe_cache_init(void)
 		type = &rxe_type_info[i];
 		size = ALIGN(type->size, RXE_POOL_ALIGN);
 		if (!(type->flags & RXE_POOL_NO_ALLOC)) {
-			type->cache =
-				kmem_cache_create(type->name, size,
+			if (type->flags & RXE_POOL_WHITELIST) {
+				type->cache =
+					kmem_cache_create_usercopy(
+						type->name, size,
+						RXE_POOL_ALIGN,
+						RXE_POOL_CACHE_FLAGS,
+						type->user_offset,
+						type->user_size, NULL);
+			} else {
+				type->cache =
+					kmem_cache_create(type->name, size,
 						  RXE_POOL_ALIGN,
 						  RXE_POOL_CACHE_FLAGS, NULL);
+			}
+
 			if (!type->cache) {
 				pr_err("Unable to init kmem cache for %s\n",
 				       type->name);
diff --git a/drivers/infiniband/sw/rxe/rxe_pool.h b/drivers/infiniband/sw/rxe/rxe_pool.h
index 664153bf9392..fc5b584a8137 100644
--- a/drivers/infiniband/sw/rxe/rxe_pool.h
+++ b/drivers/infiniband/sw/rxe/rxe_pool.h
@@ -17,6 +17,7 @@ enum rxe_pool_flags {
 	RXE_POOL_INDEX		= BIT(1),
 	RXE_POOL_KEY		= BIT(2),
 	RXE_POOL_NO_ALLOC	= BIT(4),
+	RXE_POOL_WHITELIST	= BIT(5),
 };
 
 enum rxe_elem_type {
@@ -44,6 +45,9 @@ struct rxe_type_info {
 	u32			min_index;
 	size_t			key_offset;
 	size_t			key_size;
+	/* for white listing where necessary */
+	unsigned int		user_offset;
+	unsigned int		user_size;
 	struct kmem_cache	*cache;
 };
 
-- 
2.25.1

