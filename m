Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazon11012029.outbound.protection.outlook.com [52.101.53.29])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 911553F823F;
	Tue,  4 Aug 2026 08:37:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.53.29
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785832633; cv=fail; b=R4UReLGik6JKDtIRfiPK6IgAsB7E8wlnY5UeZ2y6gzwDokhUFP5A7OGwFLWMvOClqs41nuThkB3ySLgeffgjrG/zJz7USyYdO8r+HSv/5Bey6G2DNjcRO0pFwHRrHeyIDcXalLhg98cO4WJlalCJEt7dJXl17hhTt+d6XzJl7C0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785832633; c=relaxed/simple;
	bh=t1PKWhI/XZOKgzM6LhK+nBqfuzzMDSkXzL9vBNJFihM=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=LK80q86106Olfsj8fpXLVoaaf6F6DmwfAOm8R72ZDJ8jlx14vK/dMCXeNTrg0Tro8TyMQEYpt7UJEsXM04v4Etx4ySMBEKacgtRkgzkEx/RKtycvuR77Tfpu1KK2t1qM7zCF432AvjWu72UVTzzqkAd7zOple3FhmU7SFK1lR58=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=XE5euPiM; arc=fail smtp.client-ip=52.101.53.29
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="XE5euPiM"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rqzbnRGOMgBELmH1ve4DDamBpy0PHBs767D9L4L7YG1y/S3JtlgyYJsy0KKJxK2nbVPJc1BcqkEOizweYaQLxmzygxS0qBSswjqNyPuomKU1+3TW7mTS5B806UJ+8lVLGEzCgpTSF//WulzLuDVDvOYIw6YPJHTaShP/a0xWYWy4sBTEmrdoHG8zEqzgPSs96E9Nm3zwYz4FhzPkp2dSv5Ocd/4VmTKOFLyMWJmeJSYeXj1EQliKWugrFrIW5/AVz2oZrKuQP121YcMk1C+A5FZtZAg41rg7Ave2kxBfXTVbk0+zadXdbVZXo4Kzos5ViSJV3huxj9mQKX7FzYIpuQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7bXLqLH3iMvRoixkDxNSnHtbfabqLI40auDS2pOze/w=;
 b=VBCFEoLA3SJEvlpmuOz472idmlqzya2AWcXEWQAcxx9bYLTv7MhHJi1thrlVEKg/A1hWFTq0cqc/h4XbCa6grrUazadwYUMNPvKyKiKAD4P70jZO94BRfUa8jjfq54GZvg7NSOXHADNTNio9nNeXLs+3t+ox7QLEt91gaoDuVYXbx0pcM+Rq5vYmiBpzeGPHUxi6aAh6RgHKcEGL8+qxvsW6Hg4XwidXbRv/OSN7JStOZq4W7BiY2UqQOC1LpDfMrntN5UkP6TTIAHMMe6Cy1oD5TU7BfQgf+FUuo7y8GSDczgUXcEQlM95iicG8xiIWrxPOBWkWcJFbkPIUdKp4og==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7bXLqLH3iMvRoixkDxNSnHtbfabqLI40auDS2pOze/w=;
 b=XE5euPiM/PMV9qK7R4BisgupgfFrJZVixfup+Nv93DuGa+fr1KnyP9WMgixVbTY+V4wmxGHY3aJpl6bZiOIa3vLAJaWosL1J7M1ilMEQBhFuakbzRK29Idxx65z1qcJL+7zaY5CyFK0n2+kx6naBJRBVtuuO85d1JAFLH9/hyaZ0vAeMZk6ulEvNA42d0GyUdyxnw5GZ434MEu593CAf+8DgdPTvRCxMRAM5v8Rxuqg/1SkZ9PtLAG//0Ak0DSqaBjW3AxeEvFc+GAPpzwg7G9JjXx7IVojgqb6YuKvp1+F01mQzrhrftvYBqBrWafO3k0qirp+cuDPLsSdfmi3VcQ==
Received: from BLAPR03CA0140.namprd03.prod.outlook.com (2603:10b6:208:32e::25)
 by SN7PR12MB8603.namprd12.prod.outlook.com (2603:10b6:806:260::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.270.17; Tue, 4 Aug
 2026 08:37:01 +0000
Received: from BL6PEPF00020E5F.namprd04.prod.outlook.com
 (2603:10b6:208:32e:cafe::4c) by BLAPR03CA0140.outlook.office365.com
 (2603:10b6:208:32e::25) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.270.18 via Frontend Transport; Tue, 4
 Aug 2026 08:37:01 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 BL6PEPF00020E5F.mail.protection.outlook.com (10.167.249.20) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.292.8 via Frontend Transport; Tue, 4 Aug 2026 08:37:00 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Tue, 4 Aug
 2026 01:36:45 -0700
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.20; Tue, 4 Aug 2026 01:36:45 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server id 15.2.2562.20 via Frontend
 Transport; Tue, 4 Aug 2026 01:36:37 -0700
From: Tariq Toukan <tariqt@nvidia.com>
To: Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
	<davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Jakub Kicinski
	<kuba@kernel.org>, <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Sabrina Dubroca <sd@queasysnail.net>
CC: Aleksandr Loktionov <aleksandr.loktionov@intel.com>, Alexei Lazar
	<alazar@nvidia.com>, Boris Pismenny <borisp@nvidia.com>, Carolina Jubran
	<cjubran@nvidia.com>, Chris Mi <cmi@nvidia.com>, Cosmin Ratiu
	<cratiu@nvidia.com>, Daniel Zahka <daniel.zahka@gmail.com>, Doruk Tan Ozturk
	<doruk@0sec.ai>, Dragos Tatulea <dtatulea@nvidia.com>, Gal Pressman
	<gal@nvidia.com>, Jacob Keller <Jacob.e.keller@intel.com>, Jianbo Liu
	<jianbol@nvidia.com>, Kees Cook <kees@kernel.org>, Lama Kayal
	<lkayal@nvidia.com>, Leon Romanovsky <leon@kernel.org>,
	<linux-kernel@vger.kernel.org>, <linux-kselftest@vger.kernel.org>,
	<linux-rdma@vger.kernel.org>, Mark Bloch <mbloch@nvidia.com>, "Patrisious
 Haddad" <phaddad@nvidia.com>, Raed Salem <raeds@nvidia.com>, Rahul Rameshbabu
	<rrameshbabu@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>, Shuah Khan
	<shuah@kernel.org>, Shuah Khan <skhan@linuxfoundation.org>, Simon Horman
	<horms@kernel.org>, Stanislav Fomichev <sdf@fomichev.me>, Stanislav Fomichev
	<sdf.kernel@gmail.com>, Tariq Toukan <tariqt@nvidia.com>
Subject: [PATCH net-next V2 00/13] net/mlx5e: Add support for HW-GRO to PSP
Date: Tue, 4 Aug 2026 11:35:22 +0300
Message-ID: <20260804083535.2946459-1-tariqt@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BL6PEPF00020E5F:EE_|SN7PR12MB8603:EE_
X-MS-Office365-Filtering-Correlation-Id: 5058b34a-dc01-475b-b29f-08def2038dbd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|82310400026|1800799024|36860700016|23010399003|18002099003|13003099007|6133799003|56012099006|10067099003|11063799006;
X-Microsoft-Antispam-Message-Info:
	pghgS61lmyx8FY1WyCvjmyJC/j2wevKvXf5uN+PV8D6CzEXYmI8GFaQVLAOWfOnV/R55vsEFKtKYahxecsQ0qLTEPoRg6HYry/ttEuduIakxLYkQDN77nkirq0sT82NRsmpNfdl5KoG9tF5uLkX2PgxjMT5lrAhOib1j5FUrKKs4E6lqLpWTiq4DIONU6odPevLjAMFWJfzgnbTugoMqz4Pgkkr8BbMal1+Sd2BJwe8DziDzZKuZQSba0ggg1hltjoBtC2ya8/Y97wig9aicKuGiIeRec4iq4A7HGXByW1sFT1L94+6T+nR4WstmYXmNiT0CUmUIrEBK4A881pamHOf01C4fnk7xgQbtqi82oCoPzaVTmdoR0GyxGLe2kLn/PDOSdaqkxMTeUST2CI4zBLkeOwJAVlMDoeM2h89R/kPRdAGxG30TccuDmGVqXi8yurTrvUGv0XwC73bPRdvP7F8RjpJP7jh9ZOTaE35cLlTz8CBwMLI+U2pl/RsUl4envmk+e0+kTtbHbK4LOuBIyBjR2rDPb2+YvxWApwViZTqsFuDv0WW4AURp5Aa0cM+j5rFThZ5qtdw8Sy2vaqCeDnxDjqcz+q92KeK3CPUkDi5G9FPoZNlW7YQ65PHo+K95vyLYlAU55VivrpFVOW2a+dnzpc35nLWtbhZ5mmkEjjxEEi/kj6mVNIE1r9Kz6er3iMhrOtSOKQBAjbsv+PfQrQ==
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230040)(7416014)(376014)(82310400026)(1800799024)(36860700016)(23010399003)(18002099003)(13003099007)(6133799003)(56012099006)(10067099003)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	GXG85UHbiErdKQv+/JNJ3N8RtnfDLAQnuqbh3HlFMOwpkrCYW67wLglvvkkopqZ/iKEbN/irutQbXGQkDXS4PjZPHcBt9vEls2qdwy9CamoH7WEv0iRJdktnoJfsBXUSQp1xyVeywWKgoFd1KGPi2RZpyYKa6o/wNrjvTnkZNz9hevFODSTF/X7GUk26fx9Sl8gT5ky0TwrjYhpDqJYq+z+w5bxAuGXxbDkthRcEDG8utoHh/byZAVVyLe52YBQzBZIPK8gE25isFkmYEUb7KPXCMWFEU5bOLNi3rXhT3tPoq8YN6f/W5QE5mWVoBfjV+7U2+FMp2Lznrwppulb9vtxwgZ1VOw8g7rf9lxiM7SeWrclRfW2yoFH6bqLB9e6oSRJXStxc2U6OSREVJ+JgSgvwY+rViNXHSYJ6Ovhqsiv5N2Eu1Gue6/Gq+SoKYexk
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Aug 2026 08:37:00.8036
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5058b34a-dc01-475b-b29f-08def2038dbd
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF00020E5F.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB8603

Ingress PSP packets cannot be merged by the HW-GRO HW state machine
because they are not decapsulated and the current HW-GRO state machine
does not understand PSP.

This series by Cosmin decapsulates PSP packets in steering, which allows
the now-decapsulated PSP packets (== TCP) to go through HW-GRO and be
aggregated. The SPI and PSP version from the PSP header are handed off
to the driver in the CQE metadata fields. They are used to terminate the
HW GRO session on mismatch, and are required to construct the skb
extension which is used higher up in the stack.

kperf tests on a pair of CX7 NICs with 200Gbps link speed:

Streams   Gbps no HW-GRO   Gbps HW-GRO   Speedup
-------   --------------   -----------   -------
      1               28            58     2.07x
      2               67           102     1.52x
      4              136           180     1.32x
      8              175           183     1.05x
        
Regards,
Tariq

Some internal Sashiko findings, plus Cosmin's comments:

> +        cfg.wait_hw_stats_settle()
> +        after = cfg.netnl.qstats_get({"ifindex": cfg.ifindex}, dump=True)[0]
Could this lead to flaky test failures on multiqueue NICs?
By hardcoding the netlink dump array access to index [0], the test statically
verifies statistics for the first queue only. Since the test sends traffic over
an ephemeral random port, Receive Side Scaling (RSS) will hash this 4-tuple and
could deliver the flow to any active RX queue. If the flow lands on a queue
other than queue 0, will the test fail to observe the hardware GRO packet
increments?
[CR] The premise is wrong. [0] is not queue 0, it's the result for the
requested dev.
> @@ -224,6 +253,28 @@ run_session(struct ynl_sock *ys, struct opts *opts,
>                                               fprintf(stderr, "WARN: echo but no data sock\n");
>                                       send_ack(comm_sock);
>                               }
> +                             if (cmd("data send")) {
> +                                     __u32 len;
> +
> +                                     if (data_sock < 0) {
> +                                             fprintf(stderr, "WARN: send but no data sock\n");
> +                                             send_err(comm_sock);
> +                                             continue;
> +                                     }
Is there a race condition between processing the control command and accepting
the data socket?
If the Python client initiates the data socket connection and immediately
sends the "data send" command on the control socket, both the server_sock
(accept queue) and comm_sock (control connection) could become readable
simultaneously before the responder calls poll().
Because the comm_sock is processed first in run_session():
tools/testing/selftests/drivers/net/psp_responder.c:run_session() {
    ...
    /* comm sock */
    if (pfds[1].revents & POLLIN) {
        ...
    }
    /* server sock */
    if (pfds[0].revents & POLLIN) {
        data_sock = accept(server_sock, NULL, NULL);
    }
    ...
}
does this cause the responder to handle the "data send" command before
accepting the data socket, resulting in data_sock < 0 and an immediate failure?
[CR] Possible in theory, not happening in practice today because "data send" is
only used after a few round trips from the Python test, so it is guaranteed
that the new socket is accepted by the time the command gets executed.
Fixing this class of races in the responder would be nice, but outside the
scope of this series.
> @@ -1757,11 +1755,10 @@ macsec_fs_rx_add_rule(struct mlx5_macsec_fs *macsec_fs,
>       rx_tables = &rx_fs->tables;
>       ft_crypto = &rx_tables->ft_crypto;
>
> -     /* Set bit[31 - 30] macsec marker - 0x01 */
>       /* Set bit[15-0] fs id */
>       MLX5_SET(set_action_in, action, action_type, MLX5_ACTION_TYPE_SET);
>       MLX5_SET(set_action_in, action, field, MLX5_ACTION_IN_FIELD_METADATA_REG_B);
> -     MLX5_SET(set_action_in, action, data, macsec_fs_set_rx_fs_id(fs_id));
> +     MLX5_SET(set_action_in, action, data, fs_id);
Does removing the BIT(30) marker from the MACsec fs_id metadata cause a
regression by exposing RoCE MACsec to an aliasing issue?
By removing BIT(30) from the fs_id in this patch, the fs_id written to
METADATA_REG_B becomes a small integer (e.g., 1, 2).
Later in mlx5_macsec_fs_add_roce_rule_rx(), the hardware rule
ft_macsec_op_check enforces MACsec on RoCE traffic by matching
metadata_reg_c_5 exactly against this same fs_id value.
Could any unencrypted packet that has its REG_B set to this small integer
by another NIC feature (such as TC rules setting packet marks, or PSP IPsec
decryption) falsely pass the MACsec check and bypass encryption enforcement?
[CR] Preexisting, TC rules could set the fsid to the the previous value even before.
'PSP IPsec' decryption doesn't make sense.
> @@ -1717,7 +1717,7 @@ void mlx5e_macsec_offload_handle_rx_skb(struct net_device *netdev,
>       if (!macsec)
>               return;
>
> -     fs_id = MLX5_MACSEC_RX_METADAT_HANDLE(macsec_meta_data);
> +     fs_id = MLX5_MACSEC_RX_METADATA_HANDLE(macsec_meta_data);
>
>       rcu_read_lock();
>       sc_xarray_element = xa_load(&macsec->sc_xarray, fs_id);
This is a pre-existing issue, but can this xa_load() race with an immediate
kfree() during deletion, causing a use-after-free?
In the deletion path, mlx5e_macsec_del_rxsc() calls xa_erase() and then
immediately frees the element without an RCU grace period:
mlx5e_macsec_del_rxsc() {
        ...
        xa_erase(&macsec->sc_xarray, rx_sc->sc_xarray_element->fs_id);
        dst_release(&rx_sc->md_dst->dst);
        kfree(rx_sc->sc_xarray_element);
        ...
}
Since mlx5e_macsec_offload_handle_rx_skb() retrieves sc_xarray_element
locklessly under rcu_read_lock() via xa_load(), would a concurrent deletion
result in dereferencing freed memory?
[CR] Preexisting.
> +static inline int mlx5e_accel_block_tc_offload(struct mlx5_core_dev *mdev)
> +{
> +     int ret = 0;
> +
> +     mutex_lock(&mdev->offload_block.lock);
> +     if (mdev->offload_block.num_accel)
> +             ret = -EBUSY;
> +     else
> +             mdev->offload_block.num_tc++;
This isn't a bug, but does the new naming here swap the semantics of the
variables?
In the original logic, num_block_tc counted the number of blockers on TC
(which are IPsec/accel rules). By renaming it to num_tc,
mlx5e_accel_block_tc_offload() now increments num_tc when an accel rule
is added.
Would it be clearer to keep "block" in the names, e.g., num_block_tc, so
it doesn't look like num_tc is tracking the number of TC rules?
[CR] Intentional, "offload_block.num_{tc, accel}" sounds better.
> +static inline int mlx5e_accel_block_tc_offload(struct mlx5_core_dev *mdev)
> +{
> +	int ret = 0;
> +
> +	mutex_lock(&mdev->offload_block.lock);
> +	if (mdev->offload_block.num_accel)
> +		ret = -EBUSY;
> +	else
> +		mdev->offload_block.num_tc++;
Are the semantic meanings of the num_tc and num_accel variables inverted?
When an Accel rule is added here in mlx5e_accel_block_tc_offload(), it
increments num_tc.
[CR] Same thing, it's an intentional rename.

V2:
- Use XFail in patch 13 (Jakub).

V1:
https://lore.kernel.org/all/20260730091756.2543777-1-tariqt@nvidia.com/

Cosmin Ratiu (13):
  net/mlx5e: Generalize TC <-> IPsec mutual exclusion
  net/mlx5e: ipsec: Block TC offload when IPsec is enabled
  net/mlx5e: psp: Block TC offload when PSP is enabled
  net/mlx5e: macsec: Block TC offload when MACsec is enabled
  net/mlx5e: psp: Move RX marker from ft_metadata to flow_tag
  net/mlx5e: ipsec: Move RX marker from ft_metadata to flow_tag
  net/mlx5e: macsec: Move RX marker from ft_metadata to flow_tag
  net/mlx5e: psp: Handle HW-decapsulated RX PSP packets
  net/mlx5e: psp: Add an rx_decap steering table
  net/mlx5e: shampo: Flush session on PSP mismatch
  net/mlx5e: psp: Dynamically reconfigure based on SHAMPO mode
  selftests: drv-net: psp: Fix responder parsing
  selftests: drv-net: psp: Add a test for PSP with HW-GRO

 .../net/ethernet/mellanox/mlx5/core/en/fs.h   |   1 +
 .../mellanox/mlx5/core/en_accel/en_accel.h    |  31 ++
 .../mellanox/mlx5/core/en_accel/flow_tag.h    |  45 +++
 .../mellanox/mlx5/core/en_accel/ipsec_fs.c    |  70 ++--
 .../mellanox/mlx5/core/en_accel/ipsec_rxtx.h  |   9 +-
 .../mellanox/mlx5/core/en_accel/macsec.c      |  34 +-
 .../mellanox/mlx5/core/en_accel/macsec.h      |   5 +-
 .../mellanox/mlx5/core/en_accel/psp.c         | 319 ++++++++++++++++--
 .../mellanox/mlx5/core/en_accel/psp.h         |   2 +
 .../mellanox/mlx5/core/en_accel/psp_rxtx.c    |  21 +-
 .../mellanox/mlx5/core/en_accel/psp_rxtx.h    |  44 ++-
 .../net/ethernet/mellanox/mlx5/core/en_main.c |   8 +-
 .../net/ethernet/mellanox/mlx5/core/en_rx.c   |  32 +-
 .../net/ethernet/mellanox/mlx5/core/en_tc.c   |  46 +--
 .../net/ethernet/mellanox/mlx5/core/en_tc.h   |   7 +-
 .../mellanox/mlx5/core/lib/macsec_fs.c        |  17 +-
 .../mellanox/mlx5/core/lib/macsec_fs.h        |   9 +-
 .../net/ethernet/mellanox/mlx5/core/main.c    |   3 +
 include/linux/mlx5/driver.h                   |   7 +-
 tools/testing/selftests/drivers/net/psp.py    | 131 ++++++-
 .../selftests/drivers/net/psp_responder.c     |  87 +++--
 21 files changed, 764 insertions(+), 164 deletions(-)
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en_accel/flow_tag.h


base-commit: 5b4f243f78a533abf414bfd96325aa2c96e711a3
-- 
2.44.0

