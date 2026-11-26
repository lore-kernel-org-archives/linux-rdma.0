Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.201.0
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795687107;
	b=eb4stBSX4btCMrbx+R52pLSJcu1WKxvqJW3hULz5uSGmlIPxLXKG3fLpMHfIsHQpdetX
	 zY6V9QQT4zNDW1ll9vI6oWUl0Z41vVSalPGSmW/CgMA3LMYZo/gpL/6ky1zDXWyaME+Og
	 zqW1dPb0lwySJyC57lUihOaQXxyH69PaTKCnqzcYrRE8aBv09ynK2TyYgrVrgreDhSbLV
	 1pUJ6pHHDSmfyAYK5Ltv7UjzeXLhzdNv3fooozeKu3b2b7BdzigvtaLR8VLm1C3Ur7yQw
	 g8/tOnJMuszcMW4gDRQsVpdiWu4+eSnlqCm7lTAe/H86az8oAHzAv0jD2PArrK7BiBg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795687107;
	h=DMARC-Filter:DKIM-Signature:Received:Received:Message-ID:Date:
	 User-Agent:Subject:To:Cc:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:X-ClientProxiedBy:MIME-Version:
	 X-MS-PublicTrafficType:X-MS-TrafficTypeDiagnostic:
	 X-MS-Office365-Filtering-Correlation-Id:X-MS-Exchange-SenderADCheck:
	 X-MS-Exchange-AntiSpam-Relay:X-Microsoft-Antispam:
	 X-Microsoft-Antispam-Message-Info:X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
	 X-MS-Exchange-CrossTenant-UserPrincipalName:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=7v+6/vdC8tOuJLuiiuW+HG7sVDDsOHr6dIFJ9e43AAI=;
	b=hyDfhTBaZ0REhW8BAu+y7NzHxdDmCzLmzUQN0rb7rmh5dBSWwnpwQ++SrhiBW9ha6h2W
	 uDqtvNfUneOsZBdND07a8x3qJAUH7bxMjq1n1b36QEcmzFRwxYpmweZpp95nks/we/OAu
	 7H1AiQM8OdiGdCCWQHRACodD/YJIc9CSzocfOdLNff9kRvaRC/+rAa1KhNxrunrukpKoo
	 RoJEAPlEUEF3oDf2AF9ktJDuiK9dLKheHSMhbA96Wv0wYboVTFjbAVVsPwEAd093FZz2I
	 aJ9nm6lKAgcCn5/Hux56ojfYqUjHfdrC4NIGyWP9X9JXZbgNAT5OoAQExMz3/6J5wMw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=amd.com;
	spf=fail smtp.mailfrom=amd.com;
	dkim=pass header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=04+uEy6b;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.201.0
Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11010000.outbound.protection.outlook.com [52.101.201.0])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6274606A321;
	Thu, 26 Nov 2026 09:58:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A6274606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=04+uEy6b
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qnsPdRSUQVgweAPitwb8JDr9Xu+S+ttT+NkzL8mEGmBRgDE7Swu9pEtvMTwOSKNq25DKaVZmvxuR7mUS4A3mFgcufT2N1JZp778FXgeRNqixGyjUVSzu45JCM2clHK+XhPqkHUwbPGVyFyc8RmvZB1chx4+oSXmAiIv5L/Hksd70doPvJPn+ZCG268HBAPy5as/ZwEsyCegPGZQoTNzdDuTXOV1ZHa8V4awttOJgKgmpQaCVvPISG5J9HdX1ZCchyEq3wGaI4WU6GbD+LBTLtJsbA4sfJ6WAKXfXNnYKLoEXaxY2P3zbWxjJSj3PmL6NIpjfJDevtyzK1XtQOpzyNw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7v+6/vdC8tOuJLuiiuW+HG7sVDDsOHr6dIFJ9e43AAI=;
 b=zUit2FqbcNT5Qz6I6SKetFnAScCTqpRM+CNszsuSkMM6mWd0SbHS+y/c+RooYRBsm5QqH/OWUUJ7IT+2i4J3oZhW4zaGKA0FL+I2oo0b/96ppNOLRJuC9S0+14MBK0/wbsP7oL1ZAoaHsksm9S4qTYkZzaFrTgJr6cr15gcnGRLeGpd/Cn8JaB4dRVn/shpAdCdvDmQ/pvB0JULwnvP4RonWsCfH4RGiHyIr9CiFcINOzIE8HRZvLQUUTY+cm3mpvSOfJYGXCpHukSHhiudi3jdMkX/AUa9qfd0AQ6zuf4tk8p91jVa0+YG/AZeeTfCLXbtsyvjtmevfOsafjyxufg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7v+6/vdC8tOuJLuiiuW+HG7sVDDsOHr6dIFJ9e43AAI=;
 b=04+uEy6bsbe6i6uc5PUzVZsBIryOeakc/Sgz0r31BvGmFpsv3Q2NqzNMyw6MSVlXzSbtRUl+H9Z9JqAGbtsdlURjhYxXg0VXE+71ZrunuuYqVxllDWt1cMD2ShHgOk4jZi3DwYp/9mL1UVJ2vHHZVq6OjK9S4iBr6efriRs7F/8=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from PH7PR12MB5685.namprd12.prod.outlook.com (2603:10b6:510:13c::22)
 by IA0PR12MB8893.namprd12.prod.outlook.com (2603:10b6:208:484::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.662.7; Thu, 26 Nov
 2026 09:58:23 +0000
Received: from PH7PR12MB5685.namprd12.prod.outlook.com
 ([fe80::ce69:cfae:774d:a65c]) by PH7PR12MB5685.namprd12.prod.outlook.com
 ([fe80::ce69:cfae:774d:a65c%3]) with mapi id 15.21.0662.004; Thu, 26 Nov 2026
 09:58:23 +0000
Message-ID: <a8c00bbf-dddb-4207-bcdf-af58d27116c5@amd.com>
Date: Thu, 26 Nov 2026 10:58:13 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 03/24] dma-buf: Add the SGT DMA mapping type
To: Alistair Popple <apopple@nvidia.com>, Jason Gunthorpe <jgg@ziepe.ca>
Cc: Sumit Semwal <sumit.semwal@linaro.org>,
 =?UTF-8?Q?Thomas_Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
 Simona Vetter <simona.vetter@ffwll.ch>,
 Matthew Brost <matthew.brost@intel.com>,
 Vivek Kasireddy <vivek.kasireddy@intel.com>,
 Dongwon Kim <dongwon.kim@intel.com>, Kevin Tian <kevin.tian@intel.com>,
 Xu Yilun <yilun.xu@linux.intel.com>,
 Karl Mehltretter <kmehltretter@gmail.com>,
 Baolu Lu <baolu.lu@linux.intel.com>, Felix Kuehling
 <felix.kuehling@amd.com>, Alex Deucher <alexander.deucher@amd.com>,
 linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
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
 jhubbard@nvidia.com, chaitanyak@nvidia.com, Leon Romanovsky <leon@kernel.org>
References: <awT8prWsj11TBdmP@nvdebian.thelocal>
 <63eb7b6e-e0a8-4443-a434-0301ed59beae@amd.com>
 <20261124142032.GN9566@ziepe.ca>
 <7a5a2d3a-e42e-4dc0-8d22-8dd1bd249501@amd.com>
 <20261124194618.GC114530@ziepe.ca> <awZ_Os1pXelOGaFP@nvdebian.thelocal>
 <fb9a6b12-c134-4e40-86a5-dbcb59c0b91b@amd.com>
 <20261125155559.GL246011@ziepe.ca>
 <5fb8bb60-7d9f-49b1-899c-40a890fdc14b@amd.com>
 <20261125190705.GN246011@ziepe.ca> <awfMy1d8ICL6mr9i@nvdebian.thelocal>
Content-Language: en-US
From: =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>
In-Reply-To: <awfMy1d8ICL6mr9i@nvdebian.thelocal>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: FR4P281CA0372.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:f8::18) To PH7PR12MB5685.namprd12.prod.outlook.com
 (2603:10b6:510:13c::22)
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
X-MS-TrafficTypeDiagnostic: PH7PR12MB5685:EE_|IA0PR12MB8893:EE_
X-MS-Office365-Filtering-Correlation-Id: b5158486-a275-49d2-27eb-08df4ba3ce95
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|1800799024|23010399003|366016|10067099003|56012099006|11063799006|4143699003|261022105027099003|261021121427099003|261021123027099003|261102123227099003|261102130727099003|261026140227099003|261026121527099003|261028144727099003|22082099003|18002099003|6133799003;
X-Microsoft-Antispam-Message-Info:
	jNH/7tSUkOpZBN5rKDbGK6/xsFjuIvIWWhn6TXdzXIos1ZDyyzWhckZELrgzYob5iRIGxsT1GGiujGpFCOcTSiDi6yjH+xtrHvJ0AxVE66T5++Dux/IFj00wiDnsIkkVIo2/aOxGIxkRy04nz9oNbakytWsmfKw11miCvhbOsVZN1Enz1/8Cn7w5JmIc8mdXRaRWSZmYB99al51dnaLtFbAu8dwMQcMJP/QT+g4If7dGgELNbn2+5z2wtfeWJwtxivVtl7jW2fjDKpWzBpgF+zQ4LEFIJ5Z4Qu1VHrZgTP6A3wh6WPjRPG3JmmUaoSzSsxKmjCWxA/N4JLKJ8Gy3fmdwv80MwLiXjSUfDXdmxHlfYdi5VgDLCYVtjkSofbCFJ34gJWMATrIu4+C7CKc2sEZgytTJo+zOiAkoP1bguhlCYiXVZwBNBIkIPgP8Bo77I0Cd+OFedw2Evu4l5nTERw9UGOK6VwfpoSscen+ay6CKU6LYSWTZ0jB3HWztR6StkYKXKwsZYWyXrSKkM16Fy18nXIfYVVqDffKgzGm4egYDEcrNQCp4YHLT7cP0Bc/oPYKM20OVl2yIUvswiqzb4RiyFnKQp9Yn2yhx6fEowlpudBKYFDWaqQVDLBY3rIeOMdRdJEvk1rAqioDv/vWJIDUJjds5t1A3/pvjfHWyqXU=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB5685.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(23010399003)(366016)(10067099003)(56012099006)(11063799006)(4143699003)(261022105027099003)(261021121427099003)(261021123027099003)(261102123227099003)(261102130727099003)(261026140227099003)(261026121527099003)(261028144727099003)(22082099003)(18002099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?TmtabG50RUlWNjMzYXUrTEpFUEdCaWZVWW1acWQ2Nmh1aTk3eVBlMzZpNU8w?=
 =?utf-8?B?WUh5bVEwdWtuMWhKNnNaTnZwQkk0TmhWODN4QVlOVXYvbGhybEtrbG9scmRS?=
 =?utf-8?B?Uk9SMTF5RkdNNTQ1ZWw2K0xPOFFvZ1haY09wTGhOMG1IYmx3QTExOTdFbGto?=
 =?utf-8?B?TTNFcTArdll5b2swMDlvNG43Y1hCTC93bnVhS3ZwTGowMlF3anlEUDhuQlQ4?=
 =?utf-8?B?Qnk0ZTkxTVVVNUxJaWNRbWNXaFpEa2VuVUlkZnQ0TGVmMndWNEpXOE4zRnRz?=
 =?utf-8?B?eUQ2RjBiV3RJZktXTyt4YXdRSVlPelU5bWViSEdyUzVWcEo0VlZRWU1aNDQx?=
 =?utf-8?B?YVcxVXlLcHd3c2VCbnJscFFBMDVMcGNuaEJvdzFGRytYUklJSGN0K2tBMEVE?=
 =?utf-8?B?NDJmWTh6YUZhMjltM2xRcEVJTWRCMVc2TXl4Z3RIamphZEVrNjI3biszS3NO?=
 =?utf-8?B?RktNYTBlWk9zTVVnalczTUtpSkUzbUQyUFNhamtNN2Z1NmNxdkljVFJNbCti?=
 =?utf-8?B?NVRNRWdmd3QxWS95Y29FQXNBQ3l5YTc0azVKbnB6bDBTK2VPRkMzTGtoVlVl?=
 =?utf-8?B?dFVESkdpUDZ3ajE0T0xRME56bGpRNlE4ckFJdGVvR1lmcGFQWW43dGxSVXJV?=
 =?utf-8?B?VHZXcC8rQjFLcnViZ2U2NzhPV29ROCt5d0RiZjUyU2FGT1hVblc2cFNaMTRL?=
 =?utf-8?B?NDZBL1BuUmNaSXc0dXJjend6NlFQS25xQTAzanJrNHd4Y2wrcHRoVmFLZ0ZU?=
 =?utf-8?B?YXN0Mkd1M1pZaUVZQ2JQZmQ5b0pvTTR3Z3JCVmQrd3lYVjJhVXphMXFnbVBq?=
 =?utf-8?B?OEdqSXJ5clRCS2FITiszZ1h1Y1o5YWlnKzZCc3h3M2JSSWxzK2NETFF2K3Uy?=
 =?utf-8?B?MWl2bjJaVFI2empXZEdtRzVuTGloc1dkUzN2QnhHNitSQ0UwYVo3ckgvTSsx?=
 =?utf-8?B?SXUxVzdJVkFTbmlpNXArRm5aU00xVlpsclZGQU02OXhOTGIwck1JbFhucldP?=
 =?utf-8?B?YnZ4YldMQkduMVJKbG1seUdqbTBFVmNmWFpWaGdCblhaZWdBWTV2amNsYmlk?=
 =?utf-8?B?eUEzaENRZUljZm5RdjZnaE5oMWhQVkZXWFdNak5SQXFqYzRUaTgrd0hSTXBo?=
 =?utf-8?B?ekJQcWZaZUJCSGZrL1NWQW1lTUNleWVuOHo1YjVBdnV6Q1FLYVlwdWJBbXE3?=
 =?utf-8?B?R3JqODhMbnZBalM2OEEzWG10UE9KUWZMaEppUThnWkpaSUc2emRIQ2EvYi9B?=
 =?utf-8?B?NjdmNGk0NS9WVHo5Vnh4SFR5SUdiYTBDckg0amx2VTl1b2JCc1NQMVVyaFl4?=
 =?utf-8?B?QVFJUi9rbTRqYmJna1d2aFZxZ3k1bkxIVGJyaGh2eENTY1QyaWFWbXd0dzFC?=
 =?utf-8?B?L1Y5R1l2Z3hnZ3hnSUtOdjltaFAzeUNuVC96a01VaUg1ZjFCbnFoUWh2cTJU?=
 =?utf-8?B?N0dLV1BLM3BqZHZBbU9CQ2ZpS1lBR0s4V3lDdzFoMWpoU1ZzYUZHSFZjV3dh?=
 =?utf-8?B?T0VPcGpRWVUvK04zTXI4NjdORjBob1gyZm5mdHBYb2VoYWxMNkNpRmlDTVZB?=
 =?utf-8?B?Y0JYUlFwSW13aUpRVEpSSzRPKytmaENaanFyT2NubzAxQW9KQmxLT1VsRVVP?=
 =?utf-8?B?bm9DdzZ4SU9TT00yN2o2cS9rb3VqM1hUMmcrQ1VnS29wKzBEQXFiaHc4MGxk?=
 =?utf-8?B?TjU4RlFoZVY1aWJLUUNVeElodW5DdDZFcy9BTW9XTkRXdTlJczEwNGJxNHRD?=
 =?utf-8?B?d3NGS1JWZ21qNG9SR1JNRDU4U0ZxdW1Jai9mYTk4aHQyTlVXVGwzK25VSUtz?=
 =?utf-8?B?SjVNNEFsMk5BSWtwWTh5ZmRZSWJHRFV1Y2c5SzZyZDZnelNCeTVNeHBVMWc2?=
 =?utf-8?B?c1ZRcmdnUDdZdjJha2RuS0xQYUVNOWJmN3k1bHFlYW5wVWc3VzIyZlNjQTYr?=
 =?utf-8?B?cHp2TUVUUWQyMlErMnBOc1hTdENIMzZ3UVl3MjdROW1vZmdQWlVHaHhrTlZB?=
 =?utf-8?B?dy9zcFc3V09qZXEwSWI2cFU3eDdOdmt0bHNqYkQ5d21YZjNraTJhbm1vUzBL?=
 =?utf-8?B?eU45YlZQRUNJd1hrdE9GQVBwV3pYOVdKbEo1bHhIM3JPY3BTcE9ZUGIwUnV3?=
 =?utf-8?B?TU0yL2dLQ1JHTHp0YlE1V1kxNmI4a1E2N3FROWF5NFBYbGQ1WEsxU1AvaFdK?=
 =?utf-8?B?YWdrT2NSWm83L3Iya1NPSEwxYkgzbVp4Z29tVDNpSlVuUFZxeSt2TVMvNEUv?=
 =?utf-8?B?amRIOWFYbkp0d2YzM1J1NlQ2VVVYWUxGbFREY1RpaTQ3RHcvcVJLZkl6cjdo?=
 =?utf-8?Q?PFrOAE+1TwFt4xFQsE?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b5158486-a275-49d2-27eb-08df4ba3ce95
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB5685.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Nov 2026 09:58:22.9662
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9GAhOlm8zIN62e3nAX/NwX3vxI9IipWrmBBGM2UpfXcTC2HYN7rH6lyPGubRAUHg
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB8893

On 11/26/26 07:24, Alistair Popple wrote:
> On 2026-11-26 at 06:07 +1100, Jason Gunthorpe <jgg@ziepe.ca> wrote...
>> On Wed, Nov 25, 2026 at 07:17:51PM +0100, Christian König wrote:
>>> On 11/25/26 16:55, Jason Gunthorpe wrote:
>>>> On Wed, Nov 25, 2026 at 12:19:08PM +0100, Christian König wrote:
> 
> [...]
> 
>  > > We cannot disconnect this from the DMA API, ie to use an iommu domain
>>>> or ualink, if exporting drivers are hardwiring calls into it.
>>>
>>> Well the plan is to not disconnect it at all. The exporting drivers
>>> just says to the underlying API here is my buffer please map that
>>> for this importer and that result is then given back to the importer
>>> through the DMA API again.
>>
>> DMA API will only do basic PCI DMA mappings into dma_addr_t.
>>
>> It will never handle iommu_domain, it will never handle ualink/etc.
>>
>> Give us a plan for those if you don't like any of these ideas.
>>
>>>> Fundamentally the need is for the driver to get the phys_addr list,
>>>> exactly like today, and then pass it to an op which formats that into
>>>> the right data structure for the importer. Be it dma_addr[],
>>>> iommu_domain, or some ualink_addr[] - or whatever.
>>>
>>> No, the phys_addr type should only ever been seen by the DMA API and
>>> not by DMA-buf.
>>
>> Again, I don't care how you label things or what "library" they live
>> in, I can't tell if we are nitpicking names or what.
>>
>> But there needs to be some kind of abstraction that takes in
>> phys_addr_t and makes sgt, dma_addr_t, or iommu_domain depending on
>> what the importer needs.
>>
>> Exporters must not open code that.
>>
>> Obviously DMABUF is involved here *somehow* since it is the only thing
>> that knows an importer even exists.
>>
>> Would you be happy if we made a 'dma mapping for dmabuf' library that
>> did all of this and DMABUF just passes its type opaquely and drivers
>> just call its tightly abstracted functions?
>>
>> That is the component Alistair is proposing, he just prefixed it with
>> dmabuf_* as the namespace because, lets be honest, only dmabuf needs
>> this weird looking thing.
> 
> Right, I don't really mind where and what things are named. I'm fine with this
> being a separate library somewhere or building it all on top of opaque/private
> types. But I'm having trouble understanding where exactly the objections lie and
> what the path forward is.

Would it help if have a call on Teams or similar services to discuss the whole thing?

That might be easier and especially faster than by mail.

Regards,
Christian.

> So given no one outright rejected the plan I wrote earlier I'm going to go ahead
> and post the series implementing it (I was hoping to do that today, but it's not
> quite ready).
> 
> Hopefully that will help by giving us actual code to ground the discussion on.
> 
>  - Alistair
> 
>> Jason

