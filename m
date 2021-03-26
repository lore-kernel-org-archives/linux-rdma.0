Return-Path: <linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,
	DATE_IN_FUTURE_12_24,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11023C433DB
	for <linux-rdma@archiver.kernel.org>; Thu, 25 Mar 2021 10:20:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BC45361A1A
	for <linux-rdma@archiver.kernel.org>; Thu, 25 Mar 2021 10:20:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230154AbhCYKTx (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Thu, 25 Mar 2021 06:19:53 -0400
Received: from mga04.intel.com ([192.55.52.120]:58708 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230031AbhCYKTt (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Thu, 25 Mar 2021 06:19:49 -0400
IronPort-SDR: h44g9HNs/gKXzTZ6TwtZGjyK4VwnoIbT26nzpo/w5PFY8XRFyBrPnwhpcavRhlYH8TZF9oPhbE
 QzQB73SkV09g==
X-IronPort-AV: E=McAfee;i="6000,8403,9933"; a="188602030"
X-IronPort-AV: E=Sophos;i="5.81,277,1610438400"; 
   d="scan'208";a="188602030"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Mar 2021 03:19:49 -0700
IronPort-SDR: X0m1ZWPS27WmTLjW8GDs+dIEZY2ziSBAh1YNmZyAbV+QBt3GX7CBxDCLOtFJQwpgfVoB/Jb6Iu
 lJt/K5VWL50g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,277,1610438400"; 
   d="scan'208";a="514572817"
Received: from unknown (HELO intel-86.bj.intel.com) ([10.238.154.86])
  by fmsmga001.fm.intel.com with ESMTP; 25 Mar 2021 03:19:47 -0700
From:   Zhu Yanjun <yanjun.zhu@intel.com>
To:     dledford@redhat.com, jgg@ziepe.ca, leon@kernel.org,
        linux-rdma@vger.kernel.org
Cc:     Zhu Yanjun <zyjzyj2000@gmail.com>, Jason Gunthorpe <jgg@nvidia.com>
Subject: [PATCH 1/1] RDMA/addr: Disable ipv6 features when ipv6.disable set in cmdline
Date:   Thu, 25 Mar 2021 22:44:05 -0400
Message-Id: <20210326024405.3870-1-yanjun.zhu@intel.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

From: Zhu Yanjun <zyjzyj2000@gmail.com>

When ipv6.disable=1 is set in cmdline, ipv6 is actually disabled
in the stack. As such, the operations of ipv6 will fail.
So ipv6 features in addr should also be disabled.

Fixes: caf1e3ae9fa6 ("RDMA/core Introduce and use rdma_find_ndev_for_src_ip_rcu")
Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Zhu Yanjun <zyjzyj2000@gmail.com>
---
 drivers/infiniband/core/addr.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/infiniband/core/addr.c b/drivers/infiniband/core/addr.c
index 0abce004a959..6fa57b83c4b1 100644
--- a/drivers/infiniband/core/addr.c
+++ b/drivers/infiniband/core/addr.c
@@ -257,6 +257,9 @@ rdma_find_ndev_for_src_ip_rcu(struct net *net, const struct sockaddr *src_in)
 		break;
 #if IS_ENABLED(CONFIG_IPV6)
 	case AF_INET6:
+		if (!ipv6_mod_enabled())
+			return ERR_PTR(-EPFNOSUPPORT);
+
 		for_each_netdev_rcu(net, dev) {
 			if (ipv6_chk_addr(net,
 					  &((const struct sockaddr_in6 *)src_in)->sin6_addr,
@@ -424,6 +427,9 @@ static int addr6_resolve(struct sockaddr *src_sock,
 	struct flowi6 fl6;
 	struct dst_entry *dst;
 
+	if (!ipv6_mod_enabled())
+		return -EADDRNOTAVAIL;
+
 	memset(&fl6, 0, sizeof fl6);
 	fl6.daddr = dst_in->sin6_addr;
 	fl6.saddr = src_in->sin6_addr;
-- 
2.27.0

