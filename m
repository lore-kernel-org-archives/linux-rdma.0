Return-Path: <linux-rdma-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A0D5EE4996
	for <linux-rdma@archiver.kernel.org>; Tue, 22 Aug 2023 03:36:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232499AbjHVDgM (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Mon, 21 Aug 2023 23:36:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230169AbjHVDgL (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Mon, 21 Aug 2023 23:36:11 -0400
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41E40186
        for <linux-rdma@vger.kernel.org>; Mon, 21 Aug 2023 20:36:06 -0700 (PDT)
Received: from kwepemi500008.china.huawei.com (unknown [172.30.72.53])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4RVFMc3dHZz1L8Vq;
        Tue, 22 Aug 2023 11:34:36 +0800 (CST)
Received: from huawei.com (10.90.53.73) by kwepemi500008.china.huawei.com
 (7.221.188.139) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.31; Tue, 22 Aug
 2023 11:36:03 +0800
From:   Jinjie Ruan <ruanjinjie@huawei.com>
To:     <linux-rdma@vger.kernel.org>,
        Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Leon Romanovsky <leon@kernel.org>
CC:     <ruanjinjie@huawei.com>
Subject: [PATCH -next v2] RDMA/hfi1: Use list_for_each_entry() helper
Date:   Tue, 22 Aug 2023 11:35:38 +0800
Message-ID: <20230822033539.3692453-1-ruanjinjie@huawei.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.90.53.73]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 kwepemi500008.china.huawei.com (7.221.188.139)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

Convert list_for_each() to list_for_each_entry() so that the pos list_head
pointer and list_entry() call are no longer needed, which can
reduce a few lines of code. No functional changed.

Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>
---
v2:
- Update the commit message to clarify the purpose of the patch.
---
 drivers/infiniband/hw/hfi1/affinity.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/affinity.c b/drivers/infiniband/hw/hfi1/affinity.c
index 77ee77d4000f..bbc957c578e1 100644
--- a/drivers/infiniband/hw/hfi1/affinity.c
+++ b/drivers/infiniband/hw/hfi1/affinity.c
@@ -230,11 +230,9 @@ static void node_affinity_add_tail(struct hfi1_affinity_node *entry)
 /* It must be called with node_affinity.lock held */
 static struct hfi1_affinity_node *node_affinity_lookup(int node)
 {
-	struct list_head *pos;
 	struct hfi1_affinity_node *entry;
 
-	list_for_each(pos, &node_affinity.list) {
-		entry = list_entry(pos, struct hfi1_affinity_node, list);
+	list_for_each_entry(entry, &node_affinity.list, list) {
 		if (entry->node == node)
 			return entry;
 	}
-- 
2.34.1

