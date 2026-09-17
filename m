Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013053.outbound.protection.outlook.com [40.93.196.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09073579821;
	Thu, 17 Sep 2026 14:04:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.196.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789653889; cv=fail; b=YrUgoEjTA5BU+D2+Tm1hbvPx7f/ONPuLDntygtEJg9IdlPYsEPSnaK4xkiLBBLqmFWRJ4fXweK4jDtPnIH4tu+8Cz6rg18o/jEy/nYyXak+CiY78tcovITWBw5fVpcAEBKHq13GM+XZtiDemHcewvNMbmUvo5JDiRLbsRDqs2zU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789653889; c=relaxed/simple;
	bh=gWRtqLMFIa1YTqQSnBJgleZXKLwEWQo36GrMNmV0DeQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=D7FgjDbvGqGQ7GfIbsjQ0n9IFeOPrSUAvklAZG7IvHwduGQDrW8U1f/u1KsH2zcSDbk6rnlDyvdDP0DHYIc8QXGsPWz5xTRqOxdal8aBs4q9BcKzj40CjgYXd44hsUmUSEdv/3Y7FqkcbehPKo69Kh5ZII/PyE30Hf1eXK6AWls=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=I9rRQux3; arc=fail smtp.client-ip=40.93.196.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="I9rRQux3"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RlaaKyyuBsSwUN8dEZoxnKQHuw1u5kadwKfJQ3eEyyTAxwYIug3M3KzkWVIu32ZtRrCTrA1p7L6L/OhCUsAz9YjVhRT6Cu4qg4Ta/DwFaxcjBkevu70RmtMJR7V8VBz74uCmqvReW0wI4gwQt/5cQrutk1VxN6oGcw2I5I8VGRY8uiVIW1c9gEuNtpO/xC0MfNCLnoGKb1L1GsD2jlLHPmgM1rzrJCzIqXkdGaSu3FA4w1pr2esSaCJX8EY+xaG6pEX8NFsQ/en4QDkMUD3D0Z591VxDU4LtZS35yhBk1lEFbxJLkCP6LZ/+QcXZnbcrm3AJ+op5SlXWl+VEnuMpAA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oqact/i0Y0qXZ05PIWE1jO5BZ30WI4iM3Lc542IZ+gg=;
 b=QxUs4ToBGWiwRBd9De4l3X9//OlQSHH9CPhDy+puYRud8RUOiDBsQzP+kNmuCkG5E/bA+YhvIm7ukwwz8YH0X/Swq/WJRgDMatdg3V0r5wUnvQ3QA8dZ7mYOV6tA2G+/cimqOvsvw+IO8qhdCh1umrZhudePYEPLe0p45vm2luk27oHfPQNSzzdoKfAn2F/O0eaFrLL3OcADjAtFVPX6OKXiqQX52ewL4wTeJiwUZUnMOMRESn3tZq5qw70Xg4WI7C6Uun66bcNRkEwhKmK4reCizhY0UyrXZ8++I2yEmLBABtZsAS5MM9mx1/tcJCnK2Dl1hVzcJi6jZgivVoUtxg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=iscas.ac.cn smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oqact/i0Y0qXZ05PIWE1jO5BZ30WI4iM3Lc542IZ+gg=;
 b=I9rRQux3RhuCEB2qWH+Xy1Yd37sF3NHM0g6bAaBPTpE3eMibPAPjX1rMc0uSYKhRQG9Gd3doLQEr2bcUqiKEfdLLb0cBbMp8bmSZ/xW25ENMfMLd5QmYpqkUh5eIJNjgCaeyoAqyimBViwfZwmeBB1TnMv6U7FcTk2TFGNU6nkgyn03w+tzbYiZUpaDnuFq4O1noTamGs6GrzYGTp5RyPol3kqkrI13hbifN/axtYhDu4pM8YfpFnpErlBCe+RZQfYdBjPv9AIKu8tYj689hKaybjZ3iAxqloVho39WD9BdfGyQlEFMJIEqNg2ieoRp9uH8Lab8js6boEzP27d2RuA==
Received: from DS1PR05CA0009.namprd05.prod.outlook.com (2603:10b6:8:457::6) by
 DM6PR12MB4436.namprd12.prod.outlook.com (2603:10b6:5:2a3::20) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.428.9; Thu, 17 Sep 2026 14:04:41 +0000
Received: from BL02EPF00021F6F.namprd02.prod.outlook.com
 (2603:10b6:8:457:cafe::46) by DS1PR05CA0009.outlook.office365.com
 (2603:10b6:8:457::6) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.451.8 via Frontend Transport; Thu, 17
 Sep 2026 14:04:41 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BL02EPF00021F6F.mail.protection.outlook.com (10.167.249.11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.451.8 via Frontend Transport; Thu, 17 Sep 2026 14:04:39 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Thu, 17 Sep
 2026 07:03:57 -0700
Received: from [10.242.158.215] (10.126.231.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Thu, 17 Sep
 2026 07:03:53 -0700
Message-ID: <c23774ed-f6f3-4f11-921b-59aa9a06e1fe@nvidia.com>
Date: Thu, 17 Sep 2026 17:03:51 +0300
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] net/mlx5: Fix ent use-after-free in cmd_work_handler()
To: Wentao Liang <vulab@iscas.ac.cn>, <agoldberger@nvidia.com>
CC: <andrew+netdev@lunn.ch>, <davem@davemloft.net>, <edumazet@google.com>,
	<kuba@kernel.org>, <leon@kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-rdma@vger.kernel.org>, <mbloch@nvidia.com>, <netdev@vger.kernel.org>,
	<pabeni@redhat.com>, <saeedm@nvidia.com>, <tariqt@nvidia.com>,
	<stable@vger.kernel.org>
References: <20260917112900.2148932-1-vulab@iscas.ac.cn>
Content-Language: en-US
From: Moshe Shemesh <moshe@nvidia.com>
In-Reply-To: <20260917112900.2148932-1-vulab@iscas.ac.cn>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: rnnvmail201.nvidia.com (10.129.68.8) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL02EPF00021F6F:EE_|DM6PR12MB4436:EE_
X-MS-Office365-Filtering-Correlation-Id: 61b6f270-cb86-4c32-2fc5-08df14c49d1c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|23010399003|36860700016|82310400026|1800799024|56012099006|11063799006|10067099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	atcDo4MyX6TE85KuRqgveahuUQY3REqd1FfFb+Y5WkgqwjcJA2BwyLcGYtwmLIht26QxLFtcHQEtTSETLrAtc7YM+TS3RajvMCtepLLhbIc2eNgyEHOtIpTh5XA2msVs+reg1u0bV0uXyQfjVDvZdZ8ngCbgkuUJBMJ2Vdxt/zLC0QsMqr2FndLA7GznMjF9qC+VIBTzmTiwFfpppvnfcbgnl7Yr1XZ8CvzKroanfcIfdYd3aB9EcRrd7aUuT7NXCsxDYvsGcvKdtfFNtvQhsBLikFg/+FIjoQafjWpWmuxh7/vdxr6buOpELHy/OYdecwK1I6ln1izFP2fb2rmAeb8pGq/SkLJZLDj4XYd9FJZ9P3X0PI+mEFBXJMTpcVCwYsIgoEF4axiAvXwmTvupxQioVQrTR8L1uQreawuhNL5v6M9xC0dj9lGNKOAJWveFBCqgoFsd1ry+GMLNN2AVIuQlYVIGkA6Dp31jk5kp7KPHsRaY+SXlx+qYeMo3o4WbTdvWaZIfeEo9uPJYmF+TrGEnUNGN70Dg69KhCx98OFqff6fq8Zk7Lz/3NtRagoZa2yH/No5vxl3ZXOBWzG1TLGLtZAZUC38mW1f03g7cwsV5LfYnhjGNK8Kyrm6coJBatns6H7aKWBKvsyxK52Uo6GnRXhGOKHOXSnzfW8pao2NiZGi1kBJnyJy2AntVsjFrYqfxTD+3B+16ICYPnqNVMA==
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(7416014)(376014)(23010399003)(36860700016)(82310400026)(1800799024)(56012099006)(11063799006)(10067099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	BXANJK6zL+iqOgvJUIs6Vmm5tJe7ttKK9tPS/QWpchiDAYYWYD/dbmGydmSPnaB3riUnpdH/bdJRq59+7FUiYcumLtiNp8aw8DqXMnq8CXVNzBMsgWPyp94lhc2GmkAiJ5DApxoel4PneI63EI564xDlG/UxdXB0+dBd+gCUtKn/XxVycbyCIeEc4CD4r2BCA1IdMRrBia4Xoogt6SuXEI2jSVQ6LaoooFPeGdzEsiQWFLoXgj1FByhcHIZxkRpEekJw3bW1WzCjQVJvViUMg5B9LsawyH+YXd7Y8ZXfni4TvCffz+uD+YYfj5iO+XZVAvov5CXUvNKJmz+AIAPaIqbrPJnCrFHe1d+mvxDiusyQnSjnZkOf9iYjTnPBp0mbUjTORrHCjtxNVEr/LywUGwaJ3fmzd8Sf1lucfOYfODmKVmxebzeW7lbtU1hoOUW3
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Sep 2026 14:04:39.0060
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 61b6f270-cb86-4c32-2fc5-08df14c49d1c
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL02EPF00021F6F.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4436



On 9/17/2026 2:29 PM, Wentao Liang wrote:
> 
> In the two command slot acquisition error paths, cmd_ent_put() can drop
> the last reference and free the command entry, and complete(&ent->slotted)
> is then called on that freed entry.  Signal the slotted completion before
> dropping the reference so that the waiter in wait_func() is woken while
> the entry is still allocated and the entry is not touched after it has
> been freed.


This is already fixed upstream by
commit 02896a7fa4cd ("net/mlx5: Reorder completion before putting 
command entry in cmd_work_handler").

Thanks, Moshe.

> 
> Fixes: 485d65e13571 ("net/mlx5: Add a timeout to acquire the command queue semaphore")
> Cc: stable@vger.kernel.org
> Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
> ---
>   drivers/net/ethernet/mellanox/mlx5/core/cmd.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/cmd.c b/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
> index c89417c1a1f9..2dac131c5f86 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
> @@ -998,6 +998,7 @@ static void cmd_work_handler(struct work_struct *work)
>                  if (down_timeout(&cmd->vars.sem, timeout)) {
>                          mlx5_core_warn(dev, "%s(0x%x) timed out while waiting for a slot.\n",
>                                         mlx5_command_str(ent->op), ent->op);
> +                       complete(&ent->slotted);
>                          if (ent->callback) {
>                                  ent->callback(-EBUSY, ent->context);
>                                  mlx5_free_cmd_msg(dev, ent->out);
> @@ -1007,12 +1008,12 @@ static void cmd_work_handler(struct work_struct *work)
>                                  ent->ret = -EBUSY;
>                                  complete(&ent->done);
>                          }
> -                       complete(&ent->slotted);
>                          return;
>                  }
>                  alloc_ret = cmd_alloc_index(cmd, ent);
>                  if (alloc_ret < 0) {
>                          mlx5_core_err_rl(dev, "failed to allocate command entry\n");
> +                       complete(&ent->slotted);
>                          if (ent->callback) {
>                                  ent->callback(-EAGAIN, ent->context);
>                                  mlx5_free_cmd_msg(dev, ent->out);
> @@ -1023,7 +1024,6 @@ static void cmd_work_handler(struct work_struct *work)
>                                  complete(&ent->done);
>                          }
>                          up(&cmd->vars.sem);
> -                       complete(&ent->slotted);
>                          return;
>                  }
>          } else {
> --
> 2.34.1
> 

