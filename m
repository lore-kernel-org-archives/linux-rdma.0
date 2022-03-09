Return-Path: <linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1A8AC433EF
	for <linux-rdma@archiver.kernel.org>; Wed,  9 Mar 2022 03:30:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231629AbiCIDbz (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Tue, 8 Mar 2022 22:31:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231717AbiCIDby (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Tue, 8 Mar 2022 22:31:54 -0500
Received: from out199-1.us.a.mail.aliyun.com (out199-1.us.a.mail.aliyun.com [47.90.199.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 645D015C645;
        Tue,  8 Mar 2022 19:30:56 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R111e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04400;MF=dust.li@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0V6hFNJG_1646796651;
Received: from localhost(mailfrom:dust.li@linux.alibaba.com fp:SMTPD_---0V6hFNJG_1646796651)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 09 Mar 2022 11:30:52 +0800
From:   Dust Li <dust.li@linux.alibaba.com>
To:     kuba@kernel.org, Karsten Graul <kgraul@linux.ibm.com>,
        Tony Lu <tonylu@linux.alibaba.com>, davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-rdma@vger.kernel.org
Subject: [PATCH net-next] net/smc: fix -Wmissing-prototypes warning when CONFIG_SYSCTL not set
Date:   Wed,  9 Mar 2022 11:30:51 +0800
Message-Id: <20220309033051.41893-1-dust.li@linux.alibaba.com>
X-Mailer: git-send-email 2.19.1.3.ge56e4f7
MIME-Version: 1.0
X-Git-Hash: 06748fb85c3e
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

when CONFIG_SYSCTL not set, smc_sysctl_net_init/exit
need to be static inline to avoid missing-prototypes
if compile with W=1.

Since __net_exit has noinline annotation when CONFIG_NET_NS
not set, it should not be used with static inline.
So remove the __net_init/exit when CONFIG_SYSCTL not set.

Fixes: 7de8eb0d9039 ("net/smc: fix compile warning for smc_sysctl")
Signed-off-by: Dust Li <dust.li@linux.alibaba.com>
---
 net/smc/smc_sysctl.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/smc/smc_sysctl.h b/net/smc/smc_sysctl.h
index 1d554300604d..0becc11bd2f4 100644
--- a/net/smc/smc_sysctl.h
+++ b/net/smc/smc_sysctl.h
@@ -20,13 +20,13 @@ void __net_exit smc_sysctl_net_exit(struct net *net);
 
 #else
 
-int __net_init smc_sysctl_net_init(struct net *net)
+static inline int smc_sysctl_net_init(struct net *net)
 {
 	net->smc.sysctl_autocorking_size = SMC_AUTOCORKING_DEFAULT_SIZE;
 	return 0;
 }
 
-void __net_exit smc_sysctl_net_exit(struct net *net) { }
+static inline void smc_sysctl_net_exit(struct net *net) { }
 
 #endif /* CONFIG_SYSCTL */
 
-- 
2.19.1.3.ge56e4f7

