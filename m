Return-Path: <SRS0=HMeR=4C=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4CDF8C2BA83
	for <linux-rdma@archiver.kernel.org>; Fri, 14 Feb 2020 19:13:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DC4E9206D7
	for <linux-rdma@archiver.kernel.org>; Fri, 14 Feb 2020 19:13:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=dlink.ru header.i=@dlink.ru header.b="DY4dBz5A"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388174AbgBNTN2 (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Fri, 14 Feb 2020 14:13:28 -0500
Received: from mail.dlink.ru ([178.170.168.18]:39436 "EHLO fd.dlink.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387950AbgBNTN2 (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Fri, 14 Feb 2020 14:13:28 -0500
Received: by fd.dlink.ru (Postfix, from userid 5000)
        id 3A6A41B20805; Fri, 14 Feb 2020 22:13:24 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 fd.dlink.ru 3A6A41B20805
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dlink.ru; s=mail;
        t=1581707604; bh=nhwdDqOJlQOl87aKKC1lm6aCScw7AzhefyZ1wDtS7gM=;
        h=From:To:Cc:Subject:Date;
        b=DY4dBz5AoMAcKmdPUcOGmsbVictVqh8ydt+C2b60OuKVD2Yl8EuvU2I6VXU8uYyBn
         ZCF/rIdXanWiCZigjzm9IVcJ87yF9r7H8GR36ZylmCfQ1l0rwPoS/lGlnvFukv4hy9
         4diizy5KiiVJJAPqU13qsLWwWDDqAWISiPxU6LP0=
Received: from mail.rzn.dlink.ru (mail.rzn.dlink.ru [178.170.168.13])
        by fd.dlink.ru (Postfix) with ESMTP id 748631B201C3;
        Fri, 14 Feb 2020 22:13:17 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 fd.dlink.ru 748631B201C3
Received: from mail.rzn.dlink.ru (localhost [127.0.0.1])
        by mail.rzn.dlink.ru (Postfix) with ESMTP id 41F041B2267C;
        Fri, 14 Feb 2020 22:13:16 +0300 (MSK)
Received: from localhost.localdomain (unknown [196.196.203.118])
        by mail.rzn.dlink.ru (Postfix) with ESMTPA;
        Fri, 14 Feb 2020 22:13:16 +0300 (MSK)
From:   Alexander Lobakin <alobakin@dlink.ru>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>,
        Yishai Hadas <yishaih@mellanox.com>,
        Maxim Mikityanskiy <maximmi@mellanox.com>,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alexander Lobakin <alobakin@dlink.ru>
Subject: [PATCH rdma] IB/mlx5: Fix linkage failure on 32-bit arches
Date:   Fri, 14 Feb 2020 22:13:09 +0300
Message-Id: <20200214191309.155654-1-alobakin@dlink.ru>
X-Mailer: git-send-email 2.25.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

Commit f164be8c0366 ("IB/mlx5: Extend caps stage to handle VAR
capabilities") introduced a straight "/" division of the u64
variable "bar_size", which emits an __udivdi3() libgcc call on
32-bit arches and certain GCC versions:

error: "__udivdi3" [drivers/infiniband/hw/mlx5/mlx5_ib.ko] undefined! [1]

Replace it with the corresponding div_u64() call.
Compile-tested on ARCH=mips 32r2el_defconfig BOARDS=ocelot.

[1] https://lore.kernel.org/linux-mips/CAMuHMdXM9S1VkFMZ8eDAyZR6EE4WkJY215Lcn2qdOaPeadF+EQ@mail.gmail.com/

Fixes: f164be8c0366 ("IB/mlx5: Extend caps stage to handle VAR
capabilities")
Signed-off-by: Alexander Lobakin <alobakin@dlink.ru>
---
 drivers/infiniband/hw/mlx5/main.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index e874d688d040..c47530e4d202 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -6545,7 +6545,8 @@ static int mlx5_ib_init_var_table(struct mlx5_ib_dev *dev)
 					doorbell_bar_offset);
 	bar_size = (1ULL << log_doorbell_bar_size) * 4096;
 	var_table->stride_size = 1ULL << log_doorbell_stride;
-	var_table->num_var_hw_entries = bar_size / var_table->stride_size;
+	var_table->num_var_hw_entries = div_u64(bar_size,
+						var_table->stride_size);
 	mutex_init(&var_table->bitmap_lock);
 	var_table->bitmap = bitmap_zalloc(var_table->num_var_hw_entries,
 					  GFP_KERNEL);
-- 
2.25.0

