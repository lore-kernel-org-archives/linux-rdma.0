Return-Path: <linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8FDF6C28D13
	for <linux-rdma@archiver.kernel.org>; Mon, 22 Aug 2022 11:24:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232620AbiHVLYs (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Mon, 22 Aug 2022 07:24:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232555AbiHVLYr (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Mon, 22 Aug 2022 07:24:47 -0400
Received: from out1.migadu.com (out1.migadu.com [IPv6:2001:41d0:2:863f::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38B9A29C84
        for <linux-rdma@vger.kernel.org>; Mon, 22 Aug 2022 04:24:46 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1661167483;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=6TfnAbubtCZNC14dcbSUTVV2jfThBqa0niu+/FQBgx4=;
        b=tMCJQW3+xLZbWnfUnWQPAKy/hRRVO9wnAbK0Fwe6vbOnsGSmxFJMOBL4C4dK7iRLtRrByT
        O/XP2o8btjZ/LhGNm4sAj04yZbSu4AR/ULhENpDFfjgF15JpAabEYO2Hy46/q0NwVjje8F
        /k0Y7bxxPzqUBegUH62n2TfR8epz8iY=
From:   Guoqing Jiang <guoqing.jiang@linux.dev>
To:     yanjun.zhu@linux.dev, jgg@ziepe.ca, leon@kernel.org
Cc:     linux-rdma@vger.kernel.org, Guoqing Jiang <guoqing.jiang@linux.dev>
Subject: [PATCH] RDMA/rxe: No need to check IPV6 in rxe_find_route
Date:   Mon, 22 Aug 2022 19:23:55 +0800
Message-Id: <20220822112355.17635-1-guoqing.jiang@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

This check is unnecessary since rxe_find_route6 returns NULL if
CONFIG_IPV6 is disabled.

Signed-off-by: Guoqing Jiang <guoqing.jiang@linux.dev>
---
 drivers/infiniband/sw/rxe/rxe_net.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/infiniband/sw/rxe/rxe_net.c b/drivers/infiniband/sw/rxe/rxe_net.c
index c53f4529f098..b0f31f849144 100644
--- a/drivers/infiniband/sw/rxe/rxe_net.c
+++ b/drivers/infiniband/sw/rxe/rxe_net.c
@@ -113,11 +113,9 @@ static struct dst_entry *rxe_find_route(struct net_device *ndev,
 			saddr6 = &av->sgid_addr._sockaddr_in6.sin6_addr;
 			daddr6 = &av->dgid_addr._sockaddr_in6.sin6_addr;
 			dst = rxe_find_route6(ndev, saddr6, daddr6);
-#if IS_ENABLED(CONFIG_IPV6)
 			if (dst)
 				qp->dst_cookie =
 					rt6_get_cookie((struct rt6_info *)dst);
-#endif
 		}
 
 		if (dst && (qp_type(qp) == IB_QPT_RC)) {
-- 
2.31.1

