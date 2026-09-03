Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazon11011000.outbound.protection.outlook.com [52.101.62.0])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1ECF9459ACF;
	Thu,  3 Sep 2026 08:53:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.62.0
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788425616; cv=fail; b=ZtoJk49bnToGnpV3mxmulibXHQ+rAgJWYdziqD/Kh1YjT0HTGi11qrEK9+OqoOddUoZoK5xv40eK8Ed19bBg4cYt59k3w8rAPwa6lv9Ihs9enWs/7jjtKtUSKtMo8dZEPeM1cCeO9p/UkNpj4CPNW8T1fuDbd8bzwCB3EfC3yRI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788425616; c=relaxed/simple;
	bh=P0N/SQTAV7XgeZmliezr6uJ0PmK6J2x4E4tcIvsx6XM=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=jMPtWBPsZCX8ZrnPKX+ak6TzoZdysRwoHE0b1y1hlrkPVXxfy6GYdXT6+5H3ze1bUNrJWzr2ghSPMaD3N65zlhSKPW7LNStQExXTPX3c4Mz/XLAiBh9mFlR2QA+1DtddBTD1yLU/zrbrpkO2QEuaYsOerPpNO4XECFKTV242b18=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=QIBO1nxa; arc=fail smtp.client-ip=52.101.62.0
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="QIBO1nxa"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yR/Npkk2x266tQWyEMsmxcFcKCo1ytteBGZUeRhYfk4xZ+iN8wkn6KS6hq0do11fwWFUXmhaCSKJDu7zhQNHfPNRbRFPNA4e9CF0/m5JBBRiHKdAQwsTQP96fyahia6it3hKFRMzZRkU6sbr3mDVBW4xkBppnDnnzunLPNy1o4reKojJxbbZv1y+oIPVefjM+P9MfH5/Iaw/wkvOJPc8vJC55bUaOaokg8SJ3ri7+ivBaSbsTuS+nKwoL14YDBPqDwQ/qr0w2iq2zJkkCSzL9djIG2+EKn0L9AKm+O8PHhzAnj7fdaSjIkW1aRjL2X92RsU+kvLxj8S4ySs5pG/SJg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rbZwBEiwdRPWfrnJMNEV31eDilkHKCDngU+e2Yf94pw=;
 b=c93Q710gchd8rFIOLT7LEk3UNb04GQ2bHaz7i3onwOzW5eeUxVWXKPeCAxVfDRfoUoyG0DRx+B8kugB4xvp/9gVi6L3+NNgiPYxP9iTZRA/9v4wVAxAb133ZcDGUdp0xnTyAiIS6qWcIxIwGiwwwb70LoJ0FJJyRwr6kenFfZ7MyrC/RvSCqKjOyNfy4JJq85/6I1xXtXvAhF7Xjw33k/57972r6Qgl1Uqy1y4r4K6sO+gV1jYSGyFDQ3v3/31BujbDnEnJuJ+09cV0rD/jIOPnDBcs4w8wPhNYG7oioR5rvUtUz8oJMivIH8dLfJiOZBQfaelhwFeRVa+uInZmDdw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rbZwBEiwdRPWfrnJMNEV31eDilkHKCDngU+e2Yf94pw=;
 b=QIBO1nxa9hC8qC67nxqZNcIogHo9GSMJehDRU93p3EsgpjavnOfrI8Zo+jaNk5/R8SJ154GU1gIbozKb1ng6xKMFxGrKuYSfgx0luN9DDXB7QxLlDsbPD/JeP9VV9WOtrP7sVQEf2Xuk+Cb2UhAtuvMPSzoIZwS+sE+cz4/eIxNL6ygkftiHHtcgZWz28BtZ2Rgk9YIn6ZYTWZsWr/t35uR2ju+YoKL5OOhl4AZwBshaNpysdkyPvAUdW4+cbUVLDorZpW9mXagzKlzOJS7eXPsHBoNkKjRdVztR02TxXaM2n98ERoY7UkhMuTB+i9tqnZtDunUfI8jJ/eZAv6HyNQ==
Received: from CH2PR04CA0023.namprd04.prod.outlook.com (2603:10b6:610:52::33)
 by MW4PR12MB7358.namprd12.prod.outlook.com (2603:10b6:303:22b::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.360.12; Thu, 3 Sep
 2026 08:53:16 +0000
Received: from BN2PEPF0000A7FE.namprd02.prod.outlook.com
 (2603:10b6:610:52:cafe::2) by CH2PR04CA0023.outlook.office365.com
 (2603:10b6:610:52::33) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.382.12 via Frontend Transport; Thu, 3
 Sep 2026 08:53:16 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BN2PEPF0000A7FE.mail.protection.outlook.com (10.167.245.165) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.382.8 via Frontend Transport; Thu, 3 Sep 2026 08:53:16 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.46; Thu, 3 Sep
 2026 01:52:58 -0700
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.46; Thu, 3 Sep
 2026 01:52:57 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.7)
 with Microsoft SMTP Server id 15.2.2562.46 via Frontend Transport; Thu, 3 Sep
 2026 01:52:45 -0700
From: Tariq Toukan <tariqt@nvidia.com>
To: Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
	<davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Jakub Kicinski
	<kuba@kernel.org>, <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Sabrina Dubroca <sd@queasysnail.net>
CC: Aleksandr Loktionov <aleksandr.loktionov@intel.com>, Alexei Lazar
	<alazar@nvidia.com>, Alexei Starovoitov <ast@kernel.org>, Allison Henderson
	<allison.henderson@oracle.com>, Antonio Quartulli <antonio@openvpn.net>,
	Anubhav Singh <anubhavsinggh@google.com>, Bobby Eshleman
	<bobbyeshleman@meta.com>, Boris Pismenny <borisp@nvidia.com>,
	<bpf@vger.kernel.org>, Carolina Jubran <cjubran@nvidia.com>, Chris Mi
	<cmi@nvidia.com>, Cosmin Ratiu <cratiu@nvidia.com>, Daniel Borkmann
	<daniel@iogearbox.net>, Daniel Zahka <daniel.zahka@gmail.com>, David Wei
	<dw@davidwei.uk>, Doruk Tan Ozturk <doruk@0sec.ai>, Dragos Tatulea
	<dtatulea@nvidia.com>, Gal Pressman <gal@nvidia.com>, Jacob Keller
	<Jacob.e.keller@intel.com>, Jesper Dangaard Brouer <hawk@kernel.org>, "Jianbo
 Liu" <jianbol@nvidia.com>, John Fastabend <john.fastabend@gmail.com>, "Kees
 Cook" <kees@kernel.org>, Lama Kayal <lkayal@nvidia.com>, Leon Romanovsky
	<leon@kernel.org>, open list <linux-kernel@vger.kernel.org>,
	<linux-kselftest@vger.kernel.org>, <linux-rdma@vger.kernel.org>, Mark Bloch
	<mbloch@nvidia.com>, "Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Patrisious Haddad <phaddad@nvidia.com>, Petr Machata <petrm@nvidia.com>,
	"Raed Salem" <raeds@nvidia.com>, Rahul Rameshbabu <rrameshbabu@nvidia.com>,
	"Richard Gobert" <richardbgobert@gmail.com>, Saeed Mahameed
	<saeedm@nvidia.com>, "Shuah Khan" <shuah@kernel.org>, Shuah Khan
	<skhan@linuxfoundation.org>, Simon Horman <horms@kernel.org>, Stanislav
 Fomichev <sdf@fomichev.me>, Stanislav Fomichev <sdf.kernel@gmail.com>, Tariq
 Toukan <tariqt@nvidia.com>, Willem de Bruijn <willemb@google.com>, Willem de
 Bruijn <willemdebruijn.kernel@gmail.com>
Subject: [PATCH net-next V3 00/15] net/mlx5e: Add support for HW-GRO to PSP
Date: Thu, 3 Sep 2026 11:52:00 +0300
Message-ID: <20260903085215.3691657-1-tariqt@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BN2PEPF0000A7FE:EE_|MW4PR12MB7358:EE_
X-MS-Office365-Filtering-Correlation-Id: ae86ebea-48d1-4d67-d613-08df0998cb75
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700016|7416014|376014|1800799024|23010399003|13003099007|6133799003|3023799007|10067099003|56012099006|11063799006|18002099003;
X-Microsoft-Antispam-Message-Info:
	AmYkfMXIz7VG1STGsuuS2/CdcuBs0FcD9SkvrxgFR65TpH1RgPZICSOkVcxyx2V7MCoZym8w/nn//UUMzxF/jbNV9eiS30joe2XF8wQVZHK/wDt/5fqhjf4nMGM+rQ2e9ws3ctSp57jhG8Ll6Ln1nU4DRPQxUKHAxLpZ1VbLJuIS+GiF2mhD0PTIyBFwprsrSpcAerdqikiwkv8vyrze5N06LmMuzRh0AI7GeelPOS0+oQu6QFveRDZhdAlQ1rORiBVFDKMljfpNJOSyWMuuaUfI4E61uqDaahJrsad5DV4EYapNg7AuHcovyFXey0Gx/5yH4PHAKJJzJNNfi+ad5csRX7j+KgARSeHH9lmgTC31Hr28Uab7m37S9An/zKMDaggbiPZKckjkgIlGNiXoJcfItCptV3qJbX3WuCPlOMhk9exHqHgrZopVtDkhvvrfWS0UqLGi5w3aZC3wO8RjJY+5OOLN4/JfJEFmn5GmstjGAkhATYrniKumQEiMM27heZ3gCLELgof27EoWw5M5LZV6Oz1mcniqkx7ZEPgHVw7SXJIC6jPBGMMyzjWZwuOVQJhcX+aD03wXwV+Edx85TyZbeuiqYtIRLAV6OgGe8ewCJ6MG+ICx7YWa7TmJXleNKoazn1QNyF756nxcCWhtNCy8JzX+MOm9096VNuO+OVCPmwkJy/l8hmhwK48Jef1Bp1Vngwk+KYKZIWL/OxNFIw==
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(36860700016)(7416014)(376014)(1800799024)(23010399003)(13003099007)(6133799003)(3023799007)(10067099003)(56012099006)(11063799006)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	wxORS0BEHes0tp6/Jria24s8tEVGQFQboBCNMuP3vXhC1jq2VLLq/5n6jdJAETDQ9gBP3DtduQCSQWBifGTTG5OpBQIqSUUZs/S4XepQEcFwiTcdLLdwVYPBczbB9ndFRJvNXODowbDMN+rKkIAQLwvKZzQU5nqh+1TGiTh733FVS3A/ntQnVPEj0eduh2nMdHSqh3ao9v+kpkHK4fmMQ+SvNMpH5T1ny6MvSU88KAaW7bG9cWrQaX3PIgOUskzALPhK+Y0Ec8BCWbLUeSUamDZG4MHwMz+q1HzwFB1o+BJcIMWQo4zScKNEhoWcb7f8ARQSP1KUzKa1VX1iMJ3sgibQoGJXN0sV5tgZiFgH0JjSzFQaOBYpY3QWrd4a5YI9tWpR0N5IeFQDONrwJs4etyOYHiMuaCAbFst7LWX5TQ9UIGsGr1/NCScsfrCV5ODI
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Sep 2026 08:53:16.1596
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ae86ebea-48d1-4d67-d613-08df0998cb75
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN2PEPF0000A7FE.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB7358

Ingress PSP packets cannot be merged by the HW-GRO HW state machine
because they are not decapsulated and the current HW-GRO state machine
does not understand PSP.

This series by Cosmin decapsulates PSP packets in steering, which allows
the now-decapsulated PSP packets (== TCP) to go through HW-GRO and be
aggregated. The SPI and PSP version from the PSP header are handed off
to the driver in the CQE metadata fields. They are used to terminate the
HW GRO session on mismatch, and are required to construct the skb
extension which is used higher up in the stack.

Some preparatory work needed to happen to allow that:
- All accel protocol markers were moved away from ft_metadata into
  flow_tag
- Mutual exclusion between TC and accel protocols was added. Trying to
  configure both IPsec and TC at the same time for example is not
  detected at config time instead of doing weird things at runtime.

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

> @@ -1757,11 +1755,10 @@ macsec_fs_rx_add_rule(struct mlx5_macsec_fs *macsec_fs,
>  	rx_tables = &rx_fs->tables;
>  	ft_crypto = &rx_tables->ft_crypto;
>
> -	/* Set bit[31 - 30] macsec marker - 0x01 */
>  	/* Set bit[15-0] fs id */
>  	MLX5_SET(set_action_in, action, action_type, MLX5_ACTION_TYPE_SET);
>  	MLX5_SET(set_action_in, action, field, MLX5_ACTION_IN_FIELD_METADATA_REG_B);
> -	MLX5_SET(set_action_in, action, data, macsec_fs_set_rx_fs_id(fs_id));
> +	MLX5_SET(set_action_in, action, data, fs_id);
Does removing the BIT(30) marker allow metadata collisions in the hardware
RoCE datapath?
If an administrator configures a benign TC rule that sets a mark equal to
the MACsec fs_id (which is just a 16-bit integer), could an attacker send
unauthenticated RoCE traffic that matches the TC mark, falsely setting the
metadata and bypassing the MACsec hardware authentication checks?

[CR] This series makes TC and MACsec mutually exclusive.

> @@ -2160,8 +2167,8 @@ static int mlx5_macsec_fs_add_roce_rule_rx(struct mlx5_macsec_fs *macsec_fs, u32
>
>  	spec->match_criteria_enable |= MLX5_MATCH_MISC_PARAMETERS_2;
>  	MLX5_SET_TO_ONES(fte_match_param, spec->match_criteria, misc_parameters_2.metadata_reg_c_5);
> -	MLX5_SET(fte_match_param, spec->match_value, misc_parameters_2.metadata_reg_c_5,
> -		 macsec_fs_set_rx_fs_id(fs_id));
> +	MLX5_SET(fte_match_param, spec->match_value,
> +		 misc_parameters_2.metadata_reg_c_5, fs_id);
By matching on the bare fs_id without the BIT(30) marker in
metadata_reg_c_5, is this RoCE datapath rule now susceptible to the TC
mark collision issue?

[CR] See above.

> @@ -1778,6 +1775,11 @@ macsec_fs_rx_add_rule(struct mlx5_macsec_fs *macsec_fs,
>  	/* Rx crypto table with SCI rule */
>  	macsec_fs_rx_setup_fte(spec, &flow_act, attrs, true);
>
> +	spec->flow_context.flags |= FLOW_CONTEXT_HAS_TAG;
> +	spec->flow_context.flow_tag =
> +		FIELD_PREP(MLX5E_ACCEL_FLOW_TAG_PROTO_MASK,
> +			   MLX5E_ACCEL_FLOW_TAG_PROTO_MACSEC);
Can adding FLOW_CONTEXT_HAS_TAG to the shared MACsec crypto table corrupt
RoCE Queue Pair Numbers (QPN)?
This unconditionally adds a flow tag to the shared ft_crypto table, which
processes both Ethernet and RoCE MACsec traffic. When FLOW_CONTEXT_HAS_TAG
is set, the hardware writes the flow tag into the sop_drop_qpn field of
the CQE.
Will this cause the mlx5_ib driver to read the MACsec tag (value 2) instead
of the actual destination QPN for RDMA traffic, breaking RoCE delivery?

[CR] The flow_tag is only given for Eth CQEs. For RoCE/RDMA, that CQE
field is the QPN, and therefore mlx5_ib is unaffected.

> @@ -1803,6 +1805,11 @@ macsec_fs_rx_add_rule(struct mlx5_macsec_fs *macsec_fs,
>
>  		macsec_fs_rx_setup_fte(spec, &flow_act, attrs, false);
>
> +		spec->flow_context.flags |= FLOW_CONTEXT_HAS_TAG;
> +		spec->flow_context.flow_tag =
> +			FIELD_PREP(MLX5E_ACCEL_FLOW_TAG_PROTO_MASK,
> +				   MLX5E_ACCEL_FLOW_TAG_PROTO_MACSEC);
Is it safe to set the flow tag on the shared crypto table here as well?
This risks corrupting the destination QPN for RoCE traffic as mentioned
above.

[CR] Same as above, QPN isn't corrupted, those CQEs don't carry flow_tag.

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

> @@ -384,6 +429,215 @@ static void fill_transportlayer(void *buf, int seq_offset, int ack_offset,
[ ... ]
> +static char psp_scratch[L2_HLEN_MAX + IP_MAXPACKET + PSP_ENCAP_LEN];
[ ... ]
> +/* Encapsulates & encrypts @pkt with PSP transport mode into psp_scratch.
> + * Returns the scratch buffer and updates *@lenp.
> + */
> +static char *psp_encapsulate(const char *pkt, int *lenp)
> +{
[ ... ]
> +	memcpy(psp_scratch, pkt, len);
> +
> +	if (proto == PF_INET) {
> +		struct iphdr *iph = (struct iphdr *)(psp_scratch + ETH_HLEN);
Does this code violate strict aliasing rules?
Since psp_scratch is declared as a character array, casting it to an
incompatible structure pointer like struct iphdr * (and later struct ipv6hdr *
and struct udphdr *) violates C11 strict aliasing rules.
Because the tools/ directory assumes standard -fstrict-aliasing optimizations
are active, could this cause the compiler to incorrectly reorder or optimize
away memory writes to these headers, potentially resulting in malformed
packets and spurious test failures?

[CR] Maybe, but there are already 20+ similar things in the file.

V3:
- Cleared fs->decap_enabled on config down (Daniel).
- Made decap support optional (don't fail device reconfig on errors).
- Used bitfield ops for accel protos & psp ver (Daniel).
- Renamed psp_responder off -> len (Jakub).
- Dedicated HW GRO PSP test (Jakub).
- Extended HW GRO test coverage (Jakub).

V2:
https://lore.kernel.org/netdev/20260804083535.2946459-1-tariqt@nvidia.com/
- Use XFail in patch 13 (Jakub).

V1:
https://lore.kernel.org/all/20260730091756.2543777-1-tariqt@nvidia.com/

Cosmin Ratiu (15):
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
  selftests: drv-net: psp: Extract shared helpers into psp_lib.py
  selftests: drv-net: gro: Extract shared helpers into gro_lib.py
  selftests: net: gro: Add PSP encapsulation and encryption
  selftests: drv-net: Add PSP HW GRO conformance tests

 .../net/ethernet/mellanox/mlx5/core/en/fs.h   |   1 +
 .../mellanox/mlx5/core/en_accel/en_accel.h    |  27 ++
 .../mellanox/mlx5/core/en_accel/flow_tag.h    |  49 +++
 .../mellanox/mlx5/core/en_accel/ipsec_fs.c    |  72 ++--
 .../mellanox/mlx5/core/en_accel/ipsec_rxtx.h  |   8 +-
 .../mellanox/mlx5/core/en_accel/macsec.c      |  34 +-
 .../mellanox/mlx5/core/en_accel/macsec.h      |   4 +-
 .../mellanox/mlx5/core/en_accel/psp.c         | 316 ++++++++++++++--
 .../mellanox/mlx5/core/en_accel/psp.h         |   2 +
 .../mellanox/mlx5/core/en_accel/psp_rxtx.c    |  21 +-
 .../mellanox/mlx5/core/en_accel/psp_rxtx.h    |  44 ++-
 .../net/ethernet/mellanox/mlx5/core/en_main.c |  10 +-
 .../net/ethernet/mellanox/mlx5/core/en_rx.c   |  32 +-
 .../net/ethernet/mellanox/mlx5/core/en_tc.c   |  46 ++-
 .../net/ethernet/mellanox/mlx5/core/en_tc.h   |   7 +-
 .../mellanox/mlx5/core/lib/macsec_fs.c        |  21 +-
 .../mellanox/mlx5/core/lib/macsec_fs.h        |   9 +-
 .../net/ethernet/mellanox/mlx5/core/main.c    |   3 +
 include/linux/mlx5/driver.h                   |   7 +-
 tools/testing/selftests/drivers/net/Makefile  |   5 +
 tools/testing/selftests/drivers/net/gro.py    | 200 ++---------
 .../testing/selftests/drivers/net/gro_lib.py  | 204 +++++++++++
 .../testing/selftests/drivers/net/hw/Makefile |  17 +
 .../selftests/drivers/net/hw/psp_gro.py       | 172 +++++++++
 tools/testing/selftests/drivers/net/psp.py    |  77 ++--
 .../testing/selftests/drivers/net/psp_lib.py  |  57 +++
 tools/testing/selftests/net/lib/Makefile      |  16 +
 tools/testing/selftests/net/lib/gro.c         | 337 +++++++++++++++++-
 28 files changed, 1431 insertions(+), 367 deletions(-)
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en_accel/flow_tag.h
 create mode 100644 tools/testing/selftests/drivers/net/gro_lib.py
 create mode 100755 tools/testing/selftests/drivers/net/hw/psp_gro.py
 create mode 100644 tools/testing/selftests/drivers/net/psp_lib.py


base-commit: c29b37ed7a4d9856ed758a82282456d69cee2ed1
-- 
2.44.0

