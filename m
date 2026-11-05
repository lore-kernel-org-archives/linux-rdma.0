Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.62.7
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793860952;
	b=3r1BDlXKagxqNdqPmkmDiarSK5uko7j9UpTiL21OwXX6ZPu5+obveKYrPr/qOdNJTGKo
	 nI50yBaDP3j4ux92uBUtTIxG/laznfBjhSELHD/OHKUdq2vHkYya69swWSBZAVQCn+g5o
	 XB35jycEn57EONkGODKSTlouhRemPb1bYn7KPwGiHtiP4LWzGrp6V3WAUMiq1er2LKdkU
	 oJ1juIs7BR301nVpAnHIcE42BHW1Tt2JQhxcCLkw87dRtVnQ2ueyA+R5pdkmLMm5ZKzMP
	 LENgL+nNLTtzKfeBor3LTYyYlikQjZoLC0igYe7j//6nJYR8o3n89ctvY27k4kXeSdQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793860952;
	h=DMARC-Filter:DKIM-Signature:Received:Received:From:Date:Subject:
	 Content-Type:Content-Transfer-Encoding:Message-Id:References:
	 In-Reply-To:To:Cc:X-Mailer:X-Developer-Signature:X-Developer-Key:
	 X-ClientProxiedBy:MIME-Version:X-MS-PublicTrafficType:
	 X-MS-TrafficTypeDiagnostic:X-MS-Office365-Filtering-Correlation-Id:
	 X-MS-Exchange-SenderADCheck:X-MS-Exchange-AntiSpam-Relay:
	 X-Microsoft-Antispam:X-Microsoft-Antispam-Message-Info:
	 X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
	 X-MS-Exchange-CrossTenant-UserPrincipalName:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=tfa2O0ag68rnlZjpqrqxgsV5GHa01sPCxmnGKWnJVjk=;
	b=BBYUGg7rEitmkCINbhMtJbYEDZU6oA6AjhdryGZmPEqzlXJ16VIO+n2KJsrk/BIqw2KN
	 i9iEMXAZe9rw48N9+rb+PiIFh/r/lPsbalOD9dcpMQOhMRnnCMlB61L/fUIZDDm3rgi0/
	 h+Dne+k28xGMgZZ20/Rmaj0KrtqgZOphGn9+4nu3S4cKuiI9oTG9bQ58+CjUly863VOgO
	 wTEX/l+QLaTFm4FgY289uQlOAv2jMAZ0wr+6OP9DZMOuAv4lZHx15znRSfi3X+iv/MoCg
	 eYrQQmvtJ2msdn8gzBpFjMbA/yVacuOdVI2rTAz/52dnIZGSy26jT8FmC30GQNUA1Eg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=pCG47PCg;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.62.7
Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazon11011007.outbound.protection.outlook.com [52.101.62.7])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C372606D802;
	Thu,  5 Nov 2026 06:42:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5C372606D802
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=pCG47PCg
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=K8qZ7NT867onnbLIiNmfP92Ace7rSL7URJKCyQT9OndGdLauLBhKrdbCuKpx4OgwVdJCxeNt/YrJ3dZ9EUyvzXrNx8Dd0vhuWU5/IRUgKM9EHaqWmMEaJvg20ihOLLe4yP43/BdVoK5kXut0uBvUFbP22gv/bPPk2zwlI8s0LkAmG3KAhl5Riw0UJx/vrZ/jDnRfh40FGv8FA/P/uOTZdEhOOfJC2/yN4dcTjvSSjrw1/ePvuyldn1TRPuEbjnR9B3Lps9ApW7kbzYL/S1FtT9wSy7yRTfHOkiZAHhL51z5UyrojAyz+sWcP4CumSKANjcyLpPmprBfzTrWHXNkkvA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tfa2O0ag68rnlZjpqrqxgsV5GHa01sPCxmnGKWnJVjk=;
 b=D8aVe7+rEbpggdyQPHCbFDRdaTcKXS4015O3XIDoOxR63MgYxN4YiCnIJKDxUyOoi43ECKHT5Cm6CN4PngIGVSmAD4tB21N5HMJI6ZW7PMUiZ5o+K/vnT9ra2uBgol6wfBVBNn2/u/qrs5WulggW3gPGq2Svmf+nUFsCQrsPgndjlAbz29KDogUnNUU+SUZxhIKyCv1ePyYjIalqcRrgx8QKWD53IgyNhJ36ZDisQ0NjUUMNDApTyqyJpJG3iw1srUAKXL4cBRyzbewuXvmcBMUJovnyTqFmBdhRQfChixPh3ubaFldaRY6QrvlfBI1XXPMRxpyIL54pFsrNQrDXlQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tfa2O0ag68rnlZjpqrqxgsV5GHa01sPCxmnGKWnJVjk=;
 b=pCG47PCg7ARfMlsWY3aFUR6evPycV0t8kqkXf0ffjobLGnKklnq473GUC/nWrOz3AAmeAhP36Sp5eYJS9oab2QPDZzGHX5fP6m0u1BPo+taqFKfqZwHw0vNErk2FF2Z53tpjNIiU4tvgKiCDJ8liJl75ZD/x6pvZRnAI/bxS1WWCqfK+eHLbqlj/Fxfk7/EfoxEN0t1Ha9ipFtShID1R+aPX/2ibFWYArVWwHf+FESDP9J6SmDgyxUYjmWq99rh8c9oHxJh8OPqOZgwyaqGPOt7Xh//hNhIC5X4lxcryYU5GRFtk3eyELIXCNI5d8qTACFhwemtjAoO+sVLoWt01XQ==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SA3PR12MB598757.namprd12.prod.outlook.com
 (2603:10b6:806:52d::14) by CH1PR12MB9573.namprd12.prod.outlook.com
 (2603:10b6:610:2ae::5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.8; Thu, 5 Nov 2026
 06:42:05 +0000
Received: from SA3PR12MB598757.namprd12.prod.outlook.com
 ([fe80::e206:100:5946:a777]) by SA3PR12MB598757.namprd12.prod.outlook.com
 ([fe80::e206:100:5946:a777%5]) with mapi id 15.21.0592.009; Thu, 5 Nov 2026
 06:42:05 +0000
From: Alistair Popple <apopple@nvidia.com>
Date: Thu, 05 Nov 2026 17:40:43 +1100
Subject: [PATCH v2 08/23] dma-buf: Add dma_buf_mapping_map() returning a
 type-tagged mapping
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261105-dma_mapping_type_v4-v2-8-78b8dc9ae80a@nvidia.com>
References: <20261105-dma_mapping_type_v4-v2-0-78b8dc9ae80a@nvidia.com>
In-Reply-To: <20261105-dma_mapping_type_v4-v2-0-78b8dc9ae80a@nvidia.com>
To: =?utf-8?q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>, 
 Sumit Semwal <sumit.semwal@linaro.org>, 
 =?utf-8?q?Thomas_Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>, 
 Simona Vetter <simona.vetter@ffwll.ch>, 
 Matthew Brost <matthew.brost@intel.com>, 
 Vivek Kasireddy <vivek.kasireddy@intel.com>, 
 Dongwon Kim <dongwon.kim@intel.com>, Kevin Tian <kevin.tian@intel.com>, 
 Xu Yilun <yilun.xu@linux.intel.com>, 
 Karl Mehltretter <kmehltretter@gmail.com>, 
 Baolu Lu <baolu.lu@linux.intel.com>, 
 Felix Kuehling <felix.kuehling@amd.com>, 
 Alex Deucher <alexander.deucher@amd.com>, dri-devel@lists.freedesktop.org, 
 intel-xe@lists.freedesktop.org, amd-gfx@lists.freedesktop.org, 
 linux-media@vger.kernel.org, linaro-mm-sig@lists.linaro.org, 
 linux-rdma@vger.kernel.org, iommu@lists.linux.dev, 
 Keith Busch <kbusch@kernel.org>, Jens Axboe <axboe@kernel.dk>, 
 Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>, 
 linux-nvme@lists.infradead.org, "David S. Miller" <davem@davemloft.net>, 
 Eric Dumazet <edumazet@kernel.org>, Jakub Kicinski <kuba@kernel.org>, 
 Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, 
 Mina Almasry <almasrymina@google.com>, netdev@vger.kernel.org, 
 Alexey Kardashevskiy <aik@amd.com>, zhipingz@meta.com, treding@nvidia.com, 
 jhubbard@nvidia.com, Jason Gunthorpe <jgg@ziepe.ca>, 
 Leon Romanovsky <leon@kernel.org>
Cc: Alistair Popple <apopple@nvidia.com>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1793860879; l=9057;
 i=apopple@nvidia.com; s=20261105; h=from:subject:message-id;
 bh=6tdZMR4D2DxbT51QLTne7z0XiYdcGkIb6GiT9zTavHI=;
 b=sXkIbu0P3D4YFCiRC0TUVJdAjMKnQgKXhMeApbL8cKAPJzjBHJo/6mSRp1p1ne5meraLBnr3F
 WWZ+bngikJmAk9f+Ru9Jg+OMGmudBLJbe0lEheogjrCKAaiyC/DT3tP
X-Developer-Key: i=apopple@nvidia.com; a=ed25519;
 pk=WdWPT9rAq3YNfXldbGv1NSGVLGxzQGFGJvRUiShhNqs=
X-ClientProxiedBy: SY5PR01CA0006.ausprd01.prod.outlook.com
 (2603:10c6:10:1fa::10) To SA3PR12MB598757.namprd12.prod.outlook.com
 (2603:10b6:806:52d::14)
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA3PR12MB598757:EE_|CH1PR12MB9573:EE_
X-MS-Office365-Filtering-Correlation-Id: 974021b6-ac18-499e-5f96-08df3b07e817
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|7416014|376014|366016|921020|261028144727099003|261022075727099003|11063799006|56012099006|261009223027099003|261026121527099003|261102123227099003|261021121427099003|261022105027099003|261102130727099003|261026140227099003|10067099003|22082099003|18002099003|6133799003;
X-Microsoft-Antispam-Message-Info:
	UpjRPC65mD58wkANNym2zRRGmVDmE2aae5n2tykeaXJi/Sf6yhLwp0589NbVMkVLX7hulmNHqw8cJ4lPa35EiIPaE+pC1mQDMXZ1QEyYsvP/mZaF0kJkbf6hRft6qW9FBEcUv2bNCpkKTzxfnE6lMRKGgHhysIn70nVcucb4MnsbTD4j663aKAXFvW3BxM4o8/0ue2hndeHm5ysRVVTdPWaUvKN4SPjO7qDahFVM0NuYD1ejQ+gCADdVycUpm9bQphIzma9WyGMPK5/SofU3dOn7ip5kTnrkbS3/eNG9s5u8JbPZVYRE3xlHf0D0TgrdFWrxLBjDSdo3s4WuoWWCdVFCY/HDr6Zp3u7Eoq/lOVaITEzUyI0IIEO9bfW0yywNKM8dvmGoZN6VI678AmxGr+TI/Gstk1CI7My8W2RgY3mIDKMYvJZyARKWHS6Ta2QPn++FurHiw8szODxwcfTWkNDclhfW0kU8Q1UXgoWxsa/N0ej9fCZ+iZLJk74JXkAyFAbAKGUeGzE0by+Buy3qKtqcgCBPxmz3n0KknEDyO56ENcbZy0glTCAc6lnR3yPin3So7OJ8czbc8zqW+Ej5kjkega8vMKHTSbsMP1zUMPwfrwLizcstDsGCK4/Ekf0ndmMtOlvf2N8Y37e5laPTV9JnEriLgTTZYF4GAnEwmDFdjQyppNJnaLh555OqC8OvILZUKYoDDTGF93TzJT6D7A==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA3PR12MB598757.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(7416014)(376014)(366016)(921020)(261028144727099003)(261022075727099003)(11063799006)(56012099006)(261009223027099003)(261026121527099003)(261102123227099003)(261021121427099003)(261022105027099003)(261102130727099003)(261026140227099003)(10067099003)(22082099003)(18002099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?SDlaY3ZjcWtuVkFOSStCNndMY1hrMk9hY2pJQ00ybU0yd3phbkVDN2ZWdkE4?=
 =?utf-8?B?YzBvY3g3UGNsblB2WE5NN3RrRENoME5ZbjBLRTJzR3B4dzJpTlpSTjZHTGFZ?=
 =?utf-8?B?YzFubE1wMFhyTllIMkFPTHkwY1V4SCtaVnJGbTV4L3NmQVJDMWM3QkR5NWxi?=
 =?utf-8?B?WVRPQXBJRWE2Z2FFdTNqaUtXRnhuL2NtT1gyWHZCRUEySUU3WTRxRnVPMENE?=
 =?utf-8?B?TXhSZG05TzJYMFB5RDNnSWtzeFh0N25UQzV3K3haOWpyL1N2WnB1aExNNlpm?=
 =?utf-8?B?NWdteldnWGZsR2tINmNlK3ZxODBZMmxUUDZFZzRuSTFoUWppUW5WRE1IMFFl?=
 =?utf-8?B?bFdvaXpObDF3ekFIWG5vRFNnSWMzT3ZVN3ZNODhxazJpNDJlZ0JxYXYwME1W?=
 =?utf-8?B?MitrS0VhYlh6L2dCVEVnVWUzdFVSeHNLTHNJRUFLdmhOTWp2T2NrVjhkbVFL?=
 =?utf-8?B?a3JVeWlyVmJldWFFNGZmZnRyUVdvUDBFK0dnSkhtbTRHdWFqVEZtcWIyRlhX?=
 =?utf-8?B?bXZTZHVFUUU3KzR6WDlFZ295YVVYVGtYcVJqTFNyK0srOEJuUnhMU1BEY1dF?=
 =?utf-8?B?SHZoYW83VFdVV3NyUUYrN1V0aWJpZUNVY1lxdWYxaDUwL1BQdUU5OGUxZTdp?=
 =?utf-8?B?Zjg5c2paY1lKV1g1ei85Lzhkdm1wblRLTFZYdEt1ZlJxNndQL1dQRVlacmtr?=
 =?utf-8?B?QkkvbGcvS3JYNW9WTHdKcStpTXJvdXF2QmNnWmZYUXpabHRQY1gzSkdQUU5M?=
 =?utf-8?B?Nlh2TW54amxhdzNMK2VEMTF0K2ZxdWVlV1lGcnBtUjY5ei83Mjg5VnhQWm56?=
 =?utf-8?B?U1JONXB4NEszdk4xc3J6K3VxdnVmYzF2eTdKeVhoT2l1dTJMc1puYmZPUUVz?=
 =?utf-8?B?ZGpLS3N4ZVBqd2ZKNkpaNmQzVGpPTy9lcjZGNURWYkVXSmVjMU9lTzZiczBH?=
 =?utf-8?B?T2hzWnRpbFBuSlV4VzY4TWNMUEtmZ3N0Nk1VeVlKUUNja3liZTdGZUdmZmlI?=
 =?utf-8?B?UXZvVWFjdUlDOGxoUHB1cG1BTDJSQU9KeGxDYXFhaFFBNDJNMDBldGFLa2FI?=
 =?utf-8?B?SFFpZnJBZTZpUzgzM2lWNStQNWNraS9kTFc1V3JPUnJRZkFFU1pPMERlZ2tX?=
 =?utf-8?B?Y1Y2NlhwWk1EL05JNFVJdVhWM1VZMkYwM3Y5OU5RbUpGemJGTFhTSkpqalU3?=
 =?utf-8?B?R3hINGxqNGh0T3ArYitMTUNIekxsaW5NMklIcTgvQ1FPeWFFd05xVkhLSGtw?=
 =?utf-8?B?NFU3Z3NRaGdUSjNUTHF5Nnp1UUEwNE85V1FjRFc1dWtSVm9QblRTMyt1UUwr?=
 =?utf-8?B?YWFQWkdqTmxVU2JBbVNYR1ZMcDRuS01ITTJxT2xVTFFnbElpSGJEcjZ2NGY4?=
 =?utf-8?B?R1JjQTlXNTl2TjNxYVBRS21ZK2I2VFAreThiaW1BTHBaMTNnUVhIYU1PSHVI?=
 =?utf-8?B?eVczQlBncjRCWUVPMFdTRTRRN0g3TlVZL2ZRSk5xVHAzWjBjdlkwakRlSWtI?=
 =?utf-8?B?T0c1SEdIRmpUMm9FODRwdCtYMEoza3MrbHNObUlTdUY4S3h6Mkdvc05nS2J1?=
 =?utf-8?B?SVNYSDFxVWRXcXVZeTM0MXBKTnRYQk5GSnJwZUV4cWJMNEZRdk9sajJmbHNh?=
 =?utf-8?B?UnkrVDNHUkpxUUg4dUpGR2k2eTcwQXdwWDRiTTgyYlEyOEEwSGlSWWRlSDRG?=
 =?utf-8?B?SUxBNmVwT0RQTjUrQ1FRQzE0SE4zYVR0eFVKOUdRSXRKbUVyMCtXaHc2VG13?=
 =?utf-8?B?SmszQlVjUlF6c21CdmEwL2ZHbVk5M1kyelJlSHgzQ0NCREthQ1pmTndjYjVK?=
 =?utf-8?B?ME9IMWw3Q3dTdFM2Q3RRUFlySWxDZWNEQnNRSlg5MUVzNXhmd2F5bDVsTmtV?=
 =?utf-8?B?RitkT3MzUldJcjdyWWltMC9RN3hYWDkxZkVLSlB0OUFjMDFyWVRnQndCU3ZR?=
 =?utf-8?B?Sm5uT3J2ZGx6Rld3RkN1S3I2TzhUelVQUUZqRmR5TjIwNXZNOXZlaVE3dXlG?=
 =?utf-8?B?bmV6ZGI3Zm1QazVMU3pBbFRacGoyTTdpWkkrVzVwRVRSQXk1T2VwWGJqMSs1?=
 =?utf-8?B?OUZYb1pZRHN0bmdNajNCamNtb245NFFUbzZQVlZJcHNwQ1orcHRCMlpqQkZm?=
 =?utf-8?B?dEo1a0V2VGpKZ2pzbXhPNHJQcjJsSk1pSDRPekJ2bUE2K0hBOWliM0Q3THAr?=
 =?utf-8?B?QXZrd08yWEVuTUQ3em40VHFmV2pMWENGQXNtc3lEaWk0WlVoTjM4ckI4MzZy?=
 =?utf-8?B?RHM3K3FkeG8veVdjOG5ObWVSWkdpUlJ2S05pUzhjNnhNcnM2WG94YTFJV0tH?=
 =?utf-8?Q?OahQ92w7bBLWc0QQzo?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 974021b6-ac18-499e-5f96-08df3b07e817
X-MS-Exchange-CrossTenant-AuthSource: SA3PR12MB598757.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Nov 2026 06:42:05.6765
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tMbMVFssXkQt5qRvVT4pvLIypCCpBdGAm2PKTXmlU6ygNBi0JmO6Kkz+Sc1woOg5WVQ+dFQhDYOP2LRXUsmuaA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH1PR12MB9573

An importer that lists more than one mapping type cannot know which
type-specific map function to call, because the exporter selects the
type at map time. Create a generic entry point to determine the correct
type.

dma_buf_mapping_map() selects via dma_buf_mapping_select() and dispatches
to a map op on struct dma_buf_mapping_type. That returns a struct
dma_buf_mapping carrying the type, embedded in the type's own
result struct. dma_buf_mapping_unmap() hands it back through the type's
unmap op.

To support existing SGT importers the SGT type implements both. Its
result is struct dma_buf_sgt_mapping with the sg_table reachable through
dma_buf_sgt_mapping_table(). The sgt map body is shared with the SGT
type's map function which remains the entry point for importers listing
only SGT.

Signed-off-by: Alistair Popple <apopple@nvidia.com>
---
 drivers/dma-buf/dma-buf-mapping.c | 78 +++++++++++++++++++++++++++++++++++++++
 drivers/dma-buf/dma-buf.c         | 33 +++++++++++++++++
 include/linux/dma-buf-mapping.h   | 63 +++++++++++++++++++++++++++++++
 3 files changed, 174 insertions(+)

diff --git a/drivers/dma-buf/dma-buf-mapping.c b/drivers/dma-buf/dma-buf-mapping.c
index ff2dbcca23d9..264c9293438f 100644
--- a/drivers/dma-buf/dma-buf-mapping.c
+++ b/drivers/dma-buf/dma-buf-mapping.c
@@ -388,6 +388,82 @@ void dma_buf_mapping_unselect(struct dma_buf_attachment *attach,
 	attach->selected_idx = 0;
 }
 
+/**
+ * dma_buf_mapping_map - Map an attachment with whichever type the exporter
+ *                       selects
+ * @attach: the attachment
+ * @dir: DMA direction
+ *
+ * For importers that listed more than one mapping type. The exporter picks the
+ * type from the possible matches and the result's &dma_buf_mapping.type records
+ * which was used. Must be called with the dma_resv lock held, and the lock must
+ * be held until the result has been acted on. Importers that listed a single
+ * type keep using that type's map function.
+ *
+ * Returns: a &struct dma_buf_mapping to pass to dma_buf_mapping_unmap(), or
+ * an ERR_PTR.
+ */
+struct dma_buf_mapping *dma_buf_mapping_map(struct dma_buf_attachment *attach,
+					    enum dma_data_direction dir)
+{
+	const struct dma_buf_mapping_type *type;
+	struct dma_buf_mapping *mapping;
+	bool selected;
+	int ret;
+
+	might_sleep();
+
+	if (WARN_ON(!attach || !attach->dmabuf))
+		return ERR_PTR(-EINVAL);
+
+	dma_resv_assert_held(attach->dmabuf->resv);
+
+	selected = attach->selected;
+	ret = dma_buf_mapping_select(attach);
+	if (ret)
+		return ERR_PTR(ret);
+
+	type = dma_buf_attach_map_type(attach)->type;
+	if (!type->map) {
+		ret = -EOPNOTSUPP;
+		goto err_release;
+	}
+
+	mapping = type->map(attach, dir);
+	if (IS_ERR(mapping)) {
+		ret = PTR_ERR(mapping);
+		goto err_release;
+	}
+
+	return mapping;
+
+err_release:
+	dma_buf_mapping_unselect(attach, selected);
+	return ERR_PTR(ret);
+}
+EXPORT_SYMBOL_NS_GPL(dma_buf_mapping_map, "DMA_BUF");
+
+/**
+ * dma_buf_mapping_unmap - Release a mapping from dma_buf_mapping_map()
+ * @attach: the attachment
+ * @mapping: what dma_buf_mapping_map() returned
+ * @dir: DMA direction used for the map
+ */
+void dma_buf_mapping_unmap(struct dma_buf_attachment *attach,
+			   struct dma_buf_mapping *mapping,
+			   enum dma_data_direction dir)
+{
+	might_sleep();
+
+	if (WARN_ON(!attach || !attach->dmabuf || !mapping))
+		return;
+
+	dma_resv_assert_held(attach->dmabuf->resv);
+
+	mapping->type->unmap(attach, mapping, dir);
+}
+EXPORT_SYMBOL_NS_GPL(dma_buf_mapping_unmap, "DMA_BUF");
+
 static int dma_buf_sgt_match(struct dma_buf_match_args *args,
 			     const struct dma_buf_mapping_match *exp,
 			     const struct dma_buf_mapping_match *imp)
@@ -458,6 +534,8 @@ struct dma_buf_mapping_type dma_buf_mapping_sgt_type = {
 	.match = dma_buf_sgt_match,
 	.finish_match = dma_buf_sgt_finish_match,
 	.debugfs_dump = dma_buf_sgt_debugfs_dump,
+	.map = dma_buf_sgt_type_map,
+	.unmap = dma_buf_sgt_type_unmap,
 };
 EXPORT_SYMBOL_NS_GPL(dma_buf_mapping_sgt_type, "DMA_BUF");
 
diff --git a/drivers/dma-buf/dma-buf.c b/drivers/dma-buf/dma-buf.c
index f052184da5ed..fc1e62a0b388 100644
--- a/drivers/dma-buf/dma-buf.c
+++ b/drivers/dma-buf/dma-buf.c
@@ -1345,6 +1345,39 @@ struct sg_table *dma_buf_map_sgt(struct dma_buf_attachment *attach,
 }
 EXPORT_SYMBOL_NS_GPL(dma_buf_map_sgt, "DMA_BUF");
 
+/* &dma_buf_mapping_type.map / .unmap for the SGT type */
+struct dma_buf_mapping *dma_buf_sgt_type_map(struct dma_buf_attachment *attach,
+					     enum dma_data_direction dir)
+{
+	struct dma_buf_sgt_mapping *mapping;
+	int ret;
+
+	mapping = kzalloc_obj(*mapping);
+	if (!mapping)
+		return ERR_PTR(-ENOMEM);
+
+	mapping->base.type = &dma_buf_mapping_sgt_type;
+	mapping->sgt = __dma_buf_map_sgt(attach, dir);
+	if (IS_ERR(mapping->sgt)) {
+		ret = PTR_ERR(mapping->sgt);
+		kfree(mapping);
+		return ERR_PTR(ret);
+	}
+
+	return &mapping->base;
+}
+
+void dma_buf_sgt_type_unmap(struct dma_buf_attachment *attach,
+			    struct dma_buf_mapping *base,
+			    enum dma_data_direction dir)
+{
+	struct dma_buf_sgt_mapping *mapping =
+		container_of(base, struct dma_buf_sgt_mapping, base);
+
+	dma_buf_unmap_sgt(attach, mapping->sgt, dir);
+	kfree(mapping);
+}
+
 /**
  * dma_buf_map_sgt_unlocked - Returns the scatterlist table of the attachment;
  * mapped into _device_ address space. Is a wrapper for map_dma_buf() of the
diff --git a/include/linux/dma-buf-mapping.h b/include/linux/dma-buf-mapping.h
index 7140fc13dd00..a961314dbd99 100644
--- a/include/linux/dma-buf-mapping.h
+++ b/include/linux/dma-buf-mapping.h
@@ -33,6 +33,16 @@ enum dma_sgt_requires_p2p {
 /* Type tag for all mapping operations */
 struct dma_buf_mapping_exp_ops {};
 
+/**
+ * struct dma_buf_mapping - header of a mapping made with dma_buf_mapping_map()
+ * @type: The mapping type the exporter selected. Importers that listed more
+ *        than one type switch on this and use the type's accessor to get at
+ *        the type-specific result embedding this header.
+ */
+struct dma_buf_mapping {
+	const struct dma_buf_mapping_type *type;
+};
+
 /*
  * Internal struct to pass arguments from the attach function to the matching
  * function
@@ -100,8 +110,35 @@ struct dma_buf_mapping_type {
 	 */
 	void (*debugfs_dump)(struct seq_file *s,
 			     struct dma_buf_attachment *attach);
+
+	/**
+	 * @map:
+	 *
+	 * Produce a mapping of this type for @attach, for which this type has
+	 * already been selected. Called by dma_buf_mapping_map()
+	 * with the dma_resv lock held. Responsible for pin-on-map of static
+	 * importers if the type supports them. Optional; a type without it
+	 * can only be used through its own map functions.
+	 */
+	struct dma_buf_mapping *(*map)(struct dma_buf_attachment *attach,
+				       enum dma_data_direction dir);
+
+	/**
+	 * @unmap:
+	 *
+	 * Release a mapping returned by @map.
+	 */
+	void (*unmap)(struct dma_buf_attachment *attach,
+		      struct dma_buf_mapping *mapping,
+		      enum dma_data_direction dir);
 };
 
+struct dma_buf_mapping *dma_buf_mapping_map(struct dma_buf_attachment *attach,
+					    enum dma_data_direction dir);
+void dma_buf_mapping_unmap(struct dma_buf_attachment *attach,
+			   struct dma_buf_mapping *mapping,
+			   enum dma_data_direction dir);
+
 struct sg_table *dma_buf_phys_vec_to_sgt(struct dma_buf_attachment *attach,
 					 struct p2pdma_provider *provider,
 					 struct phys_vec *phys_vec,
@@ -158,6 +195,13 @@ dma_buf_attach_accepts(const struct dma_buf_attachment *attach,
 	return false;
 }
 
+/* Internal: &dma_buf_mapping_sgt_type.map / .unmap, implemented in dma-buf.c */
+struct dma_buf_mapping *dma_buf_sgt_type_map(struct dma_buf_attachment *attach,
+					     enum dma_data_direction dir);
+void dma_buf_sgt_type_unmap(struct dma_buf_attachment *attach,
+			    struct dma_buf_mapping *mapping,
+			    enum dma_data_direction dir);
+
 /*
  * DMA Mapped Scatterlist Type
  *
@@ -175,6 +219,25 @@ dma_buf_attach_accepts(const struct dma_buf_attachment *attach,
  */
 extern struct dma_buf_mapping_type dma_buf_mapping_sgt_type;
 
+/**
+ * struct dma_buf_sgt_mapping - dma_buf_mapping_map() result for the SGT type
+ * @base: common header, @base.type == &dma_buf_mapping_sgt_type
+ * @sgt: the DMA mapped scatterlist, as the SGT type's own map function
+ *       returns it
+ */
+struct dma_buf_sgt_mapping {
+	struct dma_buf_mapping base;
+	struct sg_table *sgt;
+};
+
+static inline struct sg_table *
+dma_buf_sgt_mapping_table(struct dma_buf_mapping *mapping)
+{
+	if (WARN_ON(mapping->type != &dma_buf_mapping_sgt_type))
+		return NULL;
+	return container_of(mapping, struct dma_buf_sgt_mapping, base)->sgt;
+}
+
 struct dma_buf_mapping_sgt_exp_ops {
 	struct dma_buf_mapping_exp_ops ops;
 	struct sg_table *(*map_dma_buf)(struct dma_buf_attachment *attach,

-- 
2.54.0

