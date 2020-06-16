Return-Path: <SRS0=8Neo=75=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2685C433DF
	for <linux-rdma@archiver.kernel.org>; Tue, 16 Jun 2020 10:58:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C05FC2078E
	for <linux-rdma@archiver.kernel.org>; Tue, 16 Jun 2020 10:58:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1592305109;
	bh=dbjcsyelM+YIGy3/tBnfYnaHL+fcVDLLoR7VPqUboNo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=QNnPwPFjNASuWih73yeDGJRrwY0lMMtORJjUr/jflza8ven/ZrC/j3mZlDdvc01A2
	 v1vL1luLIvRvTKcEb79+z9xRiS0xxr1+D71cSImEfcSF3ui1j+CqJalQrGpwyFFOiW
	 hzatUvpK3FZEUNI0FjHoRifUTFvCMWAaHHgLEWbU=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727773AbgFPK62 (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Tue, 16 Jun 2020 06:58:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:37594 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725775AbgFPK61 (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Tue, 16 Jun 2020 06:58:27 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6E92C20786;
        Tue, 16 Jun 2020 10:58:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592305107;
        bh=dbjcsyelM+YIGy3/tBnfYnaHL+fcVDLLoR7VPqUboNo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=R9DcxoRRU1I9sP5FobiEtdX8r80G1IH3y0b39/S7nQORG1sNW1QjE/WTbdqrPIwaS
         HQynwTjpk0R1kGBOMhYP6Sv0ZA4dfLK0Vzq/uRrJ/wEIJCMCCxTo1EoR2IlluZO12r
         mvg/EMm+y5s2yF2JYlR0qoYAHuxjlooUnYjVQQHo=
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Cc:     Yishai Hadas <yishaih@mellanox.com>, linux-rdma@vger.kernel.org
Subject: [PATCH rdma-next 1/7] IB/uverbs: Enable CQ ioctl commands by default
Date:   Tue, 16 Jun 2020 13:55:25 +0300
Message-Id: <20200616105531.2428010-2-leon@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200616105531.2428010-1-leon@kernel.org>
References: <20200616105531.2428010-1-leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

From: Yishai Hadas <yishaih@mellanox.com>

Enable CQ ioctl commands by default, this functionality is fully mature
to be used over ioctl, no reason to maintain any more the EXP KCONFIG
entry to enable it.

Signed-off-by: Yishai Hadas <yishaih@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/infiniband/Kconfig                    | 8 --------
 drivers/infiniband/core/uverbs_std_types_cq.c | 3 ---
 2 files changed, 11 deletions(-)

diff --git a/drivers/infiniband/Kconfig b/drivers/infiniband/Kconfig
index a83f9eb86bfe..91b023341b77 100644
--- a/drivers/infiniband/Kconfig
+++ b/drivers/infiniband/Kconfig
@@ -37,14 +37,6 @@ config INFINIBAND_USER_ACCESS
 	  libibverbs, libibcm and a hardware driver library from
 	  rdma-core <https://github.com/linux-rdma/rdma-core>.
 
-config INFINIBAND_EXP_LEGACY_VERBS_NEW_UAPI
-	bool "Allow experimental legacy verbs in new ioctl uAPI  (EXPERIMENTAL)"
-	depends on INFINIBAND_USER_ACCESS
-	help
-	  IOCTL based uAPI support for Infiniband is enabled by default for
-	  new verbs only. This allows userspace to invoke the IOCTL based uAPI
-	  for current legacy verbs too.
-
 config INFINIBAND_USER_MEM
 	bool
 	depends on INFINIBAND_USER_ACCESS != n
diff --git a/drivers/infiniband/core/uverbs_std_types_cq.c b/drivers/infiniband/core/uverbs_std_types_cq.c
index 5dce2c7cc323..b1c7dacc02de 100644
--- a/drivers/infiniband/core/uverbs_std_types_cq.c
+++ b/drivers/infiniband/core/uverbs_std_types_cq.c
@@ -207,11 +207,8 @@ DECLARE_UVERBS_NAMED_METHOD(
 DECLARE_UVERBS_NAMED_OBJECT(
 	UVERBS_OBJECT_CQ,
 	UVERBS_TYPE_ALLOC_IDR_SZ(sizeof(struct ib_ucq_object), uverbs_free_cq),
-
-#if IS_ENABLED(CONFIG_INFINIBAND_EXP_LEGACY_VERBS_NEW_UAPI)
 	&UVERBS_METHOD(UVERBS_METHOD_CQ_CREATE),
 	&UVERBS_METHOD(UVERBS_METHOD_CQ_DESTROY)
-#endif
 );
 
 const struct uapi_definition uverbs_def_obj_cq[] = {
-- 
2.26.2

