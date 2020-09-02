Return-Path: <SRS0=RpEd=CL=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26059C433E7
	for <linux-rdma@archiver.kernel.org>; Wed,  2 Sep 2020 12:43:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 02F5B20767
	for <linux-rdma@archiver.kernel.org>; Wed,  2 Sep 2020 12:43:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dqbDVQiK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726913AbgIBMnY (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Wed, 2 Sep 2020 08:43:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726742AbgIBMnX (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Wed, 2 Sep 2020 08:43:23 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0BF1C061246
        for <linux-rdma@vger.kernel.org>; Wed,  2 Sep 2020 05:43:14 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id c19so3092139wmd.1
        for <linux-rdma@vger.kernel.org>; Wed, 02 Sep 2020 05:43:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=TrGDJvAlorRFRcU7x0zQCgPQu13HZ8Yguy41QHc9Lss=;
        b=dqbDVQiKSV/7Mo4+l/GQiuu22kSAJNk78eFieqR1h7YVT2Tgb4omaa5WessVgsglRH
         2M9xDKFESoUvHmZ5aqndr3lFR51DdrEtUbH2NeUKLKNgj9TP/OBk10LkdnvdLLreYnWG
         0P//uWmhwA+mNo5e2hT7e7JkxfImKIMFzIEDYp3/c/dmKgL6i8E2SjGhfOqDm9OjdNwo
         c+3XhE3wrDCWBPhnwRXZBQXn1VXkZMQK+pOh3arRwaNy0jJLaZ1b1bVfVa6+oLGQGS38
         B8aUpUBcU6NFw0mFlsDakmgZVqgJfVs78X2d2F+he+fKAzzZJ0VAv+PcEfTjl9lymNgl
         AzfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=TrGDJvAlorRFRcU7x0zQCgPQu13HZ8Yguy41QHc9Lss=;
        b=IY9+Kq/rB52CVSz1FUNMcKKU+2/UoZzV0ZuP+Sf2OCS5dqXXNcr9lSJ7HRUCIGCAx8
         WT/U7nBuWyjFVpNQwQkn2LuPWARFdG6jHsPYvdqzt8YOvCP++G0I+UtrNRAaxZw2burU
         g4qfgXtLEjVxB0V919+dYjntx7H9CcnmZUyl4QqRhbi4jsecBz5OLd0wsLel1C59nkL3
         JPaffpNMqn91jknW82WRUX5nyreyFE0dkjriRdcSDfXpTpYAgDPcurqzUKVqSfFFiqVL
         nM9jx0AKl7kmqL8ow8SoFXvu5rpcd259+/v03gbLW3knSKGdj9Z8Wb2c9BcbnvTIvxBr
         FcIQ==
X-Gm-Message-State: AOAM533VEX9hTlITEbt/svlAzpXkc6hBMJKGDBtoGdMV9+5dnOBdHUa5
        hlvdJLeHrLjosfUmYPo2xcskRD5hzm8=
X-Google-Smtp-Source: ABdhPJwbRPLse/kPJTP6auH9IWF83nemIIZY/gu1t90o1ZDcvUwY3l8jcxloEJveMz7PqbsHwVWvPg==
X-Received: by 2002:a7b:c769:: with SMTP id x9mr504816wmk.65.1599050593197;
        Wed, 02 Sep 2020 05:43:13 -0700 (PDT)
Received: from kheib-workstation.redhat.com ([37.142.0.228])
        by smtp.gmail.com with ESMTPSA id r3sm7200262wro.1.2020.09.02.05.43.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Sep 2020 05:43:12 -0700 (PDT)
From:   Kamal Heib <kamalheib1@gmail.com>
To:     linux-rdma@vger.kernel.org
Cc:     Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>,
        Kamal Heib <kamalheib1@gmail.com>
Subject: [PATCH for-rc] RDMA/core: Fix reported speed and width
Date:   Wed,  2 Sep 2020 15:43:04 +0300
Message-Id: <20200902124304.170912-1-kamalheib1@gmail.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

When the returned speed from __ethtool_get_link_ksettings() is
SPEED_UNKNOWN this will lead to reporting a wrong speed and width for
providers that uses ib_get_eth_speed(), fix that by defaulting the
netdev_speed to SPEED_1000 in case the returned value from
__ethtool_get_link_ksettings() is SPEED_UNKNOWN.

Fixes: d41861942fc5 ("IB/core: Add generic function to extract IB speed from netdev")
Signed-off-by: Kamal Heib <kamalheib1@gmail.com>
---
 drivers/infiniband/core/verbs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/core/verbs.c
index 3096e73797b7..307886737646 100644
--- a/drivers/infiniband/core/verbs.c
+++ b/drivers/infiniband/core/verbs.c
@@ -1801,7 +1801,7 @@ int ib_get_eth_speed(struct ib_device *dev, u8 port_num, u8 *speed, u8 *width)
 
 	dev_put(netdev);
 
-	if (!rc) {
+	if (!rc && lksettings.base.speed != (u32)SPEED_UNKNOWN) {
 		netdev_speed = lksettings.base.speed;
 	} else {
 		netdev_speed = SPEED_1000;
-- 
2.26.2

