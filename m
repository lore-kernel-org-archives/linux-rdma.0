Return-Path: <linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91D31C48BC2
	for <linux-rdma@archiver.kernel.org>; Wed, 23 Jun 2021 08:21:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7C65260D07
	for <linux-rdma@archiver.kernel.org>; Wed, 23 Jun 2021 08:21:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230072AbhFWIYE (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Wed, 23 Jun 2021 04:24:04 -0400
Received: from lpdvsmtp11.broadcom.com ([192.19.166.231]:51864 "EHLO
        relay.smtp-ext.broadcom.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230030AbhFWIYD (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>);
        Wed, 23 Jun 2021 04:24:03 -0400
X-Greylist: delayed 398 seconds by postgrey-1.27 at vger.kernel.org; Wed, 23 Jun 2021 04:24:03 EDT
Received: from dhcp-10-192-206-197.iig.avagotech.net.net (dhcp-10-123-156-118.dhcp.broadcom.net [10.123.156.118])
        by relay.smtp-ext.broadcom.com (Postfix) with ESMTP id 1EBC124AB2;
        Wed, 23 Jun 2021 01:15:06 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 relay.smtp-ext.broadcom.com 1EBC124AB2
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=broadcom.com;
        s=dkimrelay; t=1624436108;
        bh=Nxvg3CePTD4fU7UbeNC1eaymrfaplF9rdrUYZHyUjG4=;
        h=From:To:Cc:Subject:Date:From;
        b=EjbbQ2EPtguhB4BoWEMJ5BWRRS9W+uQdmGLqYtwlohkn9ZDtLjEaC1UJdS3pOOhld
         kq+jy/xD69YENFPyTEaxQ8q5CBxxQwULTWY8iS8+H1hUotBQft19TDbYOP9vuQUKge
         TVJIpWXAmUw6eVXuAP3SiSZMzadicKthNOHLDulc=
From:   Selvin Xavier <selvin.xavier@broadcom.com>
To:     jgg@ziepe.ca, dledford@redhat.com
Cc:     linux-rdma@vger.kernel.org,
        Selvin Xavier <selvin.xavier@broadcom.com>
Subject: [PATCH rdma-next] MAINTAINERS: Update Broadcom RDMA maintainers
Date:   Wed, 23 Jun 2021 01:14:49 -0700
Message-Id: <1624436089-28263-1-git-send-email-selvin.xavier@broadcom.com>
X-Mailer: git-send-email 2.5.5
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

Updating the maintainers file as Devesh decidied to
leave Broadcom.

Signed-off-by: Selvin Xavier <selvin.xavier@broadcom.com>
---
 MAINTAINERS | 2 --
 1 file changed, 2 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 636b238..985e621 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3735,7 +3735,6 @@ F:	drivers/gpio/gpio-bcm-kona.c
 
 BROADCOM NETXTREME-E ROCE DRIVER
 M:	Selvin Xavier <selvin.xavier@broadcom.com>
-M:	Devesh Sharma <devesh.sharma@broadcom.com>
 M:	Naresh Kumar PBS <nareshkumar.pbs@broadcom.com>
 L:	linux-rdma@vger.kernel.org
 S:	Supported
@@ -6719,7 +6718,6 @@ F:	drivers/net/ethernet/emulex/benet/
 
 EMULEX ONECONNECT ROCE DRIVER
 M:	Selvin Xavier <selvin.xavier@broadcom.com>
-M:	Devesh Sharma <devesh.sharma@broadcom.com>
 L:	linux-rdma@vger.kernel.org
 S:	Odd Fixes
 W:	http://www.broadcom.com
-- 
2.5.5

