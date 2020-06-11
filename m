Return-Path: <SRS0=HkY6=7Y=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82B81C433E0
	for <linux-rdma@archiver.kernel.org>; Thu, 11 Jun 2020 13:00:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5DEE420801
	for <linux-rdma@archiver.kernel.org>; Thu, 11 Jun 2020 13:00:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1591880451;
	bh=AM+QjIkxVyPO4wNQJRrRou15D+SqLG5w262fn4yEAwk=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=fTFyQjefB5CjEJjlZn5UH5RkFn90RTagmPa8hmH0CjmysyVg/iICBP4Q46srLZ6AQ
	 wNcN5yt7xK12yEbVpdn1qKypqt4j7uR2zqQDhNoSfRTt/wpW9XuQ1FQhbu3Zijn2qm
	 yuk5aVqmUsj6I+DrDAe7LeWRnOwVmFRQxgD+dWSg=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726471AbgFKNAu (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Thu, 11 Jun 2020 09:00:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:60688 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726391AbgFKNAu (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Thu, 11 Jun 2020 09:00:50 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8AAC82078D;
        Thu, 11 Jun 2020 13:00:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591880450;
        bh=AM+QjIkxVyPO4wNQJRrRou15D+SqLG5w262fn4yEAwk=;
        h=From:To:Cc:Subject:Date:From;
        b=LalW4Bk0PpPtapDshB1GcZen6z3CyJIBJVsYXqu8KBMigalWMpENnEv9F+qLCUHuc
         wCFLvo1u1bba/Gcm9hpXOHCxCTMQR0yBCgMlOSxDlgc2Qu6pV3A78rSWLOwPYGxDyc
         RbUtgk0xkReoV3h8s1dD4mwYPcpxhvD9WF5m1Jt4=
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Cc:     Leon Romanovsky <leonro@mellanox.com>, linux-rdma@vger.kernel.org,
        kernel test robot <lkp@intel.com>
Subject: [PATCH rdma-rc] RDMA/core: Annotate CMA unlock helper routine
Date:   Thu, 11 Jun 2020 16:00:45 +0300
Message-Id: <20200611130045.1994026-1-leon@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro@mellanox.com>

Fix the following sparse error by adding annotation
to cm_queue_work_unlock() that it releases cm_id_priv->lock lock.

 drivers/infiniband/core/cm.c:936:24: warning: context imbalance in
 'cm_queue_work_unlock' - unexpected unlock

Fixes: e83f195aa45c ("RDMA/cm: Pull duplicated code into cm_queue_work_unlock()")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/infiniband/core/cm.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/infiniband/core/cm.c b/drivers/infiniband/core/cm.c
index 9ce787e37e22..0d1377232933 100644
--- a/drivers/infiniband/core/cm.c
+++ b/drivers/infiniband/core/cm.c
@@ -918,6 +918,7 @@ static void cm_free_work(struct cm_work *work)

 static void cm_queue_work_unlock(struct cm_id_private *cm_id_priv,
 				 struct cm_work *work)
+	__releases(&cm_id_priv->lock)
 {
 	bool immediate;

--
2.26.2

