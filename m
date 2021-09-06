Return-Path: <linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0FB11C433F5
	for <linux-rdma@archiver.kernel.org>; Mon,  6 Sep 2021 09:49:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E1BC160E76
	for <linux-rdma@archiver.kernel.org>; Mon,  6 Sep 2021 09:49:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241410AbhIFJuL (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Mon, 6 Sep 2021 05:50:11 -0400
Received: from out30-43.freemail.mail.aliyun.com ([115.124.30.43]:34308 "EHLO
        out30-43.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241413AbhIFJuC (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Mon, 6 Sep 2021 05:50:02 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R931e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=alimailimapcm10staff010182156082;MF=jiapeng.chong@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0UnOy8TL_1630921725;
Received: from j63c13417.sqa.eu95.tbsite.net(mailfrom:jiapeng.chong@linux.alibaba.com fp:SMTPD_---0UnOy8TL_1630921725)
          by smtp.aliyun-inc.com(127.0.0.1);
          Mon, 06 Sep 2021 17:48:56 +0800
From:   Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
To:     mike.marciniszyn@cornelisnetworks.com
Cc:     dennis.dalessandro@cornelisnetworks.com, dledford@redhat.com,
        jgg@ziepe.ca, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        chongjiapeng <jiapeng.chong@linux.alibaba.com>
Subject: [PATCH] IB/hfi1: make hist static
Date:   Mon,  6 Sep 2021 17:48:43 +0800
Message-Id: <1630921723-21545-1-git-send-email-jiapeng.chong@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

From: chongjiapeng <jiapeng.chong@linux.alibaba.com>

This symbol is not used outside of trace.c, so marks it static.

Fix the following sparse warning:

drivers/infiniband/hw/hfi1/trace.c:491:23: warning: symbol 'hist' was
not declared. Should it be static?

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: chongjiapeng <jiapeng.chong@linux.alibaba.com>
---
 drivers/infiniband/hw/hfi1/trace.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/hfi1/trace.c b/drivers/infiniband/hw/hfi1/trace.c
index d9b5bbb..8302469 100644
--- a/drivers/infiniband/hw/hfi1/trace.c
+++ b/drivers/infiniband/hw/hfi1/trace.c
@@ -488,7 +488,7 @@ struct hfi1_ctxt_hist {
 	atomic_t data[255];
 };
 
-struct hfi1_ctxt_hist hist = {
+static struct hfi1_ctxt_hist hist = {
 	.count = ATOMIC_INIT(0)
 };
 
-- 
1.8.3.1

