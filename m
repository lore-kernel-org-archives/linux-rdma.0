Return-Path: <linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF563C3A59D
	for <linux-rdma@archiver.kernel.org>; Sun, 23 Oct 2022 05:39:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229568AbiJWFjf (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Sun, 23 Oct 2022 01:39:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229588AbiJWFje (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Sun, 23 Oct 2022 01:39:34 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7634613CCC
        for <linux-rdma@vger.kernel.org>; Sat, 22 Oct 2022 22:39:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1666503570; x=1698039570;
  h=from:to:subject:date:message-id:in-reply-to:references:
   mime-version:content-transfer-encoding;
  bh=mESt4mhsp+XsG+gJr28pIhhED4A6IjoZZpefU6QgPTo=;
  b=Iwcw2+vQELMNSQWfB6uSNT6AbgcVA2zXF/yZLxeLyjVwHTXKkikTBNbI
   YFkZtXOFurlfy85hAy6uwi4au6dedt2kyPG4izlTMnX8BuYdX+hkVCn/B
   x7umDZviPIVAcYNoRhVp41E6cUshPmjqagSj3+9ZgK+DWNzH2VfaAoawX
   YOlyLxP8beTW+hBrtbKocaQIGOvrpF18VK4hos7fdnwVdRKSjYcuq1T8B
   c9IcEIzYNIZHO58mvwNAcR+lUeK1qPuyzQa69lKRjZaYf412pI96deHKW
   S4gwOh6dxJZSMaOP0L9+C5fSNcggdhDy7peRskbjoQbUzBKMiebfQSiya
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10508"; a="294632907"
X-IronPort-AV: E=Sophos;i="5.95,206,1661842800"; 
   d="scan'208";a="294632907"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Oct 2022 22:39:30 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10508"; a="662047006"
X-IronPort-AV: E=Sophos;i="5.95,206,1661842800"; 
   d="scan'208";a="662047006"
Received: from unknown (HELO intel-71.bj.intel.com) ([10.238.154.71])
  by orsmga008.jf.intel.com with ESMTP; 22 Oct 2022 22:39:28 -0700
From:   Zhu Yanjun <yanjun.zhu@intel.com>
To:     jgg@ziepe.ca, leon@kernel.org, linux-rdma@vger.kernel.org,
        yanjun.zhu@linux.dev, yanjun.zhu@intel.com
Subject: [PATCH 2/3] RDMA/core: The legacy IB devices still work with shared/exclusive mode
Date:   Sun, 23 Oct 2022 18:04:49 -0400
Message-Id: <20221023220450.2287909-3-yanjun.zhu@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20221023220450.2287909-1-yanjun.zhu@intel.com>
References: <20221023220450.2287909-1-yanjun.zhu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

From: Zhu Yanjun <yanjun.zhu@linux.dev>

Other ib devices except legacy IB devices should work with its related
net devices. That is, these ib devices should be in the same net
namespace with the related net devices.

Signed-off-by: Zhu Yanjun <yanjun.zhu@linux.dev>
---
 drivers/infiniband/core/device.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/core/device.c b/drivers/infiniband/core/device.c
index 59784fd10876..d38eb1fc2ed7 100644
--- a/drivers/infiniband/core/device.c
+++ b/drivers/infiniband/core/device.c
@@ -140,8 +140,13 @@ MODULE_PARM_DESC(netns_mode,
  */
 bool rdma_dev_access_netns(const struct ib_device *dev, const struct net *net)
 {
-	return (ib_devices_shared_netns ||
-		net_eq(read_pnet(&dev->coredev.rdma_net), net));
+	/* ib_devices_shared_netns is only for IB device. */
+	if (rdma_protocol_ib(dev, rdma_start_port(dev))) {
+		return (ib_devices_shared_netns ||
+			net_eq(read_pnet(&dev->coredev.rdma_net), net));
+	} else { /* Others device */
+		return net_eq(read_pnet(&dev->coredev.rdma_net), net);
+	}
 }
 EXPORT_SYMBOL(rdma_dev_access_netns);
 
@@ -2744,6 +2749,12 @@ static int rdma_netns_notify(struct notifier_block *not_blk,
 	if (!ibdev)
 		return NOTIFY_OK;
 
+	/* This will exclude IB device */
+	if (rdma_protocol_ib(ibdev, rdma_start_port(ibdev))) {
+		ib_device_put(ibdev);
+		return NOTIFY_OK;
+	}
+
 	switch (event) {
 	case NETDEV_REGISTER:
 		ib_device_put(ibdev);
-- 
2.27.0

