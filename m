Return-Path: <linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3243EC5519F
	for <linux-rdma@archiver.kernel.org>; Wed, 25 Nov 2020 06:17:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A4245208CA
	for <linux-rdma@archiver.kernel.org>; Wed, 25 Nov 2020 06:17:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="Dh3GD2MC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726202AbgKYGRQ (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Wed, 25 Nov 2020 01:17:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:40300 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726197AbgKYGRQ (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Wed, 25 Nov 2020 01:17:16 -0500
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6F124208CA;
        Wed, 25 Nov 2020 06:17:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606285036;
        bh=VU1yDTFFZrXUsIKfkmYklWXTGZlLebMLV05wNpAGMSQ=;
        h=From:To:Cc:Subject:Date:From;
        b=Dh3GD2MCSarkOzk5NTFU0aLVH8JsKu1dt3dfZJtWS5CZEM2IyCsg5UT99t5Q/YGvm
         tnLduM2TODMDw27cky8N9V2jjJXUlhe07OqYNI+Htrf8SnL2uUEeJIeibTygQ5mDHq
         EYmWTedZGQmWvTWeH7NT6hbx4iOBBXJHCpKs4Y/s=
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Cc:     Leon Romanovsky <leonro@nvidia.com>, linux-rdma@vger.kernel.org
Subject: [PATCH rdma-next] RDMA/mlx5: Silence the overflow warning while building offset mask
Date:   Wed, 25 Nov 2020 08:17:04 +0200
Message-Id: <20201125061704.6580-1-leon@kernel.org>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

The coverity reports "Potentially overflowing expression ..." warning,
which is correct thing to complain from the compiler point of view, but
this is not possible in the current code.

Fixes: b045db62f6f6 ("RDMA/mlx5: Use ib_umem_find_best_pgoff() for SRQ")
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/infiniband/hw/mlx5/mem.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/mlx5/mem.c b/drivers/infiniband/hw/mlx5/mem.c
index f8ec5156d8e9..844545064c9e 100644
--- a/drivers/infiniband/hw/mlx5/mem.c
+++ b/drivers/infiniband/hw/mlx5/mem.c
@@ -62,7 +62,7 @@ unsigned long __mlx5_umem_find_best_quantized_pgoff(
 	unsigned int page_offset_bits, u64 pgoff_bitmask, unsigned int scale,
 	unsigned int *page_offset_quantized)
 {
-	const u64 page_offset_mask = (1 << page_offset_bits) - 1;
+	const u64 page_offset_mask = (1UL << page_offset_bits) - 1;
 	unsigned long page_size;
 	u64 page_offset;
 
-- 
2.28.0

