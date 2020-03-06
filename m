Return-Path: <SRS0=uWV+=4X=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2ECD3C3F2D2
	for <linux-rdma@archiver.kernel.org>; Fri,  6 Mar 2020 01:06:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EDAD520870
	for <linux-rdma@archiver.kernel.org>; Fri,  6 Mar 2020 01:06:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1583456815;
	bh=BFAz6k8N2AgaW0pXpCjlxC1XrQ/2bd8PY1PxlDWovR0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=CN+tk9TtM6OT9iJRk7ulm04gglrVPj/ldqQ1HCeyn5WO51ytdlPOARVCMj2FZfnI7
	 dqFPQSw62O2nYkbAJqpGiFCSf/fiJK6hb3l2aYZhUkyFl1kv197xdmEirzP0I7Fvn0
	 60FaOUiryucsIfGo1rmtosgXmDOkbvGE41Kz/IVY=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726682AbgCFBGv (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Thu, 5 Mar 2020 20:06:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:59366 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726485AbgCFBGu (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Thu, 5 Mar 2020 20:06:50 -0500
Received: from kicinski-fedora-PC1C0HJN.thefacebook.com (unknown [163.114.132.128])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CBE7E208C3;
        Fri,  6 Mar 2020 01:06:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583456809;
        bh=BFAz6k8N2AgaW0pXpCjlxC1XrQ/2bd8PY1PxlDWovR0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eDv4q92MORThFDshgMnFSWnN8110Mhqn0qrE54dC9E9Y+VvvVknnafFvOnuYH/ZKD
         gmYxPMTC8cTzqhFWwwQSMS+YQORfDP0IGiQRhC/0UBDTJpDSpQwDKTs4Q+Nzn/qODN
         a2RcZc51Zeqqp6AIeWQOrvJk1S0sJ8uHzQhK90BY=
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     jdike@addtoit.com, richard@nod.at, anton.ivanov@cambridgegreys.com,
        linux-um@lists.infradead.org, dledford@redhat.com, jgg@ziepe.ca,
        leon@kernel.org, linux-rdma@vger.kernel.org, edumazet@google.com,
        jasowang@redhat.com, mkubecek@suse.cz, hayeswang@realtek.com,
        doshir@vmware.com, pv-drivers@vmware.com, manishc@marvell.com,
        GR-Linux-NIC-Dev@marvell.com, gregkh@linuxfoundation.org,
        merez@codeaurora.org, kvalo@codeaurora.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 2/7] RDMA/ipoib: reject unsupported coalescing params
Date:   Thu,  5 Mar 2020 17:05:57 -0800
Message-Id: <20200306010602.1620354-3-kuba@kernel.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200306010602.1620354-1-kuba@kernel.org>
References: <20200306010602.1620354-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

Set ethtool_ops->supported_coalesce_params to let
the core reject unsupported coalescing parameters.

This driver did not previously reject unsupported parameters.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 drivers/infiniband/ulp/ipoib/ipoib_ethtool.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/infiniband/ulp/ipoib/ipoib_ethtool.c b/drivers/infiniband/ulp/ipoib/ipoib_ethtool.c
index 63e4f9d15fd9..a10a0c2ca2da 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_ethtool.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_ethtool.c
@@ -213,6 +213,8 @@ static int ipoib_get_link_ksettings(struct net_device *netdev,
 }
 
 static const struct ethtool_ops ipoib_ethtool_ops = {
+	.supported_coalesce_params = ETHTOOL_COALESCE_RX_USECS |
+				     ETHTOOL_COALESCE_RX_MAX_FRAMES,
 	.get_link_ksettings	= ipoib_get_link_ksettings,
 	.get_drvinfo		= ipoib_get_drvinfo,
 	.get_coalesce		= ipoib_get_coalesce,
-- 
2.24.1

