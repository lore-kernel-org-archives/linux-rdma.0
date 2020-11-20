Return-Path: <linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31018C64E8A
	for <linux-rdma@archiver.kernel.org>; Fri, 20 Nov 2020 23:04:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D76A02240C
	for <linux-rdma@archiver.kernel.org>; Fri, 20 Nov 2020 23:04:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=nvidia.com header.i=@nvidia.com header.b="HQoS5O7R"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728810AbgKTXEO (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Fri, 20 Nov 2020 18:04:14 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:1194 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728625AbgKTXEL (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Fri, 20 Nov 2020 18:04:11 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fb84b5f0007>; Fri, 20 Nov 2020 15:03:59 -0800
Received: from sx1.mtl.com (172.20.13.39) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 20 Nov
 2020 23:04:01 +0000
From:   Saeed Mahameed <saeedm@nvidia.com>
To:     Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leonro@mellanox.com>
CC:     <netdev@vger.kernel.org>, <linux-rdma@vger.kernel.org>,
        Aya Levin <ayal@nvidia.com>, Moshe Shemesh <moshe@nvidia.com>
Subject: [PATCH mlx5-next 09/16] net/mlx5: Expose IP-in-IP TX and RX capability bits
Date:   Fri, 20 Nov 2020 15:03:32 -0800
Message-ID: <20201120230339.651609-10-saeedm@nvidia.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201120230339.651609-1-saeedm@nvidia.com>
References: <20201120230339.651609-1-saeedm@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-Originating-IP: [172.20.13.39]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1605913439; bh=W6pKMuf/KgnwGNgqWgjk8dGoJtcl++rqCeAwoa4ckxs=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
         References:MIME-Version:Content-Transfer-Encoding:Content-Type:
         X-Originating-IP:X-ClientProxiedBy;
        b=HQoS5O7RToFSZp0xF86okH05P6FhmcCvOT19ACgLv2Nn5duG2P9EkkThuEf5irUYQ
         7BCKWhzAJlmkcKpMSV/PToU7IBqexxdJFCx79tQgc40+hJYABHKd86L5VZJxLRgDWr
         4DXQW9CYNYRR/+L2kfYq3Qx9hr7Lrdurh5LB/pFUcNNyieHN33yXeW21+VjVHcxx2u
         TqvOiu8yaNClt17SZWbwSQKeMWZXVMs1Wvriu7MVr5Z2vrfndlN8ZFP1nSEV/APe3G
         ysTlGiNASQi9aDqWL2FgN3npnLy/mdBdldvpNVNQGMH7lXTgnxkddgH8LzIaLQh/b+
         fMZJQMkT3CXFQ==
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

From: Aya Levin <ayal@nvidia.com>

Expose FW indication that it supports stateless offloads for IP over IP
tunneled packets per direction. In some HW like ConnectX-4 IP-in-IP
support is not symmetric, it supports steering on the inner header but
it doesn't TX-Checksum and TSO. Add IP-in-IP capability per direction to
cover this case as well.

Note: only if both indications are turned on, the global
tunnel_stateless_ip_over_ip is on too.

Signed-off-by: Aya Levin <ayal@nvidia.com>
Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 include/linux/mlx5/mlx5_ifc.h | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index 3ace1976514c..96888f9f822d 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -913,7 +913,10 @@ struct mlx5_ifc_per_protocol_networking_offload_caps_b=
its {
 	u8         tunnel_stateless_ipv4_over_vxlan[0x1];
 	u8         tunnel_stateless_ip_over_ip[0x1];
 	u8         insert_trailer[0x1];
-	u8         reserved_at_2b[0x5];
+	u8         reserved_at_2b[0x1];
+	u8         tunnel_stateless_ip_over_ip_rx[0x1];
+	u8         tunnel_stateless_ip_over_ip_tx[0x1];
+	u8         reserved_at_2e[0x2];
 	u8         max_vxlan_udp_ports[0x8];
 	u8         reserved_at_38[0x6];
 	u8         max_geneve_opt_len[0x1];
--=20
2.26.2

