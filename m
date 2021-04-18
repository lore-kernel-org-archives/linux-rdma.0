Return-Path: <linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CDFECC433ED
	for <linux-rdma@archiver.kernel.org>; Sun, 18 Apr 2021 21:26:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A054561027
	for <linux-rdma@archiver.kernel.org>; Sun, 18 Apr 2021 21:26:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232539AbhDRV0s (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Sun, 18 Apr 2021 17:26:48 -0400
Received: from smtp02.smtpout.orange.fr ([80.12.242.124]:37290 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232480AbhDRV0q (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Sun, 18 Apr 2021 17:26:46 -0400
Received: from localhost.localdomain ([86.243.172.93])
        by mwinf5d25 with ME
        id uMSG2400721Fzsu03MSGDU; Sun, 18 Apr 2021 23:26:17 +0200
X-ME-Helo: localhost.localdomain
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Sun, 18 Apr 2021 23:26:17 +0200
X-ME-IP: 86.243.172.93
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     tj@kernel.org, jiangshanlai@gmail.com, saeedm@nvidia.com,
        leon@kernel.org, davem@davemloft.net, kuba@kernel.org,
        bvanassche@acm.org
Cc:     netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH 1/2] workqueue: Have 'alloc_workqueue()' like macros accept a  format specifier
Date:   Sun, 18 Apr 2021 23:26:16 +0200
Message-Id: <ae88f6c2c613d17bc1a56692cfa4f960dbc723d2.1618780558.git.christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <cover.1618780558.git.christophe.jaillet@wanadoo.fr>
References: <cover.1618780558.git.christophe.jaillet@wanadoo.fr>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

Improve 'create_workqueue', 'create_freezable_workqueue' and
'create_singlethread_workqueue' so that they accept a format
specifier and a variable number of arguments.

This will put these macros more in line with 'alloc_ordered_workqueue' and
the underlying 'alloc_workqueue()' function.

This will also allow further code simplification.

Suggested-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
 include/linux/workqueue.h | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/include/linux/workqueue.h b/include/linux/workqueue.h
index d15a7730ee18..145e756ff315 100644
--- a/include/linux/workqueue.h
+++ b/include/linux/workqueue.h
@@ -425,13 +425,13 @@ struct workqueue_struct *alloc_workqueue(const char *fmt,
 	alloc_workqueue(fmt, WQ_UNBOUND | __WQ_ORDERED |		\
 			__WQ_ORDERED_EXPLICIT | (flags), 1, ##args)
 
-#define create_workqueue(name)						\
-	alloc_workqueue("%s", __WQ_LEGACY | WQ_MEM_RECLAIM, 1, (name))
-#define create_freezable_workqueue(name)				\
-	alloc_workqueue("%s", __WQ_LEGACY | WQ_FREEZABLE | WQ_UNBOUND |	\
-			WQ_MEM_RECLAIM, 1, (name))
-#define create_singlethread_workqueue(name)				\
-	alloc_ordered_workqueue("%s", __WQ_LEGACY | WQ_MEM_RECLAIM, name)
+#define create_workqueue(fmt, args...)					\
+	alloc_workqueue(fmt, __WQ_LEGACY | WQ_MEM_RECLAIM, 1, ##args)
+#define create_freezable_workqueue(fmt, args...)			\
+	alloc_workqueue(fmt, __WQ_LEGACY | WQ_FREEZABLE | WQ_UNBOUND |	\
+			WQ_MEM_RECLAIM, 1, ##args)
+#define create_singlethread_workqueue(fmt, args...)			\
+	alloc_ordered_workqueue(fmt, __WQ_LEGACY | WQ_MEM_RECLAIM, ##args)
 
 extern void destroy_workqueue(struct workqueue_struct *wq);
 
-- 
2.27.0

