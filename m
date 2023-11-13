Return-Path: <linux-rdma-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7EB8DC4332F
	for <linux-rdma@archiver.kernel.org>; Mon, 13 Nov 2023 11:57:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230324AbjKML5w (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Mon, 13 Nov 2023 06:57:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230323AbjKML5v (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Mon, 13 Nov 2023 06:57:51 -0500
Received: from out-187.mta1.migadu.com (out-187.mta1.migadu.com [95.215.58.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15D81D78
        for <linux-rdma@vger.kernel.org>; Mon, 13 Nov 2023 03:57:46 -0800 (PST)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1699876665;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cRIh0/+cJy0iTqpkHFk8pRZcHVKwd/KMHQoBl+k6SCk=;
        b=LvkT8ykkYtb60LpQ5jUHIVDFvtXBubjGuapJRJI+qq0nKsXabo69PXaDORozQ2rp4dCs3+
        gZLKO1kVdKBgMml4njwXBhmcb7she9l2NYloUcOM2WvvFbxOg0rp1BLYwHbraY0kN2NLBL
        G2L97x/HtTG5/xYwkj+o7mhMcbnzu8A=
From:   Guoqing Jiang <guoqing.jiang@linux.dev>
To:     bmt@zurich.ibm.com, jgg@ziepe.ca, leon@kernel.org
Cc:     linux-rdma@vger.kernel.org
Subject: [PATCH V5 09/17] RDMA/siw: Add one parameter to siw_destroy_cpulist
Date:   Mon, 13 Nov 2023 19:57:18 +0800
Message-Id: <20231113115726.12762-10-guoqing.jiang@linux.dev>
In-Reply-To: <20231113115726.12762-1-guoqing.jiang@linux.dev>
References: <20231113115726.12762-1-guoqing.jiang@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

With that we can reuse it in siw_init_cpulist.

Acked-by: Bernard Metzler <bmt@zurich.ibm.com>
Signed-off-by: Guoqing Jiang <guoqing.jiang@linux.dev>
---
 drivers/infiniband/sw/siw/siw_main.c | 30 +++++++++++++---------------
 1 file changed, 14 insertions(+), 16 deletions(-)

diff --git a/drivers/infiniband/sw/siw/siw_main.c b/drivers/infiniband/sw/siw/siw_main.c
index 1ab62982df74..61ad8ca3d1a2 100644
--- a/drivers/infiniband/sw/siw/siw_main.c
+++ b/drivers/infiniband/sw/siw/siw_main.c
@@ -109,6 +109,17 @@ static struct {
 	int num_nodes;
 } siw_cpu_info;
 
+static void siw_destroy_cpulist(int number)
+{
+	int i = 0;
+
+	while (i < number)
+		kfree(siw_cpu_info.tx_valid_cpus[i++]);
+
+	kfree(siw_cpu_info.tx_valid_cpus);
+	siw_cpu_info.tx_valid_cpus = NULL;
+}
+
 static int siw_init_cpulist(void)
 {
 	int i, num_nodes = nr_node_ids;
@@ -138,24 +149,11 @@ static int siw_init_cpulist(void)
 
 out_err:
 	siw_cpu_info.num_nodes = 0;
-	while (--i >= 0)
-		kfree(siw_cpu_info.tx_valid_cpus[i]);
-	kfree(siw_cpu_info.tx_valid_cpus);
-	siw_cpu_info.tx_valid_cpus = NULL;
+	siw_destroy_cpulist(i);
 
 	return -ENOMEM;
 }
 
-static void siw_destroy_cpulist(void)
-{
-	int i = 0;
-
-	while (i < siw_cpu_info.num_nodes)
-		kfree(siw_cpu_info.tx_valid_cpus[i++]);
-
-	kfree(siw_cpu_info.tx_valid_cpus);
-}
-
 /*
  * Choose CPU with least number of active QP's from NUMA node of
  * TX interface.
@@ -558,7 +556,7 @@ static __init int siw_init_module(void)
 	pr_info("SoftIWARP attach failed. Error: %d\n", rv);
 
 	siw_cm_exit();
-	siw_destroy_cpulist();
+	siw_destroy_cpulist(siw_cpu_info.num_nodes);
 
 	return rv;
 }
@@ -573,7 +571,7 @@ static void __exit siw_exit_module(void)
 
 	siw_cm_exit();
 
-	siw_destroy_cpulist();
+	siw_destroy_cpulist(siw_cpu_info.num_nodes);
 
 	if (siw_crypto_shash)
 		crypto_free_shash(siw_crypto_shash);
-- 
2.35.3

