Return-Path: <SRS0=pr8h=4B=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A90EC2BA83
	for <linux-rdma@archiver.kernel.org>; Thu, 13 Feb 2020 13:07:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CF6F4218AC
	for <linux-rdma@archiver.kernel.org>; Thu, 13 Feb 2020 13:07:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Brxw7250"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729855AbgBMNHT (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Thu, 13 Feb 2020 08:07:19 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:41014 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729572AbgBMNHT (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Thu, 13 Feb 2020 08:07:19 -0500
Received: by mail-wr1-f68.google.com with SMTP id c9so6594957wrw.8
        for <linux-rdma@vger.kernel.org>; Thu, 13 Feb 2020 05:07:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=33YeHp5qjts49g7mlCCDlJIEshOHQQWNs0BLQ39qol8=;
        b=Brxw72504KqdKM1JNuGvEgrfbzCvsdkdvhokNkzM12T3bW2ofD4GzP1P2f2xD8L2Z3
         E6GgXLehfCA/zRptvIbWlb3Ea8FsbpNUQgwgUmFhyHgbmrNzLMatizhJrKs+O3WkbwxD
         7fYjsfpiRFQ74svFyzqnmR7/J83SHoBTbgzTHWz9adz8ezxcrVMB5ctI4JSsrlugIDhJ
         8bOh604g1NgUqNubjqTrqBTGTOyNuByEHqRrnXRgid2JpbvzdS0rYh2I0+CAYpttw1vI
         ZerW4mf0rdpx0g4YN2MhkUmJtuH6XVCDe8j+ZBk2+TErXvZlR3IR9+WegbvRZaeMvmnV
         6ydQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=33YeHp5qjts49g7mlCCDlJIEshOHQQWNs0BLQ39qol8=;
        b=g0nOsDvTkmCdBH173auq60u/hIVszcau+2toUjBmfGxZ4h6V/2pEDb7Hx+ypriMOuW
         P1C567t862MZJpXrek66sClyp/Yx2wYIzh7I99hk53lVBIjf9/gjkJqKDIafZ4fO8LPh
         RBrK8/CnKaR7Goc7LGoXi/4zRY8dE5m6kWp1f0X7lHScC1FKGg32pTuZOb5dwkoILjXa
         8RqRzNLCdDqNvHI497hU+iEfG4y9ARAc/7bXiLYDfTBJgQde2gc64magQEp251/o751M
         L5nZC3u/FComUqj+rDLt6ufsf5rqyhI8/JrZ/jg0Mi+7svEuxl/Uvw33zmj7+0HpEaIg
         Pqsw==
X-Gm-Message-State: APjAAAWzPV4afoExtdUxvwdbloeGT3FsMi9AvTZgMx1xUubIHGNSutTv
        6Wo/GiT/1neWM/LUY2ETRcCdcaa/wgI=
X-Google-Smtp-Source: APXvYqwvbHcl5soD3hLvLIUTbdhn6CjUs/DiCojBvmdfShXO8/eSBp+o0xtqQUQgCsCxDRvCLIFxnQ==
X-Received: by 2002:a5d:4a04:: with SMTP id m4mr21975945wrq.104.1581599236741;
        Thu, 13 Feb 2020 05:07:16 -0800 (PST)
Received: from kheib-workstation.redhat.com (bzq-79-179-106-48.red.bezeqint.net. [79.179.106.48])
        by smtp.gmail.com with ESMTPSA id u8sm3004319wmm.15.2020.02.13.05.07.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Feb 2020 05:07:15 -0800 (PST)
From:   Kamal Heib <kamalheib1@gmail.com>
To:     linux-rdma@vger.kernel.org
Cc:     Jason Gunthorpe <jgg@ziepe.ca>, Doug Ledford <dledford@redhat.com>,
        Bernard Metzler <bmt@zurich.ibm.com>,
        Kamal Heib <kamalheib1@gmail.com>
Subject: [PATH for-next] RDMA/siw: Fix setting active_{speed, width} attributes
Date:   Thu, 13 Feb 2020 15:07:01 +0200
Message-Id: <20200213130701.11589-1-kamalheib1@gmail.com>
X-Mailer: git-send-email 2.21.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

Make sure to set the active_{speed, width} attributes to avoid reporting
the same values regardless of the underlying device.

Fixes: 303ae1cdfdf7 ("rdma/siw: application interface")
Signed-off-by: Kamal Heib <kamalheib1@gmail.com>
---
 drivers/infiniband/sw/siw/siw_verbs.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/sw/siw/siw_verbs.c b/drivers/infiniband/sw/siw/siw_verbs.c
index 73485d0da907..b1aaec912edb 100644
--- a/drivers/infiniband/sw/siw/siw_verbs.c
+++ b/drivers/infiniband/sw/siw/siw_verbs.c
@@ -165,11 +165,12 @@ int siw_query_port(struct ib_device *base_dev, u8 port,
 		   struct ib_port_attr *attr)
 {
 	struct siw_device *sdev = to_siw_dev(base_dev);
+	int rc;
 
 	memset(attr, 0, sizeof(*attr));
 
-	attr->active_speed = 2;
-	attr->active_width = 2;
+	rc = ib_get_eth_speed(base_dev, port, &attr->active_speed,
+			 &attr->active_width);
 	attr->gid_tbl_len = 1;
 	attr->max_msg_sz = -1;
 	attr->max_mtu = ib_mtu_int_to_enum(sdev->netdev->mtu);
@@ -192,7 +193,7 @@ int siw_query_port(struct ib_device *base_dev, u8 port,
 	 * attr->subnet_timeout = 0;
 	 * attr->init_type_repy = 0;
 	 */
-	return 0;
+	return rc;
 }
 
 int siw_get_port_immutable(struct ib_device *base_dev, u8 port,
-- 
2.21.1

