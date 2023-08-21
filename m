Return-Path: <linux-rdma-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30619EE49A5
	for <linux-rdma@archiver.kernel.org>; Mon, 21 Aug 2023 08:48:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234072AbjHUIsi (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Mon, 21 Aug 2023 04:48:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234106AbjHUIsh (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Mon, 21 Aug 2023 04:48:37 -0400
Received: from out-49.mta0.migadu.com (out-49.mta0.migadu.com [91.218.175.49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B12EC2
        for <linux-rdma@vger.kernel.org>; Mon, 21 Aug 2023 01:48:35 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1692607713;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9vzpsBXmojz1JsNyc3SshEhReKj3po9p4YLPESqA7hc=;
        b=FWLpqXfUwyRbuvDdH2ZIJRjkM1/oBxfDop3d1XEXkYkiWb/W3nPIXS+3yJdB40CJasZ+Hv
        ylaJp4VK+0AL/ofGpZErrZWES06NQHfIBEJV1N332SuA2V8gDnY9tYk+qICYAGadQZdOHj
        F1kRluhRXluXOUi63Tn+A7oEB1cmgWo=
From:   Guoqing Jiang <guoqing.jiang@linux.dev>
To:     bmt@zurich.ibm.com, jgg@ziepe.ca, leon@kernel.org
Cc:     linux-rdma@vger.kernel.org
Subject: [PATCH V2 2/3] RDMA/siw: Correct wrong debug message
Date:   Mon, 21 Aug 2023 16:47:42 +0800
Message-Id: <20230821084743.6489-3-guoqing.jiang@linux.dev>
In-Reply-To: <20230821084743.6489-1-guoqing.jiang@linux.dev>
References: <20230821084743.6489-1-guoqing.jiang@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

We need to print num_sle first then pbl->max_buf per the condition.
Also replace mem->pbl with pbl while at it.

Fixes: 303ae1cdfdf7 ("rdma/siw: application interface")
Signed-off-by: Guoqing Jiang <guoqing.jiang@linux.dev>
---
 drivers/infiniband/sw/siw/siw_verbs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/sw/siw/siw_verbs.c b/drivers/infiniband/sw/siw/siw_verbs.c
index 398ec13db624..4832723dc244 100644
--- a/drivers/infiniband/sw/siw/siw_verbs.c
+++ b/drivers/infiniband/sw/siw/siw_verbs.c
@@ -1494,7 +1494,7 @@ int siw_map_mr_sg(struct ib_mr *base_mr, struct scatterlist *sl, int num_sle,
 
 	if (pbl->max_buf < num_sle) {
 		siw_dbg_mem(mem, "too many SGE's: %d > %d\n",
-			    mem->pbl->max_buf, num_sle);
+			    num_sle, pbl->max_buf);
 		return -ENOMEM;
 	}
 	for_each_sg(sl, slp, num_sle, i) {
-- 
2.35.3

