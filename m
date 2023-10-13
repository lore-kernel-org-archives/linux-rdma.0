Return-Path: <linux-rdma-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5CEA7CDB474
	for <linux-rdma@archiver.kernel.org>; Fri, 13 Oct 2023 02:01:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229441AbjJMCBQ (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Thu, 12 Oct 2023 22:01:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229509AbjJMCBP (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Thu, 12 Oct 2023 22:01:15 -0400
Received: from out-191.mta0.migadu.com (out-191.mta0.migadu.com [91.218.175.191])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC42AC0
        for <linux-rdma@vger.kernel.org>; Thu, 12 Oct 2023 19:01:13 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1697162472;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OPwcpA7//dIbTt1g4Eq45TjqQVUmQdS+9/pDuCW7ADw=;
        b=cHj9d1PYvRJqE3J0P/AqokTeRSWlKDWEqXocRBcaRUqN0d9D5yoJN1Qlu8dejgGsBIz+Uh
        ze4zlA1SbazxnY0fXkV01ojy+mHXAsLblitfBL28tsrO+69t6TrTljFNCL4Gsk5yg1u91A
        qajJelIh+i2jgjGPiudqNlT8ZEvYQcQ=
From:   Guoqing Jiang <guoqing.jiang@linux.dev>
To:     bmt@zurich.ibm.com, jgg@ziepe.ca, leon@kernel.org
Cc:     linux-rdma@vger.kernel.org
Subject: [PATCH V2 07/20] RDMA/siw: Also goto out_sem_up if pin_user_pages returns 0
Date:   Fri, 13 Oct 2023 10:00:40 +0800
Message-Id: <20231013020053.2120-8-guoqing.jiang@linux.dev>
In-Reply-To: <20231013020053.2120-1-guoqing.jiang@linux.dev>
References: <20231013020053.2120-1-guoqing.jiang@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

Since it is legitimate for pin_user_pages returns 0, which
means it might be dead loop here.

Signed-off-by: Guoqing Jiang <guoqing.jiang@linux.dev>
---
 drivers/infiniband/sw/siw/siw_mem.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/sw/siw/siw_mem.c b/drivers/infiniband/sw/siw/siw_mem.c
index c5f7f1669d09..92c5776a9eed 100644
--- a/drivers/infiniband/sw/siw/siw_mem.c
+++ b/drivers/infiniband/sw/siw/siw_mem.c
@@ -423,7 +423,7 @@ struct siw_umem *siw_umem_get(u64 start, u64 len, bool writable)
 		while (nents) {
 			rv = pin_user_pages(first_page_va, nents, foll_flags,
 					    plist);
-			if (rv < 0)
+			if (rv <= 0)
 				goto out_sem_up;
 
 			umem->num_pages += rv;
-- 
2.35.3

