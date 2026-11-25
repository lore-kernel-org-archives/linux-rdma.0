Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.208.34
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795615552;
	b=4cPx2OoNcQjk7xxtP/qUMH95LAj+Hk43E7EY1O5ys2AvVCnZY/Zcm3mk2Fjl6U96YAZX
	 ytyoeHn2QQ3gxeW5E7qdRPOXV/I1akkyCbXudLTtJi7U48OQXzVkVAUsaSzL99C+G1Ikb
	 hlx8iP+GFEGKDPuFrAlsPGTCFnwdgOoaevNjlCSb6WSg9c4dowBbsOOPDpejADDWmKea/
	 eg+witwClC3tdVjqURFxjVQ7DDDV1jEwULcK0TkFUGptSGtMFyiWuOVhMxfuAK8Q3DDen
	 UJ++t15dK9p2b1TsvHFpF3IMFTbFa163nahqwBJhR/3ffEGwSXki4KKkp6DLqxRfw3w==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795615552;
	h=DMARC-Filter:DKIM-Signature:Received:Received:Message-ID:Date:
	 User-Agent:Subject:Content-Language:To:Cc:References:From:In-Reply-To:
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
	bh=+ZP6FaQ+AXUkFN0q1DEy9aUkZxlxBOF8AKYa5llXE9w=;
	b=l4m2ePIztP7Wlv7Zlvik7sWYnVK6kAgXHM0QcXnQlDncEVFpsVLz7q1C+pKUYFNWsDH0
	 nj0vmMLTd8x7Qxzz1cfo+KjBA61e134jMDGGkj8cP0qNooU3lca3oLoR7MgazAbmgN5gH
	 VMCtFB+UKRs7AmmJqpfI3y9Y+Ar3Je6gJHKDv4mDJmoP6xTH6uGcGcXKY85Pm5wmdle86
	 cfZEzYzsEKQrWMQoa+Iemr2JYAd35nhf1yqWZBOEXcrmoEm6hBxQnKXWEN0V+2Dz1Wv4o
	 440JBf0X6BkuCOQ8zhLNq5nqjt/FqVJiXUF/S4RmE/QeOyiMRNwi1ptfa3UiZkSFpNw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=amd.com;
	spf=fail smtp.mailfrom=amd.com;
	dkim=pass header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=Winfs3uk;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.208.34
Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azon11011034.outbound.protection.outlook.com [40.107.208.34])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CBB9606A326;
	Wed, 25 Nov 2026 14:05:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6CBB9606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=Winfs3uk
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fjSfIk/ZVCDzh7Xu0zRrMsSGRUXxwy7QvZC/UR5slswaO7EXoiYVmthrIASn35/iEKVSTJtu6VRnAAivB5AsrZ38ioWhyK36NGBh2gHtGYRXyhom57D9RhEquumD/1DlDIhfa87AxVtFaC3Ii6xM3S4urOYdpcShNoHfWWfPJ0KUaqdH2uk0QicQZHJLGZIr0PqhLUgx0pxCYpssZWe2q1Ke+5DyAw7Lp8uRYICZp0PJkmSJ2nrzGfrG6dVxwYZ2vfNnP+O6eeN48adrLzEYRWxv+lgxQ2dkUf0bDn55cLaVbNVbIrE73I71Zp+CHqJRVtQXKzP3oScw469JIem32w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+ZP6FaQ+AXUkFN0q1DEy9aUkZxlxBOF8AKYa5llXE9w=;
 b=yMLqqRQa01KRqR0yPK3gSSU93EMzBAEOCFN0mUEV2shrvOu0NxNTaUhrQb1sz2B28Dcxl3emuAZ7I1UUi3vB8k2X1ZjWiYv0RR+dDbHxq/blg6J1bBuO1Jvdy4st9o3oh6UlbS2QIfS++LwMPOwHjcY9eJWtMogI6/AKjd8nMDz70I3Cre3IMa/0JWobGTe2dS9BdswtY5yHotJS0v2xSuyaM6neHTu8ioCmPSSqpBgqNBKpxiE8IWeH1dcDTk2HSjdS8FbvfhMZ337S4IsQ50v3h6o/ubbtU8ZUKCj7guUmZC44yvlhRDpmZ0KHi1eXSrp7AAoegKHGybdEP1Mlzw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+ZP6FaQ+AXUkFN0q1DEy9aUkZxlxBOF8AKYa5llXE9w=;
 b=Winfs3ukQGF49LF+W48U9/bhNm/2mETxyx7qVByddPBIJ8FozxsMe+Yd4r2XfQU5Wge5Q9IUT465iVJ/TSmEJ7HKB5CRAUvtRYJqSZP7ElSp3oIAL6TSVMImuSb53WgygtcQw15QyEZ0Pv1vYDygYvehVLj1ENFJkfPOjNkUNuQ=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS4PR12MB999102.namprd12.prod.outlook.com (2603:10b6:8:2fc::9)
 by CH3PR12MB7665.namprd12.prod.outlook.com (2603:10b6:610:14a::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.662.6; Wed, 25 Nov
 2026 14:05:43 +0000
Received: from DS4PR12MB999102.namprd12.prod.outlook.com
 ([fe80::dd7a:c52c:c74c:2a25]) by DS4PR12MB999102.namprd12.prod.outlook.com
 ([fe80::dd7a:c52c:c74c:2a25%4]) with mapi id 15.21.0639.012; Wed, 25 Nov 2026
 14:05:43 +0000
Message-ID: <74b62bfd-a088-2474-f003-95651c700d82@amd.com>
Date: Wed, 25 Nov 2026 19:35:34 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.0
Subject: Re: [PATCH rdma-rc] RDMA/ionic: Wait the device command timeout for
 admin queue commands
Content-Language: en-US
To: "Nikhil P. Rao" <nikhil.rao@amd.com>, Jason Gunthorpe <jgg@ziepe.ca>,
 Leon Romanovsky <leon@kernel.org>
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
 Allen Hubbe <allen.hubbe@amd.com>, Andrew Boyer <andrew.boyer@amd.com>
References: <20261118-b4-ionic-rdma-admin-timeout-v1-1-39536999a3e4@amd.com>
From: Abhijit Gangurde <abhijit.gangurde@amd.com>
In-Reply-To: <20261118-b4-ionic-rdma-admin-timeout-v1-1-39536999a3e4@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MA5P287CA0212.INDP287.PROD.OUTLOOK.COM
 (2603:1096:a01:1ab::9) To DS4PR12MB999102.namprd12.prod.outlook.com
 (2603:10b6:8:2fc::9)
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
X-MS-TrafficTypeDiagnostic: DS4PR12MB999102:EE_|CH3PR12MB7665:EE_
X-MS-Office365-Filtering-Correlation-Id: 3363c251-0c9e-4f41-ed73-08df4afd314e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|23010399003|10067099003|11063799006|56012099006|261021121427099003|261021123027099003|261009223027099003|261021135927099003|261102123227099003|261022105027099003|261028144727099003|261026140227099003|261026121527099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	MKjDyRaCSuJAWsOW+mpStMUi0os3Lb0a7MHFli+Vdt8nyA0piebl7rO/SgEdfAq8pB9vpWTsD5eUx9BCqwK1LhKe7iyL9OwASU4v2JjCF2OngyrcB1xYTJuub7azXbdc9AgiQFxpzAbTNqGeM2fqi/WZ+SHm3RQJ0AFDDNlZRk46sdHHeIKZNQWV4ZduY8YzSgJWGUMkt5ErWRYjrGZVZns8oP/93vUZzNzNC8wnilABIK/30k1zYBBwVhghFsZBaiYwj23IM6bzb+LIItAX1BNcTSerHAqIMkmERptIZhr8VdEeBsK0bGDUf3aP8HXpOlKDiMsp6A6ho4V6eEzubv+FrLDMSZXyN1JY2X0IfWKuYFDcOamlpzI9JxTJa2nsHVzLEJyOcso6ebsiQKR6nPUdJBqi1C2KrlTtTc6yrb2p1sKypBysRZMHa48pQfbFbG4LW29bnfr7Rq4ZQu9T2h0Uc8IKVZGISOyDAm8wweiCD9zWBOz1hLcMstOc02hwWcP1N8Iel4sN/nS7tsYvqfO7C/Yf77/ASbdhjYXTAy0tCpitx0JPtuYmfEKbeu9X9zPaoK+rzqEPbaomAqPBt1ybcVzUytJnOdvt8TaLDvSJMntnaxq944cAcmR6cRwcPMRcQX+inTu9hrMyDh2aEZb5eWKrdoNcwKnO0v0+JbA=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PR12MB999102.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(23010399003)(10067099003)(11063799006)(56012099006)(261021121427099003)(261021123027099003)(261009223027099003)(261021135927099003)(261102123227099003)(261022105027099003)(261028144727099003)(261026140227099003)(261026121527099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?SFJob1N5RmVZQ05YckhWVlVCc2d2OHVtMEtXdnlVSkg5ZUEveExoSnpqaE16?=
 =?utf-8?B?OEhPUDBrR0xRRzVOaU9LeEpRRnFtUXlpUVpLTmVCQlptdWtaeGlWK0x0V3p1?=
 =?utf-8?B?cVNrMndlSjU2Z2MyWGI1U0M4ZDFDeGlLZEg5WjlFNUV1azlrVE8yaXhVOGJS?=
 =?utf-8?B?ajlLM2Nad29nclRLeHFFaDRpdnJZa3JNZW5lMHRuWmg4c1hnWmVpZVorOXd2?=
 =?utf-8?B?Q2ZJMVlSd21OaytEWjFPQmEzRHpuRnNJL0RwVnpYcTJ2OTRCb1AwWEF0VUhS?=
 =?utf-8?B?MUI4aW9raXJXUTJZRVpIVFZ0U0lMZFUwbWwweFhVcW0rS0hOVGF4dHpITTJQ?=
 =?utf-8?B?SUFIaTJsUTJPdjhrdWRjREtnd0NweVdjQThVTEN3WjgxdlJ2ekJTZ1BtcVdT?=
 =?utf-8?B?T1AyYVZmeTlxWXkrd3htWjBSNVVjNVg2d1UwQ05lOFFHekVVdno4VjQxV1Jl?=
 =?utf-8?B?WmV5SWpMeXNKa3lQZ1BsRjRuY2szblZPcmxZN2VyTUNGUFp0Z1VST3h2RzIv?=
 =?utf-8?B?VXV5Uk02V1lEOE9GekNiUUltSmd1dE11ak1hWDZwV1JrK2p0OHd3UGhMbG41?=
 =?utf-8?B?UjI0bGNyanAyakZQaHBmSFpPWk9pRWZzSEhCUUtmc09uYzlwZmhaTEVIT3RV?=
 =?utf-8?B?UjBtSU50QnlRd1pGNkN6UkxRNWdCQlB3RTc0Sjhsdm1sNmJ6aTQ3MFkzSFZG?=
 =?utf-8?B?aTR5T1dmQlIvcC9SMVB6Q0xWMHVvMlZEQWZRdTNYY3ZLVDZsVlRiZUNab1ZP?=
 =?utf-8?B?Y2E0c0ZHZlBpenNja1JkZERQdnV0KzlaWk5SUnR5SmdkREh1QWRSRDFIRExx?=
 =?utf-8?B?bWZCdFJRZ0FZNEpralBYMkM3MXU2TFpMNkR4WWdDcnlJd2crNTExN3g0ZE1n?=
 =?utf-8?B?UTZ2akUzS1UyNmYycW1rYk1HUFBaV3Z1VTFXa1N0aEFCYXVHbWh1Tk1HYmFt?=
 =?utf-8?B?OVZBbTBTNjdseHBjMGhEUTJaZnJBNUZUMmMvRFpyWEE4RGdPd2xDamVkMFFW?=
 =?utf-8?B?Y0pqUmhSaDlJc0tkQi90eXlkTVlTY1UyNkdxcUtlZXI5am12SHRZQTZobHdI?=
 =?utf-8?B?aXd5U2tSNzlJRDlvYnFqdFVCd20wcFZxYjcxZWc1QjJaaVdzdXh1enR5WUdH?=
 =?utf-8?B?OWxsZnhxVjQvejd5ak81UVhld1MvdHlTYk5EcWs4UnZmU2FZVDZUM1dETU93?=
 =?utf-8?B?UE9DMU93RFIrb01pclFyRnZreHBXQlBjMmphQWFsLzB0QmNHak1Yb0VNVGVq?=
 =?utf-8?B?SUExQkkyYlczd2xWZk95VGRHSVdIb3Z2WU5VRjNNY3JZTDJqcWRGa2h1YW9M?=
 =?utf-8?B?N2trZzAxRHhyVGNENnhRMSt3VnJyTjAwcDUrRWs3dGNGN2YzTXQyaWpRM0Zy?=
 =?utf-8?B?c1VMWEMyaVkxVjl4cFJnU0V0UnJOYUFnSjBPTWhveFplcEgzQ3QzV21GTW5K?=
 =?utf-8?B?K3hkd2RmTDE2Zmh5NjlZSE4rNGVKRWI5TER4WW5OTVBaV05YWUZ3a0lYVUJh?=
 =?utf-8?B?aTBlVXlLZ3l5NmZGaWFqdUhwTlV6dWJQRUVjUEVqUzJoUTNtZ0M0V2NkUjhM?=
 =?utf-8?B?ZWZsUnFYT0E4TEFnSmJ4SXN0QXdYTkUvQkE4SGx1UjR3ZEw3VzgvQkZyWmVp?=
 =?utf-8?B?UmhTZFliS1JhVEhHYzhOSlhsWUdZZHhWbFBuVnFLWnhCbmFjRWFVMTdXYlgv?=
 =?utf-8?B?UDBFT21neGs2eCsrZUxlcmZmclpkYXBDdmlSSityQlhBZFVkcEhNajhvNGlk?=
 =?utf-8?B?S2xPY3YrVXVaMlBQLzdlb2tWVVVsTTNkbVRmR2daTXRyNEczTnVYRDAxK3dM?=
 =?utf-8?B?NWRmQ25IQkMvR1J4T25DSTk4VWVPMENHQ1VDUzl4TmRBemJJZzVVU294NHp5?=
 =?utf-8?B?enB2RW91eTIvQmdPa1dOcXlqbnJQQnNHWCtEVlFqbVdWZGlxZ1Njck0yR2dy?=
 =?utf-8?B?ck11dVdtTmVMTC8vN2tNWFdadk9pc3l0OTRkYlVHTHpNb0l3TmF5cHVJek5r?=
 =?utf-8?B?OThvdFlqSVdwcnZ0QTZxZkUxN0FPWjdvZEFWdVQ2Q09ydDlaMkJFQmQ3aE5p?=
 =?utf-8?B?dm1NY2dYYVhveDk2VFAzUjRmeWp2VU96b1JVbTR5bFg0VnIzK1BLY3lpYktR?=
 =?utf-8?B?K3BKb1NsU1NDNlNUQkZOTDlYNmFEODVVRUFKS1RiUGtGMC83VmxNK014OFZB?=
 =?utf-8?B?R2syUnNGcFgrS01ibDRoSTduSmNRUmlid09NTEVUeW9BcXhQdEdOZTZ6N24w?=
 =?utf-8?B?OHhuQm9lYnROTWJJR2JSdnp6S3JCRXUvVXp2ZXRIVlBWMVI4dHJsL1ZYdUgy?=
 =?utf-8?B?L29Hb2V0N0tNekx6ZzFyZHdEMk1EVTM3d3NkaHhwdVJVNThKZmtyQT09?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3363c251-0c9e-4f41-ed73-08df4afd314e
X-MS-Exchange-CrossTenant-AuthSource: DS4PR12MB999102.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Nov 2026 14:05:43.0732
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2JlgiJ5d5mSh+G+5H3WIOLnCWVpo93SeI+ri/4hFLKdmbe+MNeDpApZyjRtSbagVDvmu8pEZBUmy3UJ+8SxEYA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB7665


On 11/19/26 03:27, Nikhil P. Rao wrote:
> Commit ec8ee714736e ("ionic: stretch heartbeat detection") notes that
> firmware can take more than 2 seconds to service a device or admin
> queue request, and is only expected to complete it within the ionic
> command timeout of 5 seconds. The RDMA admin queue watchdog gives up
> after 2 seconds, and a timeout resets the RDMA LIF, after which every
> verb fails with -ENODEV. Wait 5 seconds, as ionic does for its own
> admin queue.
>
> Fixes: f3bdbd42702c ("RDMA/ionic: Create device queues to support admin operations")
> Signed-off-by: Nikhil P. Rao <nikhil.rao@amd.com>
> ---
>   drivers/infiniband/hw/ionic/ionic_admin.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/infiniband/hw/ionic/ionic_admin.c b/drivers/infiniband/hw/ionic/ionic_admin.c
> index 0ccd869ad8e6..859893568538 100644
> --- a/drivers/infiniband/hw/ionic/ionic_admin.c
> +++ b/drivers/infiniband/hw/ionic/ionic_admin.c
> @@ -19,7 +19,7 @@
>   #define IONIC_ADMIN_BUSY_RETRY_MS	1
>   
>   /* admin queue will be considered failed if a command takes longer */
> -#define IONIC_ADMIN_TIMEOUT	(HZ * 2)
> +#define IONIC_ADMIN_TIMEOUT	(HZ * 5)
>   #define IONIC_ADMIN_WARN	(HZ / 8)
>   
>   /* will poll for admin cq to tolerate and report from missed event */
>
> ---
> base-commit: e7732ec135b501e87ab060d992b3b5f2ec4396c9
> change-id: 20261118-b4-ionic-rdma-admin-timeout-3cc9f4afe247
>
> Best regards,
> --
> Nikhil P. Rao <nikhil.rao@amd.com>
>
Acked-by: Abhijit Gangurde <abhijit.gangurde@amd.com>

