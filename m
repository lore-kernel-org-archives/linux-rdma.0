Return-Path: <SRS0=91Dd=2N=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4646BC2D0C0
	for <linux-rdma@archiver.kernel.org>; Mon, 23 Dec 2019 09:40:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1470420709
	for <linux-rdma@archiver.kernel.org>; Mon, 23 Dec 2019 09:40:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="akhPY9hl"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726257AbfLWJkZ (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Mon, 23 Dec 2019 04:40:25 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:46071 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726243AbfLWJkZ (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Mon, 23 Dec 2019 04:40:25 -0500
Received: by mail-wr1-f66.google.com with SMTP id j42so15899674wrj.12
        for <linux-rdma@vger.kernel.org>; Mon, 23 Dec 2019 01:40:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=BkBz/E8KQ76qHoClTca4FdmApceDdenDANy6D6hh9wM=;
        b=akhPY9hly2NdklEh09ztfyJthXzcNmdfhJoIpbCBE9zUN/Dx6suKH1CfcZKKIt1HH5
         D56Vh/tyM2xp38nhrULwyapQXLjRkIjWKo7smmAyWsj6jMOQvvrYpP/NCxliC+p6fzvK
         ZLrw1QiGooHh7MEebWh9lvKSMaegHVsq0zJTk/gjz35cL5EP8N0tV4m1o2OA7VlHiOVG
         Wm0mk5aYLmA7ywzKuEUUueRqGHeYcLP6SomNmR2x25YBqjW7TXwFTvoyNnCH2eWVn92P
         l7SC1y4lrL9t7MHwoBPeJLr4ivxNxqGAao4jT9dmcu5L257aZO5WQuujkAYO6iTgc3go
         xSuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=BkBz/E8KQ76qHoClTca4FdmApceDdenDANy6D6hh9wM=;
        b=qoKsP6mOLSRSj9hv1jJECiw4cLk2riWqf7pVrbPEO7fwmsbJ8hIcukzz1XlBwNAWg8
         KZvZjxwdrjjoz/DcaIuX+3KXpMbNCWQGCS86DPDyhVaCG9lMUlc0b6bGrUeLCdzU7St7
         C6NQU852fk43FTAoQVYtYkVG2ES2wyjfMPYCK1Df1KOREyMlkLgduzdtwcQHrbWXr/17
         3u1e6PnNqajIP5VLmXg5n90+mS3mtx9wWxV9OW7miw+mdrIAEmh8HIefR/YqdfODeXwi
         dALYe2N0VOKeAxGHhYiVEiAi2d9T2CBBiQ1gEgp9N3C+IY0pXl43iCLsTMwYeJV9dNH8
         owbQ==
X-Gm-Message-State: APjAAAXq3XnvWMXNaZIQn02H/4DVk89s202WM3gN/oFfTze8/709f///
        P0ukO+jUmJRn5AcjY5Mn1InnWaee
X-Google-Smtp-Source: APXvYqylwofZ4dIlaz7jSLkGcWOG4crM5zQoQ7IVXzIVO8foxbWOstjDfofBw0ieQe7j+iRs/45zvw==
X-Received: by 2002:adf:e3c1:: with SMTP id k1mr28090570wrm.151.1577094022886;
        Mon, 23 Dec 2019 01:40:22 -0800 (PST)
Received: from kheib-workstation.redhat.com (bzq-109-66-66-12.red.bezeqint.net. [109.66.66.12])
        by smtp.gmail.com with ESMTPSA id j12sm20006191wrt.55.2019.12.23.01.40.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Dec 2019 01:40:22 -0800 (PST)
From:   Kamal Heib <kamalheib1@gmail.com>
To:     linux-rdma@vger.kernel.org
Cc:     Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>,
        Kamal Heib <kamalheib1@gmail.com>
Subject: [PATCH for-next] RDMA/core: Fix storing node_desc
Date:   Mon, 23 Dec 2019 11:39:43 +0200
Message-Id: <20191223093943.17883-1-kamalheib1@gmail.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

When writing to node_desc sysfs using echo a new line symbol will be
stored at the end of the string, avoid that by dropping the new line
symbol and also make sure to return -EINVAL when the supplied string is
bigger then IB_DEVICE_NODE_DESC_MAX.

Fixes: c5bcbbb9fe00 ("IB: Allow userspace to set node description")
Signed-off-by: Kamal Heib <kamalheib1@gmail.com>
---
 drivers/infiniband/core/sysfs.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/core/sysfs.c b/drivers/infiniband/core/sysfs.c
index 087682e6969e..2de5f6710c0b 100644
--- a/drivers/infiniband/core/sysfs.c
+++ b/drivers/infiniband/core/sysfs.c
@@ -1263,12 +1263,21 @@ static ssize_t node_desc_store(struct device *device,
 {
 	struct ib_device *dev = rdma_device_to_ibdev(device);
 	struct ib_device_modify desc = {};
+	size_t len;
 	int ret;
 
 	if (!dev->ops.modify_device)
 		return -EOPNOTSUPP;
 
-	memcpy(desc.node_desc, buf, min_t(int, count, IB_DEVICE_NODE_DESC_MAX));
+	if (count > IB_DEVICE_NODE_DESC_MAX)
+		return -EINVAL;
+
+	len = strlen(buf);
+	if (buf[len - 1] == '\n')
+		len--;
+
+	strncpy(desc.node_desc, buf, len);
+	desc.node_desc[len] = 0;
 	ret = ib_modify_device(dev, IB_DEVICE_MODIFY_NODE_DESC, &desc);
 	if (ret)
 		return ret;
-- 
2.21.0

