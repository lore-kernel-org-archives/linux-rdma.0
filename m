Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.193.8
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795474344;
	b=tLpydNNB5CefNV9jFT1J005dkNpA3FqT7PPE6XP7PktIvM5k+Y5r8NL3zjnGV/2KG5r7
	 1Mfa39UFaXTKx8Gr+wb1R99h0G7OKMApOpowX3FlFY/EhxLi539IrcxPWOkgCYPm9plfS
	 6X4pcXpbb8HL+AvSWI79egIUsWaATHgrnhe6TwggcbicNGEcyusFDbKYv+qvEIlf9YS66
	 j15PTYZdYBoYSeflyO6EmXoZI7pYrcikHXVMWsHoCOF+u0DQapjmn+slTIrMNixiS6Dwq
	 O2spnHOWvfaUHKn9MVCELKP0ICQwgKfKmUx0aXMrmAvxxKaXsOOVVx/f4beOoG0bqVg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795474344;
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
	bh=fSXsLtSg4B0myYuZ8XMEe2lEGjAIu4iVzbHSGcsEBQI=;
	b=DMnXjx+kILvfAXQCo89RLnG4w/zFV58Hw6ZxsPsWm0o29O8tl3D2rJN/GH+vuOwtlbgF
	 pOIYwwweF8WLzIbUTfeSqYR4fEpXrGK9rxsRF8rcnSVVJdnYI5ScSGq55mrivEAlVXp3j
	 4xXPjC5sivQBkW3pZxNxplFaYP/HAehLqIsoTytnoHSj8eI2f26gHvkWbocJ+H4Yg0Rra
	 v5iO3vrNZuNgbosTlaZrRp2XoZ2Wp4fL8hJZanIOI4K09J5pZLEBndY6+Hog4ffG+j/s+
	 2t7rIlhX0ko///+LNh8Wz8n6nc+zS52KY7nHOMOJrGcPNljN6cApGDkbznrgJV6qjuw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=amd.com;
	spf=fail smtp.mailfrom=amd.com;
	dkim=pass header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=TDuH9Qs1;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.193.8
Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazon11010008.outbound.protection.outlook.com [52.101.193.8])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49F0B606A32D;
	Mon, 23 Nov 2026 22:52:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 49F0B606A32D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=TDuH9Qs1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=K9mwATSr57AucVDDw7UufARMSBJoidRfJodx+9a8jsKGEevd1G7eHzjOs8RulGMowRUMaQvIKjLVrOo10E9B/m/iezn5qV0W/b+WP1Tbv6M8vMKtybdfYXO+zJsKVJAewVSbfWtMPiLA9x+4FV27uxFrnQF3dvQRLr+URB8gPvYxjTXB5XPsq73c3aT/A5QRBvEThRvIx1KsdWYa95EXLjalETofaKfObg/VudT46rBzeIOE7bV2nfRfxlHtYWGjZvotmmSoeeV7CxvvodMOs+ElHXA4jsKVMIjBmWZZv8qBdO9SvH1mJwMI/7h4dV1Bvtp2Eiiczm+q2VXztBNjqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fSXsLtSg4B0myYuZ8XMEe2lEGjAIu4iVzbHSGcsEBQI=;
 b=BMFXAo0O6aWtizH684LgilUG3Frs2KOLzH96OcYbxrvn2cNeBHMPi8yav0010mhXgnJNNAjDfgdlpFT6yu4NuoEC7DwW9vz45sup8V4W820BtZ/o9NzamK/1aXKb8xPGD9ktd5EWL61d3EyAjm9Tb4/vlPRi391l83DWfs7GhHd1W4+MsUJEJ9tAf86Rmla4LfKvEr2o5wd8w7TKr/KvlZozJKeFOTyBAjINR9Nv4At/+Wl3k4lFwoXMPdlSLN/vMnLdZsOFFTsgtOFNlpGapPwlnHSETUSKEGWl9Y0oFr6xuPcb9jnffLfl7WzOzBxc258GejneELH8RlukGtwAQw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fSXsLtSg4B0myYuZ8XMEe2lEGjAIu4iVzbHSGcsEBQI=;
 b=TDuH9Qs10NFlkG638FzsGFs+mDr3OmFXT7u3SN0xdnWXHwtD4JhPdTy6X3kN13P5+m+CppSODLTUnCqQUT8y0o63en8MQzrBOJaV6Ef7n6RYFEm7FxbhPb1WVBRbFq1AobT3FBmkB0xR1Y+nycrRiEei+gY55504/ag1rfpuCJQ=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from MN2PR12MB3485.namprd12.prod.outlook.com (2603:10b6:208:c9::22)
 by EA3PR12MB178636.namprd12.prod.outlook.com (2603:10b6:303:308::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.639.12; Mon, 23 Nov
 2026 22:52:20 +0000
Received: from MN2PR12MB3485.namprd12.prod.outlook.com
 ([fe80::7ac:5acc:f8b7:65c9]) by MN2PR12MB3485.namprd12.prod.outlook.com
 ([fe80::7ac:5acc:f8b7:65c9%7]) with mapi id 15.21.0639.012; Mon, 23 Nov 2026
 22:52:20 +0000
Message-ID: <de51f77f-b077-4c96-95d0-50b7248df7cd@amd.com>
Date: Mon, 23 Nov 2026 14:52:16 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next v3 2/3] RDMA/ionic: Use the ionic command timeout
 for the admin queue
To: netdev-bot+sashiko@kernel.org, nikhil.rao@amd.com
Cc: brett.creeley@amd.com, andrew+netdev@lunn.ch, davem@davemloft.net,
 edumazet@kernel.org, kuba@kernel.org, pabeni@redhat.com,
 abhijit.gangurde@amd.com, allen.hubbe@amd.com, jgg@ziepe.ca,
 leon@kernel.org, jiri@resnulli.us, horms@kernel.org, corbet@lwn.net,
 skhan@linuxfoundation.org, rdunlap@infradead.org, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
 linux-doc@vger.kernel.org, eric.joyner@amd.com, ArunKumar.Prakash@amd.com
References: <20261119-b4-ionic-cmd-timeout-v3-2-2cdb8fca15fd@amd.com>
 <179539559480.3135.11592624744457325166@kernel.org>
Content-Language: en-US
From: "Rao, Nikhil" <nikhirao@amd.com>
In-Reply-To: <179539559480.3135.11592624744457325166@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY1P220CA0004.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:a03:59d::15) To MN2PR12MB3485.namprd12.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: MN2PR12MB3485:EE_|EA3PR12MB178636:EE_
X-MS-Office365-Filtering-Correlation-Id: 4b2549c9-eabe-45e9-426f-08df49b46e09
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|23010399003|366016|1800799024|18002099003|22082099003|4143699003|11063799006|56012099006|261026140227099003|261021135927099003|261028144727099003|261026121527099003|261009223027099003|261022105027099003|10067099003;
X-Microsoft-Antispam-Message-Info:
	TNZQ5auvg7EZKUtcVTCmxZcCBir/o/BabjH3aaLU1C7SpiLm+fLThP2puXNWuKLBxrvPfMVUUv6i10hAXcoqtrbyoHMXHKtkp7lL5BnBOW56VZJC5T/17nPO8Tghyc02TsI70hFzA+T7BSLrfLJS88ABzwXfpR/lQaJwl+YBwWwLcub1LrJZmy6/Hwc2JbaMSMFLjGFaB6cUWP0Kox/IhdufR6GYbdaS65t1LdHg2iGulo7fHYODe51/MQTg+nm0pgtseYMd9yERc3Ke9QIM4Kdq+kQq82EOE/FYs0eb462fiFEm76nQNUima8CHYilJnj+KePFd2kPIy1cMgUnrKanRaIcnFFDw51QN7IB8pHpkoJH7KYGAvdmo1t/xhohFRqlQmsiZcbHiCp1V1whmJh5F/+D2VxUsmck3suK9H2dMJK78vj0OwCRmtPk97f0kWn3odQPBA+F1y10xmPLcJWDCGRYutjI0JqaoIQBE+ICjwWW6epUneK9rVBQL5kXDC7bjvUgCRNHeCrVB6+NBNcff3hckBhSKjtYhdLYf3/w8hgIrJmEmTliiDISEg1nSwY5T83ZDDG28KgouMrXxUfWVaRxeY3kEq1veZkNQYitEUIU5ZI2x6SOANLIwn6bb
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB3485.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(23010399003)(366016)(1800799024)(18002099003)(22082099003)(4143699003)(11063799006)(56012099006)(261026140227099003)(261021135927099003)(261028144727099003)(261026121527099003)(261009223027099003)(261022105027099003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?YkhDNGx3K09lZVpTbHZTSkdPOTVLQjdqTzNITjc1ODZvcDlvMXJTNCs2ZHhi?=
 =?utf-8?B?dExxRUozRzliekJVRmh6NDBGQW9TR3ZVNjhZT25CL05qOXV4SWFRVUl0eXFa?=
 =?utf-8?B?M25YQzBzYnM3WmJrVXJQd0pBY1RTY3ptM1gyODR1b09xWFRxSlJDWlFKRWM2?=
 =?utf-8?B?bk1pcEJVeUpIQXkyRjBVTTFzeU5WMWI1VmxWN2JjaXJVVGJWVUZ0aGlldEM4?=
 =?utf-8?B?R0JuazFQME5UekNvR28yd1dnRTJqdzZyeUpqV3Z4K280YVVYSDUzTndxSk1M?=
 =?utf-8?B?NlZZc3h2RXZyQllrQ2FCK1c5R2pjUStkL2E0M252dVZlMFlGOXhZK3l5aXBJ?=
 =?utf-8?B?Zk1id0FGNTBITU5TUm9ZcjE5Z3kyZ21pcHc2SlNNdEY2blExSTUxbDA3UUpt?=
 =?utf-8?B?dnZUckVWTEtXUE1WeWRQRFgycVZVeWFYL2JsVXR3V3Vnak91azg4SllJaWw1?=
 =?utf-8?B?U2tHL2Y0RTV4S2kvMmgwaWZiNjRBbVM3WXgwVERmUVFNVjRTcHlMWksrVUVT?=
 =?utf-8?B?N213bzFSOHo2Y3NNRnhlNkpnRHFxTkJhVy9DY25WQWJsNWN0NVNhVHhxRGlj?=
 =?utf-8?B?OFNockQ1VTU0eC9jV21wSUIyaFZzY1JiNitnMFNuaFBlK0QrV3M0cGxneW9n?=
 =?utf-8?B?RWJZcEpUenR6Nm5KeHdLQ1BGcS9UWVl1ZUt4L0tpL2oxWDNuWXRoanl1aXhQ?=
 =?utf-8?B?ZTVkL3kzOS9FUkQzQmRpeTg4b2VtazcrcjJpRE55TnppNS96SmpGZiszeTNM?=
 =?utf-8?B?S1NZOTA3NlRZNm04cElvSDhjOGc1SS9nR0haZEYvNUdWS3RpUzFiMk1GOUhB?=
 =?utf-8?B?dmZzc2p5TWtlVXFrTDBhZ1pGREZUZ3J6dm9EWVF4dVRHNzJSSVpHRVBxU0p0?=
 =?utf-8?B?d1Rmd3BKcDlTUDNTblBpcDVlVk5xSFBPaEZxUXlWUEFQRzVUNzFhZzRmeVhO?=
 =?utf-8?B?NXEzYS9JaUNyWHJqam9oTHhjenluSWNkQjZHK2FtMFNvU1plMW5ydFR6S0lU?=
 =?utf-8?B?VmI4UGw5eG5Hamo0R3NuaTUrMjkvWUYzWjkwRXk3Q2JYY1B0djQ3V0VpN2ZC?=
 =?utf-8?B?MWNwT2lkNDNZeGQ1cGpEelNmTVMyczk3YXFiUEtGOFRjYkJ2UDVuYUZNNW1S?=
 =?utf-8?B?anI5SkJPcGVpc1BGcEpNMzFwUUJ6bEk1T0svWFl5MklrSENIWU1jQ2plNmtx?=
 =?utf-8?B?RTdUOFV6MDB6OUI4MVRLREh3c1dRYXM4R3Q0N3c5eHRtb0lKRXlzcEtpWElv?=
 =?utf-8?B?MXFMZk1vU2RRaE5aVWdIQ2hZcS9RZjdOdWc2ajd4V1ExZmdhRkRST2pPS1Yw?=
 =?utf-8?B?ay9YbWNndmtYOUZLUURoYThlMVluYzJOWmhzSjhFbGZxT0NSdDVRZGpoZ2FS?=
 =?utf-8?B?RXFLTjRLVDBsQU1VM0pNbzZBT0JBdU5SOGxwTytQNmJXZ2xNRFlaMitncWU4?=
 =?utf-8?B?d2cxSzkrTk1sTVM4UVFnSXE3Y2RNWFlxanErSmVxcWlCUWc0S1REalk2aWhu?=
 =?utf-8?B?dFcvMDV5U0NCZGY0UmtkQnFhdmxnRTBCaFNSazhNb3hKZXplNjlhanVvOVhC?=
 =?utf-8?B?M3c2SDNoa1FBOEFmRjlMUHJVNTVKUmxBamJaMmtoa2xMZDlTcDloTTJjdW1Q?=
 =?utf-8?B?TXFTS0R0VGZiUklUZmx5VzNGR0tDUTNnUlJCZzZBQUR4VFhzaFVEYUozVFpl?=
 =?utf-8?B?U0JxRHpmc281bWpjekNESFlub1NCV0V5VjRDbkw4NU5BdXhqa1ZEY2s3T2dK?=
 =?utf-8?B?OC9xSmlQSVZtdGdVTTBMdEFIVFBmTUROSWtCdmxsRjFzMGVDWE5LYzMwTjdk?=
 =?utf-8?B?R28wQUVLa05IZlgwQ0Zwa21UL3d6dG1UUkFzZHpqYWZHZ0RXdWFCcG50SjhP?=
 =?utf-8?B?c0s2MjFlUEVUK1Aybmx3QjRlYk41QXNOVnE0cWFwakgvYlFqaHJVY3NDT1RC?=
 =?utf-8?B?QTJDZFZNczRuVVByckVBZlFzOTMwNGRhaXlwUEt2eVIrSWpxcEg2TDBxL2xY?=
 =?utf-8?B?dVVtYlVhSEs2UmlBc3JrUUR5ajJmTi84bGYwbVZkM0tGR2FzUGpqK29vaGtU?=
 =?utf-8?B?MlM5eFE1aEEwa3lrVEFrNHlJdE53bDhab2gvSjNVcWJmZWxiMXE1SmJOTFdR?=
 =?utf-8?B?UU1saVNoWkF5a2Z0S3FUL2QvQW1iNUNwR0g2RlB2dlpEYlJjTGk3QVcvWjk4?=
 =?utf-8?B?ZHF5RktzYk81YlVnRHMwcytkaTBVSEltN1FVYWJ1T3BlMDBPcXZvSmNTRkFB?=
 =?utf-8?B?N25HLzNxa0J3SDg0QUlYNHk1ZTU5aHFBaWNzRDJrUUhHMVJEWE1kVHNRVlJy?=
 =?utf-8?B?ZUFZcWIwZ0hlODAwayswMWJmTitBSDFITGllSlJROUVhSUJyVUJGQT09?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4b2549c9-eabe-45e9-426f-08df49b46e09
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB3485.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Nov 2026 22:52:20.3201
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yDYaHbdwwFbtEf284+k0+JM2DWjAy/TacGAwETMFDUZzGONCY3ZEzW9wWQi2WOarL6UzOTk3bEPO9y2U3xZUmg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: EA3PR12MB178636

On 11/22/2026 4:59 PM, netdev-bot+sashiko@kernel.org wrote> [Severity: Low]
> Should this have a Fixes: tag? 
[...]
> A backport would also need the earlier "ionic: make the command timeout
> per device" commit, because that commit adds ionic_cmd_timeout().

The stable part, raising the watchdog from 2 to 5 seconds, is sent
separately to rdma for-rc with that Fixes: tag and no dependency on
1/3:
https://lore.kernel.org/linux-rdma/20261118-b4-ionic-rdma-admin-timeout-v1-1-39536999a3e4@amd.com/
This patch only makes the watchdog follow the configurable timeout.

> [Severity: High]
[...]
> Would it work for the busy-wait to cancel the wr and return -ETIMEDOUT
> without a LIF reset when it gives up before cmd_timeout, and leave the
> reset to the watchdog? The 2 second spin bound in atomic context could
> stay as it is.

Not as is. On a busy-wait timeout the driver cancels the wr, which only
stops tracking it, and the create AH error path then returns the AH id
and frees the header buffer while the command can still complete in the
device. Killing the admin queues and resetting the LIF stops the driver
from using the device in that state. Doing without it needs the driver
to defer releasing the id and the buffer until the admin queue has
moved past the command, which is a separate change from this series.
The busy-wait keeps its 2 second bound because its callers hold a
spinlock.

Thanks,
Nikhil
