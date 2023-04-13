Return-Path: <linux-rdma-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B5A2C77B6E
	for <linux-rdma@archiver.kernel.org>; Thu, 13 Apr 2023 10:14:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229766AbjDMKOy (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Thu, 13 Apr 2023 06:14:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229746AbjDMKOa (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Thu, 13 Apr 2023 06:14:30 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A304AF
        for <linux-rdma@vger.kernel.org>; Thu, 13 Apr 2023 03:14:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681380854; x=1712916854;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=8b8vJdLdaGarWMGYDCX+GLQKHw0iObWHbaN0F/onbHk=;
  b=L0AL/TDM01EphRIjV3xxDrDiHk3mCsQXvOCWlwkzBpHvTyj8teun05t/
   yR9Ck6C2RkcVwxYe3Ubarjnv3NiiRFV0lX0y90Si0sxUshj/CasxXGddU
   ONR+hkbsbmOurY0QyuPnxZRh/BqzWGpkrnHWqOszqaDFOtUcGDw6kIj6m
   xJ6WmxIyERZWX2As/3r93JH5/62lRUnQFABhdftxXqdirD+kmX3fjaBZY
   4vOksx56LGhezDUZbEtXzT/Sa4kG2SoO8pw6q8LJok4WXyYlsO0bXv1Oq
   PzisYHkWOAvtT54BD7v68HNunqRMb7cMRdGTH6l6tJGcCRp7aoEMwrqN2
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10678"; a="345935993"
X-IronPort-AV: E=Sophos;i="5.98,341,1673942400"; 
   d="scan'208";a="345935993"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Apr 2023 03:14:14 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10678"; a="639607764"
X-IronPort-AV: E=Sophos;i="5.98,341,1673942400"; 
   d="scan'208";a="639607764"
Received: from unknown (HELO intel-71.bj.intel.com) ([10.238.154.71])
  by orsmga003.jf.intel.com with ESMTP; 13 Apr 2023 03:14:11 -0700
From:   Zhu Yanjun <yanjun.zhu@intel.com>
To:     zyjzyj2000@gmail.com, jgg@ziepe.ca, leon@kernel.org,
        linux-rdma@vger.kernel.org
Cc:     Zhu Yanjun <yanjun.zhu@linux.dev>,
        syzbot+cfcc1a3c85be15a40cba@syzkaller.appspotmail.com
Subject: [PATCH rdma-next v4 1/1] RDMA/rxe: Fix the error "trying to register non-static key in rxe_cleanup_task"
Date:   Thu, 13 Apr 2023 18:11:15 +0800
Message-Id: <20230413101115.1366068-1-yanjun.zhu@intel.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

From: Zhu Yanjun <yanjun.zhu@linux.dev>

In the function rxe_create_qp(), rxe_qp_from_init() is called to
initialize qp, internally things like rxe_init_task are not setup until
rxe_qp_init_req().

If an error occures before this point then the unwind will call
rxe_cleanup() and eventually to rxe_qp_do_cleanup()/rxe_cleanup_task()
which will oops when trying to access the uninitialized spinlock.

If rxe_init_task is not executed, rxe_cleanup_task will not be called.

Reported-by: syzbot+cfcc1a3c85be15a40cba@syzkaller.appspotmail.com
Link: https://syzkaller.appspot.com/bug?id=fd85757b74b3eb59f904138486f755f71e090df8

Fixes: 8700e3e7c485 ("Soft RoCE driver")
Fixes: 2d4b21e0a291 ("IB/rxe: Prevent from completer to operate on non valid QP")
Signed-off-by: Zhu Yanjun <yanjun.zhu@linux.dev>
---
V3 -> V4: Remove the wrong signature;
V2 -> V3: Rebase to rdma-next;
V1 -> V2: Remove memset functions;
---
 drivers/infiniband/sw/rxe/rxe_qp.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/sw/rxe/rxe_qp.c b/drivers/infiniband/sw/rxe/rxe_qp.c
index 49891f8ed4e6..d5de5ba6940f 100644
--- a/drivers/infiniband/sw/rxe/rxe_qp.c
+++ b/drivers/infiniband/sw/rxe/rxe_qp.c
@@ -761,9 +761,14 @@ static void rxe_qp_do_cleanup(struct work_struct *work)
 		del_timer_sync(&qp->rnr_nak_timer);
 	}
 
-	rxe_cleanup_task(&qp->resp.task);
-	rxe_cleanup_task(&qp->req.task);
-	rxe_cleanup_task(&qp->comp.task);
+	if (qp->resp.task.func)
+		rxe_cleanup_task(&qp->resp.task);
+
+	if (qp->req.task.func)
+		rxe_cleanup_task(&qp->req.task);
+
+	if (qp->comp.task.func)
+		rxe_cleanup_task(&qp->comp.task);
 
 	/* flush out any receive wr's or pending requests */
 	rxe_requester(qp);
-- 
2.27.0

