Return-Path: <linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9BB7C433F5
	for <linux-rdma@archiver.kernel.org>; Tue, 15 Feb 2022 08:24:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233983AbiBOIZF (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Tue, 15 Feb 2022 03:25:05 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:45322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232487AbiBOIZE (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Tue, 15 Feb 2022 03:25:04 -0500
Received: from out30-54.freemail.mail.aliyun.com (out30-54.freemail.mail.aliyun.com [115.124.30.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F8C2B715F;
        Tue, 15 Feb 2022 00:24:53 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R151e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04395;MF=alibuda@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0V4XPoIJ_1644913490;
Received: from localhost(mailfrom:alibuda@linux.alibaba.com fp:SMTPD_---0V4XPoIJ_1644913490)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 15 Feb 2022 16:24:51 +0800
From:   "D. Wythe" <alibuda@linux.alibaba.com>
To:     kgraul@linux.ibm.com
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org
Subject: [PATCH net-next] net/smc: return ETIMEDOUT when smc_connect_clc() timeout
Date:   Tue, 15 Feb 2022 16:24:50 +0800
Message-Id: <1644913490-21594-1-git-send-email-alibuda@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

From: "D. Wythe" <alibuda@linux.alibaba.com>

When smc_connect_clc() times out, it will return -EAGAIN(tcp_recvmsg
retuns -EAGAIN while timeout), then this value will passed to the
application, which is quite confusing to the applications, makes
inconsistency with TCP.

From the manual of connect, ETIMEDOUT is more suitable, and this patch
try convert EAGAIN to ETIMEDOUT in that case.

Signed-off-by: D. Wythe <alibuda@linux.alibaba.com>
---
 net/smc/af_smc.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
index 246c874..38a4064 100644
--- a/net/smc/af_smc.c
+++ b/net/smc/af_smc.c
@@ -1372,8 +1372,14 @@ static int __smc_connect(struct smc_sock *smc)
 
 	/* perform CLC handshake */
 	rc = smc_connect_clc(smc, aclc2, ini);
-	if (rc)
+	if (rc) {
+		/* -EAGAIN on timeout, see tcp_recvmsg() */
+		if (rc == -EAGAIN) {
+			rc = -ETIMEDOUT;
+			smc->sk.sk_err = ETIMEDOUT;
+		}
 		goto vlan_cleanup;
+	}
 
 	/* check if smc modes and versions of CLC proposal and accept match */
 	rc = smc_connect_check_aclc(ini, aclc);
-- 
1.8.3.1

