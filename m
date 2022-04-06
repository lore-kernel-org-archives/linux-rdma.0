Return-Path: <linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5C1DC433F5
	for <linux-rdma@archiver.kernel.org>; Wed,  6 Apr 2022 08:37:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234109AbiDFIj3 (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Wed, 6 Apr 2022 04:39:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352013AbiDFIgO (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Wed, 6 Apr 2022 04:36:14 -0400
Received: from out199-7.us.a.mail.aliyun.com (out199-7.us.a.mail.aliyun.com [47.90.199.7])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 505212AC2AE
        for <linux-rdma@vger.kernel.org>; Tue,  5 Apr 2022 19:34:57 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R761e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04357;MF=chengyou@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0V9JZmId_1649212492;
Received: from localhost(mailfrom:chengyou@linux.alibaba.com fp:SMTPD_---0V9JZmId_1649212492)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 06 Apr 2022 10:34:53 +0800
From:   Cheng Xu <chengyou@linux.alibaba.com>
To:     jgg@ziepe.ca, dledford@redhat.com, leon@kernel.org
Cc:     linux-rdma@vger.kernel.org, KaiShen@linux.alibaba.com,
        chengyou@linux.alibaba.com, tonylu@linux.alibaba.com,
        BMT@zurich.ibm.com
Subject: [PATCH for-next v5 02/12] RDMA/core: Allow calling query_port when netdev isn't attached in iWarp
Date:   Wed,  6 Apr 2022 10:34:40 +0800
Message-Id: <20220406023450.56683-3-chengyou@linux.alibaba.com>
X-Mailer: git-send-email 2.32.0 (Apple Git-132)
In-Reply-To: <20220406023450.56683-1-chengyou@linux.alibaba.com>
References: <20220406023450.56683-1-chengyou@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

This change lets the iWarp device drivers decide the return value of
iw_query_port when attached netdev is NULL. This allows ib_register_device
calling when netdev is NULL.

background info:
https://lore.kernel.org/all/20220118141324.GF8034@ziepe.ca/

Signed-off-by: Cheng Xu <chengyou@linux.alibaba.com>
---
 drivers/infiniband/core/device.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/core/device.c b/drivers/infiniband/core/device.c
index a311df07b1bd..1638b1188dc8 100644
--- a/drivers/infiniband/core/device.c
+++ b/drivers/infiniband/core/device.c
@@ -2019,8 +2019,12 @@ static int iw_query_port(struct ib_device *device,
 	memset(port_attr, 0, sizeof(*port_attr));
 
 	netdev = ib_device_get_netdev(device, port_num);
+	/* Some iwarp device may be not binded to a netdev temporarily when
+	 * ib_register_device called. To adapt this scenario, allowing iWarp
+	 * device drivers decide the return value.
+	 */
 	if (!netdev)
-		return -ENODEV;
+		goto query_port;
 
 	port_attr->max_mtu = IB_MTU_4096;
 	port_attr->active_mtu = ib_mtu_int_to_enum(netdev->mtu);
@@ -2045,6 +2049,7 @@ static int iw_query_port(struct ib_device *device,
 	}
 
 	dev_put(netdev);
+query_port:
 	return device->ops.query_port(device, port_num, port_attr);
 }
 
-- 
2.27.0

