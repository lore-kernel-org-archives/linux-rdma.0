Return-Path: <SRS0=WZnQ=3M=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39585C2D0DB
	for <linux-rdma@archiver.kernel.org>; Thu, 23 Jan 2020 13:09:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F41AA2467B
	for <linux-rdma@archiver.kernel.org>; Thu, 23 Jan 2020 13:09:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1579784981;
	bh=xqbS5R4WS1AqgEI2Q7sHCOZQz4UNp2SDFty7q25qvLo=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=BREX5RAziBEnEddtztya2H7bQ1ya3+4NZrhe6NHo3Dlgl8Au8cU0G8pI9aVC3UHrk
	 1dBDKOuO8PSxWJpGL5w2ZfoOt+BC/hcakStqp1ZK7iakwwtwJwaHlrFlbSm4bYf9G/
	 2VyWP+iqtZic51XCC+aSKHaqfcnJrsWTB3UKf50M=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726771AbgAWNJk (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Thu, 23 Jan 2020 08:09:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:47718 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726240AbgAWNJk (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Thu, 23 Jan 2020 08:09:40 -0500
Received: from localhost (unknown [193.47.165.251])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 09AF824655;
        Thu, 23 Jan 2020 13:09:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579784979;
        bh=xqbS5R4WS1AqgEI2Q7sHCOZQz4UNp2SDFty7q25qvLo=;
        h=From:To:Cc:Subject:Date:From;
        b=DMwuMaqSGLPfcLr2L6TqGCMEUgi+kfddrNA8gVSu835botzchuzQpa5ritngN/iUy
         GwOuqriXQ61rkxVb+vkk1dW+BkM9OFYGjtryD3z7Jwx57/ZH1kMzYK6OdTqyC+v2vO
         Fz3Psnhr26hqRa4R0RLGEZkD4hQkVFuQ4NvzngTg=
From:   Leon Romanovsky <leon@kernel.org>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Leon Romanovsky <leonro@mellanox.com>,
        Michal Kalderon <michal.kalderon@marvell.com>,
        linux-netdev <netdev@vger.kernel.org>,
        RDMA mailing list <linux-rdma@vger.kernel.org>
Subject: [PATCH net-next] net/core: Replace driver version to be kernel version
Date:   Thu, 23 Jan 2020 15:05:41 +0200
Message-Id: <20200123130541.30473-1-leon@kernel.org>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro@mellanox.com>

In order to stop useless driver version bumps and unify output
presented by ethtool -i, let's overwrite the version string.

Before this change:
[leonro@erver ~]$ ethtool -i eth0
driver: virtio_net
version: 1.0.0
After this change:
[leonro@server ~]$ ethtool -i eth0
driver: virtio_net
version: 5.5.0-rc6+

Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
I wanted to change to VERMAGIC_STRING, but the output doesn't
look pleasant to my taste and on my system is truncated to be
"version: 5.5.0-rc6+ SMP mod_unload modve".

After this patch, we can drop all those version assignments
from the drivers.

Inspired by nfp and hns code.
---
 net/core/ethtool.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/core/ethtool.c b/net/core/ethtool.c
index cd9bc67381b2..3c6fb13a78bf 100644
--- a/net/core/ethtool.c
+++ b/net/core/ethtool.c
@@ -17,6 +17,7 @@
 #include <linux/phy.h>
 #include <linux/bitops.h>
 #include <linux/uaccess.h>
+#include <linux/vermagic.h>
 #include <linux/vmalloc.h>
 #include <linux/sfp.h>
 #include <linux/slab.h>
@@ -776,6 +777,8 @@ static noinline_for_stack int ethtool_get_drvinfo(struct net_device *dev,
 		return -EOPNOTSUPP;
 	}

+	strlcpy(info.version, UTS_RELEASE, sizeof(info.version));
+
 	/*
 	 * this method of obtaining string set info is deprecated;
 	 * Use ETHTOOL_GSSET_INFO instead.
--
2.20.1

