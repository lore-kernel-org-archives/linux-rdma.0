Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.57.2
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794907877;
	b=Gy6JjxDOyeLe7Jm+KyMNRY4gKIIAucUB4d0D5ux3YeT0fjmlmlT6EFlyVsKnY5+atSP3
	 hdHBxRl7o65ELxQkkirg+sxOZq7MAJ6a9y//LbZ65yuihMOx95HkyStVz03onREShWE9z
	 OJEaHCQ0BoUXMoEA/UttVQV50z+wjDY/2TLxFywsBj+8Zo72Ik88fplCJmx8BHcoQ2Svz
	 9c5qon+JsPdaQX6sYxgUOHdOj4yBf46jdP9V+4j6GLP1rgjwlf9i8IsFymwu/ZLHv7xNE
	 aCF2+MWIPSkIGfYgp8yC+ZFPbt7eisiIDNq/oh5EwOfkO1wWRC/DPeDPXTPQTjOSalA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794907877;
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
	bh=YTfl1Rudit220v0ZHVhYdp7bEqkIR8M6W9ypzH56mJ8=;
	b=w7GIPNV84FQNhfaBSLMtJhVX9MjNOqfSjVUFXEUfe2/Bq809qgU5FkchVdETHJv+HpRq
	 D3g3CYAWky1cgl5HFROu9wVbcbAr/pSx00YNUYgz7qhYvbshIb2CAjXjstCpl7lX4jEoc
	 6RfmKFxrBh3ELn2+GbFRYbvtjOAbXaS2hvP1T7juNWpU+8gkct2LUaKaCjpne0RvvRit1
	 CmrD6JHXImkI7bBkuEeGvh75SZSOoAMvdS41Reod+wjvwz8PJKHxd9UQ3EkNxNPjwXRqZ
	 ixex/2phdBcUXEKKVumbZguY9wqj1I1s9ClqbjukXBFKu++8uuoHkoU+k2oajCZBcbQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=kNWO90aH;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.57.2
Received: from BN8PR05CU002.outbound.protection.outlook.com (mail-eastus2azon11011002.outbound.protection.outlook.com [52.101.57.2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0C19606A329;
	Tue, 17 Nov 2026 09:31:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E0C19606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=kNWO90aH
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WwQ9nvPQDu2eD5w0mouIzqweQJKZtJYKxsWkTqkmkeo8pVfn8RETKBYq7+QND0tWprrUm1f0qYcHDsnILucMZMWN545fHr9kn3n6a5tiWUryfO9TTK2+i1LIbM5tof/fOyNT2vdfrolyu0JtrMukrhwoenQ7HRZOAMa6RPcW2t/1JOSg73Rpwt7I5nmK2TP1rMyjFsP6NmNoPTrntB72AcEDCSzrpavvPVuvc8Qap2k4Bim/YePWkcn6IwV+D/InMi7Emz4QPA3TcBP6CDm5itBpk0u+p0HzaHMVuCBSEQiKBUmeuH9zrxSU5uNtT/U+xPGhbSPKPuIQgkaUDa5hhw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YTfl1Rudit220v0ZHVhYdp7bEqkIR8M6W9ypzH56mJ8=;
 b=volL3QgWGIIx3ruW43VN7OIfoYE/G5WnD5q6FFGM+s3sWAs1AUCnIUhAUaeTFiXU+hhreV1QcU5tKYXicPO6i0bN6csOwxK/LFkBhOd8umpPR8PCd0l7C1sqNqap9TrCvp66hlpcwWPm/VHuiw/p24TsMAIFrMszgPHeXH+Q7I8UzPAOtsKIn3oFEvfQqN4z3movqB0V6/oxcIEHAOlHp/ko9lYYCeRI0X23+az6GCXg3vplK9g8frHSoEgruPcsDr7nqHKjR79PcT/NcQtElSHXSU6ajcTNIUF1piz+fZrca0IGK0p0V1nN3dWb0zlwIrqOrFk2nY+wy+lJsMlS8g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YTfl1Rudit220v0ZHVhYdp7bEqkIR8M6W9ypzH56mJ8=;
 b=kNWO90aHH/gWHiEXA4FvweOv7hljG5niVpbXU7tfvX0HJluQJ0n7Lh2zI98P5fpEqf5X67tePmpONsdEYNDHOL+lhRmSh9DcX5phxIHTkWkCe26fA4/R1gO/Qfo7LK8uWIzDPsR63SZdJg3mxzBrbvasKUFWVHdKdmbnqgBBYYStzHiwFr4hAqlWNY/Lem3xUmFemegj2OeLW8yF1A8uSnlMRf2+D7X32FL6Llq65zw5CdsvWAMVLGeNbF543QUGpUekubKMBLBSBKdwxYipjTOOx7Hr8tgLi5PcK1np4zjoTEhVIl+SXUFCQsHNdAl+WBDL8XXyPDp7UCVXgoQjGg==
Received: from CH0PR04CA0045.namprd04.prod.outlook.com (2603:10b6:610:77::20)
 by DS3PR12MB153673.namprd12.prod.outlook.com (2603:10b6:8:611::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.14; Tue, 17 Nov
 2026 09:31:11 +0000
Received: from DS2PEPF00007107.namprd05.prod.outlook.com
 (2603:10b6:610:77:cafe::9) by CH0PR04CA0045.outlook.office365.com
 (2603:10b6:610:77::20) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.615.10 via Frontend Transport; Tue,
 17 Nov 2026 09:31:11 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.117.161) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 DS2PEPF00007107.mail.protection.outlook.com (10.167.23.70) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.615.4 via Frontend Transport; Tue, 17 Nov 2026 09:31:11 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Tue, 17 Nov
 2026 01:30:51 -0800
Received: from [10.125.206.246] (10.126.230.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Tue, 17 Nov
 2026 01:30:47 -0800
Message-ID: <591b2771-7e87-48de-8256-3d3fe553e294@nvidia.com>
Date: Tue, 17 Nov 2026 11:30:45 +0200
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
Subject: Re: [PATCH V1 rdma-next 02/24] net/mlx5: Derive adversarial mode from
 CC guest memory encryption
To: Leon Romanovsky <leon@kernel.org>
CC: <jgg@ziepe.ca>, <linux-rdma@vger.kernel.org>, <netdev@vger.kernel.org>,
	<saeedm@nvidia.com>, <tariqt@nvidia.com>, <mbloch@nvidia.com>,
	<kuba@kernel.org>, <pabeni@redhat.com>, <edumazet@kernel.org>,
	<davem@davemloft.net>, <andrew+netdev@lunn.ch>, <dtatulea@nvidia.com>,
	<moshe@nvidia.com>, <maorg@nvidia.com>
References: <20261110134320.34408-1-yishaih@nvidia.com>
 <20261110134320.34408-3-yishaih@nvidia.com> <20261116094522.GF11319@unreal>
Content-Language: en-US
From: Yishai Hadas <yishaih@nvidia.com>
In-Reply-To: <20261116094522.GF11319@unreal>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: rnnvmail203.nvidia.com (10.129.68.9) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS2PEPF00007107:EE_|DS3PR12MB153673:EE_
X-MS-Office365-Filtering-Correlation-Id: 82727f5c-737c-4934-1d89-08df448d84b1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|23010399003|1800799024|36860700016|82310400026|4143699003|11063799006|56012099006|261026121527099003|261026140227099003|261028144727099003|10067099003|261021135927099003|261022075727099003|261021121427099003|261022105027099003|261102130727099003|261102123227099003|261009223027099003|18002099003|22082099003|6133799003|13003099007;
X-Microsoft-Antispam-Message-Info:
	quaIkvW0YigiNrva2WpYXiw8e4ZxNIpa6OmtjXac5L1kJQ8a63hhEDD81JvBJ5ldI3/PCS6ZW5RFuAFJfOMEM6BJJxogFhpJ9m5XNHhLt1OddZAHA8kkmGz/RnnrkkMLr0GZ4uLZUTRIpfxlnis0DghBcRDwXmDu1Twhrrh89lKwXobMtWmNjCLWeNNTl0a3mzZCs/Jhh4J3dE7JczxopoNcecQbGKc8wCjVkwhjnPuQWWqRW8tDonDW9291S8WY4V9oRzdqniav+dUzmtDPRiZeGxOd6zMz/kwtlFrdGHkGLm+LHRmPUBIEv/VslvOijy06ii/Ud18+AyZM7YcnM+x6NF3s0RSxQw7rUyxfCVJasiDf6dvglFwVCTrWSDZGk3W45P13oOUYwX7e0igro8p9uDDlR30yEQdWr1hqK4wtxLx0w+TWz8qcTJaYf5QX+nvXaFukPoh58SyvBTzF8H6OcpgsB7wOIrQqV7oIC8lxPeMZ2k11i7XtFozLvIl/cNs5Qx9RqhoFOqqmAMFgMi9yjlCey+yeRc+VSSiXouj15Z7phJ/RTW5q6wvDyexT4+ml4VswEkTS8hdR+qG+UUuWxzHUDLEr3erL4xhlf0nNa3vYEnPUM8LyBHKpqx1s0H0ezdlBRTvfet2auZZiDd/ZjqG9sf/qRw60shLZLP8UipiuEvFOq+aHCruv1FmcBXPgFBePB5ebjD5vEd584g==
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(23010399003)(1800799024)(36860700016)(82310400026)(4143699003)(11063799006)(56012099006)(261026121527099003)(261026140227099003)(261028144727099003)(10067099003)(261021135927099003)(261022075727099003)(261021121427099003)(261022105027099003)(261102130727099003)(261102123227099003)(261009223027099003)(18002099003)(22082099003)(6133799003)(13003099007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	UMp6QueLMZy8FtCyKixFFyNeKZX5ruDuUsdN5/JoujN+ZPeI9y2M6m7qpwxLNH01OLEaRty4RMAe+ANaVVB0ZY3qD/XXNb60JaGwZf8Zhudk8oT0GMB9ZoLE/uutUTW1OCMeatYOONWPHZB9Prnkpakdtacr5XLO8rOj9Uk36EbL3p1ARaRZGERUwclQn+4FC1rateKuiuJe3anH8vIKlAv2I/goZPJV5+6WHaSdOiSbGoxbiX4QJ8hzmPg+Ife38vlw36ntgUYpFnMwLgZR3hEIcJaEuYRKhMXZt0WXlwF5WM8ECG0aNM7L1wN+sil9WKFeBQpEduBy5IXZbOMpkz+2RuttJ1RHpVSwO1bvYeIuYdNs2xsEO+ZwqWxd1b71jTT6d0E79/GXzW5o1leoKN66XY/VWdgmwWLZfWdJuUTsMT1kWN+hvzvMawMWQi6T
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Nov 2026 09:31:11.5774
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 82727f5c-737c-4934-1d89-08df448d84b1
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS2PEPF00007107.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS3PR12MB153673

On 16/11/2026 11:45, Leon Romanovsky wrote:
> On Tue, Nov 10, 2026 at 03:42:58PM +0200, Yishai Hadas wrote:
>> Add mlx5_is_adversarial() to report whether the driver treats the NIC
>> as untrusted. In a confidential computing guest, the hypervisor and any
>> passthrough device are outside the guest's trust boundary, so the mode
>> is derived from cc_platform_has(CC_ATTR_GUEST_MEM_ENCRYPT).
>>
>> This turns adversarial mode on automatically in such guests, without
>> any administrator configuration.
>>
>> Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
>> Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
>> ---
>>   drivers/net/ethernet/mellanox/mlx5/core/main.c | 7 +++++++
>>   include/linux/mlx5/driver.h                    | 1 +
>>   2 files changed, 8 insertions(+)
>>
>> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
>> index 1a45474ce03d..f9e10464a71b 100644
>> --- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
>> +++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
>> @@ -31,6 +31,7 @@
>>    */
>>   
>>   #include <linux/highmem.h>
>> +#include <linux/cc_platform.h>
>>   #include <linux/module.h>
>>   #include <linux/init.h>
>>   #include <linux/errno.h>
>> @@ -484,6 +485,12 @@ bool mlx5_is_roce_on(struct mlx5_core_dev *dev)
>>   }
>>   EXPORT_SYMBOL(mlx5_is_roce_on);
>>   
>> +bool mlx5_is_adversarial(void)
>> +{
>> +	return cc_platform_has(CC_ATTR_GUEST_MEM_ENCRYPT);
>> +}
>> +EXPORT_SYMBOL_GPL(mlx5_is_adversarial);
> 
> I would expect all drivers to follow the driver core's trust level instead.
> https://lore.kernel.org/all/20261109-device-trust-core-v2-0-3b12d9a9f861@nvidia.com/
> 

OK, in V2 the mode will be kept per device, ready for the core's trust 
level once it lands. Until then, it will still come from 
cc_platform_has(), so it's enabled automatically in a CC guest.

Yishai
