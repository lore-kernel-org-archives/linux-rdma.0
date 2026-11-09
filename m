Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.201.19
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794220247;
	b=v0aZ2e869mCrwd5TKlt00QntLnOIQ4pF0UrakZyrzM5/2aMxrKOzz57ZP8VibrGD/IYL
	 mNdVk32ZAkKHPP4E5u5iczu3M2uc4DbNh2WI4ZlkwZzu2dxHXGx0kDvu7vZt/805Clhqr
	 6lRyncWkYNgLlpeEMJ6b9Fa6X/CoC4Yd31hiOJ9XxxDJV35q9L/67TjICOUfBeXEQ6Adi
	 cAJqxpBv55U2f16qsMW5Yp5YxMWXHgG9YyYH2+SOJleLqGrdNy+qA3/rmh5sv4d1ovRjh
	 9rq49zl6iMJ7R6SzESjCYKKbvdPZpFN3ewXaGjWJSIcSxEYx7TBflNu2O5FZ/nLSrnQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794220247;
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
	bh=Lwv7/6Rm1ksnmB8FxVlkGOpwRvqoR8h3fOYGT7fchNY=;
	b=KEDotIvWyExUSKjGj7uJJF1A8rd6nviSVUq0qpPQcPiUgj7N+x1mOpWgs3thMmbkgY5A
	 tUJHphJKEC9RNC5LLgmhzU99R87mL3Ex4DSJUruZ929J/GDj4KDNy1VxXzeke9PUiFNLF
	 D3VZV73ttb/T33L2G9RSFpZHFR7/tNUmH/H5MJDWGRmoxtvCcKLPfg5UmMUJUj+EpGIUw
	 ih0aBt4TUWG8gNSeuwQoJt4SRcs5+ZLGz/kf7VFTHKBT5KxcToEBBhPp8MCIBbKnxZB42
	 8FgxHK+EY9TXJcncRxisq2g89WNgJiTi6dpKgqmRVdTbIbdhKtZlyEQgNl3VgV6Fy0Q==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=DDiXqog+;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.201.19
Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11010019.outbound.protection.outlook.com [52.101.201.19])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E9EA606A325;
	Mon,  9 Nov 2026 10:30:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1E9EA606A325
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=DDiXqog+
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vi5kx7+ULuDWcWhYFJGE11pC0J/rJg6/Rihrsh/CRrjYHalDVtVUiwZx+01xWHt4dQqDj46+fyy6qI9KafO4vHDuhJVrP7Sjiuh+wmiux52OsYqDtPPGU7hyPbYTJgJE4sEdISpPwvnA4UDLyzeR9s44nncZ2kxa7zvWYyjl1cLu9xyBHyjPDg//1ymw/iIl4IL+GWbePKXJK3eRR3+AG8bDSqHSEjRpzvfiWGtgZupP+E7ZVoX67nnV7jGB34T6CScE8Ofiz/QOH7xQiMgsxxCVvIoW7WNwE2tehbnejGferM99yJXKYKy4Aa8XN/W0fTtk83oHDUEOzKxITKQ4Tg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Lwv7/6Rm1ksnmB8FxVlkGOpwRvqoR8h3fOYGT7fchNY=;
 b=tjGVyLRhvX4CuWZhh5UwmL817gquU5D6J1E+S5TXWIEup6GQE7bmca6s/OseoK38/MWy0+dGfid/UArjMPK6m/x7RNJvtBkTa1EgSaThJqRV6b0wa1Tp+eVkuTyb26W31SRSRI881pyypBMKj1ykdSirzzGiiQnCdNIvH2iHLkQDhZpm4scvb5Xfk/rVRrSpuDBsLGj9upGGrEsOJPHuXmo6B6u5ID47hy8HZGxKooLsFy1Px4iZmdZhG0DZ7ce2mq/INehU0oHyDGsJC9aBOSy/pe7zqtB21pYlErlh+oqhUrFsbar6tdc/O2u3L0liWQikpasAU4cUtM4Dr9JglA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Lwv7/6Rm1ksnmB8FxVlkGOpwRvqoR8h3fOYGT7fchNY=;
 b=DDiXqog+PqX07nDiSAIMNA46U+RRzndKiZdNLy0tg7CfWd8P4YRCxf1R6rMyCrL7ivfWAYLoyrGlNWNCYLygrtgafRb7mzabJ+NAIxsViO1hP0O2lcA8vCQNZsILVqjkKqm+nvG63tkCN9J6tEcNMP/9QG0f/hhgUkMo5c17mWxI33i2RcpAygtIkwrFqcjZLPWZqZkrfBiwqYiWpN0cjFj8JqDMTqAcE1zSNWD4z1uMspn719SJlQOiK4vjQtSlvqQQjckM2gWB3RXkAqmaf4gcgZDnMtAlam+osoAr3FkpmB3lrSsgTyqnpG8fVwVXvbKsQj//1Dh+EN2T6zz5Wg==
Received: from SJ0PR03CA0372.namprd03.prod.outlook.com (2603:10b6:a03:3a1::17)
 by MN0PR12MB5811.namprd12.prod.outlook.com (2603:10b6:208:377::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.8; Mon, 9 Nov 2026
 10:30:37 +0000
Received: from SJ1PEPF00002317.namprd03.prod.outlook.com
 (2603:10b6:a03:3a1:cafe::5c) by SJ0PR03CA0372.outlook.office365.com
 (2603:10b6:a03:3a1::17) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.592.13 via Frontend Transport; Mon, 9
 Nov 2026 10:30:36 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.117.161) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 SJ1PEPF00002317.mail.protection.outlook.com (10.167.242.171) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.615.4 via Frontend Transport; Mon, 9 Nov 2026 10:30:36 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Mon, 9 Nov
 2026 02:30:22 -0800
Received: from [10.125.206.9] (10.126.231.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Mon, 9 Nov
 2026 02:30:17 -0800
Message-ID: <64bdfae3-6747-475f-9b90-4882d651d1ee@nvidia.com>
Date: Mon, 9 Nov 2026 12:30:14 +0200
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
Subject: Re: [PATCH rdma-next 20/23] RDMA/mlx5: Clamp log_max_* shifts in QP
 and WQ limit checks
To: <netdev-bot+sashiko@kernel.org>
CC: <jgg@ziepe.ca>, <leon@kernel.org>, <linux-rdma@vger.kernel.org>,
	<netdev@vger.kernel.org>, <saeedm@nvidia.com>, <tariqt@nvidia.com>,
	<mbloch@nvidia.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
	<edumazet@kernel.org>, <davem@davemloft.net>, <andrew+netdev@lunn.ch>,
	<dtatulea@nvidia.com>, <moshe@nvidia.com>, <maorg@nvidia.com>
References: <20261103163949.1554-21-yishaih@nvidia.com>
 <179408310595.994134.12854233732790224193@kernel.org>
Content-Language: en-US
From: Yishai Hadas <yishaih@nvidia.com>
In-Reply-To: <179408310595.994134.12854233732790224193@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PEPF00002317:EE_|MN0PR12MB5811:EE_
X-MS-Office365-Filtering-Correlation-Id: 5390b833-c15c-42da-61bd-08df3e4c7e67
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|7416014|1800799024|23010399003|82310400026|376014|22082099003|18002099003|10067099003|261009223027099003|56012099006|4143699003|11063799006|261028144727099003|261022105027099003|261026140227099003|261021135927099003;
X-Microsoft-Antispam-Message-Info:
	Suc2+MGlbpx9or4LUSW68mfA9wgqQh7GsgKW09L6I/jlnpatYaDwhm6x2zzgOpqwIJmTM2Hb6KTLdC/+EDB8IApUlBSKssA7GZhccBLHLc4dViVXDclesHzv653ssOLfwk9MUU62YzZUTxlS4cwp9pBkdtnJ3+kMGafdxDeiqNE1x3E/AhPFp2vzUZwt4xo/iPdKSH11WpyuntC81yq2EqgROJDHF/XknRQ4Hs8Jsve+0l74a632bJc941mMjmfYwfdf+df4JB2sTVbbxXGdBwBN0asR5jkwanRvXgrR7ukV06SzHZ16N4DhRab0empP92Oi5NK2V0FssZtC2ETTnn2k4802tEcB3td8MWWXCKb13LWH2Qt5i9f3qk7GKw1UpY+koVxmyeFqNhtfNFpWVWywuj+m2MTu7vCHIB3va1Ia2TcCwzUIAti+ODG4EvI+6b19SHvkHANSCrj/tAcusCMCBFvwKPY4yz2JFHpTzia0v7/pjcjSzhJ6HZdudFcMHPOV7RCi6laLe4nEUPqvy4AKICDgRme/LlgFYsi8zVgLguqofEPGaZ0T8v5XqtGdi+FjrioMnFiuaTfOuVHExNCGBM1JEW965kb7JhNp3B4H2r9O+/gNHEZmxsU1MX+9eMjJ0ZhVmGHiLi0iu5fV7ikuDv+9ErU0zwtAAyK7kf0vFScF27JhcWMOYj6MPVusU/R8VfCX/RMQPvboKYnbKg==
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(36860700016)(7416014)(1800799024)(23010399003)(82310400026)(376014)(22082099003)(18002099003)(10067099003)(261009223027099003)(56012099006)(4143699003)(11063799006)(261028144727099003)(261022105027099003)(261026140227099003)(261021135927099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	GGEiEvMQTwS8t8FSjtNZjvM2SFScN8daYOs19Eypm3uZawnBbXmxwL88KXAH4o8NCkjFOYi18GdJxQ0S1c2sLa4M2Pttvrwo+2IFrVwFvaRVPXvEE1LqUWFUdgSBi+t3H9hKeL8kB9vFFiZxBSa8qQvi2P1ata8+47jJDe+uaspRKdRdIIpgoUv8IT8sR0JZcghn5J6jTS9TnU+khwGXcitKLSKyU91urfjInOA7keVmuRmwGNNVvmxQukKhLe8r1RrCpgYAoOHN1yP1GbGXbaceuIvnddvSCCRUPINo5H6tYRI31sVdcXfL69ikIM/9Uaqca3yxOVAj1lccidxAItulERigvgW6Qn2FJg5er1qxBSpMh/cNUOwfYEfJJEf/qHsYOIXYpuc2XHJr0jR6fqIsuSRqWn1hkkjLKcpMxLMjXE9dqo1+IYcaGtgUGL9G
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Nov 2026 10:30:36.8720
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5390b833-c15c-42da-61bd-08df3e4c7e67
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF00002317.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB5811

On 07/11/2026 22:25, netdev-bot+sashiko@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found more severe
> issue(s) in other patches of this series. This mail is only an FYI, in case
> you want to address the nit picks below when you respin.
> 
> Low priority / nit picks for your consideration:
> 
> - [Low] The commit message says each limit is computed from "an 8-bit
>    log_max_* FW capability".
> 
> --
> 
> RDMA/mlx5: Clamp log_max_* shifts in QP and WQ limit checks
> 
> This commit replaces several open-coded 1 << MLX5_CAP_GEN(...) limit
> calculations in drivers/infiniband/hw/mlx5/qp.c with
> MLX5_CAP_GEN_LOGSZ_U32(). This avoids an undefined shift when a NIC
> reports a log_max_* capability of 31 or more. The affected checks are in
> set_rq_size(), calc_sq_size(), set_user_buf_size(), create_dci(),
> create_user_qp(), validate_rd_atomic() and set_user_rq_size().
> 
>> Several QP and WQ size checks in qp.c compute their limit as
>> 1 << cap, where cap is an 8-bit log_max_* FW capability. An untrusted
>> NIC can report 31 or more, which makes the shift undefined.
> 
> [Severity: Low]
> This isn't a bug, but is "an 8-bit log_max_* FW capability" accurate for
> all the caps this patch touches?
> 
> In struct mlx5_ifc_cmd_hca_cap_bits in include/linux/mlx5/mlx5_ifc.h,
> only log_max_qp_sz is 8 bits wide:
> 
> 	u8         log_max_qp_sz[0x8];
> 
> The rd_atomic caps used by validate_rd_atomic() are 6 bits wide:
> 
> 	u8         log_max_ra_req_dc[0x6];
> 	u8         log_max_ra_res_dc[0x6];
> 	u8         log_max_ra_req_qp[0x6];
> 	u8         log_max_ra_res_qp[0x6];
> 
> The cap used by set_user_rq_size() is 5 bits wide, so its maximum value
> is exactly 31:
> 
> 	u8         log_max_wq_sz[0x5];
> 
> The main point still holds, since every one of these fields can reach 31
> and the shift can be undefined.
> 
> Could the wording be changed to something like "a log_max_* FW capability
> of up to 8 bits"?
> 

Right, will fix the commit message in V1.

Yishai
