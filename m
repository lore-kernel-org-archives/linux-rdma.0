Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11012032.outbound.protection.outlook.com [40.107.209.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6B261D432D;
	Fri, 16 Oct 2026 08:45:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.209.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792140302; cv=fail; b=ugqQ4nKA4Hn1DPVDvkGiWtVOmls0HX5PyvTXwDHMpmodxfj+n4HYk1yE9bE5iDrrH0frCS/OFqI//ezGVkcNXMgU9A4am0fu+SbDVKyONx5+iY0s1HxbzHGrBGKUY/29/punfa44GRBE0SriI7u16GGk18dI4Pufrf3GzO2GBdA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792140302; c=relaxed/simple;
	bh=swp+zYq+FFZZrnaX/+Bc9teWylFYrWnMLFHKtyMG7a0=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=m8DeIKKxFROnONGZ7CBoBm+GoQgCtFV66zcCla2KzQveM3eXFO5yf9bcErPDJjJQhca/JMf8HGyXjnYYnRa8/nWj4OkRpi3+Vy7nuFWiLlN/IitnoaZKACYU8qjaC+p9U2aqe2rNENAXPwy3Asynb3THobD2Sh2dRRnKt6xzL98=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=tTIH94ov; arc=fail smtp.client-ip=40.107.209.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="tTIH94ov"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JYU/N/avYG2VUPmtMPELHI37CqWO7WPosmvjsv1jbE/myAgjY2AB6Fk9WNzVbkKkBVWrhaiPGtCh0te2ILXO8YJor+d1a67owk7nAtI6Z5VuXWFGDZu8bCff3Z0okaQ2S/Bjmih9lw0/PY/69w0c/6k2kjVtdDU/iJ9qNGuoAtdT+q70b2Cm0kQxIcevGTqY+HufxHImiuwlrwlwP5d944uHM0l0shm0xEVxRr/CLFceEy46C9jWhkVsIIGb59j7b3OZ3bXVqjUEFhYqNHu0KP5XWS6PS/oXwIbqCNYci5jXPCWLplSE6a2areWeYG1KiqIxkoQlEzRSDNMqvPTF6g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zTW90B2oQVIZnRsawTgBsRfe6Ewi+eja1Ik/dLeHtHI=;
 b=m1mF4dczVPfnKs3UX/gxjifFnuihR8A+Z8HUEYU36iEU0TrGua7e43L01NNdKwAFJ8DoPDTrSoF3yKphUT8F5tGST9oYEjKqKYmJnTo8ny6d8LW8IfSfTXzxJXoXncYgkx3OHUkjtzFMhIIXdbZ+E8I1VKUpKSoYhFc6rQtZlGtX+/R/SdxuuyhxjpYy9y1p6pdrGOsMrMYghFleyudSoZFXYx+CcRtaAjfLSKzL/nRrgEqbMAciU74xu7YurfEC0y9mUMAkM1iNujAz4LiuHe439+sRjbi/3HnXVaSZOguWr+LAvMxZ1Wthl6ybuNlZY36CN1R7pkAXCWADbSsShA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zTW90B2oQVIZnRsawTgBsRfe6Ewi+eja1Ik/dLeHtHI=;
 b=tTIH94ovFaKodksGtwhrF7KcNT7RBrZ+AtMI7TCS4PjsiWEDn2yipqv166irEmuZevJlaSrZcVSDkqSbR2sNpDi/SHx9e2CJv+DywbypT2WV7GTOsewbFlZe7NvEzuNbPkTUM+cIL04vEbqVhI1B3U417mLZCQnJzaNUoNIGJzNZZ438W+JEZPqiEgDwvnUT7S+vUWrxjyfodW3X3CCbA5ghygAobbZ+EjYSMpogwZShnvjSBoiHe1lxDimARC+W6vC9rMNLt5jkyhjgTgg/ucQ+v45jayTVYOHhSWjNikmUnBjQ2cdTfOcRiXHSfmkf7+QOxdiJSAWa2to+SsbTOQ==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SAVPR12MB999143.namprd12.prod.outlook.com
 (2603:10b6:806:4e5::21) by DM4PR12MB6208.namprd12.prod.outlook.com
 (2603:10b6:8:a5::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.496.24; Fri, 16 Oct
 2026 08:44:57 +0000
Received: from SAVPR12MB999143.namprd12.prod.outlook.com
 ([fe80::219e:6553:2ec0:3761]) by SAVPR12MB999143.namprd12.prod.outlook.com
 ([fe80::219e:6553:2ec0:3761%4]) with mapi id 15.21.0522.012; Fri, 16 Oct 2026
 08:44:51 +0000
Message-ID: <b4005276-fb1d-4e4f-8f03-487f9e9bf9e5@nvidia.com>
Date: Fri, 16 Oct 2026 16:44:42 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net] net/mlx5: Attach late uplink netdev to loaded
 representors
To: Chenguang Zhao <chenguang.zhao@linux.dev>,
 Tariq Toukan <tariqt@nvidia.com>
Cc: Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
 <davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>,
 Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
 Paolo Abeni <pabeni@redhat.com>, Cosmin Ratiu <cratiu@nvidia.com>,
 Dragos Tatulea <dtatulea@nvidia.com>, Gal Pressman <gal@nvidia.com>,
 Jason Gunthorpe <jgg@ziepe.ca>, Jiri Pirko <jiri@resnulli.us>,
 Leon Romanovsky <leon@kernel.org>, open list <linux-kernel@vger.kernel.org>,
 linux-rdma@vger.kernel.org, Mark Bloch <mbloch@nvidia.com>,
 Saeed Mahameed <saeedm@nvidia.com>, Shay Drori <shayd@nvidia.com>
References: <20261006110219.257714-1-tariqt@nvidia.com>
 <20261016023609.GA318264@pc>
Content-Language: en-US
From: Jianbo Liu <jianbol@nvidia.com>
In-Reply-To: <20261016023609.GA318264@pc>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SI3PR01CA0012.apcprd01.prod.exchangelabs.com
 (2603:1096:4:296::11) To SAVPR12MB999143.namprd12.prod.outlook.com
 (2603:10b6:806:4e5::21)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SAVPR12MB999143:EE_|DM4PR12MB6208:EE_
X-MS-Office365-Filtering-Correlation-Id: 4b053911-c464-4edc-74e0-08df2b61be35
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|376014|7416014|366016|6133799003|10067099003|22082099003|18002099003|11063799006|4143699003|56012099006|261009223027099003;
X-Microsoft-Antispam-Message-Info:
	tkNfUqBoWeUnK0zDrM4P1jj7eRkeRu4fsYeNemUGSmUXMazOAtylwIYn5enrKZe6N1deILPnY0yGI0Pa8OnvszJlETXzOPtAJ7DmfiyqYmiAHCAsTUau36ZzxzRX0PWG+IlYn3d/1EYVWBPTn08bTpbT8dfcURMzoytWG0GGvaQLEIiaNHhE6vzpyi2WcFKxd7IYAhn/lnwIIXG2a1L8SjbpV7mZMBr2b1fl3pT/R3r88eXqxA7j2dzWkA3vnZMWhZmN+K6btGvrf/KL0/gE+oO+QMT+d2slBKisZQ55yxmOEs7uoCIALKrcI050Ip5A4dajtPJ0pdwTa2szFxhk4BX+DQPhWvGL0lP4VvnQTcpG94GDPu0ZXFr22WseWLywiw9vWv7XKoM5GrlZI8yl6geB5vq1Ar+UoF7VAJmERNv4OkfvR7mg41Eao9CJ2KR2q5uSWyHv15Y42h50Sp+peMgd7Mzw7sxfWIog8Dl1mf2Pmcw3/RPiTDTilO57Xc/8Wb/mN0BKcbCQQJN8ooeFvmh8WphbJe0Dxl3uyxaGPcxEK5llRNkVyu2JbCcTEiyYbOLrHP9uBB+gszO92RmxvBrBw/WxafsFWbzym3LXKI1PoyPVap1ifIb8BpJeI7M9R84YUYOSc/vVNGKX7dO88NPPLCbirS8PeOqQkshNfJg=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SAVPR12MB999143.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(376014)(7416014)(366016)(6133799003)(10067099003)(22082099003)(18002099003)(11063799006)(4143699003)(56012099006)(261009223027099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ZzkwbGpqNlN2SjlDazZ3UjRQaWNMY2lZNllHYU1ob0RDY2xpRXV5TEJwVjFq?=
 =?utf-8?B?bnRwR3NZWG5HRXNCQWVCVWhuWnYxNnA0SDFVSVBUaEtiS1VJSG4yTVVZa05j?=
 =?utf-8?B?M240R1hLSW0vcnk5UHZtOWJ3S2lHaUR5VmUyZEUwWks2WHZtdUo4ZUdBVGJN?=
 =?utf-8?B?RkthMTcyd09DZWZQT1VBM01WR3E3UVk3Q01vT1pHUzJwYlRUYk5LM2lZOGE2?=
 =?utf-8?B?RWRBWVo1U3Zxb011QWdMVG5MYVU4OSsrVFVFUUg2MWE3RU1WalB0Z0RBMmRO?=
 =?utf-8?B?SzAyYTlJT1lyTzN0UDV6NWpuR1JaTWEwUjRZTUt1bGpaVGQrdmVJdGxDbG1z?=
 =?utf-8?B?em01VXZPYUFBdmZMZ1MxSGE3TDZnSkVkQ28wTS9PVHhhTFFzVjNJRFk0dEFT?=
 =?utf-8?B?V3VmY1UrV05kMzdEV29kVjNvWUsvRkNOTkpFQitDY0xYS1RGbFNJcGg0STUw?=
 =?utf-8?B?bGo0VXpGV1JjYkQwZUNFZmoyMkhoU3AzTDkrMGxIK3pQTWIxWDNvTXhqckVq?=
 =?utf-8?B?YVMyN2diU0VCL1hiR2FTam0xNWlvYytpRGZ4WG1EMUNQRlNNQ1hhT2RWYlFI?=
 =?utf-8?B?RDA0VXpOSXMwcnBQSlAvUVhLRUx6MHhYQmMzcEJCeFZqcU4rWFdNYW96SU9O?=
 =?utf-8?B?VVdENyt2N0VTQ0dEOHBLVDVCQUxWMTVUdGZKTm9RTjNrUzNENnpHcUtWSlR3?=
 =?utf-8?B?TDBUTXBiUVMwRnllUHU0NmhGS25VYVNZN0dMMGVranNxTWpNeEQ4TkRVRjhl?=
 =?utf-8?B?aVdrL0ozdWFIYW5MbDNmYWZNeW9IWWZ2WDVyNXIwVk1XbHJSTE9FdWRqMFl0?=
 =?utf-8?B?QmZsV01JSFA0TEtEeG1RdnpYNnZEUyt6Qk5OVUFicEFlK3lYU1M3SzJ4Q0ZO?=
 =?utf-8?B?MzdxU2UvNklxdkx1dU11cWVlVTAxY0R3MW9rTDNmYmcrRFk1dGRHMi85cm85?=
 =?utf-8?B?NWxJNXhHcHhlc3lvS2sySWJRbjAyekhQVml4MnhiU2tkRDg4cnhDbCtDaEVL?=
 =?utf-8?B?MUN5bGN2M05SQUpicTBIcUl0TlVNSHJvMFJ0MDdKU24wNEUreDNKR3pJMXVs?=
 =?utf-8?B?aUtDNXVIZEFoOFpMNkFjdVFQNWZUaGp5dUJmalpCcGN6am04ZjBsUmdhbFlF?=
 =?utf-8?B?R3Rtd21YRmppUWNDbElOVlZkNU1NdkpNcW1BQ3UrMVpSbnFjcVZ5RHB3RVFJ?=
 =?utf-8?B?c3BoTzdrZS95TndaVXlmZ1V5SmozckdwNUp3MDk0RGJ2cGZHOFZINjd0L3ZR?=
 =?utf-8?B?L3h4ejhPWGlpZlFiRXZrZ2Vya1VESUZPMlY4NG8ramNxOWVLdGc3cXJnRXl1?=
 =?utf-8?B?enQxTk1CMXFBQkd2ZUQ0VWZjN2JlQmhSanBLdnF1cXpHbUVhK0xMUmR3cE5l?=
 =?utf-8?B?MlFGQ1NrVlNmZlhtYmQxSWhrMUNFK3JBOHJXVFZUeC92dE5lYmJkY0owZzZv?=
 =?utf-8?B?dk94bVR1SGdHdTVScXBlNWx6QVB5Z3kzMFFZME5lT1g0MDBKdkNQVDBYTXNz?=
 =?utf-8?B?NlZWU241RjlJT1lTQmdhZHFxM3JQWk9jWDZsZkRxUDJ4ZTBidHhub2l6S2dj?=
 =?utf-8?B?bGkxUmU5ZTNSVVJBU2VTQWpualdFcW5YL05DcEtZQy9kVS9lK3EzZUI4Y04y?=
 =?utf-8?B?UG15OGhIZkhHTHpiazY0TWpua2FWNElDdGc5bzhrWThlTHpxbHZIY3c1dzQz?=
 =?utf-8?B?VjJ3VUp0ekRhbnpvbnpwUXhpeXMrVkdwckx3YzdCN2lxMjNrU2dObE5uQTNq?=
 =?utf-8?B?ZTVzYVdibnBkN2pJTzBuNlJiYy9OU01RV1JycjBGTWpObG9XeTFlQzBWZ3Rt?=
 =?utf-8?B?OEFFTFo0N0p3ZWxsQ3RzcHlOemZkdHlpS0dTRU5MWUNXL0t6eldmMDNSNWlz?=
 =?utf-8?B?eXNtb0lnd2RUMURmcXFOYWR3akhoWVM0SkQ0ZnNkelNPRXFQZnZScnRaNGRo?=
 =?utf-8?B?anB0bVRQZTZxaVA2K0FoTDZKUC8zS3Z6MmlXRkwzYStscFVHSGp0RnNTZWhZ?=
 =?utf-8?B?KzMybVY4VnFnVFZzb0svZ1pyUmEyV0l6UVMwMHM3NjNiWkdlbCtoNlRnU3ls?=
 =?utf-8?B?ZlhhR2FLQldhb2dHd2xldEtpSW1hYThFZ2dnRnRDTDFPR2ZjREdRSHVRTXNW?=
 =?utf-8?B?aGVOSW9ublM2WXNTdFRMY2xNcUxuRnlHejQzMk16Yy9rRTcyWFdVNjlTc1J4?=
 =?utf-8?B?YUs4VWgzdlBJL0grTXNQaDg2V3loQVdGTmhiMTZ3K0l1WHN1R3E5bXFzbHZh?=
 =?utf-8?B?TVE1R0RqcStrK01hOTdndHN4QzVnTjlEU1pwaWp2VDNQcGhzZ2VpTyszckJB?=
 =?utf-8?B?amRrU0lVYW05Y3dDQkwxY1dFWDI3RUhrbUVKWXU0Tnp5c3FuRkhLZz09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4b053911-c464-4edc-74e0-08df2b61be35
X-MS-Exchange-CrossTenant-AuthSource: SAVPR12MB999143.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Oct 2026 08:44:51.4154
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wBrG/5JaPbWeHK3iMQVufjSwoiULGXZUDjJORrGzD6o1keMM7uzoQzjlFs2xKZshWopR5B6K7BMldyuik7ydfw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6208



On 10/16/2026 10:36 AM, Chenguang Zhao wrote:
[...]
> I’m wondering if we could add a check during mode configuration to
> disallow mode switching when the device is unbound.
> 
> Maybe we can call `mlx5_uplink_netdev_get()` within `mlx5_devlink_eswitch_mode_set()`
> to retrieve the netdev, and return `-ENODEV` if it comes back NULL.
> Hi Chenguang,

I don't think we should reject the mode change. A switchdev eswitch 
without an uplink netdev is valid for our use cases.

The check is also racy, since eth can unbind right after it, and
eth may simply not have probed yet when a script sets switchdev
after mlx5_core probe.

Thanks,
Jianbo
