Return-Path: <linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 518F5C433EF
	for <linux-rdma@archiver.kernel.org>; Tue,  8 Mar 2022 14:39:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244152AbiCHOkF (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Tue, 8 Mar 2022 09:40:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242825AbiCHOkF (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Tue, 8 Mar 2022 09:40:05 -0500
Received: from out2.migadu.com (out2.migadu.com [IPv6:2001:41d0:2:aacc::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFD2038D80;
        Tue,  8 Mar 2022 06:39:08 -0800 (PST)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1646750347;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=hXaYM30fXzf7EbZCf7Yn4pxK0JWbZunWLEHDQabCqew=;
        b=TGhHDi8LJnxLHS92Pg6NecY1kdFLW3TndJQC+YIMbLY/jH25AmjQ8QllwJ/01BbdovkHZu
        dBN1zSZp+OYZwEWp8w0ZcLhqc8hKh9ZdSYejcmDONdX82mx/Xe2r6J3xpt1nuGYT0sjzPv
        G348sij6Qdf3e1L8bOVKkb/9+d9z7a4=
From:   Yajun Deng <yajun.deng@linux.dev>
To:     jgg@nvidia.com, selvin.xavier@broadcom.com, galpress@amazon.com,
        sleybo@amazon.com, liangwenpeng@huawei.com, liweihang@huawei.com,
        mustafa.ismail@intel.com, shiraz.saleem@intel.com,
        leonro@nvidia.com, dennis.dalessandro@cornelisnetworks.com,
        mike.marciniszyn@cornelisnetworks.com, zyjzyj2000@gmail.com
Cc:     linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yajun Deng <yajun.deng@linux.dev>
Subject: [PATCH for-next 6/9] RDMA/mlx5: get rid of create_user_ah
Date:   Tue,  8 Mar 2022 22:38:51 +0800
Message-Id: <20220308143851.3405060-1-yajun.deng@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

here is no create_user_ah in ib_device_ops, remove it.

Signed-off-by: Yajun Deng <yajun.deng@linux.dev>
---
 drivers/infiniband/hw/mlx5/main.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index 85f526c861e9..3c77e756c9ea 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -3727,7 +3727,6 @@ static const struct ib_device_ops mlx5_ib_dev_ops = {
 	.create_cq = mlx5_ib_create_cq,
 	.create_qp = mlx5_ib_create_qp,
 	.create_srq = mlx5_ib_create_srq,
-	.create_user_ah = mlx5_ib_create_ah,
 	.dealloc_pd = mlx5_ib_dealloc_pd,
 	.dealloc_ucontext = mlx5_ib_dealloc_ucontext,
 	.del_gid = mlx5_ib_del_gid,
-- 
2.25.1

