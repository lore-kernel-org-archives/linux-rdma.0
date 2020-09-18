Return-Path: <SRS0=aLju=C3=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D085C43465
	for <linux-rdma@archiver.kernel.org>; Fri, 18 Sep 2020 04:35:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EDBA4208DB
	for <linux-rdma@archiver.kernel.org>; Fri, 18 Sep 2020 04:35:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="WD+RPW8D"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726416AbgIREfc (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Fri, 18 Sep 2020 00:35:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726149AbgIREfc (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Fri, 18 Sep 2020 00:35:32 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42E1FC06174A;
        Thu, 17 Sep 2020 21:35:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=yS9eFbX4y5GaW4B7BzmKyRYd5WRLKcNTbaLlkNcKREU=; b=WD+RPW8DYk0H0rQYhIpo7Ira6C
        7Xha+isliybxBdqDUUmsdcJDroou2dj4QKFE1faPn/uwhAKmkFGoVSqLmJP2QiOxL6vgXDWSaAoJw
        wN0QpI3kbpZGZB3YFZ8r90RC9OwqCTFtRJ5PACyRdJTQuDuJUu8RRgjqhr9wOU33wKr3ovPalHFlH
        fD6iCm8Pzr5zmWrUyjNtxeii9xq7Bz7lnVZNmsij52EJplYqqipJiDqral9knD0cNO3Q0bqEC8wrB
        /mMFvWPMMXpeW5gdYKrmg2S8Hhmfz8vV067er86GS2yKxpfD0ZPL9N4qfg5ixz2GjGuQbMZxxQ0Xf
        Vp+Njx4g==;
Received: from [2601:1c0:6280:3f0::19c2] (helo=smtpauth.infradead.org)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kJ87N-0003Ci-Uz; Fri, 18 Sep 2020 04:35:30 +0000
From:   Randy Dunlap <rdunlap@infradead.org>
To:     netdev@vger.kernel.org
Cc:     Randy Dunlap <rdunlap@infradead.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Santosh Shilimkar <santosh.shilimkar@oracle.com>,
        linux-rdma@vger.kernel.org, rds-devel@oss.oracle.com
Subject: [PATCH 2/7 net-next] net: rds: delete duplicated words
Date:   Thu, 17 Sep 2020 21:35:16 -0700
Message-Id: <20200918043521.17346-3-rdunlap@infradead.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200918043521.17346-1-rdunlap@infradead.org>
References: <20200918043521.17346-1-rdunlap@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

Drop repeated words in net/rds/.

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Santosh Shilimkar <santosh.shilimkar@oracle.com>
Cc: linux-rdma@vger.kernel.org
Cc: rds-devel@oss.oracle.com
---
 net/rds/cong.c  |    2 +-
 net/rds/ib_cm.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- linux-next-20200917.orig/net/rds/cong.c
+++ linux-next-20200917/net/rds/cong.c
@@ -236,7 +236,7 @@ void rds_cong_queue_updates(struct rds_c
 			 *    tcp_setsockopt and/or tcp_sendmsg will deadlock
 			 *    when it tries to get the sock_lock())
 			 * 2. Interrupts are masked so that we can mark the
-			 *    the port congested from both send and recv paths.
+			 *    port congested from both send and recv paths.
 			 *    (See comment around declaration of rdc_cong_lock).
 			 *    An attempt to get the sock_lock() here will
 			 *    therefore trigger warnings.
--- linux-next-20200917.orig/net/rds/ib_cm.c
+++ linux-next-20200917/net/rds/ib_cm.c
@@ -711,7 +711,7 @@ static u32 rds_ib_protocol_compatible(st
 	 * original size. The only way to tell the difference is by looking at
 	 * the contents, which are initialized to zero.
 	 * If the protocol version fields aren't set, this is a connection attempt
-	 * from an older version. This could could be 3.0 or 2.0 - we can't tell.
+	 * from an older version. This could be 3.0 or 2.0 - we can't tell.
 	 * We really should have changed this for OFED 1.3 :-(
 	 */
 
