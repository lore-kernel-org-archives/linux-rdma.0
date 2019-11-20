Return-Path: <SRS0=BqF5=ZM=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39CF2C432C3
	for <linux-rdma@archiver.kernel.org>; Wed, 20 Nov 2019 13:41:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 12C092251E
	for <linux-rdma@archiver.kernel.org>; Wed, 20 Nov 2019 13:41:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1574257306;
	bh=ZMgoqe1m6dhLpCE3gZ+ZFrLAgyoH4bnVDt9i/egjBVw=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=1CsWXXedarTUk+MALq1INiEYFQT2qfYltA8UaQ5cPaow+Fg78+NyZ44y6sybL5fbo
	 QLlbkZcga+yiK5g3ez0b+llY3uiE7Shlw2q2RLzquGluR/GaUwAKdVFsjEZJfpRxxm
	 y3BXOpPxy2sJH2XXK/ZZHisPoNoeE3OjKDiAsx3s=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729228AbfKTNlo (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Wed, 20 Nov 2019 08:41:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:49474 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730431AbfKTNlo (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Wed, 20 Nov 2019 08:41:44 -0500
Received: from localhost.localdomain (unknown [118.189.143.39])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 83621224D0;
        Wed, 20 Nov 2019 13:41:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574257303;
        bh=ZMgoqe1m6dhLpCE3gZ+ZFrLAgyoH4bnVDt9i/egjBVw=;
        h=From:To:Cc:Subject:Date:From;
        b=y4iey/GBszOVOu1i5C5rzcnKurGDrFOmt9Ov8S284RKiRttv6cKrkPZWu2e0ZzEa/
         DO/OJLntjxialVvGSC3LsIYxgf4Tyidxmhi4VYDsGxmr83aP5DLqceguLfl0ZrdJC3
         Z47q4xv5MjkHQLOYsJNvLKsRcUJGOZSHvFK3LyQo=
From:   Krzysztof Kozlowski <krzk@kernel.org>
To:     linux-kernel@vger.kernel.org
Cc:     Krzysztof Kozlowski <krzk@kernel.org>,
        Selvin Xavier <selvin.xavier@broadcom.com>,
        Devesh Sharma <devesh.sharma@broadcom.com>,
        Somnath Kotur <somnath.kotur@broadcom.com>,
        Sriharsha Basavapatna <sriharsha.basavapatna@broadcom.com>,
        Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>, linux-rdma@vger.kernel.org
Subject: [PATCH] infiniband: Fix Kconfig indentation
Date:   Wed, 20 Nov 2019 21:41:38 +0800
Message-Id: <20191120134138.15245-1-krzk@kernel.org>
X-Mailer: git-send-email 2.17.1
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

Adjust indentation from spaces to tab (+optional two spaces) as in
coding style with command like:
	$ sed -e 's/^        /\t/' -i */Kconfig

Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
---
 drivers/infiniband/hw/bnxt_re/Kconfig | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/infiniband/hw/bnxt_re/Kconfig b/drivers/infiniband/hw/bnxt_re/Kconfig
index ab8779d23382..b83f1cc38c52 100644
--- a/drivers/infiniband/hw/bnxt_re/Kconfig
+++ b/drivers/infiniband/hw/bnxt_re/Kconfig
@@ -1,11 +1,11 @@
 # SPDX-License-Identifier: GPL-2.0-only
 config INFINIBAND_BNXT_RE
-        tristate "Broadcom Netxtreme HCA support"
-        depends on 64BIT
-        depends on ETHERNET && NETDEVICES && PCI && INET && DCB
-        select NET_VENDOR_BROADCOM
-        select BNXT
-        ---help---
+	tristate "Broadcom Netxtreme HCA support"
+	depends on 64BIT
+	depends on ETHERNET && NETDEVICES && PCI && INET && DCB
+	select NET_VENDOR_BROADCOM
+	select BNXT
+	---help---
 	  This driver supports Broadcom NetXtreme-E 10/25/40/50 gigabit
 	  RoCE HCAs.  To compile this driver as a module, choose M here:
 	  the module will be called bnxt_re.
-- 
2.17.1

