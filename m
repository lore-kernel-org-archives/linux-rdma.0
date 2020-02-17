Return-Path: <SRS0=eK3A=4F=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56FE6C35242
	for <linux-rdma@archiver.kernel.org>; Mon, 17 Feb 2020 07:37:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2CB6C206D5
	for <linux-rdma@archiver.kernel.org>; Mon, 17 Feb 2020 07:37:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=dlink.ru header.i=@dlink.ru header.b="Qu7oPA1X"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726294AbgBQHhF (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Mon, 17 Feb 2020 02:37:05 -0500
Received: from mail.dlink.ru ([178.170.168.18]:59094 "EHLO fd.dlink.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726267AbgBQHhF (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Mon, 17 Feb 2020 02:37:05 -0500
Received: by fd.dlink.ru (Postfix, from userid 5000)
        id C55C51B20178; Mon, 17 Feb 2020 10:36:59 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 fd.dlink.ru C55C51B20178
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dlink.ru; s=mail;
        t=1581925019; bh=eMq5r5AI5OZpxp2xPSJgmnoHlWLUKUDdtJ1FhSVqTnU=;
        h=From:To:Cc:Subject:Date;
        b=Qu7oPA1XQlVxL8otZibt8yXwEa3ObLpHjX/fQbG6SMpYsy545pSeupm49AWZ4GJnS
         GsGbpgQCj0GId/Ceo22WPkNJgO2RbCZa2vb2Kd8C9MugiyfqW9FELRm+9ySRRwtBEp
         bVK/XMxeUh3BMrH+UgmTmzZzg8OaDnU1oR9x55rk=
Received: from mail.rzn.dlink.ru (mail.rzn.dlink.ru [178.170.168.13])
        by fd.dlink.ru (Postfix) with ESMTP id B9E4A1B20178;
        Mon, 17 Feb 2020 10:36:53 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 fd.dlink.ru B9E4A1B20178
Received: from mail.rzn.dlink.ru (localhost [127.0.0.1])
        by mail.rzn.dlink.ru (Postfix) with ESMTP id F38A51B21819;
        Mon, 17 Feb 2020 10:36:52 +0300 (MSK)
Received: from localhost.localdomain (unknown [196.196.203.126])
        by mail.rzn.dlink.ru (Postfix) with ESMTPA;
        Mon, 17 Feb 2020 10:36:52 +0300 (MSK)
From:   Alexander Lobakin <alobakin@dlink.ru>
To:     Jason Gunthorpe <jgg@ziepe.ca>
Cc:     Leon Romanovsky <leon@kernel.org>,
        Doug Ledford <dledford@redhat.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Maxim Mikityanskiy <maximmi@mellanox.com>,
        Alexander Lobakin <alobakin@dlink.ru>,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH rdma] IB/mlx5: Optimize u64 division on 32-bit arches
Date:   Mon, 17 Feb 2020 10:36:29 +0300
Message-Id: <20200217073629.8051-1-alobakin@dlink.ru>
X-Mailer: git-send-email 2.25.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

Commit f164be8c0366 ("IB/mlx5: Extend caps stage to handle VAR
capabilities") introduced a straight "/" division of the u64
variable "bar_size".
This was fixed with commit 685eff513183 ("IB/mlx5: Use div64_u64
for num_var_hw_entries calculation"). However, div64_u64() is
redundant here as mlx5_var_table::stride_size is of type u32.
Make the actual code way more optimized on 32-bit kernels using
div_u64() and fix 80 chars break-through by the way.

Fixes: 685eff513183 ("IB/mlx5: Use div64_u64 for num_var_hw_entries
calculation")
Signed-off-by: Alexander Lobakin <alobakin@dlink.ru>
---
 drivers/infiniband/hw/mlx5/main.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index e4bcfa81b70a..026391e4ceb4 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -6545,7 +6545,8 @@ static int mlx5_ib_init_var_table(struct mlx5_ib_dev *dev)
 					doorbell_bar_offset);
 	bar_size = (1ULL << log_doorbell_bar_size) * 4096;
 	var_table->stride_size = 1ULL << log_doorbell_stride;
-	var_table->num_var_hw_entries = div64_u64(bar_size, var_table->stride_size);
+	var_table->num_var_hw_entries = div_u64(bar_size,
+						var_table->stride_size);
 	mutex_init(&var_table->bitmap_lock);
 	var_table->bitmap = bitmap_zalloc(var_table->num_var_hw_entries,
 					  GFP_KERNEL);
-- 
2.25.0

