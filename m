Return-Path: <SRS0=OUpm=ZC=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5EC73C17443
	for <linux-rdma@archiver.kernel.org>; Sun, 10 Nov 2019 02:49:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2AD29225AD
	for <linux-rdma@archiver.kernel.org>; Sun, 10 Nov 2019 02:49:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1573354143;
	bh=/iiWpYIah33RZaJSah7hoPv2+EwlM7QCexritnX69Z8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=x5sfr6ROfY1uebuEh9DLd0+i+5Hb89hMwuz+wsCAUiDYKe+DdomsaUX9CoDHjRWqs
	 vKJD4UVyrOrm6aJcfLM9y9HbA/B652BVWgZXMSV1ke/zq8rujXmaFaUb6xeOW8AbjC
	 9xHojuiZ9lQH6+dg9DN04jwgGUq4Z91UFbIAel1c=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726609AbfKJCs6 (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Sat, 9 Nov 2019 21:48:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:57000 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729374AbfKJCs5 (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Sat, 9 Nov 2019 21:48:57 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2E65522582;
        Sun, 10 Nov 2019 02:48:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573354136;
        bh=/iiWpYIah33RZaJSah7hoPv2+EwlM7QCexritnX69Z8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ioQ9CXrfw1FEch2fkvuSx+csJg5iEkFFSLUFYMyU45RnYCVkp0pCHzYv70dkn+OBX
         u4FSrKt0RIkgbSWWqbFxP4Yw0WVgT/YNnLBDxwsLP/7XIv0ArXMM6Wl+eAkkMaf8Wa
         S5zOrOW3LDYtEmFVhx95D+eK+VF8oGKracAfhnnA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?H=C3=A5kon=20Bugge?= <Haakon.Bugge@oracle.com>,
        =?UTF-8?q?H=C3=A5kon=20Bugge?= <haakon.bugge@oracle.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>, linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 07/66] RDMA/i40iw: Fix incorrect iterator type
Date:   Sat,  9 Nov 2019 21:47:46 -0500
Message-Id: <20191110024846.32598-7-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191110024846.32598-1-sashal@kernel.org>
References: <20191110024846.32598-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

From: Håkon Bugge <Haakon.Bugge@oracle.com>

[ Upstream commit 802fa45cd320de319e86c93bca72abec028ba059 ]

Commit f27b4746f378 ("i40iw: add connection management code") uses an
incorrect rcu iterator, whilst holding the rtnl_lock. Since the
critical region invokes i40iw_manage_qhash(), which is a sleeping
function, the rcu locking and traversal cannot be used.

Signed-off-by: Håkon Bugge <haakon.bugge@oracle.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/i40iw/i40iw_cm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/i40iw/i40iw_cm.c b/drivers/infiniband/hw/i40iw/i40iw_cm.c
index 85637696f6e96..282a726351c81 100644
--- a/drivers/infiniband/hw/i40iw/i40iw_cm.c
+++ b/drivers/infiniband/hw/i40iw/i40iw_cm.c
@@ -1652,7 +1652,7 @@ static enum i40iw_status_code i40iw_add_mqh_6(struct i40iw_device *iwdev,
 	unsigned long flags;
 
 	rtnl_lock();
-	for_each_netdev_rcu(&init_net, ip_dev) {
+	for_each_netdev(&init_net, ip_dev) {
 		if ((((rdma_vlan_dev_vlan_id(ip_dev) < I40IW_NO_VLAN) &&
 		      (rdma_vlan_dev_real_dev(ip_dev) == iwdev->netdev)) ||
 		     (ip_dev == iwdev->netdev)) && (ip_dev->flags & IFF_UP)) {
-- 
2.20.1

