Return-Path: <SRS0=H9Qn=ZH=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6181C432C3
	for <linux-rdma@archiver.kernel.org>; Fri, 15 Nov 2019 15:22:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9A45B20729
	for <linux-rdma@archiver.kernel.org>; Fri, 15 Nov 2019 15:22:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1573831321;
	bh=x/z2qJWNMWv2Wh/5viM/Dzgh/DVHx9LImIV4gSDNpJo=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=bAefb9OtdWb7gBAcscJ3fiOFhYCp+4Wvt7h5dbLFGJuCIPyYhQSOdrD7OuwWkGA9F
	 jXnFKrm45xmtaGMR8MGUMoFnSaAXTMwGjQ6HNi90iRfHJx64AEksN3yEV9RYECzl2D
	 fMfpcqK/+M4ITot+RAivwU+5WaEWSvrCzl3vdfXQ=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727412AbfKOPWA (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Fri, 15 Nov 2019 10:22:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:39454 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727380AbfKOPWA (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Fri, 15 Nov 2019 10:22:00 -0500
Received: from localhost (unknown [5.29.147.182])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8FFAF206D5;
        Fri, 15 Nov 2019 15:21:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573831320;
        bh=x/z2qJWNMWv2Wh/5viM/Dzgh/DVHx9LImIV4gSDNpJo=;
        h=From:To:Cc:Subject:Date:From;
        b=KIERsZFx9zPpFhPnAZW03nGt/BZrh9lPVMCmiBBaWIGrRn/vhCZPiFpV9JtxVNTA8
         s/65aJuXfggw3Lo3PEEw2VZC61bo3X7d7JoPlagdPdBrX1L3wFpmtuDktenbLnYzln
         k7n4JaR/sccMyEjN+vdUwifxd+unMK1LThzv9/BU=
From:   Leon Romanovsky <leon@kernel.org>
To:     David Ahern <dsahern@gmail.com>
Cc:     Danit Goldberg <danitg@mellanox.com>,
        netdev <netdev@vger.kernel.org>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Leon Romanovsky <leonro@mellanox.com>
Subject: [PATCH iproute2-next v1] ip link: Add support to get SR-IOV VF node GUID and port GUID
Date:   Fri, 15 Nov 2019 17:21:55 +0200
Message-Id: <20191115152155.246821-1-leon@kernel.org>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

From: Danit Goldberg <danitg@mellanox.com>

Extend iplink to show VF GUIDs (IFLA_VF_IB_NODE_GUID, IFLA_VF_IB_PORT_GUID),
giving the ability for user-space application to print GUID values.
This ability is added to the one of setting new node GUID and port GUID values.

Suitable ip link command:
- ip link show <device>

For example:
- ip link set ib4 vf 0 node_guid 22:44:33:00:33:11:00:33
- ip link set ib4 vf 0 port_guid 10:21:33:12:00:11:22:10
- ip link show ib4
ib4: <BROADCAST,MULTICAST> mtu 4092 qdisc noop state DOWN mode DEFAULT group default qlen 256
link/infiniband 00:00:0a:2d:fe:80:00:00:00:00:00:00:ec:0d:9a:03:00:44:36:8d brd 00:ff:ff:ff:ff:12:40:1b:ff:ff:00:00:00:00:00:00:ff:ff:ff:ff
vf 0     link/infiniband 00:00:0a:2d:fe:80:00:00:00:00:00:00:ec:0d:9a:03:00:44:36:8d brd 00:ff:ff:ff:ff:12:40:1b:ff:ff:00:00:00:00:00:00:ff:ff:ff:ff,
spoof checking off, NODE_GUID 22:44:33:00:33:11:00:33, PORT_GUID 10:21:33:12:00:11:22:10, link-state disable, trust off, query_rss off

Signed-off-by: Danit Goldberg <danitg@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
Changelog v0->v1: https://lore.kernel.org/linux-rdma/20191114133126.238128-2-leon@kernel.org
 * Use already preallocated "b1" buffer instead of new one.
---
 ip/ipaddress.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/ip/ipaddress.c b/ip/ipaddress.c
index b72eb7a1..5d877928 100644
--- a/ip/ipaddress.c
+++ b/ip/ipaddress.c
@@ -484,6 +484,24 @@ static void print_vfinfo(FILE *fp, struct ifinfomsg *ifi, struct rtattr *vfinfo)
 				   vf_spoofchk->setting);
 	}

+	if (vf[IFLA_VF_IB_NODE_GUID]) {
+		struct ifla_vf_guid *guid = RTA_DATA(vf[IFLA_VF_IB_NODE_GUID]);
+		uint64_t node_guid = ntohll(guid->guid);
+
+		print_string(PRINT_ANY, "node guid", ", NODE_GUID %s",
+			     ll_addr_n2a((const unsigned char *)&node_guid,
+					 RTA_PAYLOAD(vf[IFLA_VF_IB_NODE_GUID]),
+					 ARPHRD_INFINIBAND, b1, sizeof(b1)));
+	}
+	if (vf[IFLA_VF_IB_PORT_GUID]) {
+		struct ifla_vf_guid *guid = RTA_DATA(vf[IFLA_VF_IB_PORT_GUID]);
+		uint64_t port_guid = ntohll(guid->guid);
+
+		print_string(PRINT_ANY, "port guid", ", PORT_GUID %s",
+			     ll_addr_n2a((const unsigned char *)&port_guid,
+					 RTA_PAYLOAD(vf[IFLA_VF_IB_PORT_GUID]),
+					 ARPHRD_INFINIBAND, b1, sizeof(b1)));
+	}
 	if (vf[IFLA_VF_LINK_STATE]) {
 		struct ifla_vf_link_state *vf_linkstate =
 			RTA_DATA(vf[IFLA_VF_LINK_STATE]);
--
2.20.1

