Return-Path: <SRS0=0+5s=DH=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A140C2D0A8
	for <linux-rdma@archiver.kernel.org>; Wed, 30 Sep 2020 07:20:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4E1922075F
	for <linux-rdma@archiver.kernel.org>; Wed, 30 Sep 2020 07:20:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1601450414;
	bh=aiNniMZIwRTGoTEql57lPQrryn5dhARkTmXWd751G7o=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=mHQ4pVBsVp6sn5TmWOG0QiXiyTHZbDHzi/kjVX3OStdVSEjyaji2XguJ3fU/8tRHh
	 PmD2xsxN0doJrPFx2kBtq4aDo+X1HKMxB3B35NFtiJ+YiiDzVAcP4NeFAZ0awfb39T
	 g0/UbSp0j/4//H22RKDG5tBvWJS0NsMVUBa958wE=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725786AbgI3HUN (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Wed, 30 Sep 2020 03:20:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:49400 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725440AbgI3HUM (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Wed, 30 Sep 2020 03:20:12 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EFD4F2076E;
        Wed, 30 Sep 2020 07:20:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601450412;
        bh=aiNniMZIwRTGoTEql57lPQrryn5dhARkTmXWd751G7o=;
        h=From:To:Cc:Subject:Date:From;
        b=Py+R7LIAia83FOLaG5RtUtYxbKzjJF4BWuBN3quQ3Z7PhCG/vBw7VKEP0iZB8liZr
         ZldLcYuyBeuepX2DFiwRRNE6698EYszZzidkPtupewOxe0fzoPvIhggm2qRKgTLZej
         2omDzIQwSykU2mdMCRBoqXmzZ/j9tVfL6LG6PYrE=
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Cc:     Dan Aloni <dan@kernelim.com>, linux-rdma@vger.kernel.org
Subject: [PATCH rdma-next] RDMA/addr: Fix race with netevent_callback()/rdma_addr_cancel()
Date:   Wed, 30 Sep 2020 10:20:07 +0300
Message-Id: <20200930072007.1009692-1-leon@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

From: Jason Gunthorpe <jgg@nvidia.com>

This three thread race can result in the work being run once the callback
becomes NULL:

       CPU1                 CPU2                   CPU3
 netevent_callback()
                     process_one_req()       rdma_addr_cancel()
                      [..]
     spin_lock_bh()
  	set_timeout()
     spin_unlock_bh()

						spin_lock_bh()
						list_del_init(&req->list);
						spin_unlock_bh()

		     req->callback = NULL
		     spin_lock_bh()
		       if (!list_empty(&req->list))
                         // Skipped!
		         // cancel_delayed_work(&req->work);
		     spin_unlock_bh()

		    process_one_req() // again
		     req->callback() // BOOM
						cancel_delayed_work_sync()

The solution is to always cancel the work once it is completed so any
in between set_timeout() does not result in it running again.

Fixes: 44e75052bc2a ("RDMA/rdma_cm: Make rdma_addr_cancel into a fence")
Reported-by: Dan Aloni <dan@kernelim.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/infiniband/core/addr.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/infiniband/core/addr.c b/drivers/infiniband/core/addr.c
index 3a98439bba83..0abce004a959 100644
--- a/drivers/infiniband/core/addr.c
+++ b/drivers/infiniband/core/addr.c
@@ -647,13 +647,12 @@ static void process_one_req(struct work_struct *_work)
 	req->callback = NULL;

 	spin_lock_bh(&lock);
+	/*
+	 * Although the work will normally have been canceled by the workqueue,
+	 * it can still be requeued as long as it is on the req_list.
+	 */
+	cancel_delayed_work(&req->work);
 	if (!list_empty(&req->list)) {
-		/*
-		 * Although the work will normally have been canceled by the
-		 * workqueue, it can still be requeued as long as it is on the
-		 * req_list.
-		 */
-		cancel_delayed_work(&req->work);
 		list_del_init(&req->list);
 		kfree(req);
 	}
--
2.26.2

