Return-Path: <SRS0=jD56=DR=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9C84C433E7
	for <linux-rdma@archiver.kernel.org>; Sat, 10 Oct 2020 11:12:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A6B5B2067C
	for <linux-rdma@archiver.kernel.org>; Sat, 10 Oct 2020 11:12:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729774AbgJJLLx (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Sat, 10 Oct 2020 07:11:53 -0400
Received: from smtp.h3c.com ([60.191.123.50]:52185 "EHLO h3cspam02-ex.h3c.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727172AbgJJKZ2 (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Sat, 10 Oct 2020 06:25:28 -0400
X-Greylist: delayed 4237 seconds by postgrey-1.27 at vger.kernel.org; Sat, 10 Oct 2020 06:24:59 EDT
Received: from h3cspam02-ex.h3c.com (localhost [127.0.0.2] (may be forged))
        by h3cspam02-ex.h3c.com with ESMTP id 09A99kEg079319;
        Sat, 10 Oct 2020 17:09:46 +0800 (GMT-8)
        (envelope-from tian.xianting@h3c.com)
Received: from DAG2EX03-BASE.srv.huawei-3com.com ([10.8.0.66])
        by h3cspam02-ex.h3c.com with ESMTPS id 09A97Cki074737
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sat, 10 Oct 2020 17:07:13 +0800 (GMT-8)
        (envelope-from tian.xianting@h3c.com)
Received: from localhost.localdomain (10.99.212.201) by
 DAG2EX03-BASE.srv.huawei-3com.com (10.8.0.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Sat, 10 Oct 2020 17:07:15 +0800
From:   Xianting Tian <tian.xianting@h3c.com>
To:     <mike.marciniszyn@intel.com>, <dennis.dalessandro@intel.com>,
        <dledford@redhat.com>, <jgg@ziepe.ca>
CC:     <linux-rdma@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Xianting Tian <tian.xianting@h3c.com>
Subject: [PATCH] IB/hfi1: Avoid allocing memory on memoryless numa node
Date:   Sat, 10 Oct 2020 16:57:32 +0800
Message-ID: <20201010085732.20708-1-tian.xianting@h3c.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.99.212.201]
X-ClientProxiedBy: BJSMTP01-EX.srv.huawei-3com.com (10.63.20.132) To
 DAG2EX03-BASE.srv.huawei-3com.com (10.8.0.66)
X-DNSRBL: 
X-MAIL: h3cspam02-ex.h3c.com 09A97Cki074737
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

In architecture like powerpc, we can have cpus without any local memory
attached to it. In such cases the node does not have real memory.

Use local_memory_node(), which is guaranteed to have memory.
local_memory_node is a noop in other architectures that does not support
memoryless nodes.

Signed-off-by: Xianting Tian <tian.xianting@h3c.com>
---
 drivers/infiniband/hw/hfi1/file_ops.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/hfi1/file_ops.c b/drivers/infiniband/hw/hfi1/file_ops.c
index 8ca51e43c..79fa22cc7 100644
--- a/drivers/infiniband/hw/hfi1/file_ops.c
+++ b/drivers/infiniband/hw/hfi1/file_ops.c
@@ -965,7 +965,7 @@ static int allocate_ctxt(struct hfi1_filedata *fd, struct hfi1_devdata *dd,
 	 */
 	fd->rec_cpu_num = hfi1_get_proc_affinity(dd->node);
 	if (fd->rec_cpu_num != -1)
-		numa = cpu_to_node(fd->rec_cpu_num);
+		numa = local_memory_node(cpu_to_node(fd->rec_cpu_num));
 	else
 		numa = numa_node_id();
 	ret = hfi1_create_ctxtdata(dd->pport, numa, &uctxt);
-- 
2.17.1

