Return-Path: <linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 287BFC4338F
	for <linux-rdma@archiver.kernel.org>; Wed, 11 Aug 2021 12:34:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 02E5760FE6
	for <linux-rdma@archiver.kernel.org>; Wed, 11 Aug 2021 12:34:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230178AbhHKMfB (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Wed, 11 Aug 2021 08:35:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230224AbhHKMe4 (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Wed, 11 Aug 2021 08:34:56 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E8AFC0617A3;
        Wed, 11 Aug 2021 05:34:33 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id fa24-20020a17090af0d8b0290178bfa69d97so4646715pjb.0;
        Wed, 11 Aug 2021 05:34:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=5FijFRuNeIw6uFkos7dxaelXYoxcJOgS14al3RfG1Bg=;
        b=TegwMQKVI9K85UhYMUKjCyzLz28KcF26BhRV+36pk0SRypogkvU9PhnbRPxrv/tvr+
         VCheCqP9VLIIzKHPtDGvO530luOKJrErpfBrjOEl4c0hLLb/PeNt31lQ/LzY48nTQ8+w
         w/cQdXFrBNfo7dKRpBEVdfE1+59++1drGGdxX1+HE01bWK90raz4Kp/koTNE/YNCYDMQ
         6QyFz8wwjTfSq5cow8W9hYMvtdFZbsyMoYT6jQ5AnvIhsO5hfuCphkJ0mhfUzXw50TFK
         jJ2HMPR2Xo2S1SRLCyRWZYYXj+mZDHey6a1kOr8bJiiJm6v0IYAm6QPBAwYzROjndwKb
         nI5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=5FijFRuNeIw6uFkos7dxaelXYoxcJOgS14al3RfG1Bg=;
        b=dptI5x74oB1x9nwjtcKEfq77ps1GOwGfSyaCWTlUlAGlc1LBmBnTpM9gioXMVYy1sa
         YUJW7a9r1jIUlubHxoYr9k1LzpvVBK+9iCPSqE4K3Th9Bhl0tMUiH2afrLzZYsPOwFRy
         FB8HjJs+Kt/tBsWQSPwA1juHMib98A8BDcN5xHYkcvnoBcJUzuhfCO3COFoVwXSujhDB
         NnCCBxEP6ijqVQYBoKIEuqjye2NFUqEJDBeZdqQvoPCvJJb75Z65O6becG9f084AtzPq
         vu+R+THh1sd5YoDNyz1knfdXfNd13ngt8k/BFY6EtNK8j2HxuJx8yxE63KtOt8kDcl5b
         J+mw==
X-Gm-Message-State: AOAM531zO1LM53KksxVZqfXMeX7aFQz1vKqdTO5ldCf/v6MAvfCxDcEq
        vtL7ArMwe45mLpbNt/NMn1L7nv+DPyjnwMjz
X-Google-Smtp-Source: ABdhPJwCiveTQ7Y0cdhTfOEp7qyYjpD7aEssGdTlbw28Jc6Qdp7VfgPNLTpprSNT2+urVj5swAotug==
X-Received: by 2002:a17:90a:2a8e:: with SMTP id j14mr10375833pjd.208.1628685272647;
        Wed, 11 Aug 2021 05:34:32 -0700 (PDT)
Received: from localhost.localdomain ([45.135.186.103])
        by smtp.gmail.com with ESMTPSA id k6sm12466039pjj.52.2021.08.11.05.34.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Aug 2021 05:34:32 -0700 (PDT)
From:   Tuo Li <islituo@gmail.com>
To:     dledford@redhat.com, jgg@ziepe.ca
Cc:     linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
        baijiaju1990@gmail.com, Tuo Li <islituo@gmail.com>,
        TOTE Robot <oslab@tsinghua.edu.cn>
Subject: [PATCH] IB/mthca: Fix possible uninitialized-variable access in mthca_SYS_EN()
Date:   Wed, 11 Aug 2021 05:34:15 -0700
Message-Id: <20210811123415.8200-1-islituo@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

The variable out is declared without initialization, and its address is 
passed to mthca_cmd_imm():
  ret = mthca_cmd_imm(dev, 0, &out, 0, 0, CMD_SYS_EN, CMD_TIME_CLASS_D);

In this function, mthca_cmd_wait() or mthca_cmd_poll() will be called with 
the argument out_param, which is the address of the varialbe out. In these 
two called functions, mthca_cmd_post() will be called with *out_param, 
whose value comes from the uninitialized variable out.
  err = mthca_cmd_post(dev, in_param, out_param ? *out_param : 0, ...)

In mthca_cmd_post(), mthca_cmd_post_dbell() or mthca_cmd_post_hcr() will 
be called, in which the value from the uninitialized varialble out may be
used:
  __raw_writel((__force u32) cpu_to_be32(out_param >> 32), ptr + offs[3]);

To fix this possible uninitialized-variable access, initialized out to 0 
at the begining of mthca_SYS_EN().

Reported-by: TOTE Robot <oslab@tsinghua.edu.cn>
Signed-off-by: Tuo Li <islituo@gmail.com>
---
 drivers/infiniband/hw/mthca/mthca_cmd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/mthca/mthca_cmd.c b/drivers/infiniband/hw/mthca/mthca_cmd.c
index bdf5ed38de22..86584982e496 100644
--- a/drivers/infiniband/hw/mthca/mthca_cmd.c
+++ b/drivers/infiniband/hw/mthca/mthca_cmd.c
@@ -635,7 +635,7 @@ void mthca_free_mailbox(struct mthca_dev *dev, struct mthca_mailbox *mailbox)
 
 int mthca_SYS_EN(struct mthca_dev *dev)
 {
-	u64 out;
+	u64 out = 0;
 	int ret;
 
 	ret = mthca_cmd_imm(dev, 0, &out, 0, 0, CMD_SYS_EN, CMD_TIME_CLASS_D);
-- 
2.25.1

