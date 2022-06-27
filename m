Return-Path: <linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08962CCA481
	for <linux-rdma@archiver.kernel.org>; Mon, 27 Jun 2022 11:33:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234468AbiF0Lds (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Mon, 27 Jun 2022 07:33:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236238AbiF0Lda (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Mon, 27 Jun 2022 07:33:30 -0400
Received: from mail-m2835.qiye.163.com (mail-m2835.qiye.163.com [103.74.28.35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03AEBD10A
        for <linux-rdma@vger.kernel.org>; Mon, 27 Jun 2022 04:30:41 -0700 (PDT)
Received: from localhost.localdomain (unknown [117.48.120.186])
        by mail-m2835.qiye.163.com (Hmail) with ESMTPA id 3AE268A014A;
        Mon, 27 Jun 2022 19:30:39 +0800 (CST)
From:   Tao Liu <thomas.liu@ucloud.cn>
To:     linux-rdma@vger.kernel.org
Cc:     saeedm@nvidia.com, talgi@nvidia.com, leonro@nvidia.com,
        mgurtovoy@nvidia.com, jgg@nvidia.com, yaminf@nvidia.com,
        thomas.liu@ucloud.cn
Subject: [PATCH v2] linux/dim: Fix divide 0 in RDMA DIM.
Date:   Mon, 27 Jun 2022 19:30:36 +0800
Message-Id: <20220627113036.1324-1-thomas.liu@ucloud.cn>
X-Mailer: git-send-email 2.30.1 (Apple Git-130)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
        tZV1koWUFJQjdXWS1ZQUlXWQ8JGhUIEh9ZQVlDHUseVk4eSExDGUJJGUwfGVUZERMWGhIXJBQOD1
        lXWRgSC1lBWUpKTFVPQ1VKSUtVSkNNWVdZFhoPEhUdFFlBWU9LSFVKSktISkNVS1kG
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6PxQ6ISo5MjIRFwhRHBVMD0hC
        FTAaCTBVSlVKTU5NSElCT0hCTU1KVTMWGhIXVQ8TFBYaCFUXEg47DhgXFA4fVRgVRVlXWRILWUFZ
        SkpMVU9DVUpJS1VKQ01ZV1kIAVlBSk1DTzcG
X-HM-Tid: 0a81a4ed8864841dkuqw3ae268a014a
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

We hit a divide 0 error in ofed 5.1.2.3.7.1. It is caused in
rdma_dim_stats_compare() when prev->cpe_ratio == 0.

dim.c and rdma_dim.c in ofed share same code with upstream.
We check the 0 case in IS_SIGNIFICANT_DIFF(), and do not change
decision order.

Signed-off-by: Tao Liu <thomas.liu@ucloud.cn>
---
 include/linux/dim.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/dim.h b/include/linux/dim.h
index b698266d0035..6c5733981563 100644
--- a/include/linux/dim.h
+++ b/include/linux/dim.h
@@ -21,7 +21,7 @@
  * We consider 10% difference as significant.
  */
 #define IS_SIGNIFICANT_DIFF(val, ref) \
-	(((100UL * abs((val) - (ref))) / (ref)) > 10)
+	((ref) && (((100UL * abs((val) - (ref))) / (ref)) > 10))
 
 /*
  * Calculate the gap between two values.
-- 
2.30.1 (Apple Git-130)

