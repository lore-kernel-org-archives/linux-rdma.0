Return-Path: <SRS0=M/HP=Y4=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8EFBACA9EA0
	for <linux-rdma@archiver.kernel.org>; Mon,  4 Nov 2019 11:14:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6DBD9222C2
	for <linux-rdma@archiver.kernel.org>; Mon,  4 Nov 2019 11:14:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728502AbfKDLOZ (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Mon, 4 Nov 2019 06:14:25 -0500
Received: from stargate.chelsio.com ([12.32.117.8]:52583 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726071AbfKDLOZ (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Mon, 4 Nov 2019 06:14:25 -0500
Received: from localhost (mehrangarh.blr.asicdesigners.com [10.193.185.169])
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id xA4BEIUf031402;
        Mon, 4 Nov 2019 03:14:20 -0800
From:   Potnuri Bharat Teja <bharat@chelsio.com>
To:     jgg@ziepe.ca, dledford@redhat.com
Cc:     linux-rdma@vger.kernel.org, bharat@chelsio.com,
        nirranjan@chelsio.com
Subject: [PATCH rdma-core] cxgb4: free appropriate pointer in error case
Date:   Mon,  4 Nov 2019 16:44:10 +0530
Message-Id: <1572866050-29952-1-git-send-email-bharat@chelsio.com>
X-Mailer: git-send-email 2.3.9
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

Fixes: 9b2d3af5735e ("Query device to get the max supported stags, qps, and cqs")
Signed-off-by: Potnuri Bharat Teja <bharat@chelsio.com>
---
 providers/cxgb4/dev.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/providers/cxgb4/dev.c b/providers/cxgb4/dev.c
index 7f5955449ca1..4d02c7a91892 100644
--- a/providers/cxgb4/dev.c
+++ b/providers/cxgb4/dev.c
@@ -203,9 +203,9 @@ err_free:
 	if (rhp->cqid2ptr)
 		free(rhp->cqid2ptr);
 	if (rhp->qpid2ptr)
-		free(rhp->cqid2ptr);
+		free(rhp->qpid2ptr);
 	if (rhp->mmid2ptr)
-		free(rhp->cqid2ptr);
+		free(rhp->mmid2ptr);
 	verbs_uninit_context(&context->ibv_ctx);
 	free(context);
 	return NULL;
-- 
2.3.9

