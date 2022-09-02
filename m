Return-Path: <linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F78DC54EE9
	for <linux-rdma@archiver.kernel.org>; Fri,  2 Sep 2022 10:19:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234778AbiIBKTh (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Fri, 2 Sep 2022 06:19:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235662AbiIBKTf (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Fri, 2 Sep 2022 06:19:35 -0400
Received: from out0.migadu.com (out0.migadu.com [IPv6:2001:41d0:2:267::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB90CBD0AF
        for <linux-rdma@vger.kernel.org>; Fri,  2 Sep 2022 03:19:33 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1662113971;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=eJ6v7pM1CaR6xhM5ebTCnSoxo8XSLTPTn9UFkT53jTI=;
        b=YNvXScXlaDqrmoBzS6+LosbBsf+R9CoblJ3cI0iPd70Bjyx1SXECUYII0mlOKRFW9hUqzm
        fo8u9hI3IEbws7X5HKe0S2cK+8Vn4wxzjG3ZmlyOLvRohUJooC/4QwpeDkdaY17JX3A4gY
        3+XhlLuVGFimEVI9h6QTswNgMeG9538=
From:   Guoqing Jiang <guoqing.jiang@linux.dev>
To:     haris.iqbal@ionos.com, jinpu.wang@ionos.com, jgg@ziepe.ca,
        leon@kernel.org
Cc:     linux-rdma@vger.kernel.org
Subject: [PATCH 1/3] RDMA/rtrs: Update comments for MAX_SESS_QUEUE_DEPTH
Date:   Fri,  2 Sep 2022 18:19:20 +0800
Message-Id: <20220902101922.26273-2-guoqing.jiang@linux.dev>
In-Reply-To: <20220902101922.26273-1-guoqing.jiang@linux.dev>
References: <20220902101922.26273-1-guoqing.jiang@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

The maximum queue_depth should be 65535 per check_module_params,
also update other relevant comments.

Signed-off-by: Guoqing Jiang <guoqing.jiang@linux.dev>
---
 drivers/infiniband/ulp/rtrs/rtrs-pri.h | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/ulp/rtrs/rtrs-pri.h b/drivers/infiniband/ulp/rtrs/rtrs-pri.h
index ac0df734eba8..a2420eecaf5a 100644
--- a/drivers/infiniband/ulp/rtrs/rtrs-pri.h
+++ b/drivers/infiniband/ulp/rtrs/rtrs-pri.h
@@ -26,11 +26,10 @@
 /*
  * Max IB immediate data size is 2^28 (MAX_IMM_PAYL_BITS)
  * and the minimum chunk size is 4096 (2^12).
- * So the maximum sess_queue_depth is 65536 (2^16) in theory.
- * But mempool_create, create_qp and ib_post_send fail with
- * "cannot allocate memory" error if sess_queue_depth is too big.
+ * So the maximum sess_queue_depth is 65535 (2^16 - 1) in theory
+ * since queue_depth in rtrs_msg_conn_rsp is defined as le16.
  * Therefore the pratical max value of sess_queue_depth is
- * somewhere between 1 and 65534 and it depends on the system.
+ * somewhere between 1 and 65535 and it depends on the system.
  */
 #define MAX_SESS_QUEUE_DEPTH 65535
 
-- 
2.31.1

