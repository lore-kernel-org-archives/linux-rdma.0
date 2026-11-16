Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.208.54
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794838514;
	b=1HOnJV/uhFnorAnMa1XmEn6+R77xZ6ZKg5h/+TDXXHY8Yvx9EwVLuyi7H55e28L+YJgp
	 S7tU7RFxw3moa6oojAnNXIYzM3gcuTGhN9ARazzz/mYvX8DnUnc68aUbQwU/E9Bz0hKIs
	 tPirkYVgwWEH03z2c/ZdpqDGFSN8nWAUBrmOmNCXyYQfY6Sd0HFABkAVpJZq/1XRtB4kE
	 5fDlic/yuU8q5jlwYDivNpnYPksgjmFcT18alnnTrwWz6wEecLq2Cz4x6ChGCFqkVed8Z
	 cLJD7lqCgjMyViViamqtp5ikdKW+fhyAAtJvbFMtz5QzSh+h2ZqqoqhGE9m9q3Fx+uQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794838514;
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
	bh=esU+9M5lmWsiO2RMzEpPxchhEM1GnUPI9jgGUtm9voM=;
	b=FUd7+/E0QeZvKrmPezsdwXs3nJ1Ib8I6HV/LULiwCzO2NgJhe3DYJF/psuu6vIwJjobB
	 NONZ7Z7jbVtlDspolY9bhKECZNGhYP2EF+nXohsRX6xiRXqHzCRtGWY+bkufnwhf83Arj
	 uYB+sQPv2s9BpEAnjqCqPmRAN51gf9KFkW2Cw7UdKJEHZi6hqfLi+qb3Y7tZW9uFiaQ2N
	 wHShQ0c8vFJQ+JqMdatwxjiatnEIwPcQSGEhES03IIuCjmJV+hCke9ZYYNdQYgTPWLc4X
	 ToZfNcu7wWs2O8obGcBejrj+4cpD1MK1cls11N++dYKweBui5CstuKd+ShrrCQ4w7aQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=O7MV+yQJ;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.208.54
Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azon11011054.outbound.protection.outlook.com [40.107.208.54])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAB06606A885;
	Mon, 16 Nov 2026 14:15:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DAB06606A885
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=O7MV+yQJ
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KkvbleFpeyqheiX1PEx1jtjgDELWRsW47vsbAIWYgfQzd6YRZ5B5jb58hi0/AF5HfB0gLLa+tr108URW1EOh1fIhoEpOqiiV3EanCWhAvfUEYTypE985fn0G6/mlOJGJwfhNJ7hTxpwj6lmo0a371ZILwZ+3XLRKqwpAxmVMJ1qUOuhagbEM3vososyBd9bQtl7Slrm3M98CwnNq75jvoXoZe/SMgEmE90iLhkgFPBMJ9FgOTTYYFDeX/gWT9Mfkj2XquAsel7yQcoOZNJtG9cqJBOMbX4QNcTNjz85ixXX6dKRFPD4//aLbQGlSHEDvpAbPGgO/wEcyuQLuaqRAKQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=esU+9M5lmWsiO2RMzEpPxchhEM1GnUPI9jgGUtm9voM=;
 b=AXMRMZIfg1xyBWmdrzalieUEXM6M/AH62qwx7h25dkMy8GXG6aEYmrVT4EwBIL6g0OgFb2N1yN3oUoUMJ6JGP7EHM5QV8YPWH/Ar7Bf7LGOyh3qtPA8kdAegnZ2992NIaOpUSYLItNI3MmklkwJj2TyoVG1ImXJAaiuHsLNtPlC21rU9z7jFI45UzWOgb5M8OWQvXZ4UxjlQ81wTiuEh8DrlA/nX2PjagECzq78stIZHH8GSHAYigg7b81DYpOnqaMm6FADA429Lyv6ix77UxYYeRaIYnSTNHs27lqC7IpkqfnsG7w7h8hZMYNZkCm+RBwfIdfcUjxesja4WhL29lA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=esU+9M5lmWsiO2RMzEpPxchhEM1GnUPI9jgGUtm9voM=;
 b=O7MV+yQJvqZn5GifZ8sHO5CpFKRZIlXXgDkToO2TdORdd7aX+vhjI48DTvmNvY++OdBmXpcMU4teTSyrzDN1qgB9JTaDustkgDR85AAfDX96NMezYhJdxpv1U8uxSVpmTBU0YAaplOsjA3PC4J+zt5VSX0VcJEWtzyhwU8VnjWKv2LJj4C9ycCXEb6sVS5y4LLVcch5/EE/P6BWEyRqvhKg6NfNxJCOJ5wPiATtwMVmeiiS9/EQDNMarFjo2rRtm1ZkVTxfYuDnG7mM3s7Z2gdFAfm0UpVkEehd2kWgsd3sPnMUb4j9Miyn9vLi9iHzcSrc//dpWlvoI/WrLSyWiFA==
Received: from MW4PR03CA0339.namprd03.prod.outlook.com (2603:10b6:303:dc::14)
 by SA1PR12MB9545.namprd12.prod.outlook.com (2603:10b6:806:45b::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.9; Mon, 16 Nov
 2026 14:15:09 +0000
Received: from CO1PEPF0001885E.namprd02.prod.outlook.com
 (2603:10b6:303:dc:cafe::93) by MW4PR03CA0339.outlook.office365.com
 (2603:10b6:303:dc::14) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.615.13 via Frontend Transport; Mon,
 16 Nov 2026 14:15:09 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.117.161) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CO1PEPF0001885E.mail.protection.outlook.com (10.167.249.247) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.615.4 via Frontend Transport; Mon, 16 Nov 2026 14:15:09 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Mon, 16 Nov
 2026 06:14:51 -0800
Received: from [10.125.206.246] (10.126.231.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Mon, 16 Nov
 2026 06:14:47 -0800
Message-ID: <846e2194-8c5d-4fb1-93ea-be7a981ca6dc@nvidia.com>
Date: Mon, 16 Nov 2026 16:14:44 +0200
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
Subject: Re: [PATCH V1 rdma-next 09/24] RDMA/core: Suppress kverbs_provider
 for adversarial_mode devices
To: Leon Romanovsky <leon@kernel.org>
CC: <jgg@ziepe.ca>, <linux-rdma@vger.kernel.org>, <netdev@vger.kernel.org>,
	<saeedm@nvidia.com>, <tariqt@nvidia.com>, <mbloch@nvidia.com>,
	<kuba@kernel.org>, <pabeni@redhat.com>, <edumazet@kernel.org>,
	<davem@davemloft.net>, <andrew+netdev@lunn.ch>, <dtatulea@nvidia.com>,
	<moshe@nvidia.com>, <maorg@nvidia.com>
References: <20261110134320.34408-1-yishaih@nvidia.com>
 <20261110134320.34408-10-yishaih@nvidia.com> <20261116085817.GB11319@unreal>
Content-Language: en-US
From: Yishai Hadas <yishaih@nvidia.com>
In-Reply-To: <20261116085817.GB11319@unreal>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PEPF0001885E:EE_|SA1PR12MB9545:EE_
X-MS-Office365-Filtering-Correlation-Id: 510e4c8a-1ae2-4807-e5a6-08df43ec0579
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|376014|23010399003|1800799024|36860700016|22082099003|18002099003|4143699003|261022105027099003|11063799006|261028144727099003|261021121427099003|261102123227099003|261021135927099003|261009223027099003|56012099006|261009221227099003|261026140227099003|10067099003;
X-Microsoft-Antispam-Message-Info:
	5rEsSbWN3mjHNyvEXJExwiJwsAk9C+pB3YSv4KQbvaU3KQI4Y9Zk/MsH5YprGViN2+YNfIqVRYRikBHsvDKUV2stjpb1raO9ixQq6vA+RxXKoQmnis0FTST56Ttv13hDl4BsQYSITDVyvxOxq6sGgoyHqE0LEcgrNfSv+zSYvqLxYbiKuNmampffIk0KgxZR4km47oXmvVWixe9xeHUI1XPx9dF2RcvHTK5T7rNs9D4JxNk0aE3nbhXr4EO9lWwoLQ+eQB0+DViUPpTnm2wriiioOI3UC8j3hvrA/qAKQ85//4GtP9JML3kQLs1dq+VMoca7fsVE8HZOmDNZ3OkwGcErTrrS+ZiNmhEI7s7M7p4eTSbpqGkX3kHqWLX1cf1l6QXl2/VzaQx4iuZB93W5kP/gBNPAcHhSoouTlqwT70cOHZoAXLFFl23L860xfMlT6A9GgATrzDfyqffBDXExFyqow/kk0MK1w7BtI3d07qs0AdjkShQuj/9h18lQJB8HSeV1EHwJQz7xyAk/pRKPmz2PqC+HxbRmiiIslXdKRJZHKW3JZkxqPiwiM5tOshnEIWYa3NDaRVYeL//Ejk8vkTNkZeJ9MWWgrbIdkuYLpNSTmWWFmpU62yDByI8UE8Yq3KVYVoKwqLrTHPDQAzTJSMahudCm8K6La6zbS3/NWrMm2nLYBmJcTAKPGoywePpkIbPj9S0ToGJziCfAdGplTw==
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(376014)(23010399003)(1800799024)(36860700016)(22082099003)(18002099003)(4143699003)(261022105027099003)(11063799006)(261028144727099003)(261021121427099003)(261102123227099003)(261021135927099003)(261009223027099003)(56012099006)(261009221227099003)(261026140227099003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	hbJE/y04fQT5b4B9t6/PivyqL/g2Eu7Wnp9PQf8LuqwyUBf8TyBsSNY+R0oyvGBzpn0Q9KKX12GDtulWAFfuHS+HnAvp4TlJDWD6FJhPbFJi3lhuee8bgZUS4fxxNi5/VUD3v2FbzT3MDaFpikidvNY8/hcWdbGs+Ya4JT5WmaOQ/Sn/zWWiygxsIER1H+94vGfju/9I7OR3PSt55BIJapazLwfwL+yM1pvwUxG3kv1mv6ojg149ScoXx40L88XQXdkzW6s5kOzUs/Ig/9GzJ8GQvKrpiJ4QW7QjionjLuuO/TLP8o6+9pzZ8C5kUq5TisDq1OPAJwBrrJoOjHMk5aKLV7KOWhXK6M/dG7ca+gcWaMRuiYtzlierPT9hs8Q99jeXa90tiBsGb8SBfbagxckX/1jDt/xm2B9iBJFYRpHt8X0rl2JXTdP3y3o1+wWJ
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Nov 2026 14:15:09.2021
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 510e4c8a-1ae2-4807-e5a6-08df43ec0579
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF0001885E.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB9545

On 16/11/2026 10:58, Leon Romanovsky wrote:
> On Tue, Nov 10, 2026 at 03:43:05PM +0200, Yishai Hadas wrote:
>> In adversarial mode the NIC is not trusted. Kernel ULPs such as MAD,
>> IB CM, rdma_cm, IPoIB, SRP, iSER and NVMe-oF trust what the device
>> reports, its completions and the data it writes, so they must not use
>> such a device.
>>
>> Add an adversarial_mode field to struct ib_device and clear
>> kverbs_provider when it is set. add_client_context() then skips every
>> client but uverbs, the only one that sets no_kverbs_req, so the kernel
>> ULPs never bind to the device.
>>
>> The driver still implements the kverbs ops, as the uverbs path shares
>> them, so kverbs_provider can't be cleared by the existing check of the
>> mandatory ops.
>>
>> Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
>> ---
>>   drivers/infiniband/core/device.c | 8 ++++++++
>>   include/rdma/ib_verbs.h          | 2 ++
>>   2 files changed, 10 insertions(+)
>>
>> diff --git a/drivers/infiniband/core/device.c b/drivers/infiniband/core/device.c
>> index 29af9fe860e2..eb6aa567d365 100644
>> --- a/drivers/infiniband/core/device.c
>> +++ b/drivers/infiniband/core/device.c
>> @@ -312,6 +312,14 @@ static void ib_device_check_mandatory(struct ib_device *device)
>>   			break;
>>   		}
>>   	}
>> +
>> +	/*
>> +	 * Kernel ULPs must not bind to an adversarial_mode device. Its kverbs
>> +	 * ops are still present, as uverbs uses them, so clear kverbs_provider
>> +	 * explicitly. uverbs sets no_kverbs_req, so it still binds.
>> +	 */
>> +	if (device->adversarial_mode)
> 
> In previous patch, you talked that adversarial is global for all
> devices, but here you add per-device flag.
> 
Right, in V2 there is only the per-device flag, see my reply on patch #8.

Yishai
