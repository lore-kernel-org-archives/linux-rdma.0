Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazon11010004.outbound.protection.outlook.com [52.101.193.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3AEB3C3F54;
	Thu, 30 Jul 2026 21:03:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.193.4
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785445393; cv=fail; b=hyRQBCT2alE9O6VAWkbtiVNQVtZZNPt5e5zsR/nBRnntUk6jrfE721b2Qdx3E9m+btD2D0uGvjsmmm53WO277SB4aF6h4Xtmw1edyhDJOc7xTv+FkSlPPB9kVFBxnpazDHt58y283jVESC2c9cxLuYnJpIFfIXhFUlAjjA5C0ks=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785445393; c=relaxed/simple;
	bh=uLoZ/etd1sjaLMTrAkAmIr2Dh7soL9IGUorWi79hb20=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=HGjoaDcLoiwNPNdvMA8LbBC8mfWBDpioSQtKJmMBryJqOzZGx8EQtJplEa32c66HeBynUtEfo5bGUzbENrSWNlWMmkaN37o4RhYBsw3GjKdcbHRDknENozEnkCE+o3xz17tuYN0Kc9VLDHVNxZJZ8YGkiVVmlKvjNcgCYvNUP0k=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=NmYrZTl9; arc=fail smtp.client-ip=52.101.193.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="NmYrZTl9"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FVyKqp/z8n62ECAQe0LL62yU/LicWKJIkeCqtwkMsHqYH2uFUtKlO7LyVU46OownJjGh1Wl0dYR6o6QiLdYGrAk+8C5K77en4KJisqgf75j+bep2hPqAKMfPqxk7ZEHEG3CnUF07UEY1ccKndLHKtNdAt3CxHavvLKec0VPyBT5+cGAGcZB/goQqlnaCN8xad1PorvwXbo7HnH2/DWL0YYEFtR5r9/ODM7IlNkjkjPwuWuSYBAvTHBfZ6+RgMnf5ojjUfEcjTH0dLFRWRn+LgMjPnINPgkksnf2Hhn9UFeogwN+nBbZV5YlUU/k8VkW3RjAykHuGtTNLlAWx1PCzsA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=L6NKnFPU/a30YWq1irupNa4nBJK5/iDA/gXzykYfLxM=;
 b=GmnlYcmZDgaQj2K2t/mfHz+Lv6D0oVeFAwu1tkfGGVl0T1RYt0yeerGJxOvnzt9TfExyKSyW43MZTsN38gQOWdjCFvK56IwEFr5nm7S7GmaIDgikEwSIdL+0G8Hg8dYXJM91IzWH/6+S4AjY7GB8/qttRnW3FTYW8RoHzObVK241lauATylDvLJOMDoIJP6+8zp/ME7pnKtLMGnFKsK/MGIME+ESZeEUy1R1dGGmxTYB4sqv1tuDZClnyQg+4ULZsW/iAzvtRXWGpOHAiJzeZMHkUSCyTLeLrDB+NfhTkC0ayap1uXQqCuBha7DmQVXDrzpgrk2en68AF3XcUYT/Ag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=L6NKnFPU/a30YWq1irupNa4nBJK5/iDA/gXzykYfLxM=;
 b=NmYrZTl9CM4eM+lwe9ZCc3fEpAMm5aHldqriEGQ5CwgGAoGb2Jpxl0yf+FP5Agd4+La6It8gVD5RZ0w01sbzMLFJD5agnfOx6wzk7KDSyjtx0ZBa7ZFwPoraX3d/O3UWQ+Wa/BJTDhTUAmqajWOTdng9JE02PAi1n3syyvAWEHwaSlx1XyjA39ROD6FwktoIUzAE6K1tjR061CL5jFiTwplXWIpNTmBpTHl1Cs5/JRXNMv6AfJ63yGu4UewANV21VphHf9ss+OwkuvSWHO37GN8CRIzTWuUyQFZsuW1E1GEspHdPEwV5fJK6Ynp92daXpZ21zy+1bG+3LQNfcVArtA==
Received: from BY5PR03CA0014.namprd03.prod.outlook.com (2603:10b6:a03:1e0::24)
 by CY8PR12MB7124.namprd12.prod.outlook.com (2603:10b6:930:5f::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.270.15; Thu, 30 Jul
 2026 21:02:54 +0000
Received: from MWH0EPF000C618F.namprd02.prod.outlook.com
 (2603:10b6:a03:1e0:cafe::b) by BY5PR03CA0014.outlook.office365.com
 (2603:10b6:a03:1e0::24) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.270.13 via Frontend Transport; Thu,
 30 Jul 2026 21:02:54 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 MWH0EPF000C618F.mail.protection.outlook.com (10.167.249.103) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.292.8 via Frontend Transport; Thu, 30 Jul 2026 21:02:53 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Thu, 30 Jul
 2026 14:02:31 -0700
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Thu, 30 Jul
 2026 14:02:30 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.8)
 with Microsoft SMTP Server id 15.2.2562.20 via Frontend Transport; Thu, 30
 Jul 2026 14:02:26 -0700
From: Tariq Toukan <tariqt@nvidia.com>
To: Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
	<davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Jakub Kicinski
	<kuba@kernel.org>, <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>
CC: Alex Vesker <valex@nvidia.com>, Christian Borntraeger
	<borntraeger@linux.ibm.com>, Gal Pressman <gal@nvidia.com>, Kalesh AP
	<kalesh-anakkur.purayil@broadcom.com>, Kees Cook <kees@kernel.org>, "Leon
 Romanovsky" <leon@kernel.org>, Leon Romanovsky <leonro@nvidia.com>,
	<linux-kernel@vger.kernel.org>, <linux-rdma@vger.kernel.org>, Mark Bloch
	<mbloch@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>, Tariq Toukan
	<tariqt@nvidia.com>, Yevgeny Kliteynik <kliteyn@nvidia.com>
Subject: [PATCH net RESEND] net/mlx5: Use unique names for software steering caches
Date: Fri, 31 Jul 2026 00:02:00 +0300
Message-ID: <20260730210200.2590115-1-tariqt@nvidia.com>
X-Mailer: git-send-email 2.44.0
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWH0EPF000C618F:EE_|CY8PR12MB7124:EE_
X-MS-Office365-Filtering-Correlation-Id: 5b8163d4-948d-4f17-cb74-08deee7dec69
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|376014|7416014|23010399003|36860700016|6133799003|11063799006|13003099007|56012099006|18002099003|10067099003;
X-Microsoft-Antispam-Message-Info:
	4GfDcpIn5DSRSRqZ3f4RE9RwXth/K3OH2NtXw0xI71qSCRIB2q9hQbJegeMajkl4XXjOIEoUHJOB0qij2F/esX9kI9r6QnvGYM/O6Rg9KYPwxHi6T/WoHmOEuXISDjEZQaPzHdJUDpz8h7RbrNBBbKpI4WEGz+oMHmK7xbLINGJyZETdi+o3OE4wSl/h1TX4wf/+aG+fTbqj0AQ6KzInopxa3MANGXRIjHvrPTzPnN6TNF0Y7C0RbHAEYy7IqmBY1p+YQJVoKDmNgQEpi9TKbZE8/1o1yrhQGXZ/rQNriiJz5KkhoJVqAYVhUkslaJsMfFLZZ6ACX0HZUWHM+ucJE0jgZvy22ML2MtW4D3ctHvzb+k1yRymbraH3erIf1fJJESkjgZnrkO9F3jPjY/63juQNODbXh5lh1BKtgKJwtvF8XtJg7UYBERWtC7X2ritf5gEwBfbbY3oHbxr409vdIFlb07JGD4CiycfeQ4wnO5IqNtpJ0pG3az5ei+aAvQ6SfzsS59RJNfXpaq6H6UkCDG73KSqvf2HoV9H7obO3AmL5ZShLSCND4xJln/QIfYdjdWDTqZkF6F0vo0X4Vqvj5j/hALGDbtr1Bb9upgFL63dN+nEoe+qbw3SetuA9oz4oj2/3reyDSlBkS6UtN4f4dK8YxrXCgoFoR9/KTRZ1LByAtUmbOiAhb0Wc/vLWM5UWMjqklcuXDKwfJPem481vNA==
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(376014)(7416014)(23010399003)(36860700016)(6133799003)(11063799006)(13003099007)(56012099006)(18002099003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	1gRRHlQ4H1yAwMce68Ew5wYK3u9V5oDuOY1NBfdtmJ8X0PithwdKCh74iPp+4/IJ7qrbqdaHW5LE2GqARzrhEmyKBZrWX4xHS5YMHFlG9HOfwICuruFeDifRftLDx9mbGFgGxtgEJMFLWnm7uOBNhIqPscgQQK0WwiiP1SnJ0rSxgfd0v0a2nn51PMP8xh3DL1qyuwI/9FqyXPboLYq5jFG+XXmc9yGhxWhN+khfeYkZzFlzbiuh48egynD5yMCPDUUX+y1mwl/r/+5+5ZM16l77YohUPNVd3sTGODNYFqBjLJ2qVFga6+M0Y8P8lyRTwiI2e+04x5niV7gRvns43K3iRpCE+c4Nj+O/tRfEq4uROFvxRQtAbDfxQ2nlD16uu+ENDdnLBX2PTyo/PpB4gGRZO17ddOR1jdqNTMant5De+aLo5xvyM5SnQ2YUtxQU
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jul 2026 21:02:53.6415
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5b8163d4-948d-4f17-cb74-08deee7dec69
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MWH0EPF000C618F.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7124

From: Leon Romanovsky <leonro@nvidia.com>

Each software steering domain creates its own slab caches, but all
domains use the same names. When domains for two devices are alive at
once, the second kmem_cache_create() triggers the following splat:

WARNING: mm/slab_common.c:111 at __kmem_cache_create_args+0xca/0x480, CPU#18: devlink/331372
Modules linked in: act_mirred act_skbedit cls_matchall act_gact cls_flower sch_ingress
vhost_vdpa veth nfnetlink_cttimeout openvswitch macvtap macvlan vfio_ap kvm nf_nat_tftp
nf_conntrack_tftp nsh nf_conncount vfio_pci_core irqbypass scsi_debug vhost_net tap tun
vhost_vsock vmw_vsock_virtio_transport_common vsock vhost nft_masq nft_reject_ipv4 act_csum
cls_u32 sch_htb smc_diag smc ppp_deflate bsd_comp ppp_async crc_ccitt ppp_generic slhc loop
algif_hash af_alg nft_fib_inet nft_fib_ipv4 nft_fib_ipv6 nft_fib nft_reject_inet nf_reject_ipv4
nf_reject_ipv6 nft_reject nft_ct nft_chain_nat nf_nat nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4
nf_tables mlx5_vdpa vdpa mlx5_ib dm_service_time ib_uverbs_support vringh ib_core vhost_iotlb
mlx5_core s390_trng eadm_sch vfio_ccw mdev vfio_iommu_type1 vfio sch_fq_codel drm i2c_core
dm_multipath drm_panel_orientation_quirks uvdevice diag288_wdt watchdog hmac_s390 prng aes_s390
zfcp scsi_transport_fc pkey_pckmo pkey_cca pkey_ep11 zcrypt paes_s390 phmac_s390 rng_core
scsi_dh_alua pkey scsi_dh_rdac scsi_dh_emc crypto_engine autofs4 ecdsa_generic ecc sha512 [last unloaded: openvswitch]
CPU: 18 UID: 0 PID: 331372 Comm: devlink Tainted: G        W           7.2.0-20260712.rc2.git0.e3321fa3034d.300.fc44.s390x+debug #1 PREEMPT
Tainted: [W]=WARN
Hardware name: IBM 9175 ME1 701 (LPAR)
Krnl PSW : 0704c00180000000 0000038139a6771a (__kmem_cache_create_args+0xda/0x480)
            R:0 T:1 IO:1 EX:1 Key:0 M:1 W:0 P:0 AS:3 CC:0 PM:0 RI:0 EA:3
Krnl GPRS: 0000000000000000 0000000000000000 000003813b7de578 00000380b9eb8974
            00000276c417f690 00000380b9eb8974 0000030144623348 00000277234a1660
            0000000000000020 00000380b9eb8974 00000277234a1600 000003813b686d30
            0000000000000000 00000380b9e9a810 0000038139a6771a 0000030144623238
Krnl Code: 0000038139a6770a: c02000ebb737       larl    %r2,000003813b7de578
            0000038139a67710: b9040039           lgr     %r3,%r9
           *0000038139a67714: c0e5006e2eb2       brasl   %r14,000003813a82d478
           >0000038139a6771a: a7390020           lghi    %r3,32
            0000038139a6771e: b9040029           lgr     %r2,%r9
            0000038139a67722: c0e5006cf98f       brasl   %r14,000003813a806a40
            0000038139a67728: ec26018e007c       cgij    %r2,0,6,0000038139a67a44
            0000038139a6772e: 58d0f0a4           l       %r13,164(%r15)
Call Trace:
  [<0000038139a6771a>] __kmem_cache_create_args+0xda/0x480
([<0000038139a676a2>] __kmem_cache_create_args+0x62/0x480)
  [<00000380b9da1c70>] dr_domain_init_mem_resources+0x80/0x240 [mlx5_core]
  [<00000380b9da226e>] dr_domain_init_resources.constprop.0+0x7e/0x2c0 [mlx5_core]
  [<00000380b9da28b2>] mlx5dr_domain_create+0x132/0x250 [mlx5_core]
  [<00000380b9dc1e20>] mlx5_cmd_dr_create_ns+0x30/0x90 [mlx5_core]
  [<00000380b9cd8dbe>] mlx5_flow_namespace_set_mode+0x6e/0x130 [mlx5_core]
  [<00000380b9d846ec>] esw_create_offloads_fdb_tables+0xac/0x5a0 [mlx5_core]
  [<00000380b9d865b6>] esw_offloads_steering_init+0x1c6/0x480 [mlx5_core]
  [<00000380b9d86e8e>] esw_offloads_enable+0x13e/0x410 [mlx5_core]
  [<00000380b9d7b04a>] mlx5_eswitch_enable_locked+0x36a/0x540 [mlx5_core]
  [<00000380b9d84ff0>] esw_offloads_start+0x50/0x1d0 [mlx5_core]
  [<00000380b9d8774a>] mlx5_devlink_eswitch_mode_set+0x35a/0x3f0 [mlx5_core]
  [<000003813a791e68>] devlink_nl_eswitch_set_doit+0x88/0x120
  [<000003813a5b93ea>] genl_family_rcv_msg_doit+0xea/0x150
  [<000003813a5b95c2>] genl_family_rcv_msg+0x172/0x210
  [<000003813a5b96c2>] genl_rcv_msg+0x62/0xc0
  [<000003813a5b7cac>] netlink_rcv_skb+0x5c/0x120
  [<000003813a5b8f0c>] genl_rcv+0x3c/0x50
  [<000003813a5b74a4>] netlink_unicast+0x1f4/0x2b0
  [<000003813a5b783c>] netlink_sendmsg+0x2dc/0x460
  [<000003813a4c9764>] __sock_sendmsg+0x64/0xd0
  [<000003813a4cc878>] __sys_sendto+0x108/0x160
  [<000003813a4cdf50>] __do_sys_socketcall+0x350/0x460
  [<000003813a8184d2>] __do_syscall+0x172/0x750
  [<000003813a82d5d2>] system_call+0x72/0x90

Prefix each cache name with the device name to make it unique.

Fixes: fd785e5213f0 ("net/mlx5: DR, Allocate icm_chunks from their own slab allocator")
Fixes: fb628b71fb2a ("net/mlx5: DR, Allocate htbl from its own slab allocator")
Reported-by: Christian Borntraeger <borntraeger@linux.ibm.com>
Closes: https://lore.kernel.org/all/a3cea501-4d1f-47d5-b6d0-fcda9a0aab16@linux.ibm.com/
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Reviewed-by: Kalesh AP <kalesh-anakkur.purayil@broadcom.com>
Reviewed-by: Yevgeny Kliteynik <kliteyn@nvidia.com>
Tested-by: Christian Borntraeger <borntraeger@linux.ibm.com>
Link: https://lore.kernel.org/r/20260715-kmem-dupliate-name-v1-1-85551c328155@nvidia.com
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
 .../ethernet/mellanox/mlx5/core/steering/sws/dr_domain.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/sws/dr_domain.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/sws/dr_domain.c
index fedefb565a21..c9f20a9033eb 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/sws/dr_domain.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/sws/dr_domain.c
@@ -98,9 +98,12 @@ int mlx5dr_domain_get_recalc_cs_ft_addr(struct mlx5dr_domain *dmn,
 
 static int dr_domain_init_mem_resources(struct mlx5dr_domain *dmn)
 {
+	char name[80];
 	int ret;
 
-	dmn->chunks_kmem_cache = kmem_cache_create("mlx5_dr_chunks",
+	snprintf(name, sizeof(name), "%s-mlx5_dr_chunks",
+		 dev_name(dmn->mdev->device));
+	dmn->chunks_kmem_cache = kmem_cache_create(name,
 						   sizeof(struct mlx5dr_icm_chunk), 0,
 						   SLAB_HWCACHE_ALIGN, NULL);
 	if (!dmn->chunks_kmem_cache) {
@@ -108,7 +111,9 @@ static int dr_domain_init_mem_resources(struct mlx5dr_domain *dmn)
 		return -ENOMEM;
 	}
 
-	dmn->htbls_kmem_cache = kmem_cache_create("mlx5_dr_htbls",
+	snprintf(name, sizeof(name), "%s-mlx5_dr_htbls",
+		 dev_name(dmn->mdev->device));
+	dmn->htbls_kmem_cache = kmem_cache_create(name,
 						  sizeof(struct mlx5dr_ste_htbl), 0,
 						  SLAB_HWCACHE_ALIGN, NULL);
 	if (!dmn->htbls_kmem_cache) {

base-commit: 3bd438a58e910db5dc369aa25dfed1fc95f1b596
-- 
2.44.0

