Return-Path: <SRS0=alaQ=VQ=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2EBFCC76188
	for <linux-rdma@archiver.kernel.org>; Fri, 19 Jul 2019 04:24:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 08B0D21849
	for <linux-rdma@archiver.kernel.org>; Fri, 19 Jul 2019 04:24:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1563510267;
	bh=PGLNZtWYCT5FOAWjYufHYxNtrcdeB4QDl9TvYiV899k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=oQg/24mmJf27p0m6n++tB4zrsPu5rIpbzUxvuuP7QnLdm21JPT8VhZ75IKMc1W63G
	 dZcTDRPgP3Cu6PHG8MpCx2lZHUuoMHWsolpr6SQeUPGEgZ/YOvyLKP3TZmnNq5vv3b
	 9fwX3J0EeZpvg+yuvHaThlKKKehUUxlOFNKWqGEk=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387541AbfGSEYV (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Fri, 19 Jul 2019 00:24:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:44288 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387679AbfGSEJl (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Fri, 19 Jul 2019 00:09:41 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E86CA218C3;
        Fri, 19 Jul 2019 04:09:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563509379;
        bh=PGLNZtWYCT5FOAWjYufHYxNtrcdeB4QDl9TvYiV899k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XQ5DnZQ3pMJ2mu+l45tRIBq1iVlwuo/VX50U1vsOHh/6TZAub0/I4fqiMjz1JCTSb
         3jMw67St3mDjLykGfCOu00/GNlm0H7zCGGxqJ9fSebK/upF/4T2JdExM/L+LWXQYiH
         qFdqDddA5GaWx2WUq1/c8sARiVWFy7qqOzGDU3ac=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Valentine Fatiev <valentinef@mellanox.com>,
        Feras Daoud <ferasda@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>, linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 063/101] IB/ipoib: Add child to parent list only if device initialized
Date:   Fri, 19 Jul 2019 00:06:54 -0400
Message-Id: <20190719040732.17285-63-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190719040732.17285-1-sashal@kernel.org>
References: <20190719040732.17285-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

From: Valentine Fatiev <valentinef@mellanox.com>

[ Upstream commit 91b01061fef9c57d2f5b712a6322ef51061f4efd ]

Despite failure in ipoib_dev_init() we continue with initialization flow
and creation of child device. It causes to the situation where this child
device is added too early to parent device list.

Change the logic, so in case of failure we properly return error from
ipoib_dev_init() and add child only in success path.

Fixes: eaeb39842508 ("IB/ipoib: Move init code to ndo_init")
Signed-off-by: Valentine Fatiev <valentinef@mellanox.com>
Reviewed-by: Feras Daoud <ferasda@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
Reviewed-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/ulp/ipoib/ipoib_main.c | 34 +++++++++++++----------
 1 file changed, 20 insertions(+), 14 deletions(-)

diff --git a/drivers/infiniband/ulp/ipoib/ipoib_main.c b/drivers/infiniband/ulp/ipoib/ipoib_main.c
index 30f840f874b3..453695f7d457 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_main.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_main.c
@@ -1892,12 +1892,6 @@ static void ipoib_child_init(struct net_device *ndev)
 	struct ipoib_dev_priv *priv = ipoib_priv(ndev);
 	struct ipoib_dev_priv *ppriv = ipoib_priv(priv->parent);
 
-	dev_hold(priv->parent);
-
-	down_write(&ppriv->vlan_rwsem);
-	list_add_tail(&priv->list, &ppriv->child_intfs);
-	up_write(&ppriv->vlan_rwsem);
-
 	priv->max_ib_mtu = ppriv->max_ib_mtu;
 	set_bit(IPOIB_FLAG_SUBINTERFACE, &priv->flags);
 	memcpy(priv->dev->dev_addr, ppriv->dev->dev_addr, INFINIBAND_ALEN);
@@ -1940,6 +1934,17 @@ static int ipoib_ndo_init(struct net_device *ndev)
 	if (rc) {
 		pr_warn("%s: failed to initialize device: %s port %d (ret = %d)\n",
 			priv->ca->name, priv->dev->name, priv->port, rc);
+		return rc;
+	}
+
+	if (priv->parent) {
+		struct ipoib_dev_priv *ppriv = ipoib_priv(priv->parent);
+
+		dev_hold(priv->parent);
+
+		down_write(&ppriv->vlan_rwsem);
+		list_add_tail(&priv->list, &ppriv->child_intfs);
+		up_write(&ppriv->vlan_rwsem);
 	}
 
 	return 0;
@@ -1957,6 +1962,14 @@ static void ipoib_ndo_uninit(struct net_device *dev)
 	 */
 	WARN_ON(!list_empty(&priv->child_intfs));
 
+	if (priv->parent) {
+		struct ipoib_dev_priv *ppriv = ipoib_priv(priv->parent);
+
+		down_write(&ppriv->vlan_rwsem);
+		list_del(&priv->list);
+		up_write(&ppriv->vlan_rwsem);
+	}
+
 	ipoib_neigh_hash_uninit(dev);
 
 	ipoib_ib_dev_cleanup(dev);
@@ -1968,15 +1981,8 @@ static void ipoib_ndo_uninit(struct net_device *dev)
 		priv->wq = NULL;
 	}
 
-	if (priv->parent) {
-		struct ipoib_dev_priv *ppriv = ipoib_priv(priv->parent);
-
-		down_write(&ppriv->vlan_rwsem);
-		list_del(&priv->list);
-		up_write(&ppriv->vlan_rwsem);
-
+	if (priv->parent)
 		dev_put(priv->parent);
-	}
 }
 
 static int ipoib_set_vf_link_state(struct net_device *dev, int vf, int link_state)
-- 
2.20.1

