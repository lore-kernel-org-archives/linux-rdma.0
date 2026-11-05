Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.61.64
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793890280;
	b=RIsAHolZ0Y2iudffPQuB5YQlgV20V8i7RTDjmXBj2jFqYqCd6no1LpPk68/2ibOlDUu2
	 KTYkbwXYHfFwSqC9zcwCXv/GN5ZWfTzUONRPJT3xTsNP+931PpIzdUtWsXNX1SiiP9Ly8
	 /XAXbipuCKTqCJ0arp4G3VA/+Jv1LO8Juw9fmSEJ7imafy5DbiHDUest6a00egpLS1vSp
	 G/2NOPik07r1i6NGRhdwxcZkhlY6lm1MQnPbAFIjbpumjtNM6KvRklen9WCpBHMu8MBMN
	 FCvO+rbSWke+VMb13j9UAGJofRqxFFsm7V2h4F7LfppPcZkidHJp7rXpcHlo258BAtg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793890280;
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
	bh=pWNxwC1UYXJ+UDSIqs/+wAgC6MGTGehs82bXgC3QfKw=;
	b=JtlHplVjN5o/UUzwNR/ISLwZvqDl5kpdLcyw0HS5Xdvz0bj72J/9yJrUovzj4OmeAEey
	 J5j6xT3dm/x0e/KuyQ5KNJQf8hOmqBuw7GPSvMqRJdMGy+o67hUbq0Y/hiZcfMRGD+Cym
	 ESs1u6wAlp1kcoElOpXSaeVy0YMv5kaeq4+ZCFor1xA9DqR8nkVP9Ukqjvo3RYyjx1uR0
	 GCVAPGJH/qTlEtqpfvo500CsVPJyo410RU4Ko4z0jSOcPN/TXVlykzJW1frSr2rqrORNW
	 c5M6+ZHuhsa2cXXIPHkARMcsRLIgS2I15CaT7rS2vgVe66g+V2z0y6MTrsQY6E9dUjQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=UM4Pzvmo;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.61.64
Received: from DM1PR04CU001.outbound.protection.outlook.com (mail-centralusazon11010064.outbound.protection.outlook.com [52.101.61.64])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CD6B606A31B
	for <linux-rdma@vger.kernel.org>; Thu,  5 Nov 2026 14:51:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7CD6B606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=UM4Pzvmo
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tQ4+XjLevr36a8XevsgjjmMsTBndFYB1iwgTp3aYgp6thAHer7Ag3rC6AnYBfsZPknnYR2F5DmmolYIuDDvPWNuYlT5R6dl9cnfn80Wee52joyyJiyhJRR9LHmAsvYRc0PamxCwr1hLOhA1bFKvlDkDDoSaSTCLB4ln2j98iGLoqe5z0b79bxz4E5hivN4H/dluFDSpyhhLOxZKHCMII50s/jiOzgg4nToapTOlYUxjC2U+dRpkSNeJdZVBOLi0ELD7XAJnobskwOxUWaRidO8+uDwNz1kQdaiozfwJ9K9Mm4dyUVBZHfRyyS3dihagGa1oJCQsIBecvv5gTwa60ZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pWNxwC1UYXJ+UDSIqs/+wAgC6MGTGehs82bXgC3QfKw=;
 b=EmWCqvd/we7v64aQX/KCYJTlKifPYozY/DYSPrwAvb1UuLXpsQIF24jHVpaJ7b+Ta7D20OaLUs01EdC06HHqGI1zmq51582hSFdoc9h1jaBwOA8mRJOGC73Tv/bZRqhWVWhl1zN+jUwqIN8fN+OLL8ifXiBBiDrBAsmtJ42CJVGBH3vXdPzYJoPPRbTN48NAfxk2tU24gsccE+tqiPqPDEnPvN/3qY2qEHVw/qAMdLfv4QbyJYtGJwOuqezXjm1ovGDZJBcrtOn7r4OpXIu3u1XgvI96W8bixPJ3c2Xf21DVgj2idSysMC0zHHuoaQ0XB3hrAPgNFo3K8zThNkLMOQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=lists.linux.dev smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pWNxwC1UYXJ+UDSIqs/+wAgC6MGTGehs82bXgC3QfKw=;
 b=UM4PzvmoUAIskJOBECSzTwJpOIDfdbLfVx/O9lFN4UMrCo12TTDXH0njEm+QJM74SmGRSyHEYXbTDOp6YxzzpPni17Nix3YBGfy4EWp7KFSo1ZIxFQ3fpuS7EhS41FLUEHwfKsR8JAvVSNj3S7MukpC5RFAFVM8Sx+/otnrLQadDWM2d0D4EhrG/JXMt0N3QwQ35ooRsMRptgzwpQISbmHUSqOZ97lT3ukAsTrIGdtagqbTVB6YVz39aoTrtgqJz1wrHhBtNzocNBCcdp4cKg+u+F+JWfGwLlKNqBepqyRjz7F+wGz8OqK1ciXjQ8xddqMXQqXUY1e2A2PFAPw9XuA==
Received: from PH7P220CA0125.NAMP220.PROD.OUTLOOK.COM (2603:10b6:510:327::18)
 by CY5PR12MB6082.namprd12.prod.outlook.com (2603:10b6:930:2a::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.569.12; Thu, 5 Nov
 2026 14:50:49 +0000
Received: from SJ1PEPF000037B4.namprd05.prod.outlook.com
 (2603:10b6:510:327:cafe::a6) by PH7P220CA0125.outlook.office365.com
 (2603:10b6:510:327::18) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.592.10 via Frontend Transport; Thu, 5
 Nov 2026 14:50:49 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.117.160) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 SJ1PEPF000037B4.mail.protection.outlook.com (10.167.244.196) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.592.5 via Frontend Transport; Thu, 5 Nov 2026 14:50:48 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Thu, 5 Nov
 2026 06:50:30 -0800
Received: from [10.125.206.9] (10.126.230.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Thu, 5 Nov
 2026 06:50:28 -0800
Message-ID: <506c391b-69bb-40e5-a9ff-d4f51aa3ac0b@nvidia.com>
Date: Thu, 5 Nov 2026 16:50:25 +0200
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
Subject: Re: [PATCH rdma-next 03/23] net/mlx5: Add capability filtering in
 adversarial mode
To: <sashiko-reviews@lists.linux.dev>
CC: <linux-rdma@vger.kernel.org>, <dtatulea@nvidia.com>
References: <20261103163949.1554-1-yishaih@nvidia.com>
 <20261103163949.1554-4-yishaih@nvidia.com> <sashiko-outbox-197656@kernel.org>
Content-Language: en-US
From: Yishai Hadas <yishaih@nvidia.com>
In-Reply-To: <sashiko-outbox-197656@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: rnnvmail201.nvidia.com (10.129.68.8) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PEPF000037B4:EE_|CY5PR12MB6082:EE_
X-MS-Office365-Filtering-Correlation-Id: 83116aee-953a-425e-a988-08df3b4c2e2f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|376014|36860700016|82310400026|10067099003|260925021911599003|261026140227099003|260925022911599003|260925021311599003|261022075727099003|11063799006|4143699003|261022105027099003|261026121527099003|56012099006|261009223027099003|261028144727099003|261021135927099003|261021121427099003|261102123227099003|18002099003|22082099003|6133799003;
X-Microsoft-Antispam-Message-Info:
	oq5e8dmpLOA96/akhVEuptFxHTAIJ8h7YshF1mV6QAzJNp37fH6IRHiTQ6UuaNMH+Y8GyEAGYCQpRMv3XJ7yh3SrxmhBhQ/td7qImiFPDWTtcR7oElbPiz+um7ZKmvkpV/SWuTiSXIA5RVDhcQeXo6YPTZw91Bw7k+/JKIVNdGwpy+M/p4ugjdBBDxpG4SPrAd1m8ATxcJDur4e3rTAIyBlgqiXJxz3m2DsswBU08kff42X/qwfESgBAiWnUecW05ZtvDJLiXLqDAqgsFLTUrRFIhTrTrFqb+URnbFOln0M86g22LxB/koJF0K+9n2frG6HyITec4rPbhELipbBz4DDhrRyosvtjFGnqDoPds+1CRw7Ai8u23am3X6b9wCMNxiKnyJg76Ckc4B12T6szWOEEFkPL8fVm9EhOYC0Q+Kz+wDkqB03cxCHqiObxqy8wTCT/0htV2g5NHWYdFP5tD6wCLCSUmKRTsrCA5orF+YhhFJLB8vbAea4vIeR1+GN/zxtUlbUSLkN/sCMWGiuBKr7bcghxfz8V1s79Hqf5sT9PEUA1Vh6G1bwlR7MW6PiYYZwD3a+LHJlfiZM3wFHJSkJiuP78aMpPty7948CinpTa10oqoeyl83yW0XzSpZW4pX5AlfLJJdOsiX+g5XhlcaoddstYTVb5aEMAoKHW5svhcodVqsQB2UfxQKavy4bvQXobRDdcp2cXzROp9osg/g==
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(376014)(36860700016)(82310400026)(10067099003)(260925021911599003)(261026140227099003)(260925022911599003)(260925021311599003)(261022075727099003)(11063799006)(4143699003)(261022105027099003)(261026121527099003)(56012099006)(261009223027099003)(261028144727099003)(261021135927099003)(261021121427099003)(261102123227099003)(18002099003)(22082099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	fFkf9sCzmZf43NdauH39mbDEIAIMXgBp2wSS5qZR5dDOGw0+9u+NtnjwBZsxiKCayzFvIWAIq9z19Ex56Ymujq3999xhwTku2Jsk+LIdr6L26z8wNsaTs2r1gd5pFr304zs8cX+/9D0swBrdnP0Kz8y7ao3xJnL3nuML7N/tR8NWGhkNZgRWMYPhc3XuizqgLaTdo7REnT40KzhTckMcuHkJrqdxCFJw5etarxN4Gn3knmaUDvDOR3lpHl57IsRgc5qOdVjd6zehB05a2M60sRhUwsQ0zC3mEVtBVJ+BVdb6Ys2QFPojMWxTTH5gCyTeUqyUksCpwMIqXE80FI/CRVfgVAo5s3Ng1n3ItPDZrHfHu4cLBhB1IfEsQzQEm1P+4daVRUVVEiEI7xtA5ad6P5JEKV5ki5ZsyUqrA0e9AVKvNVR3CFhnFVrT+27yo3lo
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Nov 2026 14:50:48.7945
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 83116aee-953a-425e-a988-08df3b4c2e2f
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF000037B4.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6082

On 04/11/2026 18:43, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 4 potential issue(s) to consider:
> - [High] net/mlx5: unclamped log_max_flow_counter_bulk causes OOB heap read
> - [High] net/mlx5: unchecked minimum EQ caps cause divide-by-zero in alloc_cpu_rmap()
> - [Medium] net/mlx5: incomplete log_min_mkey_entity_size check in caps_filter.c
> - [Medium] net/mlx5: unclamped log_max_*_list caps overflow signed shift in en_fs.c
> --
> 
> commit 8f36be5a60064c165f291709b6cbba37c28f527e
> Author: Dragos Tatulea <dtatulea@nvidia.com>
> 
> net/mlx5: Add capability filtering in adversarial mode
> 
> This commit introduces capability filtering in adversarial mode by clearing
> firmware capabilities by default and selectively allowing, clamping, or
> validating fields in current and max HCA capabilities.
> 
>> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/caps_filter.c b/drivers/net/ethernet/mellanox/mlx5/core/caps_filter.c
>> new file mode 100644
>> index 0000000000000..67b2603397450
>> --- /dev/null
>> +++ b/drivers/net/ethernet/mellanox/mlx5/core/caps_filter.c
>> @@ -0,0 +1,381 @@
> 
> [ ... ]
> 
>> +static int mlx5_adversarial_filter_general(struct mlx5_core_dev *dev, void *dst,
>> +					   void *src)
>> +{
>> +	int err;
>> +
>> +	memset(dst, 0, MLX5_UN_SZ_BYTES(hca_cap_union));
> 
> [ ... ]
> 
>> +	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, eq_overrun_count);
>> +	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, invalid_command_count);
>> +	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, quota_exceeded_count);
>> +	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, log_max_flow_counter_bulk);
> 
> [Severity: High]
> Should log_max_flow_counter_bulk be clamped or range-checked here?
> 
> During initialization, mlx5_init_once() -> mlx5_fs_core_alloc() ->
> mlx5_init_fc_stats() calls get_init_bulk_query_len():
> 
> drivers/net/ethernet/mellanox/mlx5/core/fs_counters.c:get_init_bulk_query_len() {
> 	return min_t(int, MLX5_INIT_COUNTERS_BULK,
> 		     (1 << MLX5_CAP_GEN(dev, log_max_flow_counter_bulk)));
> }
> 
> Because log_max_flow_counter_bulk is an 8-bit field, if an untrusted device
> reports 31, (1 << 31) overflows a signed 32-bit int to INT_MIN (-2147483648),
> and get_init_bulk_query_len() returns -2147483648.
> 
> Then mlx5_fc_stats_bulk_query_buf_realloc() passes that negative bulk_len to
> mlx5_cmd_fc_get_bulk_query_out_len():
> 
> drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c:mlx5_cmd_fc_get_bulk_query_out_len() {
> 	return MLX5_ST_SZ_BYTES(query_flow_counter_out) +
> 		MLX5_ST_SZ_BYTES(traffic_counter) * bulk_len;
> }
> 
> Since MLX5_ST_SZ_BYTES(traffic_counter) is 16UL (size_t), multiplying 16UL by
> (size_t)(-2147483648) produces 0xfffffff800000000UL, whose lower 32 bits are
> 0. Truncating the result to int returns out_len = 16.
> 
> kvzalloc(16, GFP_KERNEL) then succeeds while fc_stats->bulk_query_len is set
> to -2147483648. When mlx5_fc_stats_work runs
> mlx5_fc_stats_query_all_counters() -> update_counter_cache(), could this read
> flow_statistics[index] out of bounds past the 16-byte fc_stats->bulk_query_out
> buffer?

This capability is not used by RDMA.
Currently, netdev doesn't handle adversarial flows.

> 
>> +	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, log_max_rq);
>> +	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, log_max_sq);
>> +	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, log_max_tir);
>> +	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, basic_cyclic_rcv_wqe);
>> +	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, log_max_rqt);
>> +	MLX5_HCA_CAP_CLAMP(cmd_hca_cap, log_max_rqt_size, 0, 13);
>> +	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, vnic_env_cnt_bar_uar_access);
>> +	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, vnic_env_cnt_odp_page_fault);
>> +	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, roce_rw_supported);
>> +	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, log_max_wq_sz);
>> +	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, vhca_state);
>> +	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, log_max_vlan_list);
>> +	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, log_max_current_mc_list);
>> +	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, log_max_current_uc_list);
> 
> [Severity: Medium]
> Can unclamped values in log_max_vlan_list, log_max_current_mc_list, and
> log_max_current_uc_list overflow the signed shifts in en_fs.c?
> 
> In drivers/net/ethernet/mellanox/mlx5/core/en_fs.c,
> mlx5e_vport_context_update_vlans() computes:
> 
> 	max_list_size = 1 << MLX5_CAP_GEN(fs->mdev, log_max_vlan_list);
> 
> 	if (list_size > max_list_size) {
> 		fs_warn(fs, "netdev vlans list size (%d) > (%d) max vport list size, some vlans will be dropped\n",
> 			list_size, max_list_size);
> 		list_size = max_list_size;
> 	}
> 
> 	vlans = kvcalloc(list_size, sizeof(*vlans), GFP_KERNEL);
> 
> and mlx5e_vport_context_update_addr_list() similarly computes:
> 
> 	max_size = is_uc ?
> 		1 << MLX5_CAP_GEN(fs->mdev, log_max_current_uc_list) :
> 		1 << MLX5_CAP_GEN(fs->mdev, log_max_current_mc_list);
> 
> Since these three capabilities are 5-bit fields (0..31), if an adversarial
> device reports 31, (1 << 31) overflows a signed 32-bit int to INT_MIN
> (-2147483648). The comparison list_size > max_list_size (or size > max_size)
> then evaluates to true, setting the count to -2147483648 and passing
> (size_t)(-2147483648) to kvcalloc() and kcalloc() without __GFP_NOWARN.

These capabilities are not used by RDMA.
Currently, netdev doesn't handle adversarial flows.

> 
>> +	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, sq_ts_format);
>> +	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, rq_ts_format);
>> +	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, steering_format_version);
>> +	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, create_qp_start_hint);
>> +	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, ats);
>> +	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, cross_vhca_rqt);
>> +	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, log_max_uctx);
>> +	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, max_num_eqs);
> 
> [Severity: High]
> What happens if the EQ capabilities (log_max_eq, max_num_eqs, or
> max_num_eqs_24b in mlx5_adversarial_filter_general_2()) result in a maximum EQ
> count less than or equal to MLX5_MAX_ASYNC_EQS?
> 
> mlx5_max_eq_cap_get() derives the maximum device EQs from max_num_eqs_24b,
> max_num_eqs, or (1 << log_max_eq). During mlx5_load() ->
> mlx5_eq_table_create(), get_num_eqs() calculates:
> 
> drivers/net/ethernet/mellanox/mlx5/core/eq.c:get_num_eqs() {
> 	...
> 	num_eqs = min_t(int, mlx5_irq_table_get_num_comp(eq_table->irq_table),
> 			max_dev_eqs - MLX5_MAX_ASYNC_EQS);
> 	...
> }
> 
> If an untrusted device reports max_dev_eqs == MLX5_MAX_ASYNC_EQS (for example,
> max_num_eqs = 4 or log_max_eq = 2 when MLX5_MAX_ASYNC_EQS is 4), get_num_eqs()
> sets eq_table->max_comp_eqs = 0.
> 
> mlx5_eq_table_create() then calls alloc_rmap() -> alloc_irq_cpu_rmap(0) ->
> alloc_cpu_rmap(0, GFP_KERNEL), which divides by size == 0 in cpu % size.
> Wouldn't this trigger a divide-by-zero fault during driver load unless the
> effective EQ count is checked to be strictly greater than MLX5_MAX_ASYNC_EQS
> (and log_max_eq is kept below 31)?
> 

OK, it will be fixed as part of V1.

> [ ... ]
> 
>> +static int mlx5_adversarial_filter_general_2(struct mlx5_core_dev *dev, void *dst,
>> +					     void *src)
>> +{
>> +	int err;
>> +	u32 val;
>> +
>> +	memset(dst, 0, MLX5_UN_SZ_BYTES(hca_cap_union));
> 
> [ ... ]
> 
>> +	val = MLX5_GET(cmd_hca_cap_2, dst, max_mkey_log_entity_size_mtt) ?: 31;
>> +	err = MLX5_HCA_CAP_CHECK(cmd_hca_cap_2, log_min_mkey_entity_size, 0,
>> +				 val);
>> +	if (err)
>> +		return err;
>> +
>> +	/* The fixed buffer min is don't-care when its valid bit is clear. */
>> +	if (!MLX5_GET(cmd_hca_cap_2, dst,
>> +		      min_mkey_log_entity_size_fixed_buffer_valid))
>> +		return 0;
> 
> [Severity: Medium]
> Are there two cases where the validation of log_min_mkey_entity_size in
> mlx5_adversarial_filter_general_2() is too permissive?
> 
> First, when min_mkey_log_entity_size_fixed_buffer_valid is 0,
> mlx5_adversarial_filter_general_2() returns 0 without checking
> log_min_mkey_entity_size against max_mkey_log_entity_size_fixed_buffer.
> However, in drivers/infiniband/hw/mlx5/mlx5_ib.h, get_min_log_entity_size_cap()
> falls back to log_min_mkey_entity_size when that valid bit is clear:
> 
> 	if (access_mode == MLX5_MKC_ACCESS_MODE_KSM &&
> 	    MLX5_CAP_GEN_2(dev->mdev,
> 			   min_mkey_log_entity_size_fixed_buffer_valid))
> 		min_log_size = MLX5_CAP_GEN_2(
> 			dev->mdev, min_mkey_log_entity_size_fixed_buffer);
> 	else
> 		min_log_size =
> 			MLX5_CAP_GEN_2(dev->mdev, log_min_mkey_entity_size);
> 
> while get_max_log_entity_size_cap() still uses
> max_mkey_log_entity_size_fixed_buffer for MLX5_MKC_ACCESS_MODE_KSM. If
> min_mkey_log_entity_size_fixed_buffer_valid is 0 and
> max_mkey_log_entity_size_fixed_buffer < log_min_mkey_entity_size <=
> max_mkey_log_entity_size_mtt, min_log_entity_size_cap will exceed
> max_log_entity_size_cap in mlx5_umem_mkc_find_best_pgsz(), producing an
> inverted GENMASK_ULL() of 0 and triggering WARN_ON(!page_size) in
> alloc_cacheable_mr() and can_use_umr_rereg_pas().
> 
> Second, during mlx5e probe, mlx5e_build_rq_params() ->
> mlx5e_mpwrq_validate_regular() -> mlx5e_mpwrq_page_shift(mdev, NULL) checks:
> 
> drivers/net/ethernet/mellanox/mlx5/core/en/params.c:mlx5e_mpwrq_page_shift() {
> 	u8 min_page_shift = MLX5_MPWRQ_MIN_LOG_STRIDE_SZ(mdev);
> 	u8 req_page_shift = xsk ? xsk->log_hrq_ix_sz : PAGE_SHIFT;
> 
> 	/* Regular RQ uses order-0 pages, the NIC must be able to map them. */
> 	if (WARN_ON_ONCE(!xsk && req_page_shift < min_page_shift))
> 		min_page_shift = req_page_shift;
> 	...
> }
> 
> where MLX5_MPWRQ_MIN_LOG_STRIDE_SZ(mdev) is log_min_mkey_entity_size ?: 12.
> If log_min_mkey_entity_size is allowed to be up to 31 (greater than
> PAGE_SHIFT), wouldn't this trigger WARN_ON_ONCE() on probe?
> 

OK, it will be fixed as part of V1.

Yishai
