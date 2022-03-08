Return-Path: <linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2FAB9C433F5
	for <linux-rdma@archiver.kernel.org>; Tue,  8 Mar 2022 14:41:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233420AbiCHOmA (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Tue, 8 Mar 2022 09:42:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347595AbiCHOl6 (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Tue, 8 Mar 2022 09:41:58 -0500
Received: from out0.migadu.com (out0.migadu.com [IPv6:2001:41d0:2:267::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD3CD3981F;
        Tue,  8 Mar 2022 06:40:49 -0800 (PST)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1646750448;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=FK62XeX0rd9MAa4ISec0Y+t7VaGtO7JspUeEwxTS2lg=;
        b=sQShfL3XvAflIrUEWKbROqhXXfeA3yQJybhymJOvzU0clVDavTgQADlh2ncufi2+QyAnUw
        OTw404A4a+fXkhlknM6huejCjP2WD8k9oFxGlua8mbdugZnQUM59GWPa7CYRyYWBhyulKK
        71arZTsZ9phf4HXE1rpw4qROmaNrvk4=
From:   Yajun Deng <yajun.deng@linux.dev>
To:     jgg@nvidia.com, selvin.xavier@broadcom.com, galpress@amazon.com,
        sleybo@amazon.com, liangwenpeng@huawei.com, liweihang@huawei.com,
        mustafa.ismail@intel.com, shiraz.saleem@intel.com,
        leonro@nvidia.com, dennis.dalessandro@cornelisnetworks.com,
        mike.marciniszyn@cornelisnetworks.com, zyjzyj2000@gmail.com
Cc:     linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yajun Deng <yajun.deng@linux.dev>
Subject: [PATCH for-next 9/9] RDMA/rxe: get rid of create_user_ah
Date:   Tue,  8 Mar 2022 22:40:33 +0800
Message-Id: <20220308144033.3406606-1-yajun.deng@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

There is no create_user_ah in ib_device_ops, remove it.

Signed-off-by: Yajun Deng <yajun.deng@linux.dev>
---
 drivers/infiniband/sw/rxe/rxe_verbs.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/infiniband/sw/rxe/rxe_verbs.c b/drivers/infiniband/sw/rxe/rxe_verbs.c
index 80df9a8f71a1..fa0cf2554425 100644
--- a/drivers/infiniband/sw/rxe/rxe_verbs.c
+++ b/drivers/infiniband/sw/rxe/rxe_verbs.c
@@ -1053,7 +1053,6 @@ static const struct ib_device_ops rxe_dev_ops = {
 	.create_cq = rxe_create_cq,
 	.create_qp = rxe_create_qp,
 	.create_srq = rxe_create_srq,
-	.create_user_ah = rxe_create_ah,
 	.dealloc_driver = rxe_dealloc,
 	.dealloc_mw = rxe_dealloc_mw,
 	.dealloc_pd = rxe_dealloc_pd,
-- 
2.25.1

