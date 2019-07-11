Return-Path: <SRS0=2cZW=VI=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNWANTED_LANGUAGE_BODY,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B08A3C74A4A
	for <linux-rdma@archiver.kernel.org>; Thu, 11 Jul 2019 07:13:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 90BFA20872
	for <linux-rdma@archiver.kernel.org>; Thu, 11 Jul 2019 07:13:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728263AbfGKHNB (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Thu, 11 Jul 2019 03:13:01 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:2253 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728228AbfGKHNA (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Thu, 11 Jul 2019 03:13:00 -0400
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 8CDCF5E714F41455973C;
        Thu, 11 Jul 2019 15:12:55 +0800 (CST)
Received: from localhost (10.133.213.239) by DGGEMS411-HUB.china.huawei.com
 (10.3.19.211) with Microsoft SMTP Server id 14.3.439.0; Thu, 11 Jul 2019
 15:12:49 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     <bmt@zurich.ibm.com>, <dledford@redhat.com>, <jgg@ziepe.ca>
CC:     <linux-kernel@vger.kernel.org>, <linux-rdma@vger.kernel.org>,
        YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH -next] rdma/siw: remove set but not used variable 's'
Date:   Thu, 11 Jul 2019 15:12:13 +0800
Message-ID: <20190711071213.57880-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.10.2.windows.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.133.213.239]
X-CFilter-Loop: Reflected
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

Fixes gcc '-Wunused-but-set-variable' warning:

drivers/infiniband/sw/siw/siw_cm.c: In function siw_cm_llp_state_change:
drivers/infiniband/sw/siw/siw_cm.c:1278:17: warning: variable s set but not used [-Wunused-but-set-variable]

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 drivers/infiniband/sw/siw/siw_cm.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/infiniband/sw/siw/siw_cm.c b/drivers/infiniband/sw/siw/siw_cm.c
index c883bf5..7d87a78 100644
--- a/drivers/infiniband/sw/siw/siw_cm.c
+++ b/drivers/infiniband/sw/siw/siw_cm.c
@@ -1275,7 +1275,6 @@ static void siw_cm_llp_error_report(struct sock *sk)
 static void siw_cm_llp_state_change(struct sock *sk)
 {
 	struct siw_cep *cep;
-	struct socket *s;
 	void (*orig_state_change)(struct sock *s);
 
 	read_lock(&sk->sk_callback_lock);
@@ -1288,8 +1287,6 @@ static void siw_cm_llp_state_change(struct sock *sk)
 	}
 	orig_state_change = cep->sk_state_change;
 
-	s = sk->sk_socket;
-
 	siw_dbg_cep(cep, "state: %d\n", cep->state);
 
 	switch (sk->sk_state) {
-- 
2.7.4


