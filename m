Return-Path: <linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE47BC4332F
	for <linux-rdma@archiver.kernel.org>; Sun, 13 Nov 2022 01:09:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235092AbiKMBJD (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Sat, 12 Nov 2022 20:09:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235127AbiKMBJB (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Sat, 12 Nov 2022 20:09:01 -0500
Received: from out2.migadu.com (out2.migadu.com [IPv6:2001:41d0:2:aacc::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE8059592
        for <linux-rdma@vger.kernel.org>; Sat, 12 Nov 2022 17:08:59 -0800 (PST)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1668301738;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=GvEkIWRlwtcZKi88qR9Qfnru6I7OFWi/eDsNysaKGsA=;
        b=WCQNDvT+G/o2RBU0ZLCpy+r6IgPO75cmU4wZ7RgafVKvnGsEqcWIQltUB3SayTt9i5wqAT
        Y5/eP1u+lnqKg5LPsNoZJO/C28WgZuL3oVVOpnQM1hqQaEOkGqiAHx9DZGdf+b23V660z/
        ox+O0aEZFd9/Q8f0tIuDrYHrgQvr/AI=
From:   Guoqing Jiang <guoqing.jiang@linux.dev>
To:     haris.iqbal@ionos.com, jinpu.wang@ionos.com, jgg@ziepe.ca,
        leon@kernel.org
Cc:     linux-rdma@vger.kernel.org
Subject: [PATCH RFC 12/12] RDMA/rtrs-srv: Remove kobject_del from rtrs_srv_destroy_once_sysfs_root_folders
Date:   Sun, 13 Nov 2022 09:08:23 +0800
Message-Id: <20221113010823.6436-13-guoqing.jiang@linux.dev>
In-Reply-To: <20221113010823.6436-1-guoqing.jiang@linux.dev>
References: <20221113010823.6436-1-guoqing.jiang@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

The kobj_paths which is created dynamically by kobject_create_and_add,
and per the comment above kobject_create_and_add, we only need to call
kobject_put which is not same as other kobjs such as stats->kobj_stats
and srv_path->kobj.

Signed-off-by: Guoqing Jiang <guoqing.jiang@linux.dev>
---
 drivers/infiniband/ulp/rtrs/rtrs-srv-sysfs.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/infiniband/ulp/rtrs/rtrs-srv-sysfs.c b/drivers/infiniband/ulp/rtrs/rtrs-srv-sysfs.c
index da8e205ce331..c76ba29da1e2 100644
--- a/drivers/infiniband/ulp/rtrs/rtrs-srv-sysfs.c
+++ b/drivers/infiniband/ulp/rtrs/rtrs-srv-sysfs.c
@@ -203,7 +203,6 @@ rtrs_srv_destroy_once_sysfs_root_folders(struct rtrs_srv_path *srv_path)
 
 	mutex_lock(&srv->paths_mutex);
 	if (!--srv->dev_ref) {
-		kobject_del(srv->kobj_paths);
 		kobject_put(srv->kobj_paths);
 		mutex_unlock(&srv->paths_mutex);
 		device_del(&srv->dev);
-- 
2.31.1

