Return-Path: <SRS0=/rP3=X3=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99199C352AA
	for <linux-rdma@archiver.kernel.org>; Wed,  2 Oct 2019 12:17:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5F41721929
	for <linux-rdma@archiver.kernel.org>; Wed,  2 Oct 2019 12:17:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1570018677;
	bh=ZxPG6Y6jKlkkxU05aGHfi8eRgEsCEcatBMAbquYnjTU=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=c9eLBEOzJebPxCo6XscEMv1X9KCBD6IPwd8qm1eyfNDwqOAc5wMhygNxyEtD+Vwi/
	 +ZLMGkYW4+TYNyHZIpyCFF/pnO7ajcF7ZgD2zWw+VVFiDjwSzEyKApgbh3swQFN4K5
	 ZYMZBZrSM6/FlvpweFyMs/JrwoQpLpoxDKbiuFHs=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726157AbfJBMR4 (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Wed, 2 Oct 2019 08:17:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:58326 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726030AbfJBMR4 (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Wed, 2 Oct 2019 08:17:56 -0400
Received: from localhost (unknown [193.47.165.251])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7F2B021920;
        Wed,  2 Oct 2019 12:17:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570018676;
        bh=ZxPG6Y6jKlkkxU05aGHfi8eRgEsCEcatBMAbquYnjTU=;
        h=From:To:Cc:Subject:Date:From;
        b=cGAQ7xTUBrob+CGCGeZIqwkccGrE92vb2sueugzPhhGnfRhNYgrMCmFa3cs5o1aMb
         3uMuZuQD5c5Za3SGk0ZVFdfPkhCL1cDCuCdpCMAtlJzKHc7ESNraH13SKykJNK/qJp
         uChxWaJ28ZldiDCBLy74kItMVZHW47FNYVNoIoxg=
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Cc:     Parav Pandit <parav@mellanox.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Matan Barak <matanb@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>
Subject: [PATCH rdma-rc] IB/core: Use rdma_read_gid_l2_fields to compare GID L2 fields
Date:   Wed,  2 Oct 2019 15:17:50 +0300
Message-Id: <20191002121750.17313-1-leon@kernel.org>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

From: Parav Pandit <parav@mellanox.com>

Current code tries to derive VLAN ID and compares it with GID
attribute for matching entry. This raw search fails on macvlan
netdevice as its not a VLAN device, but its an upper device of a VLAN
netdevice.

Due to this limitation, incoming QP1 packets fail to match in the
GID table. Such packets are dropped.

Hence, to support it, use the existing rdma_read_gid_l2_fields()
that takes care of diffferent device types.

Fixes: dbf727de7440 ("IB/core: Use GID table in AH creation and dmac resolution")
Signed-off-by: Parav Pandit <parav@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/infiniband/core/verbs.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/core/verbs.c
index f974b6854224..35c2841a569e 100644
--- a/drivers/infiniband/core/verbs.c
+++ b/drivers/infiniband/core/verbs.c
@@ -662,16 +662,17 @@ static bool find_gid_index(const union ib_gid *gid,
 			   void *context)
 {
 	struct find_gid_index_context *ctx = context;
+	u16 vlan_id = 0xffff;
+	int ret;
 
 	if (ctx->gid_type != gid_attr->gid_type)
 		return false;
 
-	if ((!!(ctx->vlan_id != 0xffff) == !is_vlan_dev(gid_attr->ndev)) ||
-	    (is_vlan_dev(gid_attr->ndev) &&
-	     vlan_dev_vlan_id(gid_attr->ndev) != ctx->vlan_id))
+	ret = rdma_read_gid_l2_fields(gid_attr, &vlan_id, NULL);
+	if (ret)
 		return false;
 
-	return true;
+	return ctx->vlan_id == vlan_id;
 }
 
 static const struct ib_gid_attr *
-- 
2.20.1

