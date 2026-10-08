Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011027.outbound.protection.outlook.com [40.93.194.27])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEFDD31ED7C;
	Thu,  8 Oct 2026 16:02:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.194.27
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791475357; cv=fail; b=YI2SF5heTva07Yq2qgR0X+G3YEo6MI/2xM0w1VXI+ccOsWhorThOIXS0D1kozHVCrHXvM3eUE+otmmAtyuidHgU6Ber4hCweB98VxuAzsfWg4KBVV390YxyH5KAi6C3EptM8T3TLE+rAPJG6LR6t7Qo7WHCkX3pEywN3qMLtgss=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791475357; c=relaxed/simple;
	bh=6NQHoIQe7dkKtnVlgc/y9WIsL9u2ZHZpPUqwPUqdR4k=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=meXVjfWYPSJjDvakhb4k9GWtIhVC7KrSVdKscEzGKAHatwnFW3KJSvRxOJJUDt2sU663yCOumuqqZH3JnCPIfdCGAwfntnC0SNU3GLbQgkcCERRrlZhWogdkomu7k5pGe544EYPbLDw05OVeJHX6KxvOe8oDfPiCAV5IAYeVBrM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=en969aq4; arc=fail smtp.client-ip=40.93.194.27
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="en969aq4"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=r/3U+Yk5fNe32GsEf+vLbRJwkNQ7Bb4XgDQwDiVWvnKrkhFLzw/6sPEc811M72CViNFTcwgD9LxoreZjXYryDWuviGsbHj1eG5or5HP2N6q/h6lsjVFH5SOQY1pwQOMlwhQhCmB7woHvSkr4XqfODPsygt+Plx3k+PSjLsq5PGaDcJ3XuBWh8JEf/3eaiQO2+smlBob3oNwXrgfALEbiEyuMwH0ktKqup5QYES+egE0mGmvAEKFIBTNCa0kuyUzTFmc8ny0k6X9g2GEi6V3Uv4dR3mzwnyMAyduU2PxuP1Typ1L7Wbokt1UsFWd/yMx5yxCXINlP518HUrSOU5M/cQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=18sSBec6tc2gRRguvs+r53gaBfpUlYykh5/SWi7HgLg=;
 b=CvL8wRPiSNZ1FDl7by9qZE947NiN/fRgeKMCeLf/QfCjUWG2tR9bXXX5w3ZTgwHmadgfZNdjsDp+ASX4y9/5PfzNrKEnNgl1IZV0P1VDzeKRbM4wjXRF/M/OreaP3KTJp5a4l6bIbE7yXrWQdcsxNwEDfI5uJ0Ow6bY2lSCjzIcpf55meRhqbNhVXEdK7xOtKg4sdMtUnTlEIa9I7gBRBlctTDRL5yB+8J0QmirXfZtI0VnAWhyibMpeLiD/cGzYujTDG0LRfeBzMCkthnwG/G1BlvV0rla8xI/V9yuU9ogTKeTTN8mnQwChjrft7NiWC7Pv+xxhYWS5E6CxroCU4g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=corp.free.fr smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=18sSBec6tc2gRRguvs+r53gaBfpUlYykh5/SWi7HgLg=;
 b=en969aq47CbqbPo2X6hFY0T63ktV6WZEOlP2MXSWP6j9WHGcE8N1vVM5HSSdh/6YaheePOVn8e3mJhrPuOZK967WfAdbtiuAsJGO4EDNsfuuYW+6PRV+VqrcN/unab1xfwY5G65y95tAANB119TxQeJS7W1x8B2f0YrQbld45y74yr44jVa5KwhqvwDi4rUdisJsnwXakeExwzLvDOrhzl6PgjC2aRtneFKoBbfzi4cRDG8tOm9SpuvudXbqENsRUewdtFoJ9goGzWocMBapA5gotqgcr+JPU3OepwI+MmO3VNeCOC6V5MXblco/EprMDDiQyUkNdFMOmRx6wgRciw==
Received: from CH0PR07CA0007.namprd07.prod.outlook.com (2603:10b6:610:32::12)
 by DS5PPFF2923D4C1.namprd12.prod.outlook.com (2603:10b6:f:fc00::669) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.496.15; Thu, 8 Oct
 2026 16:00:23 +0000
Received: from CH1PEPF0000A34B.namprd04.prod.outlook.com
 (2603:10b6:610:32:cafe::72) by CH0PR07CA0007.outlook.office365.com
 (2603:10b6:610:32::12) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.496.5 via Frontend Transport; Thu, 8
 Oct 2026 16:00:23 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.117.160) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 CH1PEPF0000A34B.mail.protection.outlook.com (10.167.244.10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.522.6 via Frontend Transport; Thu, 8 Oct 2026 16:00:23 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Thu, 8 Oct
 2026 08:59:57 -0700
Received: from [10.242.158.223] (10.126.231.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Thu, 8 Oct
 2026 08:59:53 -0700
Message-ID: <03f7a3ae-e223-48bb-bd4c-3a12288257b0@nvidia.com>
Date: Thu, 8 Oct 2026 18:59:51 +0300
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net 2/2] net/mlx5: HWS, fix flow meter offset within its
 bulk
To: Alexandre Cassen <acassen@corp.free.fr>, Saeed Mahameed
	<saeedm@nvidia.com>, Leon Romanovsky <leon@kernel.org>, Tariq Toukan
	<tariqt@nvidia.com>, Mark Bloch <mbloch@nvidia.com>
CC: Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
	<davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>, Jakub Kicinski
	<kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, Yevgeny Kliteynik
	<kliteyn@nvidia.com>, <netdev@vger.kernel.org>, <linux-rdma@vger.kernel.org>
References: <20261007143830.1733583-1-acassen@corp.free.fr>
 <20261007143830.1733583-3-acassen@corp.free.fr>
Content-Language: en-US
From: Moshe Shemesh <moshe@nvidia.com>
In-Reply-To: <20261007143830.1733583-3-acassen@corp.free.fr>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: rnnvmail201.nvidia.com (10.129.68.8) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH1PEPF0000A34B:EE_|DS5PPFF2923D4C1:EE_
X-MS-Office365-Filtering-Correlation-Id: e352c3d5-a990-4c0a-a49e-08df255542c5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|82310400026|23010399003|1800799024|36860700016|4143699003|11063799006|10067099003|56012099006|22082099003|18002099003|41080700001|15866825006;
X-Microsoft-Antispam-Message-Info:
	JR44xAP6JzXz2BCwHVSt7eWOlI05N+999ZLKRAZcXAS655RDZB8Iq2Ji3yqdHQZjg1Os4UP/brkfo27UixMgU7BilOynQTmdJSdJPnyjtyPaf9aVdyybEDra+rzEjFUMhqfl0ZhCpJLLVYD3W7hPYddpcyi/F1h6nd0jhOWUKZgEMfAqnlwO6BvFKv+4cQ5/90Kg3zYOwDaegUEhS3itCEu8mYEdrzLxU9eBsMPEMseUEMZBcECUCh9YCPzTJ/ULQ3yjCiHuICidoryWuTJBYD9gZskkl3kgSAr9NzcaGTzOcPEl3xNBqFhUdlQRcr7Ul5ngCBybLF3rA68dRVhCmCvAtQgK3OTD8i6JJ4ecv2B303k+pMqMqf7nqKzSXnxaea4b3lx4T6kiQXWpVgph3r/PS1LARHI1W+IWqomSvWt+gJIdoTpYUxwC+ZfuokRn7wlXnFXGQF584FbJOvWbFhZdebVAwQN8vVvEUqcHRYyVjdqKMjAHgeNZNG5QRBiCDJ6HqHzh8GqYDCqAhxQN1oicotWR3/2uK8qpDCw6kZU+EfI8PqKO4Nd8HN3MPoocDpFA5XS6N/9+NlkSSmKeBXSxmwzZTmH1Hg+sFehlDZe2+sh+XQ61T+D5M7YNK06qLY85W9fVq9fhFzB3jQHssirIZfKmNrm+8DNua1sYz6gNnqv17welQuVPj6z3Nng4u4BFSpu7b1ZmCxIQTIOdQ7R+eWdMCeu4pE4Gk37hfllh5hFAWSyG37mot4smC6Gn1GyszxGxVJOSpYsieRztiF7UGWOYhjEwKSDKECIBBic=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(82310400026)(23010399003)(1800799024)(36860700016)(4143699003)(11063799006)(10067099003)(56012099006)(22082099003)(18002099003)(41080700001)(15866825006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	5fID4eemGsE1GRGovTdUFGEpRRnN5F2ykBv3f2OdJehYvEJf1FXg41iwoFatdCPV7sRR5EcZdT5lUatC4DRTXiftYXQTzmVJryV0Q3KvZ5Y6Rp5al70l8+mwxR5Vt/slJOFxiTikXU764Nfwp1/5yxisfm16wN/9A/qKWlPdeUfQ5u336113a1XaowBIZDVTk7gHmvoAZIwe1mZ306RpX0MoepbKFbGhuuvd9UTygbaWmmLxBYn7B3Ue+zAVLm5eBeJdUU/I336AahL2QNK5UOgOi8P/aiy79vHR5hc3JPAaskElWL10KEuG3EmCK3AMaOY0EV5b9SXyyUqY88TzZeCza0o1XwSl5PQsCcKsmdSt4R/seF1Egt5pYP1GK+eaE0UWN7aONXv3sxSSvjiBHW3Q3wIisFeKm1bFvJPUZns2nmJ/n6NMuAbfFBG8jp1Y
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Oct 2026 16:00:23.1045
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e352c3d5-a990-4c0a-a49e-08df255542c5
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH1PEPF0000A34B.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS5PPFF2923D4C1



On 10/7/2026 5:38 PM, Alexandre Cassen wrote:
> 
> The flow meter action is bound to the first ASO object of the bulk but
> the rule offset only indexes the meter within its own object. A rule
> past the first object runs on the wrong meter.
> 
> Fixes: 82d3639ef7dc ("net/mlx5: fs, add support for flow meters HWS action")
> Signed-off-by: Alexandre Cassen <acassen@corp.free.fr>

Reviewed-by: Moshe Shemesh <moshe@nvidia.com>

Thanks.
> ---
>   drivers/net/ethernet/mellanox/mlx5/core/steering/hws/fs_hws.c | 1 +
>   1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/fs_hws.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/fs_hws.c
> index 44b311b4532d..54761754e657 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/fs_hws.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/fs_hws.c
> @@ -928,6 +928,7 @@ static int mlx5_fs_fte_get_hws_actions(struct mlx5_flow_root_namespace *ns,
>                          goto free_actions;
>                  }
>                  (*ractions)[num_actions].aso_meter.offset =
> +                       (fte_action->exe_aso.object_id - fte_action->exe_aso.base_id) * 2 +
>                          fte_action->exe_aso.flow_meter.meter_idx;
>                  (*ractions)[num_actions].aso_meter.init_color =
>                          fte_action->exe_aso.flow_meter.init_color;
> --
> 2.43.0
> 

