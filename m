Return-Path: <SRS0=nnSp=6G=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF237C55186
	for <linux-rdma@archiver.kernel.org>; Wed, 22 Apr 2020 08:40:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CF3D8206B9
	for <linux-rdma@archiver.kernel.org>; Wed, 22 Apr 2020 08:40:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726685AbgDVIkl (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Wed, 22 Apr 2020 04:40:41 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:36691 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726082AbgDVIkD (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Wed, 22 Apr 2020 04:40:03 -0400
Received: from Internal Mail-Server by MTLPINE2 (envelope-from maorg@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 22 Apr 2020 11:39:59 +0300
Received: from dev-l-vrt-201.mtl.labs.mlnx (dev-l-vrt-201.mtl.labs.mlnx [10.134.201.1])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 03M8dxgj006118;
        Wed, 22 Apr 2020 11:39:59 +0300
From:   Maor Gottlieb <maorg@mellanox.com>
To:     davem@davemloft.net, jgg@mellanox.com, dledford@redhat.com,
        j.vosburgh@gmail.com, vfalico@gmail.com, andy@greyhouse.net,
        kuba@kernel.org, jiri@mellanox.com, dsahern@kernel.org
Cc:     leonro@mellanox.com, saeedm@mellanox.com,
        linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        alexr@mellanox.com, Maor Gottlieb <maorg@mellanox.com>
Subject: [PATCH V4 mlx5-next 07/15] bonding: Add function to get the xmit slave in active-backup mode
Date:   Wed, 22 Apr 2020 11:39:43 +0300
Message-Id: <20200422083951.17424-8-maorg@mellanox.com>
X-Mailer: git-send-email 2.17.2
In-Reply-To: <20200422083951.17424-1-maorg@mellanox.com>
References: <20200422083951.17424-1-maorg@mellanox.com>
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

Add helper function to get the xmit slave in active-backup mode.
It's only one line function that return the curr_active_slave,
but it will used both in the xmit flow and by the new .ndo to get
the xmit slave.

Signed-off-by: Maor Gottlieb <maorg@mellanox.com>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
Reviewed-by: Jay Vosburgh <jay.vosburgh@canonical.com>
---
 drivers/net/bonding/bond_main.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index 09c8485e965d..1b0ae750d732 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -4042,6 +4042,12 @@ static netdev_tx_t bond_xmit_roundrobin(struct sk_buff *skb,
 	return NETDEV_TX_OK;
 }
 
+static struct slave *bond_xmit_activebackup_slave_get(struct bonding *bond,
+						      struct sk_buff *skb)
+{
+	return rcu_dereference(bond->curr_active_slave);
+}
+
 /* In active-backup mode, we know that bond->curr_active_slave is always valid if
  * the bond has a usable interface.
  */
@@ -4051,7 +4057,7 @@ static netdev_tx_t bond_xmit_activebackup(struct sk_buff *skb,
 	struct bonding *bond = netdev_priv(bond_dev);
 	struct slave *slave;
 
-	slave = rcu_dereference(bond->curr_active_slave);
+	slave = bond_xmit_activebackup_slave_get(bond, skb);
 	if (slave)
 		bond_dev_queue_xmit(bond, skb, slave->dev);
 	else
-- 
2.17.2

