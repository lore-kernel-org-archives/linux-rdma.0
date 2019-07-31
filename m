Return-Path: <SRS0=HDkz=V4=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42A12C433FF
	for <linux-rdma@archiver.kernel.org>; Wed, 31 Jul 2019 11:15:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 19FDD206B8
	for <linux-rdma@archiver.kernel.org>; Wed, 31 Jul 2019 11:15:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jNdMd136"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387461AbfGaLPh (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Wed, 31 Jul 2019 07:15:37 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:46693 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726607AbfGaLPh (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Wed, 31 Jul 2019 07:15:37 -0400
Received: by mail-wr1-f68.google.com with SMTP id z1so69199197wru.13
        for <linux-rdma@vger.kernel.org>; Wed, 31 Jul 2019 04:15:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=E9BPmTE+kOCXIh8/c7E+/PPwTMY3AF0O7t/3VOscjHQ=;
        b=jNdMd136Pr5K+mwt+bzNANR2cPQ3UzzCGpy96OHNQ+S23tVSs/d8CPo5S26Ozt7mn4
         ZHQcSpj1YbK30ceerW1EMR13oOxwuk2BjvOfnmLt/7Jl3wyyu3+X25Ic8SOioTPWavzQ
         DdlcpSANgoIoia88btWTswF82tLs/ouSRFJEBTdVdJdMkpN353Bw31OyenbMZYh4ELGa
         bMBUkVutVZDS44KQA4wtDig8ZnGHWZJyPDKUmRlGW7YFp0aWVQrKcghYEfeIskmhSzVV
         KbKf2aTSOcTeNWZ2gNFnyP80pZgi7OF1CZOs0ilwxQOlmMOMrIa9vVk85jyYnaNGsezk
         +2xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=E9BPmTE+kOCXIh8/c7E+/PPwTMY3AF0O7t/3VOscjHQ=;
        b=hIusCPCfeRK+8DadtoRjFHGr+DA2SkfRdxC6QXc9c6hJKeDbpLaEj6Zaqr+63xbca/
         mxzfYDm0EX16q8xqp1izrwKmZhPwFAuegYYo/cPyxVdKiQxBuc6ZoqEjECzmJjQjapY/
         zIkgrzSJVMcr8msAHuMp8TEiSJ6DmFguyiCofLcXASnw2MfuwVg+fkV5qHXmpR+/V+9e
         j+Lzj7IIOfb4EAvHQ/hwnKg710g9AZEq1t7qkYJFte6vIy3A3hvezI/FCElu521YebL3
         ANawgwwhomWhY3cfD3VtR/7Ixm2NwUDFlImGDCpY2FbImx9GdTwB04lk2VScbhRrGv0i
         Ln9A==
X-Gm-Message-State: APjAAAXFsz8zfZOvacDh2/T+Z+QLTV125fhodrguWONcTVK4ydsVXH5+
        G+Rxj+fGsWM+iONuVj3DSTD6Fw8t
X-Google-Smtp-Source: APXvYqyULjOGIDlKjT2Igvziin51MdqPJH/zUxo5MscHP5RTrie6g3q2UlLPHVOCbkKpjThg1FVaQg==
X-Received: by 2002:adf:80e1:: with SMTP id 88mr46880851wrl.127.1564571734020;
        Wed, 31 Jul 2019 04:15:34 -0700 (PDT)
Received: from kheib-workstation.redhat.com (bzq-109-65-15-211.red.bezeqint.net. [109.65.15.211])
        by smtp.gmail.com with ESMTPSA id h133sm73133732wme.28.2019.07.31.04.15.32
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 31 Jul 2019 04:15:33 -0700 (PDT)
From:   Kamal Heib <kamalheib1@gmail.com>
To:     linux-rdma@vger.kernel.org
Cc:     Jason Gunthorpe <jgg@ziepe.ca>, Doug Ledford <dledford@redhat.com>,
        Potnuri Bharat Teja <bharat@chelsio.com>,
        Selvin Xavier <selvin.xavier@broadcom.com>,
        Gal Pressman <galpress@amazon.com>,
        Leon Romanovsky <leon@kernel.org>,
        Michal Kalderon <mkalderon@marvell.com>,
        Christian Benvenuti <benve@cisco.com>,
        Moni Shoua <monis@mellanox.com>,
        Bernard Metzler <bmt@zurich.ibm.com>,
        Shiraz Saleem <shiraz.saleem@intel.com>,
        Kamal Heib <kamalheib1@gmail.com>
Subject: [PATCH for-next 4/4] RDMA/{cxgb3, cxgb4, i40iw}: Remove common code
Date:   Wed, 31 Jul 2019 14:15:03 +0300
Message-Id: <20190731111503.8872-5-kamalheib1@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190731111503.8872-1-kamalheib1@gmail.com>
References: <20190731111503.8872-1-kamalheib1@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

Now that we have a common iWARP query port function we can remove the
common code from the iWARP drivers.

Signed-off-by: Kamal Heib <kamalheib1@gmail.com>
---
 drivers/infiniband/hw/cxgb3/iwch_provider.c | 25 ---------------------
 drivers/infiniband/hw/cxgb4/provider.c      | 24 --------------------
 drivers/infiniband/hw/i40iw/i40iw_verbs.c   | 11 ---------
 3 files changed, 60 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb3/iwch_provider.c b/drivers/infiniband/hw/cxgb3/iwch_provider.c
index 5848e4727b2e..dcf02ec02810 100644
--- a/drivers/infiniband/hw/cxgb3/iwch_provider.c
+++ b/drivers/infiniband/hw/cxgb3/iwch_provider.c
@@ -991,33 +991,8 @@ static int iwch_query_device(struct ib_device *ibdev, struct ib_device_attr *pro
 static int iwch_query_port(struct ib_device *ibdev,
 			   u8 port, struct ib_port_attr *props)
 {
-	struct iwch_dev *dev;
-	struct net_device *netdev;
-	struct in_device *inetdev;
-
 	pr_debug("%s ibdev %p\n", __func__, ibdev);
 
-	dev = to_iwch_dev(ibdev);
-	netdev = dev->rdev.port_info.lldevs[port-1];
-
-	/* props being zeroed by the caller, avoid zeroing it here */
-	props->max_mtu = IB_MTU_4096;
-	props->active_mtu = ib_mtu_int_to_enum(netdev->mtu);
-
-	if (!netif_carrier_ok(netdev))
-		props->state = IB_PORT_DOWN;
-	else {
-		inetdev = in_dev_get(netdev);
-		if (inetdev) {
-			if (inetdev->ifa_list)
-				props->state = IB_PORT_ACTIVE;
-			else
-				props->state = IB_PORT_INIT;
-			in_dev_put(inetdev);
-		} else
-			props->state = IB_PORT_INIT;
-	}
-
 	props->port_cap_flags =
 	    IB_PORT_CM_SUP |
 	    IB_PORT_SNMP_TUNNEL_SUP |
diff --git a/drivers/infiniband/hw/cxgb4/provider.c b/drivers/infiniband/hw/cxgb4/provider.c
index 5e59c5708729..d373ac0fe2cb 100644
--- a/drivers/infiniband/hw/cxgb4/provider.c
+++ b/drivers/infiniband/hw/cxgb4/provider.c
@@ -305,32 +305,8 @@ static int c4iw_query_device(struct ib_device *ibdev, struct ib_device_attr *pro
 static int c4iw_query_port(struct ib_device *ibdev, u8 port,
 			   struct ib_port_attr *props)
 {
-	struct c4iw_dev *dev;
-	struct net_device *netdev;
-	struct in_device *inetdev;
-
 	pr_debug("ibdev %p\n", ibdev);
 
-	dev = to_c4iw_dev(ibdev);
-	netdev = dev->rdev.lldi.ports[port-1];
-	/* props being zeroed by the caller, avoid zeroing it here */
-	props->max_mtu = IB_MTU_4096;
-	props->active_mtu = ib_mtu_int_to_enum(netdev->mtu);
-
-	if (!netif_carrier_ok(netdev))
-		props->state = IB_PORT_DOWN;
-	else {
-		inetdev = in_dev_get(netdev);
-		if (inetdev) {
-			if (inetdev->ifa_list)
-				props->state = IB_PORT_ACTIVE;
-			else
-				props->state = IB_PORT_INIT;
-			in_dev_put(inetdev);
-		} else
-			props->state = IB_PORT_INIT;
-	}
-
 	props->port_cap_flags =
 	    IB_PORT_CM_SUP |
 	    IB_PORT_SNMP_TUNNEL_SUP |
diff --git a/drivers/infiniband/hw/i40iw/i40iw_verbs.c b/drivers/infiniband/hw/i40iw/i40iw_verbs.c
index d169a8031375..8056930bbe2c 100644
--- a/drivers/infiniband/hw/i40iw/i40iw_verbs.c
+++ b/drivers/infiniband/hw/i40iw/i40iw_verbs.c
@@ -97,18 +97,7 @@ static int i40iw_query_port(struct ib_device *ibdev,
 			    u8 port,
 			    struct ib_port_attr *props)
 {
-	struct i40iw_device *iwdev = to_iwdev(ibdev);
-	struct net_device *netdev = iwdev->netdev;
-
-	/* props being zeroed by the caller, avoid zeroing it here */
-	props->max_mtu = IB_MTU_4096;
-	props->active_mtu = ib_mtu_int_to_enum(netdev->mtu);
-
 	props->lid = 1;
-	if (netif_carrier_ok(iwdev->netdev))
-		props->state = IB_PORT_ACTIVE;
-	else
-		props->state = IB_PORT_DOWN;
 	props->port_cap_flags = IB_PORT_CM_SUP | IB_PORT_REINIT_SUP |
 		IB_PORT_VENDOR_CLASS_SUP | IB_PORT_BOOT_MGMT_SUP;
 	props->gid_tbl_len = 1;
-- 
2.20.1

