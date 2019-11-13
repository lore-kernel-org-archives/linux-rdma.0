Return-Path: <SRS0=Aeev=ZF=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11F62C43331
	for <linux-rdma@archiver.kernel.org>; Wed, 13 Nov 2019 01:52:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D34D8204EC
	for <linux-rdma@archiver.kernel.org>; Wed, 13 Nov 2019 01:52:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1573609929;
	bh=UAiA5p4GwIPMn4XuVsudYM5hQDLrQ1ON5FvGJrnxOCU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=UJJd3EOr8JdvUChJR2+QuyE8pbjsOBN7u+ywE6xn/CMYY4T0dKekK2utokIgJOX+Q
	 9nftBDYCXjaynRoS2QcW8mNJbZCI/1QHAUwXNoNXw04T7nMsR7a/eF9Bj6Eld/94Cz
	 sricmXPe/dR2dSPbIBUfltAiAwwwL2R10FwD5FMk=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728162AbfKMBwI (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Tue, 12 Nov 2019 20:52:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:40554 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728150AbfKMBwH (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Tue, 12 Nov 2019 20:52:07 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B9EAB20674;
        Wed, 13 Nov 2019 01:52:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573609926;
        bh=UAiA5p4GwIPMn4XuVsudYM5hQDLrQ1ON5FvGJrnxOCU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TDsv+p7eZQiw1fG5QC721nryichxqkuXpkBmYX1lxGyC3GexIK2XQuMqdXhGoU/U7
         9MaxNZd/R4aznUcmbiz6rL1xWifnsn+/uhyNXu8ljv1f7cMubN1dK3d73L7nn+uEdQ
         /fiDCkkopU+ilamRZ8+NvV1esvrsLHveeFxa7S6o=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zhu Yanjun <yanjun.zhu@oracle.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>, linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 072/209] IB/rxe: avoid srq memory leak
Date:   Tue, 12 Nov 2019 20:48:08 -0500
Message-Id: <20191113015025.9685-72-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191113015025.9685-1-sashal@kernel.org>
References: <20191113015025.9685-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

From: Zhu Yanjun <yanjun.zhu@oracle.com>

[ Upstream commit aae0484e15f062ad2c2502e68e15dfb8b8f84608 ]

In rxe_queue_init, q and q->buf are allocated. In do_mmap_info, q->ip is
allocated. When error occurs, rxe_srq_from_init and the later error
handler do not free these allocated memories.  This will make memory leak.

Signed-off-by: Zhu Yanjun <yanjun.zhu@oracle.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/sw/rxe/rxe_srq.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/sw/rxe/rxe_srq.c b/drivers/infiniband/sw/rxe/rxe_srq.c
index 0d6c04ba7fc36..c41a5fee81f71 100644
--- a/drivers/infiniband/sw/rxe/rxe_srq.c
+++ b/drivers/infiniband/sw/rxe/rxe_srq.c
@@ -31,6 +31,7 @@
  * SOFTWARE.
  */
 
+#include <linux/vmalloc.h>
 #include "rxe.h"
 #include "rxe_loc.h"
 #include "rxe_queue.h"
@@ -129,13 +130,18 @@ int rxe_srq_from_init(struct rxe_dev *rxe, struct rxe_srq *srq,
 
 	err = do_mmap_info(rxe, uresp ? &uresp->mi : NULL, context, q->buf,
 			   q->buf_size, &q->ip);
-	if (err)
+	if (err) {
+		vfree(q->buf);
+		kfree(q);
 		return err;
+	}
 
 	if (uresp) {
 		if (copy_to_user(&uresp->srq_num, &srq->srq_num,
-				 sizeof(uresp->srq_num)))
+				 sizeof(uresp->srq_num))) {
+			rxe_queue_cleanup(q);
 			return -EFAULT;
+		}
 	}
 
 	return 0;
-- 
2.20.1

