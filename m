Return-Path: <SRS0=tjmn=3P=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50CE1C2D0DB
	for <linux-rdma@archiver.kernel.org>; Sun, 26 Jan 2020 13:21:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2DEF22071A
	for <linux-rdma@archiver.kernel.org>; Sun, 26 Jan 2020 13:21:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729160AbgAZNVd (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Sun, 26 Jan 2020 08:21:33 -0500
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:43674 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729147AbgAZNVd (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Sun, 26 Jan 2020 08:21:33 -0500
Received: from Internal Mail-Server by MTLPINE2 (envelope-from maorg@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 26 Jan 2020 15:21:29 +0200
Received: from dev-l-vrt-201.mtl.labs.mlnx (dev-l-vrt-201.mtl.labs.mlnx [10.134.201.1])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 00QDLTp4002251;
        Sun, 26 Jan 2020 15:21:29 +0200
From:   Maor Gottlieb <maorg@mellanox.com>
To:     j.vosburgh@gmail.com, vfalico@gmail.com, andy@greyhouse.net,
        jiri@mellanox.com, davem@davemloft.net
Cc:     Maor Gottlieb <maorg@mellanox.com>, netdev@vger.kernel.org,
        saeedm@mellanox.com, jgg@mellanox.com, leonro@mellanox.com,
        alexr@mellanox.com, markz@mellanox.com, parav@mellanox.com,
        eranbe@mellanox.com, linux-rdma@vger.kernel.org
Subject: [RFC PATCH 1/4] net/core: Introduce master_xmit_slave_get
Date:   Sun, 26 Jan 2020 15:21:23 +0200
Message-Id: <20200126132126.9981-2-maorg@mellanox.com>
X-Mailer: git-send-email 2.17.2
In-Reply-To: <20200126132126.9981-1-maorg@mellanox.com>
References: <20200126132126.9981-1-maorg@mellanox.com>
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

Add new ndo to get the xmit slave of master device.
When slave selection method is based on hash, then the user can ask to
get the xmit slave assume all the slaves can transmit by setting the
LAG_FLAGS_HASH_ALL_SLAVES bit in the flags argument.

Signed-off-by: Maor Gottlieb <maorg@mellanox.com>
---
 include/linux/netdevice.h |  3 +++
 include/net/lag.h         | 19 +++++++++++++++++++
 2 files changed, 22 insertions(+)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 11bdf6cb30bd..faba4aa094e5 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -1379,6 +1379,9 @@ struct net_device_ops {
 						 struct netlink_ext_ack *extack);
 	int			(*ndo_del_slave)(struct net_device *dev,
 						 struct net_device *slave_dev);
+	struct net_device*	(*ndo_xmit_slave_get)(struct net_device *master_dev,
+						      struct sk_buff *skb,
+						      int lag);
 	netdev_features_t	(*ndo_fix_features)(struct net_device *dev,
 						    netdev_features_t features);
 	int			(*ndo_set_features)(struct net_device *dev,
diff --git a/include/net/lag.h b/include/net/lag.h
index 95b880e6fdde..c710daf8f57a 100644
--- a/include/net/lag.h
+++ b/include/net/lag.h
@@ -6,6 +6,25 @@
 #include <linux/if_team.h>
 #include <net/bonding.h>
 
+enum lag_get_slaves_flags {
+	LAG_FLAGS_HASH_ALL_SLAVES = 1<<0
+};
+
+static inline
+struct net_device *master_xmit_slave_get(struct net_device *master_dev,
+					 struct sk_buff *skb,
+					 int flags)
+{
+	const struct net_device_ops *ops = master_dev->netdev_ops;
+	struct net_device *slave = NULL;
+
+	rcu_read_lock();
+	if (ops->ndo_xmit_slave_get)
+		slave = ops->ndo_xmit_slave_get(master_dev, skb, flags);
+	rcu_read_unlock();
+	return slave;
+}
+
 static inline bool net_lag_port_dev_txable(const struct net_device *port_dev)
 {
 	if (netif_is_team_port(port_dev))
-- 
2.17.2

