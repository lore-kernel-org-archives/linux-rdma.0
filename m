Return-Path: <linux-rdma-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C618C4332F
	for <linux-rdma@archiver.kernel.org>; Mon, 13 Nov 2023 11:57:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230242AbjKML5p (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Mon, 13 Nov 2023 06:57:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230197AbjKML5o (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Mon, 13 Nov 2023 06:57:44 -0500
Received: from out-187.mta1.migadu.com (out-187.mta1.migadu.com [95.215.58.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA97C10C0
        for <linux-rdma@vger.kernel.org>; Mon, 13 Nov 2023 03:57:41 -0800 (PST)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1699876660;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/Vyos35ydMD/SnnsyYoq4LRYf8bR2O2lTe9t8OkQ3CI=;
        b=Da11oVxF+zEkuM0TFgYWcd1wrONkE1FbLabMe8gl8c/+vi+95AOOKVF3ZUAz/oOyDMy2At
        waQn/kYxUy2tBJohYHYysFpGeb8TtZxkNX8oGvcRmApW1InUFFmjIcEb2wF0QinYeyXCEe
        54C7cDy6Xsysg9uvJaNeiQAXfj4bOMQ=
From:   Guoqing Jiang <guoqing.jiang@linux.dev>
To:     bmt@zurich.ibm.com, jgg@ziepe.ca, leon@kernel.org
Cc:     linux-rdma@vger.kernel.org
Subject: [PATCH V5 05/17] RDMA/siw: Remove rcu from siw_qp
Date:   Mon, 13 Nov 2023 19:57:14 +0800
Message-Id: <20231113115726.12762-6-guoqing.jiang@linux.dev>
In-Reply-To: <20231113115726.12762-1-guoqing.jiang@linux.dev>
References: <20231113115726.12762-1-guoqing.jiang@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

Remove it since it is not used.

Acked-by: Bernard Metzler <bmt@zurich.ibm.com>
Signed-off-by: Guoqing Jiang <guoqing.jiang@linux.dev>
---
 drivers/infiniband/sw/siw/siw.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/infiniband/sw/siw/siw.h b/drivers/infiniband/sw/siw/siw.h
index 849e496c7e67..b36d1ec25327 100644
--- a/drivers/infiniband/sw/siw/siw.h
+++ b/drivers/infiniband/sw/siw/siw.h
@@ -465,7 +465,6 @@ struct siw_qp {
 	} term_info;
 	struct rdma_user_mmap_entry *sq_entry; /* mmap info for SQE array */
 	struct rdma_user_mmap_entry *rq_entry; /* mmap info for RQE array */
-	struct rcu_head rcu;
 };
 
 /* helper macros */
-- 
2.35.3

