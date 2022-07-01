Return-Path: <linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A0F7CCA479
	for <linux-rdma@archiver.kernel.org>; Fri,  1 Jul 2022 08:00:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235659AbiGAIA1 (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Fri, 1 Jul 2022 04:00:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235375AbiGAIA0 (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Fri, 1 Jul 2022 04:00:26 -0400
Received: from mail.nfschina.com (unknown [IPv6:2400:dd01:100f:2:72e2:84ff:fe10:5f45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A00576F35A;
        Fri,  1 Jul 2022 01:00:25 -0700 (PDT)
Received: from localhost (unknown [127.0.0.1])
        by mail.nfschina.com (Postfix) with ESMTP id 924871E80D93;
        Fri,  1 Jul 2022 15:58:56 +0800 (CST)
X-Virus-Scanned: amavisd-new at test.com
Received: from mail.nfschina.com ([127.0.0.1])
        by localhost (mail.nfschina.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id NCKnNYbgzgyE; Fri,  1 Jul 2022 15:58:54 +0800 (CST)
Received: from localhost.localdomain (unknown [112.65.12.78])
        (Authenticated sender: jiaming@nfschina.com)
        by mail.nfschina.com (Postfix) with ESMTPA id 0C9F01E80D92;
        Fri,  1 Jul 2022 15:58:53 +0800 (CST)
From:   Zhang Jiaming <jiaming@nfschina.com>
To:     zyjzyj2000@gmail.com, jgg@ziepe.ca, leon@kernel.org
Cc:     linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
        liqiong@nfschina.com, renyu@nfschina.com,
        Zhang Jiaming <jiaming@nfschina.com>
Subject: [PATCH] RDMA/rxe: Fix typo
Date:   Fri,  1 Jul 2022 16:00:19 +0800
Message-Id: <20220701080019.13329-1-jiaming@nfschina.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

There is a spelling mistake (writeable) in function rxe_check_bind_mw.
Fix it.

Signed-off-by: Zhang Jiaming <jiaming@nfschina.com>
---
 drivers/infiniband/sw/rxe/rxe_mw.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/sw/rxe/rxe_mw.c b/drivers/infiniband/sw/rxe/rxe_mw.c
index 2e1fa844fabf..83b5d2b2ebfd 100644
--- a/drivers/infiniband/sw/rxe/rxe_mw.c
+++ b/drivers/infiniband/sw/rxe/rxe_mw.c
@@ -113,7 +113,7 @@ static int rxe_check_bind_mw(struct rxe_qp *qp, struct rxe_send_wqe *wqe,
 		      (IB_ACCESS_REMOTE_WRITE | IB_ACCESS_REMOTE_ATOMIC)) &&
 		     !(mr->access & IB_ACCESS_LOCAL_WRITE))) {
 		pr_err_once(
-			"attempt to bind an writeable MW to an MR without local write access\n");
+			"attempt to bind an writable MW to an MR without local write access\n");
 		return -EINVAL;
 	}
 
-- 
2.25.1

