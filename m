Return-Path: <SRS0=QgBH=CC=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 562CEC433DF
	for <linux-rdma@archiver.kernel.org>; Mon, 24 Aug 2020 23:44:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2EA81207D3
	for <linux-rdma@archiver.kernel.org>; Mon, 24 Aug 2020 23:44:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EKbSv2ez"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726041AbgHXXo5 (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Mon, 24 Aug 2020 19:44:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725890AbgHXXo5 (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Mon, 24 Aug 2020 19:44:57 -0400
Received: from mail-qk1-x743.google.com (mail-qk1-x743.google.com [IPv6:2607:f8b0:4864:20::743])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1559C061574;
        Mon, 24 Aug 2020 16:44:56 -0700 (PDT)
Received: by mail-qk1-x743.google.com with SMTP id u3so9371025qkd.9;
        Mon, 24 Aug 2020 16:44:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Yn2Yu+Y39wzR1ajjDWLsKpLcyY/74xfHnDil+KAiO9E=;
        b=EKbSv2ez5CY3L5KU4c9PhpmsHm2AXEHfvfujFPxvy/+PtPqJbmN01TuRq7+Y1yFe2K
         39c/b3+BYHyKYspFKkV7suGHWsGt5q6we/vtEEqhZWBs9517pgCC+zQhaSgPlnexN8KR
         43K/1zw8FpwOo+jD8435wS6ujUu9TEwQpa5mzb9mFXuS0UYYcDQbGuHdTSQnZsr023Vw
         MDAyPNwN7QaBa4hYWIFRTMdgZCRAp89KoFRIK/JKFzaDvyT552WQrGAB4SK3/ZbjG0oW
         x5ZRBlCTV2OHLKi07DeiUUgv+NTOQmRT1bfl+OBJABh0xortXy5fCGYk+YVLhHz0O+EX
         fbZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Yn2Yu+Y39wzR1ajjDWLsKpLcyY/74xfHnDil+KAiO9E=;
        b=TeAZDWz8+O8VA43ayTUVOdpNLCcA92iFNGzQGjSRPrLwvRZKEUPToypE6iPTS1jZdJ
         LTmL6JtWAnn4ynshg6krYMP70L2rsdoF+MRN8Cic338E20M3JOZpZyVkzyFGNrUR580B
         WFSpB+Uf36KtCSsbhLV8Fqzn73GI5K6wkzujsAps20F+Dh6e+7L34EcJQAZYYgEtpgJE
         7yTK+hVLpvkjzcVn8qpXiZhwmuH/5HK2tvmw2mAkE24U09pHa2HpFxYeLna+erYYYJ5V
         YKupdS/EX7Yu2JpJKrB0fSvXcAjRII48nfq54upMZYahCQ5KQ+5usbbLcuNxgx88C2Lw
         mFWg==
X-Gm-Message-State: AOAM530Ao3JwdV9VtrwD8GljYG6Eg4i9Ls3L36ZGUPY1nzDQXCne6R/K
        hVFrN7cuqhpbxjc23LDMmWU=
X-Google-Smtp-Source: ABdhPJw1ZEHlQzxL4e/HKfjBf0rF7TcfUaa7MeVedcIG5cnZZTGf9cMpKpoGbUHndA2UBn8ya59yUw==
X-Received: by 2002:a05:620a:1361:: with SMTP id d1mr6718838qkl.387.1598312696196;
        Mon, 24 Aug 2020 16:44:56 -0700 (PDT)
Received: from tong-desktop.local ([2601:5c0:c100:b9d:e9aa:e42d:21e4:5150])
        by smtp.googlemail.com with ESMTPSA id y24sm12018127qtv.71.2020.08.24.16.44.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Aug 2020 16:44:55 -0700 (PDT)
From:   Tong Zhang <ztong0001@gmail.com>
To:     selvin.xavier@broadcom.com, devesh.sharma@broadcom.com,
        dledford@redhat.com, jgg@ziepe.ca, kamalheib1@gmail.com,
        leon@kernel.org, maxg@mellanox.com, monis@mellanox.com,
        ztong0001@gmail.com, gustavoars@kernel.org, galpress@amazon.com,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Bernard Metzler <bmt@zurich.ibm.com>
Subject: [PATCH] RDMA: error code handling
Date:   Mon, 24 Aug 2020 19:44:21 -0400
Message-Id: <20200824234422.1261394-1-ztong0001@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

ocrdma_qp_state_change() returns 1 when new and old state are the same,
however caller is checking using <0

Signed-off-by: Tong Zhang <ztong0001@gmail.com>
---
 drivers/infiniband/hw/ocrdma/ocrdma_verbs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
index c1751c9a0f62..518687c5e2cb 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
@@ -1384,7 +1384,7 @@ int _ocrdma_modify_qp(struct ib_qp *ibqp, struct ib_qp_attr *attr,
 	/* if new and previous states are same hw doesn't need to
 	 * know about it.
 	 */
-	if (status < 0)
+	if (status == 1)
 		return status;
 	return ocrdma_mbx_modify_qp(dev, qp, attr, attr_mask);
 }
-- 
2.25.1

