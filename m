Return-Path: <linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 971D2C6FA82
	for <linux-rdma@archiver.kernel.org>; Wed, 21 Sep 2022 01:23:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231459AbiIUBXJ (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Tue, 20 Sep 2022 21:23:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231371AbiIUBXE (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Tue, 20 Sep 2022 21:23:04 -0400
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 200717B281;
        Tue, 20 Sep 2022 18:23:01 -0700 (PDT)
Received: by linux.microsoft.com (Postfix, from userid 1004)
        id 6A2AE20B92A0; Tue, 20 Sep 2022 18:23:00 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 6A2AE20B92A0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxonhyperv.com;
        s=default; t=1663723380;
        bh=NDaRbD4cdcYHkNYVJR8L9jq/M1A5SIHCbhCil+aZemo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:Reply-To:From;
        b=VubkcmE0/0+35sKQEB4UpT0wGqoW184NZDfamVX/polclFyut09vDIiepRVyKRELT
         6OiV/n3gvuG/jIeuQZNDMpnE9Nzvv0MxN8n1D2jCoeHG73WTllqzr59zGrOJ0GCg/k
         25pbFY/VJbjQSYsd0kl4f3U461azehFQBCCJBksc=
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
Subject: [Patch v6 05/12] net: mana: Set the DMA device max segment size
Date:   Tue, 20 Sep 2022 18:22:25 -0700
Message-Id: <1663723352-598-6-git-send-email-longli@linuxonhyperv.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1663723352-598-1-git-send-email-longli@linuxonhyperv.com>
References: <1663723352-598-1-git-send-email-longli@linuxonhyperv.com>
Reply-To: longli@microsoft.com
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

From: Ajay Sharma <sharmaajay@microsoft.com>

MANA hardware doesn't have any restrictions on the DMA segment size, set it
to the max allowed value.

Signed-off-by: Ajay Sharma <sharmaajay@microsoft.com>
Reviewed-by: Dexuan Cui <decui@microsoft.com>
Signed-off-by: Long Li <longli@microsoft.com>
Acked-by: Haiyang Zhang <haiyangz@microsoft.com>
---
Change log:
v2: Use the max allowed value as the hardware doesn't have any limit

 drivers/net/ethernet/microsoft/mana/gdma_main.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/ethernet/microsoft/mana/gdma_main.c b/drivers/net/ethernet/microsoft/mana/gdma_main.c
index 63544ca9e238..b44548136027 100644
--- a/drivers/net/ethernet/microsoft/mana/gdma_main.c
+++ b/drivers/net/ethernet/microsoft/mana/gdma_main.c
@@ -1419,6 +1419,12 @@ static int mana_gd_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	if (err)
 		goto release_region;
 
+	err = dma_set_max_seg_size(&pdev->dev, UINT_MAX);
+	if (err) {
+		dev_err(&pdev->dev, "Failed to set dma device segment size\n");
+		goto release_region;
+	}
+
 	err = -ENOMEM;
 	gc = vzalloc(sizeof(*gc));
 	if (!gc)
-- 
2.17.1

