Return-Path: <linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6969BC4332F
	for <linux-rdma@archiver.kernel.org>; Sun, 13 Nov 2022 01:08:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235104AbiKMBIx (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Sat, 12 Nov 2022 20:08:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235088AbiKMBIv (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Sat, 12 Nov 2022 20:08:51 -0500
Received: from out2.migadu.com (out2.migadu.com [IPv6:2001:41d0:2:aacc::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78E0D25C7
        for <linux-rdma@vger.kernel.org>; Sat, 12 Nov 2022 17:08:50 -0800 (PST)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1668301729;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PMIKurErvaKaHZgyBaYTVTZbaYHPzeiTsrjhEAmq01Y=;
        b=JNPyCjhKRBpOH2+Cm9GAkc6/ittCk/5msX40M29A47nB7wewGWToV5lt9ykayP6n8R8cnN
        kt3yVuK/9/yot+JqWnDnh6G4+RYnB26pA6AeyXjJ5ldIVKm585IMQJFkaq8pN2EgsMXskI
        NdIzsaJZSVFfztok4GoXGO9P7J0z97k=
From:   Guoqing Jiang <guoqing.jiang@linux.dev>
To:     haris.iqbal@ionos.com, jinpu.wang@ionos.com, jgg@ziepe.ca,
        leon@kernel.org
Cc:     linux-rdma@vger.kernel.org
Subject: [PATCH RFC 07/12] RDMA/rtrs-srv: Remove outdated comments from create_con
Date:   Sun, 13 Nov 2022 09:08:18 +0800
Message-Id: <20221113010823.6436-8-guoqing.jiang@linux.dev>
In-Reply-To: <20221113010823.6436-1-guoqing.jiang@linux.dev>
References: <20221113010823.6436-1-guoqing.jiang@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

Remove the orphan comments.

Signed-off-by: Guoqing Jiang <guoqing.jiang@linux.dev>
---
 drivers/infiniband/ulp/rtrs/rtrs-srv.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/infiniband/ulp/rtrs/rtrs-srv.c b/drivers/infiniband/ulp/rtrs/rtrs-srv.c
index f3bf5bbb4377..4c883c57c2ef 100644
--- a/drivers/infiniband/ulp/rtrs/rtrs-srv.c
+++ b/drivers/infiniband/ulp/rtrs/rtrs-srv.c
@@ -1671,12 +1671,6 @@ static int create_con(struct rtrs_srv_path *srv_path,
 				      srv->queue_depth * (1 + 2) + 1);
 
 		max_recv_wr = srv->queue_depth + 1;
-		/*
-		 * If we have all receive requests posted and
-		 * all write requests posted and each read request
-		 * requires an invalidate request + drain
-		 * and qp gets into error state.
-		 */
 	}
 	cq_num = max_send_wr + max_recv_wr;
 	atomic_set(&con->c.sq_wr_avail, max_send_wr);
-- 
2.31.1

