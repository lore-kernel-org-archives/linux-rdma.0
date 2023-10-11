Return-Path: <linux-rdma-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1ED6CD98F7
	for <linux-rdma@archiver.kernel.org>; Wed, 11 Oct 2023 07:33:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344707AbjJKHdb (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Wed, 11 Oct 2023 03:33:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344466AbjJKHdb (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Wed, 11 Oct 2023 03:33:31 -0400
Received: from out30-100.freemail.mail.aliyun.com (out30-100.freemail.mail.aliyun.com [115.124.30.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C55391;
        Wed, 11 Oct 2023 00:33:28 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R571e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046049;MF=alibuda@linux.alibaba.com;NM=1;PH=DS;RN=10;SR=0;TI=SMTPD_---0VtvoMBA_1697009602;
Received: from j66a10360.sqa.eu95.tbsite.net(mailfrom:alibuda@linux.alibaba.com fp:SMTPD_---0VtvoMBA_1697009602)
          by smtp.aliyun-inc.com;
          Wed, 11 Oct 2023 15:33:26 +0800
From:   "D. Wythe" <alibuda@linux.alibaba.com>
To:     kgraul@linux.ibm.com, wenjia@linux.ibm.com, jaka@linux.ibm.com,
        wintera@linux.ibm.com
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org,
        "D. Wythe" <alibuda@linux.alibaba.com>
Subject: [PATCH net 0/5] net/smc: bugfixs for smc-r
Date:   Wed, 11 Oct 2023 15:33:15 +0800
Message-Id: <1697009600-22367-1-git-send-email-alibuda@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

From: "D. Wythe" <alibuda@linux.alibaba.com>

This patches contains bugfix following:

1. hung state
2. sock leak
3. potential panic 

We have been testing these patches for some time, but
if you have any questions, please let us know.

Thanks,
D. Wythe

D. Wythe (5):
  net/smc: fix dangling sock under state SMC_APPFINCLOSEWAIT
  net/smc: fix incorrect barrier usage
  net/smc: allow cdc msg send rather than drop it with NULL sndbuf_desc
  net/smc: protect connection state transitions in listen work
  net/smc: put sk reference if close work was canceled

 net/smc/af_smc.c    |  9 +++++++--
 net/smc/smc.h       |  5 +++++
 net/smc/smc_cdc.c   | 11 +++++------
 net/smc/smc_close.c |  5 +++--
 net/smc/smc_core.c  | 21 +++++++++++++--------
 5 files changed, 33 insertions(+), 18 deletions(-)

-- 
1.8.3.1

