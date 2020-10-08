Return-Path: <SRS0=E4jb=DP=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE900C433E7
	for <linux-rdma@archiver.kernel.org>; Thu,  8 Oct 2020 02:47:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 62B5620882
	for <linux-rdma@archiver.kernel.org>; Thu,  8 Oct 2020 02:47:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727449AbgJHCq7 (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Wed, 7 Oct 2020 22:46:59 -0400
Received: from smtprelay0089.hostedemail.com ([216.40.44.89]:60818 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726400AbgJHCq7 (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Wed, 7 Oct 2020 22:46:59 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay05.hostedemail.com (Postfix) with ESMTP id 6B73618029128;
        Thu,  8 Oct 2020 02:46:58 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-HE-Tag: wax25_0e0e3ab271d4
X-Filterd-Recvd-Size: 1308
Received: from XPS-9350.home (unknown [47.151.133.149])
        (Authenticated sender: joe@perches.com)
        by omf20.hostedemail.com (Postfix) with ESMTPA;
        Thu,  8 Oct 2020 02:46:56 +0000 (UTC)
Message-ID: <f7726a1873f14972f137f64a4d6cd35e530c6c95.camel@perches.com>
Subject: [likely PATCH] MAINTAINERS: CISCO VIC LOW LATENCY NIC DRIVER
From:   Joe Perches <joe@perches.com>
To:     Christian Benvenuti <benve@cisco.com>,
        Nelson Escobar <neescoba@cisco.com>
Cc:     Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>,
        linux-rdma@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Date:   Wed, 07 Oct 2020 19:46:54 -0700
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.36.4-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

Parvi Kaustubhi's email bounces.

Signed-off-by: Joe Perches <joe@perches.com>
---
 MAINTAINERS | 1 -
 1 file changed, 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 9ecb727f0a8f..3647500be78f 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4275,7 +4275,6 @@ F:	drivers/net/ethernet/cisco/enic/
 CISCO VIC LOW LATENCY NIC DRIVER
 M:	Christian Benvenuti <benve@cisco.com>
 M:	Nelson Escobar <neescoba@cisco.com>
-M:	Parvi Kaustubhi <pkaustub@cisco.com>
 S:	Supported
 F:	drivers/infiniband/hw/usnic/
 

