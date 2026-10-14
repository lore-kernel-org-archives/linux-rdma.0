Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazon11010030.outbound.protection.outlook.com [52.101.193.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BCD753F6BC;
	Wed, 14 Oct 2026 14:20:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.193.30
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791987656; cv=fail; b=j0/vBIbU+OYW431Kt8qYBEEynBWEipRcqD+6ld4d+E3HMv+F2cHUBW3DIPjLbwLLnHzfKev5BoRu8D7K0XiHUyx7X6zNjjkSOe4V4gS0+9EqF1+ZIHAuJiZNam3gAnmdjQERXNwh9Tu7BxhyEcz+CkttS6MTVcDJqsjb8Ub9Va4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791987656; c=relaxed/simple;
	bh=9NxqqY9q+oDcUfu3y5r35XsBIM9hqGEYkJBTFLOcNVk=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=WXvCim2UpY/UtyjEnHPKwmHQqUvLkbCJL2CK2GI+V/ip3OkWQ596o9/47dD6v5/2ZeIq6d+vxXakToQouOeFnOHSX0mvKYvCAYQ8VwIzkT3Tgrh1cST7/5h28IfCFKHtNey/Y4JCCVnd0YreRk5sBE+d0am3/i8QArZuPrSng7c=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=rNEnGFh0; arc=fail smtp.client-ip=52.101.193.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="rNEnGFh0"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Pge8vTacVCXCU5TfIZDENFfEOBfTHnFL3oyD6JAMYk+umXeCavmy9CSK2PEOp11aogJlZXEKE+iqDv2NTSOZfHOiw0gnBg3JaI41tDRnTod0Eyfw8RW6j1wOcG1AvPTFJA00C1NPysXIso8F8IB0JfkfjLCvvoCVGaKGE5mY3f8ddHJAtRZ7HsEOyH1nc4sEUp7PMHSBGRzenQ3m3oP3v9vzzlaE9DBdcKi6ZA0/mzlAeDow02K3nXkpmicw4s4XLRSivrdaJ/dag60x10E6igPDj1SKc7BNvy6hQwa4fVraNAy/KrDE012zKTZTelGu6FvbPT2qpQ+sfdnVlT5a8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4w/VMVFQ7eNUqd3GNQhxyb86Bgb0rSQ6ozS2lqGZb8o=;
 b=rUsPHBGdOdzVyOcOlfPaFIIgx3qcxo15bimR0UJadyQIakpqDawgEBuGKgcpp5vRkmSTWpVGacwu30QTYDeKXv0oXNru87sIYU108xaRSjfoE970ubtTFJ/J6UQnM2/jWhoOKJxkqFZzIoFPMMDGJu4YFljV7Aji+atzGwd+dxhi1aXpMKhMCKAugeftCJiPqce+WPiC2qyXC2IghIFND019WXz0gVRmE3xjHkRTXWBtQDlWHW9xTapepMiRwIb9dwnyugg9JO98SxgRZWlZcUK/ScbYTFYFAnHiO73Y6PdSQUCiNjAD/CA+wWjGcIULCs4aKvJhehDPIBocploL/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4w/VMVFQ7eNUqd3GNQhxyb86Bgb0rSQ6ozS2lqGZb8o=;
 b=rNEnGFh08gjkPJYJLtwiKc0hvzu1SN2WRDw/z2hEUTbOsaXglwWNZb8rpTbmJ41c4aeqwjKtUp6Kn5GE2JG3akXvfBLSCYjgDtoUEro4gAm1qoFypcDkrvWWFs0JyZfbk+HHztiR+UcOQeFRFlQTy2ktytrBrsyYMW3NJnedasKX46rXzHXeM9KfwmPMKNhmnGIzWDom01vFz0Jqq8UkP1FCe+7HHCXARSCddaVjQhuk89vYyFweRxtyPhNJ2r/1sHfO3ppc6jGSxLxrJqDwEYtWLH4IE2VW1TMrw29tyjfdvg6jLiSnefmNIlhCUgfgTpbzTnqvDQdXUhz2hbdNsQ==
Received: from BN0PR04CA0019.namprd04.prod.outlook.com (2603:10b6:408:ee::24)
 by SJ0PR12MB6989.namprd12.prod.outlook.com (2603:10b6:a03:448::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.19; Wed, 14 Oct
 2026 14:20:48 +0000
Received: from BL6PEPF0006C3DF.namprd02.prod.outlook.com
 (2603:10b6:408:ee:cafe::25) by BN0PR04CA0019.outlook.office365.com
 (2603:10b6:408:ee::24) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.496.5 via Frontend Transport; Wed, 14
 Oct 2026 14:20:48 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.117.160) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BL6PEPF0006C3DF.mail.protection.outlook.com (10.167.249.234) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.522.6 via Frontend Transport; Wed, 14 Oct 2026 14:20:48 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Wed, 14 Oct
 2026 07:20:21 -0700
Received: from [10.80.21.140] (10.126.230.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Wed, 14 Oct
 2026 07:20:16 -0700
Message-ID: <eef39aa1-8e84-4a8c-abf6-81555a38e1e1@nvidia.com>
Date: Wed, 14 Oct 2026 17:20:08 +0300
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next] net/mlx5: Add reset_prepare and reset_done
 callbacks
To: Narcisa Vasile <narcisav.kernel@gmail.com>, Tariq Toukan
	<tariqt@nvidia.com>
CC: Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
	<davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>, Jakub Kicinski
	<kuba@kernel.org>, <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Akiva Goldberger <agoldberger@nvidia.com>, Gal Pressman <gal@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>, open list <linux-kernel@vger.kernel.org>,
	<linux-rdma@vger.kernel.org>, Mark Bloch <mbloch@nvidia.com>, Saeed Mahameed
	<saeedm@nvidia.com>
References: <20261011094809.790798-1-tariqt@nvidia.com>
 <as8jYneJ32Hl++uj@gmail.com>
Content-Language: en-US
From: Moshe Shemesh <moshe@nvidia.com>
In-Reply-To: <as8jYneJ32Hl++uj@gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: rnnvmail203.nvidia.com (10.129.68.9) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL6PEPF0006C3DF:EE_|SJ0PR12MB6989:EE_
X-MS-Office365-Filtering-Correlation-Id: f0a5e266-03f2-4c74-fdb5-08df29fe5808
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|36860700016|23010399003|7416014|82310400026|56012099006|10067099003|11063799006|6133799003|4143699003|18002099003|22082099003|3023799007;
X-Microsoft-Antispam-Message-Info:
	VFBDwDURVzAgL8eJzfFA3IOgv6Mx8kYbqdRIwxexM5kCvyPYWuUJZnJaGSiTWpUh0ZLITyF7yw5LvorcE4IA4ywOFVBOCAh/DDy5txwH8kQjvv30LVBsbalwmQK6rhegR3fdDKgANY1RPbKUYQr9AeIwGzwzSQTrGRYet1Dp+Sp9VUbzqjbH1lj4M8JQoPVZXhTVjftM/XHkT2wLv6kQCbIzvAVfIEhLANY98U4Xg2uLtOuxQkkWNEihz/2ASwEutCJKYs1gW0QYrgFkHLLEjXy6hMwdoROfPucYesB69Qem7kXIYQ+z8mG+ztt9PhbHm3cUwi3N4JfFevLl0Wv3d0uTDvJB6XAMUWWZim6NYGR3tJfjBoq3MwFWWhabB877hEYCcqUwecLyZmtdc6BIR+1VLmxoNp8rqd1+VixeRfziY5kfREBi0Rhq77zzmqNnmgbqoSGdGdf1i1SrOPSVFNEVCBTBkAw9dQn35QfMFXS7WJfnHRqz6/14gGi6Cn9TyW8aphtpngNgvgS8m/hrXnuIP0MsbD8dN236PPyiw/5w/Wd/+q1ZCwX18L3iCEA4o56mKraG/PAYLsiqY8sKyCR889cdDvUdCvdxlST7ObtyKXYnWTV/dMVH6OPyAyA+ULL6Yd9eltqgkHj4Z7fLqE5xV4c0o9mjjuXCTRf3Ig31obV5y6LU2KoWuLNFnlKE0rUhD3/NQ+IlDGo2vSs1Gw==
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(376014)(36860700016)(23010399003)(7416014)(82310400026)(56012099006)(10067099003)(11063799006)(6133799003)(4143699003)(18002099003)(22082099003)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	/oG8aJCvyPXXg40DkEeB0oPBv02i9R/ZU+lt4Kcm9sqeEVT7cXfFQKUCGp10sYMqmphrtTt58455F5MnaXDGnR8hb0K327SxxBJossHQn+KmecpcHl/UhpE9xTvyMQ0htssMPL6Si+3azbXwByt3c/biJGXH+iFlgYTPKOeUdCNSjOy9ki8CJviOvbKInGX4znCtl3OpZMu0FL/W+0Sawgp5IFwOV5Uv4TYlcLc92cGmtEdwCcb440uBTGA0mIVBenEj03w87QmSHpCqKWci+rRCobxM2Bsu9oomtsRUa3Z/rMAoiEqm/5wQv50BdklF4/3yb8SNf5r3VmggiBc1TtvlqbdpD8zd/W/YIR+TcvN4prFpOLEcuIJA00HEbxM+tUOq/ej0eSZJ2zOX04lQRRV2dRVkhpg+vbGij3oSv11eWQ/i/QUggpUqn35vIfy6
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Oct 2026 14:20:48.3453
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f0a5e266-03f2-4c74-fdb5-08df29fe5808
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF0006C3DF.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB6989



On 10/14/2026 9:38 AM, Narcisa Vasile wrote:
> On Sun, Oct 11, 2026 at 12:48:09PM +0300, Tariq Toukan wrote:
>> From: Akiva Goldberger <agoldberger@nvidia.com>
>>
>> Currently, the mlx5_core driver registers only the error_detected,
>> slot_reset and resume PCI error handlers. Add the reset_prepare and
>> reset_done callbacks, which are triggered by the PCI core before and
>> after a PCI reset, respectively. These callbacks let mlx5 quiesce and
>> restore device resources and commands around a PCI reset, so the driver
>> no longer relies on the reset happening while the device is otherwise
>> idle.
>>
>> Additionally, add a device flag to indicate when a PCI reset is in
>> progress to serialize PCI reset flows with other reset flows, namely FW
>> reset. This flag also indicates to the reset_prepare and reset_done
>> callbacks when to do a full unload/reload of the driver. When the
>> callbacks are triggered by the hot-reset FW reset method, they leave the
>> teardown and reload to the FW reset.
>>
>> Signed-off-by: Akiva Goldberger <agoldberger@nvidia.com>
>> Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
>> Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
>> ---
>>
>> +static void mlx5_pci_reset_prepare(struct pci_dev *pdev)
>> +{
>> +     mlx5_drain_health_wq(dev);
>> +     mlx5_unload_one(dev, false);
>> +     mlx5_pci_disable_device(dev);
> This disables bus-mastering, after which pci_save_state snapshots it in
> the disabled state. reset_done() re-enables it but the snapshot remains
> stale.
> 

Good point, will send v2.
Thanks.

> If a FW error later triggers the sw recovery through mlx5_pci_slot_reset(),
> the stale snapshot is re-applied with pci_restore_state().
> Would this disable bus mastering again and block the driver recovery?
> Should pci_set_master(pdev); and pci_restore_state(pdev); be reordered
> in mlx5_pci_slot_reset()?
>> +}
>> +
>> +static void mlx5_pci_reset_done(struct pci_dev *pdev)
>> +{
>> +     err = mlx5_pci_enable_device(dev);
>> +     if (err) {
>> +             mlx5_core_err(dev, "%s: mlx5_pci_enable_device failed, err = %d\n",
>> +                           __func__, err);
> nit: mlx5_core_err already prints __func__
>> +             goto clear_pci_reset_flag;
>> +     }

