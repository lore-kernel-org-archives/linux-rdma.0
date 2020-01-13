Return-Path: <SRS0=tE8X=3C=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7FD88C33CA9
	for <linux-rdma@archiver.kernel.org>; Mon, 13 Jan 2020 19:12:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5261821556
	for <linux-rdma@archiver.kernel.org>; Mon, 13 Jan 2020 19:12:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VEWG5NHW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728783AbgAMTMk (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Mon, 13 Jan 2020 14:12:40 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:53112 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727331AbgAMTMk (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Mon, 13 Jan 2020 14:12:40 -0500
Received: by mail-wm1-f67.google.com with SMTP id p9so11056725wmc.2
        for <linux-rdma@vger.kernel.org>; Mon, 13 Jan 2020 11:12:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=KEO4XRa7yaHO22j1FzV444xdtylmBuQsLZ8DXC6ACwM=;
        b=VEWG5NHWDUGTJE2lxDmMOdRh1iHq0HNRSXfJeJ5MxFRKpGJRwVbKe6VmPgi0WFk7bW
         jSPRijHXVSipGxTM+Q6WuWrAYUpQUpXxUzR6qgeJHmONozUaArZEhRvmnRUP4H+ACNlI
         s1BDTHJaBM/RGkmbl6GOqoM7Stn22muCbvHho8RMmTerPNiEio3EGsxOBlySpM8EvPY6
         Hono0E12whddHV8S+5eD8OEG4UH0XbQt/g/W0loeUtX00lWEFsnv02jfEHp24ZhrMylZ
         m/YYHu7OGQM7DdEyFTM21nlxLuZ1RuVBi95y1fMi821hbrWy9pIFZI2yOjyORdMrnE0G
         BNFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=KEO4XRa7yaHO22j1FzV444xdtylmBuQsLZ8DXC6ACwM=;
        b=bNH/pSKmLJCIl2OVVLIA1hloijMGK7F650tsaWWn4oPc6AmhqS6KiUitg0lHaIlVRM
         EF2hu2U3MioWQJFVTaOwHCj39gq53hU9CRiH5EB+UTxVqF+6+vrZLt2M7Y9GxsOViPGD
         r7ArkIfWZTe6GEl3+fygB43itfCVVRqeJ7jpxhQp4M+Stod0hycpKF+mG7nQCX6qA9HH
         rYzn/ZcwY4JUpuQoE4SSGQWGBgkeZ3vRC/6KTACJkFW1lxTH2vkH+YAO9gpwGOQYbIv+
         kyvI+3lE8ts2SG4HUNHpbIPirSNwgraNCdEplGyVa685yQezwRYgT7mAgrYmmJsouBJp
         3RxQ==
X-Gm-Message-State: APjAAAVKalAUYWl6/90zCFxDwfak4WRzgrcDBpwNLrOhUZLV11pkfkUX
        eJhsv4Kbu0/deSMbcBax2HJHBGTZ
X-Google-Smtp-Source: APXvYqyGhyk9VLMxK8tKzB/hx2x+v72wGKUZRlyHFfpjxgxaVEHLIK7HTaT3jG774C9h6Ie9U3OHcQ==
X-Received: by 2002:a05:600c:2c13:: with SMTP id q19mr21405735wmg.144.1578942757394;
        Mon, 13 Jan 2020 11:12:37 -0800 (PST)
Received: from kheib-workstation.redhat.com (bzq-79-181-7-148.red.bezeqint.net. [79.181.7.148])
        by smtp.gmail.com with ESMTPSA id 2sm16020669wrq.31.2020.01.13.11.12.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jan 2020 11:12:36 -0800 (PST)
From:   Kamal Heib <kamalheib1@gmail.com>
To:     linux-rdma@vger.kernel.org
Cc:     Jason Gunthorpe <jgg@ziepe.ca>, Doug Ledford <dledford@redhat.com>,
        Kamal Heib <kamalheib1@gmail.com>
Subject: [PATCH for-next] RDMA/core: Fix storing node description
Date:   Mon, 13 Jan 2020 21:12:26 +0200
Message-Id: <20200113191226.14903-1-kamalheib1@gmail.com>
X-Mailer: git-send-email 2.21.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

Make sure to return -EINVAL when the supplied string is bigger then
IB_DEVICE_NODE_DESC_MAX.

Fixes: c5bcbbb9fe00 ("IB: Allow userspace to set node description")
Signed-off-by: Kamal Heib <kamalheib1@gmail.com>
---
 drivers/infiniband/core/sysfs.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/core/sysfs.c b/drivers/infiniband/core/sysfs.c
index 087682e6969e..55f4d7c1fcc9 100644
--- a/drivers/infiniband/core/sysfs.c
+++ b/drivers/infiniband/core/sysfs.c
@@ -1265,10 +1265,13 @@ static ssize_t node_desc_store(struct device *device,
 	struct ib_device_modify desc = {};
 	int ret;
 
+	if (count > IB_DEVICE_NODE_DESC_MAX)
+		return -EINVAL;
+
 	if (!dev->ops.modify_device)
 		return -EOPNOTSUPP;
 
-	memcpy(desc.node_desc, buf, min_t(int, count, IB_DEVICE_NODE_DESC_MAX));
+	memcpy(desc.node_desc, buf, count);
 	ret = ib_modify_device(dev, IB_DEVICE_MODIFY_NODE_DESC, &desc);
 	if (ret)
 		return ret;
-- 
2.21.1

