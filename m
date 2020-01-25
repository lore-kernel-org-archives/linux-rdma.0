Return-Path: <SRS0=BhuY=3O=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2ABCFC2D0DB
	for <linux-rdma@archiver.kernel.org>; Sat, 25 Jan 2020 16:14:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E53742075E
	for <linux-rdma@archiver.kernel.org>; Sat, 25 Jan 2020 16:14:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1579968858;
	bh=tG1jztXvIuyrhcdmu+h109XhVd+uN6XSXS+OCTvPijg=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=j3GtEl5c9oxcw6VZ73MIa0ymulmgnc/n2tdcHwtDd3fQrQtx2O6iOgtOEIlKJ6ZZu
	 yeu5Z3X8B64AOjLDUIO2y9NR3/aG/ZcTeKFuhKnwApQHubtLN0wuEa2bKgseud9kzN
	 NMr04HdFQk4L8RRmk8tkyoUEgq1CASy+P4nNDZ+0=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726030AbgAYQOR (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Sat, 25 Jan 2020 11:14:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:33020 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725843AbgAYQOR (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Sat, 25 Jan 2020 11:14:17 -0500
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E99D32071A;
        Sat, 25 Jan 2020 16:14:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579968856;
        bh=tG1jztXvIuyrhcdmu+h109XhVd+uN6XSXS+OCTvPijg=;
        h=From:To:Cc:Subject:Date:From;
        b=IE1Pf0FIQxoeX/IEZ9c7E5mnfQvAoADungW9c0V5sdvfR3soZFnLXwj32eBVCiA1I
         E97T+yfsfo8hcimZRTN+uLNESSL0UAx4KU5GjqnmryZKzpMg41ydCf3dGlXhfR56KE
         alS0bFOmQgUkchIZoslzJlStE6FiPSAvFp5RZJzo=
From:   Leon Romanovsky <leon@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Leon Romanovsky <leonro@mellanox.com>,
        Michal Kalderon <michal.kalderon@marvell.com>,
        linux-netdev <netdev@vger.kernel.org>,
        RDMA mailing list <linux-rdma@vger.kernel.org>
Subject: [PATCH net-next v1] net/core: Replace driver version to be kernel version
Date:   Sat, 25 Jan 2020 18:14:01 +0200
Message-Id: <20200125161401.40683-1-leon@kernel.org>
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
 Changelog:
 v1: Resend per-Dave's request
     https://lore.kernel.org/linux-rdma/20200125.101311.1924780619716720495.davem@davemloft.net
     No changes at all and applied cleanly on top of "3333e50b64fe Merge branch 'mlxsw-Offload-TBF'"
 v0: https://lore.kernel.org/linux-rdma/20200123130541.30473-1-leon@kernel.org
---
 net/ethtool/ioctl.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/ethtool/ioctl.c b/net/ethtool/ioctl.c
index 182bffbffa78..a403decacb6d 100644
--- a/net/ethtool/ioctl.c
+++ b/net/ethtool/ioctl.c
@@ -17,6 +17,7 @@
 #include <linux/phy.h>
 #include <linux/bitops.h>
 #include <linux/uaccess.h>
+#include <linux/vermagic.h>
 #include <linux/vmalloc.h>
 #include <linux/sfp.h>
 #include <linux/slab.h>
@@ -666,6 +667,8 @@ static noinline_for_stack int ethtool_get_drvinfo(struct net_device *dev,
 		return -EOPNOTSUPP;
 	}

+	strlcpy(info.version, UTS_RELEASE, sizeof(info.version));
+
 	/*
 	 * this method of obtaining string set info is deprecated;
 	 * Use ETHTOOL_GSSET_INFO instead.
--
2.24.1

