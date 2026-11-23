Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.193.38
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795475705;
	b=ACdUesNcTBb9jIwb1LHkz3vsA/TM2B3a6/sFb+hDeWo0kd3WHNnn1oNpsKIDM66wGQPa
	 +vIQJJV2QL9w6ynDpB/lFG49BLFiRbR7U2ON4WSjedCD9fRBHoUBuQ4SasLJnTZaSCXZM
	 TsnSL6O8257mJ1IkcmN7Qu6f2qzb4lAfQO/AmJTmwqZKGka8PjKqRU+guRrSZ5hQ4edN3
	 z3aXi9cYRbRgr/XivJni1quXtLF0uoYDh9sRIiIM+lyDktMfQVF2RrijCnL5GUcvHk9Jr
	 4gPfIjkWB1DStpTejx1z3gBYMumysNysi2ompI6JbjKJRASPnf7M3232ppzSNucIBtw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795475705;
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
	bh=47MNfDe86I2wbOebD6g7jBIVomlr9v38Y8J5WaQuAqM=;
	b=OZ2kHJpvjkD3+rd5HZ253aGsV8mN1Sf/UzsmPpfz+QglieAq4nRRT0UBVekLAWaQbU7u
	 wnVKOqmAg6jeTs0hE+inbPagrOn8CsXUbHZOOCrJUwQ9mOaUEeZy85NVdbc2TA3xb1RTu
	 j4W7dM9TN4LNcXpypZWfHVJGCe21HMYhPZij1oukCCqd2sJdcsdTIaYyrrWQebPMCaUP2
	 zMsCi73w5o14DzPAMONU40HqMndURvjPyzkMaN8PZCOawOInOCFm4wrFbOkLD81R3kzJ/
	 v/LNj+7MYwPs4QRYH/h57Sfa2Ps5mVlaWiwZtswHs/GNbM2IKWFDw1cTtniH66YN7HA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=amd.com;
	spf=fail smtp.mailfrom=amd.com;
	dkim=pass header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=dnXp31HF;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.193.38
Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazon11010038.outbound.protection.outlook.com [52.101.193.38])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD79C606A680;
	Mon, 23 Nov 2026 23:15:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BD79C606A680
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=dnXp31HF
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Be9lTL4iwOoBaCymlPiSkP9jdu/12Z/5F5pXYuOGLkYstdO7HiuaDia/vmnynN/+YcxjXMrA8QtcbcglDRST4NhS2VXJBAROpidBOUE3V41tccACB7gVroY9pcqPNCUik6BCj1WGD3uARbw+hMa9fhbaaY4/a2fUYs045VrFe7g1SEWbtOAKHc8DZmGs50igb3geZ0z3sQHotnjr6GABkZ6vjV6IOYmoTbP0pvxqq+kudjkpyzYqvABL4rvJTlnhIIgUOppMSfgx9p46qOKFeiVrrHYX0kQBTpLptcUidKLRDMJAdObWlC8SzTIKfzaw111i9QeYpYKf2UiOw6jkFw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=47MNfDe86I2wbOebD6g7jBIVomlr9v38Y8J5WaQuAqM=;
 b=hhx/6MpPKUM6ciPXBBIVPOVASy3bNMNmSNd/gM0egnSaLO/6C5d3QIaliFOo7N/O997w6aqStG54ldh1tQw1HtvxcwJIACVXYsGiEMoGNSpYUyj9Tfaj+WHZjaxLVWGJo1bL1wHKJjYC+A0Ulr5aVgQkCrfKiJUuiwNMj5kfnki6PVdta3kRkR/D+qUxtA/siyLCL0N5cdck5ZQ8cPC9/6KQl/6b6jZDBFmZxvzVYIwJrOU8WUPqx3h+3KN6HD7EYkmgnCtNeZDM1HBc8SIc7D0OetVrtqokNFSgzSE9NAtDBBLTHhIyqw2BqQth0z5m8QzlSuGKrZnWexxM8cKIBw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=47MNfDe86I2wbOebD6g7jBIVomlr9v38Y8J5WaQuAqM=;
 b=dnXp31HFbBJXwcxHX0Om7hRJR2n+UYtMKybbbWEcGfw0EPaAF4VHiRsvxT8p+Q+xskqeA+6ghNIRh3izcw5vpyUYvJnfCQ/0UMwseCNyCaA/TlsrmH0dWGOuW5OiQTsKtI/sBF1BJGNTRsnyTwn+y/9JQB+EdCBrJuvEBF0TM7Y=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from MN2PR12MB3485.namprd12.prod.outlook.com (2603:10b6:208:c9::22)
 by DM4PR12MB8572.namprd12.prod.outlook.com (2603:10b6:8:17d::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.639.12; Mon, 23 Nov
 2026 23:15:01 +0000
Received: from MN2PR12MB3485.namprd12.prod.outlook.com
 ([fe80::7ac:5acc:f8b7:65c9]) by MN2PR12MB3485.namprd12.prod.outlook.com
 ([fe80::7ac:5acc:f8b7:65c9%7]) with mapi id 15.21.0639.012; Mon, 23 Nov 2026
 23:14:48 +0000
Message-ID: <1120d8eb-023d-4fa1-823e-0f8d05b4d869@amd.com>
Date: Mon, 23 Nov 2026 15:14:45 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next v3 3/3] ionic: add devlink param for command
 timeout
To: netdev-bot+sashiko@kernel.org, nikhil.rao@amd.com
Cc: brett.creeley@amd.com, andrew+netdev@lunn.ch, davem@davemloft.net,
 edumazet@kernel.org, kuba@kernel.org, pabeni@redhat.com,
 abhijit.gangurde@amd.com, allen.hubbe@amd.com, jgg@ziepe.ca,
 leon@kernel.org, jiri@resnulli.us, horms@kernel.org, corbet@lwn.net,
 skhan@linuxfoundation.org, rdunlap@infradead.org, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
 linux-doc@vger.kernel.org, eric.joyner@amd.com, ArunKumar.Prakash@amd.com
References: <20261119-b4-ionic-cmd-timeout-v3-3-2cdb8fca15fd@amd.com>
 <179539559673.3135.12079878343644861835@kernel.org>
Content-Language: en-US
From: "Rao, Nikhil" <nikhirao@amd.com>
In-Reply-To: <179539559673.3135.12079878343644861835@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0186.namprd03.prod.outlook.com
 (2603:10b6:a03:2ef::11) To MN2PR12MB3485.namprd12.prod.outlook.com
 (2603:10b6:208:c9::22)
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
X-MS-TrafficTypeDiagnostic: MN2PR12MB3485:EE_|DM4PR12MB8572:EE_
X-MS-Office365-Filtering-Correlation-Id: a5a5c74f-7907-49f1-f6ca-08df49b791f0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|376014|7416014|366016|261028144727099003|4143699003|261102123227099003|261021121427099003|261021135927099003|261026121527099003|261026140227099003|261022105027099003|11063799006|5023799004|56012099006|10067099003|22082099003|261009223027099003|18002099003|261022075727099003;
X-Microsoft-Antispam-Message-Info:
	MQuXKomY5myTsGNmFaL50yexky0IpSNDPL5BdaRD3+yvoSXJsKLmmq/oFTw0dR2Xm2HLiSlw8XnYFA5AhRT9FfuUqE51dALPGcf83S4Q1Q2fGWBfPSWAs0h3usylEAWVFfm/KL/Bp0tyE2XRvH1WGTG+XIu9fjT6bKJE/dIlu1D4lwTw3Z/IDphR8OSBrPG1uMzlibnnGXi+Va/8tha/7U5hCF7hn+scY9GbDrY2fbx0ngOLtZyeSvEa0kk0OYHsx5AqQtuRAVehxffwqmLJOi1xYyt/hhYBopclZwcpjLWOLZDxdR1i7GqqYmJdfHwdnrwl3nlGNhYjgC8IHGBweU0Y4ueC4fHgAMhv6HVEwTR88NW6IndvqKxRQvMUcVXfZzsK/80GLCs6F3Z+jlcPfXZ9vKL3+JVogSyh9Rt7Lvo7kT9J03jD9btRrvyLxExpX3VPXPUkFk1OzDilaPyOY9Hg2xv7wveVG9dRfJEnpqtCfLEGck+PiaySV4Ur+Y0MWjbTgSBG8RvEExdctpOc9ZgpCB/ewWRN0ySzAhHIuaFISM+6iI/lSJSGw8x5jZDXO72WOJ17lvRYvJ1oPb8reanjg0dIT4hJYkFpwCldC5ln7aWX63EuflZGdvbNAr9tzXsvYLOMW7roo+jjHFeQ0Vi1a0zrBiF0VLOLzK7iN10=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB3485.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(376014)(7416014)(366016)(261028144727099003)(4143699003)(261102123227099003)(261021121427099003)(261021135927099003)(261026121527099003)(261026140227099003)(261022105027099003)(11063799006)(5023799004)(56012099006)(10067099003)(22082099003)(261009223027099003)(18002099003)(261022075727099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?aWZ4VUdsR2swd3ArUFpXd2x6MjliZFRBaW5lbC9TMGRlWERPY0FFdmRaNFd3?=
 =?utf-8?B?UUZXY2JVYm5kTllKWXVMYWR6S3pBbkV5LzkxU1FiRUszMkJGMWlaL2hOSVBZ?=
 =?utf-8?B?b3kyNEI0RlNYNitZcktIQUFKOHpqcWg2L1owUVR3REt5MC9XM1kzSGdZakNv?=
 =?utf-8?B?VG4wUWpOWU1GaU9QenlnQXFqSklvTUVmUDQzQ3UrWlZ0TFZXS2hnUFJZQStV?=
 =?utf-8?B?b3M0ZHRTeTJ6c1k2bkxhNXJ2Mkp5MTVkUG1Cc3pqRksrSHpFNWJ4L0FvMkZB?=
 =?utf-8?B?YW1BSmN0MVJ5ekpnNHNRWnpHYlVpeE40UUgzQ0JnVy81TTluOGxSSit5KzBy?=
 =?utf-8?B?ZU95UnpaUFlLd2ZJWGRvdCtqTW4yRmJhaXlBQzBrcDVna0JlSUlWcTVPM2Zv?=
 =?utf-8?B?czFtN3piQkh2bndHSExrRG9ISDA2UGdjakZINDdvVTZCandvS3JuWTBBVVhU?=
 =?utf-8?B?elZ3VE5BcVVvd3hXR0hJVEJ5RDNkNlFUb1VPc1pzRi8rTDdEdldKY2lVSkl1?=
 =?utf-8?B?elRaRmlyQ3ZKTC9IckV1TUdQT2hUeEI4MmZGTFVMSURUelFlQWg3eEcrbkQx?=
 =?utf-8?B?U2x2Skt0ZVd0bXJkY1JBcVVQNXlVSi9iWXVoQ2ZYbE1JMlpuREpZcmZmUHQ2?=
 =?utf-8?B?WWg5WFZYVHdLakg5WGhSampObDdDcUVJVFJJeWZQZUYwWmhCZmwrd0x1cjRE?=
 =?utf-8?B?dHVqL1BmYmVGRHRDbVVpU0ZyOGRaMTQzZEhRUm1ML0F4QndkNy9CUURmN1Rt?=
 =?utf-8?B?MWhIVnpScGg5ZnRiTFVuVlRDclNhR2FpSE4xOXhCTFhSQjVhdGNYTWhLMmdI?=
 =?utf-8?B?cjZrdE5CQ3VQVFdxUU5jb000SlUvSGZCeVV0RURwaU1QRDhFNHNQK2JPcFFk?=
 =?utf-8?B?djE1TVAxWjF0dWZ6SURQL1I1WUxzakk0VmtFazFocDB6MzBsMko5Ri9mdEp5?=
 =?utf-8?B?SXBJWEdKWjFGTzBRMEFJbEtKYWY3Um9CKzJaQU1IcnBrb0ZIYUVFSkV1aExa?=
 =?utf-8?B?RjRqdWo4WGZTK2tSUjg4ZE5TSU9BdFVnQWxlUUJyc2c1eVN4R2d2YVc0blIr?=
 =?utf-8?B?UDRhMXBjbFRRVUJhU3JWRnNadm1zOGZQMDdwS3llSW5vd1VmaTYxTGpnRXlH?=
 =?utf-8?B?KzNobmR0SE9PSXYxdnhYUFFYTDZGS1ZnU05SczZzWnFJY0YvbnNINHgyNUlX?=
 =?utf-8?B?ajJOZXZuMnFqblFTRjRySkVPeGhUNXl4V2RGd0dNQUZHWmE0ZS9Bb1kxY0xw?=
 =?utf-8?B?NTlPRUw2MzgzaWlPbGhSQlNMVHNGY2JjRUVyTTFYQXoyVEtCQzB3alRqZjVm?=
 =?utf-8?B?bklPdDdheEg5RlNod3NkTnZ6Wnc2cmlmU3lIR1hDTE9TYUVDa042Mk9yOGNW?=
 =?utf-8?B?YXFNZ0hadDd6WTY1Zis1ZEFkUG9WOTg1S3Y2WWx2bHRaZkZvVkd2UFF1YW9H?=
 =?utf-8?B?a3pFYVczK010blFES0R2SjVKemJ2UUUwVDBoODNGaFZFRCtYemFlUDVHVm9S?=
 =?utf-8?B?dkZRK1RYYmlDWjVXdXQvRVE3QlR1WWpUNDRjZHpvd1kwc1RsOWs2MDVBNlBS?=
 =?utf-8?B?U2FsVXhySHJKdnRCTU1QUzhsK2hnelRLSExVd0JSUnoxM28xYkgzaEE3K2xY?=
 =?utf-8?B?YWhWUERvb0VTcC83d2Z4b0NmM284Rkk1NkUzYWVpSUlyZGVXV3RFT1Btd3FN?=
 =?utf-8?B?VTlVZkJObnY3Z0U0Z0huVGthRGtVL1FiQVREcytEV25XY3RiVTFVNS9GYnNC?=
 =?utf-8?B?TjBPdXptU1hKNXJHRStMMDdITUlBWEFhS3QvZFlMMm9iZ1hhclcrU2V2elRW?=
 =?utf-8?B?Vm1xVWRKaDlOTzZrV0prNVAxWHVEazdzN0FSNFFjb3UxeFNXaEV6TzhFRFVm?=
 =?utf-8?B?UER5MHo2cmNGK0JLUnlzeStVZ1VLYjJVOFJUMFZOdjJaeUxCUkZVMXU0bkI3?=
 =?utf-8?B?OUd6elo4NWJWTEJZK0VJTG5CWlhIK0NVV1FNbGI3NUR1aEZzb3hsK2h2STBx?=
 =?utf-8?B?MHFqTDErMkZhZnMxNnd4UWUreW8zRGhhWDJWREdIOUcxeTNkNzhiQktTYklY?=
 =?utf-8?B?aXFqN25YZGFaQ3I4M0g5M1Q5UG9vOUI4QzVQWlVCR0RqZXV2ZVVYYnF2V0Ns?=
 =?utf-8?B?YU5mRHhnZHM1aFpYTFdpWnV3L2dtbDRkcnFJNFJKM2k1aFpsWldKdm9UWldF?=
 =?utf-8?B?MCtOdmxmYy9aVkhHcGtmbTg5U0RDWHo5Sm1GWFVHSHgvYWZwWDJZQ0xPYjFX?=
 =?utf-8?B?S3V1UFNMZmxFLzVIeTNlUEZ2ci8zR2Qzd1cwcGc5NnNsbFNQR1BKdVNpZVJm?=
 =?utf-8?B?UnMzcXVEMmNTWWxuWmN0QjFEVWVJRUt2ejdzUFdWLytYVWxyMi9pUT09?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a5a5c74f-7907-49f1-f6ca-08df49b791f0
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB3485.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Nov 2026 23:14:48.8099
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YmqcCon9EETZU6lTNGZEF2nDER2A3aE+BqekZuv++HftiCKSWKnOPXi9G7L5lTphYaeJrrFOohzOiIf3EbmxvA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB8572



On 11/22/2026 4:59 PM, netdev-bot+sashiko@kernel.org wrote:
[...]
> Doesn't that leave the user unable to see or raise cmd_timeout until the
> next FW-up or PCI reset? That would happen on exactly the slow-firmware
> device this parameter is meant for. The -EOPNOTSUPP also hides the fact
> that the query itself failed.
Yes, a GETATTR failing at probe on firmware that supports it is rare 
enough that I would rather not add a separate state for it.

> On the fw_up path, after an earlier query succeeded, the same failure
> leaves a stale positive value instead. 
It is the value last read or set, which differs from the stored one only
if something other than this parameter changed it, such as a firmware
update across the reset versus probe where nothing has been read yet

> If the slow firmware still commits the NVM write, would
> ionic_dl_cmd_timeout_get() keep reporting the old cached value while the
> device holds the new one? The new value would then take effect without
> notice at the next probe or reset, when ionic_update_cmd_timeout() reads
> it again.
Yes, get reports the last value read or set rather than querying the 
firmware,
as any user can call it and a query would hold the device command mailbox.

> Could a reset during that msleep() cause a NULL+offset MMIO write, or an
> access to unmapped I/O memory?
> 
> The missing serialisation between reset teardown and dev_cmd users
> predates this patch.
Yes, this predates the patch and affects every dev_cmd user.
It will be fixed separately for net.

Thanks,
Nikhil

