Return-Path: <linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 061EBC4338F
	for <linux-rdma@archiver.kernel.org>; Wed, 18 Aug 2021 20:57:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D9A796102A
	for <linux-rdma@archiver.kernel.org>; Wed, 18 Aug 2021 20:57:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233792AbhHRU6R (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Wed, 18 Aug 2021 16:58:17 -0400
Received: from saphodev.broadcom.com ([192.19.11.229]:41450 "EHLO
        relay.smtp-ext.broadcom.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233338AbhHRU6Q (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>);
        Wed, 18 Aug 2021 16:58:16 -0400
Received: from dhcp-10-192-206-197.iig.avagotech.net.net (dhcp-10-123-156-118.dhcp.broadcom.net [10.123.156.118])
        by relay.smtp-ext.broadcom.com (Postfix) with ESMTP id A5A80A5;
        Wed, 18 Aug 2021 13:57:39 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 relay.smtp-ext.broadcom.com A5A80A5
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=broadcom.com;
        s=dkimrelay; t=1629320260;
        bh=XbCQXY+TiXqO/sahzdQKPOsNbBv9IKxx4SeRQq3HKXc=;
        h=From:To:Cc:Subject:Date:From;
        b=CH7t4vEeM3PGORALFH3z/yYTnj0xxTrBYOgNjhj9Z1QgINpBcozhII5kcFMtwAdvt
         kK0VHebLpsPJPFPys1ia8JZq9sgRaK11UhN6SNAF1RdbEeLUbiKr8slSWdPGYsfk02
         /a3uecSzt+rymLvl2AJeT4evNMJimzGOgnb4xXow=
From:   Selvin Xavier <selvin.xavier@broadcom.com>
To:     jgg@ziepe.ca, dledford@redhat.com
Cc:     linux-rdma@vger.kernel.org,
        Selvin Xavier <selvin.xavier@broadcom.com>
Subject: [PATCH rdma-rc 0/3] RDMA/bnxt_re: Bug fixes
Date:   Wed, 18 Aug 2021 13:57:33 -0700
Message-Id: <1629320256-4034-1-git-send-email-selvin.xavier@broadcom.com>
X-Mailer: git-send-email 2.5.5
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

Some simple bug fixes

Naresh Kumar PBS (1):
  RDMA/bnxt_re: Add missing spin lock initialization

Selvin Xavier (2):
  RDMA/bnxt_re: Disable atomic support on VFs
  RDMA/bnxt_re: Fix query SRQ failure

 drivers/infiniband/hw/bnxt_re/ib_verbs.c | 1 +
 drivers/infiniband/hw/bnxt_re/main.c     | 2 +-
 drivers/infiniband/hw/bnxt_re/qplib_fp.c | 2 ++
 3 files changed, 4 insertions(+), 1 deletion(-)

-- 
2.5.5

