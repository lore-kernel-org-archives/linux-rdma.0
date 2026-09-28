Received: from CY7PR03CU001.outbound.protection.outlook.com (mail-westcentralusazon11010006.outbound.protection.outlook.com [40.93.198.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E84994E36F2;
	Mon, 28 Sep 2026 15:14:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.198.6
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790608465; cv=fail; b=jd9ytbyxIcRL8jSvAjYdmHpMnFwjWplpmfO3kOYJe/eJxN+g55U4dDSI8fr+P9zKwlx+PU+4re4mKAvZalW3lPSvERDkLQReGtOGb0kFerQ1BpjTZdEVsKuqJe3sVpc5AeI7YBJ45I8txj8GYqwYQmXHPta2LonBeBzYeQc13TY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790608465; c=relaxed/simple;
	bh=2XUULwL1sjgw3sOVs+H/eWeHp9IknBYfg0ZgXc6H8YM=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=XU2tPSicpeUZFRCjlOuMZ8xJljYcaZBTA4TMrCK2AD26Gxe3jmLjP3i6mRFL9PjoUDH4LE+fUTeCgki5lA5UkxbuCwoV9WjdQA7SRatoHDjV3RNLhw1rYKDTUlm/pj1fwm3ljcUqJSk5joqQSqfElEeoeELtrNFZqwz2LWN9RE4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=q6ANwjAi; arc=fail smtp.client-ip=40.93.198.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="q6ANwjAi"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=O++xon2umLBIqFoZIVofMy+GC3iZ9akYYGOaFk/vFY7qKBQFIYdH4iVFi9IjoPfuErbRkdQlVGpIpuvoDqdDftg9f4tZqoKI/Xyt51Jm0eCWLq6iC28JKVT708TkEi7e5nvW1b/h2ZavElDACiv7uMIAe3KBT7w/KpLnrO33FtWteHC+DiX1NSaZkmHTtKSOk4X0zXdYyInNOygeYYo0e6LduQIOfBb4J0sbjNn1LIdPO0MRJ+5rCzNWHEDe7PjvHWazS3ejFQx2VwYedULz6dz7ANLJhQttvLmOI+gf7IaRAIw6a8MFYaKDNENAd1Eh8Tf01jvpS8bwxA/gR9HW4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NrwBvs5ftsiydRzeTD62Y3NYueiZz8mIp0w2EdJCgkc=;
 b=csCBC61sLfmwNBOt6Vq0rkxawswadkfEJL5ITEDoZybXwRv83AXnJn1YvcoK0dvPL9OO/jrioFjciUuzrsTJZ5AP1dKpitdPI4xjipZJ3HfwEy6ot113V4EurHLKaQv/XjWbpUjeSOSWwrBmvSGtbmJqQgKuyNYoFjxip5B2dIJvXWOUGPzEMAVdfTFs7N8vqnUfxiggwqwI8dVFKx25bMdibdhX/i4hxAA6T3vFLdUEU8bsEV0k+oAIVE+2lQLioWEDImwWiTPdX9FGuxCJr28Wot/1afAaJUxaUfbI5cJ1qO0uY0VQsP87sAzOwkfvh2Vm3cPbpJcQVYAh6kGMcA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NrwBvs5ftsiydRzeTD62Y3NYueiZz8mIp0w2EdJCgkc=;
 b=q6ANwjAi1Le+uJNaYOV7TdbqyjXdW59AlkzoCrWbogE/KOWAO/DtFHXvQaMX44/ajQVorL+LIVpSI8r3rg+MRQ4egBtDBmpP5mCv9DWFXEhrAVYFYSXUh8Nwwk5pnlnBqlrAwQHqWhXOfaYKexpXcfknsFSgeFX7R3sDp0wMxqlNF+doHIOfpxfq6nBCyVkPSw1hv+z/99uAtpNygLdGwbP+Yaxb2NHO9eecTKDAvD4AXH/MT/Mg2QK8s8c3fTkoAlv25t21iz2BcF5kdTDhFf2ytoI7mDVq6TOaGKJOWezVyGV+5FM1PBC9ifuMTYpDyrtbcom0NvG5X5PcaSJUIQ==
Received: from CH0PR03CA0376.namprd03.prod.outlook.com (2603:10b6:610:119::23)
 by CY5PR12MB6479.namprd12.prod.outlook.com (2603:10b6:930:34::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.23; Mon, 28 Sep
 2026 15:14:18 +0000
Received: from CH2PEPF00000145.namprd02.prod.outlook.com
 (2603:10b6:610:119:cafe::10) by CH0PR03CA0376.outlook.office365.com
 (2603:10b6:610:119::23) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.451.24 via Frontend Transport; Mon,
 28 Sep 2026 15:14:17 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.117.160) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 CH2PEPF00000145.mail.protection.outlook.com (10.167.244.102) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.472.14 via Frontend Transport; Mon, 28 Sep 2026 15:14:17 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Mon, 28 Sep
 2026 08:13:53 -0700
Received: from [10.221.193.26] (10.126.230.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Mon, 28 Sep
 2026 08:13:47 -0700
Message-ID: <eafbf4ff-e1e6-4cf1-b784-7adb233c7e15@nvidia.com>
Date: Mon, 28 Sep 2026 18:13:44 +0300
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next 09/13] net/mlx5: E-switch, derive manager vport
 from device capability
To: <netdev-bot+sashiko@kernel.org>, <tariqt@nvidia.com>
CC: <andrew+netdev@lunn.ch>, <davem@davemloft.net>, <edumazet@google.com>,
	<kuba@kernel.org>, <netdev@vger.kernel.org>, <pabeni@redhat.com>,
	<agoldberger@nvidia.com>, <cratiu@nvidia.com>, <gal@nvidia.com>,
	<leon@kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-rdma@vger.kernel.org>, <mbloch@nvidia.com>, <moshe@nvidia.com>,
	<ohartoov@nvidia.com>, <saeedm@nvidia.com>
References: <20260923103830.1183-10-tariqt@nvidia.com>
 <179027196200.2160803.11089100690642035873@kernel.org>
Content-Language: en-US
From: Shay Drori <shayd@nvidia.com>
In-Reply-To: <179027196200.2160803.11089100690642035873@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: rnnvmail203.nvidia.com (10.129.68.9) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH2PEPF00000145:EE_|CY5PR12MB6479:EE_
X-MS-Office365-Filtering-Correlation-Id: d9ec59bf-41bd-4e8d-f8f4-08df1d732a35
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|23010399003|82310400026|7416014|376014|36860700016|13003099007|10067099003|4143699003|56012099006|11063799006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	3HdGw5RnWhg5EwTfS+Rt12LfdSikfTvB37CCn2tVyRLAf+kMttBXPVNM6qHMGcJmlLPZyVlrDsV8FcAnsD3Lff8WtJHBVC0lrgcXEt2zRenI8cyd8LvOM0hPOf3/E1LuEA5ByFW1okRtNOXFGp+sH8z8R7iIM9j4eaL4mjdHvg1wvt1yOMDpT2rSR9UrcNPpOdM8NB2vhTr2QzBPBT8IPb/U6iE4NSzA9NQKVckdJ8qeX5FD0qendNyQS1dkLjO8HUsajd/2ANKjTLH1tZ1UdJFQfG9JD2zK6wVOAK6kMimgJxYLLt+U/2Zo+VPz1YsVm8F3Oh1fkNYY1eAeX55QKmt53C0GL6te7eEYY42p+PX6T7k4ZUoBwEJ1xuc7RSdLtbpBIphCH3GIR2reZnRSzekW0vYxR7mxz3EPUpA8EhKHlcZD8g+G53sVhqJvDOw1wKL32nAXOYT8QuJxWrWVcpkLGBqH47hWUvx/au9LZ9abNG2x7mCxsLOymILa8bv0lffgGd7jVgmNbiDRCKtSnjFkTsK4BO2vy5IKu+cGBKx/9JbOc+cb+ts82OaSXl+hN1wZSlKCQyNLoPb5xpWM9ZWdNkASDPijSt5NxgufsCin/VOhl07uki4MAyxnfdA+4KT36clwQ5WSLSEwXVdvyZE1+FbfCV9Z/RuchI5194SuFuGDddKjY5zviOwfNE6AIwiE+GeioArtpu0ZaQZihg==
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(23010399003)(82310400026)(7416014)(376014)(36860700016)(13003099007)(10067099003)(4143699003)(56012099006)(11063799006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	9FcpDMt/rbgCxMHKmZoQgrtO5X1Ay/4tT5KUS88GXN81e0VMWQi47aT5S70Hl8zcdh6ToB5m/ZnVzjsLTe6Uz1xEUxqxZyivPvZ4/XBTYuZBzwCOt1x3ygAesZppjSz96S3qOXMDMGOkBi3mP4nKcWJuVW0Rgc9FvMtCIWzxMZhufBWj4oXOjcf9g9dFejFHlcw6iooht2NXU4YxCC+4l2+zl5VBmeUqGhJ+yk1Jr7fdCCnUnfduO3jR7Du8+bZDk+RtUTPhDlfbCkJVxphnT3BbeBh83rAnNJjSni0Om8xxXTgTkPVE6NAuFlFdHWRg/buBNcjvjo2mNi882cW6ISArxyz1rZSvwqyLMH0RZAK8iu5WudIMtiai//atupdwJ2H7NcOwIrfvQ96+gkVP8voisX8C9/RwG/no51WdfKcrSSGqSlSj41XIs7UK88LA
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Sep 2026 15:14:17.5017
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d9ec59bf-41bd-4e8d-f8f4-08df1d732a35
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH2PEPF00000145.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6479



On 24/09/2026 20:46, netdev-bot+sashiko@kernel.org wrote:
> External email: Use caution opening links or attachments
> 
> 
> Thank you for your contribution! Sashiko AI review found 1 potential
> issue(s) to consider.
> 
> Critical: 0 · High: 0 · Medium: 1 · Low: 0
> 
> If you believe none of the issues are legitimate, please reply to each
> issue of Medium severity or higher and explain why the AI is wrong.
> If any of them are legitimate and you plan to respin, please let patchwork
> know by including "pw-bot: cr" as a separate line at the end of your reply
> (one such reply per series is enough).
> 
> - [Medium] mlx5_eswitch_manager_vport() (include/linux/mlx5/eswitch.h)
>    now returns MLX5_CAP_ESW(dev, esw_manager_vport_number) when…
> 
> --
> 
> net/mlx5: E-switch, derive manager vport from device capability
> 
> The commit changes mlx5_eswitch_manager_vport() to return
> esw_manager_vport_number from the e-switch capability when
> esw_manager_vport_number_valid is set, so the manager vport can be a VF.
> The old ECPF/host PF mapping stays as the fallback. mlx5_esw_vports_init()
> now allocates the manager vport if it is not already in esw->vports.
> 
>> diff --git a/include/linux/mlx5/eswitch.h b/include/linux/mlx5/eswitch.h
>> index a0dd162baa787..03d3620141c83 100644
>> --- a/include/linux/mlx5/eswitch.h
>> +++ b/include/linux/mlx5/eswitch.h
>> @@ -222,6 +222,9 @@ static inline bool is_mdev_switchdev_mode(struct mlx5_core_dev *dev)
>>   /* The returned number is valid only when the dev is eswitch manager. */
>>   static inline u16 mlx5_eswitch_manager_vport(struct mlx5_core_dev *dev)
>>   {
>> +     if (MLX5_CAP_ESW(dev, esw_manager_vport_number_valid))
>> +             return MLX5_CAP_ESW(dev, esw_manager_vport_number);
>> +
> 
> [Severity: Medium]
> Do the SW and HW steering backends agree with this new manager vport
> number?
> 
> esw->manager_vport can now be a vport N that is neither ECPF nor 0. Both
> steering backends still hardcode the old rule to decide which vport is
> the manager.
> 
> In steering/hws/vport.c:
> 
> static bool hws_vport_is_esw_mgr_vport(struct mlx5hws_context *ctx, u16 vport)
> {
>          return ctx->caps->is_ecpf ? vport == MLX5_VPORT_ECPF :
>                                      vport == MLX5_VPORT_HOST_PF;
> }
> 
> In steering/sws/dr_domain.c, dr_domain_is_esw_mgr_vport():
> 
>          return (caps->is_ecpf && vport == MLX5_VPORT_ECPF) ||
>                 (!caps->is_ecpf && vport == 0);
> 
> The e-switch core passes esw->manager_vport to these backends as a
> destination or source port, with no vhca_id. Some examples:
> 
> eswitch_offloads.c (slow-path miss):
>          dest.vport.num = esw->manager_vport;
> 
> rdma.c:
>          mlx5_esw_set_spec_source_port(esw, esw->manager_vport, spec);
> 
> The peer and slave miss rules in eswitch_offloads.c and en/tc/sample.c
> also use it.
> 
> If firmware reports a manager vport N other than ECPF/0, it looks like
> mlx5dr_domain_get_vport_cap() and mlx5hws_vport_get_gvmi() would treat N
> as a foreign vport. They would not return the cached esw_manager_caps or
> esw_manager_gvmi. Instead they would go through dr_domain_add_vport_cap()
> or hws_vport_add_gvmi(), which query N with other_vport or other_function
> set to true. Vport 0 would also keep mapping to the local manager's
> caps/gvmi.
> 
> Could this lead to failed rule creation, or to rules that resolve to the
> wrong vport context, when SMFS or HMFS steering is used on such a device?
> 
> HWS already reads the capability in mlx5hws_cmd_query_caps() into
> caps->eswitch_manager_vport_number, and hws/table.c and hws/action.c use
> it. hws/vport.c does not. Should hws_vport_is_esw_mgr_vport() and
> dr_domain_is_esw_mgr_vport() be updated to use the capability-reported
> number as well?

VFs e-switch managers don't support SWS, and HWS only uses the hardcoded
manager check for source_port matching. FW doesn't support source_port
matching for a VF e-switch manager, so a VF manager always matches the
source by vport metadata (reg_c_0), and this helper is never reached for
it. HWS destination vport actions take the vport number directly,
without this lookup, and table/action defaults already use
esw_manager_vport_number. So this isn't a regression for VF e-switch
managers.


> 
> The later patches in this series don't appear to touch the steering
> backends. Current firmware probably reports numbers that match the
> hardcoded mapping, so this would only show up with firmware that reports
> a VF as the e-switch manager.
> 
>>        return mlx5_core_is_ecpf_esw_manager(dev) ?
>>                MLX5_VPORT_ECPF : MLX5_VPORT_HOST_PF;
>>   }
> 
> --
> Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20260923103830.1183-1-tariqt%40nvidia.com

