Return-Path: <linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD7EFC54EE9
	for <linux-rdma@archiver.kernel.org>; Wed, 31 Aug 2022 00:35:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231741AbiHaAfJ (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Tue, 30 Aug 2022 20:35:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231446AbiHaAeq (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Tue, 30 Aug 2022 20:34:46 -0400
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B64B32C7;
        Tue, 30 Aug 2022 17:34:44 -0700 (PDT)
Received: by linux.microsoft.com (Postfix, from userid 1004)
        id 7E6912045E2E; Tue, 30 Aug 2022 17:34:44 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 7E6912045E2E
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxonhyperv.com;
        s=default; t=1661906084;
        bh=TVsP8Dfm0+8+pxJK1xuH374UMPKQ2xcK55Dw85XVZL0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:Reply-To:From;
        b=rjrBBZk6H+zc0JKJj4cvlqdJaKx4gbTgw22hen9aOIKyPDL+R6BcA/b0LuiZM24d8
         sjlajumT6L8LkflBTcbCtQoZ9ob1/0QPAbhx/hDFO2PDxvgi/XPVwuV55BMZPS+hdZ
         PoGQiWK7qW9I65lNh8ninFqPTQTt/858FGHnmhrg=
From:   longli@linuxonhyperv.com
To:     "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Leon Romanovsky <leon@kernel.org>, edumazet@google.com,
        shiraz.saleem@intel.com, Ajay Sharma <sharmaajay@microsoft.com>
Cc:     linux-hyperv@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
        Long Li <longli@microsoft.com>
Subject: [Patch v5 07/12] net: mana: Record port number in netdev
Date:   Tue, 30 Aug 2022 17:34:26 -0700
Message-Id: <1661906071-29508-8-git-send-email-longli@linuxonhyperv.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1661906071-29508-1-git-send-email-longli@linuxonhyperv.com>
References: <1661906071-29508-1-git-send-email-longli@linuxonhyperv.com>
Reply-To: longli@microsoft.com
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

From: Long Li <longli@microsoft.com>

The port number is useful for user-mode application to identify this
net device based on port index. Set to the correct value in ndev.

Reviewed-by: Dexuan Cui <decui@microsoft.com>
Signed-off-by: Long Li <longli@microsoft.com>
---
 drivers/net/ethernet/microsoft/mana/mana_en.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/microsoft/mana/mana_en.c b/drivers/net/ethernet/microsoft/mana/mana_en.c
index 4c771ce59108..eeddd4ab2fa4 100644
--- a/drivers/net/ethernet/microsoft/mana/mana_en.c
+++ b/drivers/net/ethernet/microsoft/mana/mana_en.c
@@ -1988,6 +1988,7 @@ static int mana_probe_port(struct mana_context *ac, int port_idx,
 	ndev->max_mtu = ndev->mtu;
 	ndev->min_mtu = ndev->mtu;
 	ndev->needed_headroom = MANA_HEADROOM;
+	ndev->dev_port = port_idx;
 	SET_NETDEV_DEV(ndev, gc->dev);
 
 	netif_carrier_off(ndev);
-- 
2.17.1

