Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11010071.outbound.protection.outlook.com [52.101.56.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E2D43F0A81;
	Thu, 30 Jul 2026 09:18:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.56.71
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785403125; cv=fail; b=ZaqiCCU61EJkElMLYuBw5s8pUjZ9ie3yazKDo8DK7lyOKfH9kBzq9OPGOL3fwnTFwuBkFsBkNI5Uv3Id4sDGMf0f3S4wR3hvvTM+zubTQTd6emxe4QdvaahaT2YB+KdELOV4sfhdJM/uItNgM5BMmLTiiwP31MnEbAqpoR8nX1U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785403125; c=relaxed/simple;
	bh=Ew9f9pCjGslTvhjKp6vhg+hTlxcaMno/wiuFH+2TbZY=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=WzMaN3hey20zJmA4EMGEcvkfv3pRCSYXR6YWYOLHWD7jO6qz3ujtF3nhFpgkjqBuK1q93btIDBPivmzLmQIUt6rY6pasyS5nFNwssn7F6lbr74oBdJ6dni2w1pxfWRDaMdXo9BINlmOTI3OOKghqPdrU7WvCz8CZroy1GzvHaBM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=m216+EYy; arc=fail smtp.client-ip=52.101.56.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="m216+EYy"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vwKkny00gwaj+YZzsRA1fYRPO7uQ2XuK2bAuBuQ+vN2zTDXJDnnJieYkFis4QVBy0LG18TVVjPGEdpwEBHEBPpHaAHEjY45lsZVP6LkbJ1CP66fmTxO3TIuX9C6MufhiiHr9NDSE2EbIylZd2XcduXxuVeNfAzqLc6WGwQSg0WqCQ4KLqYWIv22wQA3u0RE6sgye1UI0x+Ph3F/D+KDRpkPG5zBe+4wnQC+lbjFFBBPBWtXQVqvGdPukgiaYvqoEcH2esokGQLV0RN6eKnnvFTPjPa4XN3XeI/0jUvd7woJEtlogM4kC0etdrX0Eez1DGbK17/qcyy8ux8URgvwzLA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6nyqwdRJDsojcfnlasvMUL9weVYt2ZV9yIXtfcVzCUE=;
 b=WnJltpcUtgjJHRIF1jiZMWnatU/igJsn/q6fC3PSmMamkHC3iMjPxbKvnDzUG9kAt6FCa6EF9A7mzkNYFTEw8pH9++ba4CI6dH0pbqnEwNtiAe0HIjV6lmUEF147fNhkejqerna+FzZSl0s177x2e6uJTxjSuKmqACu3sIEBFT4nvB3L+mti0Ofy5Qcy1QFCA8MCdVKGmH0g/o1HYseDyb7vy6VtANuLVkWCNA6RaQ+w/NIH1Alv3oD1F6SG093cyz2Q93y4mHrh/meKneO3MAbSrndSIaJd5J5XQqPFFOVLx7ezaX5kMvqry1YVO5E+boMxz6Ycrtb05Wt22MoewQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6nyqwdRJDsojcfnlasvMUL9weVYt2ZV9yIXtfcVzCUE=;
 b=m216+EYynYGQQNsk3tbd8e/NJJgRcVUxwbcLfnLjhKzA26C7/lhljqIR1B/RMMmnopV8ZhdZQ4zQzP7IXeoc0KBcIxkTRDY80WSZRKNdh51/i8jKN/SSldOEykQh2Oept7HfJLB/RnI5MiQaV9XUAqdOix6LltbJByOyX/t/yXOO3fwDvQxNPpIfZ0jW36/Tvs8JdtHjZXExt/IEQ7bVbuCZtMUm0kpc1Zq0fvECLe0kaUD2KHrVEXbElvGpC9u+uAcg0cABD4Q0xx59OU21+5AhTvcDUN/JtkgpfrI6mEQU1LFmDGl9fikIS/KStVS5pJfFqgrhtr/0NPVCIv998w==
Received: from SA1PR05CA0015.namprd05.prod.outlook.com (2603:10b6:806:2d2::24)
 by CYXPR12MB9388.namprd12.prod.outlook.com (2603:10b6:930:e8::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.270.14; Thu, 30 Jul
 2026 09:18:35 +0000
Received: from SN1PEPF00026367.namprd02.prod.outlook.com
 (2603:10b6:806:2d2:cafe::78) by SA1PR05CA0015.outlook.office365.com
 (2603:10b6:806:2d2::24) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.292.9 via Frontend Transport; Thu, 30
 Jul 2026 09:18:35 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 SN1PEPF00026367.mail.protection.outlook.com (10.167.241.132) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.292.8 via Frontend Transport; Thu, 30 Jul 2026 09:18:34 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Thu, 30 Jul
 2026 02:18:19 -0700
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Thu, 30 Jul
 2026 02:18:18 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.8)
 with Microsoft SMTP Server id 15.2.2562.20 via Frontend Transport; Thu, 30
 Jul 2026 02:18:10 -0700
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
Subject: [PATCH net-next 00/13] net/mlx5e: Add support for HW-GRO to PSP
Date: Thu, 30 Jul 2026 12:17:42 +0300
Message-ID: <20260730091756.2543777-1-tariqt@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: SN1PEPF00026367:EE_|CYXPR12MB9388:EE_
X-MS-Office365-Filtering-Correlation-Id: e8ef2e8a-24d9-453e-5425-08deee1b87e4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|23010399003|376014|7416014|82310400026|1800799024|6133799003|56012099006|11063799006|10067099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	az543zAwNjdaNt0/CZySt5uyiOdXb8ASpCpn5vhOrZcR9T8zRZDTVbkF77i6KK/ot3vDRbx4R1VN3lHhvKf1aJQCVSxQYLgzLQ+djW+4bJXPAWbJfkdXnCHVkBTxIQaSFqBX78o1weZ3VPTMY1nlbrHE0IDqMuhMF5lNwNY/U0Y4IPQSiYvEXty4bXaaA2lpyPWooDBZwXt9fwoz+P4TwtjqjBVdkPxt3xgz4WSntb/Gt0KNMVti4EO8GW0OJsBPV/unB0adMjshmTDUylzt1+kyhJwzbzHb9AdsB3CHFHD1uclZwHI9ih+Dwx2DXxmt0khnmhvgg1jFfbAHABZS0IMlVgiEJ7KrmjWz20cy18XJuBs+P7szP4JnWLmdj7M7L33S8N1Va0RKfSSY2TV4AnHX4H776vojqaEJ4FvkOp5Jj2ItP+eZ9cC3qJVspD17yego0S3FVk4NZgNK1s5cK/ZhP2gRKej0PG4RC65m5y7+kY3GurToMXjR9uOc78L1OloFOFSAwEeoPkB/hWNfZTnirCFgGbAWVK3azVlRfFF+PRs6Z1cZ7yGbZlYu/z3R3XIByCuI+fgnI5UiOdLPjFPmeWKo26RlcpNIK551/nsomXySjpVtUcSoOi/PBoCKDBSLOkujobkryx2EomTeC8JIG/0kT9RxVVtj8cAeF3Ig7affqgri0pvZuEbPSjQXGdDhzEtYU88HiraCtN4tBg==
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(36860700016)(23010399003)(376014)(7416014)(82310400026)(1800799024)(6133799003)(56012099006)(11063799006)(10067099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	nsKGRn8d/7fIzEoZKnBiNC+wZMdmfBKxWDc43Wc70SP0pTLP35e3z4fJ4u1+fYFJo64mj7zmbN8yabeOG8u6WY74ki2VirnHY4cYJBr6jrJ9nqxfVrUtRZ1lOgMFH2CcV/8YA7Iuuz+LynTEsOWl1Bt4FfrvUHPA+K806XO7/R2iIbkRypDqTE5sSWrKki32zfwLWFE6NFIR21SuF4iKxHEWyuUolR/QRqc0dmzPHsR+jWQ8y0eSgcB3SNuCPVHz+9v0j3qet5S4ybjg4V+kQeF3vTBWinEsD8pQnA6ZDOUGmxq+0JjdYby195UPh3hRisvDsXidv9VFk6QUWn6PQOHcN4IOPLpb8H7cKmFKTL53br65ITYsd9s5B+A679fp1uYaFbM26V6LbknAkNXiOlFeQBma8yT/V3V7IWOeEUTMU3+XbA5GGnSzPvhxhccp
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jul 2026 09:18:34.3099
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e8ef2e8a-24d9-453e-5425-08deee1b87e4
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF00026367.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYXPR12MB9388

Hi,

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
Change-Id: Ib52fd4bfc205ea2e4da47e07a54cc0b727cc225a

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
 tools/testing/selftests/drivers/net/psp.py    | 129 ++++++-
 .../selftests/drivers/net/psp_responder.c     |  87 +++--
 21 files changed, 763 insertions(+), 163 deletions(-)
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en_accel/flow_tag.h


base-commit: 2bb54b49e9d522f54dc9c0fe10ba40fbc56041c8
-- 
2.44.0

