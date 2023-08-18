Return-Path: <linux-rdma-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34753C678DC
	for <linux-rdma@archiver.kernel.org>; Fri, 18 Aug 2023 08:24:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358559AbjHRIXt (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Fri, 18 Aug 2023 04:23:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358566AbjHRIXf (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Fri, 18 Aug 2023 04:23:35 -0400
Received: from out-31.mta0.migadu.com (out-31.mta0.migadu.com [IPv6:2001:41d0:1004:224b::1f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86D191FCE
        for <linux-rdma@vger.kernel.org>; Fri, 18 Aug 2023 01:23:34 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1692347013;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rRki0neaLhGc5OKgebMQ5Pv0WmLXmG+LIJlZ1oBAIeY=;
        b=Xt+hJ8+v3cLD4MJrGptDPfmuoDU2Nk0Z0YKjWJR0eXp58UyzTXOtOGj5dpju2gtZ1RR+wQ
        8Xya3KzBAAhzzL+0WjJtv/CZ6vf6a7oT4AImCcBsJKutiBSoc5tUTpHzf3yAu+whoJOlvg
        2tMdppLWUsfEq+XMY4LOGHWQ9foQ5s8=
From:   Guoqing Jiang <guoqing.jiang@linux.dev>
To:     bmt@zurich.ibm.com, jgg@ziepe.ca, leon@kernel.org
Cc:     linux-rdma@vger.kernel.org
Subject: [PATCH 3/3] RDMA/siw: Call llist_reverse_order in siw_run_sq
Date:   Fri, 18 Aug 2023 16:23:18 +0800
Message-Id: <20230818082318.17489-4-guoqing.jiang@linux.dev>
In-Reply-To: <20230818082318.17489-1-guoqing.jiang@linux.dev>
References: <20230818082318.17489-1-guoqing.jiang@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

We can call the function to get fifo list.

Signed-off-by: Guoqing Jiang <guoqing.jiang@linux.dev>
---
 drivers/infiniband/sw/siw/siw_qp_tx.c | 12 +-----------
 1 file changed, 1 insertion(+), 11 deletions(-)

diff --git a/drivers/infiniband/sw/siw/siw_qp_tx.c b/drivers/infiniband/sw/siw/siw_qp_tx.c
index 3ff339eceec3..11b208a2d12a 100644
--- a/drivers/infiniband/sw/siw/siw_qp_tx.c
+++ b/drivers/infiniband/sw/siw/siw_qp_tx.c
@@ -1267,17 +1267,7 @@ int siw_run_sq(void *data)
 			break;
 
 		active = llist_del_all(&tx_task->active);
-		/*
-		 * llist_del_all returns a list with newest entry first.
-		 * Re-order list for fairness among QP's.
-		 */
-		while (active) {
-			struct llist_node *tmp = active;
-
-			active = llist_next(active);
-			tmp->next = fifo_list;
-			fifo_list = tmp;
-		}
+		fifo_list = llist_reverse_order(active);
 		while (fifo_list) {
 			qp = container_of(fifo_list, struct siw_qp, tx_list);
 			fifo_list = llist_next(fifo_list);
-- 
2.35.3

