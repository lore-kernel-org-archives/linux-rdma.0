Return-Path: <SRS0=OzSu=AE=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E422C433E0
	for <linux-rdma@archiver.kernel.org>; Tue, 23 Jun 2020 10:53:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 37FB620771
	for <linux-rdma@archiver.kernel.org>; Tue, 23 Jun 2020 10:53:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DUn5K4yj"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732286AbgFWKxC (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Tue, 23 Jun 2020 06:53:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732276AbgFWKxC (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Tue, 23 Jun 2020 06:53:02 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5D65C061573
        for <linux-rdma@vger.kernel.org>; Tue, 23 Jun 2020 03:53:01 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id s10so63363wrw.12
        for <linux-rdma@vger.kernel.org>; Tue, 23 Jun 2020 03:53:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=cRcbJd4ujZgh3NkmWmfWq75i3/RuToC2p3O9U9UqanE=;
        b=DUn5K4yjkRaG9p0gJSjMRKtMuSiJU+NA/Nr6phfIvM2bn6eOnlxEkuhGq16dl/Cvxa
         kxR9AZ3LYgTNROj0+3C+a/LFkGYn9699GfNEWDvFiekRBG11HnUq0eOp/rUn/pLA1lIB
         cF0VPVg+nJBCqjtLesYbbH2JPw3w76Y1UpHaaXxuuGXo+xNPUuH6CuNlrEX2j3HhWjEL
         8LcEDqnjPKlEFdPh0nEgdkgetDimieDDUUlwosk6KgAjanM8A3P9oS2PH2o61A4J8M93
         n83uMNhvgmTd+lkeUaTDKglhdFE+54H6mlU4MQtagK4LQilUzGU87NIHMUdurt/DoazQ
         ISpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=cRcbJd4ujZgh3NkmWmfWq75i3/RuToC2p3O9U9UqanE=;
        b=jZVy1gLwEitUE3u8rZcgTEvEM4ym5j87K3Fd45QBEXTkEUhPHzNvPbeDO3X5YNjjqy
         xEpGUkIfoDvWLK2w0wXtEPRcXsyv0SRDapDX+brqw2mwtK8rQ+FIo3kbAMh/9eZnDOUs
         bNZpnSKUXM08b4euDQbRBEsGrq1VbiHLnSFTeDyTwKfqqehNFnHMLCJj/D1eXYbJyvx9
         TW+A+X1qhpTwYogLdYWBFFSErgI6+c0zZLfIdoKF6usQQQMEcRij8c/tvs4YAD4njIUt
         Lxbtcl68T9jrBzw8zUer0laYQLmO9Fcg/xKqERvFJZ57d9rd1GVQZroJMZ1zUTiS4jKc
         9CSQ==
X-Gm-Message-State: AOAM5312o5f8YzaO8XzIf0eHyy0pp+QVM+aR42LElJf3hHL6BGX3WLZ2
        N2WmT0P9TfWPdbTRXeuw4wcjOS3F
X-Google-Smtp-Source: ABdhPJyQMz9QRDd8NyLz1HjIcXufI4Rp1Szu9Yy372h287LQQa0qdfF6wxmDFWWtmK433EBb376X/A==
X-Received: by 2002:a5d:5084:: with SMTP id a4mr25076319wrt.416.1592909580393;
        Tue, 23 Jun 2020 03:53:00 -0700 (PDT)
Received: from kheib-workstation.redhat.com ([37.142.6.100])
        by smtp.gmail.com with ESMTPSA id v4sm6971085wro.26.2020.06.23.03.52.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Jun 2020 03:52:59 -0700 (PDT)
From:   Kamal Heib <kamalheib1@gmail.com>
To:     linux-rdma@vger.kernel.org
Cc:     Jason Gunthorpe <jgg@ziepe.ca>, Doug Ledford <dledford@redhat.com>,
        Kamal Heib <kamalheib1@gmail.com>
Subject: [PATCH for-next] RDMA/ipoib: Return void from ipoib_ib_dev_stop()
Date:   Tue, 23 Jun 2020 13:52:36 +0300
Message-Id: <20200623105236.18683-1-kamalheib1@gmail.com>
X-Mailer: git-send-email 2.25.4
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

The return value from ipoib_ib_dev_stop() is always 0 - change it
to be void.

Signed-off-by: Kamal Heib <kamalheib1@gmail.com>
---
 drivers/infiniband/ulp/ipoib/ipoib.h    | 2 +-
 drivers/infiniband/ulp/ipoib/ipoib_ib.c | 4 +---
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/ulp/ipoib/ipoib.h b/drivers/infiniband/ulp/ipoib/ipoib.h
index 15f519ce7e0b..3440dc48d02c 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib.h
+++ b/drivers/infiniband/ulp/ipoib/ipoib.h
@@ -515,7 +515,7 @@ void ipoib_ib_dev_cleanup(struct net_device *dev);
 
 int ipoib_ib_dev_open_default(struct net_device *dev);
 int ipoib_ib_dev_open(struct net_device *dev);
-int ipoib_ib_dev_stop(struct net_device *dev);
+void ipoib_ib_dev_stop(struct net_device *dev);
 void ipoib_ib_dev_up(struct net_device *dev);
 void ipoib_ib_dev_down(struct net_device *dev);
 int ipoib_ib_dev_stop_default(struct net_device *dev);
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_ib.c b/drivers/infiniband/ulp/ipoib/ipoib_ib.c
index da3c5315bbb5..6ee64c25aaff 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_ib.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_ib.c
@@ -846,7 +846,7 @@ int ipoib_ib_dev_stop_default(struct net_device *dev)
 	return 0;
 }
 
-int ipoib_ib_dev_stop(struct net_device *dev)
+void ipoib_ib_dev_stop(struct net_device *dev)
 {
 	struct ipoib_dev_priv *priv = ipoib_priv(dev);
 
@@ -854,8 +854,6 @@ int ipoib_ib_dev_stop(struct net_device *dev)
 
 	clear_bit(IPOIB_FLAG_INITIALIZED, &priv->flags);
 	ipoib_flush_ah(dev);
-
-	return 0;
 }
 
 int ipoib_ib_dev_open_default(struct net_device *dev)
-- 
2.25.4

