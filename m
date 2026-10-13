Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012009.outbound.protection.outlook.com [40.93.195.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4866A349CFF
	for <linux-rdma@vger.kernel.org>; Tue, 13 Oct 2026 09:50:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.195.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791885011; cv=fail; b=BxvamtDz/glDegOhpbSZOPfYv6sOEuC/0Qyx5jHXCZdMTPCwdFPgImxhRG+iAqUyEN05oJ6676vnQbiQBWiITdQXgTTbbaMuNpT6wL6VkSPo4y9dpENsbO+42ifJFkK3yPBmfTbQkQf0nrceov9JFkgaKI+LH3H61CMYGNnuX+k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791885011; c=relaxed/simple;
	bh=LILL3Og/6DGqgIKUHIDYdl998s/DxpleZuR9O3dlHUA=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=i3tQRnI1t/cUZNGeAiNVwDHVtHO3mJS2EtvmWPFvMhNqcU81mMUXr0CswTwbQDw5nnts+8HjhEpwl83kjA8us1j7oN/9GFO4dt3pi+GmEeDmFkcS064ZR8xpGDTvZUNBeXI+qtP7ylnHMaXOc94KpjqmON/2CC4siYbWWqVRvyM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=AQELAlN/; arc=fail smtp.client-ip=40.93.195.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="AQELAlN/"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=awoe6FpeQpguwM7wg/Zn7eI4YuVSuiM5kICinUVkfuY8XlGImYurOP5RAVRjVfsiveMraRHjq9XTwR32ZdackljDVgLQm7RRQcmTs5wjYWFoLZnFHTrRwZzxTiKJgwImscLNrGaXsy4figTJxnChvBDJTB1bDpiNs42a89WM6XOcfXznzVLu0S0tjoW95LUdRRtIWbADIC+qUjyd31CHVdzsS6bfRi9nyy3LRVv26vyQ7Ynh0EGFOeR/ozwO/YNdlIMrbLJoqIt4fhEQD8KAPS2zkcRhBxPg12DT54ExrjiouRX5UYYn8Bh80Wg+ksmmO8jq5qwjXT77FjWKbjnd4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Nl2nco867Af2CNbiY9xn5FRNySjxSIB5R0uXjBVbRLc=;
 b=Q/Ha/1HoTf3JyEHoXB+OjFced7J4Y3OzRJYFIm6IhQiHVodLRTk0T2uRq9XGZCCBcAh2eejtt2aKTjkEKthTxgiJ5odsTUQE8qKBFQZUxjFG/GfsC3ljcXgOEsE9VUfYA54ZDnBoLAUJwpqP7eZx/TeWhZLxqwQCpn77ayy25XwGfFZxNTTqKV2+zbE9OXbU14RqV0BsgSFUaqx2673uJ0BeHApG5dETAi8T7U6UED3LHj6le8Hflbp6oE5sZYCBJQ4kCBsY2mK3xnZ6DTNDi45bLknphNp6n7sQcWX38o3PSRxXXH55c75pCsa9j3g6t19Vm5oCNMK2E5q4SzcFuQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=cybernetics.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Nl2nco867Af2CNbiY9xn5FRNySjxSIB5R0uXjBVbRLc=;
 b=AQELAlN/MBOfnFaRWAjmFFkRImh9WQak9FqpwkBjqn9llvWeBgHH+XK5xHdNtklbpF/aHF71nbMEPbvlozwAY0+jA2V5bx7XjrKnky0rbtMFqFam7I3Lvsa/mgsZv5gff5ft+7PEq0Ydz3o2j7j+j3IL6q1Vfnla7P/L4nTZcseHsjBk5x/6EbXXuJWvDpFFE1Gu8FSG+8jbNsNLaMgfnQcqWuo1C/5pYAQox6tWplIK0FRuhdKwoaxcFCsEqw2fzulHypsCzVvjRyZIMNXVbzEfBVTfGOpuKlS5Kbda3xSxnskkIalguVGL3phRGFZ2xpHUu6EkhC0v98Ne4DRUsg==
Received: from SJ0PR03CA0291.namprd03.prod.outlook.com (2603:10b6:a03:39e::26)
 by MN0PR12MB5881.namprd12.prod.outlook.com (2603:10b6:208:379::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.496.23; Tue, 13 Oct
 2026 09:50:05 +0000
Received: from SJ5PEPF000001CF.namprd05.prod.outlook.com
 (2603:10b6:a03:39e:cafe::6d) by SJ0PR03CA0291.outlook.office365.com
 (2603:10b6:a03:39e::26) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.522.4 via Frontend Transport; Tue, 13
 Oct 2026 09:50:05 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.117.161) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 SJ5PEPF000001CF.mail.protection.outlook.com (10.167.242.43) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.522.6 via Frontend Transport; Tue, 13 Oct 2026 09:50:05 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Tue, 13 Oct
 2026 02:49:53 -0700
Received: from [10.221.200.227] (10.126.230.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Tue, 13 Oct
 2026 02:49:51 -0700
Message-ID: <6af095b1-4ca1-483e-94c4-50227507fa85@nvidia.com>
Date: Tue, 13 Oct 2026 12:49:48 +0300
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: mlx5_ib fails probe with old firmware
To: Tony Battersby <tonyb@cybernetics.com>, Leon Romanovsky <leon@kernel.org>
CC: <linux-rdma@vger.kernel.org>
References: <064dfa67-8fd4-40f0-b925-6d1e0cd42e6a@cybernetics.com>
Content-Language: en-US
From: Moshe Shemesh <moshe@nvidia.com>
In-Reply-To: <064dfa67-8fd4-40f0-b925-6d1e0cd42e6a@cybernetics.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ5PEPF000001CF:EE_|MN0PR12MB5881:EE_
X-MS-Office365-Filtering-Correlation-Id: b37213c7-650f-4972-4dc4-08df290f5c09
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|23010399003|36860700016|82310400026|56012099006|11063799006|261009223027099003|10067099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	wS0J/T/zD0mI7QeS/A47oSG6EoT/M6smmR3DXB1zLaX47JdYJdern1vIa49D/0cy8uPh+qHz0ojUfH/NsgABVt0IsP1tmo3HGROKeRUpb882Fy26U2WsejoCFyIsyoZh3SUseo3dtL8z+Lrl5Dz5PI7Aj0QNIqFbn3MV4f+D4bhib5roVqgWrRexUhcUg7ePwVc7Nv2dvZZ1tLzzNzMi1EJN0cifJ6G452sLVABksEuiR0ZU8tS4fyZc7yfu+btR/OGUiKoM13izQzEcyPN06dAi9tnOp2OiiIPpGIqiP2TyTN+sDcbLkBakYxyVy++0gxCtSTNJVAbeHCQPYNdaf6y+VDR7WYBF2B+rVPP/nNMHt6+bvUS30/inBBWk0zLEMNW1RGmYuCbCLR19cE/iFYV4/nWBqgX3Z9y+EcnNa71O4vT7NEy50GtYeKo4GYo2UkA20aqxZ18Xz9NM/Jal/+wYLANUVoBZcHnAc9Oqoa0BUgsNzT0LRqa6iVNCShPsoyG/tiyFOodAbiTiQc08OGGQMupib/fClkyP6IWJZQ7Hu5DQW8yfuoq/u/xEn+XakfKSuak2XcJZYSzS7oBJNkAZSg4AI60EiZCzAFSsfm0Fm2ck/S5ZqWHtfvM+42mqRdzvWSqJWxxbX4YhrfKM5qxzAEBa95DCW4M1fNZNwXrUXD+1w4mhiCNWKq1/l5eEYEETNTtPb+b/gNNN6SkITA==
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(1800799024)(23010399003)(36860700016)(82310400026)(56012099006)(11063799006)(261009223027099003)(10067099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	+127Zqo404DvOTiSpvpKNdDY9oPv0rGNwmj2vY6uJ+paTTRYe4OH+yLNCBHMXFn1cKnKKzPPJyZ+Ay8tWJNNK59i+1VaWo0YqmW9kFuTVQKFEfCklYoQyT63yjZQapyhgHNW43a8ZGNqiD5o2MaQvp2tWGNFY+jSrazjb4vUFS5wGwbtq5wZoZCbNgxoYl+sgfRCAD1xIHGl/+G/59uHdIiAeSCsxTYWwhBC+JRsFvkIi/1OUXqtRYQxh5eSxdwE9qvcTWQ3cDzwq3l4lTM6+tmgxiIPMYhyF1ouJ3xkirzd9+Obk62sc182J0yjKkKjubKHBWALUB/s9JiEuUpS3rXaUnsq3W5FFg3R+E6PX4riqmtvNmCb5Ft3sd0hisg9BcG8HsH2yduupOVqdz/BQLlvg/9FYju/tvL5oyJsMR3KxOR098TGVKDDcmCbk1wI
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2026 09:50:05.4889
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b37213c7-650f-4972-4dc4-08df290f5c09
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF000001CF.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB5881



On 10/9/2026 9:20 PM, Tony Battersby wrote:
> I have a number of Mellanox infiniband adapters out in the field with
> various firmware versions:
> 
> lspci
> 01:00.0 Infiniband controller: Mellanox Technologies MT27600 [Connect-IB]
> Subsystem: Mellanox Technologies Device 0018
> 
> lspci -n
> 01:00.0 0207: 15b3:1011
> Subsystem: 15b3:0018
> 
> Ones with old firmware don't work:
> 
> mlx5_core 0000:01:00.0: mlx5_pci_vsc_init:66:(pid 731): Failed to get valid vendor specific ID
> mlx5_core 0000:01:00.0: firmware version: 10.10.5020
> mlx5_core 0000:01:00.0: 63.008 Gb/s available PCIe bandwidth (8.0 GT/s PCIe x8 link)
> mlx5_core 0000:01:00.0: mlx5_cmd_out_err:810:(pid 731): QUERY_ISSI(0x10a) op_mod(0x0) failed, status bad system state(0x4), syndrome (0x408b33), err(-5)
> mlx5_core 0000:01:00.0: mlx5_core_set_issi:866:(pid 731): Query ISSI is not supported by FW, ISSI is 0
> mlx5_core 0000:01:00.0: mlx5_init_clock:1040:(pid 731): invalid device_frequency_khz, aborting HW clock init
> mlx5_core 0000:01:00.0: mlx5_cmd_out_err:810:(pid 731): QUERY_HCA_VPORT_CONTEXT(0x762) op_mod(0x0) failed, status bad operation(0x2), syndrome (0x3590f5), err(-22)
> infiniband mlx5_0: Couldn't create per-port data
> mlx5_ib.rdma: probe of mlx5_core.rdma.0 failed with error -12
> 
> Ones with new firmware do work:
> 
> mlx5_core 0000:01:00.0: firmware version: 10.12.780
> mlx5_core 0000:01:00.0: 63.008 Gb/s available PCIe bandwidth (8.0 GT/s PCIe x8 link)
> mlx5_core 0000:01:00.0: mlx5_init_clock:1614:(pid 755): invalid device_frequency_khz, aborting HW clock init
> mlx5_core 0000:01:00.0: Flow counters bulk query buffer size increased, bulk_query_len(1)
> mlx5_core 0000:01:00.0 mlx5_0: Port: 1 Link INIT
> mlx5_core 0000:01:00.0 mlx5_0: Port: 1 Link ACTIVE
> 
> I can work around the problem with the following change:
> 
> diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
> index a457647edacd..4fc903c2a0be 100644
> --- a/drivers/infiniband/hw/mlx5/main.c
> +++ b/drivers/infiniband/hw/mlx5/main.c
> @@ -3611,7 +3611,7 @@ static int mlx5_port_immutable(struct ib_device *ibdev, u32 port_num,
>   
>                  err = mlx5_query_hca_vport_context(dev->mdev, 0, port_num, 0,
>                                                     &rep);
> -               if (err)
> +               if (0 && err)
>                          return err;
>          }
> 
> This code was added in kernel 4.19 by commit b02289b3d60f ("RDMA:
> Validate grh_required when handling AVs").
> 
> A similar problem was fixed in kernel 4.9 by commit f9c14e46748b
> ("net/mlx5: Fix query ISSI flow"), which is a source of some of the
> messages with the old firmware.
> 
> Can anyone suggest a proper fix for this issue?  I can upgrade the
> firmware if necessary, but that would be less convenient than having a
> fix for the driver.

Hi Tony,
Thanks for your report.
Please try the following change:
diff --git a/drivers/infiniband/hw/mlx5/main.c 
b/drivers/infiniband/hw/mlx5/main.c
index a457647edacd..632a45f663f6 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -3605,7 +3605,8 @@ static int mlx5_port_immutable(struct ib_device 
*ibdev, u32 port_num,
         if (err)
                 return err;

-       if (ll == IB_LINK_LAYER_INFINIBAND) {
+       if (ll == IB_LINK_LAYER_INFINIBAND &&
+           MLX5_CAP_GEN(dev->mdev, ib_virt)) {
                 if (ibdev->type == RDMA_DEVICE_TYPE_SMI)
                         port_num = smi_to_native_portnum(dev, port_num);


> 
> Thanks,
> Tony Battersby
> Cybernetics
> 
> 

