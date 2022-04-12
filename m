Return-Path: <linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE040C433EF
	for <linux-rdma@archiver.kernel.org>; Tue, 12 Apr 2022 02:37:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238315AbiDLCjs (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Mon, 11 Apr 2022 22:39:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234875AbiDLCjp (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Mon, 11 Apr 2022 22:39:45 -0400
Received: from out30-133.freemail.mail.aliyun.com (out30-133.freemail.mail.aliyun.com [115.124.30.133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C81A19C35
        for <linux-rdma@vger.kernel.org>; Mon, 11 Apr 2022 19:37:28 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R141e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04395;MF=chengyou@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0V9saMha_1649731045;
Received: from localhost(mailfrom:chengyou@linux.alibaba.com fp:SMTPD_---0V9saMha_1649731045)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 12 Apr 2022 10:37:25 +0800
From:   Cheng Xu <chengyou@linux.alibaba.com>
To:     jgg@ziepe.ca, dledford@redhat.com, leon@kernel.org
Cc:     linux-rdma@vger.kernel.org, KaiShen@linux.alibaba.com,
        chengyou@linux.alibaba.com, tonylu@linux.alibaba.com,
        BMT@zurich.ibm.com
Subject: [PATCH for-next v6 02/12] RDMA/core: Allow calling query_port when netdev isn't attached in iWarp
Date:   Tue, 12 Apr 2022 10:37:11 +0800
Message-Id: <20220412023721.47371-3-chengyou@linux.alibaba.com>
X-Mailer: git-send-email 2.32.0 (Apple Git-132)
In-Reply-To: <20220412023721.47371-1-chengyou@linux.alibaba.com>
References: <20220412023721.47371-1-chengyou@linux.alibaba.com>
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

