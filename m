Return-Path: <linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07A88C43334
	for <linux-rdma@archiver.kernel.org>; Thu,  9 Jun 2022 06:43:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238498AbiFIGnJ (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Thu, 9 Jun 2022 02:43:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231596AbiFIGnI (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Thu, 9 Jun 2022 02:43:08 -0400
Received: from hust.edu.cn (unknown [202.114.0.240])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AECE1E453A;
        Wed,  8 Jun 2022 23:43:06 -0700 (PDT)
Received: from localhost.localdomain ([172.16.0.254])
        (user=dzm91@hust.edu.cn mech=LOGIN bits=0)
        by mx1.hust.edu.cn  with ESMTP id 2596ghQD027715-2596ghQG027715
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO);
        Thu, 9 Jun 2022 14:42:47 +0800
From:   Dongliang Mu <dzm91@hust.edu.cn>
To:     Zhu Yanjun <zyjzyj2000@gmail.com>, Jason Gunthorpe <jgg@ziepe.ca>,
        Leon Romanovsky <leon@kernel.org>
Cc:     Dongliang Mu <mudongliangabcd@gmail.com>,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] rxe: fix xa_alloc_cycle() error return value check
Date:   Thu,  9 Jun 2022 14:42:42 +0800
Message-Id: <20220609064242.1444485-1-dzm91@hust.edu.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-FEAS-AUTH-USER: dzm91@hust.edu.cn
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

From: Dongliang Mu <mudongliangabcd@gmail.com>

Currently rxe_alloc checks ret to indicate error, but 1 is also a valid
return and just indicates that the allocation succeeded with a wrap.

Fix this by modifying the check to be < 0.

Signed-off-by: Dongliang Mu <mudongliangabcd@gmail.com>
---
 drivers/infiniband/sw/rxe/rxe_pool.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/sw/rxe/rxe_pool.c b/drivers/infiniband/sw/rxe/rxe_pool.c
index 19b14826385b..1cc8e847ccff 100644
--- a/drivers/infiniband/sw/rxe/rxe_pool.c
+++ b/drivers/infiniband/sw/rxe/rxe_pool.c
@@ -139,7 +139,7 @@ void *rxe_alloc(struct rxe_pool *pool)
 
 	err = xa_alloc_cyclic(&pool->xa, &elem->index, elem, pool->limit,
 			      &pool->next, GFP_KERNEL);
-	if (err)
+	if (err < 0)
 		goto err_free;
 
 	return obj;
-- 
2.25.1

