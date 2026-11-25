Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.53.29
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795640852;
	b=uc55isqZ7H7pSODDxeJcUSzdVZ0xTHNN7h6n/wGgv/nhhpsOrx45GynxPbLkn7MlYY9j
	 KEZKGLL2KHfryNV4tj7OY2oJpdJZvdEDUfBhzzq0PysTCRcpt4tbiFZ5Z72MTME9GdgqB
	 ATi27u4g0f1mPOqq2lHl5/uGzcux2e/CSxY9htbdYD2JNnHRiGkBrWRLjPGQOM/mRWCsD
	 IpKU3aSAkGtj8/9THY/GKKfpceqiiYVD4zSv46H0hG4dsBG6frPNvNV8MhZhbaFNDbUji
	 kC6zVwzZqtEJ4o5isRN6P7swABSZuNKokH3uZ7lw6QuWdG5fhnY19seEvv5GgApbGoA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795640852;
	h=DMARC-Filter:DKIM-Signature:Received:Received:
	 X-MS-Exchange-Authentication-Results:Received-SPF:Received:Received:
	 Received:Received:From:To:CC:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding:Content-Type:
	 X-NV-OnPremToCloud:X-EOPAttributedMessage:X-MS-PublicTrafficType:
	 X-MS-TrafficTypeDiagnostic:X-MS-Office365-Filtering-Correlation-Id:
	 X-MS-Exchange-SenderADCheck:X-MS-Exchange-AntiSpam-Relay:
	 X-Microsoft-Antispam:X-Microsoft-Antispam-Message-Info:
	 X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-Id:
	 X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=Bg92odu+cc/7Q4gqQaN/vA3rfaBulA1BRn21Y7oRcok=;
	b=KxFzFuiHiFTadOyVNwPlhG5N7HLIg5Do5nSeGYgJpsqsZ4jH3X7dcrxfTxFj8r9k7H9V
	 9h+5fcMZ/J2uOyFI4P7TataSzb3xdehUWIkesBvjDV78+KbZM0vpdKlc05Xtr+ivzdOZq
	 C6cjSNbpRyV8qN2o+rqzIwLAQh5mVVTajGUwDiEpPXpdDvYvqKhiz027THuRO55Vo4rDT
	 A0ksDPtPo9ux982B4xho7m9othbb4uPmfc49+shgZpQrC83ViyRX4hejHPHj/gnxAN7FP
	 5c1f+/x9x72UcNQSTGx1DC981fju9B/1rtA7ZP0xGi9lX9IlqospgC1nVauGRvElODg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=SpK9CScD;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.53.29
Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazon11012029.outbound.protection.outlook.com [52.101.53.29])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7123606A31E;
	Wed, 25 Nov 2026 21:07:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B7123606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=SpK9CScD
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WjvD0WLZHvR9XwWibtTbLQrHN80G+ZTjenMPSXOiGNB2E4MQd+CWRINXb14LkgR6ZJqTTG/Qwcfxw8za/AcdAAh87YiLMJVACRNshZoc51iSh/A9WYjKyR7scjQDmyN7EGWv9JnH7EckhqesaLzAxHtzYASKL6hgMrfCDHxk9nuA52d22wiSSWj+02uQFICOv95xNqQsxRLlgk9th6fYRG2YzYuwi2+piCtHn2x7mD3rasnqLWkSUrJom9dSzxsse6udEEmXYJqjP2MZzRxZz9u2HVp8lrDiTKQ7kzHXyFdfAFcw8XeYPf/jciidUS4Uyd2MFaoX09ZGZljDLlIr/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Bg92odu+cc/7Q4gqQaN/vA3rfaBulA1BRn21Y7oRcok=;
 b=xpy41vJb2nNkY/Z8bt+vlG3asS7lRVZi/ajfUcd6WEhdX9mP9eJ4sqkQSzPqDfyug9HyaVUVTU5DBF7WcTRG63VrTtawQAS2hdCLchYplRdBP/tJbR7ZjDG8gVDWO14zzwwLd+3ZSXWuD6XLgVpc8sBYZ53mwFuK/ZA5mCrYg2M3dsQzrvzsnYjdglIp5k6zHO2Wpj2KD01zcy/6A1D3jqDC7BtQ3YBIWipUrM5pILWHC9RgR7L3gL7n1G8aPVWRcxDFCk5ttsFDhiUNsljF5SK1gyJkL3V4AV3E+7FHPQNpZ7vg0VHngvjLPlhdoZ0qPQK42xa8jhjT8n2HRSvfsw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Bg92odu+cc/7Q4gqQaN/vA3rfaBulA1BRn21Y7oRcok=;
 b=SpK9CScDiIpjdnGGnwbE/5ducRV5ti4imk4V6uKEytNFt6g7+VF4teUFBk1Bk4mus3hrw2KcIESmVkzyPdaV8S+l7eSgk7OfpiA1mwZIDDFJgEVrQ5WqYpjbmiDewBnXDoWVmlbyfWJqliRW7ulTqXAEZWLue9lM+Z9xqSE5Bfsg4V/xnGdHYRM9hZxjsNNXp/1wQnAWJCn0aewsi7WInHYkRzaBa9hX2tHEPRYP9KXZM4HPGHe5U+MWCsyihz4w3V5jYMpxUNNoxpbkYGSci4NP9Menr+ibt0VA1Jw1WEYsvgppRMfdg8jcT167y3INSzM0f6oalyjNyVyfwSGRZQ==
Received: from IA1P220CA0048.NAMP220.PROD.OUTLOOK.COM (2603:10b6:208:462::17)
 by IA0PR12MB9048.namprd12.prod.outlook.com (2603:10b6:208:408::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.639.12; Wed, 25 Nov
 2026 21:07:18 +0000
Received: from MN7PEPF0000014E.namprd04.prod.outlook.com
 (2603:10b6:208:462:cafe::37) by IA1P220CA0048.outlook.office365.com
 (2603:10b6:208:462::17) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.662.7 via Frontend Transport; Wed, 25
 Nov 2026 21:07:18 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.118.233) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 MN7PEPF0000014E.mail.protection.outlook.com (10.167.254.40) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.662.3 via Frontend Transport; Wed, 25 Nov 2026 21:07:17 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.57; Wed, 25 Nov
 2026 13:06:56 -0800
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.57; Wed, 25 Nov 2026 13:06:55 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server id 15.2.2562.57 via Frontend
 Transport; Wed, 25 Nov 2026 13:06:51 -0800
From: Tariq Toukan <tariqt@nvidia.com>
To: Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
	<davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>, Jakub Kicinski
	<kuba@kernel.org>, <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Willem de Bruijn <willemb@google.com>
CC: Fernando Fernandez Mancera <fmancera@suse.de>, Gal Pressman
	<gal@nvidia.com>, Ido Schimmel <idosch@nvidia.com>, Jianbo Liu
	<jianbol@nvidia.com>, Kuniyuki Iwashima <kuniyu@google.com>, Leon Romanovsky
	<leon@kernel.org>, <linux-rdma@vger.kernel.org>, Maor Dickman
	<maord@nvidia.com>, Mark Bloch <mbloch@nvidia.com>, Nikolay Aleksandrov
	<razor@blackwall.org>, Roi Dayan <roid@nvidia.com>, Saeed Mahameed
	<saeedm@nvidia.com>, Shay Drory <shayd@nvidia.com>, Tariq Toukan
	<tariqt@nvidia.com>
Subject: [PATCH net] net/mlx5e: TC, use the owner eswitch for encap neigh updates
Date: Wed, 25 Nov 2026 23:06:29 +0200
Message-ID: <20261125210629.239095-1-tariqt@nvidia.com>
X-Mailer: git-send-email 2.44.0
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN7PEPF0000014E:EE_|IA0PR12MB9048:EE_
X-MS-Office365-Filtering-Correlation-Id: 263916cb-f5f7-47d5-e877-08df4b3816c0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|36860700016|23010399003|7416014|376014|18002099003|11063799006|261022075727099003|56012099006|261021121427099003|261028144727099003|261009223027099003|261102123227099003|10067099003|261021123027099003|261026121527099003|261026140227099003|261022105027099003;
X-Microsoft-Antispam-Message-Info:
	0dyrO1AMr2yc82XBA0tDSs6tVgeqhF0m0l6ee/TZAElYvmj+t899AxwswudoiVQHqAtgEzh00Eec9qE9eqk+wPXrR01lYuVS2jun8C80ahKfmb/qiguDSYPT4HzducJR2cg6sCXzOOsbu1v3A3GKQYKVFLE7Vu+/b0uNSWOZdaOiSzgdeMEFbsDa4GgyZUbECNnIFjMd0D3jyfpofwr3lK+BJJN1bONjEeTkP3vTe4cT6D7vWa0s1S11HWOEw1X6qBUNJ6FtXap6vBdlV04vPY4URfq4fbJgFVvnIpg+FMKOBpFFJaJC3LtEDQF2ETkUt77qZ33VGOQVT6h23uYf7vRPuK2pj9stzJ3FchthDQmwu617SAdz5nKqynTk8pFGEJyW3jca8U/LwBdceRy4JmymFoedIt8N04zVX7F7xu1eoRGqitSpoKAJVNzZqklh4KOu8TqujRP3pK8HIMFXTgBm42G2lNHVl7G8AxNF//BFI/TJOZWG4Do/dmcjN/c4GCL5cTF2z9hK6q2zE6Icb0XAkNXpyvdV4VFW0cVDlYqg7qEq7ZO7eKOZptRJ1KuEphCcLzDCztn2cjg/CvtJJTSPYO2q7SQcM6RhsopyPUSaYd911WOVCoYTMcvaegeYM3GdTG4hBREAcXOyY7C2DbIkp7h7j+0jvy45SlvnAnf44KgNEYbqJt5Y9yIf7pzGkEFyNz9LcEkorqiHc9XfYQ==
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(36860700016)(23010399003)(7416014)(376014)(18002099003)(11063799006)(261022075727099003)(56012099006)(261021121427099003)(261028144727099003)(261009223027099003)(261102123227099003)(10067099003)(261021123027099003)(261026121527099003)(261026140227099003)(261022105027099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	XrCG2HDclPhKotB8hVr3HADTSOoAKP6KyLR75N2YDxopfq/Tb5miWGTys5hPy5/ZezxJiKZSEWDWtqUOsdquab2nad3CzkRU15Mdh/RxBA362EpzL6V7AUs3ZUGqDgdAaxAJT2gMqepO+a2dq17AfOlCH923RssZzyYBIhrOlyrUj3BU+13Wc5fclyAJ03yVLTb03FJuKlbcXc+7UKKMWEZ8lyK+8OD6Z1g+H9z9fLftmkpFDWCPnRM+zLlALdJIPvwXtqRuPgKrBO6dLVrFGhRTolQYi8t3cRg3oaRorBrj29psuwzWShpiQzJGtHPAQEDcIIvKgz9MfmDvvbicOgkimrTHJzB+Cp0/pj1SkU0qSB7fa+RTNCw0zZ68CEJ8tKEPwt77LRiNuWPQFj+OquDcFQ9CoCuTr677Rp5XgqkI57+TB+i7PQMXytUbZfOc
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Nov 2026 21:07:17.9186
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 263916cb-f5f7-47d5-e877-08df4b3816c0
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MN7PEPF0000014E.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB9048

From: Shay Drory <shayd@nvidia.com>

Encap entries are kept in the encap table of the eswitch of the flows
that use them, while the neigh hash entry is attached to the out_dev
uplink. The neigh update and neigh-used paths took the eswitch from
netdev_priv(e->out_dev), assuming out_dev is always the uplink of the
owner eswitch.

Since MPESW peer flows were added, an encap entry of one eswitch can
route through the uplink of another eswitch. A neigh update on that
uplink then:
- takes the wrong encap_tbl_lock,
- adds the slow path rule to the other eswitch's FDB chains, where it
  shares a match with the origin flow's rule, while the flow later
  removes it from its own eswitch chains. This unbalances the fs_chains
  refcount ("Couldn't find table", leaked flow tables on unload) and
  with HWS, which emulates same-match NO_APPEND rules with a single
  pending rule, fails the origin's slow path update with -EEXIST,
- allocates the packet reformat on the other device, which the owner
  eswitch FDB rejects on HWS.

Record the owner eswitch uplink priv in the encap entry and use it for
flow updates and entry release, keeping out_dev for neigh handling.

Fixes: 8ce81fc01b52 ("net/mlx5e: TC, Add peer flow in mpesw mode")
Signed-off-by: Shay Drory <shayd@nvidia.com>
Reviewed-by: Jianbo Liu <jianbol@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/rep/neigh.c    | 2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c       | 3 ++-
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c | 7 ++++---
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.h          | 1 +
 4 files changed, 8 insertions(+), 5 deletions(-)

---

Answer to an internal sashiko comment:

Could mlx5e_attach_encap() preserve the owner's initialized profile
resources until all foreign neighbour users have finished?
When an mpesw encap owned by uplink B routes through uplink A, unbinding
B's eth-rep auxiliary device can overlap A's neighbour work. In
drivers/net/ethernet/mellanox/mlx5/core/en_rep.c, mlx5e_rep_remove() reaches
owner profile teardown through:
    mlx5_eswitch_unregister_vport_reps()
      -> mlx5e_vport_rep_unload()
      -> mlx5e_vport_uplink_rep_unload()
      -> mlx5e_netdev_change_profile()
Unlike normal eswitch disable, this path does not first synchronously
unpair peers. The peer flow created by mlx5e_tc_add_fdb_peer_flow() in
drivers/net/ethernet/mellanox/mlx5/core/en_tc.c is stored on the originating
flow's peer_flows list, rather than B's tc_ht, so B's table cleanup need
not remove the encap.
In drivers/net/ethernet/mellanox/mlx5/core/en/rep/neigh.c,
mlx5e_rep_neigh_cleanup() drains B's work, not A's callbacks.
mlx5e_rep_neigh_update() on A now passes this borrowed owner to
mlx5e_rep_update_flows() in
drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c, which dereferences
priv->mdev->priv.eswitch.
The callback holds the rtnl lock, but mlx5e_netdev_change_profile() in
drivers/net/ethernet/mellanox/mlx5/core/en_main.c performs profile cleanup
after mlx5e_uplink_rep_disable() releases that lock. mlx5e_priv_cleanup()
then clears priv with memset(priv, 0, sizeof(*priv)).
Can A's callback therefore dereference a cleared owner->mdev and oops,
or access destroyed owner tc resources during profile replacement?
mlx5e_tc_update_neigh_used_value() and mlx5e_get_next_matching_encap() in
drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c also now use this
owner, including for iterator release. An encap reference or a retained
netdev allocation does not preserve those initialized profile resources.
Could owner teardown synchronously remove these foreign encap users and
wait for their callbacks before resetting the profile?

[SD] The stored priv does not add a new lifetime dependency. It has the
same lifetime as flow->priv of the peer flows attached to the entry,
which mlx5e_tc_add_fdb_peer_flow() creates on the peer uplink priv, and
which the neigh update path already dereferenced before this patch,
e.g. in mlx5e_tc_unoffload_fdb_rules() and get_mod_hdr_table(). All
teardown paths (unload, reload, eswitch mode change, module exit)
unpair the eswitches in esw_offloads_disable(), which removes the peer
flows, before the owner uplink representor is unloaded. The window is
only reachable by a manual eth-rep auxiliary unbind while paired, which
this patch does not change.

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/rep/neigh.c b/drivers/net/ethernet/mellanox/mlx5/core/en/rep/neigh.c
index 6a8d8aac7d16..a93138692371 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/rep/neigh.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/rep/neigh.c
@@ -167,7 +167,7 @@ static void mlx5e_rep_neigh_update(struct work_struct *work)
 	 * the next one.
 	 */
 	while ((e = mlx5e_get_next_init_encap(nhe, e)) != NULL)
-		mlx5e_rep_update_flows(netdev_priv(e->out_dev), e, neigh_connected, ha);
+		mlx5e_rep_update_flows(e->priv, e, neigh_connected, ha);
 
 out:
 	rtnl_unlock();
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c
index e1ebc9b2d061..d43c1d7d5281 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c
@@ -117,7 +117,8 @@ void mlx5e_rep_update_flows(struct mlx5e_priv *priv,
 		/* Update the encap source mac, in case that we delete
 		 * the flows when encap source mac changed.
 		 */
-		route_dev = __dev_get_by_index(dev_net(priv->netdev), e->route_dev_ifindex);
+		route_dev = __dev_get_by_index(dev_net(e->out_dev),
+					       e->route_dev_ifindex);
 		if (route_dev)
 			ether_addr_copy(eth->h_source, route_dev->dev_addr);
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c
index 4f9f8beffbc8..d23cf60613ea 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c
@@ -177,7 +177,7 @@ void mlx5e_tc_encap_flows_add(struct mlx5e_priv *priv,
 		return;
 	}
 	e->flags |= MLX5_ENCAP_ENTRY_VALID;
-	mlx5e_rep_queue_neigh_stats_work(priv);
+	mlx5e_rep_queue_neigh_stats_work(netdev_priv(e->out_dev));
 
 	list_for_each_entry(flow, flow_list, tmp_list) {
 		if (!mlx5e_is_offloaded_flow(flow) || !flow_flag_test(flow, SLOW))
@@ -348,7 +348,7 @@ mlx5e_get_next_matching_encap(struct mlx5e_neigh_hash_entry *nhe,
 
 	/* release starting encap */
 	if (e)
-		mlx5e_encap_put(netdev_priv(e->out_dev), e);
+		mlx5e_encap_put(e->priv, e);
 	if (!next)
 		return next;
 
@@ -401,7 +401,7 @@ void mlx5e_tc_update_neigh_used_value(struct mlx5e_neigh_hash_entry *nhe)
 	 * next one.
 	 */
 	while ((e = mlx5e_get_next_valid_encap(nhe, e)) != NULL) {
-		struct mlx5e_priv *priv = netdev_priv(e->out_dev);
+		struct mlx5e_priv *priv = e->priv;
 		struct encap_flow_item *efi, *tmp;
 		struct mlx5_eswitch *esw;
 		LIST_HEAD(flow_list);
@@ -871,6 +871,7 @@ int mlx5e_attach_encap(struct mlx5e_priv *priv,
 	init_completion(&e->res_ready);
 	entry_created = true;
 	INIT_LIST_HEAD(&e->route_list);
+	e->priv = netdev_priv(mlx5_eswitch_uplink_get_proto_dev(esw, REP_ETH));
 
 	tun_info = mlx5e_dup_tun_info(tun_info);
 	if (!tun_info) {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.h b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.h
index bcd7b4e814d0..4be0b9fe94cd 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.h
@@ -211,6 +211,7 @@ struct mlx5e_encap_entry {
 	struct mlx5e_mpls_info mpls_info;
 	unsigned char h_dest[ETH_ALEN];	/* destination eth addr	*/
 
+	struct mlx5e_priv *priv;
 	struct net_device *out_dev;
 	int route_dev_ifindex;
 	struct mlx5e_tc_tunnel *tunnel;

base-commit: cc7fe6e741730fef549e484379281736d32746f0
-- 
2.44.0

