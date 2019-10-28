Return-Path: <SRS0=4Nee=YV=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2BAAECA9EC0
	for <linux-rdma@archiver.kernel.org>; Mon, 28 Oct 2019 16:00:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F398920717
	for <linux-rdma@archiver.kernel.org>; Mon, 28 Oct 2019 16:00:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="tooKU51b"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731561AbfJ1QAH (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Mon, 28 Oct 2019 12:00:07 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:44596 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730448AbfJ1QAH (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Mon, 28 Oct 2019 12:00:07 -0400
Received: by mail-wr1-f66.google.com with SMTP id z11so10431706wro.11
        for <linux-rdma@vger.kernel.org>; Mon, 28 Oct 2019 09:00:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=1oAb42sZZnx0GHz8zCdLCMmekFS0iw5KiZS34/CPk4k=;
        b=tooKU51bYYf1gF016u+c81AEuMXscSfSovfJ/EDkbLFB04aStD3mLoO+NUTyJaeMo7
         Gd0zVRLA3hmTuqX4quwt4Afq+NMEXw6HQVOyWBY71EagsnSWDm++sa7QfL39oGoOMV3T
         rFT2qFID6aW7XZ8a6v67Gpbno0FjrDfiemU50pbtlGzzgPOEs4t7kgJtmgWi1qIa69Jp
         smbUhA5doLiSdFEpNmZofHnf8K3GDCoR21apKb49dLV0Ah4CJY8hcUIORsjn8HrmoIVD
         UD+xuVWTTESPh7gajyQKrD4/r/Q7BPClADeAwvVOb8r5FLwEm9PAbj+MOm1uzIO+SI5g
         vLdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1oAb42sZZnx0GHz8zCdLCMmekFS0iw5KiZS34/CPk4k=;
        b=VQOsVfPyaOtkZzdDHhgZE47f4jonPtx5FT+yWUOcKnzn5EWqpbQ+jKYCp5OYtgl9rR
         AV1dS+2FHGNj+yOjirMV3cXuKYyMenX/0Ptb2lTbOVS585ZkdirfFVvbjgWo97dqGfbm
         eaeIkIi/2JU1PE9Ynq5J8i3wpCn/Hj+GH00p3EOT01M3RYUFBfsmpzxmv9FPa2YolivN
         IDGq80yaXT3BVJmvDrNPvw1jqSWxUTkSq1TGA6OpYxl69SJSle1mJIhqJ5mv226UqwSn
         v9Ws/ubnruUtEasmFcKiEC48l13Qgi45jvTb+8w0Y/ZuzA/wZbtaCyqOlL1rpaxB/XAI
         lHcg==
X-Gm-Message-State: APjAAAU+dIenSHCPfjnJw3MBOeLd/8Lf2YZPz1V/ogF0YVNCShiUYFwU
        84vh1CT8OXaeRAoW5CXWWbcHHbrNn8c=
X-Google-Smtp-Source: APXvYqzErUlZTf9VjIv3POxBpIqJbqoWcV0/wANgcpnF0hbGAK7HB6spU4kLAID3fAtG3aGTGqpCtg==
X-Received: by 2002:adf:fe90:: with SMTP id l16mr15359441wrr.81.1572278403719;
        Mon, 28 Oct 2019 09:00:03 -0700 (PDT)
Received: from kheib-workstation.redhat.com (bzq-79-179-0-252.red.bezeqint.net. [79.179.0.252])
        by smtp.gmail.com with ESMTPSA id a2sm11871600wrv.39.2019.10.28.09.00.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Oct 2019 09:00:03 -0700 (PDT)
From:   Kamal Heib <kamalheib1@gmail.com>
To:     linux-rdma@vger.kernel.org
Cc:     Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>,
        Lijun Ou <oulijun@huawei.com>,
        Selvin Xavier <selvin.xavier@broadcom.com>,
        Michal Kalderon <mkalderon@marvell.com>,
        Kamal Heib <kamalheib1@gmail.com>
Subject: [for-next v4 1/4] RDMA/core: Fix return code when modify_port isn't supported
Date:   Mon, 28 Oct 2019 17:59:28 +0200
Message-Id: <20191028155931.1114-2-kamalheib1@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191028155931.1114-1-kamalheib1@gmail.com>
References: <20191028155931.1114-1-kamalheib1@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

Improving return code from ib_modify_port() by doing the following:
1- Use "-EOPNOTSUPP" instead "-ENOSYS" which is the proper return code.
2- Allow only IB_PORT_CM_SUP fake manipulation for RoCE providers that
   didn't implement the modify_port callback, otherwise return "-EOPNOTSUPP".

Fixes: 61e0962d5221 ("IB: Avoid ib_modify_port() failure for RoCE devices")
Signed-off-by: Kamal Heib <kamalheib1@gmail.com>
---
 drivers/infiniband/core/device.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/core/device.c b/drivers/infiniband/core/device.c
index eb35b663a742..ee5fe20bd8b0 100644
--- a/drivers/infiniband/core/device.c
+++ b/drivers/infiniband/core/device.c
@@ -2395,8 +2395,12 @@ int ib_modify_port(struct ib_device *device,
 		rc = device->ops.modify_port(device, port_num,
 					     port_modify_mask,
 					     port_modify);
+	else if (rdma_protocol_roce(device, port_num) &&
+		 ((port_modify->set_port_cap_mask & ~IB_PORT_CM_SUP) == 0 ||
+		  (port_modify->clr_port_cap_mask & ~IB_PORT_CM_SUP) == 0))
+		rc = 0;
 	else
-		rc = rdma_protocol_roce(device, port_num) ? 0 : -ENOSYS;
+		rc = -EOPNOTSUPP;
 	return rc;
 }
 EXPORT_SYMBOL(ib_modify_port);
-- 
2.20.1

