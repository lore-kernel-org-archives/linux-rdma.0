Return-Path: <SRS0=M/HP=Y4=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC64ECA9EA0
	for <linux-rdma@archiver.kernel.org>; Mon,  4 Nov 2019 12:26:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AF14D222C5
	for <linux-rdma@archiver.kernel.org>; Mon,  4 Nov 2019 12:26:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726100AbfKDM0Q (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Mon, 4 Nov 2019 07:26:16 -0500
Received: from stargate.chelsio.com ([12.32.117.8]:8806 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728481AbfKDM0P (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Mon, 4 Nov 2019 07:26:15 -0500
Received: from localhost (mehrangarh.blr.asicdesigners.com [10.193.185.169])
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id xA4CQBRd032291;
        Mon, 4 Nov 2019 04:26:12 -0800
From:   Potnuri Bharat Teja <bharat@chelsio.com>
To:     jgg@ziepe.ca, dledford@redhat.com
Cc:     linux-rdma@vger.kernel.org, bharat@chelsio.com,
        nirranjan@chelsio.com, Rahul Kundu <rahul.kundu@chelsio.com>
Subject: [PATCH rdma-core] cxgb4: always query device before initializing chip version
Date:   Mon,  4 Nov 2019 17:56:08 +0530
Message-Id: <1572870368-8686-1-git-send-email-bharat@chelsio.com>
X-Mailer: git-send-email 2.3.9
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

chip_version may be initialized wrongly if alloc_context() is
invoked multiple times. therefore always query device to derive the
correct chip_version.

Fixes: c7e71b250268 ("cxgb4: fix chipversion initialization")
Signed-off-by: Rahul Kundu <rahul.kundu@chelsio.com>
Signed-off-by: Potnuri Bharat Teja <bharat@chelsio.com>
---
 providers/cxgb4/dev.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/providers/cxgb4/dev.c b/providers/cxgb4/dev.c
index 4d02c7a91892..6526a7170fce 100644
--- a/providers/cxgb4/dev.c
+++ b/providers/cxgb4/dev.c
@@ -143,14 +143,14 @@ static struct verbs_context *c4iw_alloc_context(struct ibv_device *ibdev,
 	} 
 
 	verbs_set_ops(&context->ibv_ctx, &c4iw_ctx_common_ops);
+	ret = ibv_cmd_query_device(&context->ibv_ctx.context, &attr,
+				   &raw_fw_ver, &qcmd, sizeof(qcmd));
+	if (ret)
+		goto err_unmap;
 
 	if (!rhp->mmid2ptr) {
 		int ret;
 
-		ret = ibv_cmd_query_device(&context->ibv_ctx.context, &attr,
-					   &raw_fw_ver, &qcmd, sizeof(qcmd));
-		if (ret)
-			goto err_unmap;
 		rhp->max_mr = attr.max_mr;
 		rhp->mmid2ptr = calloc(attr.max_mr, sizeof(void *));
 		if (!rhp->mmid2ptr) {
-- 
2.3.9

