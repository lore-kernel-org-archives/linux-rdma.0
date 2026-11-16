Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.57.43
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794846536;
	b=XtcSNrNeI6s9rMeMwgQd+jLOUpXpr/JEKYJEjTu9YLPhNuY4IQIpHZQN5LtQitbfI5RY
	 fimPLRTiyzksaRnamtjS+GyiUzSkFHunuBdkplK1tMHHFwICZM7RLGu+uDrQoGtylt2te
	 evo5INvAaE7q82Eh6lYdUgvQrbVmOJvCffzSC/thUNKxarkhND9o95K7odjwAIyrCQwd1
	 Y15iZU0YiFtbcsEoBSfwmZFjN6Jei9XqLbpYbXjUSTtF0lACN2aC1JbHMhxf2rNX6qZFJ
	 /BnwG4szwxojRF4jAO6joHh/VKZRLhlBq73jfKC/QM6LZZ6aX1GQv8f3E5JaDZ7fYVQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794846536;
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
	bh=1OwhN+sZuAa8/WZnHOStP2WKZXTwbg/QW4V7crZqO68=;
	b=gjzxrptThPdDy01aTI2wg58hu4RvOh04/FjYVwanLKqrdAywRkSaPC0GUUTLOrpgnAYS
	 YDqK6inNpdE04EYDS3AGNn6Y0aom/FYZB6ss0mEosqvZyTtJIk5zAot5zkN6aDCNDmB3j
	 sjXWosHVMsMZdQYnWZJcDFHhaowbUz4JD4Xo5e2WIO5MF/U3Z4nzfRYxpH4Q6GQaAs4+F
	 k6q4aib5MEyaWqXuS3HA0KJG5BtYEqtFkwOcPQzOCOJu917L6OSUMP+7Pcy683YC+WrZh
	 DB3LSW3BMI3wWGKEGIsJ5fx8FGb4WcYvW2PNGZXaP+daeaGFe1hpNTGTzP9PUN66RFw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b="cCPO/kVU";
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.57.43
Received: from BN8PR05CU002.outbound.protection.outlook.com (mail-eastus2azon11011043.outbound.protection.outlook.com [52.101.57.43])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF7CB606A32C;
	Mon, 16 Nov 2026 16:28:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BF7CB606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=cCPO/kVU
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=AumJUzAn7rxZ0r1Uc++IPNVBygyZs8LgxRgYZ7ecJuZo20l9+gm37sI2A9YRYL8QCSfG3UdkenQxWHPvH3gpegSuQhi3IZQBJjTXy+1qk2f+t7EAbJxRGkBBWYFK1IQ3W+izOq4hjh4nZNDb5oJauGU3pQ9hSXEGoJAjAym+eo7pz23eqOfRrSj+zJ/N/I2lyWFcfhiHMyKXjkA0uXFnGXBi0bnzFMUoZUvxRvnVwhp0gidH8VM+fkeoP8DkhynLX+Kf8ZjTseIKrpv65xZh9xwfdp4O46GwNjWv3YsTCFNqvoh34JOjISk8/Epzm6uN+v7fyLrP7wMsU2NFLsMqKA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1OwhN+sZuAa8/WZnHOStP2WKZXTwbg/QW4V7crZqO68=;
 b=pnWB2T7mRnJEH4CSCiLyDWzp1+6JG5BBPl/EKFCKW1tgA4dQswTA5xtAQafLFpaLqr824BmwRotkxLjtOAxMUE7uazb6QAi6ZQEIga/r97aqxuZtLIlNPKz/0MFZasrlPweyPU/JsF1jJbV27lSl0sSrsCfCDzrDuiJDIvWwi285k9N5MpAYz4+ErA8mMXDnbWbJYaa3haffWVBUdvFfSFMqq7F1cnw5FVm0bfawh8eUdQfy/4PHl//G2v2Wy7xa/BdgPkflpUp75moSRx1IOjhQ4BU2N6IoOGoe3CGIBvdVLocAsZLm7riilT23Nk4UeXKp5ppmMgEXcL5t6QVuJA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1OwhN+sZuAa8/WZnHOStP2WKZXTwbg/QW4V7crZqO68=;
 b=cCPO/kVUzrKh9RanPEvAk9aNWIJIcg2hIc0jes/Fe72aEy7+VC6T5t2x/Y0VOGX6Mn4WyDScBB2t4ZCNl3S50cxnvkM+gxOmtLLweSt/enYmrWl93iMEISu4pAUx0HR7/+SGqPLv8IzbmifVY2CMfowljaD2+nPHqrsNRRSEgo8v/Dz9lAsVbHfBI4VfKgl6kUo1P13FzB841+uR0bALOrwnx8l7u6QVLWWpPjqzqJ+ZlMkbKAg56eUGKMnThu7CGW4l/Wf6I2JrDqvWST0UwMU75lZkB1VEdXQfCHRZZkn6fRpNW+uHE3Lm/CMAhAHzsJKUvvPu5jVOmDqaS9ChDQ==
Received: from PH8PR15CA0002.namprd15.prod.outlook.com (2603:10b6:510:2d2::29)
 by MN2PR12MB4112.namprd12.prod.outlook.com (2603:10b6:208:19a::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.10; Mon, 16 Nov
 2026 16:28:50 +0000
Received: from PH2PEPF00048918.namprd05.prod.outlook.com
 (2603:10b6:510:2d2:cafe::15) by PH8PR15CA0002.outlook.office365.com
 (2603:10b6:510:2d2::29) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.615.14 via Frontend Transport; Mon,
 16 Nov 2026 16:28:50 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.117.160) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 PH2PEPF00048918.mail.protection.outlook.com (10.167.243.74) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.639.5 via Frontend Transport; Mon, 16 Nov 2026 16:28:50 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Mon, 16 Nov
 2026 08:28:29 -0800
Received: from [10.125.206.246] (10.126.231.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Mon, 16 Nov
 2026 08:28:25 -0800
Message-ID: <2c2246aa-9343-44a1-8174-425ef35546be@nvidia.com>
Date: Mon, 16 Nov 2026 18:28:22 +0200
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
Subject: Re: [PATCH V1 rdma-next 20/24] RDMA/mlx5: Clamp log_max_cq_sz shift
 in CQ size checks
To: Leon Romanovsky <leon@kernel.org>
CC: <jgg@ziepe.ca>, <linux-rdma@vger.kernel.org>, <netdev@vger.kernel.org>,
	<saeedm@nvidia.com>, <tariqt@nvidia.com>, <mbloch@nvidia.com>,
	<kuba@kernel.org>, <pabeni@redhat.com>, <edumazet@kernel.org>,
	<davem@davemloft.net>, <andrew+netdev@lunn.ch>, <dtatulea@nvidia.com>,
	<moshe@nvidia.com>, <maorg@nvidia.com>
References: <20261110134320.34408-1-yishaih@nvidia.com>
 <20261110134320.34408-21-yishaih@nvidia.com> <20261116093548.GE11319@unreal>
Content-Language: en-US
From: Yishai Hadas <yishaih@nvidia.com>
In-Reply-To: <20261116093548.GE11319@unreal>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH2PEPF00048918:EE_|MN2PR12MB4112:EE_
X-MS-Office365-Filtering-Correlation-Id: 573f3cba-d200-4e1c-0ee9-08df43feb23d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|376014|36860700016|23010399003|1800799024|22082099003|18002099003|261009223027099003|11063799006|4143699003|56012099006|261028144727099003|261102123227099003|261026121527099003|261026140227099003|261022105027099003|261022075727099003|261021135927099003|261021123027099003|261021121427099003|10067099003;
X-Microsoft-Antispam-Message-Info:
	mgHJQGJo1AHExJkHbucroVUdeXrKH4LYa9givqZCu3C9T8KkdUWXEMFDTCcnejd0B8kbTSDRKc7KActk4mAWuz2c2x+P/vIazNR1TG54PS6HiyBkwQ4ZFX1W2JFx3EHW6Y9HOgndhR9TUsVcTGJkOQZEvGfmF+j/d1RDz6PqvwjCPy2H7a8wuzefrnpDocYMvd+BRVNCVAfAArjE156U/rTYoM6txsXQyND1NAEOaBYX0tY5jVYsPH2OYrD4traEBZySr2f4I514QPU7r2hQCa9nKSWetByXVNWcTKCcGO0VgAcKCLjnONfRFMspWMVAQmCPljWm1Ct9QyXhQZXydGvkLQcWINaW0nTN/7bl50oQdCulpVhqCC7yhZe99XgXfCCiUSBwy8lkbBLj1+dSKjCydw/+4g29n9uQmSDIXnqULHlEgp9by2+jZjokpXM1QABE19qCvNOxukJPn5S0aWbjPD5GJSGuDDNxWlTJ2cdRVlC9tbQ2Mi5UX+3LFsicnum/Z5lLWzIdBfMnoL6KA/9XgeFCJJmwC1UoqGiSS5PDMttdgLviPcGrbLy4AK6WjhpdPcTLHftwh+A5o6waUfnd1CE+GgKNjrK17o2o57CoBAvZrLAC22/8OTxaORIMf0EVpdthro+HpGC58UgwpIx3chp7Ygppy+6GxCTpoyNMN8/NVluKdideQ8hq0kh8ZskAnCpQvD/mJbbru+dGGA==
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(376014)(36860700016)(23010399003)(1800799024)(22082099003)(18002099003)(261009223027099003)(11063799006)(4143699003)(56012099006)(261028144727099003)(261102123227099003)(261026121527099003)(261026140227099003)(261022105027099003)(261022075727099003)(261021135927099003)(261021123027099003)(261021121427099003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	rcYhjJanN25KDrDHDnGkwKld5i32MaQzO7p7xItbZNrYAFHY3C96C+ovefhe2Z1xORMAnGSbWQRrShIYRwHFCLisCmtComGf5gsvFbI7DQYPZgRrIQKEsaKKSfDqaHFxFXEqEm+jcVTKRZt2Ut2FmvStse73ymudR2/iyaxzQ/1Vr/icLgjVa9JHZfeVkBv5/48vXw5BRCEo0ic9lsz4VgHvKpuFq/u8p/+g28gUTb/npP12w+h2vhSSEHauVmgvQqo4w+Vk2usanuOfJPEV5KvAnVJmpbBURpjdpPgYVE2hfu0umXiPd/46tN4nsgUDcMYLNNNFKmnH+dwvh94OyfexCYuBVXwVoGaTmOn2HLDwowcBxBja5guOzlRkwI+psM6FQYgMkqd8dmoX77Pub8vH/NDJwFbMEPr2LBI7VjKRtYL4zab+FBApJY0gbSGB
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Nov 2026 16:28:50.0125
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 573f3cba-d200-4e1c-0ee9-08df43feb23d
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	PH2PEPF00048918.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4112

On 16/11/2026 11:35, Leon Romanovsky wrote:
> On Tue, Nov 10, 2026 at 03:43:16PM +0200, Yishai Hadas wrote:
>> The CQ create and resize paths check the requested size against
>> 1 << log_max_cq_sz. The cap is 8 bits wide, so an untrusted NIC can
>> report 31 or more, which makes the shift undefined. A large limit also
>> lets the rounded up CQ size exceed INT_MAX, and it is then truncated
>> when passed on as an int.
>>
>> Such a size also overflows the CQ buffer size, entries * cqe_size,
>> which create_cq_user() and alloc_cq_frag_buf() compute as an int. A
>> user CQ buffer smaller than the CQ the NIC is given then passes the
>> umem size check, and a kernel CQ gets a zero-sized buffer that
>> init_cq_frag_buf() writes to.
>>
>> Take the limit from MLX5_CAP_GEN_LOGSZ_U64(), round up in 64 bits, and
>> reject sizes above INT_MAX. Compute the buffer size with
>> check_mul_overflow(), as resize_user() already does.
>>
>> Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
>> ---
>>   drivers/infiniband/hw/mlx5/cq.c | 52 ++++++++++++++++++++++++---------
>>   1 file changed, 39 insertions(+), 13 deletions(-)
> 
> <...>
> 
>> +/*
>> + * Next power of 2 above entries. It can be 2^32, which doesn't fit the
>> + * unsigned long of roundup_pow_of_two() on 32-bit archs.
> 
> This is not correct. unsigned long in the kernel continue to be 64bits
> even for 32bits archs.
> 

On 32-bit archs long is 32 bits, like int, see BITS_PER_LONG [1], so
roundup_pow_of_two() can't return 2^32 there.

We can consider two options for V2:
1. Keep this helper, which rounds up in 64 bits, and reject sizes above 
INT_MAX after rounding up, as in V1.

2. Drop the helper and reject sizes above INT_MAX / 2 before rounding 
up, so roundup_pow_of_two() can be used as before:

if (attr->cqe > INT_MAX / 2)
	return -EINVAL;
entries = roundup_pow_of_two(entries + 1);

Both accept the same sizes. Which do you prefer?

[1] 
https://elixir.bootlin.com/linux/v7.4-rc1/source/include/asm-generic/bitsperlong.h#L8

Yishai
