Return-Path: <linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2AED8C433EF
	for <linux-rdma@archiver.kernel.org>; Tue,  8 Mar 2022 14:38:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347525AbiCHOi7 (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Tue, 8 Mar 2022 09:38:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347530AbiCHOi6 (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Tue, 8 Mar 2022 09:38:58 -0500
X-Greylist: delayed 95 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 08 Mar 2022 06:37:59 PST
Received: from out1.migadu.com (out1.migadu.com [91.121.223.63])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6692329B6;
        Tue,  8 Mar 2022 06:37:58 -0800 (PST)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1646750277;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=o19dQIjkfabXS5JfOfa4bRxa2w2E+xg4aNQtDEegpkc=;
        b=ocxSqE4vm/1oTNvLUP/VkoHigCg3X3XJMJWg8fVmbVREKpWee5VRMafsVPJL8dQcZ4s9GP
        ezMcwm9Cx/VeizUrhQ+j5twRcAHjjfOWQHOJEUGUibEWySR9XJ3NZpQyz7dmUJgymLvHR5
        WXUlDyJrMtddh3rjXecmaml3WtjVY64=
From:   Yajun Deng <yajun.deng@linux.dev>
To:     jgg@nvidia.com, selvin.xavier@broadcom.com, galpress@amazon.com,
        sleybo@amazon.com, liangwenpeng@huawei.com, liweihang@huawei.com,
        mustafa.ismail@intel.com, shiraz.saleem@intel.com,
        leonro@nvidia.com, dennis.dalessandro@cornelisnetworks.com,
        mike.marciniszyn@cornelisnetworks.com, zyjzyj2000@gmail.com
Cc:     linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yajun Deng <yajun.deng@linux.dev>
Subject: [PATCH for-next 4/9] RDMA/hns:  get rid of create_user_ah
Date:   Tue,  8 Mar 2022 22:37:40 +0800
Message-Id: <20220308143740.3404014-1-yajun.deng@linux.dev>
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
 drivers/infiniband/hw/hns/hns_roce_main.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_main.c b/drivers/infiniband/hw/hns/hns_roce_main.c
index f73ba619f375..9b879d247e9b 100644
--- a/drivers/infiniband/hw/hns/hns_roce_main.c
+++ b/drivers/infiniband/hw/hns/hns_roce_main.c
@@ -505,7 +505,6 @@ static const struct ib_device_ops hns_roce_dev_ops = {
 	.alloc_pd = hns_roce_alloc_pd,
 	.alloc_ucontext = hns_roce_alloc_ucontext,
 	.create_ah = hns_roce_create_ah,
-	.create_user_ah = hns_roce_create_ah,
 	.create_cq = hns_roce_create_cq,
 	.create_qp = hns_roce_create_qp,
 	.dealloc_pd = hns_roce_dealloc_pd,
-- 
2.25.1

