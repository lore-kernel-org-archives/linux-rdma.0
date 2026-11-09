Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.85.52
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794244976;
	b=4cB5kIKV/LlLmbS338i5aPGRx1SxOf6NPsiEHZbb/W77tP2sOGuu1KOdExJ3vmlPOJcF
	 ePAPkKBTi1PXdRHNb9icrT2dLTgpdY7cQU/3siLr3vDfDUDPDSECSdYM4n/NgkygUL5QF
	 7JW+0otzReoE7BYBXCe0YWiMXtKvnnkuHL0UvLy0ha/bo6obZKtwPpjDlb4nLM6fIIlw8
	 KYjMfRZ0vS4OgYg7JoQitIXB7laSIEAN2UAMU9SOhxQaQYvscnyoMmouQzNsEUPEV+XZd
	 o4CKvTW/bxLz9D1ccrgCcHCfQA+OLh4fn7tI0lGSYIIVJc9+7dWxsgbeQoNrUqfxyKQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794244976;
	h=DMARC-Filter:DKIM-Signature:Received:Received:
	 X-MS-Exchange-Authentication-Results:Received-SPF:Received:Received:
	 Received:Message-ID:Date:MIME-Version:User-Agent:Subject:To:CC:
	 References:Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:X-Originating-IP:X-ClientProxiedBy:
	 X-EOPAttributedMessage:X-MS-PublicTrafficType:
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
	bh=g/YzGmlsRvtKgnshVsEjP7j0vmQU3C3vgGbsDnHJEm0=;
	b=yZphnqjD6Q03W1Fx9tgtUao9pf2OV5aBE+CjDEvwnlnGYe+bshPDQVL+Z2e85Sku+ow2
	 aelQlEuDxxxqkgpawz4IVEzOqeUz1o97LrKv/BtQd9G8z257vy6O/ar0pGzS1584f0f9C
	 ypSbyLqTcmjM8uiMnwmg/RKapeSIPWg/fvfLSg754eUuF0PL6/axNfjoIwZjuiOQ8oJfW
	 S5XMCudYuw8F60UVFE1cXfH9rtgeCPreTTHdmmtJ5qtmcY/r0bpc0MFfvz3PSpxgl3+cR
	 hg7zEoc2SUpoFvLrF+x8Pd4l0p3yIfxoLmrStyTtJJ1u/aRL6TqaOkeKLlZIlZVFFFA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=NswfRWyu;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.85.52
Received: from BYAPR05CU005.outbound.protection.outlook.com (mail-westusazon11010052.outbound.protection.outlook.com [52.101.85.52])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 384E6606A325;
	Mon,  9 Nov 2026 17:22:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 384E6606A325
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=NswfRWyu
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UDh/AwkkMDysBW5Cfzf5sFo6CUtaMqqQka0f+jwHBctK6qOh62HAV09Bypq2Qbr/DFkJlL8/2a5+rQTQ0T1QnyTXEH2slxDAGKyiOGCvfled0S4bmfcYvrFshSFTzUJcN06U3bSeJKl37ZESybo0f5lmbuJBlR6fTmGIy/AG9Z6N0LzO746nYX9hcfczlQtSYEtAmoL/25GW7gjgihzY1ptFJJ0EDdF7ekN6aaiD7apPPdcq8/zJB/j+rC1GMJlVMFpc5HZVshhE44XOiOLnVhQG36ZUZf9qiVQRSBzsF2LaCwV3glKepOx3eanHQEiz1M0SHs2b4xRMnlbHpw9jag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=g/YzGmlsRvtKgnshVsEjP7j0vmQU3C3vgGbsDnHJEm0=;
 b=lNke7DGQ0sb/cGfjrdQ0mWaQYCHb+2mZz2t8ql87ywzT53peXlozpDl13UqRy08JhdNQ8auc6Q6WEsCu1rN2vu7izmTM6BNcJaG3wqpYEptsa9HOuf4IQ1zBxyIz6WVo4cMwziHnXPArgpasHqPBTX8fWi0xBOVrzNSecRHEBdNituZq3OotybnwLPUu3rQ0RGuMG1HddzDENOmehrAvECiWfWqc/d9B9R7AdplF4v6bxiw0gshwIS4htyngmnMxvBGj2bF2tBv+SzMAFqULQwDy9roIEfe1YWHti++XAlb/j26mVDHr71YqxzdjGvP5G7RO7sp6iEYJC2Rti870sA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=g/YzGmlsRvtKgnshVsEjP7j0vmQU3C3vgGbsDnHJEm0=;
 b=NswfRWyuNs7WC1beyMwR9X3EKGw3a6mpwD8zNr/B6ahVl4OWM0PmeZyULdy/aFfnnhoQpm6yCi85WqqRV1Fm7k8FQrlB+xOjLkpUehoYLpoIdAxGZ2yiMDfqPADVP7ViXP3CSBfoQByTu4jRTwykB9SbgFIkSHMzv0ZFaT6yJ73kqB9CanwP0mZsGewz/JK5iQ5K3fZjhyZGIewHgKSrDkc2WRo+WWPOOri56WL33/D9MKZUXiWaeIFMYohn2aSLFJU3eyEULQymwi1/W5dRha18I35No420n0qkgrdYjcjD2QyQLGqghOP4/4ATOsUaQ1z19nmOnT0J8yQ/BV1l2Q==
Received: from BN9PR03CA0176.namprd03.prod.outlook.com (2603:10b6:408:f4::31)
 by PH8PR12MB7326.namprd12.prod.outlook.com (2603:10b6:510:216::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.13; Mon, 9 Nov
 2026 17:22:48 +0000
Received: from IA0PEPF00000037.namprd03.prod.outlook.com
 (2603:10b6:408:f4:cafe::26) by BN9PR03CA0176.outlook.office365.com
 (2603:10b6:408:f4::31) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.592.13 via Frontend Transport; Mon, 9
 Nov 2026 17:22:48 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.117.160) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 IA0PEPF00000037.mail.protection.outlook.com (10.167.249.68) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.615.4 via Frontend Transport; Mon, 9 Nov 2026 17:22:48 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Mon, 9 Nov
 2026 09:22:22 -0800
Received: from [10.221.209.160] (10.126.230.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Mon, 9 Nov
 2026 09:22:16 -0800
Message-ID: <ea4f9ee0-3925-4b93-b9c2-edfe20dd3a29@nvidia.com>
Date: Mon, 9 Nov 2026 19:22:13 +0200
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next 01/15] net/mlx5: Distinguish VFs/SFs in the SW
 system image GUID for LAG grouping
To: Tariq Toukan <tariqt@nvidia.com>, Andrew Lunn <andrew+netdev@lunn.ch>,
	"David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>, <netdev@vger.kernel.org>, Paolo Abeni
	<pabeni@redhat.com>
CC: Akiva Goldberger <agoldberger@nvidia.com>, Carolina Jubran
	<cjubran@nvidia.com>, Cosmin Ratiu <cratiu@nvidia.com>, Edward Srouji
	<edwards@nvidia.com>, Gal Pressman <gal@nvidia.com>, Leon Romanovsky
	<leon@kernel.org>, open list <linux-kernel@vger.kernel.org>,
	<linux-rdma@vger.kernel.org>, Mark Bloch <mbloch@nvidia.com>, Moshe Shemesh
	<moshe@nvidia.com>, Or Har-Toov <ohartoov@nvidia.com>, Patrisious Haddad
	<phaddad@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>
References: <20261103171009.563034-1-tariqt@nvidia.com>
 <20261103171009.563034-2-tariqt@nvidia.com>
Content-Language: en-US
From: Shay Drori <shayd@nvidia.com>
In-Reply-To: <20261103171009.563034-2-tariqt@nvidia.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PEPF00000037:EE_|PH8PR12MB7326:EE_
X-MS-Office365-Filtering-Correlation-Id: bf4189e1-1eb2-435e-f1a4-08df3e861381
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|1800799024|82310400026|36860700016|261028144727099003|4143699003|11063799006|261021133027099003|56012099006|261021135927099003|261021130227099003|261021123027099003|261021121427099003|261022075727099003|261022105027099003|261022115727099003|261022113327099003|261009223027099003|261026121527099003|261026130827099003|261026135527099003|261026140227099003|261102130727099003|261102123227099003|10067099003|22082099003|18002099003|6133799003;
X-Microsoft-Antispam-Message-Info:
	feI39IfAnD5Xs9pXWvhfhq3ri1FaE3kgqI9U91uwH/duTkD5LWEFh9axOnL5d34VlP7t0Y5f6CFEwmgwY335mQ67soskuirhPzbnY6+dfDFv5CFx8s1idf/t1B5g0MI54mUsYFQJSykatLZY4XOyfpVIG6wAvZt+Q6U59u7Ko8NKR7DnPh2VHXJwFNw2qYv7Vvb6ZKQMvwXOb7MXYbG0XW23tvIN6orD442z7Su7GcMzP8IQZxfOgtc4g2AUfAAZeig5271dWOV+10vfYEHljqzSIYtUap+4ml8Cg1ycmNaktR0aEmM3dgAB8IxUzyjsvsrTaOyuutrN44YKabRqZkLmipRR5tVb/fI52cZ6gNM3+xgHFHbY5eMaEfQFTtAFUaVMFazVOWZibotl7LMhAaMQ9q8IqlmBhk1Kg8Js38Utqin9hSuRzZMGAXy//60/9j8IDcwZzkxYrE8leWraQfsqlHBhRXXbMSKvgEycMmzjkmdpMbVoeEYvTYclUVfT1YpEZkLTIo8Pgy20C2lDHkF0dqXpEIVM92LuFwsJ8bzWCrwyDqmsUqNxImzAvYkEnf8O458yvXLQ+MofUM94BXF34wa8tu/MFt181kYVpeszdN7yYMPwx9LNk3V8rRlwaKXTxL6eKAWLjYcZXILuZm8wqSNnLMSYWB7Sxk2gGlY+zugGIFVbI/C9oTs131X9CpxZbI4GN3cfexIe0Y6Dow==
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(23010399003)(376014)(1800799024)(82310400026)(36860700016)(261028144727099003)(4143699003)(11063799006)(261021133027099003)(56012099006)(261021135927099003)(261021130227099003)(261021123027099003)(261021121427099003)(261022075727099003)(261022105027099003)(261022115727099003)(261022113327099003)(261009223027099003)(261026121527099003)(261026130827099003)(261026135527099003)(261026140227099003)(261102130727099003)(261102123227099003)(10067099003)(22082099003)(18002099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	zreczQ15ahoHSSL89r45j4vCXcOf7TJrzhg77vC/UBUvBdQWCRzdQJ2l/qXXWbVvMFf4ATHJoKIScJ02l8kI3lpEUCuZp5gj2IJBvMbDrNxoy5inxpUK8LXyuNSqLZfSfTHo3fNdBaxHSaA7CHaw5hUKGGzvPSq3+W8RcoM3bNU12CanbNnUB0T23ItjgmIz2nnQa/kf208SmxfTSVEK+PZYPkvk1WUPEO+2d1sBdJ32Ai4nUwUsC1C2cQjiYA2edMaWXLv6bQhfETf8LECaMZMqYYaOJR3Qovj7VDLaKw/KWQkWfXG6CvTxzKBgq8uJvsgFOj92eNWrCrnya8AOV8TxUhgePJTPmxjPUZsHjN/Q32kP42O1PpS88aF23s4oeUbQZ2pPZzHG6A8ehEFlCO6SYZrrXJE1jf8yKhJ5NTmmWDoygcj3coD3aPysz84c
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Nov 2026 17:22:48.1997
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: bf4189e1-1eb2-435e-f1a4-08df3e861381
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	IA0PEPF00000037.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB7326

On 03/11/2026 19:09, Tariq Toukan wrote:
> From: Shay Drory <shayd@nvidia.com>
> 
> mlx5_query_nic_sw_system_image_guid() builds the key used to group
> devices that may form a LAG. A PF and its VFs/SFs share the same FW
> system image GUID, so without a discriminator a VF/SF that can join a
> virt LAG would be grouped with its PF.
> 
> Appending bare discriminator bytes at conditional offsets is not enough:
> distinct capability sets can collapse to the same key (a PF ending in a
> load_balance byte of 0x01 vs a VF whose marker is 0x01). Give each
> discriminator a fixed position instead, and add the VF and SF as such
> fields. Trailing zero fields are trimmed, so keys of devices that set
> none of the new fields are unchanged.
> 
> Set the VF/SF markers only when mlx5_virt_lag_is_supported(). The same
> key also backs mlx5_same_hw_devs(), so a VF/SF that cannot join a virt
> LAG keeps its current key and is still identified as the same HW as its
> PF.
> 
> Signed-off-by: Shay Drory <shayd@nvidia.com>
> Reviewed-by: Mark Bloch <mbloch@nvidia.com>
> Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
> Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
> ---
>   .../net/ethernet/mellanox/mlx5/core/lag/lag.h |  9 ++++
>   .../net/ethernet/mellanox/mlx5/core/vport.c   | 41 +++++++++++++++++--
>   include/linux/mlx5/driver.h                   |  2 +-
>   3 files changed, 48 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.h b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.h
> index 8552792b9035..0ff337983a6d 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.h
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.h
> @@ -266,6 +266,15 @@ static inline void mlx5_lag_set_vports_agg_speed(struct mlx5_lag *ldev) {}
>   static inline void mlx5_lag_reset_vports_speed(struct mlx5_lag *ldev) {}
>   #endif
>   
> +static inline bool mlx5_virt_lag_is_supported(const struct mlx5_core_dev *dev)
> +{
> +	if (!MLX5_CAP_GEN(dev, multi_uplink_eswitch) ||
> +	    !MLX5_CAP_GEN(dev, lag_master) ||
> +	    MLX5_CAP_GEN(dev, num_lag_ports) >= 2)
> +		return false;
> +	return true;
> +}
> +
>   static inline bool mlx5_lag_is_supported(struct mlx5_core_dev *dev)
>   {
>   	if (!MLX5_CAP_GEN(dev, vport_group_manager) ||
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/vport.c b/drivers/net/ethernet/mellanox/mlx5/core/vport.c
> index 78f3d15b599d..50d2609374c4 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/vport.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/vport.c
> @@ -38,6 +38,7 @@
>   #include "mlx5_core.h"
>   #include "eswitch.h"
>   #include "sf/sf.h"
> +#include "lag/lag.h"
>   
>   /* Mutex to hold while enabling or disabling RoCE */
>   static DEFINE_MUTEX(mlx5_roce_en_lock);
> @@ -1308,10 +1309,37 @@ u64 mlx5_query_nic_system_image_guid(struct mlx5_core_dev *mdev)
>   }
>   EXPORT_SYMBOL_GPL(mlx5_query_nic_system_image_guid);
>   
> +static u8 mlx5_sw_guid_load_balance(const struct mlx5_core_dev *mdev)
> +{
> +	if (MLX5_CAP_GEN_2(mdev, load_balance_id) &&
> +	    MLX5_CAP_GEN_2(mdev, lag_per_mp_group))
> +		return MLX5_CAP_GEN_2(mdev, load_balance_id);
> +	return 0;
> +}
> +
> +static u8 mlx5_sw_guid_sf(const struct mlx5_core_dev *mdev)
> +{
> +	return mlx5_core_is_sf(mdev) && mlx5_virt_lag_is_supported(mdev);
> +}
> +
> +static u8 mlx5_sw_guid_vf(const struct mlx5_core_dev *mdev)
> +{
> +	return mlx5_core_is_vf(mdev) && mlx5_virt_lag_is_supported(mdev);
> +}

answers to net-dev sashiko

Sashiko (Medium):
Does this break PF to VF/SF same-HW detection for the VFs/SFs that do
pass mlx5_virt_lag_is_supported()?
The commit message says a VF/SF that cannot join a virt LAG keeps its
current key and is still identified as the same HW as its PF. A VF/SF
that reports multi_uplink_eswitch, lag_master and num_lag_ports < 2 now
gets a key that differs from its PF's key:
   PF: GUID [+ lb]                 (8 or 9 bytes)
   VF: GUID + lb + 0x01            (10 bytes, lb may be 0)
   SF: GUID + lb + 0x00 + 0x01     (11 bytes, lb may be 0)
mlx5_same_hw_devs() requires the lengths and bytes to match exactly:
drivers/net/ethernet/mellanox/mlx5/core/dev.c:mlx5_same_hw_devs() {
     ...
     return plen && flen && flen == plen &&
         !memcmp(fsystem_guid, psystem_guid, flen);
}
mlx5e_tc_is_vf_tunnel() accepts only a PF out_dev with a VF or SF
route_dev, and then depends on that same check:
drivers/net/ethernet/mellanox/mlx5/core/en_tc.c:mlx5e_tc_is_vf_tunnel() {
     ...
     if (out_mdev->coredev_type != MLX5_COREDEV_PF)
         return false;
     if (route_mdev->coredev_type != MLX5_COREDEV_VF &&
         route_mdev->coredev_type != MLX5_COREDEV_SF)
         return false;
     return mlx5e_same_hw_devs(out_priv, route_priv);
}
For these VFs/SFs, it looks like mlx5e_tc_is_vf_tunnel() can never
return true. Would that cause the following?
   mlx5e_tc_tun_route_lookup() skips the VF tunnel branch and never sets
   rx_tun_attr->decap_vport. mlx5e_attach_decap_route() then bails out,
   and the indirect table source vport rewrite is never set up.
   mlx5e_set_vf_tunnel() takes the goto out path and does not rewrite
   the source port to the VF vport.
   mlx5e_update_vf_tunnel() returns -ENODEV.
In NIC mode, tc_act_can_offload_mirred_nic() would also reject a
redirect between a PF and such a VF/SF, or between a VF and an SF, with
"devices are not on same switch HW, can't offload forwarding".
No later patch in the series changes mlx5_same_hw_devs(),
mlx5e_tc_is_vf_tunnel(), the tunnel code or mirred_nic.c. The final
patch, "net/mlx5: LAG, enable LAG over functions that do not represent a
physical port", relies on VF/SF functions that report exactly these
capabilities.
Should mlx5_same_hw_devs() use a key without the VF/SF markers, or
compare only the bytes that identify the hardware?

[SD] No, this is the point of the patch. A VF/SF that reports
multi_uplink_eswitch and lag_master (and num_lag_ports < 2) is a nested
eswitch manager. That makes it a different switch domain from its
PF, not one more vport of the PF's FDB, so it must not be identified as
the same HW as the PF. Without the marker it would also be grouped into
the PF's LAG, which is what the patch prevents.

A VF/SF that does not report these caps, i.e. every VF/SF that exists
today, keeps its key unchanged and is still the same HW as its PF, as
the commit message says. Dropping the markers inside mlx5_same_hw_devs()
would make a nested eswitch manager the same HW as its PF again, i.e.
undo the patch.


> +
> +static u8 (* const mlx5_sw_guid_fields[])(const struct mlx5_core_dev *mdev) = {
> +	mlx5_sw_guid_load_balance,
> +	mlx5_sw_guid_vf,
> +	mlx5_sw_guid_sf,
> +	/* New fields should be added at the end */
> +};
> +
>   void mlx5_query_nic_sw_system_image_guid(struct mlx5_core_dev *mdev, u8 *buf,
>   					 u8 *len)
>   {
>   	u64 fw_system_image_guid;
> +	u8 trim_len;
> +	int i;
>   
>   	*len = 0;
>   
> @@ -1321,10 +1349,17 @@ void mlx5_query_nic_sw_system_image_guid(struct mlx5_core_dev *mdev, u8 *buf,
>   
>   	memcpy(buf, &fw_system_image_guid, sizeof(fw_system_image_guid));
>   	*len += sizeof(fw_system_image_guid);
> +	trim_len = *len;
>   
> -	if (MLX5_CAP_GEN_2(mdev, load_balance_id) &&
> -	    MLX5_CAP_GEN_2(mdev, lag_per_mp_group))
> -		buf[(*len)++] = MLX5_CAP_GEN_2(mdev, load_balance_id);
> +	for (i = 0; i < ARRAY_SIZE(mlx5_sw_guid_fields); i++) {
> +		u8 val = mlx5_sw_guid_fields[i](mdev);
> +
> +		buf[(*len)++] = val;
> +		if (val)
> +			trim_len = *len;
> +	}
> +
> +	*len = trim_len;
>   }
>   
>   bool mlx5_vport_use_vhca_id_as_func_id(struct mlx5_core_dev *dev,
> diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
> index abb99371ff13..d9d91faa0a1d 100644
> --- a/include/linux/mlx5/driver.h
> +++ b/include/linux/mlx5/driver.h
> @@ -1395,7 +1395,7 @@ static inline struct net *mlx5_core_net(struct mlx5_core_dev *dev)
>   	return devlink_net(priv_to_devlink(dev));
>   }
>   
> -#define MLX5_SW_IMAGE_GUID_MAX_BYTES 9
> +#define MLX5_SW_IMAGE_GUID_MAX_BYTES 11
>   
>   static inline bool mlx5_data_direct_supported(struct mlx5_core_dev *mdev)
>   {

