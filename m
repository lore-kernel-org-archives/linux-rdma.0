Return-Path: <SRS0=iu+b=YZ=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4616ECA9ECF
	for <linux-rdma@archiver.kernel.org>; Fri,  1 Nov 2019 19:21:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D8F2321855
	for <linux-rdma@archiver.kernel.org>; Fri,  1 Nov 2019 19:21:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727778AbfKATVE (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Fri, 1 Nov 2019 15:21:04 -0400
Received: from mga11.intel.com ([192.55.52.93]:51728 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727774AbfKATVE (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Fri, 1 Nov 2019 15:21:04 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 01 Nov 2019 12:21:03 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,256,1569308400"; 
   d="scan'208";a="402321986"
Received: from sedona.ch.intel.com ([10.2.136.157])
  by fmsmga006.fm.intel.com with ESMTP; 01 Nov 2019 12:21:03 -0700
Received: from awfm-01.aw.intel.com (awfm-01.aw.intel.com [10.228.212.213])
        by sedona.ch.intel.com (8.14.3/8.14.3/Standard MailSET/Hub) with ESMTP id xA1JL1dY032648;
        Fri, 1 Nov 2019 12:21:02 -0700
Received: from awfm-01.aw.intel.com (localhost [127.0.0.1])
        by awfm-01.aw.intel.com (8.14.7/8.14.7) with ESMTP id xA1JKx7Q106271;
        Fri, 1 Nov 2019 15:20:59 -0400
Subject: [PATCH v2 for-rc 1/4] IB/hfi1: Ensure full Gen3 speed in a Gen4
 system
To:     jgg@ziepe.ca, dledford@redhat.com
From:   Mike Marciniszyn <mike.marciniszyn@intel.com>
Cc:     linux-rdma@vger.kernel.org
Date:   Fri, 01 Nov 2019 15:20:59 -0400
Message-ID: <20191101192059.106248.1699.stgit@awfm-01.aw.intel.com>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

From: James Erwin <james.erwin@intel.com>

If an hfi1 card is inserted in a Gen4 systems, the driver will avoid
the gen3 speed bump and the card will operate at half speed.

This is because the driver avoids the gen3 speed bump when the parent
bus speed isn't identical to gen3, 8.0GT/s.  This is not
compatible with gen4 and newer speeds.

Fix by relaxing the test to explicitly look for the lower
capability speeds which inherently allows for gen4 and all future
speeds.

Fixes: 7724105686e7 ("IB/hfi1: add driver files")
Cc: <stable@vger.kernel.org>
Reviewed-by: Dennis Dalessandro <dennis.dalessandro@intel.com>
Reviewed-by: Kaike Wan <kaike.wan@intel.com>
Signed-off-by: James Erwin <james.erwin@intel.com>
Signed-off-by: Mike Marciniszyn <mike.marciniszyn@intel.com>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro@intel.com>
---
 drivers/infiniband/hw/hfi1/pcie.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/hfi1/pcie.c b/drivers/infiniband/hw/hfi1/pcie.c
index 61aa550..61362bd 100644
--- a/drivers/infiniband/hw/hfi1/pcie.c
+++ b/drivers/infiniband/hw/hfi1/pcie.c
@@ -319,7 +319,9 @@ int pcie_speeds(struct hfi1_devdata *dd)
 	/*
 	 * bus->max_bus_speed is set from the bridge's linkcap Max Link Speed
 	 */
-	if (parent && dd->pcidev->bus->max_bus_speed != PCIE_SPEED_8_0GT) {
+	if (parent &&
+	    (dd->pcidev->bus->max_bus_speed == PCIE_SPEED_2_5GT ||
+	     dd->pcidev->bus->max_bus_speed == PCIE_SPEED_5_0GT)) {
 		dd_dev_info(dd, "Parent PCIe bridge does not support Gen3\n");
 		dd->link_gen3_capable = 0;
 	}

