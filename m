Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.195.11
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794219536;
	b=2UKH2Xign8HNFlFWZ8n4HvZv9EnknoqOeVvJxXzDv5CSMK12Bm22fBCaYqN7EkLsGSnb
	 Dc5IXOokH2sSkEq3R7ncj2pUavyMMW8Efxjla0bdz/SHQ/rkk8r/OcN4vP8X13Pl8k3nc
	 oGSBrVj9J58/RvrLHOEQsZsvnPGKjjUTcJaK4piS2DgDwQ4RfmAdpXm1CajL36fkwtg0g
	 5hn+bOAOKLmsZZk2FP/moXet3OTcKUBbBI1f23BHXgMEoQB31bIjldRGUm0bxyzGjkx/l
	 4ZVxMzwPVVV7TRdE2feMn2P5nfxR+kpK/49KTVT9tshyqq2wd4Eh3Vmge7IANwnzjyQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794219536;
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
	bh=yC4ZY2/7vEwLzfgaEz0T8mpI5jn7vInVn/zdIhJeSp8=;
	b=hbAWplV5bHGE9E0EqnnILBjccWrswJnJ9To/s4t9u1Q/GFgPIb6ET8at/UPGD1Y1+Bb1
	 WwV7DLbviJtR2fvITEjMLUuScp6gti23MOa2IhfEMrh0Y6ZtbTkAci5jMbkYoLDmbZzdR
	 knir9JnvmUTY2R7xvTeU7cboLweZ8ONfWt8f1efIbu536fY8ng2djBXNFori4THGukdKb
	 nkOfr4gE48weUkBjFRovi0qSj/ihNZyEPAkgKGKljJ2V2kblr5OALTgGOB/k/cEn0zobh
	 S1DGvEU+Ar4pGrfnBPEIbehvw5mqUXUxtXus79Gkwrj+X9IBhYRBng6FzIzdcfX2/qw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=Z9Rr4MJn;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.195.11
Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012011.outbound.protection.outlook.com [40.93.195.11])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4EB2606A31C;
	Mon,  9 Nov 2026 10:18:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C4EB2606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=Z9Rr4MJn
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=otUjx8H5XIoRz+EkmHQh1YP1/MoVUYdUj8anJDAHM2LTInkPl6nfpeKUXOeEkxWupMX6y23b9hgU2gTrGfk2d//4Mi/rpST5myTILkNfQpxRkYO54Dt0bHh9BcgfM2bj76CJ1auz0oIP5g2kFADJ/+9WnryizZQspxAUnoqc6SnpzjQ0KWBdTPgn6LQGCEapNspehw/lRDQ4h/t0t1z4LCQzmyL2Wii9HJihM2KVyMiwPCDKERuZtcMIrxP1m2aMiI0gCJh76BKV8Z5ny/8JW8A4tvMT55PriNbdhWtwmX453E5ZE6B7vVx5KSEmecUfOSkTi1bC+u8N9octqsOcuw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yC4ZY2/7vEwLzfgaEz0T8mpI5jn7vInVn/zdIhJeSp8=;
 b=k/8PnWJzs3EpH0LOxIlZchKdXt+ZFWj7l1syXkHUzxa1K9nbAdXHgZZOcNe0eFFOpHyyGXIrgKHrkEVC1BB+cjaFB/ng17Yh2KVYJQEfUM6aTZbcDyA/5IJjOSKVY3R5GsNTS8S76+jFtdEO6Hz2Kp86MVJZ2lwYHLpRabYdpqVrvzyJ4LGPNwT91522VTEQNWi6uDJP3TIFHnihRlTp+2j8kRNLBQyenToNF8hffFWkJYY+6TTviVM4CQgP23OKjhiRxE35ax8swzYChhxlwvK/s8th8sBc9EdQpBqPg9tt+Xsf3khrzTCtagGP0pvT0mec/NObBMv80kfRBrvpXQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yC4ZY2/7vEwLzfgaEz0T8mpI5jn7vInVn/zdIhJeSp8=;
 b=Z9Rr4MJn37a4ef5gcp1qxnsKIPmCEKVQR7oFNxJIK5TtwI60Haj1E4nfMPCDKjvFZzrKlhXVFjH1ZRJ6SMzv4Aoa62re72gWqlh09P3f8s1ybYsd1APYhv/R8pIb2wDySptn8iWOAWRdXZoEqj1Ur4+yHpd9KSDMaj4Mx5+FszVj5z0D+tjSqHAupGvsCPKgT8Yy83CujRac/7ExoIjrM2cS//Wv4BE0zx8B6phxMa4QyukmU2trOPNcgPIIgPsmAX35rqys6Wd5TXW8JjKnjVbFb4ksW0u37YF5CGAau/NZhI2YacMlg3V4lxtjusM04cLtm8AkQb/S/gkOCwnVvA==
Received: from CH0P221CA0027.NAMP221.PROD.OUTLOOK.COM (2603:10b6:610:11d::8)
 by DM4PR12MB6637.namprd12.prod.outlook.com (2603:10b6:8:bb::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.12; Mon, 9 Nov
 2026 10:18:49 +0000
Received: from CH2PEPF00000145.namprd02.prod.outlook.com
 (2603:10b6:610:11d:cafe::18) by CH0P221CA0027.outlook.office365.com
 (2603:10b6:610:11d::8) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.592.13 via Frontend Transport; Mon, 9
 Nov 2026 10:18:49 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.117.160) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 CH2PEPF00000145.mail.protection.outlook.com (10.167.244.102) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.615.4 via Frontend Transport; Mon, 9 Nov 2026 10:18:48 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Mon, 9 Nov
 2026 02:18:34 -0800
Received: from [10.125.206.9] (10.126.230.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Mon, 9 Nov
 2026 02:18:29 -0800
Message-ID: <746b7acf-ebbf-41dc-a80c-317080e13e94@nvidia.com>
Date: Mon, 9 Nov 2026 12:18:26 +0200
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
Subject: Re: [PATCH rdma-next 17/23] RDMA/mlx5: Validate EQE port and GSI port
 before indexing devr.ports[]
To: <netdev-bot+sashiko@kernel.org>
CC: <jgg@ziepe.ca>, <leon@kernel.org>, <linux-rdma@vger.kernel.org>,
	<netdev@vger.kernel.org>, <saeedm@nvidia.com>, <tariqt@nvidia.com>,
	<mbloch@nvidia.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
	<edumazet@kernel.org>, <davem@davemloft.net>, <andrew+netdev@lunn.ch>,
	<dtatulea@nvidia.com>, <moshe@nvidia.com>, <maorg@nvidia.com>
References: <20261103163949.1554-18-yishaih@nvidia.com>
 <179408310169.994134.18411917783042594669@kernel.org>
Content-Language: en-US
From: Yishai Hadas <yishaih@nvidia.com>
In-Reply-To: <179408310169.994134.18411917783042594669@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH2PEPF00000145:EE_|DM4PR12MB6637:EE_
X-MS-Office365-Filtering-Correlation-Id: ab642db2-21ab-4ad6-2a0c-08df3e4ad87a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700016|376014|7416014|23010399003|1800799024|18002099003|22082099003|10067099003|4143699003|11063799006|261028144727099003|261102123227099003|261022113327099003|261022075727099003|261022105027099003|261021135927099003|56012099006|261021121427099003|261026140227099003|261026121527099003|261009223027099003;
X-Microsoft-Antispam-Message-Info:
	/ZyEuVuFY+q8IFtb9kjqHUffsVRCpof49jJjP5c/QeoAII8mKqnuNdfZlI+pYT+AWjEcdXBEjhDyvP+QRP5jcDf9yj7bUIoffZ1zU2nU4TGtGC35qj/UlRP/CthdkMCCTh2+krnj1rYipuaHqYEME+WhreF7KZ77vbkmZu3iI13h4kpIvEP5h3Sk1TuguthXxVdAQfQEfURhIfKOQPddBG6MvwQuiFn5A8UGV2TR6Y4jM0VwEq0jjsTwZaSBPhTCGDSy81tC9jdSpVytP3D+y8PPbthvhhn3segTSGH3PvkbG3D6GItritemKNEqHoinpreC38Ym/wjlQw6HJkKWBKjJMZwTej/xRARa9f5QeFNtlJmWO/V+Miokny+XJpdhWLxwv0uiDWpJdJV5Nplbt3neQ5M9Psf666OQGXziOTe4U+nWQ3dR++FNVeO6QwEf/znuHvrxyLmJyPLCz9zn3SP2fqS8iuJ5Rmy7hZqGkE0SYqnT0w3EQsvc1KzOftsI1/q/+DdXoDRNyMUDpJs1f74B3yMkXIUr6BfJ13N93qoxE4bT+ZY/xumzaVLXoozeMRQ0TehBuvRWGQuYn1frfDMSCm8LnkRy9n8J8/hE242ZeVJc4hfTEN1EAwQTS2V3wLrBsFu5eLwm00pugweq7QkjADhrztOp/gh7Mt2vtowvaEiOnyHRCDRp8czPSWPjXlRhNCxYS91Ivdd5koVeZA==
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(36860700016)(376014)(7416014)(23010399003)(1800799024)(18002099003)(22082099003)(10067099003)(4143699003)(11063799006)(261028144727099003)(261102123227099003)(261022113327099003)(261022075727099003)(261022105027099003)(261021135927099003)(56012099006)(261021121427099003)(261026140227099003)(261026121527099003)(261009223027099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	XDAvGkxN1ec6z60cvzvn/2vMumGimQlxolYXBHueKv2iCUsDV6Lvfx9NLp+WELYfpqIpWZRSsqw62Aiikart+pO6khWkPn5mS0fULFSZ3Lhl3/G3h+WF1LdlXKn2bHIJu6V2O7LmsiFlhXKsdO2JzUs9PqbdZ4cn/0kZcn0nIHBczsVbeBaE8IjGepZtACGMXVe3BPAiTeXGwSpLObLQhTKZFFk61bIWmFT4CSJzsTvxrECXWugyE56pRh7y9eJ7SDZ7eP0alCQvydr+n/gOWBPqdc1tJ2cQp2Frz+/7XqIfXCv4NiM5IYOtewi5D37AgoafRqU0cPTuRxFYroLhfvjsqzcWum1BM9uNwurmGvcwgSLQI343iOQ8z3V1Egsk0oUtGcIs2dM7u3dnCVKgqFX9srlM7lr9JQi6m+oE+p2lJIJf5kDPsyoLYBvbdzf+
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Nov 2026 10:18:48.8842
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ab642db2-21ab-4ad6-2a0c-08df3e4ad87a
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH2PEPF00000145.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6637

On 07/11/2026 22:25, netdev-bot+sashiko@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found more severe
> issue(s) in other patches of this series. This mail is only an FYI, in case
> you want to address the nit picks below when you respin.
> 
> Low priority / nit picks for your consideration:
> 
> - [Low] This patch makes the existing invalid-port check and warning in
>    mlx5_ib_handle_event() (drivers/infiniband/hw/mlx5/main.c)…
> 
> --
> 
> RDMA/mlx5: Validate EQE port and GSI port before indexing devr.ports[]
> 
> This commit adds port validation to handle_port_change() and
> mlx5_ib_create_gsi(). The port number from the NIC is checked with
> rdma_is_port_valid() and limited to ARRAY_SIZE(devr.ports) before it is
> used to index devr.ports[].
> 
>> diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
>> index f4f2ad80e76c4..c29102260989f 100644
>> --- a/drivers/infiniband/hw/mlx5/main.c
>> +++ b/drivers/infiniband/hw/mlx5/main.c
>> @@ -3063,6 +3063,10 @@ static int handle_port_change(struct mlx5_ib_dev *ibdev, struct mlx5_eqe *eqe,
>>   {
>>   	u32 port = (eqe->data.port.port >> 4) & 0xf;
>>   
>> +	if (!rdma_is_port_valid(&ibdev->ib_dev, port) ||
>> +	    port > ARRAY_SIZE(ibdev->devr.ports))
>> +		return -EINVAL;
>> +
> 
> [Severity: Low]
> Does this early return make the port check and warning in
> mlx5_ib_handle_event() unreachable?
> 
> mlx5_ib_handle_event() treats any non-zero return from
> handle_port_change() as a reason to skip the event:
> 
> drivers/infiniband/hw/mlx5/main.c:mlx5_ib_handle_event() {
>      ...
> 	case MLX5_EVENT_TYPE_PORT_CHANGE:
> 		if (handle_port_change(ibdev, work->param, &ibev))
> 			goto out;
> 		break;
> 	case MLX5_EVENT_TYPE_GENERAL_EVENT:
> 		handle_general_event(ibdev, work->param, &ibev);
> 		fallthrough;
> 	default:
> 		goto out;
> 	}
> 
> 	ibev.device = &ibdev->ib_dev;
> 
> 	if (!rdma_is_port_valid(&ibdev->ib_dev, ibev.element.port_num)) {
> 		mlx5_ib_warn(ibdev, "warning: event on port %d\n",  ibev.element.port_num);
> 		goto out;
> 	}
>      ...
> }
> 
> The only way to reach the rdma_is_port_valid() check is a successful
> handle_port_change(). After this patch, a successful return always means
> the port is valid.
> 
> Before the patch, a port change EQE with port 0 or a port above
> phys_port_cnt went through handle_port_change() and returned 0 if its
> sub_type was not PKEY (LID, GUID, CLIENT_REREG, or ACTIVE/DOWN on IB).
> The caller's check then printed the "warning: event on port %d" message.
> 
> After the patch, the same event is dropped with no log message.
> 
> Could the warning be moved into the new early-return path in
> handle_port_change()? Or, if the silent drop is intended, could the
> caller's check be removed, since it is now dead code?
> 
>> +
>>   	ibev->element.port_num = port;
>>   
>>   	switch (eqe->sub_type) {
> 

Right, V1 will move the warning into handle_port_change() and drop the 
caller's check.

Yishai
