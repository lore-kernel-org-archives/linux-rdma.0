Return-Path: <SRS0=aLju=C3=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02140C43463
	for <linux-rdma@archiver.kernel.org>; Fri, 18 Sep 2020 02:50:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AF5D421707
	for <linux-rdma@archiver.kernel.org>; Fri, 18 Sep 2020 02:50:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1600397438;
	bh=4qTkj4l9xYshPGVL1jFCPD5HFJvEoHurIlP2Z06u938=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=hO6PBrnZ3fRVSzYc/23ELGvsuxOMaSyE3Pan406MkOdxW9ukSUGUSA/2c4YWp28iu
	 dhwLfqxYaHGj9mhAjwNc15ntgvQ7ntOiXA8ZRvk3j7MBVoOybIw+gjjutmLSFGPeex
	 5AjekSoNd1vf2NfUVO7BN1h01Lo9Bl7TEEoCuvCA=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728127AbgIRCIl (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Thu, 17 Sep 2020 22:08:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:60176 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728121AbgIRCIk (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Thu, 17 Sep 2020 22:08:40 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9DE872388E;
        Fri, 18 Sep 2020 02:08:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600394920;
        bh=4qTkj4l9xYshPGVL1jFCPD5HFJvEoHurIlP2Z06u938=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tMLUAxyvB/zXtFIY96sB+gxk0hBrhZ5Xe06fNfQ8pHUiMJ4r8u4ExNHb9YlGYSLgj
         GjNaxOY1sqaRcMFAqMvGufXig5Xyw7yJHmtkBRgT7lMB1RbTjNF9cLXWLg92IE8MX0
         L6sBfDAFVndAkq7xVxpGkNL0p1mvbcOw0DZSjGgA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>, linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 032/206] RDMA/iw_cgxb4: Fix an error handling path in 'c4iw_connect()'
Date:   Thu, 17 Sep 2020 22:05:08 -0400
Message-Id: <20200918020802.2065198-32-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200918020802.2065198-1-sashal@kernel.org>
References: <20200918020802.2065198-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit 9067f2f0b41d7e817fc8c5259bab1f17512b0147 ]

We should jump to fail3 in order to undo the 'xa_insert_irq()' call.

Link: https://lore.kernel.org/r/20190923190746.10964-1-christophe.jaillet@wanadoo.fr
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/cxgb4/cm.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb4/cm.c b/drivers/infiniband/hw/cxgb4/cm.c
index 16145b0a14583..3fd3dfa3478b7 100644
--- a/drivers/infiniband/hw/cxgb4/cm.c
+++ b/drivers/infiniband/hw/cxgb4/cm.c
@@ -3293,7 +3293,7 @@ int c4iw_connect(struct iw_cm_id *cm_id, struct iw_cm_conn_param *conn_param)
 		if (raddr->sin_addr.s_addr == htonl(INADDR_ANY)) {
 			err = pick_local_ipaddrs(dev, cm_id);
 			if (err)
-				goto fail2;
+				goto fail3;
 		}
 
 		/* find a route */
@@ -3315,7 +3315,7 @@ int c4iw_connect(struct iw_cm_id *cm_id, struct iw_cm_conn_param *conn_param)
 		if (ipv6_addr_type(&raddr6->sin6_addr) == IPV6_ADDR_ANY) {
 			err = pick_local_ip6addrs(dev, cm_id);
 			if (err)
-				goto fail2;
+				goto fail3;
 		}
 
 		/* find a route */
-- 
2.25.1

