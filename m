Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.198.70
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794838477;
	b=3nI2ES6IEuGkd/qGRDQtqNyMuyviec4wLmbVzaRVJcLiiRBQkGUa4aV1b1WYr8AN+d2y
	 CIIebne6iFN7DYY0HQDlZ6DmAbTv5aS/1T8ZGMi8D4XI3krMdqDlSGZhelG3RztZE11ct
	 r/3DrCAVLZOPEsL3YHHZO6gf0kt00nv/4f83WUwkJP5d6Hlmfd0KUqMndrKbTGoz2cCiS
	 cRoB3GgYFvVu4eV1c1rJ50ebhhNtLFa5U118cnwX4I2UPakfU+73VdaLYxGnE0meTNVM1
	 6qLCUPOL7NMcSbFvomOmQiwbyoqZLLKJkMDAlLHYwsrQaFyS3KWyfF3xv0NsD9DiO3A==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794838477;
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
	bh=5AaHEkxuOI4o8yf7EemD7QQqchrC4omjU6j/7lOvsNk=;
	b=HfDIMFPBv2R192G8nNC9Op69CPCOmAo2Sgmy3Dj+j8iOVjgPt3elC9EehPknaKw+MOJ8
	 55VRR0nQ/I8W1Q00Mv+jYGN3ca8eUqEAGLKyKyS9uxIYDA9gEgC/ik7T97UfAcPh2E90k
	 oY2vEdttpQ1sWa3Kb5vxFc/UhpPVXhQKhtK9Ju7DoZn7V9piLBPC7a7DCSMEWNSkBzEmQ
	 G28TRWTjBqhUyqk67xN26atOVQgPoMrVXcPIYUtx+Pee3kzs+rAnQAKZgvFpyC2HtUpJq
	 3k9+T+wh/1ZE4ARK4iSmC/eIrRCucLM5sNPoE3nYFQco+t3TMDp8BP9533grnCOCw+Q==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=uQNZJkqc;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.198.70
Received: from CY7PR03CU001.outbound.protection.outlook.com (mail-westcentralusazon11010070.outbound.protection.outlook.com [40.93.198.70])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EE9B606A329;
	Mon, 16 Nov 2026 14:14:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9EE9B606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=uQNZJkqc
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Cwi1KJnzjALmnufRRh82qgdgHKcbJbuENN/+IL7TLY1Iq9odzxxB1eJ83u63GjCAvVvw+deIxLSACOLEVjnR4Rim6cUzJqWC3i9ZBe3m9GYn8z48+fj11kufpFa/gVeKp/X6NtDcyioBQs8MKIeKtIve3mA5PJYrmyla4EQSPX71N/flfGIaC2BcxVcz2M2hdiWqMAG2599WPaBfOT038Xz0lox8815+wCnYaYqw6B5fZhimkGPprHfALWKAj6Zo8K+XTQXcf2glDRNUCSL3M0339yuGRn1gLaPAveaooPxJSTUJ6QLvb8HH/IBMqHIJt3imSktGaHXn3RPnXfLQVw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5AaHEkxuOI4o8yf7EemD7QQqchrC4omjU6j/7lOvsNk=;
 b=rSC9SDB5hcYo99qcKPhijewUl9G96+jeKogrPgCMy3MmHAMQKDvdheLDIQFh3HbkNFds+aG02fs0guE34JG23cKIt/pjjq+6QEPak2AMGtMcrORoaZHN1JPShp5ICABoNFDL9bQmQ8T/VeTNv2n9KVfCBXmZanwNMZQmnqQcKhKwJzmWVgkYjYCnsE2qNaqGX0BLiWHnYc1QLWDPOkyyuyqm/DVUcY3TSuQ4dTiy8MULYrSKTkrG2rse/iCzmwfOgmkPvoTNlZXCiBFMHTg5vAqGxQLB1+PpB3o3pSX0xqgoHgbTQ4xm3Iq8KVONG6ZLPWRbcENEfP/wb80OTw3FKA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5AaHEkxuOI4o8yf7EemD7QQqchrC4omjU6j/7lOvsNk=;
 b=uQNZJkqcwShsOoKiESFrHTKISXXS9PHm4XsVAJRmlYMHGGIyy80PRCRbpTisO1Dt0FAyY528TlzmFiQ7f5IFCE9tpBGlnkb+ZYW4VDpzq8ClIyRrLpHWne4ZOgvM0OcqB2ybX0SjFFmqI1nTlYwJ38VF/BATunItfdttqqoWGQ45yuWBuhBrZWqJMj/PZ/HR0bF/d9SWnzrY6HSc9+o/YPPeDcJnSkFm1aziBOxcs8pl34E1joyUE3o9LOG3uYw4XQiKqzIj1ZiOIX3cuJaXibEP51NVnKLrVuhRVeHWpz29RJAQhhRG55b8dKRuX3/KCmltZXkq/wggO6qbbkUn8g==
Received: from SJ0PR03CA0294.namprd03.prod.outlook.com (2603:10b6:a03:39e::29)
 by SA3PR12MB095375.namprd12.prod.outlook.com (2603:10b6:806:514::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.14; Mon, 16 Nov
 2026 14:13:32 +0000
Received: from CO1PEPF00018860.namprd02.prod.outlook.com
 (2603:10b6:a03:39e:cafe::6) by SJ0PR03CA0294.outlook.office365.com
 (2603:10b6:a03:39e::29) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.615.14 via Frontend Transport; Mon,
 16 Nov 2026 14:13:31 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.117.161) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CO1PEPF00018860.mail.protection.outlook.com (10.167.249.249) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.615.4 via Frontend Transport; Mon, 16 Nov 2026 14:13:31 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Mon, 16 Nov
 2026 06:13:03 -0800
Received: from [10.125.206.246] (10.126.231.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Mon, 16 Nov
 2026 06:12:58 -0800
Message-ID: <759c8f05-a018-4040-a791-fef794eb6933@nvidia.com>
Date: Mon, 16 Nov 2026 16:12:55 +0200
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
Subject: Re: [PATCH V1 rdma-next 08/24] RDMA/mlx5: Derive
 mlx5_ib_adversarial_mode global from mlx5_core adversarial API
To: Leon Romanovsky <leon@kernel.org>
CC: <jgg@ziepe.ca>, <linux-rdma@vger.kernel.org>, <netdev@vger.kernel.org>,
	<saeedm@nvidia.com>, <tariqt@nvidia.com>, <mbloch@nvidia.com>,
	<kuba@kernel.org>, <pabeni@redhat.com>, <edumazet@kernel.org>,
	<davem@davemloft.net>, <andrew+netdev@lunn.ch>, <dtatulea@nvidia.com>,
	<moshe@nvidia.com>, <maorg@nvidia.com>
References: <20261110134320.34408-1-yishaih@nvidia.com>
 <20261110134320.34408-9-yishaih@nvidia.com> <20261116085701.GA11319@unreal>
Content-Language: en-US
From: Yishai Hadas <yishaih@nvidia.com>
In-Reply-To: <20261116085701.GA11319@unreal>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PEPF00018860:EE_|SA3PR12MB095375:EE_
X-MS-Office365-Filtering-Correlation-Id: 621ea53c-c155-4826-4dcd-08df43ebcb63
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|23010399003|82310400026|36860700016|10067099003|4143699003|11063799006|56012099006|261026121527099003|261026140227099003|261028144727099003|261022105027099003|261021121427099003|261102123227099003|261009223027099003|22082099003|18002099003|6133799003;
X-Microsoft-Antispam-Message-Info:
	3jwDvTZKoumajzLgYD4byG44Ak0B+kyMOuiT/pUuJksTPRNN+UOgfDdiMuO14V0KWfKYqMrtVe8T1F7NPmoNqStWgI1EBCx4oI1XaQjrqG4BgBcDtX2ZPvFkF+Z5/XL5PM4rKB5lFXG3XYiWh9y4x2OhQuPzNxT/jrr8PmmldJHGpS0BVSknAVA3SxL6UXbWMbvSqOekamLNVebjM0AMLIwFRuv0w/cgVpT/1XIvTLiUynOW0Mmv7nQ2U2jrSOURYpRk5a4bJk1kjdRNYezf5HmlfJqM2D2Bo6epoGtMmzHwNBGL7ZxZSsYSDEwEWpFBeicvN9EAIFDRxQ1masTeqxWAFo+lXdMNXPViwdnkgEoimUIJ4HAM+ocjx4j1PDNuWR7U1/wE77qI+L6Y/RFjUnoLx6BKzr+iarfNbvzvXWdJf9GCMgYdfCnY6egaDrHVQ+SMCgdXKNZAm5OwAJiC1+6SfCb/A2rGtYYZH8498Si2KUmgPGE8ad2w/bV7VGd7QpS8w+pzncoZdf5ryMKVzJqHM+U5Qmcdr5QHcUmZ1DMCbStoeBIPY7kcDhj7ShX1hhGUnMcp3yLGR6ftbCKo0olUI40mR64wQiwk8JqiOdVqtEgdwbZBpKuDQuBxbk7Fs+SHxrcJqp8E+1WyL8jtIlUAeKV+FRSRajXD0YYDS2UYx8rFbTUgJbA1eQrCaJ7RKLFcp5ZRaQpxGe9I38aBIw==
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(1800799024)(23010399003)(82310400026)(36860700016)(10067099003)(4143699003)(11063799006)(56012099006)(261026121527099003)(261026140227099003)(261028144727099003)(261022105027099003)(261021121427099003)(261102123227099003)(261009223027099003)(22082099003)(18002099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	cKwi+dBkX5LR4sqGwUJCaVziaKlVfDAJXHYZaCLw3ELfD3VQydgMEiUI+5G+697ry4idvh1Rod2YY4DPPMxQlpD1OR1QkjS1013CxUaa6AFmqudDn+dZdSbl+dAfPtmNjjuuK7m3ZwAgbDx9gSQkC1KWQ0uZ7ipL4dxEYMzqa2OKaHPpvyswqDaRo2CLSnuAGIE3zLKAG11Zd8lvTDaVegeOiv+B9QlD14oIdmKUboSDlbkJRLeZ40SsIoFfF4PweS+ogipfpN5MFkL3wlNPOoqni7g3kqJKTrOFKOriSjBpxHpl2KKsMXDAnrpnuxCAAfgCpDXQrZZyRXdK5N9EczTb8RiWWmU4TX7o2VXHneUo6wX5kn5HVttkDOa2MNxBEKcwCsKbrNuq5OpyI219PWPWe8ZUSYiczHGqkSgVfN8tTheM3pZQqIXTt1z4TpbL
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Nov 2026 14:13:31.7593
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 621ea53c-c155-4826-4dcd-08df43ebcb63
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF00018860.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR12MB095375

On 16/11/2026 10:57, Leon Romanovsky wrote:
> On Tue, Nov 10, 2026 at 03:43:04PM +0200, Yishai Hadas wrote:
>> Cache mlx5_is_adversarial() in a driver-wide mlx5_ib_adversarial_mode
>> in mlx5_ib_init(), shared through mlx5_ib.h. The mode is the same for
>> all devices, so a global avoids reading it through every mlx5_ib_dev
>> and keeps the checks at the call sites simple.
> 
> This patch and description makes no sense. The mlx5_is_adversarial() is
> simple static pre-compiled branch "cc_platform_has(CC_ATTR_GUEST_MEM_ENCRYPT)".
> 

cc_platform_has() is a function call, not a static branch. The wrapper 
keeps the policy of when mlx5 runs in adversarial mode in one place,
used by both mlx5_core and mlx5_ib. Anyway, in V2 mlx5_ib calls it once
per device at init, see below.

>>
>> Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
>> ---
>>   drivers/infiniband/hw/mlx5/main.c    | 3 +++
>>   drivers/infiniband/hw/mlx5/mlx5_ib.h | 1 +
>>   2 files changed, 4 insertions(+)
>>
>> diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
>> index 65455aedd559..f4f2ad80e76c 100644
>> --- a/drivers/infiniband/hw/mlx5/main.c
>> +++ b/drivers/infiniband/hw/mlx5/main.c
>> @@ -76,6 +76,7 @@ enum {
>>   	MLX5_ATOMIC_SIZE_QP_8BYTES = 1 << 3,
>>   };
>>   
>> +bool mlx5_ib_adversarial_mode;
> 
> It is not kernel style to throw random global values to cache existing
> in-kernel API functions.
> 

OK. In V2 there is no global flag in mlx5_ib anymore. This patch is
replaced by one that sets ib_device::adversarial_mode once per device,
and the checks read that field. Patch #24, which set it at the end of
the series, is folded into it.

Yishai
