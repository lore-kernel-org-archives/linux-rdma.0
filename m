Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11012055.outbound.protection.outlook.com [52.101.48.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1062B38B7D9;
	Tue,  8 Sep 2026 06:53:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.48.55
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788850425; cv=fail; b=c0P7YbEfkmNAW91QaVoAuMZpGMX1A6LKhSWTbvja5375IWGIyRxWpT18SXuXTdi7ilrJZYlSo2Hi+jojs+3H/WNHobTK98H2TAdAf147NK6c5FmCoLnucr/Lis1IMHQuzVPJa6S9HafLIDX4TkYW0bCzJn84qzhP4CO5sONotDw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788850425; c=relaxed/simple;
	bh=8htw/KUtxLEh59R71GmegWhtGhSVklZD8Y+4ZnBr2tw=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=kXWAzYFrAxrSLcfXP+Jgo4A8op78CVcX9HE84y7Z8LxYygA8NLosZfOXlUJbHhdpWOsZZNCICXgEAB0RX2jgenMq+wpIqM1Zj3JzzRiUG9XRmyba7GqTL3EcdERO40iAgZWzPzAQ2iNw+k1dxCi1KqrSas26W8bdQVr2MQ8pB80=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=lA8wqKIF; arc=fail smtp.client-ip=52.101.48.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="lA8wqKIF"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=SOOzm7m/zGQ6CdHhO9bQHUltr8ULVlsC5R2jRz8vEmC3G6xHGm7eDrinX5qQHoxAjcdftGtIPfuuoVLAxBwtlCWN7xAVHEbKlKIr5rj4+4jjZjpMwu0bMqViQT+MZXIpjVUYU+D3ib9NjxmS+NqE9TJPVHjPQDSClh2YAQrbvgT5OrDiJ0kHu1l9obt3Ul4gfI0LZCD2tVJIqE8uxIF60mx25XTLu82GsszXo7Btz+0LSJRmH4xpVg/q0uzvX+uUOeNYU4CcVw5+i6yhEYpaTfpnWsl3vFcU75ecdOI0m0GaEmj3ZSx+QtAIxGrd4clBL1eMGRqDF2A2lVPZrYhL1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=j5j9ANX9DB1cp8Vfrn5uS1ZARDvQA8ojx5XrK2qvWgM=;
 b=pxkN8mRVHYnSUS/PDTFN6Brafs4zcjiNa9B1g1SK+wHRw5tIRseH73X/dGqwvl0Df1+DM4U8NPnHNPOSy8jL2GCP+WOrdUtHEWR0NgWDIcwRq3cRcpoR2Fi8yUYug8hYlcXWVfOWPKcScDY6o6V0qlh4zvMureqDLANqMPDnNPmgIwvcDIQuiWQgCJs4pX0D9DRMCaiMlHYXtc7tTz8Ss9UFm1YJowbhGDCJ4LPPkc88VjSdcRMm03nsk7xKO9V0qxRuWv3OGq1Z+Z2/yAOpRY232EWdQrVLCi71fSUlNBvcE1OSvK4HLECjzJHcLSbLVfHeEXqrLqehv/UV4RHhWg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=j5j9ANX9DB1cp8Vfrn5uS1ZARDvQA8ojx5XrK2qvWgM=;
 b=lA8wqKIFfR6OyVkST2rZHlqbFn+azCcYdrbCSyeb26v1lDEFkzjMpsVf23kZsEJQogfYTR0YVSZ5wyKzIPdE1kmqMAyNa7rnzOr9YR11ZP9laBuvA6UWuZE0aHomWQj5RnkxX8j7UZlyjLj8+ChkjSIq1CPYNQRLGC6sxzSrzEqmT4Yshbp8CO4ji/Xc+DGd6CFulblJgRudfbV5Jf0FpCEkjGI4ynujSWia3xdU9Ibkm1jtcofG8f28sOGBSqN/nHCNz5pGaopghY0Dke19+YeDnQksX1VRC/bLqxXujllw/RwbsVARLM46cya8JFYyNDMZ8UvHFmSHv2JQJ5ySQA==
Received: from BL1PR13CA0275.namprd13.prod.outlook.com (2603:10b6:208:2bc::10)
 by CY5PR12MB6156.namprd12.prod.outlook.com (2603:10b6:930:24::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.15; Tue, 8 Sep
 2026 06:53:33 +0000
Received: from BN7PEPF000000A6.namprd05.prod.outlook.com
 (2603:10b6:208:2bc:cafe::7a) by BL1PR13CA0275.outlook.office365.com
 (2603:10b6:208:2bc::10) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.406.6 via Frontend Transport; Tue, 8
 Sep 2026 06:53:33 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BN7PEPF000000A6.mail.protection.outlook.com (10.167.245.230) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.406.5 via Frontend Transport; Tue, 8 Sep 2026 06:53:32 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.46; Mon, 7 Sep
 2026 23:53:19 -0700
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.46; Mon, 7 Sep
 2026 23:53:19 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.9)
 with Microsoft SMTP Server id 15.2.2562.46 via Frontend Transport; Mon, 7 Sep
 2026 23:53:11 -0700
From: Tariq Toukan <tariqt@nvidia.com>
To: Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
	<davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Jakub Kicinski
	<kuba@kernel.org>, <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Sabrina Dubroca <sd@queasysnail.net>
CC: Bobby Eshleman <bobbyeshleman@meta.com>, Boris Pismenny
	<borisp@nvidia.com>, Carolina Jubran <cjubran@nvidia.com>, Cosmin Ratiu
	<cratiu@nvidia.com>, Daniel Zahka <daniel.zahka@gmail.com>, Doruk Tan Ozturk
	<doruk@0sec.ai>, Dragos Tatulea <dtatulea@nvidia.com>, Gal Pressman
	<gal@nvidia.com>, Jianbo Liu <jianbol@nvidia.com>, Kees Cook
	<kees@kernel.org>, Leon Romanovsky <leon@kernel.org>, open list
	<linux-kernel@vger.kernel.org>, <linux-kselftest@vger.kernel.org>,
	<linux-rdma@vger.kernel.org>, Mark Bloch <mbloch@nvidia.com>, Petr Machata
	<petrm@nvidia.com>, Raed Salem <raeds@nvidia.com>, Rahul Rameshbabu
	<rrameshbabu@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>, Shuah Khan
	<shuah@kernel.org>, Shuah Khan <skhan@linuxfoundation.org>, Simon Horman
	<horms@kernel.org>, Tariq Toukan <tariqt@nvidia.com>, Willem de Bruijn
	<willemb@google.com>, Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Subject: [PATCH net-next V4 00/14] net/mlx5e: Add support for HW-GRO to PSP
Date: Tue, 8 Sep 2026 09:52:30 +0300
Message-ID: <20260908065244.3799142-1-tariqt@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BN7PEPF000000A6:EE_|CY5PR12MB6156:EE_
X-MS-Office365-Filtering-Correlation-Id: ec9741b7-915c-46db-6d00-08df0d75e60c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|36860700016|82310400026|1800799024|23010399003|13003099007|3023799007|11063799006|56012099006|6133799003|18002099003|10067099003;
X-Microsoft-Antispam-Message-Info:
	Z/yVsyYc+S0BmXeAhUETlBZiDDVlnBqq+w5wZ6QLNrxUUXnC7HWrmmEwPee7mue4GfjRBhJW0O2xmEBJytGzpNwlPT5+FzdUvXcMTiXQsdnaLl5w6TRwXWfspmUZXcWelM5G14O9BficZaXeOEIFifRUkNpYKFbD14z78ZtGyk+79mF37ZC6VotzYhqxXm0AaDFYi66PEeVJb4mQ2iOyBkX1lLRhSN+wJ9fL1Wrmh0R+B8lSxAXx1+sDMvKlbkbp1aCfoVwXjwOoOhS4GGdRiR98hWZuwMMdBtfnjIDvnSnVfyOKPK0IXVOHEtLx+NZhk1nVPP3r7uEjA+RJfdxc9Eau52whxQFiBrB+9zNhxBYBGf+zkIfhPVNiNU4/n9kIP+AnWMEwH23RsCEeRCbgC3InE0KEO1NoFy0vqsy9MXX3W5EVhjCJAVCTg9wHWV25G+sSyxSOF/4qH4MOuonXMQnd+2EoEAG7k+YfJQPPyJIS9RpHDKVMUbbA477k5CCoGVSSx7X3/RugtMpHTJKlY8GWL1PEUdACwzNi6iGT6q7k5XisOd15URA4ieqlNnxC0DBWlB5+9V3T2UgkvYFTe2nfPHAcfMF/rKasaMzcqPFPmdxG3nArseMQS46DrzmvQLLIM7Ce26datplXKJlykxcMpbgVSWsM4XpTdcE6B6EhX7plbz0kZ1ThaJWLssMftysju1YNsI3smK6XMc03kQ==
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(7416014)(376014)(36860700016)(82310400026)(1800799024)(23010399003)(13003099007)(3023799007)(11063799006)(56012099006)(6133799003)(18002099003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	XChqX/Ns5tOylEkEwNfCKn3vpEGx/woblUWIAfoJ/w9m/fWB/3ngZ0hYDwdusTglNkqvu1S9K76eKoEOuNVJbhv/YJhKQ+JzGAWmN8BwvoSKUyA/RP02enSZbdNwwoq1yr7FJbJIBr5SbCMQBTdBc4HJAE5LOrA176KPg1YvBqZIjHCks1MLcok/aNosRyqnq1NDU/DnkKeB8LMkFBMYYQLOW1ma5cVYJxPI6ZEVdu2oj1lAKRmGynHz7U+AojhC4r/BYxRvtW6+1kKvMeiv6pZK+wuZbb7ajjX1rNUstZ5uz5hp88uTQa+DlMtcD44QsOAijCtIq4biJpEMkZni8eJaLHoXaSovx6qsFExwkaXEjy9oIqtZ7t1I6KcaRCoNtbEkBaBt+UVSMN4KN84TE3IOkB1V2Fel8y0XdVhR3h8Hl5ePcerf27QUeu3+KnOS
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Sep 2026 06:53:32.9933
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ec9741b7-915c-46db-6d00-08df0d75e60c
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN7PEPF000000A6.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6156

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

Some preparatory work needed to happen to allow that:
- All accel protocol markers were moved away from ft_metadata into
  flow_tag
- Mutual exclusion between TC and accel protocols was added. Trying to
  configure both IPsec and TC at the same time for example is now
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

V4:
- Removed dead mlx5_esw_lock() (Daniel).
- Rebased on top of f225a7317c18 ("selftests: drv-net: split gro.py into one test per coalescing mode") (Daniel).
- Dropped the gro_lib.py extraction, made obsolete by above change.
- Fixed some typos (Aleksandr).
- Added CONFIG_INET_PSP=y to the test config (Daniel).

V3:
https://lore.kernel.org/netdev/20260903085215.3691657-1-tariqt@nvidia.com/
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

Cosmin Ratiu (14):
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
 .../net/ethernet/mellanox/mlx5/core/eswitch.c |  12 -
 .../net/ethernet/mellanox/mlx5/core/eswitch.h |   1 -
 .../mellanox/mlx5/core/lib/macsec_fs.c        |  21 +-
 .../mellanox/mlx5/core/lib/macsec_fs.h        |   9 +-
 .../net/ethernet/mellanox/mlx5/core/main.c    |   3 +
 include/linux/mlx5/driver.h                   |   7 +-
 tools/testing/selftests/drivers/net/Makefile  |   1 +
 .../testing/selftests/drivers/net/gro_lib.py  |  15 +-
 .../testing/selftests/drivers/net/hw/Makefile |  17 +
 tools/testing/selftests/drivers/net/hw/config |   1 +
 .../selftests/drivers/net/hw/psp_gro.py       | 157 ++++++++
 tools/testing/selftests/drivers/net/psp.py    |  77 ++--
 .../testing/selftests/drivers/net/psp_lib.py  |  57 +++
 tools/testing/selftests/net/lib/Makefile      |  16 +
 tools/testing/selftests/net/lib/gro.c         | 337 +++++++++++++++++-
 30 files changed, 1198 insertions(+), 206 deletions(-)
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en_accel/flow_tag.h
 create mode 100755 tools/testing/selftests/drivers/net/hw/psp_gro.py
 create mode 100644 tools/testing/selftests/drivers/net/psp_lib.py


base-commit: bc6fe9d301d59fe5cb236d646abe792bffae5fa6
-- 
2.44.0

