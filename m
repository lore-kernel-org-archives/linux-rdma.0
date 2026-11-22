Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.198.28
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795340048;
	b=Is9VuJk6lCY636LjB769sybDu7FNYtWOvFVcvn2cy7Zy4fa7WqQqomDCJHScxijW5mgR
	 3B0FlUNnnfh0gb4T5EsTiV1GhcM3akUd+eRdfNUZwQlf+VP01/PhQr7RRVIoGRpNtuiVl
	 hnUp7ySxLpjLTFIg1qNM3vxDTdn3iPgQ4gUF3ZgSaBZcxZKtiZ4FoCTYspWICl3alCvrx
	 9UEn13eBYRnIiwuhe1bt176y8KXhnIKMowWg2xh3yjG45Y58ePasyJbHzfvGFKKTsjxXd
	 PULugvoOEFiFC5JlKkGCjNprEkW0rS46PenKTglXahqsjSq0eyNboZPc9CjFiQVZffw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795340048;
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
	bh=TP4RfFb9O6ILLc+88MdHXEYF/nFewlsBoTQjqvVWbIg=;
	b=zUfDzMSi5WnilxiERnNp4y6KEdAYrVuj7aOyI9aEF+9wZ8t5huJXwUNPp/U2j3YwSPpl
	 ODGlSx/FmxHTHTgU/blP3b2IFU/7v0KEKV0LqL5cTrraczFN7wQXt3f7ecwM7L0Bk0ZFi
	 hRowd/3bErVUUv24eHSdyyoYFUXthYQoWNdOPSkW7wmxhGAf+Trr9qIHrOw/P2LwZipsF
	 YJmKuMa40MQLqk1d/omkRC1/b8W7G02hp5E6VoIYgnENoE1a3NYfp01m+8oPXcAOy66Tz
	 EvnVIY9p/AFYOxc3sILM1YWQY2RroTzHrpdwuX10r9DWiHeoAW8PZ3IjYQjcrBr5TGw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=iTvzrmIp;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.198.28
Received: from CY7PR03CU001.outbound.protection.outlook.com (mail-westcentralusazon11010028.outbound.protection.outlook.com [40.93.198.28])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 290B6606A320;
	Sun, 22 Nov 2026 09:34:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 290B6606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=iTvzrmIp
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Y9NqJhrrN1wqQs4dzncseEyr1sGQ2eSUt4C4aEOz+zSaNHnU2lZQKtERCAOYqU3V55FKJuTCrHLQzjavYBbK/WD/m52JmWMn69+xeJ7jTSU9vW1M3OmavTX97fRGEgj9liR+yX89TLbC697UKQed+zJ9Xa1I7yir4qBLuYKTzkQdz7wnHDgEXpXE/0SqZghKSWGimxk5yGJCqE4EsduceSQf37LoIvShC22GpvUxmW8HIp8z0zN44c4QnQxsEZ2jUTlIoL6OtlxWSpuCmfWjoR+6RQ2IEjDy2x+PyyJsy6cInXJF/hdOIFD+dYOW3X1J8BUmo039IF1ZQhx5D+PflA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TP4RfFb9O6ILLc+88MdHXEYF/nFewlsBoTQjqvVWbIg=;
 b=U9avVX+/eqKvu73zsPf0i1hZr1LDNu0nJzdn3+/JqwH6H64+pxm0EvrhrIzESU5ptduSMh01xGPvqOy9K84haojzWRs0F7jgOFnPsZzpfQ8cgUZzXCf6hJI48rdb/O0fKw9NiaqiRPmxA0ttV2JNINCzRdW0DdBzNAG3F3D4NOmk10jwd9o0FRAsqcgoY3ig4mXvgEUqz9WkwsyOrVfbbcHyQ5ztfYinjRBAUC/v4fIW/8m4xMXhCkL0QM5en6oV8EqXvo8i42ZDR3GZWM6tx2INrTdhXctKJqZ1Uvw1sO2wvNvmGdkcHmaHcTQsKDbP5x+pjzUCJc+xoDoVHRUzcg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TP4RfFb9O6ILLc+88MdHXEYF/nFewlsBoTQjqvVWbIg=;
 b=iTvzrmIpsC1eNpnzgXtN5dvaE4pgvPBNXNIGd2JmbidsTK0oQl6mkhNjXTtbWIsU9dwv1q6M1flNBXBwphINTbjC826OylbQB8zH7bOElvF2frAcXGBT6npaiuYYalkXTDN2jD3E0WfRTrDWELEz9bXoUn+B0i17Dral/pmtpTZXV36RYKohj3mlqnpQKMT2Oum4sQR6iTUJlV6HfytZfn62x/mHH7dLbEvKg3RspRX0swPuxkkOXxLdAYRUvko04JaeQzmHhZ4byMAi0j0LRO3+tW/Z5JEkg5dR25oGTAknV2ciQplvNXUZ/d+bhBfOMy0GNb2uQMl4blA4fTdPyA==
Received: from SJ0PR05CA0195.namprd05.prod.outlook.com (2603:10b6:a03:330::20)
 by IA0PPFFEC453979.namprd12.prod.outlook.com (2603:10b6:20f:fc04::beb) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.639.10; Sun, 22 Nov
 2026 09:34:01 +0000
Received: from SJ1PEPF000026C3.namprd04.prod.outlook.com
 (2603:10b6:a03:330:cafe::a3) by SJ0PR05CA0195.outlook.office365.com
 (2603:10b6:a03:330::20) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.639.0 via Frontend Transport; Sun, 22
 Nov 2026 09:34:01 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.117.161) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 SJ1PEPF000026C3.mail.protection.outlook.com (10.167.244.100) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.639.5 via Frontend Transport; Sun, 22 Nov 2026 09:34:01 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.57; Sun, 22 Nov
 2026 01:33:51 -0800
Received: from [10.125.206.246] (10.126.230.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.57; Sun, 22 Nov
 2026 01:33:47 -0800
Message-ID: <761ca80e-a772-41f3-b8e9-cc332e4ba5d9@nvidia.com>
Date: Sun, 22 Nov 2026 11:33:44 +0200
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
Subject: Re: [PATCH V2 rdma-next 21/21] RDMA/core: Report and enforce
 adversarial mode via GET_CONTEXT
To: Leon Romanovsky <leon@kernel.org>
CC: <jgg@ziepe.ca>, <linux-rdma@vger.kernel.org>, <netdev@vger.kernel.org>,
	<saeedm@nvidia.com>, <tariqt@nvidia.com>, <mbloch@nvidia.com>,
	<kuba@kernel.org>, <pabeni@redhat.com>, <edumazet@kernel.org>,
	<davem@davemloft.net>, <andrew+netdev@lunn.ch>, <dtatulea@nvidia.com>,
	<moshe@nvidia.com>, <maorg@nvidia.com>
References: <20261117170914.27410-1-yishaih@nvidia.com>
 <20261117170914.27410-22-yishaih@nvidia.com> <20261122073156.GA12665@unreal>
Content-Language: en-US
From: Yishai Hadas <yishaih@nvidia.com>
In-Reply-To: <20261122073156.GA12665@unreal>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PEPF000026C3:EE_|IA0PPFFEC453979:EE_
X-MS-Office365-Filtering-Correlation-Id: 97123eb0-3517-4fe1-9404-08df487bbdc6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|36860700016|23010399003|1800799024|82310400026|10067099003|4143699003|11063799006|56012099006|261021121427099003|261021135927099003|261009223027099003|261102123227099003|261022105027099003|261028144727099003|261026121527099003|261026140227099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	XDAXsmEzzXJ9IS92c4ig0O9cCS+czgbJ2njez7MdECcFYW0kWWQmAc9i6XMnhc02Xxt/mzQ/JhmG2Y9RhC2+8X/maffCJyRt0eEBvwJ3R1ULxC+yZp0TiE0ne4HN2ntVIC3qMoq1fKo6gmgfuVe2nPVXj7F7/jfduEA53IwTGYiRoaRYEpt1YlN95YVpJX4ExY64YDCVeHqKDeyJdiChpaXH1Lc1TeDVrRE6r8eTmKGWCA/tvkw5UcTp7QBnEgJmAhUvCtpAmZH+No5u1mafaBBkDPYN+JHtTdp51bWy+wjaQnw9wKKagxbfGuDye3TyTxO/lBBdXXcE7yGlIQmiHYwcTliwMIdi7auu0p1on9417Zw3iZKsEGhOuDJVz0Qwg0nu2wnYaNOvGtfcA2OKhEGVDCU8iEK1vvm8TVaZL7Xu9Zw1kdybiL2VCjSpyuqNBxFM/FLQJIKxCBfIVze5vAt2sRQn/km6RDMg3TOO8yz0SWt2iQrZVoH0vAapyPuHEtl25nG2hd0fslH1ebz5hOzU6un3QDjYZkg5J2S7NCDh+SJQEII0SqzaBR2kTx9LxvbMPHOP6+Pbg3Vox6m4ljllsTUsqwN8fPTZydzxt2r6OM0Knqi4is3QJBREXSfd2e7mI8yQPZczbc5w6agD1jRgyB/h/Q43rG7ASvZHffjcM6srh8dvLOBdpJoE7Pijd7wK1ZFGGK+gdPd2w7Wifg==
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(36860700016)(23010399003)(1800799024)(82310400026)(10067099003)(4143699003)(11063799006)(56012099006)(261021121427099003)(261021135927099003)(261009223027099003)(261102123227099003)(261022105027099003)(261028144727099003)(261026121527099003)(261026140227099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	qkl2wyio+t3si8yL7izaQrt2dli8T5tP+oiHZy0A+CnKgQtsoQQyHRrykbKzbag7WbHb3y2bxh7Om+2WxjIaaQUIu6tD0BK3n+S1DToBwuul8VR2i64rsAqW05+a4fZ4dwMhGxlzpUAUe6V2B7nGSvm9LJiifs2KG2ZxhJMo1JEMAZFxBTRN0ghlrmHwWUvHpRfXONK0EHoHvyowm9Q+ungHKnPfugEFXwbBRnimmpRmINaRcFxI8L3jJnI8zo+TTTatp7p4ha0D9nHReKUeqomZl/ExpOsdKQc9xUmOYDFf4Y4pQpJBz5Aae31m38V4wbCzaxc5juQK6c5BqIVSl1GcVKFMY/Kql6sf3efP4i9XzeW5LwtdIbWXkroP1wNdalaJ9gTU4lJHG2NeztiJyohoYk2HUF0lt6F75Jd6wybCNRYfeRK1OhdaFBXxgaiP
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Nov 2026 09:34:01.1621
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 97123eb0-3517-4fe1-9404-08df487bbdc6
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF000026C3.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PPFFEC453979

On 22/11/2026 9:31, Leon Romanovsky wrote:
> On Tue, Nov 17, 2026 at 07:09:14PM +0200, Yishai Hadas wrote:
>> Userspace must know when a device is in adversarial mode, and an
>> unaware rdma-core must not get a context on such a device, as it
>> doesn't harden itself against the NIC.
> 
> Why is this a “must”? If it is required, please describe in the commit
> message the scenario that cannot be supported without this new UAPI flag.
> 

User space must protect itself from an untrusted NIC, as the kernel
does. Hardening has a cost, so user space must know when to apply it,
and unhardened user space must not run on such a device.

More details are in the suggested commit message below.

>>
>> Report the mode with IB_UVERBS_CORE_SUPPORT_ADVERSARIAL in the
>> core_support of GET_CONTEXT and QUERY_CONTEXT. Add an optional
>> UVERBS_ATTR_GET_CONTEXT_FLAGS input, where userspace declares
>> UVERBS_ATTR_GET_CONTEXT_FLAG_ADVERSARIAL_SUPPORTED. In adversarial
>> mode, GET_CONTEXT without that flag fails with -EPERM, and so does the
>> legacy write() GET_CONTEXT, which has no way to pass it.
> 
> The above is AI generated useless information, completely useless.
> 

Sure, it's dropped in the suggested commit message below.

If no V3 is needed, could you please replace the commit message with 
this one when applying?

RDMA/core: Report and enforce adversarial mode via GET_CONTEXT

In adversarial mode the NIC is not trusted. As the kernel protects its
own code from it, user space has to protect its own area, e.g. the data
path that polls CQEs directly from the HW.

Hardened user space might use a different data path, with extra checks,
and support a smaller surface. This isn't needed for a trusted NIC, so 
user space must know when a device is in adversarial mode.

Add a GET_CONTEXT handshake. User space that supports adversarial mode
declares it, and the kernel reports the mode back, so user space moves
to the hardened mode. If user space doesn't declare it, GET_CONTEXT
fails with -EPERM on a device in adversarial mode. This prevents 
unhardened user space from running on such a device.

Yishai

> 
>>
>> Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
>> ---
>>   drivers/infiniband/core/uverbs_cmd.c             |  5 +++++
>>   .../infiniband/core/uverbs_std_types_device.c    | 16 ++++++++++++++++
>>   include/uapi/rdma/ib_user_ioctl_cmds.h           |  5 +++++
>>   include/uapi/rdma/ib_user_ioctl_verbs.h          |  1 +
>>   4 files changed, 27 insertions(+)
>>
>> diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
>> index aca7c6ab55cd..b78207a81091 100644
>> --- a/drivers/infiniband/core/uverbs_cmd.c
>> +++ b/drivers/infiniband/core/uverbs_cmd.c
>> @@ -292,6 +292,11 @@ static int ib_uverbs_get_context(struct uverbs_attr_bundle *attrs)
>>   		goto err_ucontext;
>>   	}
>>   
>> +	if (ib_dev->adversarial_mode) {
>> +		ret = -EPERM;
>> +		goto err_uobj;
>> +	}
>> +
>>   	resp = (struct ib_uverbs_get_context_resp){
>>   		.num_comp_vectors = attrs->ufile->device->num_comp_vectors,
>>   		.async_fd = uobj->id,
>> diff --git a/drivers/infiniband/core/uverbs_std_types_device.c b/drivers/infiniband/core/uverbs_std_types_device.c
>> index db65032e80b4..72c67f09533e 100644
>> --- a/drivers/infiniband/core/uverbs_std_types_device.c
>> +++ b/drivers/infiniband/core/uverbs_std_types_device.c
>> @@ -248,6 +248,7 @@ static int UVERBS_HANDLER(UVERBS_METHOD_GET_CONTEXT)(
>>   	u32 num_comp = attrs->ufile->device->num_comp_vectors;
>>   	u64 core_support = IB_UVERBS_CORE_SUPPORT_OPTIONAL_MR_ACCESS;
>>   	struct ib_device *ib_dev;
>> +	u32 ctx_flags;
>>   	int ret;
>>   
>>   	ib_dev = srcu_dereference(attrs->ufile->device->ib_dev,
>> @@ -255,6 +256,15 @@ static int UVERBS_HANDLER(UVERBS_METHOD_GET_CONTEXT)(
>>   	if (!ib_dev)
>>   		return -EIO;
>>   
>> +	ret = uverbs_get_flags32(&ctx_flags, attrs, UVERBS_ATTR_GET_CONTEXT_FLAGS,
>> +				 UVERBS_ATTR_GET_CONTEXT_FLAG_ADVERSARIAL_SUPPORTED);
>> +	if (ret)
>> +		return ret;
>> +
>> +	if (ib_dev->adversarial_mode &&
>> +	    !(ctx_flags & UVERBS_ATTR_GET_CONTEXT_FLAG_ADVERSARIAL_SUPPORTED))
>> +		return -EPERM;
>> +
>>   	ret = uverbs_copy_to(attrs, UVERBS_ATTR_GET_CONTEXT_NUM_COMP_VECTORS,
>>   			     &num_comp, sizeof(num_comp));
>>   	if (IS_UVERBS_COPY_ERR(ret))
>> @@ -262,6 +272,8 @@ static int UVERBS_HANDLER(UVERBS_METHOD_GET_CONTEXT)(
>>   
>>   	if (ib_dev->ops.uverbs_robust_udata)
>>   		core_support |= IB_UVERBS_CORE_SUPPORT_ROBUST_UDATA;
>> +	if (ib_dev->adversarial_mode)
>> +		core_support |= IB_UVERBS_CORE_SUPPORT_ADVERSARIAL;
>>   	ret = uverbs_copy_to(attrs, UVERBS_ATTR_GET_CONTEXT_CORE_SUPPORT,
>>   			     &core_support, sizeof(core_support));
>>   	if (IS_UVERBS_COPY_ERR(ret))
>> @@ -303,6 +315,8 @@ static int UVERBS_HANDLER(UVERBS_METHOD_QUERY_CONTEXT)(
>>   	if (IS_UVERBS_COPY_ERR(ret))
>>   		return ret;
>>   
>> +	if (ib_dev->adversarial_mode)
>> +		core_support |= IB_UVERBS_CORE_SUPPORT_ADVERSARIAL;
>>   	ret = uverbs_copy_to(attrs, UVERBS_ATTR_QUERY_CONTEXT_CORE_SUPPORT,
>>   			     &core_support, sizeof(core_support));
>>   	if (IS_UVERBS_COPY_ERR(ret))
>> @@ -519,6 +533,8 @@ DECLARE_UVERBS_NAMED_METHOD(
>>   			   UVERBS_ATTR_MIN_SIZE(sizeof(int)),
>>   			   UA_OPTIONAL,
>>   			   UA_ALLOC_AND_COPY),
>> +	UVERBS_ATTR_FLAGS_IN(UVERBS_ATTR_GET_CONTEXT_FLAGS, u32,
>> +			     UA_OPTIONAL),
>>   	UVERBS_ATTR_UHW());
>>   
>>   DECLARE_UVERBS_NAMED_METHOD(
>> diff --git a/include/uapi/rdma/ib_user_ioctl_cmds.h b/include/uapi/rdma/ib_user_ioctl_cmds.h
>> index 816b3107464f..3e482a4338f9 100644
>> --- a/include/uapi/rdma/ib_user_ioctl_cmds.h
>> +++ b/include/uapi/rdma/ib_user_ioctl_cmds.h
>> @@ -101,10 +101,15 @@ enum uverbs_attrs_query_comp_cntr_caps_attr_ids {
>>   	UVERBS_ATTR_QUERY_COMP_CNTR_CAPS_SUPPORTED_QP_ATTACH_OPS,
>>   };
>>   
>> +enum uverbs_attrs_get_context_flags {
>> +	UVERBS_ATTR_GET_CONTEXT_FLAG_ADVERSARIAL_SUPPORTED = 1 << 0,
>> +};
>> +
>>   enum uverbs_attrs_get_context_attr_ids {
>>   	UVERBS_ATTR_GET_CONTEXT_NUM_COMP_VECTORS,
>>   	UVERBS_ATTR_GET_CONTEXT_CORE_SUPPORT,
>>   	UVERBS_ATTR_GET_CONTEXT_FD_ARR,
>> +	UVERBS_ATTR_GET_CONTEXT_FLAGS,
>>   };
>>   
>>   enum uverbs_attrs_query_context_attr_ids {
>> diff --git a/include/uapi/rdma/ib_user_ioctl_verbs.h b/include/uapi/rdma/ib_user_ioctl_verbs.h
>> index 21f86cc7bb1f..5861f34f8343 100644
>> --- a/include/uapi/rdma/ib_user_ioctl_verbs.h
>> +++ b/include/uapi/rdma/ib_user_ioctl_verbs.h
>> @@ -47,6 +47,7 @@
>>   enum ib_uverbs_core_support {
>>   	IB_UVERBS_CORE_SUPPORT_OPTIONAL_MR_ACCESS = 1 << 0,
>>   	IB_UVERBS_CORE_SUPPORT_ROBUST_UDATA = 1 << 1,
>> +	IB_UVERBS_CORE_SUPPORT_ADVERSARIAL = 1 << 2,
>>   };
>>   
>>   enum ib_uverbs_access_flags {
>> -- 
>> 2.18.1
>>

