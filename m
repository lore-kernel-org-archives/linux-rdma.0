Received: from BYAPR05CU005.outbound.protection.outlook.com (mail-westusazon11010061.outbound.protection.outlook.com [52.101.85.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9BEE15A86D;
	Tue, 28 Jul 2026 23:16:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.85.61
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785280580; cv=fail; b=CG5OsWmQ4KXpKsoUyJHTgbLeZPRAXNVEn36cc3r5OZdJcwEM0UKLo/AEa7G/2nIYkkgOX3WDs4kE+Wyo0uHcLSLN/5ZfC68+wi+rMVm8sVB/+YM6o3XEUXRqzERerfxmJQGegm9MVUneJZNKNOxXUdlaAByBJxatkgl1on/tvnQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785280580; c=relaxed/simple;
	bh=jiJd3EnQx7PiULjkU0BoMEFgQAqBwQeqtZPUiwdS8v0=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=mQbv215/DyB1BT8sL3Y03s7Lx6Y5t0F9/WC3DnEf8wCq6UZ9Tgz+pSffr6TqFy+H4Vp1CG7vj700LNa64WKEETwMwE8LfpzFmnjfdwRPlgRZLNBdDh9Ij8g61fW9k8sUxyavvfgWRGDCGOf08SZDsZl+Rb79hSy+ydq+jNPo4gY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=QLC9iJ+v; arc=fail smtp.client-ip=52.101.85.61
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="QLC9iJ+v"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fAnXHbu+eSNMJQsnzwIEEQIoMyFPNoDlxmMDCZAXXWQ2sG3wMod7iRB+g4Yry4vDUON57jBIPWOjrgxpyQ/u1bZM7Ft5r4BUJs9VoTsPdrlsIIoqT2O0cjoA9j52VhgeFUoaXCbgJvxky7oJonGqOlm3Vx82exInC1k1Uz1EA4E/a55BEYaIczQ0NaT1iT/A34S0ubgvbTV3qXxpOOK8drYg1PlPbcILKdOEEW1MtV6isF4aY/LTrGr4XcNfE/bKvfqHToebpQvcTMKXjGMm0WwFQ83Jdi7MtadLnUNbo3yY8v5MVGJWS4CieKZ+S0vDC2QoOuaAOdP9AYeVpGNaCA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bFSZBCo7Wql+KxdUBLh3KnqSVHf+veCXUy4sZxL8Hcc=;
 b=o+D3sZ/6TnwasBKBLh24wvtM1L50NQbm7FZCF184YzFWj5Gi2zU2JhnJKGak50fU0FbnXBd9BKbDhbfu3hzmGfmohZMPAts4bo1yvckGP1fInggnfJ+u+Xn27MLEHx8h9GI/3SqfzqJVdmE3EFYkxuhIq9janF2Cq2MZ7kXhswu691kX11NhKYeXGSRf047VM/C8CGUdD5IX2h6Di/XGOxMWPNCF5+A5PqmqI2tnRC5FuhmdCrrer9VkoG5M8Re7cZ9eaKoMBiLvDaEwd2e4cenlHIuuKLjpq6UC+nIxxdtY88eA5s2LuaJQReQvzJGmo0VeidadkBGOqlXnguc0Dg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bFSZBCo7Wql+KxdUBLh3KnqSVHf+veCXUy4sZxL8Hcc=;
 b=QLC9iJ+vt7C6ejVDvZChecocztj7r7oBQUrPFjpz4ZEsolPs+EPGkxe4QUbyIsei5TTJKHvnb4QgD/7IVoa8DjI0zPocIfRKBaT/aO5K5pPleyLTjtqbt06k+ZDVcgwSqIhbu/zKBdg5iPwpFhVkIuCpTRX9rR3Kgcz0FCch+dU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS4PR12MB9708.namprd12.prod.outlook.com (2603:10b6:8:278::7) by
 SAWPR12MB999140.namprd12.prod.outlook.com (2603:10b6:806:4e2::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.13; Tue, 28 Jul
 2026 23:16:13 +0000
Received: from DS4PR12MB9708.namprd12.prod.outlook.com
 ([fe80::8570:d817:2f81:c62a]) by DS4PR12MB9708.namprd12.prod.outlook.com
 ([fe80::8570:d817:2f81:c62a%6]) with mapi id 15.21.0270.009; Tue, 28 Jul 2026
 23:16:13 +0000
Message-ID: <bb6f164e-5f95-48ab-a22c-5582dcef721d@amd.com>
Date: Tue, 28 Jul 2026 16:16:10 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next 4/4] RDMA/ionic: Add DCQCN parameter
 configuration via debugfs
To: netdev@vger.kernel.org, linux-rdma@vger.kernel.org
Cc: Brett Creeley <brett.creeley@amd.com>, Andrew Lunn
 <andrew+netdev@lunn.ch>, "David S. Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, Abhijit Gangurde
 <abhijit.gangurde@amd.com>, Allen Hubbe <allen.hubbe@amd.com>,
 Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>,
 "Nikhil P . Rao" <nikhil.rao@amd.com>
References: <20260506041935.1061-1-eric.joyner@amd.com>
 <20260506041935.1061-5-eric.joyner@amd.com>
From: Eric Joyner <eric.joyner@amd.com>
Content-Language: en-US
In-Reply-To: <20260506041935.1061-5-eric.joyner@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH0PR04CA0090.namprd04.prod.outlook.com
 (2603:10b6:610:74::35) To DS4PR12MB9708.namprd12.prod.outlook.com
 (2603:10b6:8:278::7)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PR12MB9708:EE_|SAWPR12MB999140:EE_
X-MS-Office365-Filtering-Correlation-Id: d6683d33-0d64-46c8-0ce3-08deecfe3792
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|366016|1800799024|4143699003|10067099003|11063799006|5023799004|56012099006|6133799003|18002099003|22082099003|3023799007;
X-Microsoft-Antispam-Message-Info:
	yvNhxqATGyhvAYDbwLZAQepaqQDSdUsrUggiCcN24uqoDiXGFrY5Z8+K4BOCSg3d+epJI6QV+mVdu+Vci+0dcKbvGEqfP1e5h4DS80+ZGf3vGx+r2P1Z/X52kOnAVScGTvwgq61UPGmrc55IyPfiPMFq+baUoi68kToWLKpNGLg5iHnvaggVaFs+dLQMfRNq7gLMxzS0DaDdpf/sZMDOrrTcWLkoYneTSLDS/lA0lv/wk0A4H2+VbVxnhUwQ1x+hBdRqVcVfo3zRTLc46PSOmYuK8oezyrfuTjzWfxmOf4hXL3j+5IwTwnY3PRwqGeISC+RiTB2I5LLYvn171MrtjTM8MO2oFqOU9OSA26+t3qAoRsizOko1Z/VkaGPJv5QzxWC3aNmMT463iY1p7RQNHVtQ9qqfPaqOfS8vonXYBO2lne6d4Fqy5YplmMco42Y++GSkgThuZGeFLrpp4quoRuIC76ZXMLdv4Kd1oXqcaoa5GmSpxdoyc52oY1mm1Z24DE0hKtWeg51ThxJETVAHNgYSHHhMXO4ZS85npq2pJ8UG8jGqxtcyyvlK4l8ZdE/+dbtzym2IB2FTTTMmP52TfpRDgNCcGt/i+Md/epGXjAD1CoKgAK6HuVSXpM0f+H94lT6xsfqwuY32bbtpy+Tss31FazgGoOuYpWKWypCVrs4=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PR12MB9708.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(366016)(1800799024)(4143699003)(10067099003)(11063799006)(5023799004)(56012099006)(6133799003)(18002099003)(22082099003)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?cVZsMHllR3hFcmorMXFEZCtGWmswN2ZkOWFWTGZjK1I4c01OWis4b3dsYmZ3?=
 =?utf-8?B?RFJPdVJpSXJHdWNJRS9sRjc0TDFiWUYwaTlNNENlNmIzY0d4M3JFZXFiQTh4?=
 =?utf-8?B?ZHRWR0UxY1N1N0FxZEp3eDB1K09sMmtvQlRqYUVHa3BVamJrR2trVXVna1o5?=
 =?utf-8?B?dDQ5eWs1amZvK3BMbW9YT1ZLSmZCTG5Qd0p4c0pVaXM5eWpzK1VZc2xUWVM4?=
 =?utf-8?B?Njhkb3d2d2poV0J5YTAzaHp5SWJYNmpMazB6dTg3dm5yMGVqSStJam5xdHIv?=
 =?utf-8?B?T1hScWVla1NOVlBORk9ydHJiMVlKUXkwSC9LUzJpZ29NVXUrYUNvd3RibCtJ?=
 =?utf-8?B?NUFMQmlRbFg3TUoyT1Myd24rejdxODhXa052WnZrSlR4S3RVR0ZzL0loRDQr?=
 =?utf-8?B?TVFFM2Q4Ly9BcjJ3UENUVmdheWFUeHgyQzlLM3lWOWVrNndQQ2xLT2hVTTBk?=
 =?utf-8?B?alJMdzJFQjhxSzFCYTF1bmgvRm1OT045b1M3SGZySTMzOENjTFpuUUgyMGMy?=
 =?utf-8?B?U09zQTFvWGJ5NUhMYnVHMlZyUGZoZGNPdUpoSHozZWVmeFUxL0Q5bFJoZ3ZX?=
 =?utf-8?B?TW8xS2YyUkdKVW4yaTErQTkwYzAwQld0R1hET1BvTGVHQnlQS1BmRjBsRnY5?=
 =?utf-8?B?ZTRUUnFLZ2Q0bnE2dDE2bUVaME1RN1U1NzIzWGd2M1JtL2NhVWxiV3JMTWxy?=
 =?utf-8?B?THJLdEQwTjEvZHc3enpuMzY2TVg0VVl1NG01dzZCWjVIYlZSeEgwak0yT0ZE?=
 =?utf-8?B?a3dBb2s0VGQ3ZnFjeUpXSGxnUmFMYXMzdUtYczlBQTZYK0VTVjExYURDdHky?=
 =?utf-8?B?ejFIZEhTZW9IQThLZGwyYkJYbzduZ1ovSURuSDhoSGR4QkZ3cmRvaGxPY3Q4?=
 =?utf-8?B?bHBvTFBCRnM1NCt6dEFJQ2NNbGZXQm40TlczTFRyeGluQ3J3TCtCdXBJNGdk?=
 =?utf-8?B?S2pGb3hGR3EzM2s0QUJKZW1aT1dNKzJtdXZZdktLdktDMk5HU0JsQ2EwSkI0?=
 =?utf-8?B?UW1jRE5hcTJuU2tlVHhyTnJaV3pEaCsrWmdLTG1zbGhkSHRKUHF5UUNJa1My?=
 =?utf-8?B?MDZVYTJidDlQcTNRVG4rQ3Rxd012ZktyL1dhZDdhTEJ6a1VzQzR2VzZFNFI3?=
 =?utf-8?B?aVQ1akpzYTdDeDUrL0JLQ1liRzZWV1dPOXlpbzNxSTJIaVpaUlFWQjFMZzYw?=
 =?utf-8?B?VGZsZU5nTDlzQnJ2dzZIV3Y2NHNqQmYwQUxUZXcwQ2xjREQrcC9GbDJ0OTNr?=
 =?utf-8?B?cEFQOWgwVzdmVkZkL3hCRVdrU2NpUDZFaVc5aTJNUjJVWkJ6OGl1T3dZeWlB?=
 =?utf-8?B?UXpvOGR0elZHc25KWWx5Ty9uRlhuQlVsdHNXTUd5Nk9CWjE2QWNia0djb0Zy?=
 =?utf-8?B?MFNNMUVhRUNvcWhscG0zMTU2aGxiNm91NnA3YUVwd0h2UHl2OVJQbCtkb0ZX?=
 =?utf-8?B?UkFta3BWV2kwQmgvZWt4SzVlaFlRNmk4MlFOSVZRYnFDbXVlOXpwRmN4Qldm?=
 =?utf-8?B?dThEUVVlc1lEVG5Od3ZJc0REQllBdFhMU3JLUDBGaWdxOXpzVnRMUmhGVm85?=
 =?utf-8?B?bkhHR2ZLRS9DMXVNUnFNT3FSVkh6Mk91dzYwMTV0N1JVcVJkTkxNa1EvWGtJ?=
 =?utf-8?B?K25VN01XSkh5WE95aVpwZ0o3OEJ0ZGFJRWZRMHRaZysxaEdaWk44S3JwMFM3?=
 =?utf-8?B?NXNCaXlFbHhDaFU0cU5ya0tqZkQwYjN6S3RVN1I0a0lEQlNvekYzbVdqRWMr?=
 =?utf-8?B?NEtKanRodGxIZXNrUFFTc0E5ejMzRUVqSC9idWNXVGY2Z24vRVp5T2pGS3U1?=
 =?utf-8?B?SnlMRUZabjRwdmZrMFRXcFdqOHlVZ0dZVWtpVHNEOTErQ2Zickhha1BTQWxo?=
 =?utf-8?B?MTJqWVFwbDBETFpHRGVaVkR2Zkh5b0dybmUzZmpKNjA4M0JKb2VyVXExTFNG?=
 =?utf-8?B?UjQvZmJrNHAwZWFkbjJ2a0hIbkQ1QTRxYU90cUk0YlBXOVlCdlh5ZkpCcVlt?=
 =?utf-8?B?eGZZWnE2aDBsV0V6blJIMEZBZnhjbldnZ3Q2OVY3MTBnTUlPSHRzZUl1VnVo?=
 =?utf-8?B?YUl4Q2x3RS83Nk5uZldaaTF1UDUzWS9UU3J0ZlN6YnpOcXp2a096OFpoQjhz?=
 =?utf-8?B?MUYxaVBubjg3a2U5NWhXT0NWbVg2RFNORit6Q0U1NXhGMGc5MVlQTXNlL2tW?=
 =?utf-8?B?Q005YXZUSGltN0xTTGxoY2xGbHJ6OEo2WHQvaTJ5SkpTS3gzSGpDZS82K1lo?=
 =?utf-8?B?cmNTOHBZZWI4T3l3YmpWU0E5TW93eXJxUGU0bXBISE1uTHVxVE1LYk1FVkZz?=
 =?utf-8?Q?VnoRXypkF6d2ePMfaN?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d6683d33-0d64-46c8-0ce3-08deecfe3792
X-MS-Exchange-CrossTenant-AuthSource: DS4PR12MB9708.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jul 2026 23:16:13.4047
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0QTGQ3842O61kxFycfjgyo8o0rD8KZvogwiEEOpKcfWYEGucP7ywgFM7/DjGV0iY
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SAWPR12MB999140

On 5/5/2026 9:19 PM, Eric Joyner wrote:
> From: Allen Hubbe <allen.hubbe@amd.com>
> 
> The HCA supports DCQCN with multiple profiles; these are normally
> configured through a userspace utility, but expose these profiles and
> their parameters for debug purposes via debugfs.
> 
> To use these, the firmware must be configured in the mode that expects
> DCQCN settings to be programmed by the driver, otherwise the firmware
> will silently fail and indicate success without any changes actually
> occurring.
> 
> Signed-off-by: Allen Hubbe <allen.hubbe@amd.com>
> Co-developed-by: Eric Joyner <eric.joyner@amd.com>
> Signed-off-by: Eric Joyner <eric.joyner@amd.com>
> ---
>  drivers/infiniband/hw/ionic/Makefile          |   3 +-
>  .../infiniband/hw/ionic/ionic_controlpath.c   |   5 +
>  drivers/infiniband/hw/ionic/ionic_dcqcn.c     | 629 ++++++++++++++++++
>  drivers/infiniband/hw/ionic/ionic_fw.h        |  31 +
>  drivers/infiniband/hw/ionic/ionic_ibdev.c     |   4 +
>  drivers/infiniband/hw/ionic/ionic_ibdev.h     |  12 +
>  drivers/infiniband/hw/ionic/ionic_lif_cfg.c   |   1 +
>  drivers/infiniband/hw/ionic/ionic_lif_cfg.h   |   2 +
>  drivers/infiniband/hw/ionic/ionic_profiles.h  |  86 +++
>  9 files changed, 772 insertions(+), 1 deletion(-)
>  create mode 100644 drivers/infiniband/hw/ionic/ionic_dcqcn.c
>  create mode 100644 drivers/infiniband/hw/ionic/ionic_profiles.h
> 
> diff --git a/drivers/infiniband/hw/ionic/Makefile b/drivers/infiniband/hw/ionic/Makefile
> index 65bb4eaf0c13..1ad2c3d12b36 100644
> --- a/drivers/infiniband/hw/ionic/Makefile
> +++ b/drivers/infiniband/hw/ionic/Makefile
> @@ -6,4 +6,5 @@ obj-$(CONFIG_INFINIBAND_IONIC)	+= ionic_rdma.o
>  
>  ionic_rdma-y :=	\
>  	ionic_ibdev.o ionic_lif_cfg.o ionic_queue.o ionic_pgtbl.o ionic_admin.o \
> -	ionic_controlpath.o ionic_datapath.o ionic_hw_stats.o ionic_debugfs.o
> +	ionic_controlpath.o ionic_datapath.o ionic_hw_stats.o ionic_debugfs.o \
> +	ionic_dcqcn.o
> diff --git a/drivers/infiniband/hw/ionic/ionic_controlpath.c b/drivers/infiniband/hw/ionic/ionic_controlpath.c
> index 0ea053369cba..4daca85c4fb3 100644
> --- a/drivers/infiniband/hw/ionic/ionic_controlpath.c
> +++ b/drivers/infiniband/hw/ionic/ionic_controlpath.c
> @@ -1512,6 +1512,7 @@ static int ionic_modify_qp_cmd(struct ionic_ibdev *dev,
>  			cpu_to_le32(qp->ahid | (hdr_len << 24));
>  		wr.wqe.cmd.mod_qp.dma_addr = cpu_to_le64(hdr_dma);
>  
> +		wr.wqe.cmd.mod_qp.dcqcn_profile = qp->dcqcn_profile;
>  		wr.wqe.cmd.mod_qp.en_pcp = attr->ah_attr.sl;
>  		wr.wqe.cmd.mod_qp.ip_dscp = grh->traffic_class >> 2;
>  	}
> @@ -2586,6 +2587,10 @@ int ionic_modify_qp(struct ib_qp *ibqp, struct ib_qp_attr *attr, int mask,
>  	if (mask & IB_QP_CAP)
>  		return -EINVAL;
>  
> +	if (mask & IB_QP_AV)
> +		qp->dcqcn_profile =
> +		    ionic_dcqcn_select_profile(dev, &attr->ah_attr);
> +
>  	rc = ionic_modify_qp_cmd(dev, pd, qp, attr, mask);
>  	if (rc)
>  		return rc;
> diff --git a/drivers/infiniband/hw/ionic/ionic_dcqcn.c b/drivers/infiniband/hw/ionic/ionic_dcqcn.c
> new file mode 100644
> index 000000000000..80fa79cfd951
> --- /dev/null
> +++ b/drivers/infiniband/hw/ionic/ionic_dcqcn.c
> @@ -0,0 +1,629 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/* Copyright (C) 2018-2026, Advanced Micro Devices, Inc. */
> +
> +#include <linux/debugfs.h>
> +
> +#include "ionic_ibdev.h"
> +#include "ionic_profiles.h"
> +
> +static const struct ionic_profile_vals dcqcn_defaults[] = {
> +	{
> +		.v[NP_ICNP_802P_PRIO]			= 6,
> +		.v[NP_CNP_DSCP]				= 46,
> +		.v[RP_TOKEN_BUCKET_SIZE]		= 800000,
> +		.v[RP_INITIAL_ALPHA_VALUE]		= 64,
> +		.v[RP_DCE_TCP_G]			= 512,
> +		.v[RP_DCE_TCP_RTT]			= 1,
> +		.v[RP_RATE_REDUCE_MONITOR_PERIOD]	= 1,
> +		.v[RP_MIN_RATE]				= 1,
> +		.v[RP_GD]				= 11,
> +		.v[RP_MIN_DEC_FAC]			= 50,
> +		.v[RP_CLAMP_TGT_RATE_ATI]		= 1,
> +		.v[RP_THRESHOLD]			= 1,
> +		.v[RP_TIME_RESET]			= 1,
> +		.v[RP_QP_RATE]				= 100000,
> +		.v[RP_BYTE_RESET]			= 431068,
> +		.v[RP_AI_RATE]				= 160,
> +		.v[RP_HAI_RATE]				= 300,
> +	},
> +};
> +
> +#define DCQCN_INT_ATTR(_min, _max, _name) \
> +	{ .min = (_min), .max = (_max), .name = (_name) }
> +
> +#define DCQCN_BOOL_ATTR(_name) \
> +	DCQCN_INT_ATTR(0, 1, _name)
> +
> +static const struct ionic_dcqcn_param_attr dcqcn_attrs[] = {
> +	/* under "roce_np" */
> +	DCQCN_INT_ATTR(0, 7, "icnp_802p_prio"),
> +	DCQCN_INT_ATTR(0, 63, "cnp_dscp"),
> +	/* under "roce_rp" */
> +	DCQCN_INT_ATTR(100, 200000000, "token_bucket_size"),
> +	DCQCN_INT_ATTR(0, 1023, "initial_alpha_value"),
> +	DCQCN_INT_ATTR(0, 1023, "dce_tcp_g"),
> +	DCQCN_INT_ATTR(1, 131071, "dce_tcp_rtt"),
> +	DCQCN_INT_ATTR(1, INT_MAX, "rate_reduce_monitor_period"),
> +	DCQCN_INT_ATTR(1, INT_MAX, "rate_to_set_on_first_cnp"),
> +	DCQCN_INT_ATTR(1, INT_MAX, "min_rate"),
> +	DCQCN_INT_ATTR(1, 11, "gd"),
> +	DCQCN_INT_ATTR(0, 100, "min_dec_fac"),
> +	DCQCN_BOOL_ATTR("clamp_tgt_rate"),
> +	DCQCN_BOOL_ATTR("clamp_tgt_rate_ati"),
> +	DCQCN_INT_ATTR(1, 31, "threshold"),
> +	DCQCN_INT_ATTR(1, 32767, "time_reset"),
> +	DCQCN_INT_ATTR(1, INT_MAX, "qp_rate"),
> +	DCQCN_INT_ATTR(1, INT_MAX, "byte_reset"),
> +	DCQCN_INT_ATTR(1, INT_MAX, "ai_rate"),
> +	DCQCN_INT_ATTR(1, INT_MAX, "hai_rate"),
> +};
> +
> +static void dcqcn_set_profile(struct ionic_profile *profile)
> +{
> +	struct ionic_ibdev *dev = profile->dev;
> +	struct ionic_admin_wr wr = {
> +		.work = COMPLETION_INITIALIZER_ONSTACK(wr.work),
> +		.wqe = {
> +			.op = IONIC_V1_ADMIN_MODIFY_DCQCN,
> +			.len = cpu_to_le16(IONIC_ADMIN_MODIFY_DCQCN_IN_V1_LEN),
> +			.cmd.mod_dcqcn = {
> +				.id_ver = cpu_to_le32(profile->idx + 1),
> +			}
> +		}
> +	};
> +	int rc;
> +
> +	wr.wqe.cmd.mod_dcqcn.np_incp_802p_prio =
> +		profile->vals.v[NP_ICNP_802P_PRIO];
> +
> +	wr.wqe.cmd.mod_dcqcn.np_cnp_dscp =
> +		profile->vals.v[NP_CNP_DSCP];
> +
> +	wr.wqe.cmd.mod_dcqcn.rp_token_bucket_size =
> +		cpu_to_be64(profile->vals.v[RP_TOKEN_BUCKET_SIZE]);
> +
> +	wr.wqe.cmd.mod_dcqcn.rp_initial_alpha_value =
> +		cpu_to_be16(profile->vals.v[RP_INITIAL_ALPHA_VALUE]);
> +
> +	wr.wqe.cmd.mod_dcqcn.rp_dce_tcp_g =
> +		cpu_to_be16(profile->vals.v[RP_DCE_TCP_G]);
> +
> +	wr.wqe.cmd.mod_dcqcn.rp_dce_tcp_rtt =
> +		cpu_to_be32(profile->vals.v[RP_DCE_TCP_RTT]);
> +
> +	wr.wqe.cmd.mod_dcqcn.rp_rate_reduce_monitor_period =
> +		cpu_to_be32(profile->vals.v[RP_RATE_REDUCE_MONITOR_PERIOD]);
> +
> +	wr.wqe.cmd.mod_dcqcn.rp_rate_to_set_on_first_cnp =
> +		cpu_to_be32(profile->vals.v[RP_RATE_TO_SET_ON_FIRST_CNP]);
> +
> +	wr.wqe.cmd.mod_dcqcn.rp_min_rate =
> +		cpu_to_be32(profile->vals.v[RP_MIN_RATE]);
> +
> +	wr.wqe.cmd.mod_dcqcn.rp_gd =
> +		profile->vals.v[RP_GD];
> +
> +	wr.wqe.cmd.mod_dcqcn.rp_min_dec_fac =
> +		profile->vals.v[RP_MIN_DEC_FAC];
> +
> +	if (profile->vals.v[RP_CLAMP_TGT_RATE])
> +		wr.wqe.cmd.mod_dcqcn.rp_clamp_flags |= IONIC_RPF_CLAMP_TGT_RATE;
> +
> +	if (profile->vals.v[RP_CLAMP_TGT_RATE_ATI])
> +		wr.wqe.cmd.mod_dcqcn.rp_clamp_flags |=
> +			IONIC_RPF_CLAMP_TGT_RATE_ATI;
> +
> +	wr.wqe.cmd.mod_dcqcn.rp_threshold =
> +		profile->vals.v[RP_THRESHOLD];
> +
> +	wr.wqe.cmd.mod_dcqcn.rp_time_reset =
> +		cpu_to_be32(profile->vals.v[RP_TIME_RESET]);
> +
> +	wr.wqe.cmd.mod_dcqcn.rp_qp_rate =
> +		cpu_to_be32(profile->vals.v[RP_QP_RATE]);
> +
> +	wr.wqe.cmd.mod_dcqcn.rp_byte_reset =
> +		cpu_to_be32(profile->vals.v[RP_BYTE_RESET]);
> +
> +	wr.wqe.cmd.mod_dcqcn.rp_ai_rate =
> +		cpu_to_be32(profile->vals.v[RP_AI_RATE]);
> +
> +	wr.wqe.cmd.mod_dcqcn.rp_hai_rate =
> +		cpu_to_be32(profile->vals.v[RP_HAI_RATE]);
> +
> +	ionic_admin_post(dev, &wr);
> +	rc = ionic_admin_wait(dev, &wr, IONIC_ADMIN_F_INTERRUPT);
> +	if (rc)
> +		ibdev_warn(&dev->ibdev, "dcqcn profile %d not set, error %d\n",
> +			   profile->idx + 1, rc);
> +}
> +
> +static int dcqcn_param_show(struct seq_file *s, void *v)
> +{
> +	struct ionic_dcqcn_param_entry *entry = s->private;
> +	struct ionic_profile *profile = entry->profile;
> +	int val = profile->vals.v[entry->var];
> +
> +	seq_printf(s, "%d\n", val);
> +	return 0;
> +}
> +
> +static ssize_t dcqcn_param_write(struct file *fp, const char __user *ubuf,
> +				 size_t count, loff_t *ppos)
> +{
> +	struct seq_file *s = fp->private_data;
> +	struct ionic_dcqcn_param_entry *entry;
> +	struct ionic_profile *profile;
> +	int rc, val;
> +	char *buf;
> +
> +	entry = s->private;
> +	profile = entry->profile;
> +
> +	buf = memdup_user_nul(ubuf, count);
> +	if (IS_ERR(buf))
> +		return PTR_ERR(buf);
> +
> +	rc = kstrtoint(buf, 0, &val);
> +	if (rc < 0)
> +		goto out;
> +
> +	if (val < dcqcn_attrs[entry->var].min ||
> +	    val > dcqcn_attrs[entry->var].max) {
> +		rc = -EINVAL;
> +		goto out;
> +	}
> +
> +	profile->vals.v[entry->var] = val;
> +
> +	dcqcn_set_profile(profile);
> +out:
> +	kfree(buf);
> +	return rc ?: count;
> +}
> +DEFINE_SHOW_STORE_ATTRIBUTE(dcqcn_param);
> +
> +static const struct ionic_profile_vals *dcqcn_get_defaults(int prof_i)
> +{
> +	if (prof_i < 0 || prof_i >= ARRAY_SIZE(dcqcn_defaults))
> +		return &dcqcn_defaults[0];
> +
> +	return &dcqcn_defaults[prof_i];
> +}
> +
> +static int dcqcn_match_default_show(struct seq_file *s, void *v)
> +{
> +	struct ionic_profile_root *profile_root = s->private;
> +	int val = profile_root->profiles_default;
> +
> +	seq_printf(s, "%d\n", val);
> +	return 0;
> +}
> +
> +static ssize_t dcqcn_match_default_write(struct file *fp, const char __user *ubuf,
> +					 size_t count, loff_t *ppos)
> +{
> +	struct ionic_profile_root *profile_root;
> +	struct seq_file *s = fp->private_data;
> +	int rc, val;
> +	char *buf;
> +
> +	profile_root = s->private;
> +
> +	buf = memdup_user_nul(ubuf, count);
> +	if (IS_ERR(buf))
> +		return PTR_ERR(buf);
> +
> +	rc = kstrtoint(buf, 0, &val);
> +	if (rc < 0)
> +		goto out;
> +
> +	if (val < 0 || val > profile_root->profiles_count) {
> +		rc = -EINVAL;
> +		goto out;
> +	}
> +
> +	profile_root->profiles_default = val;
> +
> +out:
> +	kfree(buf);
> +	return rc ?: count;
> +}
> +DEFINE_SHOW_STORE_ATTRIBUTE(dcqcn_match_default);
> +
> +static int dcqcn_match_rules_show(struct seq_file *s, void *v)
> +{
> +	struct ionic_profile_root *profile_root = s->private;
> +	struct ionic_match_rule *rule, *rules;
> +	unsigned long irqflags;
> +	int i, rules_count;
> +
> +	spin_lock_irqsave(&profile_root->rules_lock, irqflags);
> +
> +	rules = profile_root->rules;
> +	rules_count = profile_root->rules_count;
> +	for (i = 0; i < rules_count; ++i) {
> +		rule = &rules[i];
> +		seq_printf(s, "%s %d %d\n", rule->name, rule->cond, rule->prof);
> +	}
> +
> +	spin_unlock_irqrestore(&profile_root->rules_lock, irqflags);
> +
> +	return 0;
> +}
> +
> +static bool ionic_match_prio(struct rdma_ah_attr *attr, int cond)
> +{
> +	int prio = attr->sl;
> +
> +	return prio >= 0 && prio < 8 && (cond & BIT(prio));
> +}
> +
> +static bool ionic_match_gid(struct rdma_ah_attr *attr, int cond)
> +{
> +	int gid = rdma_ah_read_grh(attr)->sgid_index;
> +
> +	return gid == cond;
> +}
> +
> +static bool ionic_parse_rule_name(const char *name, const char *buf, int count)
> +{
> +	return !strncmp(name, buf, count) && !name[count];
> +}
> +
> +static int ionic_parse_match_rules(const char *buf, size_t count,
> +				   int prof_count, int rules_count,
> +				   struct ionic_match_rule *rules)
> +{
> +	bool (*match)(struct rdma_ah_attr *attr, int cond);
> +	struct ionic_match_rule *rule;
> +	int cmd, cond, prof, end;
> +	int rc, rule_i = 0;
> +	const char *name;
> +
> +	for (;; ++rule_i) {
> +		/* skip leading whitespace */
> +
> +		rc = sscanf(buf, " %n", &end);
> +		if (rc != 0)
> +			return -EINVAL;
> +
> +		buf += end;
> +		count -= end;
> +
> +		/* break at end of buffer */
> +
> +		if (!count)
> +			break;
> +
> +		/* Parse one rule, as:
> +		 * <name> <condition> <profile>
> +		 *
> +		 * Name and condition determine when a rule will be a match.
> +		 * If a rule is a match, then use the inidcated DCQCN profile.
> +		 *
> +		 * If name eq "gid":
> +		 * then condition is a gid index.
> +		 *
> +		 * eg: gid 5 3 -> for gid index 5, use profile 3.
> +		 *
> +		 * If name eq "prio":
> +		 * then condition is a bitmask of 802.1p priorities.
> +		 *
> +		 * eg: prio 0xc 1 -> for 802.1p priority 2 or 3, use profile 1.
> +		 */
> +
> +		rc = sscanf(buf, "%*s%n%i%i%n", &cmd, &cond, &prof, &end);
> +		if (rc != 2)
> +			return -EINVAL;
> +
> +		/* rule name in first `cmd` chars of `buf` */
> +
> +		if (ionic_parse_rule_name("gid", buf, cmd)) {
> +			match = ionic_match_gid;
> +			name = "gid";
> +		} else if (ionic_parse_rule_name("prio", buf, cmd)) {
> +			match = ionic_match_prio;
> +			name = "prio";
> +		} else {
> +			return -EINVAL;
> +		}
> +
> +		if (prof < 0 || prof > prof_count)
> +			return -EINVAL;
> +
> +		if (rule_i < rules_count) {
> +			rule = &rules[rule_i];
> +			rule->match = match;
> +			rule->name = name;
> +			rule->cond = cond;
> +			rule->prof = prof;
> +		}
> +
> +		buf += end;
> +		count -= end;
> +	}
> +
> +	return rule_i;
> +}
> +
> +static ssize_t dcqcn_match_rules_write(struct file *fp,
> +				       const char __user *ubuf,
> +				       size_t count, loff_t *ppos)
> +{
> +	struct ionic_profile_root *profile_root;
> +	struct seq_file *s = fp->private_data;
> +	unsigned long irqflags;
> +	int rc, rules_count;
> +	char *buf;
> +
> +	profile_root = s->private;
> +
> +	buf = memdup_user_nul(ubuf, count);
> +	if (IS_ERR(buf))
> +		return PTR_ERR(buf);
> +
> +	/* validate and count rules */
> +	rc = ionic_parse_match_rules(buf, count, profile_root->profiles_count,
> +				     0, NULL);
> +	if (rc < 0)
> +		goto out;
> +
> +	rules_count = rc;
> +	rc = 0;
> +
> +	/* clear previous rules */
> +	spin_lock_irqsave(&profile_root->rules_lock, irqflags);
> +	profile_root->rules_count = 0;
> +	spin_unlock_irqrestore(&profile_root->rules_lock, irqflags);
> +
> +	kfree(profile_root->rules);
> +	profile_root->rules = NULL;
> +
> +	/* assign new rules */
> +	if (rules_count) {
> +		profile_root->rules = kzalloc_objs(*profile_root->rules,
> +						   rules_count);
> +		if (!profile_root->rules) {
> +			rc = -ENOMEM;
> +			goto out;
> +		}
> +
> +		ionic_parse_match_rules(buf, count, profile_root->profiles_count,
> +					rules_count, profile_root->rules);
> +
> +		spin_lock_irqsave(&profile_root->rules_lock, irqflags);
> +		profile_root->rules_count = rules_count;
> +		spin_unlock_irqrestore(&profile_root->rules_lock, irqflags);
> +	}
> +out:
> +	kfree(buf);
> +	return rc ?: count;
> +}
> +DEFINE_SHOW_STORE_ATTRIBUTE(dcqcn_match_rules);
> +
> +static ssize_t dcqcn_profile_reset(struct file *fp, const char __user *ubuf,
> +				   size_t count, loff_t *ppos)
> +{
> +	struct ionic_profile *profile = fp->private_data;
> +	int rc = 0;
> +	char *buf;
> +
> +	buf = memdup_user_nul(ubuf, 2);
> +	if (IS_ERR(buf))
> +		return PTR_ERR(buf);
> +
> +	if (strcmp(buf, "1") && strcmp(buf, "1\n")) {
> +		rc = -EINVAL;
> +		goto out;
> +	}
> +
> +	profile->vals = *dcqcn_get_defaults(profile->idx);
> +	dcqcn_set_profile(profile);
> +
> +out:
> +	kfree(buf);
> +	return rc ?: count;
> +}
> +
> +static const struct file_operations dcqcn_profile_reset_fops = {
> +	.owner = THIS_MODULE,
> +	.open = simple_open,
> +	.write = dcqcn_profile_reset,
> +};
> +
> +static void ionic_dcqcn_add_profile_params(struct ionic_profile *profile)
> +{
> +	struct ionic_dcqcn_param_entry *entry;
> +	struct dentry *dentry;
> +	int i;
> +
> +	for (i = 0; i < DCQCN_VAR_COUNT; i++) {
> +		entry = &profile->entries[i];
> +
> +		entry->profile = profile;
> +		entry->var = i;
> +
> +		if (i <= NP_CNP_DSCP)
> +			dentry = profile->roce_np_debug;
> +		else
> +			dentry = profile->roce_rp_debug;
> +
> +		debugfs_create_file(dcqcn_attrs[i].name, 0640, dentry, entry,
> +				    &dcqcn_param_fops);
> +	}
> +}
> +
> +int ionic_dcqcn_init(struct ionic_ibdev *dev, int prof_count)
> +{
> +	const enum ionic_profile_type type = IONIC_PROFILE_TYPE_DCQCN;
> +	struct ionic_profile_root *profile_root;
> +	int rc, i;
> +
> +	if (!prof_count)
> +		return 0;
> +
> +	dev->profile[type] = kzalloc_obj(*dev->profile[type]);
> +	if (!dev->profile[type]) {
> +		rc = -ENOMEM;
> +		goto err_cb_alloc;
> +	}
> +
> +	profile_root = dev->profile[type];
> +	profile_root->dev = dev;
> +
> +	spin_lock_init(&profile_root->rules_lock);
> +
> +	profile_root->debug = debugfs_create_dir("dcqcn", dev->debug);
> +	if (IS_ERR(profile_root->debug)) {
> +		profile_root->debug = NULL;
> +		goto err_cb_dentry;
> +	}
> +
> +	debugfs_create_file("match_default", 0640, profile_root->debug,
> +			    profile_root, &dcqcn_match_default_fops);
> +	debugfs_create_file("match_rules", 0640, profile_root->debug,
> +			    profile_root, &dcqcn_match_rules_fops);
> +
> +	profile_root->profiles_debug = debugfs_create_dir("profiles",
> +							  profile_root->debug);
> +	if (IS_ERR(profile_root->profiles_debug)) {
> +		profile_root->profiles_debug = NULL;
> +		goto err_prof_dentry;
> +	}
> +
> +	profile_root->profiles = kzalloc_objs(*profile_root->profiles,
> +					      prof_count);
> +	if (!profile_root->profiles) {
> +		rc = -ENOMEM;
> +		goto err_prof_alloc;
> +	}
> +
> +	profile_root->profiles_default = 0;
> +
> +	for (i = 0; i < prof_count; ++i) {
> +		struct ionic_profile *profile = &profile_root->profiles[i];
> +		char name[8];
> +
> +		profile->dev = dev;
> +		profile->vals = *dcqcn_get_defaults(i);
> +		profile->idx = i;
> +
> +		dcqcn_set_profile(profile);
> +
> +		snprintf(name, sizeof(name), "%d", i + 1);
> +		profile->debug = debugfs_create_dir(name,
> +						 profile_root->profiles_debug);
> +		if (IS_ERR(profile->debug)) {
> +			profile->debug = NULL;
> +			break;
> +		}
> +
> +		debugfs_create_file("reset", 0640, profile->debug, profile,
> +				    &dcqcn_profile_reset_fops);
> +
> +		profile->entries = kzalloc_objs(*profile->entries,
> +						DCQCN_VAR_COUNT);
> +
> +		profile->roce_np_debug = debugfs_create_dir("roce_np",
> +							    profile->debug);
> +		if (IS_ERR(profile->roce_np_debug)) {
> +			profile->roce_np_debug = NULL;
> +			break;
> +		}
> +
> +		profile->roce_rp_debug = debugfs_create_dir("roce_rp",
> +							    profile->debug);
> +		if (IS_ERR(profile->roce_rp_debug)) {
> +			profile->roce_rp_debug = NULL;
> +			break;
> +		}
> +
> +		ionic_dcqcn_add_profile_params(profile);
> +	}
> +
> +	if (!i)
> +		goto err_prof_init;
> +
> +	profile_root->profiles_count = i;
> +	if (i != prof_count) {
> +		ibdev_warn(&dev->ibdev,
> +			   "dcqcn initialized %d out of %d profiles\n",
> +			   i, prof_count);
> +	}
> +	return 0;
> +
> +err_prof_init:
> +	kfree(profile_root->profiles);
> +err_prof_alloc:
> +	debugfs_remove_recursive(profile_root->profiles_debug);
> +err_prof_dentry:
> +	debugfs_remove_recursive(profile_root->debug);
> +err_cb_dentry:
> +	kfree(dev->profile[type]);
> +	dev->profile[type] = NULL;
> +err_cb_alloc:
> +	ibdev_warn(&dev->ibdev, "dcqcn failed init, error %d\n", rc);
> +	return rc;
> +}
> +
> +void ionic_dcqcn_destroy(struct ionic_ibdev *dev)
> +{
> +	struct ionic_profile_root *profile_root;
> +	int i, prof_count;
> +
> +	profile_root = dev->profile[IONIC_PROFILE_TYPE_DCQCN];
> +
> +	if (!profile_root)
> +		return;
> +	prof_count = profile_root->profiles_count;
> +	for (i = 0; i < prof_count; ++i) {
> +		struct ionic_profile *profile;
> +
> +		profile = &profile_root->profiles[i];
> +
> +		kfree(profile->entries);
> +		debugfs_remove_recursive(profile->debug);
> +	}
> +
> +	debugfs_remove_recursive(profile_root->profiles_debug);
> +	kfree(profile_root->rules);
> +	kfree(profile_root->profiles);
> +
> +	debugfs_remove_recursive(profile_root->debug);
> +
> +	kfree(profile_root);
> +	dev->profile[IONIC_PROFILE_TYPE_DCQCN] = NULL;
> +}
> +
> +int ionic_dcqcn_select_profile(struct ionic_ibdev *dev,
> +			       struct rdma_ah_attr *attr)
> +{
> +	struct ionic_profile_root *profile_root;
> +	struct ionic_match_rule *rule, *rules;
> +	int i, rules_count, prof;
> +	unsigned long irqflags;
> +
> +	if (!dev->profile[IONIC_PROFILE_TYPE_DCQCN])
> +		return 0;
> +
> +	profile_root = dev->profile[IONIC_PROFILE_TYPE_DCQCN];
> +
> +	spin_lock_irqsave(&profile_root->rules_lock, irqflags);
> +
> +	prof = profile_root->profiles_default;
> +	rules = profile_root->rules;
> +	rules_count = profile_root->rules_count;
> +
> +	for (i = 0; i < rules_count; ++i) {
> +		rule = &rules[i];
> +		if (rule->match(attr, rule->cond)) {
> +			prof = rule->prof;
> +			break;
> +		}
> +	}
> +
> +	spin_unlock_irqrestore(&profile_root->rules_lock, irqflags);
> +
> +	return prof;
> +}
> diff --git a/drivers/infiniband/hw/ionic/ionic_fw.h b/drivers/infiniband/hw/ionic/ionic_fw.h
> index 0806c148faf2..eb463afe2305 100644
> --- a/drivers/infiniband/hw/ionic/ionic_fw.h
> +++ b/drivers/infiniband/hw/ionic/ionic_fw.h
> @@ -838,6 +838,36 @@ struct ionic_admin_query_qp {
>  static_assert(sizeof(struct ionic_admin_query_qp) ==
>  	       IONIC_ADMIN_QUERY_QP_IN_V1_LEN);
>  
> +enum ionic_v1_dcqcn_flags {
> +	IONIC_RPF_CLAMP_TGT_RATE	= BIT(0),
> +	IONIC_RPF_CLAMP_TGT_RATE_ATI	= BIT(1),
> +};
> +
> +struct ionic_admin_mod_dcqcn {
> +	__u8		np_incp_802p_prio;
> +	__u8		np_cnp_dscp;
> +	__be16		rp_dce_tcp_g;
> +	__be32		rp_dce_tcp_rtt;
> +	__be32		rp_rate_reduce_monitor_period;
> +	__be32		rp_rate_to_set_on_first_cnp;
> +	__be32		rp_min_rate;
> +	__be16		rp_initial_alpha_value;
> +	__u8		rp_gd;
> +	__u8		rp_min_dec_fac;
> +	__u8		rp_clamp_flags;
> +	__u8		rp_threshold;
> +	__be16		rp_time_reset;
> +	__be32		rp_qp_rate;
> +	__be32		rp_byte_reset;
> +	__be32		rp_ai_rate;
> +	__be32		rp_hai_rate;
> +	__le32		id_ver;
> +	__be64		rp_token_bucket_size;
> +} __packed;
> +
> +#define IONIC_ADMIN_MODIFY_DCQCN_IN_V1_LEN 56
> +static_assert(sizeof(struct ionic_admin_mod_dcqcn) == IONIC_ADMIN_MODIFY_DCQCN_IN_V1_LEN);
> +
>  #define ADMIN_WQE_STRIDE	64
>  #define ADMIN_WQE_HDR_LEN	4
>  
> @@ -860,6 +890,7 @@ struct ionic_v1_admin_wqe {
>  		struct ionic_admin_destroy_qp destroy_qp;
>  		struct ionic_admin_mod_qp mod_qp;
>  		struct ionic_admin_query_qp query_qp;
> +		struct ionic_admin_mod_dcqcn mod_dcqcn;
>  	} cmd;
>  };
>  
> diff --git a/drivers/infiniband/hw/ionic/ionic_ibdev.c b/drivers/infiniband/hw/ionic/ionic_ibdev.c
> index 69e6164e0f1e..2d89a4139d5a 100644
> --- a/drivers/infiniband/hw/ionic/ionic_ibdev.c
> +++ b/drivers/infiniband/hw/ionic/ionic_ibdev.c
> @@ -290,6 +290,8 @@ static void ionic_destroy_resids(struct ionic_ibdev *dev)
>  static void ionic_destroy_ibdev(struct ionic_ibdev *dev)
>  {
>  	ionic_kill_rdma_admin(dev, false);
> +
> +	ionic_dcqcn_destroy(dev);
>  	ib_unregister_device(&dev->ibdev);
>  	ionic_stats_cleanup(dev);
>  	ionic_destroy_rdma_admin(dev);
> @@ -357,6 +359,8 @@ static struct ionic_ibdev *ionic_create_ibdev(struct ionic_aux_dev *ionic_adev)
>  	if (rc)
>  		goto err_register;
>  
> +	ionic_dcqcn_init(dev, dev->lif_cfg.dcqcn_profiles);
> +
>  	return dev;
>  
>  err_register:
> diff --git a/drivers/infiniband/hw/ionic/ionic_ibdev.h b/drivers/infiniband/hw/ionic/ionic_ibdev.h
> index 300d17882db5..cf909b14395a 100644
> --- a/drivers/infiniband/hw/ionic/ionic_ibdev.h
> +++ b/drivers/infiniband/hw/ionic/ionic_ibdev.h
> @@ -74,6 +74,11 @@ enum ionic_mmap_flag {
>  	IONIC_MMAP_WC = BIT(0),
>  };
>  
> +enum ionic_profile_type {
> +	IONIC_PROFILE_TYPE_DCQCN,
> +	IONIC_PROFILE_TYPE_MAX,
> +};
> +
>  struct ionic_mmap_entry {
>  	struct rdma_user_mmap_entry rdma_entry;
>  	unsigned long size;
> @@ -123,6 +128,7 @@ struct ionic_ibdev {
>  	struct dentry		*debug_qp;
>  
>  	int			hw_stats_count;
> +	struct ionic_profile_root	*profile[IONIC_PROFILE_TYPE_MAX];
>  };
>  
>  struct ionic_eq {
> @@ -543,4 +549,10 @@ void ionic_dbg_rm_mr(struct ionic_mr *mr);
>  void ionic_dbg_add_qp(struct ionic_ibdev *dev, struct ionic_qp *qp);
>  void ionic_dbg_rm_qp(struct ionic_qp *qp);
>  
> +/* ionic_dcqcn.c */
> +int ionic_dcqcn_init(struct ionic_ibdev *dev, int prof_count);
> +void ionic_dcqcn_destroy(struct ionic_ibdev *dev);
> +int ionic_dcqcn_select_profile(struct ionic_ibdev *dev,
> +			       struct rdma_ah_attr *attr);
> +
>  #endif /* _IONIC_IBDEV_H_ */
> diff --git a/drivers/infiniband/hw/ionic/ionic_lif_cfg.c b/drivers/infiniband/hw/ionic/ionic_lif_cfg.c
> index 53e41b1b3e8d..71aaf8d83f9c 100644
> --- a/drivers/infiniband/hw/ionic/ionic_lif_cfg.c
> +++ b/drivers/infiniband/hw/ionic/ionic_lif_cfg.c
> @@ -93,6 +93,7 @@ void ionic_fill_lif_cfg(struct ionic_lif *lif, struct ionic_lif_cfg *cfg)
>  	    !!(lif->qtype_info[IONIC_QTYPE_RXQ].features & IONIC_QIDENT_F_EXPDB);
>  
>  	cfg->dbg_ctx = lif->dentry;
> +	cfg->dcqcn_profiles = ident->rdma.dcqcn_profiles;
>  }
>  
>  struct net_device *ionic_lif_netdev(struct ionic_lif *lif)
> diff --git a/drivers/infiniband/hw/ionic/ionic_lif_cfg.h b/drivers/infiniband/hw/ionic/ionic_lif_cfg.h
> index 500925c429f6..1e005400a0fa 100644
> --- a/drivers/infiniband/hw/ionic/ionic_lif_cfg.h
> +++ b/drivers/infiniband/hw/ionic/ionic_lif_cfg.h
> @@ -58,6 +58,8 @@ struct ionic_lif_cfg {
>  	bool sq_expdb;
>  	bool rq_expdb;
>  	u8 expdb_mask;
> +
> +	u8 dcqcn_profiles;
>  };
>  
>  void ionic_fill_lif_cfg(struct ionic_lif *lif, struct ionic_lif_cfg *cfg);
> diff --git a/drivers/infiniband/hw/ionic/ionic_profiles.h b/drivers/infiniband/hw/ionic/ionic_profiles.h
> new file mode 100644
> index 000000000000..a6cdd5992460
> --- /dev/null
> +++ b/drivers/infiniband/hw/ionic/ionic_profiles.h
> @@ -0,0 +1,86 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/* Copyright (C) 2018-2026, Advanced Micro Devices, Inc. */
> +
> +#ifndef _IONIC_PROFILES_H_
> +#define _IONIC_PROFILES_H_
> +
> +#include "ionic_ibdev.h"
> +
> +enum ionic_dcqcn_var {
> +	/* notification point */
> +	NP_ICNP_802P_PRIO,		/* 0..7 (prio) */
> +	NP_CNP_DSCP,			/* 0..63 (dscp) */
> +
> +	RP_TOKEN_BUCKET_SIZE,		/* 100..200000000 (100kb - 200gb) */
> +	/* reaction point alpha update */
> +	RP_INITIAL_ALPHA_VALUE,		/* 0..1023 */
> +	RP_DCE_TCP_G,			/* 0..1023 */
> +	RP_DCE_TCP_RTT,			/* 1..131071 (us) */
> +
> +	/* reaction point rate decrease */
> +	RP_RATE_REDUCE_MONITOR_PERIOD,	/* 1.. (us) */
> +	RP_RATE_TO_SET_ON_FIRST_CNP,	/* 0 disable, 1.. (Mbps) */
> +	RP_MIN_RATE,			/* 1.. (Mbps) */
> +	RP_GD,				/* 1..11 */
> +	RP_MIN_DEC_FAC,			/* 0..100 (%) */
> +
> +	/* reaction point rate increase */
> +	RP_CLAMP_TGT_RATE,		/* 0..1 (bool) */
> +	RP_CLAMP_TGT_RATE_ATI,		/* 0..1 (bool) */
> +	RP_THRESHOLD,			/* 1..31 */
> +	RP_TIME_RESET,			/* 1..32767 (x RP_DCE_TCP_RTT) */
> +	RP_QP_RATE,			/* 1.. (Mbps) */
> +	RP_BYTE_RESET,			/* 1..4294967296 (B) */
> +	RP_AI_RATE,			/* 1.. (Mbps) */
> +	RP_HAI_RATE,			/* 1.. (Mbps) */
> +
> +	DCQCN_VAR_COUNT
> +};
> +
> +struct ionic_match_rule {
> +	bool			(*match)(struct rdma_ah_attr *attr, int cond);
> +	const char		*name;
> +	int			cond;
> +	int			prof;
> +};
> +
> +struct ionic_profile_vals {
> +	int			v[DCQCN_VAR_COUNT];
> +};
> +
> +struct ionic_dcqcn_param_attr {
> +	char			*name;
> +	int			min;
> +	int			max;
> +};
> +
> +struct ionic_dcqcn_param_entry {
> +	struct ionic_profile	*profile;
> +	enum ionic_dcqcn_var	var;
> +};
> +
> +struct ionic_profile {
> +	struct ionic_ibdev		*dev;
> +	struct ionic_profile_vals	vals;
> +	struct ionic_dcqcn_param_entry	*entries;
> +	int idx;
> +
> +	struct dentry			*debug;
> +	struct dentry			*roce_np_debug;
> +	struct dentry			*roce_rp_debug;
> +};
> +
> +struct ionic_profile_root {
> +	struct ionic_ibdev	*dev;
> +	int			profiles_default;
> +	int			profiles_count;
> +	struct ionic_profile	*profiles;
> +	spinlock_t		rules_lock;	/* lock to atomic update the rules */
> +	int			rules_count;
> +	struct ionic_match_rule	*rules;
> +
> +	struct dentry		*debug;
> +	struct dentry		*profiles_debug;
> +};
> +
> +#endif /* _IONIC_PROFILES_H_ */

Leon,

From this thread for Patch 3:
https://lore.kernel.org/linux-rdma/20260514163540.GT15586@unreal/, I understand
that it's too large and it's exposing too much information; I can shrink that
down and remove the entries there.

But before I make changes and resubmit, is what this patch is doing okay? It
adds DCQCN configuration parameters so that they can be written to in debugfs
and propagated to the firmware? Would this be considered too much meddling with
the firmware in debugfs, too? We want to have a driver-configured mode for DCQCN
and possibly other congestion control profiles.

- Eric
