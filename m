Return-Path: <SRS0=pCwc=B7=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F5EAC433E3
	for <linux-rdma@archiver.kernel.org>; Fri, 21 Aug 2020 16:15:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0FA3922B43
	for <linux-rdma@archiver.kernel.org>; Fri, 21 Aug 2020 16:15:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1598026551;
	bh=7UJgrp8oLpFznfczBNjW/hayYKMwBDlwUKiE1REJQXU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=sC7/RWhO3FB63RCVh3UI9H0xX9wS71g3eq/5NGhAfoqiuCYtNE6WuAly4ApQCTSPz
	 B8V/4nCyk7WDP5QAwP0i2MfbaOZiPsNUrg9FcyZGcZ/14xDjiODrPLIShHJUbM3Bo7
	 CNz3xWfhd0YlxRQMA9u4VbXk6mE+LTr1Q7cmNakU=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727973AbgHUQPt (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Fri, 21 Aug 2020 12:15:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:48014 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727954AbgHUQPe (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Fri, 21 Aug 2020 12:15:34 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4E1DD22B43;
        Fri, 21 Aug 2020 16:15:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598026534;
        bh=7UJgrp8oLpFznfczBNjW/hayYKMwBDlwUKiE1REJQXU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wN5tzABLBp5NqAkdwiJmP6Mm4xBLmE52VuH54vPSTf0IeXLqlyV+/4dJ/JKCt5bZ5
         K8N4c86gkKAe+cidaFbkpB4GulvSSuomi7ncZs+7oTa3EgBEwCHvV4jpLTcSqtWtAw
         GGV1cN+U9UEtvA9EeEE3Lvl66Hj4VFrJ+T1acVrs=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Gal Pressman <galpress@amazon.com>,
        Shadi Ammouri <sammouri@amazon.com>,
        Yossi Leybovich <sleybo@amazon.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>, linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 5.8 55/62] RDMA/efa: Add EFA 0xefa1 PCI ID
Date:   Fri, 21 Aug 2020 12:14:16 -0400
Message-Id: <20200821161423.347071-55-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200821161423.347071-1-sashal@kernel.org>
References: <20200821161423.347071-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

From: Gal Pressman <galpress@amazon.com>

[ Upstream commit d4f9cb5c5b224dca3ff752c1bb854250bf114944 ]

Add support for 0xefa1 devices.

Link: https://lore.kernel.org/r/20200722140312.3651-5-galpress@amazon.com
Reviewed-by: Shadi Ammouri <sammouri@amazon.com>
Reviewed-by: Yossi Leybovich <sleybo@amazon.com>
Signed-off-by: Gal Pressman <galpress@amazon.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/efa/efa_main.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/efa/efa_main.c b/drivers/infiniband/hw/efa/efa_main.c
index 82145574c9286..92d7011463203 100644
--- a/drivers/infiniband/hw/efa/efa_main.c
+++ b/drivers/infiniband/hw/efa/efa_main.c
@@ -12,10 +12,12 @@
 
 #include "efa.h"
 
-#define PCI_DEV_ID_EFA_VF 0xefa0
+#define PCI_DEV_ID_EFA0_VF 0xefa0
+#define PCI_DEV_ID_EFA1_VF 0xefa1
 
 static const struct pci_device_id efa_pci_tbl[] = {
-	{ PCI_VDEVICE(AMAZON, PCI_DEV_ID_EFA_VF) },
+	{ PCI_VDEVICE(AMAZON, PCI_DEV_ID_EFA0_VF) },
+	{ PCI_VDEVICE(AMAZON, PCI_DEV_ID_EFA1_VF) },
 	{ }
 };
 
-- 
2.25.1

