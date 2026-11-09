Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.200.16
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794248835;
	b=sB0gbYq075pXzX+rR461avC9hDa2dc+2qCorpk06tArITrarMkwKkAuIH+6lTPsNWw12
	 VmH1YOqeViZtr1aEcTKdbJoM9ospVh+LHP4vC6Ur3yRzGQU3wsue5EBpYzWznbKx/MlsJ
	 lIBEZCLN2AfimWhlfg4HhNAgiGbDtVbnTyU8d3hzrV2he7plMcjR6aMYNr09eoFbYeoJR
	 aGzfSBgI2rgOxtwY1goOWzHtHnDhHK//I/qKj6amS+5IHXmwYjIoDb2qWzx5+x0HhQWtq
	 sQ580oJJTYI05fUpl/bJQH26tezecQJ635DSnfYGJ2dVFvTtwV2fm456/Rrsd0ouDEA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794248835;
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
	bh=wr52XL9OyrFoF1xODONF6vCm3skFbfB75UMdttbxnS0=;
	b=sM3LpL/pgWEX1zdFA0vzc1acVL1rAsohKXak7ClEdQryr9ez995I58sObLIIBYctzumY
	 eDktm20d8JXqkU2WbyrNLFLgkzn+qLjkaZ/CjiP28nqe78HKfREPppkJIwRP42td5Ot4f
	 xfMplD7oKSuGmVhGYr1vAMd0jrxsJG4haRT6GQiyBELPOa+VEmdR7r1N24/DcNkEh/mGa
	 c+800yqvr95cHKBQ64bCvTfpjK9eRAt03JOwMdEtGEus94oMKNXDi8OEf8PtWo4IkJzvL
	 f75OcrbHBf2Ag2ZveYg/cd0zjZI3gUrcE25/Sc2/rvxnMoxQ4gdwuqLr4GDuJ8HSsTw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=W0kKXVQA;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.200.16
Received: from CH5PR02CU005.outbound.protection.outlook.com (mail-northcentralusazon11012016.outbound.protection.outlook.com [40.107.200.16])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04BF8606A335;
	Mon,  9 Nov 2026 18:27:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 04BF8606A335
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=W0kKXVQA
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GPxIZZnqmGlc/ed/sbUClk4SBb3wlzakHjpdQtHwUb/byx44seDRSJOwBK3xee9N7jTT96Y3IF++RV8WIWmyMDPs/8ntb0y05jrIPYZCGy8ixF7b9M2wP0RTnEFzZBQjmkAj+1HSbFVezvmTCIgG4rcCoBlFUKeHrvNjr5E84yHXrastfDEAbtCS45utUMoSc2q6XRUAgzFePVQnTmVEc/TgBug5KoMgzxmFL0Oa7Y2ZSBc9JUqM26uBdA27D7Om8rVKW2mPytZcklZkMmBht5knpaab8QMYiyujfU46e9WxIxxpcH3XaQX5KEUZxaHJHR8xJ/fHtk4eZ21+hsd8Dw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wr52XL9OyrFoF1xODONF6vCm3skFbfB75UMdttbxnS0=;
 b=P6Z5EMaA9UNhYzpqKn2jEvEdxi0PKh0tqzbVjT95lGg/hfQJpxMVNeVk06En+QF+48m6Aowhm6W6mNUt5hrKkQjFzTKcEL34Ia+abgpyfe/M1CAoexGqtx4uaiHttk0D+G2XN9AJveygX2fxU8HnUGn325sDbvbxcznMZMw/EKeDPFbXZ8RgjnY4Cs4sNpePWmOKGx8sqzBz09cX/BgZaTPn2YMC6wljf30m5LqqJDVgGVIQGlIDXcWUmVccNR+sJbZvbeUFkxkcROyHK+3eRM2PBmyhhvWQRAdoUhQ5DwcjHrvV8uNLsdy6Zgn7XUqagvy4jaqILRfRbv7Rn0mdJw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wr52XL9OyrFoF1xODONF6vCm3skFbfB75UMdttbxnS0=;
 b=W0kKXVQAUSbABqe/OWQCE0J5E+BH9OQp3Eccqjst5mBHLjL5NzQ0Jv2b1RooP3SWld0FQYGb+uApFeT++6ML5rD1Cca1e4IXqZQrR1pDjGHakaZhAjBuVHzSrZ9sLxyjYjrv4kFk/Fq8LfEA0P/jiP5Xhquk2nDM0ohus5GgmE1csciqajUBohDTnmZlohEatRp6BB63yDh9w2UMZCwAjT73FOnyI4K2Wkl3+hLuIxFeRZT4nvDuwokM1n4tblgpkryas/KmvAdj8jFsGHRva1R8C2mdA1dSAKo7VrqBxRSdp6LlNi6K3I6Lz450hrQtUtT55QJlmH2cj8ORtnx+1Q==
Received: from BL1PR13CA0200.namprd13.prod.outlook.com (2603:10b6:208:2be::25)
 by DS0PR12MB677406.namprd12.prod.outlook.com (2603:10b6:8:4ed::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.13; Mon, 9 Nov
 2026 18:27:10 +0000
Received: from BN2PEPF000044A3.namprd02.prod.outlook.com
 (2603:10b6:208:2be:cafe::38) by BL1PR13CA0200.outlook.office365.com
 (2603:10b6:208:2be::25) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.592.9 via Frontend Transport; Mon, 9
 Nov 2026 18:27:10 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.117.161) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BN2PEPF000044A3.mail.protection.outlook.com (10.167.243.154) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.615.4 via Frontend Transport; Mon, 9 Nov 2026 18:27:10 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Mon, 9 Nov
 2026 10:26:45 -0800
Received: from [10.221.197.41] (10.126.230.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Mon, 9 Nov
 2026 10:26:38 -0800
Message-ID: <5b514ff4-676a-4c36-ba47-0854debd5c7f@nvidia.com>
Date: Mon, 9 Nov 2026 20:26:35 +0200
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
Subject: Re: [PATCH net-next 08/15] net/mlx5: LAG: replace fixed
 MLX5_MAX_PORTS arrays with dynamic allocation
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
 <20261103171009.563034-9-tariqt@nvidia.com>
Content-Language: en-US
From: Shay Drori <shayd@nvidia.com>
In-Reply-To: <20261103171009.563034-9-tariqt@nvidia.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN2PEPF000044A3:EE_|DS0PR12MB677406:EE_
X-MS-Office365-Filtering-Correlation-Id: 77aca9cb-624b-4839-6443-08df3e8f11aa
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|23010399003|82310400026|36860700016|5023799004|11063799006|261021121427099003|261009223027099003|56012099006|261021123027099003|261022075727099003|261022105027099003|261026140227099003|261026121527099003|4143699003|261028144727099003|261102123227099003|18002099003|22082099003|6133799003|10067099003;
X-Microsoft-Antispam-Message-Info:
	50QCtR7UWgPTtctSy3v38qoOnWCJ8QuLzSzTf5egbaTLROqSoxxlrCkHBHby1CS6Og/AT760cBwTKXQGYF+zZxtXwnZMfV97Q2IgS1U0UCwK6zmnMdzz8/OaIWOCZyQH+kLjfNwI/DFf2fkTUefVFspyUWFpoTRKNmyK7eawitJKSNdGsf6KiVBCLmh9ZXf0h5AHeS864tO2fdk0ysBFx3z2Qvic7IsZV4ksKGXvUT/Lud435wv8YhELN0C00mcGrVvDkwPbjvW4HURIqVFvGcSLQqejfNBpXMhYx+EuEjrcaWAGMxsiG+acAK7Z8e1X+/L9/6Q1Dj68SPwBpzeL1zp67S8jBhaazJCeh4sciFNRG9O1e/dNqxzKYLAg2eihTgyWYHl76p2jJ/ZIT+P3SbQO3fYQtLGiYvZAB1aRs6k1ee3xWvMOfO0YRchYFffOHCfW9HSXPQTmPOKVLDCQ18yAr8ZOh8FKZklfmTzD16vmzRgjFMNMUSVSw+i6303/Wi4GaVJi+1232DphNLppeFOMfV/KKxf7kU14ifDcIC8ro/745liSv0DZgv9LRyQJMiXtAzZD9IzhoY81Rg8R+HI+M8XwfzgPEyH6mUQ/BQ9BHPu7ZyG7OFHuyUuagD6yRohuE5pc/1R+OyzfXXVmvWrE7PS8pYqVcZpHlWSH1mpGAriZxMvA3zxkaS7ZAz8L4dhK/LGoLBquE5GEnrLqdg==
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(376014)(23010399003)(82310400026)(36860700016)(5023799004)(11063799006)(261021121427099003)(261009223027099003)(56012099006)(261021123027099003)(261022075727099003)(261022105027099003)(261026140227099003)(261026121527099003)(4143699003)(261028144727099003)(261102123227099003)(18002099003)(22082099003)(6133799003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	ADKBDX6CakUsV7Qj86KUYomq+8Wjuh7aj6RoR5Ze4yPMx6uGpMPP59gXwSs4NB7SXS5fJ1I50FVrQzw1DkbR4xSphGJY/H9TigbXfSIg2032CJX1GuXSF+vqtujrIKt9nrO5T+0FUCnTXsx8juc8viG2CBFCIvCL/fNLQgmjYuJkLrH1YdOC7nImkNLQE2IeZmyU00atp6kQAxbvz9wVd1U/7rV3XI3cr4+q/802KYztvx7LKqs7GQYRP3XOm2I3bwUnS5weGzsJ6Dn3Od3KR7EjV/bMmDKxAv92f7c/UtE0llADq9hN6YYTYHN6+ByDaO2ajn0lb1QYKMeQxmtwT5dhiBKH6vknhl32b6e9VlNqVNMpxzLx9JUDsQRguFa/HLO3qKCUTqViFxDUUQWdgbltWma9gsd0P7P4A9uMYDYFQ3ToLttlP77aLXlIPWJT
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Nov 2026 18:27:10.6334
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 77aca9cb-624b-4839-6443-08df3e8f11aa
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN2PEPF000044A3.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB677406



On 03/11/2026 19:10, Tariq Toukan wrote:
> From: Shay Drory <shayd@nvidia.com>
> 
> Converts two fixed-size arrays sized to MLX5_MAX_PORTS into
> dynamically allocated pointers:
> 
> - lag_mpesw.pf_metadata in mpesw.c/mpesw.h, sized by ldev->max_fns
> - mdev array in mlx5_lag_query_cong_counters(), sized by ldev->ports
> 
> The cong-counters array is sized by ldev->ports, which is fixed at ldev
> allocation, rather than by the LAG mode, so a mode change between the
> allocation and filling the array cannot overflow it. The query loop is
> bounded by the number of entries actually filled. A virt LAG is not
> aggregated and queries only the given device, as its members are not
> LAG ports.
> 
> Thus, removes the hard dependency on MLX5_MAX_PORTS.
> 
> Signed-off-by: Shay Drory <shayd@nvidia.com>
> Reviewed-by: Mark Bloch <mbloch@nvidia.com>
> Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
> Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
> ---
>   drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c | 15 +++++++--------
>   .../net/ethernet/mellanox/mlx5/core/lag/mpesw.c   | 12 ++++++++++++
>   .../net/ethernet/mellanox/mlx5/core/lag/mpesw.h   |  2 +-
>   3 files changed, 20 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
> index 2b76d119cfa6..b873eb91fd0d 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
> @@ -2917,7 +2917,9 @@ int mlx5_lag_query_cong_counters(struct mlx5_core_dev *dev,
>   	if (!out)
>   		return -ENOMEM;
>   
> -	mdev = kvzalloc(sizeof(mdev[0]) * MLX5_MAX_PORTS, GFP_KERNEL);
> +	ldev = mlx5_lag_dev(dev);
> +	num_ports = ldev ? max_t(int, ldev->ports, 1) : 1;
> +	mdev = kcalloc(num_ports, sizeof(mdev[0]), GFP_KERNEL);
>   	if (!mdev) {
>   		ret = -ENOMEM;
>   		goto free_out;
> @@ -2926,20 +2928,17 @@ int mlx5_lag_query_cong_counters(struct mlx5_core_dev *dev,
>   	memset(values, 0, sizeof(*values) * num_counters);
>   
>   	spin_lock_irqsave(&lag_lock, flags);
> -	ldev = mlx5_lag_dev(dev);
> -	if (ldev && __mlx5_lag_is_active(ldev)) {
> -		num_ports = ldev->ports;
> +	if (ldev && __mlx5_lag_is_active(ldev) && !ldev->virt_lag) {
>   		mlx5_ldev_for_each(i, 0, ldev) {
>   			fn = mlx5_lag_fn(ldev, i);
>   			mdev[idx++] = fn->dev;
>   		}


answers to net-dev sashiko

Sashiko (Medium):
Can this loop write past the end of mdev[]?
The array now has max(ldev->ports, 1) entries. mlx5_ldev_for_each()
writes one entry for each member that has MLX5_LAG_XA_MARK_PORT, and
nothing checks idx against num_ports.
mlx5_ldev_add_mdev() puts the PORT mark on every group_id == 0 member
and does not cap the count at ldev->ports:
     if (group_id)
         return 0;
     xa_set_mark(&ldev->fns, idx, MLX5_LAG_XA_MARK_PORT);
The member count is compared with ldev->ports only at activation time, in
mlx5_lag_check_prereq(). __mlx5_lag_dev_add_mdev() refuses a join only
when mode_changes_in_progress is set.
If an active non-virt LAG ever had more PORT-marked members than
ldev->ports, this loop would write struct mlx5_core_dev pointers past the
kcalloc'd buffer while holding lag_lock with IRQs off. I couldn't confirm
that such a configuration happens on real hardware. mapping_show() in
debugfs.c makes the same kcalloc(ldev->ports) assumption.
The commit message says:
     The cong-counters array is sized by ldev->ports, which is fixed at ldev
     allocation, rather than by the LAG mode, so a mode change between the
     allocation and filling the array cannot overflow it.
The old MLX5_MAX_PORTS sizing left headroom here. Should the loop have
something like "if (idx >= num_ports) break;", maybe with WARN_ON_ONCE(),
so the code enforces that guarantee?

[SD] It can't. The loop runs only for a non-virt LAG, and the
PORT-marked members of such an ldev are the PFs of one card, at most
num_lag_ports == ldev->ports of them (an SD secondary is not PORT-marked
and a virt member is excluded by the !ldev->virt_lag check right here).



>   	} else {
> -		num_ports = 1;
> -		mdev[MLX5_LAG_P1] = dev;
> +		mdev[idx++] = dev;
>   	}
>   	spin_unlock_irqrestore(&lag_lock, flags);
>   
> -	for (i = 0; i < num_ports; ++i) {
> +	for (i = 0; i < idx; ++i) {
>   		u32 in[MLX5_ST_SZ_DW(query_cong_statistics_in)] = {};
>   
>   		MLX5_SET(query_cong_statistics_in, in, opcode,
> @@ -2954,7 +2953,7 @@ int mlx5_lag_query_cong_counters(struct mlx5_core_dev *dev,
>   	}
>   
>   free_mdev:
> -	kvfree(mdev);
> +	kfree(mdev);
>   free_out:
>   	kvfree(out);
>   	return ret;
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/mpesw.c b/drivers/net/ethernet/mellanox/mlx5/core/lag/mpesw.c
> index 6e3bef276611..584436668a5c 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/lag/mpesw.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/mpesw.c
> @@ -15,6 +15,9 @@ static void mlx5_mpesw_metadata_cleanup(struct mlx5_lag *ldev)
>   	u32 pf_metadata;
>   	int i;
>   
> +	if (!ldev->lag_mpesw.pf_metadata)
> +		return;
> +
>   	mlx5_lag_for_each(i, 0, ldev, MLX5_LAG_FILTER_ALL) {
>   		dev = mlx5_lag_fn(ldev, i)->dev;
>   		esw = dev->priv.eswitch;
> @@ -27,6 +30,9 @@ static void mlx5_mpesw_metadata_cleanup(struct mlx5_lag *ldev)
>   		mlx5_esw_match_metadata_free(esw, pf_metadata);
>   		ldev->lag_mpesw.pf_metadata[i] = 0;
>   	}
> +
> +	kfree(ldev->lag_mpesw.pf_metadata);
> +	ldev->lag_mpesw.pf_metadata = NULL;
>   }
>   
>   static int mlx5_mpesw_metadata_set(struct mlx5_lag *ldev)
> @@ -36,6 +42,12 @@ static int mlx5_mpesw_metadata_set(struct mlx5_lag *ldev)
>   	u32 pf_metadata;
>   	int i, err;
>   
> +	ldev->lag_mpesw.pf_metadata =
> +		kcalloc(ldev->max_fns, sizeof(*ldev->lag_mpesw.pf_metadata),
> +			GFP_KERNEL);
> +	if (!ldev->lag_mpesw.pf_metadata)
> +		return -ENOMEM;
> +

Sashiko (High):
Can mlx5_mpesw_metadata_cleanup() index past the end of pf_metadata[]?
This buffer is sized by ldev->max_fns at the time MPESW is enabled, and
the length is not saved anywhere. The cleanup loop stops at the current
max_fns instead:
     mlx5_lag_for_each(i, 0, ldev, MLX5_LAG_FILTER_ALL) {
         ...
         pf_metadata = ldev->lag_mpesw.pf_metadata[i];
         ...
         mlx5_esw_match_metadata_free(esw, pf_metadata);
         ldev->lag_mpesw.pf_metadata[i] = 0;
     }
max_fns only ever grows, in mlx5_ldev_add_mdev():
     if (idx >= ldev->max_fns)
         ldev->max_fns = idx + 1;
sd_lag_init() adds SD secondaries without checking ldev->mode. These
have group_id != 0, so MLX5_LAG_FILTER_ALL includes them:
     mlx5_sd_for_each_secondary(i, primary, pos) {
         err = mlx5_ldev_add_mdev(ldev, pos, sd->group_id);
One possible sequence:
   esw_multiport devlink param set on a phys LAG before the SD group forms
     mlx5_devlink_esw_multiport_set()
       mlx5_lag_mpesw_enable()
         mlx5_mpesw_metadata_set()
           kcalloc(ldev->max_fns, ...)   /* e.g. 2 entries */
   SD secondary eth aux device probes
     mlx5e_probe()->mlx5_sd_init()->sd_lag_init()
       mlx5_ldev_add_mdev()   /* idx 2, 3, ..., max_fns grows */
   esw_multiport cleared, or eswitch mode change
     mlx5_lag_disable_mpesw()->mlx5_mpesw_metadata_cleanup()
       reads and writes pf_metadata[2..] out of bounds
If a stray value read there is non-zero, cleanup would also reprogram
the uplink ingress ACL of a device that never took part in MPESW and
send it a MULTIPORT_ESW event. It would also call ida_free() on an
arbitrary metadata id that another vport may still be using.
The old zeroed u32[MLX5_MAX_PORTS] array absorbed this growth for
indices below MLX5_MAX_PORTS.
Later in the series, "net/mlx5: LAG, do not add a device to an
already-active LAG" only rejects virt-LAG-capable devices in
__mlx5_lag_dev_add_mdev(). sd_lag_init() is unchanged, so this appears
to remain at the end of the series.
Could the allocated length be stored and used to bound the cleanup loop?
Alternatively, could membership growth be refused, or the buffer
reallocated, while MPESW is active?

[SD] this is pre-existing bug, MPESW should failed if SD Secondary
is down. this will be handle in separate patch.


>   	mlx5_lag_for_each(i, 0, ldev, MLX5_LAG_FILTER_ALL) {
>   		dev = mlx5_lag_fn(ldev, i)->dev;
>   		esw = dev->priv.eswitch;
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/mpesw.h b/drivers/net/ethernet/mellanox/mlx5/core/lag/mpesw.h
> index 5099723ba0f7..6296e3edd38c 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/lag/mpesw.h
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/mpesw.h
> @@ -9,7 +9,7 @@
>   
>   struct lag_mpesw {
>   	struct work_struct mpesw_work;
> -	u32 pf_metadata[MLX5_MAX_PORTS];
> +	u32 *pf_metadata;
>   };
>   
>   enum mpesw_op {

