Return-Path: <linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C65EC433E9
	for <linux-rdma@archiver.kernel.org>; Wed, 13 Jan 2021 19:28:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BBE222310F
	for <linux-rdma@archiver.kernel.org>; Wed, 13 Jan 2021 19:28:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728647AbhAMT23 (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Wed, 13 Jan 2021 14:28:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:55880 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728610AbhAMT22 (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Wed, 13 Jan 2021 14:28:28 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DAB1D2311F;
        Wed, 13 Jan 2021 19:27:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610566067;
        bh=+Eqb/rZXyhN3y+aVdpfVsqxnltGHkvsN2fzZyf4Lp24=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TW7LMdZts2h69DaRvbPcHsxzIZOsgbNHHPbrJ4997RfD2EEN2EwuZ0S9qvgb12y+k
         jCCwNd4r+bU98WPM126mVcC0OFIS/OC0n7yOMlPNM0719sPD0Fco+4QO/xdfKrUurZ
         aqypedsuTZonHoddfxh8IUPgYetw5JlSeVyoNHbrMgNUcaVbBrLSMtAzq9+c+piUwt
         W1dxxhOZg307xVIdeio5JHTCSTBBo1DA7+Gh9l5lLQbIeJb7U/8V+uOvojObjlrrj3
         xywiVGpDiz/AyyHN3N+smPGNcanYinehpGDGdxWOac4rLff+ua+rricoCxBwpasT93
         fNqxu/TJTSUOg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jason Gunthorpe <jgg@nvidia.com>
Cc:     netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        Leon Romanovsky <leonro@nvidia.com>,
        Parav Pandit <parav@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        Vu Pham <vuhuong@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next V6 01/14] devlink: Prepare code to fill multiple port function attributes
Date:   Wed, 13 Jan 2021 11:27:17 -0800
Message-Id: <20210113192730.280656-2-saeed@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210113192730.280656-1-saeed@kernel.org>
References: <20210113192730.280656-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

From: Parav Pandit <parav@nvidia.com>

Prepare code to fill zero or more port function optional attributes.
Subsequent patch makes use of this to fill more port function
attributes.

changelog:
v5->v6:
 - change function name from 'port_function' to 'port_fn'
 - align to 80 characters limit

Signed-off-by: Parav Pandit <parav@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Reviewed-by: Vu Pham <vuhuong@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 net/core/devlink.c | 64 ++++++++++++++++++++++++----------------------
 1 file changed, 33 insertions(+), 31 deletions(-)

diff --git a/net/core/devlink.c b/net/core/devlink.c
index ee828e4b1007..c39496311b71 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -712,6 +712,31 @@ static int devlink_nl_port_attrs_put(struct sk_buff *msg,
 	return 0;
 }
 
+static int
+devlink_port_fn_hw_addr_fill(struct devlink *devlink, const struct devlink_ops *ops,
+			     struct devlink_port *port, struct sk_buff *msg,
+			     struct netlink_ext_ack *extack, bool *msg_updated)
+{
+	u8 hw_addr[MAX_ADDR_LEN];
+	int hw_addr_len;
+	int err;
+
+	if (!ops->port_function_hw_addr_get)
+		return 0;
+
+	err = ops->port_function_hw_addr_get(devlink, port, hw_addr, &hw_addr_len, extack);
+	if (err) {
+		if (err == -EOPNOTSUPP)
+			return 0;
+		return err;
+	}
+	err = nla_put(msg, DEVLINK_PORT_FUNCTION_ATTR_HW_ADDR, hw_addr_len, hw_addr);
+	if (err)
+		return err;
+	*msg_updated = true;
+	return 0;
+}
+
 static int
 devlink_nl_port_function_attrs_put(struct sk_buff *msg, struct devlink_port *port,
 				   struct netlink_ext_ack *extack)
@@ -719,36 +744,17 @@ devlink_nl_port_function_attrs_put(struct sk_buff *msg, struct devlink_port *por
 	struct devlink *devlink = port->devlink;
 	const struct devlink_ops *ops;
 	struct nlattr *function_attr;
-	bool empty_nest = true;
-	int err = 0;
+	bool msg_updated = false;
+	int err;
 
 	function_attr = nla_nest_start_noflag(msg, DEVLINK_ATTR_PORT_FUNCTION);
 	if (!function_attr)
 		return -EMSGSIZE;
 
 	ops = devlink->ops;
-	if (ops->port_function_hw_addr_get) {
-		int hw_addr_len;
-		u8 hw_addr[MAX_ADDR_LEN];
-
-		err = ops->port_function_hw_addr_get(devlink, port, hw_addr, &hw_addr_len, extack);
-		if (err == -EOPNOTSUPP) {
-			/* Port function attributes are optional for a port. If port doesn't
-			 * support function attribute, returning -EOPNOTSUPP is not an error.
-			 */
-			err = 0;
-			goto out;
-		} else if (err) {
-			goto out;
-		}
-		err = nla_put(msg, DEVLINK_PORT_FUNCTION_ATTR_HW_ADDR, hw_addr_len, hw_addr);
-		if (err)
-			goto out;
-		empty_nest = false;
-	}
-
-out:
-	if (err || empty_nest)
+	err = devlink_port_fn_hw_addr_fill(devlink, ops, port, msg,
+					   extack, &msg_updated);
+	if (err || !msg_updated)
 		nla_nest_cancel(msg, function_attr);
 	else
 		nla_nest_end(msg, function_attr);
@@ -986,7 +992,6 @@ devlink_port_function_hw_addr_set(struct devlink *devlink, struct devlink_port *
 	const struct devlink_ops *ops;
 	const u8 *hw_addr;
 	int hw_addr_len;
-	int err;
 
 	hw_addr = nla_data(attr);
 	hw_addr_len = nla_len(attr);
@@ -1011,12 +1016,7 @@ devlink_port_function_hw_addr_set(struct devlink *devlink, struct devlink_port *
 		return -EOPNOTSUPP;
 	}
 
-	err = ops->port_function_hw_addr_set(devlink, port, hw_addr, hw_addr_len, extack);
-	if (err)
-		return err;
-
-	devlink_port_notify(port, DEVLINK_CMD_PORT_NEW);
-	return 0;
+	return ops->port_function_hw_addr_set(devlink, port, hw_addr, hw_addr_len, extack);
 }
 
 static int
@@ -1037,6 +1037,8 @@ devlink_port_function_set(struct devlink *devlink, struct devlink_port *port,
 	if (attr)
 		err = devlink_port_function_hw_addr_set(devlink, port, attr, extack);
 
+	if (!err)
+		devlink_port_notify(port, DEVLINK_CMD_PORT_NEW);
 	return err;
 }
 
-- 
2.26.2

