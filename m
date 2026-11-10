Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.196.49
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794303429;
	b=liucd2/LJ2fbqkU1YAqRXYXnjp5bAv9UiHzQN+yJsJa/rFWhcAaj4JbbiWoSovWHG33p
	 TQZ5r/f6zSo5S2ewCVIjW1cskY0uQA98Nd/Fbe2ne06ntUKlYYHRes+V45tJmTnGwGLod
	 VAJFrYs/EkxgWqQ+1xpH4jgokmtfwARNI4mvFX4zd3hRpWLm+qwj/6lBs/6WV0pVY4T0O
	 qJqVzo7INI+QRzkDN86idYscrjkbUp/ZT07wQa6cTLQQA7HE1rQir5GMcHptJKQfQ4UhY
	 EKPpBSS7aswSxBBoKdwOqN4QWOuzNpsElSxCJXQO/GYaxRcECCtO4JGcq8+orlwPwJA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794303429;
	h=DMARC-Filter:DKIM-Signature:Received:Received:
	 X-MS-Exchange-Authentication-Results:Received-SPF:Received:Received:
	 Received:From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
	 References:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 X-Originating-IP:X-ClientProxiedBy:X-EOPAttributedMessage:
	 X-MS-PublicTrafficType:X-MS-TrafficTypeDiagnostic:
	 X-MS-Office365-Filtering-Correlation-Id:X-MS-Exchange-SenderADCheck:
	 X-MS-Exchange-AntiSpam-Relay:X-Microsoft-Antispam:
	 X-Microsoft-Antispam-Message-Info:X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-Id:
	 X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=kkuHBCLLkER1nWzWwOZ5Xp3mIIgxwtJHK6WfBGqeckw=;
	b=pzQbPa4Fali+FXobjTjE+L4U9EEfsFLV+3+k+MjCKpXdS+h9uqMTQ73CICnurnk3g1M+
	 pd0HdRC4m6q5zUHxYg3NaWaM9tR7soV4qbkEbRK6U0cOhO7PSBS+wFPS4pdAjy+DReLz/
	 G4Duv4k+WpQ0TexhccNWSSsUj9DrWKRXbK9iz9QgtXIYAWo3bWIz+HFp627p79ikmq6RU
	 y/dUIVsAsjUnfHpPwk0f05MHfBur9qUy62K3mV6nEChxLOgqC61uyO8ZCLEtm+6f4+0RA
	 2BGBbXqGFzKI7OorTWllBQujjGwM72HLBR49Fyu+OD8gPXUz6Ni7VQKatgm/Ys11QYQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=X175lct3;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.196.49
Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013049.outbound.protection.outlook.com [40.93.196.49])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2207D606EEC7;
	Tue, 10 Nov 2026 09:37:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2207D606EEC7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=X175lct3
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Q6StG6ch2T//yfNmQq5unTTw1D/Ex3eRdWuU/cf2M15UpbRqUZyDKdzK6VWCycuQy8GiZVc1Eqyo9Gs5nhvYAyQq5JBARRoB+d21jDW7M0xwyWMvLjTmXS5T+59MTOdiBVuMBKx2KtBO034bF8GDQXo+5FsKYjbwaXEBaiJHismi1c03IEl5Q/as0ACXH0XmwHounQ2sD2k+0NMwl5zw85ABi4Mq70ax3wIYQrbLPjrE6FC3Nw0cKMxHeSflSYzKhXhaj84owNeWPPcVdlPwsCS59jh6wP4FhALK+sYl2BzNcSbbH0bjUQt/+g0Fq8ChDsaYw5HQAwbeuuyugDZI3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kkuHBCLLkER1nWzWwOZ5Xp3mIIgxwtJHK6WfBGqeckw=;
 b=UDcylVuNfJn0+uOj2rVxfsuDMd0K4r5iqa8ROnVzSxgO5TdWdUbemDis603EInlFKneOWCgSwfiIkIYn8QVBAS5WFmDIOBhJ9iG9ZiQl5Lz9dCoCqp3HJPOcNdvjbFaqpIubCcpfBZmnayiaP9LMlg1lMwqStJO8ibINeEt+pRocrjKJ8lbDaxOm1oM8+KqAfFQuOfqI1XiZdbaGyYBcsPIBWrHsR8n5cygOSWMoOsMyemKHl8T6PXXST2JwR6DzoCqxZTAfHTsqC7aReMSl4LxPSKC3bHnwPkJsONzpTjBii8qvlGl3iyQGqDJ9E2lcibwHzGrK9pdlVP7ErpcRFw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kkuHBCLLkER1nWzWwOZ5Xp3mIIgxwtJHK6WfBGqeckw=;
 b=X175lct3H0aMdNd7QzqOeyJQGWVxK5mSJc/HVFzSWfTCppQcxua24vl1HJTIvcDAkU8SzZ+20X/8wAJFc9OBlKsUK/0IjXnOdf0JvGldcj8SHU7poHhDaebEQ6rCdORuxvrHKK/nKeZ5VQeiJO6+g3iNrmwJNt4J9wrS7LoVKd0jLdtVBuDZKJINYr29JJYk94Yrnlcr0Q1quplSAe6VqCHvprf/5y1iBsJJaGS8vEoBLLVNyoojffmCKsqIFU8Mxt/0cZ0ot50LlDLJFsmit8+Px6tEwdeKD14+tzbfKUQ+IIEp/255pyzFddi+83+7sdZFY2UcyhC0FM7w0t5efw==
Received: from CH2PR08CA0001.namprd08.prod.outlook.com (2603:10b6:610:5a::11)
 by SJ2PR12MB9163.namprd12.prod.outlook.com (2603:10b6:a03:559::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.12; Tue, 10 Nov
 2026 09:37:04 +0000
Received: from CH01EPF000BE949.namprd02.prod.outlook.com
 (2603:10b6:610:5a:cafe::aa) by CH2PR08CA0001.outlook.office365.com
 (2603:10b6:610:5a::11) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.592.13 via Frontend Transport; Tue,
 10 Nov 2026 09:37:03 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.117.161) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CH01EPF000BE949.mail.protection.outlook.com (10.167.244.197) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.615.4 via Frontend Transport; Tue, 10 Nov 2026 09:37:03 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Tue, 10 Nov
 2026 01:36:38 -0800
Received: from nps-server-23.mtl.nbulabs.nvidia.com (10.126.231.37) by
 rnnvmail201.nvidia.com (10.129.68.8) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56; Tue, 10 Nov 2026 01:36:33 -0800
From: Shay Drory <shayd@nvidia.com>
To: <tariqt@nvidia.com>
CC: <andrew+netdev@lunn.ch>, <davem@davemloft.net>, <edumazet@kernel.org>,
	<kuba@kernel.org>, <netdev@vger.kernel.org>, <pabeni@redhat.com>,
	<agoldberger@nvidia.com>, <cjubran@nvidia.com>, <cratiu@nvidia.com>,
	<edwards@nvidia.com>, <gal@nvidia.com>, <leon@kernel.org>,
	<linux-kernel@vger.kernel.org>, <linux-rdma@vger.kernel.org>,
	<mbloch@nvidia.com>, <moshe@nvidia.com>, <ohartoov@nvidia.com>,
	<phaddad@nvidia.com>, <saeedm@nvidia.com>
Subject: Re: [PATCH net-next 12/15] net/mlx5: E-switch, match master egress rule by vport metadata
Date: Tue, 10 Nov 2026 11:36:25 +0200
Message-ID: <20261110093625.378702-1-shayd@nvidia.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20261103171009.563034-13-tariqt@nvidia.com>
References: <20261103171009.563034-1-tariqt@nvidia.com> <20261103171009.563034-13-tariqt@nvidia.com>
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: rnnvmail201.nvidia.com (10.129.68.8) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH01EPF000BE949:EE_|SJ2PR12MB9163:EE_
X-MS-Office365-Filtering-Correlation-Id: 00f61b1b-9c1f-44a6-0e84-08df3f0e2db2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|1800799024|82310400026|36860700016|56012099006|261009223027099003|11063799006|5023799004|4143699003|261021121427099003|261022075727099003|261021123027099003|261102123227099003|261026121527099003|10067099003|22082099003|18002099003|6133799003|3023799007;
X-Microsoft-Antispam-Message-Info:
	sAkOZeIkoUOiETRDMOp91fyPUPubqJrRE95DNJgtxdG1Ja1WaEreZ9s7VPPhmE1dILYC88Qb2deoIISPog659wLkHxY2CGtsJQGCQHIDmzM6DpoRRP+HY0+LDen4qGICb/uDMUnB6tuyLdToFCqiKStKXkTOVgA5AO/KQ9cgw/c44YObcO14ckKRn9uMN101jAck+utWYeNRzTOPYEtmwIEOAaSmpM0ZvcJuaKWbAHxjDy3rA9IOb1yCmdSPBVMai6ILnNOKm56qYqSMTtq10x9MSkEYtOw8EEv5oMiknrwwQXsoRXUflmOCIKdit6BPhmnG5a4/o56OdSdYDc/7EElK2QGs3n1SEa3JXjCopHWTWtnX10lP+Wrlzy1NenroXUX7c8ITJha0aCkDJTc6S4308i/CJj6K7Uzh4t/M2YDOtq1k7n8WIuNZjsjpYtEYL6J16loILucQJygOE5Eu3DFrgnQ8o6wemXhjx9biPSq7SXug5G0rv5ysXuBpLdKt+KhZNbzFysjwrFmXr8KAIGzfwooERfdiJcpV5Ax9QTUIBP0nYA6ovy66SxTCSDKkTqPbJWb93EaG5Sy537MjgWD8BU9rr5ua279K0V4ZL8xzEwwV5B6MXo+lkLaCvTs10KOOjK0TsWGDa5UNptBolBpd9i708bkxLt/Cn9KPeWAqC5ZkTHFxonbQmW5bv37vW7rtuwFfZganypctWxnmOg==
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(23010399003)(376014)(1800799024)(82310400026)(36860700016)(56012099006)(261009223027099003)(11063799006)(5023799004)(4143699003)(261021121427099003)(261022075727099003)(261021123027099003)(261102123227099003)(261026121527099003)(10067099003)(22082099003)(18002099003)(6133799003)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	YPh4GUlG/4LfRtDBo4M3rmHbKnvu0PCiojrAbjGw0W3EejcJjjaVPo2dUoLWzmHCa7E74qQxiXPb1jiSi57xmw9BIg7TE6+1pt5GZn6qPsW+kvhIzD4JSheNmUxx4lxipFtE/dvKNsqSVGZBNIhqx0Mc/P7myOwmtyJ1NEyKu99YC2A6/ilmPohEM29YqA4FEfRWf/WrnWC+jpvmPlU31Hyf3t6I0aL27h7poI/goFCARJhRLWFfwUtNwL2stR2Ajcv9CvTpGZY6TwiDVOdLFL0VA7xZsyiQHolOjLazBtMv14glOeUSEzCHDARgba5NYA8A38zJP4LHYhcfxRiGIuZPDI7btYAfR3+/ImE+U43U64iYP9806e1f+eoBYy5gSPtPRdfNH4RyxhefWVcx9taWbraRrbas2lzW6MeclJ3LfP8a9siKV62IzVAzLpt9
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Nov 2026 09:37:03.7225
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 00f61b1b-9c1f-44a6-0e84-08df3f0e2db2
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH01EPF000BE949.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB9163

On 03/11/2026 19:10, Tariq Toukan wrote:
> From: Shay Drory <shayd@nvidia.com>
>
> The master egress-ACL bounce group and rule matched the slave uplink by
> source_port + source_eswitch_owner_vhca_id. Virt LAG master cannot match
> that way; it must match by vport metadata (reg_c_0).
>
> Virt LAG only supports MPESW, where every uplink has a unique metadata.
> Hence, use metadata matching when LAG is virt LAG, and keep the
> source_port + source_eswitch_owner_vhca_id match otherwise.
>
> Signed-off-by: Shay Drory <shayd@nvidia.com>
> Reviewed-by: Mark Bloch <mbloch@nvidia.com>
> Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
> Reviewed-by: Akiva Goldberger <agoldberger@nvidia.com>
> Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
> ---
>  .../mellanox/mlx5/core/eswitch_offloads.c     | 78 +++++++++++++------
>  1 file changed, 55 insertions(+), 23 deletions(-)
>
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
> index ef1043517e9e..d633c63b309b 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
> @@ -3000,6 +3000,26 @@ static int esw_set_slave_root_fdb(struct mlx5_core_dev *master,
>  	return err;
>  }
>  
> +static void mlx5_esw_set_spec_source_port_vhca(struct mlx5_flow_spec *spec,
> +					       u16 vport, u16 vhca_id)
> +{
> +	void *misc;
> +
> +	spec->match_criteria_enable = MLX5_MATCH_MISC_PARAMETERS;
> +
> +	misc = MLX5_ADDR_OF(fte_match_param, spec->match_value,
> +			    misc_parameters);
> +	MLX5_SET(fte_match_set_misc, misc, source_port, vport);
> +	MLX5_SET(fte_match_set_misc, misc, source_eswitch_owner_vhca_id,
> +		 vhca_id);
> +
> +	misc = MLX5_ADDR_OF(fte_match_param, spec->match_criteria,
> +			    misc_parameters);
> +	MLX5_SET_TO_ONES(fte_match_set_misc, misc, source_port);
> +	MLX5_SET_TO_ONES(fte_match_set_misc, misc,
> +			 source_eswitch_owner_vhca_id);
> +}
> +
>  static int __esw_set_master_egress_rule(struct mlx5_core_dev *master,
>  					struct mlx5_core_dev *slave,
>  					struct mlx5_vport *vport,
> @@ -3011,22 +3031,22 @@ static int __esw_set_master_egress_rule(struct mlx5_core_dev *master,
>  	struct mlx5_flow_act flow_act = {};
>  	struct mlx5_flow_spec *spec;
>  	int err = 0;
> -	void *misc;
> +
> +	if (mlx5_virt_lag_is_supported(master) &&
> +	    !mlx5_eswitch_vport_match_metadata_enabled(slave->priv.eswitch))
> +		return -EINVAL;
>  
>  	spec = kvzalloc_obj(*spec);
>  	if (!spec)
>  		return -ENOMEM;
>  
> -	spec->match_criteria_enable = MLX5_MATCH_MISC_PARAMETERS;
> -	misc = MLX5_ADDR_OF(fte_match_param, spec->match_value,
> -			    misc_parameters);
> -	MLX5_SET(fte_match_set_misc, misc, source_port, MLX5_VPORT_UPLINK);
> -	MLX5_SET(fte_match_set_misc, misc, source_eswitch_owner_vhca_id, slave_index);
> -
> -	misc = MLX5_ADDR_OF(fte_match_param, spec->match_criteria, misc_parameters);
> -	MLX5_SET_TO_ONES(fte_match_set_misc, misc, source_port);
> -	MLX5_SET_TO_ONES(fte_match_set_misc, misc,
> -			 source_eswitch_owner_vhca_id);
> +	if (mlx5_virt_lag_is_supported(master) &&
> +	    mlx5_eswitch_vport_match_metadata_enabled(slave->priv.eswitch))
> +		mlx5_esw_set_spec_source_port(slave->priv.eswitch,
> +					      MLX5_VPORT_UPLINK, spec);
> +	else
> +		mlx5_esw_set_spec_source_port_vhca(spec, MLX5_VPORT_UPLINK,
> +						   slave_index);

answers to net-dev sashiko

Sashiko (Medium):
Is mlx5_virt_lag_is_supported() enough to decide on reg_c_0 matching here?
It only checks static capability bits:
lag/lag.h:mlx5_virt_lag_is_supported() {
    if (!MLX5_CAP_GEN(dev, multi_uplink_eswitch) ||
        !MLX5_CAP_GEN(dev, lag_master) ||
        MLX5_CAP_GEN(dev, num_lag_ports) >= 2)
        return false;
    return true;
}
That says nothing about the mode the shared FDB was actually created in.
The commit message says "Virt LAG only supports MPESW, where every uplink
has a unique metadata". The code relies on that, but it never checks that
mlx5_mpesw_metadata_set() has run.
Outside MPESW, each uplink gets its default metadata from
mlx5_esw_match_metadata_reserved(), which returns
MLX5_ESW_METADATA_RSVD_UPLINK. The comment there says both uplinks share
this value in shared FDB mode.
Suppose a virt-LAG capable master gets a shared FDB in a non-MPESW mode.
Would this bounce FTE then match reg_c_0 == MLX5_ESW_METADATA_RSVD_UPLINK?
That is also the master's own uplink metadata. If so, master uplink
traffic would be sent to the slave manager vport.
Rules for several slaves could also collide in one group. The group mask
from mlx5_esw_set_flow_group_source_port() in
esw_master_egress_create_resources() no longer includes
source_eswitch_owner_vhca_id.
For VF/SF virt LAG at the end of the series, this case appears
unreachable:
- the SRIOV shared FDB needs MLX5_LAG_FLAG_NDEVS_READY, which is never set
  for virt_lag
- multipath is blocked for virt LAG
- SD is PF-only
One case is left: a PF that reports the virt LAG capability bits and also
supports SD. In that case sd.c would call:
    err = mlx5_lag_shared_fdb_create(ldev, NULL, 0, sd->group_id);
with only the reserved uplink metadata in place. The commit "add
match-metadata allocator for nested VF/SF eswitches" says PFs may have
virt LAG capabilities.

[SD] This is not correct, PFs cannot have virt LAG caps; FW exposes
them only on VF/SF nested eswitch managers. The wording in the
"add match-metadata allocator" commit message is misleading, and will
be fixed in case of v2.

Could this be gated on runtime state instead, for example ldev->virt_lag
together with MPESW mode or pf_metadata being set? Or could the invariant
at least be documented?
The new -EINVAL above, for virt-LAG capable devices with metadata matching
disabled, is also not mentioned in the commit message. Could the message
describe this behavior change?
At this commit the new branch is not reachable, because
mlx5_lag_add_mdev() still requires mlx5_lag_is_supported()
(num_lag_ports >= 2).

>  
>  	flow_act.action = MLX5_FLOW_CONTEXT_ACTION_FWD_DEST;
>  	dest.type = MLX5_FLOW_DESTINATION_TYPE_VPORT;
> @@ -3179,6 +3199,21 @@ static void esw_unset_slave_egress_rule(struct mlx5_core_dev *master,
>  	esw_slave_egress_destroy_resources(slave_vport);
>  }
>  
> +static void mlx5_esw_set_flow_group_source_port_vhca(u32 *flow_group_in)
> +{
> +	void *match_criteria = MLX5_ADDR_OF(create_flow_group_in,
> +					    flow_group_in, match_criteria);
> +
> +	MLX5_SET_TO_ONES(fte_match_param, match_criteria,
> +			 misc_parameters.source_port);
> +	MLX5_SET_TO_ONES(fte_match_param, match_criteria,
> +			 misc_parameters.source_eswitch_owner_vhca_id);
> +	MLX5_SET(create_flow_group_in, flow_group_in,
> +		 match_criteria_enable, MLX5_MATCH_MISC_PARAMETERS);
> +	MLX5_SET(create_flow_group_in, flow_group_in,
> +		 source_eswitch_owner_vhca_id_valid, 1);
> +}
> +
>  static int esw_master_egress_create_resources(struct mlx5_eswitch *esw,
>  					      struct mlx5_flow_namespace *egress_ns,
>  					      struct mlx5_vport *vport, size_t count)
> @@ -3189,13 +3224,16 @@ static int esw_master_egress_create_resources(struct mlx5_eswitch *esw,
>  	};
>  	struct mlx5_flow_table *acl;
>  	struct mlx5_flow_group *g;
> -	void *match_criteria;
>  	u32 *flow_group_in;
>  	int err;
>  
>  	if (vport->egress.acl)
>  		return 0;
>  
> +	if (mlx5_virt_lag_is_supported(esw->dev) &&
> +	    !mlx5_eswitch_vport_match_metadata_enabled(esw))
> +		return -EINVAL;
> +
>  	flow_group_in = kvzalloc(inlen, GFP_KERNEL);
>  	if (!flow_group_in)
>  		return -ENOMEM;
> @@ -3209,17 +3247,11 @@ static int esw_master_egress_create_resources(struct mlx5_eswitch *esw,
>  		goto out;
>  	}
>  
> -	match_criteria = MLX5_ADDR_OF(create_flow_group_in, flow_group_in,
> -				      match_criteria);
> -	MLX5_SET_TO_ONES(fte_match_param, match_criteria,
> -			 misc_parameters.source_port);
> -	MLX5_SET_TO_ONES(fte_match_param, match_criteria,
> -			 misc_parameters.source_eswitch_owner_vhca_id);
> -	MLX5_SET(create_flow_group_in, flow_group_in, match_criteria_enable,
> -		 MLX5_MATCH_MISC_PARAMETERS);
> -
> -	MLX5_SET(create_flow_group_in, flow_group_in,
> -		 source_eswitch_owner_vhca_id_valid, 1);
> +	if (mlx5_virt_lag_is_supported(esw->dev) &&
> +	    mlx5_eswitch_vport_match_metadata_enabled(esw))
> +		mlx5_esw_set_flow_group_source_port(esw, flow_group_in, 0);
> +	else
> +		mlx5_esw_set_flow_group_source_port_vhca(flow_group_in);
>  	MLX5_SET(create_flow_group_in, flow_group_in, start_flow_index, 0);
>  	MLX5_SET(create_flow_group_in, flow_group_in, end_flow_index, count);
>  
