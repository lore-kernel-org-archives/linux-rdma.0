Return-Path: <linux-rdma-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D31FAC41535
	for <linux-rdma@archiver.kernel.org>; Fri,  3 Nov 2023 06:07:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229379AbjKCGH4 (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Fri, 3 Nov 2023 02:07:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229463AbjKCGHz (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Fri, 3 Nov 2023 02:07:55 -0400
Received: from out30-113.freemail.mail.aliyun.com (out30-113.freemail.mail.aliyun.com [115.124.30.113])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5BE619D;
        Thu,  2 Nov 2023 23:07:51 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R181e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046060;MF=alibuda@linux.alibaba.com;NM=1;PH=DS;RN=9;SR=0;TI=SMTPD_---0VvYF2G2_1698991660;
Received: from j66a10360.sqa.eu95.tbsite.net(mailfrom:alibuda@linux.alibaba.com fp:SMTPD_---0VvYF2G2_1698991660)
          by smtp.aliyun-inc.com;
          Fri, 03 Nov 2023 14:07:45 +0800
From:   "D. Wythe" <alibuda@linux.alibaba.com>
To:     kgraul@linux.ibm.com, wenjia@linux.ibm.com, jaka@linux.ibm.com,
        wintera@linux.ibm.com
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org
Subject: [PATCH net v2 0/3] bugfixs for smc
Date:   Fri,  3 Nov 2023 14:07:37 +0800
Message-Id: <1698991660-82957-1-git-send-email-alibuda@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

From: "D. Wythe" <alibuda@linux.alibaba.com>

This patches includes bugfix following:

1. hung state
2. sock leak
3. potential panic

We have been testing these patches for some time, but
if you have any questions, please let us know.

--
v1:
Fix spelling errors and incorrect function names in descriptions

v2->v1:
Add fix tags for bugfix patch

D. Wythe (3):
  net/smc: fix dangling sock under state SMC_APPFINCLOSEWAIT
  net/smc: allow cdc msg send rather than drop it with NULL sndbuf_desc
  net/smc: put sk reference if close work was canceled

 net/smc/af_smc.c    |  4 ++--
 net/smc/smc.h       |  5 +++++
 net/smc/smc_cdc.c   | 11 +++++------
 net/smc/smc_close.c |  5 +++--
 4 files changed, 15 insertions(+), 10 deletions(-)

-- 
1.8.3.1

