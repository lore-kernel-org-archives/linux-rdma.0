Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.189.97
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794260551;
	b=IzPniyOZVPSbtB0RHPzddoS/JrspHB4CFU1edoJ3IaW5iKFNWcfw40Q8gvxy8gTs7GvY
	 dA/sdwvr8mLCjR3mOHbxdtBViV4tjvz1yh/ODSHqY7T731vIBXP337USTyFotUJnMeicx
	 y9oX85ZnDW2O2ifD0XtUzV0keLKkjDvY25J9b9A4fLMhc7OMruML63eCKIoC8OHblTN1N
	 +m77MKDXivS9NsI/ZK1HxpboTIpl3F5G8G15WTBWOnkuhYaGXYh9BGOiaD0mjYIrfyViX
	 TWE7OXFOvAAOcW1vTLG7qkbvNacookQW9Ae2RD4CAAq4+Z/5VYBsgaobWAitTq7g7UQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794260551;
	h=DMARC-Filter:DKIM-Signature:Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:Content-Type:Content-Transfer-Encoding:
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
	bh=wgLCOAAYOpEXwVVYoA9gP+1isn08Z3NqEMx+bU3Z7Lo=;
	b=LroYmqao/vVAPIaBmfW9emdYkV2krzA6gWLSih5cFN8eAWLvtQYOf4m+6VJFd/LTsZpR
	 wPsE3KeGvo6rD8E6lZntqauT4TonOPgcEWn2ueGwmii6O6NtVgRZAmK3zC0OJCNbXGgZY
	 eHrEAsAqc7R8IR23zg9TNHUyUF0bNxQyEmv0hPdnA5dKYxNFOj8S2SJ3qGtiotd7ZbDG9
	 F5qPyABaktxmnSWJQqS7h6dcxEotLvvnpJYloFlUjSMsr1EbkKnb9W0ozKesJyu8Pk/r8
	 IKIKX0YXGnsqfvtWOkc1Y1zOEnm0giGC9sfQT4iXn4+zilH4xVnC+2zrLNqwRW4oxzQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=none header.from=raithlin.com;
	spf=pass smtp.mailfrom=raithlin.com;
	dkim=pass header.d=raithlin.onmicrosoft.com header.i=@raithlin.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-raithlin-onmicrosoft-com header.b=tdRye6Ds;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.189.97
Received: from YT3PR01CU008.outbound.protection.outlook.com (mail-canadacentralazon11020097.outbound.protection.outlook.com [52.101.189.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07EB4606A31C
	for <linux-rdma@vger.kernel.org>; Mon,  9 Nov 2026 21:42:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 07EB4606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=raithlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=raithlin.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=raithlin.onmicrosoft.com header.i=@raithlin.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-raithlin-onmicrosoft-com header.b=tdRye6Ds
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gnGMxl/Qzfjc5l8DB46fc4+nvz8nukU7JZHydhiagqfkWMly6HQR8taBtqa4huLdWQ+n2zEgdScS+geEkiubV8EZfU5eZyJYdB1YXPCvbFpyQTiSTLVDK/+4ik1E3KSed3qHGYnuvgGcl62IE4/9z0WeBZmHY+3Pi3vMT0RbL9BZHpsLnW7sIXFlYuVAJEf5FyMLe30gcEaoDPzL2s3L94Kk0nqivRqEpTtw+GIWBUk+W+1mMzOaBzDj7K3X1/9eVw1IOpyQTVfiw417XnK9uP8YybCJvHK3L2bKjNFicZOwp1K1BNulHhzADEuOV9gP4kRtE4+NUU9WWYDgUWgrNA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wgLCOAAYOpEXwVVYoA9gP+1isn08Z3NqEMx+bU3Z7Lo=;
 b=gAak5bThA6pA1nGnDGc8c4ih9TQiysMgBuCg00zsFPZHswzK/FOHKSFWTk7/2SP08UKqlqNW9tnXQac+BftvE4cOw1dwlAKs9URJkHZnbP4WfIZpwZfy6LfjMTVEeSylr8gPmG34irotB4EDof1xRk3fm4T69S2xcVD23rs/9j6tdgYRyMz0+OiFN/R+7oedjc0Hx8I2DbQsI5Z0CVdwr53ucJR1rLhZlZVhrkzp3WIJ3Ua+ucp4ZN8MzKzlaKcsmK6GT0Xol6TwvozqQf3VMYhx0Xh4U0ZT7VYZ8D2dcmggIICSnvYA2sv+xJGxsUicX0a4TAlrjTjkZY/431TZLQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=raithlin.com; dmarc=pass action=none header.from=raithlin.com;
 dkim=pass header.d=raithlin.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=raithlin.onmicrosoft.com; s=selector2-raithlin-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wgLCOAAYOpEXwVVYoA9gP+1isn08Z3NqEMx+bU3Z7Lo=;
 b=tdRye6Ds6ZUULmO8VJNpZT4CIKPLEnVmFnwTZKmeoNCjOFSHPLqmMggnGMpZGdElcRHgTBTLVPcCULZxwwFzwIYOpOp1mj0cW55a2/Q7mv71oy3aDdzndOj+pV+3+a9Czx/0ep/vGZJs1GdADo51XlRZ6owuDtDfut5AoQvSWX4=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=raithlin.com;
Received: from YQXPR01MB6671.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:c01:4c::19)
 by YT3PR01MB298025.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b00:10e::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.13; Mon, 9 Nov
 2026 21:42:26 +0000
Received: from YQXPR01MB6671.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::cb84:4e7b:86e6:f58]) by YQXPR01MB6671.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::cb84:4e7b:86e6:f58%4]) with mapi id 15.21.0569.010; Mon, 9 Nov 2026
 21:42:26 +0000
From: Stephen Bates <sbates@raithlin.com>
To: linux-rdma@vger.kernel.org
Cc: Stephen Bates <sbates@raithlin.com>,
	sshaul@nvidia.com,
	stephen.bates@amd.com,
	abhijit.gangurde@amd.com,
	nikhil.agarwal@amd.com
Subject: [PATCH v1 1/2] perftest: add data validation for ROCm device memory
Date: Mon,  9 Nov 2026 15:42:13 -0600
Message-ID: <20261109214215.3152974-1-sbates@raithlin.com>
X-Mailer: git-send-email 2.53.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MW4PR04CA0319.namprd04.prod.outlook.com
 (2603:10b6:303:82::24) To YQXPR01MB6671.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:4c::19)
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
X-MS-TrafficTypeDiagnostic: YQXPR01MB6671:EE_|YT3PR01MB298025:EE_
X-MS-Office365-Filtering-Correlation-Id: 0e5c85ce-e581-4907-fb27-08df3eaa5847
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|23010399003|366016|1800799024|261102130727099003|5023799004|261021121427099003|261021130227099003|261022105027099003|261026140227099003|56012099006|261021135927099003|261021123027099003|261021133027099003|261022115727099003|261022113327099003|261026121527099003|261028144727099003|261009223027099003|261026130827099003|261022075727099003|261026135527099003|261102123227099003|10067099003|20052099010|18002099003|6133799003|3023799007;
X-Microsoft-Antispam-Message-Info:
	i/GzYjtGiEe98DFVv4Te1wRcG3zJoSqWWM+WEJOrHF2bX357aCohYDA8/RH4qj6wKuPxOtwil1vA+AX0cKlVeqWUEdnNhLWvgqwFv34BSdAQIQBFhDZZlG5W8t/8d+djNUQH13ECPwACswCzduRFOZ3OnVG8DgcZXaJ/eY9lEi9IfABlNFyQPIMZxvVST4PySpQW8PkggyaU9VjIsJiiSpJruvO8C36bkdhTsQxbcVJH4Fy9CHZSo1kP45iTpLqotzhruDcJqoAY18Pnd5IGYvQOgLgyQpFreKFvo98bF6U3pNtG4bYcLp2BdnY7jEJs2JvlvgKzB0y6Z03NaAnMHbqOp7Jh3SSnhLds8FF4JGdiCpQrIXUeSz+Nt3k4ZGOqPGVmlyJlxzIEgrWwt8xH7ituhKxlvWsm/0a87jIRVp1imbv3KepU5eLoFkoESjhCmkrGH8/6QynAoGNig+1LiiXSUe7AX0GS7R3KXm6HOa1e3deDenFHelKJc0X0QBRU0o2s3ZPvIXufGay6RRZODF3R0En8Xa2WR+RxJ5lZAD6E77O+fyMMk25M6bm2mxHglYV2R0VbFMNBOpWyT1kxIKoEvVgqhcbH+OT2e9T/L9C3jolu4p2eb6QDujqqLCjjsGb1HYDLey1Old+gCUZrKIXKqtp7p5MBY4rMsXmIVsg=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YQXPR01MB6671.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(376014)(23010399003)(366016)(1800799024)(261102130727099003)(5023799004)(261021121427099003)(261021130227099003)(261022105027099003)(261026140227099003)(56012099006)(261021135927099003)(261021123027099003)(261021133027099003)(261022115727099003)(261022113327099003)(261026121527099003)(261028144727099003)(261009223027099003)(261026130827099003)(261022075727099003)(261026135527099003)(261102123227099003)(10067099003)(20052099010)(18002099003)(6133799003)(3023799007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?cS9OcTdBSUNod05NczFzTTd4OFRyL25QcXArZWhvSjZUQ1FVVGJaWHJJb2dE?=
 =?utf-8?B?SHVoeDlIdml1S1U1aEFzeko1Z3owS1JpL2NFL3FjVzdUYTdnSEFuZkVleHJm?=
 =?utf-8?B?dEtENVh5MW03azgyRjhRNjYzL1pRcndNK2I4aVdlUmNmeHJOMGZkSHZ6elNh?=
 =?utf-8?B?TXZyd2NaaUtsVDE5T291anNEc1JZeXZCeGZIa3lDaGR3ZmFyUTdQTkFOSkNu?=
 =?utf-8?B?TDE3b0h1THl4ZEEycndKUm5GOEU1VG9EKzgzMXNNWnBUcldIaVBHckhmdG9Z?=
 =?utf-8?B?RW9tNkEyNXFnRldpTzVhZUUwM2w2V1ZOZHM3NzVLdDE0WEluTnpTUGp4ZjhN?=
 =?utf-8?B?a3NqdXJQemVOa0hMM2Z0OU13dXlkdzRCUzc0Z1FybHYrV3l3Y2ZScW80NmI3?=
 =?utf-8?B?MmxrdnBWNTVCNVBsZ2lOSVMyNTJIZzdCVWx3N2FYS0NPMXpHVE1zUjBCV2ZE?=
 =?utf-8?B?b0RyQXJQMnJ0bnY1N0tDWkt4UExST1dYZjZyVU5HWlNZT1FLaFEwQXdvbUhs?=
 =?utf-8?B?K3d4dTN6MWhMbTBtVm1NdnBsMGw3M016cGpUTHlmS1FBZUxWOHdIRmUzV2dJ?=
 =?utf-8?B?QllEaVB2YWQ5NGpaY0tQd3JCWUV4SEJRQmdkY3ZYOWRxQjhuLzJnUStvYkVl?=
 =?utf-8?B?MEJZcEUwS29wYy9yZ3hQU1A4cy9XUForM1ZFSkhVNGpIVmRiTU0yYlNNckQw?=
 =?utf-8?B?TFk0em15dDJqV1B4Rm9wVzRNY01wdVd6dE81Y2hMWXBZQXY5Wm5qbkFkTkRH?=
 =?utf-8?B?eFRUazJpSDB5bEhwZEp4azlYUGVaOE8zZUF4K3hzNEtYSVVSUVdNd0F4Szdy?=
 =?utf-8?B?S1FkVFVnTFdoZkNmekZzOG01bUxyMXRxMXNIS1lZRXA1Q3BRTERobytKWSt1?=
 =?utf-8?B?azhMNmMyR3NsK2tjTmlkRjZGTzRkdDJNTjFxcUZvQnVoSmQyZkJTRVdXVnpU?=
 =?utf-8?B?TFZJRkUvbkdwUjl6OFN0NXBKcHhiblFVSDl4MW9LN0MzVjJadFluNnoreHM3?=
 =?utf-8?B?ZmFLNkhaaGZCTU00Um9sSVVaYnBSS0tDSzNka21wbk9oaTVoaDN4U1k0M3U2?=
 =?utf-8?B?REdiY2R5WXozTFJDKzJTQ0VuN0l0SGdCMG1BamxJTC9RamlURlNTUHZyRG1t?=
 =?utf-8?B?eFVrWTFNb0xwL3BwNFBjQW9qb2YrdHhkVERNU3dxRlpZMkFPbklLTTBTcXdr?=
 =?utf-8?B?TnNQdjFQYmQ5QXZQckltc0ZNUEVybnp1ai92Z2FVWjFRYUQzOUxhdEdlNEd0?=
 =?utf-8?B?N0NNWTBFampWallBQ2xyZUxDVDduRE9TTXRiWURvb1doUXdFYjNwVDJ4NFFh?=
 =?utf-8?B?ZUI4R2RnTkppUlhxTzBEaHpyQ0hFNkZlU1JyT1pOUThBV3NZbGJOcjVMUXNm?=
 =?utf-8?B?aEZNTkFValYvQnJ0RlBGQStNZnYzbG12dXhqUVBLTDNLM3BCN0ROV29LdE95?=
 =?utf-8?B?WkpxTFdDb1hjeWxBL09LaVd0UDZuZEYwaGNFMllkZFlqVEROT0JnTlB0Yi9H?=
 =?utf-8?B?SFhPNDc0SGRXQnNKb2NTeUw2M0RSbkJVOG9ISW9tbGhaZEhWNGk4TTdEZkVD?=
 =?utf-8?B?d2F5dG1SMTczbkd3cUxMMmdPNUpzclVseHBFSGNaOFFoRkdIRGZ1eWxELzZv?=
 =?utf-8?B?anBWTEIyTWtPOVdrL3ZmbzlOOFFuWUltVytMajZRd1daTE1SSVJJN3lkRi8x?=
 =?utf-8?B?bUN4VWtCZ3RneHN2OEhURXF2a2lYUTJheFd4UHBSemtKR09NK1VlNDgzc3Zm?=
 =?utf-8?B?YmtTWGlqUktSRXlIWFNFSDljdXF0YVhXRWZOU2RFS2VLVEdkc1ZCTlRkR0Rq?=
 =?utf-8?B?OERLc0YwSHZMVzZZbjkrOVhHYmNMSFBHaEZITGZSUjNhTU43MGlMUUZIUU85?=
 =?utf-8?B?MmRBRG9PSWl3eWZjdlFhbmc3V2crT0hMdU9KQzNUZENha2Fuc3BJRVdCMEdD?=
 =?utf-8?B?bWMzSDlhOFdEKzJaOW9Ib2lkRnRscmhIeFhRdlFnNXVxQ29LNkxzdUh4NXlG?=
 =?utf-8?B?bzdMM1lwZXpZZVp2OEtGOEpaK2VkdVVYQVl3UDJQbjVaRzhmSGp2eFVnNEg3?=
 =?utf-8?B?a3Jma2Ywb1pBU0xoSndwTU1aMzJQZjd2N21ieDZuRDgzcDltNTNJeXZDVUNz?=
 =?utf-8?B?aStOeHdrb1UxZWFEUCtocmJ4SmhBbDFINU0va0RRTXFHMXBSbGZqR2xOZFZs?=
 =?utf-8?B?RDMyeW9YaTVXZFJVeFA4bC84TC8vYzRhelZHSUhocXBuWVdyS2hOb09tSkNV?=
 =?utf-8?B?M3J4enVEUmthU0M3d2l3L2wzRFBRTThRTWQxNXpvT09ldmlCRDNjSGpsSitM?=
 =?utf-8?B?VEVoQnl0eGJyd1M3b3NVbUl1K2dXa0dnUVlmSWVIa1dTbXBVczYyUT09?=
X-OriginatorOrg: raithlin.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0e5c85ce-e581-4907-fb27-08df3eaa5847
X-MS-Exchange-CrossTenant-AuthSource: YQXPR01MB6671.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Nov 2026 21:42:25.8911
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 18519031-7ff4-4cbb-bbcb-c3252d330f4b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qa1LFzGMTwrXC0D+3yMgQHoNuOyPx3KX+m3X/NpSgDG6g95V6nFvWGMzHvwH3RJVZIlcuviPMVNWQetG88qXFQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YT3PR01MB298025

Perftest validates host and CUDA memory but not ROCm memory. Add a ROCm
validation backend, wired through the existing memory_ctx hooks.

src/rocm_kernels.hip is a port of src/cuda_kernels.cu and is the default: a
resident kernel in which block 0 monitors the tail markers and blocks 1..N
drain a lock-free queue, so each cycle is checked as it lands rather than
inspecting the final state afterwards. Where it cannot run -- a build without
hipcc, a device the kernel will not launch on, or
PERFTEST_ROCM_VALIDATION=staged -- the fallback compares on the host after the
run. The fallback is strictly weaker: it sees only each chunk's final state,
so transient corruption a later cycle overwrote is missed and bytes_validated
is correspondingly lower. Which path ran is printed at stop, and a live
validator that observed no completed cycle falls back rather than reporting an
empty result. Both paths reuse upstream's classify_validation_mismatch(), so a
run stopping mid-cycle is scored as an overwrite race rather than corruption.

The ROCm copy ops were plain memcpy into and out of device memory. They are
now hipMemcpy with the right direction.

The port stays deliberately close to the original: same monitor/validator
split, same lock-free queue, same structures from cuda_validation.h, same
exported entry points with nothing missing. The rocm_kernel_ prefix is not
cosmetic -- the CUDA plugin is dlopen'd from libperftest_kernels.so, while
these link into libperftest.a and share a namespace with the memory_ctx hooks.
Divergences are marked PORT: at the site.

Warp width is the one that matters. The CUDA reduction assumes a 32-lane warp
(tid & 31, shuffle offset starting at 16). An AMD wavefront is 64 lanes on
CDNA and 32 on RDNA, so the literal reduces only within half a wave and lets
two lanes observe lane == 0, double-counting the atomics that follow. The port
uses warpSize, which is a built-in rather than a constant, so the unrolls go
with it. HIP's warp intrinsics take no mask operand, so the *_sync forms map
onto the HIP ones.

The synchronisation is expressed with scoped atomics rather than the CUDA
original's volatile idiom. volatile is not a synchronisation primitive: it
constrains the compiler for one access and says nothing about which agents the
access must be coherent with. It works on NVIDIA because the emitted loads
happen to bypass cache. On AMD the memory scope is what selects which cache
levels are bypassed, so __hip_atomic_load/store carry it explicitly -- system
scope for the tail markers and receive slots the NIC DMAs into, and for the
flags shared with the host; agent scope for the work queue only this kernel's
blocks touch. The queue handoff is a release/acquire pair on the slot's valid
flag. A uniform __threadfence_system() over-synchronised the queue while
under-specifying the markers.

Two __ldg uses go with them, both on data the NIC is actively writing. __ldg
is a read-only-cache hint, asserting the data will not change for the life of
the kernel, which is false for a DMA target. The tail retry re-read through
__ldg was the load least likely to observe the write it was waiting for; and
the forward-byte snapshot feeds classify_validation_mismatch(), where a stale
read biases towards reporting corruption that did not occur. The bulk compare
loop keeps __ldg, ordered by the acquire on the marker.

Poll loops back off with s_sleep rather than spinning. A device that runs a
wave until it blocks never retires a tight poll loop, so the kernel cannot
observe should_stop and the host waits in hipDeviceSynchronize() forever. That
includes the slot-valid wait in the work queue, which a consumer reaches
holding its block at a __syncthreads(), so stalling there strands every thread
in the block rather than just itself. validation_start() also honours
num_blocks and threads_per_block, which the CUDA original accepts and ignores:
33 blocks x 1024 spinning threads is not a geometry every device retires.

rocm_kernels_available() is the one addition with no CUDA counterpart. The
CUDA plugin answers that question by whether libperftest_kernels.so dlopen'd
at all; these kernels link in unconditionally and need a runtime probe.

Error codes are not discarded. hipcc marks the HIP entry points nodiscard
where nvcc does not, which exposed three cases the CUDA style hides: the
teardown frees genuinely do not care and say so with a cast; a hipMemset that
quietly failed would leave a previous run's markers, stats or error record in
place for the validator to report as this run's, and now returns
VALIDATION_ERR_MEMSET, which cuda_validation.h had defined and nothing
returned; and a discarded hipMemcpy in check_status would have reported "not
failed", asserting the data is good on the strength of a read that did not
happen.

Three supporting changes.

VALIDATION_INLINE only annotated the shared helpers __host__ __device__ for
__CUDACC__, so they were not callable from hipcc device code. hipcc compiles
..hip as nvcc compiles .cu; both need the annotation.

configure learns --with-rocm-arch, defaulting to rocm_agent_enumerator. hipcc
otherwise targets whatever GPU the build host reports, which is wrong whenever
perftest is cross-built or built in a VM, and the symptom is "device kernel
image is invalid" at launch rather than anything at build time.

The ROCm dmabuf path no longer greps the kernel config before running. That
check required CONFIG_DMABUF_MOVE_NOTIFY, which no longer exists upstream --
dma-buf always builds with it, and .move_notify became .invalidate_mappings --
so it began refusing to run precisely because support had become universal.
What it gated was whether amdgpu_dma_buf_pin() kept AMDGPU_GEM_DOMAIN_VRAM or
fell back to GTT: driver policy, versioned with the driver rather than the
running kernel, which on a DKMS install moves independently of it.
CONFIG_PCI_P2PDMA fared no better, being blind to whether the NIC's driver
implements .reg_user_mr_dmabuf. Both questions are already answered accurately
by hsa_amd_portable_export_dmabuf() and ibv_reg_dmabuf_mr(); their diagnostics
are improved instead of being predicted.

data_validation_stop_and_report() is reordered: errors, then
nothing-validated, then pass. This affects every backend, not just ROCm.
Testing "nothing validated" first reports a run whose chunks all mismatched --
errors > 0 with bytes_validated == 0 -- as a warning about missing data,
hiding a real failure. And backends set passed = (errors == 0 && chunks > 0),
so a run that observed no completed cycle has passed == 0 and would otherwise
be reported as a failure with every error field still zero: "FAILED - 0
error(s) ... (expected 0x00, got 0x00)". bytes_validated == 0 is that same
condition counted differently, since a chunk mismatching at its first byte
contributes no compared bytes but still increments the chunk count.

Two debugging hooks. PERFTEST_ROCM_VALIDATION_FAULT=n corrupts n bytes of the
staged copy before the compare, because a validator that only ever passes is
indistinguishable from one that does not look. PERFTEST_ROCM_HOST_ALLOC=1
allocates host-mapped rather than VRAM, for devices whose MR registers cleanly
and then fails to gather; it measures host memory, so it diagnoses
reachability rather than benchmarking peer-to-peer.

Tested on an emulated gfx1250 behind an emulated RDMA NIC: the live kernel
retires and the host-staged fallback passes with real byte counts, and
injected faults are caught on both. Builds warning-free with --enable-rocm and
hipcc, with --enable-rocm without it, and with neither.

Link: https://github.com/linux-rdma/perftest/pull/419
Signed-off-by: Stephen Bates <sbates@raithlin.com>
---
 Makefile.am               |   32 +-
 configure.ac              |   25 +
 src/perftest_parameters.c |    5 +-
 src/perftest_resources.c  |   63 ++-
 src/rocm_kernels.h        |   64 +++
 src/rocm_kernels.hip      | 1029 +++++++++++++++++++++++++++++++++++++
 src/rocm_memory.c         |  182 +++----
 src/rocm_validation.c     |  467 +++++++++++++++++
 src/rocm_validation.h     |   57 ++
 src/validation_common.h   |   12 +-
 10 files changed, 1839 insertions(+), 97 deletions(-)
 create mode 100644 src/rocm_kernels.h
 create mode 100644 src/rocm_kernels.hip
 create mode 100644 src/rocm_validation.c
 create mode 100644 src/rocm_validation.h

diff --git a/Makefile.am b/Makefile.am
index b12c302..ada55ed 100755
--- a/Makefile.am
+++ b/Makefile.am
@@ -35,7 +35,7 @@ AUTOMAKE_OPTIONS= subdir-objects
 
 noinst_LIBRARIES = libperftest.a
 libperftest_a_SOURCES = src/get_clock.c src/perftest_communication.c src/perftest_negotiation.c src/perftest_parameters.c src/perftest_resources.c src/perftest_counters.c src/host_memory.c src/host_validation.c src/mmap_memory.c src/numa_loader.c
-noinst_HEADERS = src/get_clock.h src/perftest_communication.h src/perftest_negotiation.h src/perftest_parameters.h src/perftest_resources.h src/perftest_counters.h src/memory.h src/host_memory.h src/host_validation.h src/mmap_memory.h src/cuda_memory.h src/rocm_memory.h src/neuron_memory.h src/hl_memory.h src/mlu_memory.h src/cuda_validation.h src/validation_common.h src/dm_memory.h src/system_dmabuf_memory.h src/musa_memory.h src/numa_loader.h
+noinst_HEADERS = src/get_clock.h src/perftest_communication.h src/perftest_negotiation.h src/perftest_parameters.h src/perftest_resources.h src/perftest_counters.h src/memory.h src/host_memory.h src/host_validation.h src/mmap_memory.h src/cuda_memory.h src/rocm_memory.h src/rocm_validation.h src/neuron_memory.h src/hl_memory.h src/mlu_memory.h src/cuda_validation.h src/validation_common.h src/dm_memory.h src/system_dmabuf_memory.h src/musa_memory.h src/numa_loader.h
 
 AM_CFLAGS =
 
@@ -52,6 +52,36 @@ endif
 
 if ROCM
 libperftest_a_SOURCES += src/rocm_memory.c
+libperftest_a_SOURCES += src/rocm_validation.c
+noinst_HEADERS += src/rocm_kernels.h
+endif
+
+if ROCM_KERNELS
+
+if ROCM_ARCH_SET
+ROCM_OFFLOAD_FLAG = --offload-arch=@ROCM_OFFLOAD_ARCH@
+else
+ROCM_OFFLOAD_FLAG =
+endif
+
+ROCM_HIPCC_FLAGS = -DHAVE_CONFIG_H $(DEFS) $(DEFAULT_INCLUDES) $(INCLUDES) \
+	-fPIC -std=c++17 $(ROCM_OFFLOAD_FLAG)
+
+src/rocm_kernels.hip: ;
+
+src/rocm_kernels.hip.o: src/rocm_kernels.hip src/rocm_kernels.h \
+		src/cuda_validation.h
+	$(HIPCC) $(ROCM_HIPCC_FLAGS) -o $@ -c $<
+
+ROCM_KERNEL_OBJ = src/rocm_kernels.hip.o
+libperftest_a_LIBADD = $(ROCM_KERNEL_OBJ)
+
+clean-local-rocm-kernels:
+	-rm -f src/rocm_kernels.hip.o
+
+else
+ROCM_KERNEL_OBJ =
+clean-local-rocm-kernels:
 endif
 
 if NEURON
diff --git a/configure.ac b/configure.ac
index e44ffe5..4549167 100755
--- a/configure.ac
+++ b/configure.ac
@@ -334,9 +334,34 @@ AS_IF([test "x$enable_rocm" = xyes], [
        AC_SEARCH_LIBS([hipFree], [amdhip64], [],
                       [AC_MSG_ERROR([cannot link with -lamdhip64])])
        AC_DEFINE([HAVE_ROCM], [1], [Enable ROCm])
+       dnl HIP validation kernels are optional: without hipcc the ROCm
+       dnl validator falls back to staging the buffer through host memory,
+       dnl which is slower but needs no device compiler.
+       AC_CHECK_TOOL([HIPCC], [hipcc], [no])
+       dnl Which GPU the kernels are compiled for. hipcc's default target is
+       dnl whatever the *build* host reports, which is wrong whenever perftest
+       dnl is cross-built or built in a VM for an emulated device -- the
+       dnl symptom is "device kernel image is invalid" at launch, long after a
+       dnl clean build. Ask the runtime, and let a caller override.
+       AC_ARG_WITH([rocm-arch],
+                   [AS_HELP_STRING([--with-rocm-arch=ARCH],
+                                   [GPU arch for HIP kernels (default: ask rocm_agent_enumerator)])],
+                   [ROCM_OFFLOAD_ARCH="$withval"],
+                   [ROCM_OFFLOAD_ARCH=`rocm_agent_enumerator 2>/dev/null | grep -v '^gfx000$' | head -1`])
+       AS_IF([test "x$ROCM_OFFLOAD_ARCH" = "x"],
+             [AC_MSG_WARN([no GPU arch detected; HIP kernels will use hipcc's default])],
+             [AC_MSG_NOTICE([HIP kernels target $ROCM_OFFLOAD_ARCH])])
+       AC_SUBST([ROCM_OFFLOAD_ARCH])
+       AS_IF([test "x$HIPCC" != "xno"],
+             [AC_DEFINE([HAVE_ROCM_KERNELS], [1], [HIP validation kernels])
+              rocm_kernels=yes],
+             [AC_MSG_WARN([hipcc not found; ROCm validation will stage through host memory])
+              rocm_kernels=no])
        ])
 
 AM_CONDITIONAL([ROCM], [test x$enable_rocm = xyes])
+AM_CONDITIONAL([ROCM_KERNELS], [test x$rocm_kernels = xyes])
+AM_CONDITIONAL([ROCM_ARCH_SET], [test x$ROCM_OFFLOAD_ARCH != x])
 
 AS_IF([test "x$enable_rocm_dmabuf" = xyes], [
        AS_IF([test "x$HAVE_REG_DMABUF_MR" = "xno"],
diff --git a/src/perftest_parameters.c b/src/perftest_parameters.c
index ae17db0..8f491c8 100755
--- a/src/perftest_parameters.c
+++ b/src/perftest_parameters.c
@@ -1519,11 +1519,12 @@ static void force_dependecies(struct perftest_parameters *user_param)
 	}
 
 	if (user_param->data_validation) {
-		/* Require CUDA or HOST memory */
+		/* Require CUDA, ROCm or HOST memory */
 		if (user_param->memory_type != MEMORY_CUDA &&
+		    user_param->memory_type != MEMORY_ROCM &&
 		    user_param->memory_type != MEMORY_HOST) {
 			printf(RESULT_LINE);
-			fprintf(stderr, " --data_validation requires --use_cuda or host memory\n");
+			fprintf(stderr, " --data_validation requires --use_cuda, --use_rocm or host memory\n");
 			exit(1);
 		}
 
diff --git a/src/perftest_resources.c b/src/perftest_resources.c
index e2fc006..6b7c704 100755
--- a/src/perftest_resources.c
+++ b/src/perftest_resources.c
@@ -2332,7 +2332,13 @@ static int register_memory_region(struct pingpong_context *ctx,
 		fprintf(stderr, "Couldn't allocate MR with error=%d\n", errno);
 
 		if (dmabuf_fd && errno == EOPNOTSUPP) {
-			fprintf(stderr, "OFED stack does not support DMA-BUF\n");
+			/* EOPNOTSUPP here is the kernel RDMA driver declining the
+			 * dma_buf, not a userspace limitation: the device has no
+			 * .reg_user_mr_dmabuf, or it has one that rejected this
+			 * importer/exporter pair. */
+			fprintf(stderr,
+				"This RDMA device's kernel driver does not support "
+				"dma_buf memory regions\n");
 			close(dmabuf_fd);
 		}
 
@@ -7364,6 +7370,7 @@ int data_validation_init(struct pingpong_context *ctx,
 	{
 		struct validation_config vcfg = {
 			.buffer_base = ctx->buf[0],
+			.buffer_size = ctx->buff_size,
 			.markers_offset = markers_offset,
 			.recv_slots_offset = ctx->recv_slots_offset,
 			.payload_size = ctx->payload_size,
@@ -7414,20 +7421,64 @@ int data_validation_stop_and_report(struct pingpong_context *ctx,
 		return FAILURE;
 	}
 
-	if (!result.passed) {
+	/*
+	 * Order matters here, and each branch was reached in testing by a
+	 * different real condition.
+	 *
+	 * Errors first. A run whose chunks all mismatched has errors > 0 and
+	 * bytes_validated == 0, and testing "nothing validated" ahead of it
+	 * hides a genuine failure behind a message about missing data.
+	 *
+	 * Then nothing-validated. Backends set
+	 * passed = (errors == 0 && chunks_validated > 0), so a run that
+	 * observed no completed cycle also has passed == 0, and the !passed
+	 * branch would claim a failure with every error field still at its
+	 * initialised zero:
+	 *
+	 *   VALIDATION: FAILED - 0 error(s), first at QP 0, Chunk 0,
+	 *                        Offset 0 (expected 0x00, got 0x00)
+	 *
+	 * which contradicts itself and hides the real condition.
+	 * bytes_validated == 0 is that same condition counted differently: a
+	 * chunk that mismatches at its very first byte contributes no compared
+	 * bytes but still increments the chunk count.
+	 *
+	 * All three paths return FAILURE. Validating nothing is not a pass.
+	 */
+	if (result.errors_found > 0) {
 		fprintf(stderr, "VALIDATION: FAILED%s%s%s - %lu error(s), "
 			"first at QP %u, Chunk %u, Offset %lu "
 			"(expected 0x%02x, got 0x%02x)\n",
 			role ? " (" : "", role ? role : "", role ? ")" : "",
 			(unsigned long)result.errors_found,
-			result.error_qp_id, result.error_chunk_id, result.error_byte_offset,
+			result.error_qp_id, result.error_chunk_id,
+			result.error_byte_offset,
 			result.error_expected, result.error_actual);
 		return FAILURE;
 	}
 
-	if (result.chunks_validated == 0) {
-		fprintf(stderr, "VALIDATION: WARNING%s%s%s - no data validated\n",
-			role ? " (" : "", role ? role : "", role ? ")" : "");
+	if (result.chunks_validated == 0 || result.bytes_validated == 0) {
+		fprintf(stderr, "VALIDATION: WARNING%s%s%s - no data validated"
+			" (%lu chunks, %lu bytes)\n",
+			role ? " (" : "", role ? role : "", role ? ")" : "",
+			(unsigned long)result.chunks_validated,
+			(unsigned long)result.bytes_validated);
+		return FAILURE;
+	}
+
+	/*
+	 * Unreachable for the backends in tree, which derive passed from the
+	 * two conditions above. Kept so a backend that fails for a reason it
+	 * has not expressed as an error count still reports rather than
+	 * silently passing -- and says so, instead of printing a zeroed error
+	 * record that would read as corruption at offset 0.
+	 */
+	if (!result.passed) {
+		fprintf(stderr, "VALIDATION: FAILED%s%s%s - backend reported "
+			"failure with no error recorded (%lu chunks, %lu bytes)\n",
+			role ? " (" : "", role ? role : "", role ? ")" : "",
+			(unsigned long)result.chunks_validated,
+			(unsigned long)result.bytes_validated);
 		return FAILURE;
 	}
 
diff --git a/src/rocm_kernels.h b/src/rocm_kernels.h
new file mode 100644
index 0000000..e7b9133
--- /dev/null
+++ b/src/rocm_kernels.h
@@ -0,0 +1,64 @@
+/* SPDX-License-Identifier: GPL-2.0 OR BSD-2-Clause */
+/*
+ * Copyright 2026 Advanced Micro Devices, Inc. All rights reserved.
+ *
+ * C interface to the HIP validation kernel in rocm_kernels.hip -- a port of
+ * cuda_kernels.cu.
+ *
+ * The signatures mirror the CUDA plugin's exported entry points one for one;
+ * the names carry a rocm_kernel_ prefix because these are linked into
+ * libperftest.a rather than dlopen'd from libperftest_kernels.so, so they
+ * share a namespace with everything else and must not collide with either
+ * the CUDA plugin or the memory_ctx hooks in rocm_validation.c.
+ */
+
+#ifndef ROCM_KERNELS_H
+#define ROCM_KERNELS_H
+
+#include <stdint.h>
+
+#ifdef __cplusplus
+extern "C" {
+#endif
+
+const char *rocm_kernel_validation_strerror(int err);
+
+int rocm_kernel_validation_init(void *buffer_base,
+				uint64_t markers_offset,
+				uint64_t recv_slots_offset,
+				uint64_t payload_size,
+				uint32_t tx_depth,
+				uint32_t num_qps,
+				uint32_t chunks_per_qp,
+				int validation_mode,
+				int device_id,
+				int debug_enabled);
+
+int rocm_kernel_validation_start(void *params, int num_blocks,
+				 int threads_per_block);
+int rocm_kernel_validation_stop(void);
+int rocm_kernel_validation_get_stats(uint64_t *chunks_validated,
+				     uint64_t *bytes_validated,
+				     uint64_t *errors_found,
+				     uint64_t *markers_scanned,
+				     uint64_t *markers_hit,
+				     uint64_t *skipped_steps,
+				     uint64_t *race_overwrites,
+				     uint64_t *dma_stale_retries,
+				     uint64_t *queue_full_drops,
+				     uint64_t *stale_work_skips);
+int rocm_kernel_validation_get_error(uint32_t *qp_id, uint32_t *chunk_id,
+				     uint64_t *byte_offset, uint8_t *expected,
+				     uint8_t *actual);
+int rocm_kernel_validation_destroy(void);
+int rocm_kernel_validation_is_running(void);
+int rocm_kernel_validation_check_status(void);
+
+/* 1 if a HIP device is usable, 0 otherwise. */
+int rocm_kernels_available(void);
+
+#ifdef __cplusplus
+}
+#endif
+
+#endif /* ROCM_KERNELS_H */
diff --git a/src/rocm_kernels.hip b/src/rocm_kernels.hip
new file mode 100644
index 0000000..5b3d407
--- /dev/null
+++ b/src/rocm_kernels.hip
@@ -0,0 +1,1029 @@
+/* SPDX-License-Identifier: GPL-2.0 OR BSD-2-Clause */
+/*
+ * Copyright 2026 Advanced Micro Devices, Inc. All rights reserved.
+ *
+ * HIP validation kernels for perftest ROCm memory.
+ *
+ * A port of src/cuda_kernels.cu, kept deliberately close to it: same
+ * monitor/validator split, same lock-free work queue, same shared structures
+ * from cuda_validation.h, same exported entry points (prefixed rocm_ because
+ * these are linked into libperftest.a rather than dlopen'd from a plugin
+ * .so, and must not collide when both backends are enabled).
+ *
+ * Divergences from the CUDA original are only where CUDA semantics do not
+ * exist on AMD, and each is marked PORT: below. The important one is warp
+ * width -- the CUDA code assumes 32 lanes, AMD wavefronts are 32 or 64 --
+ * which is a correctness issue, not a tuning one.
+ */
+
+#include <stdio.h>
+#include <stdint.h>
+#include <string.h>
+#include <hip/hip_runtime.h>
+
+#include "cuda_validation.h"
+
+/*
+ * PORT: HIP's warp intrinsics take no mask operand -- an AMD wavefront is
+ * always fully converged at these points -- so the CUDA *_sync forms are
+ * mapped onto the HIP ones and the mask argument is discarded.
+ */
+#define PORT_any_sync(mask, pred)           __any(pred)
+#define PORT_shfl_xor_sync(mask, var, lane) __shfl_xor(var, lane)
+
+/*
+ * PORT: a real backoff in the poll loops.
+ *
+ * The CUDA original spins tightly -- its idle hint is an empty
+ * `for (volatile int i = 0; i < 1; i++) {}`, which costs a few cycles and
+ * never yields. That is fine on hardware that preempts waves. It is not fine
+ * everywhere: a device that runs a wave until it blocks will never retire a
+ * tight poll loop, so the kernel cannot observe should_stop and the host
+ * hangs in hipDeviceSynchronize() forever. s_sleep yields the wave for a
+ * short interval and costs nothing on real silicon.
+ */
+#define PORT_POLL_BACKOFF() __builtin_amdgcn_s_sleep(1)
+
+/*
+ * PORT: scoped atomics in place of the CUDA original's volatile idiom.
+ *
+ * The CUDA code polls through `*(volatile T *)p` and orders with
+ * __threadfence[_system](). volatile is not a synchronisation primitive: it
+ * constrains the compiler for one access and says nothing about which agents
+ * the access must be coherent with. It works on NVIDIA because the emitted
+ * loads happen to bypass cache, not because the language promises it.
+ *
+ * HIP can state the scope exactly, and on AMD the scope is what selects which
+ * cache levels are bypassed and invalidated -- so being explicit is both more
+ * honest and cheaper than the uniform __threadfence_system() it replaces.
+ * Two scopes are in play:
+ *
+ *   SYSTEM  the tail markers and receive slots, written by the NIC's DMA, and
+ *           should_stop and validation_failed, shared with the host.
+ *   AGENT   the work queue, which only this kernel's own blocks touch.
+ *
+ * The queue handoff is a release/acquire pair on the slot's valid flag: the
+ * producer's release publishes the item fields written before it, and the
+ * consumer's acquire makes them visible. That ordering is what the bare
+ * __threadfence() calls around the flag were standing in for.
+ */
+#define PORT_LOAD_SYSTEM(p) \
+	__hip_atomic_load((p), __ATOMIC_RELAXED, __HIP_MEMORY_SCOPE_SYSTEM)
+#define PORT_ACQUIRE_SYSTEM(p) \
+	__hip_atomic_load((p), __ATOMIC_ACQUIRE, __HIP_MEMORY_SCOPE_SYSTEM)
+#define PORT_LOAD_AGENT(p) \
+	__hip_atomic_load((p), __ATOMIC_RELAXED, __HIP_MEMORY_SCOPE_AGENT)
+#define PORT_ACQUIRE_AGENT(p) \
+	__hip_atomic_load((p), __ATOMIC_ACQUIRE, __HIP_MEMORY_SCOPE_AGENT)
+#define PORT_RELEASE_AGENT(p, v) \
+	__hip_atomic_store((p), (v), __ATOMIC_RELEASE, __HIP_MEMORY_SCOPE_AGENT)
+
+#define VDBG(fmt, ...) \
+	do { if (g_ctx.debug_enabled) \
+		printf(VALIDATION_LOG_PREFIX " " fmt, ##__VA_ARGS__); \
+	} while (0)
+
+/* --- Global validation context (single instance, avoids dlsym ABI issues) --- */
+static struct ValidationContext g_ctx;
+static int g_initialized = 0;
+
+/* --- Error Handling --- */
+
+extern "C" const char* rocm_kernel_validation_strerror(int err)
+{
+	switch (err) {
+		case VALIDATION_OK:
+			return "Success";
+		case VALIDATION_ERR_NULL_PARAM:
+			return "NULL parameter passed";
+		case VALIDATION_ERR_CUDA_DEVICE:
+			return "Failed to set GPU device";
+		case VALIDATION_ERR_ALLOC_QUEUE:
+			return "Failed to allocate work queue";
+		case VALIDATION_ERR_ALLOC_QP_STATE:
+			return "Failed to allocate QP state";
+		case VALIDATION_ERR_ALLOC_ERROR_INFO:
+			return "Failed to allocate error info";
+		case VALIDATION_ERR_ALLOC_STATS:
+			return "Failed to allocate stats";
+		case VALIDATION_ERR_ALLOC_FLAGS:
+			return "Failed to allocate control flags";
+		case VALIDATION_ERR_MEMSET:
+			return "Failed to zero memory";
+		case VALIDATION_ERR_ALREADY_RUNNING:
+			return "Kernel already running";
+		case VALIDATION_ERR_INIT_FAILED:
+			return "Context initialization failed";
+		case VALIDATION_ERR_LAUNCH:
+			return "Kernel launch failed";
+		case VALIDATION_ERR_SYNC:
+			return "Device synchronization failed";
+		case VALIDATION_ERR_NOT_RUNNING:
+			return "Kernel not running";
+		default:
+			return "Unknown error";
+	}
+}
+
+/* --- Lock-free work queue (monitor threads produce, validator blocks consume) --- */
+
+/* Push a work item without advancing head on queue-full failure. */
+__device__ bool work_queue_push(struct ValidationWorkQueue *queue,
+                                uint32_t qp_id,
+                                uint16_t chunk_id,
+                                uint8_t pattern,
+                                uint64_t marker_epoch)
+{
+	uint32_t my_slot_index;
+
+	while (true) {
+		uint32_t head = PORT_LOAD_AGENT(&queue->head);
+		uint32_t tail = PORT_LOAD_AGENT(&queue->tail);
+
+		if ((head - tail) >= VALIDATION_QUEUE_SIZE)
+			return false;
+
+		uint32_t claimed = atomicCAS((uint32_t*)&queue->head, head, head + 1);
+		if (claimed == head) {
+			my_slot_index = head;
+			break;
+		}
+	}
+
+	uint32_t slot = my_slot_index & (VALIDATION_QUEUE_SIZE - 1);
+
+	queue->items[slot].qp_id = qp_id;
+	queue->items[slot].marker_epoch = marker_epoch;
+	queue->items[slot].chunk_id = chunk_id;
+	queue->items[slot].expected_pattern = pattern;
+
+	/* Release: publishes the item fields written above to the consumer. */
+	PORT_RELEASE_AGENT(&queue->items[slot].valid, (uint8_t)1);
+
+	return true;
+}
+
+/* Non-blocking pop (returns false on empty or CAS contention). */
+__device__ bool work_queue_try_pop(struct ValidationWorkQueue *queue,
+                                   struct ValidationWorkItem *item_out,
+                                   volatile uint32_t *should_stop)
+{
+	uint32_t tail = PORT_LOAD_AGENT(&queue->tail);
+	uint32_t head = PORT_LOAD_AGENT(&queue->head);
+
+	if (tail == head) {
+		item_out->valid = 0;
+		return false;
+	}
+
+	uint32_t claimed = atomicCAS((uint32_t*)&queue->tail, tail, tail + 1);
+	if (claimed != tail) {
+		item_out->valid = 0;
+		return false;
+	}
+
+	uint32_t slot = tail & (VALIDATION_QUEUE_SIZE - 1);
+
+	/*
+	 * Spin until the producer marks the slot valid. The CAS above already
+	 * claimed this slot, so a producer is committed to filling it -- but
+	 * this is a poll loop like any other and must honour the rules at the
+	 * top of this file: back off so the wave yields, and bail on
+	 * should_stop so a wedged producer cannot strand the whole block. The
+	 * caller runs this under __syncthreads(), so spinning here forever
+	 * deadlocks every thread in the block, not just this one.
+	 */
+	while (PORT_ACQUIRE_AGENT(&queue->items[slot].valid) == 0) {
+		if (PORT_LOAD_SYSTEM(should_stop)) {
+			item_out->valid = 0;
+			return false;
+		}
+		PORT_POLL_BACKOFF();
+	}
+
+	item_out->qp_id = queue->items[slot].qp_id;
+	item_out->marker_epoch = queue->items[slot].marker_epoch;
+	item_out->chunk_id = queue->items[slot].chunk_id;
+	item_out->expected_pattern = queue->items[slot].expected_pattern;
+	item_out->valid = 1;
+
+	queue->items[slot].valid = 0;
+	return true;
+}
+
+/* --- Monitor block: scan tail markers, push work items to queue --- */
+
+__device__ void monitor_scan_tails(
+	volatile uint64_t *tail_markers,
+	uint64_t *marker_last_seen,
+	uint32_t num_qps,
+	uint32_t chunks_per_qp,
+	struct QpValidationState *qp_state,
+	struct ValidationWorkQueue *work_queue,
+	volatile uint32_t *validation_failed,
+	volatile uint32_t *should_stop,
+	struct ValidationStats *stats)
+{
+	uint32_t tid = threadIdx.x;
+	uint32_t num_threads = blockDim.x;
+	uint32_t total_tails = num_qps * chunks_per_qp;
+	uint32_t scan_passes = 0;
+
+	while (!PORT_LOAD_SYSTEM(validation_failed) &&
+	       !PORT_LOAD_SYSTEM(should_stop)) {
+		PORT_POLL_BACKOFF();
+
+		if (tid == 0 && (++scan_passes & 0x3FF) == 0)
+			atomicAdd((unsigned long long*)&stats->markers_scanned,
+			          (unsigned long long)total_tails * 1024ULL);
+
+		for (uint32_t i = tid; i < total_tails; i += num_threads) {
+			/*
+			 * Acquire at system scope: seeing this marker is what
+			 * makes the payload the NIC DMA'd beneath it visible.
+			 * The CUDA original expressed that as a volatile read
+			 * followed by __threadfence_system(); the acquire is
+			 * the same ordering, attached to the load that needs it.
+			 */
+			uint64_t marker_value = PORT_ACQUIRE_SYSTEM(&tail_markers[i]);
+			uint64_t last_seen = marker_last_seen[i];
+
+			if (marker_value == 0 || marker_value <= last_seen)
+				continue;
+
+			uint32_t qp_id = i / chunks_per_qp;
+			uint32_t chunk_id = i % chunks_per_qp;
+
+			atomicAdd((unsigned long long*)&stats->monitor_detections, 1);
+
+			uint8_t expected_pattern = validation_cycle_to_pattern(marker_value - 1);
+			bool pushed = work_queue_push(work_queue, qp_id, (uint16_t)chunk_id,
+			                              expected_pattern, marker_value);
+			if (pushed) {
+				atomicAdd((unsigned long long*)&stats->markers_hit, 1);
+				if (marker_value - last_seen > 1)
+					atomicAdd((unsigned long long*)&stats->skipped_steps,
+					          (unsigned long long)(marker_value - last_seen - 1));
+				marker_last_seen[i] = marker_value;
+				atomicAdd(&qp_state[qp_id].chunks_validated, 1);
+			} else {
+				atomicAdd((unsigned long long*)&stats->queue_full_drops, 1);
+			}
+		}
+	}
+}
+
+/* --- Validator block logic: pop work items, validate data --- */
+
+/*
+ * Validate a chunk using uint4 (16-byte) vectorized loads for peak bandwidth.
+ * Handles unaligned head/tail with scalar fallback.
+ * Returns number of mismatches found by this thread.
+ */
+__device__ uint32_t validate_chunk_portion(
+	const uint8_t *data,
+	uint64_t size,
+	uint8_t expected,
+	uint64_t *error_offset,
+	uint8_t *actual_byte)
+{
+	const uint32_t tid = threadIdx.x;
+	const uint32_t num_threads = blockDim.x;
+
+	/* Build 16-byte pattern from single byte */
+	const uint32_t pattern32 = expected | (expected << 8) |
+	                           (expected << 16) | (expected << 24);
+	const uint4 pattern128 = make_uint4(pattern32, pattern32, pattern32, pattern32);
+
+	/* Aligned boundaries */
+	const uintptr_t data_addr = (uintptr_t)data;
+	const uintptr_t aligned_start_addr = (data_addr + 15) & ~15ULL;
+	const uintptr_t aligned_end_addr = (data_addr + size) & ~15ULL;
+
+	const uint64_t head_size = (aligned_start_addr > data_addr) ?
+	                           (aligned_start_addr - data_addr) : 0;
+	const uint64_t tail_offset = aligned_end_addr - data_addr;
+	const uint64_t tail_size = size - tail_offset;
+	const uint4 *aligned_data = (const uint4*)aligned_start_addr;
+	const uint64_t num_uint4s = (aligned_end_addr > aligned_start_addr) ?
+	                            ((aligned_end_addr - aligned_start_addr) / 16) : 0;
+
+	uint32_t my_errors = 0;
+	uint64_t my_first_error = UINT64_MAX;
+	uint8_t my_error_byte = 0;
+
+	/* Unaligned head (0-15 bytes) */
+	for (uint64_t i = tid; i < head_size; i += num_threads) {
+		uint8_t val = data[i];
+		if (val != expected) {
+			my_errors++;
+			if (i < my_first_error) {
+				my_first_error = i;
+				my_error_byte = val;
+			}
+		}
+	}
+
+	/* Aligned region — vectorized uint4 loads (hot path) */
+	for (uint64_t idx = tid; idx < num_uint4s; idx += num_threads) {
+		uint4 loaded = __ldg(&aligned_data[idx]);
+
+		if ((loaded.x != pattern128.x) | (loaded.y != pattern128.y) |
+		    (loaded.z != pattern128.z) | (loaded.w != pattern128.w)) {
+			uint64_t base_offset = head_size + idx * 16;
+			const uint8_t *bytes = (const uint8_t*)&loaded;
+			const uint8_t *exp = (const uint8_t*)&pattern128;
+
+			#pragma unroll
+			for (int b = 0; b < 16; b++) {
+				if (bytes[b] != exp[b]) {
+					my_errors++;
+					uint64_t offset = base_offset + b;
+					if (offset < my_first_error) {
+						my_first_error = offset;
+						my_error_byte = bytes[b];
+					}
+				}
+			}
+		}
+	}
+
+	/* Unaligned tail (0-15 bytes) */
+	for (uint64_t i = tid; i < tail_size; i += num_threads) {
+		uint64_t byte_idx = tail_offset + i;
+		uint8_t val = data[byte_idx];
+		if (val != expected) {
+			my_errors++;
+			if (byte_idx < my_first_error) {
+				my_first_error = byte_idx;
+				my_error_byte = val;
+			}
+		}
+	}
+
+	*error_offset = my_first_error;
+	*actual_byte = my_error_byte;
+	return my_errors;
+}
+
+/* Pop work items, validate data, classify mismatches. */
+__device__ void validator_process_work(
+	volatile uint64_t *tail_markers,
+	const uint8_t *recv_slots_base,
+	uint64_t payload_size,
+	uint32_t tx_depth,
+	uint32_t num_qps,
+	uint32_t chunks_per_qp,
+	struct ValidationWorkQueue *work_queue,
+	volatile uint32_t *validation_failed,
+	volatile uint32_t *should_stop,
+	struct ValidationErrorInfo *error_info,
+	struct ValidationStats *stats)
+{
+	(void)num_qps;
+
+	__shared__ struct ValidationWorkItem work;
+	__shared__ uint32_t total_errors;
+	__shared__ uint64_t first_error_offset;
+	__shared__ uint8_t first_error_actual;
+	__shared__ int have_work;
+	__shared__ int should_exit;
+	__shared__ int stale_work;
+
+	uint32_t tid = threadIdx.x;
+	const uint64_t chunk_size = (uint64_t)tx_depth * payload_size;
+	const uint64_t qp_stride = chunks_per_qp * chunk_size;
+
+	while (true) {
+		/* Thread 0 reads volatile flags into shared memory so ALL threads
+		 * see the same value — prevents divergent __syncthreads() deadlock. */
+		if (tid == 0) {
+			should_exit = (PORT_LOAD_SYSTEM(validation_failed) ||
+				       PORT_LOAD_SYSTEM(should_stop)) ? 1 : 0;
+			have_work = 0;
+			if (!should_exit) {
+				have_work = work_queue_try_pop(work_queue, &work,
+				                               should_stop) ? 1 : 0;
+				if (have_work) {
+					total_errors = 0;
+					first_error_offset = UINT64_MAX;
+				}
+			}
+		}
+		__syncthreads();
+
+		if (should_exit)
+			break;
+		if (!have_work) {
+			PORT_POLL_BACKOFF();
+			continue;
+		}
+
+		const uint8_t *chunk_data = recv_slots_base +
+		                            work.qp_id * qp_stride +
+		                            work.chunk_id * chunk_size;
+		const uint32_t marker_idx = work.qp_id * chunks_per_qp + work.chunk_id;
+
+		/* Thread 0 snapshots the marker so all threads take the same branch. */
+		if (tid == 0) {
+			uint64_t marker_before =
+				PORT_ACQUIRE_SYSTEM(&tail_markers[marker_idx]);
+			stale_work = (marker_before > work.marker_epoch) ? 1 : 0;
+			if (stale_work)
+				atomicAdd((unsigned long long*)&stats->stale_work_skips, 1);
+		}
+		__syncthreads();
+
+		if (stale_work)
+			continue;
+
+		/*
+		 * No fence here: thread 0's acquire on marker_before above
+		 * already ordered the NIC's payload writes ahead of this
+		 * block's reads, and the __syncthreads() propagated that to
+		 * every thread.
+		 */
+
+		uint64_t my_error_offset;
+		uint8_t my_error_actual;
+		uint32_t my_errors = validate_chunk_portion(
+			chunk_data, chunk_size, work.expected_pattern,
+			&my_error_offset, &my_error_actual);
+
+		/* Warp-level reduction: reduces 256 potential atomics to max 8 */
+		const uint32_t FULL_WARP_MASK = 0xFFFFFFFF;
+		/*
+		 * PORT: the CUDA original uses a literal 32-lane warp
+		 * (tid & 31, offset starting at 16). An AMD wavefront is 64
+		 * lanes on CDNA and 32 on RDNA, so a literal 32 would reduce
+		 * only within half a wave and let two lanes see lane == 0 --
+		 * double-counting the atomics below. warpSize is a built-in,
+		 * not a constant, so the unrolls are dropped with it.
+		 */
+		const uint32_t lane = tid % warpSize;
+		uint32_t warp_has_errors = PORT_any_sync(FULL_WARP_MASK, my_errors > 0);
+
+		uint32_t warp_error_count = 0;
+		uint64_t warp_first_error_offset = UINT64_MAX;
+		uint8_t warp_first_error_actual = 0;
+
+		if (warp_has_errors) {
+			warp_error_count = my_errors;
+			for (int offset = warpSize / 2; offset > 0; offset /= 2)
+				warp_error_count += PORT_shfl_xor_sync(FULL_WARP_MASK, warp_error_count, offset);
+
+			warp_first_error_offset = my_error_offset;
+			warp_first_error_actual = my_error_actual;
+			for (int offset = warpSize / 2; offset > 0; offset /= 2) {
+				uint64_t other_offset = PORT_shfl_xor_sync(FULL_WARP_MASK, warp_first_error_offset, offset);
+				uint8_t other_actual = PORT_shfl_xor_sync(FULL_WARP_MASK, warp_first_error_actual, offset);
+				if (other_offset < warp_first_error_offset) {
+					warp_first_error_offset = other_offset;
+					warp_first_error_actual = other_actual;
+				}
+			}
+		}
+
+		if (lane == 0 && warp_has_errors) {
+			atomicAdd(&total_errors, warp_error_count);
+			if (warp_first_error_offset < first_error_offset) {
+				first_error_offset = warp_first_error_offset;
+				first_error_actual = warp_first_error_actual;
+			}
+		}
+		__syncthreads();
+
+		/* Thread 0: classify mismatch and update stats */
+		if (tid == 0) {
+			if (total_errors > 0) {
+				uint64_t err_off = first_error_offset;
+				uint8_t err_actual = first_error_actual;
+				uint8_t expected = work.expected_pattern;
+
+				/* DMA tail retry */
+				int retry_matched = 0;
+				uint64_t tail_bytes = payload_size * 2;
+				if (tail_bytes < 256)
+					tail_bytes = 256;
+				if (err_off >= chunk_size - tail_bytes) {
+					/*
+					 * PORT: the CUDA original fences, spins on
+					 * an empty loop, then re-reads with __ldg.
+					 * __ldg is a read-only-cache hint, which is
+					 * the one load least likely to observe a
+					 * DMA that landed in the meantime -- the
+					 * opposite of what a retry wants. Back off
+					 * as the other poll loops do and re-read at
+					 * system scope, which is both the fence and
+					 * the uncached fetch.
+					 */
+					PORT_POLL_BACKOFF();
+					uint8_t retry_val =
+						PORT_LOAD_SYSTEM(&chunk_data[err_off]);
+					if (retry_val == expected)
+						retry_matched = 1;
+				}
+
+				/*
+				 * Forward-byte snapshot for the epoch guard.
+				 * PORT: system scope rather than __ldg. These
+				 * five bytes are what classify_validation_mismatch()
+				 * uses to tell an in-flight overwrite from real
+				 * corruption, so reading them from a stale cache
+				 * biases towards reporting corruption that did not
+				 * happen -- the one error a validator must not make.
+				 */
+				uint8_t actual_snap = err_actual;
+				uint8_t fwd[4] = {expected, expected, expected, expected};
+				int fwd_valid = 0;
+				if (!retry_matched && (err_off + 4) < chunk_size) {
+					actual_snap = PORT_LOAD_SYSTEM(&chunk_data[err_off]);
+					fwd[0] = PORT_LOAD_SYSTEM(&chunk_data[err_off + 1]);
+					fwd[1] = PORT_LOAD_SYSTEM(&chunk_data[err_off + 2]);
+					fwd[2] = PORT_LOAD_SYSTEM(&chunk_data[err_off + 3]);
+					fwd[3] = PORT_LOAD_SYSTEM(&chunk_data[err_off + 4]);
+					fwd_valid = 1;
+				}
+
+				enum validation_mismatch_type mtype =
+					classify_validation_mismatch(
+						err_off, chunk_size,
+						payload_size, expected,
+						actual_snap, retry_matched, fwd,
+						fwd_valid);
+
+				uint64_t marker_after =
+					PORT_LOAD_SYSTEM(&tail_markers[marker_idx]);
+				if (marker_after > work.marker_epoch) {
+					atomicAdd((unsigned long long *)&stats->stale_work_skips, 1);
+					atomicAdd((unsigned long long *)&stats->race_overwrites, 1);
+				} else if (mtype == VALIDATION_MISMATCH_STALE) {
+					atomicAdd((unsigned long long *)&stats->dma_stale_retries, 1);
+				} else if (mtype == VALIDATION_MISMATCH_RACE) {
+					atomicAdd((unsigned long long *)&stats->race_overwrites, 1);
+				} else {
+					error_info->qp_id = work.qp_id;
+					error_info->chunk_id = work.chunk_id;
+					error_info->byte_offset = err_off;
+					error_info->expected = expected;
+					error_info->actual = err_actual;
+					atomicExch((uint32_t *)validation_failed, 1);
+					atomicAdd((unsigned long long *)&stats->errors_found, total_errors);
+				}
+			}
+			atomicAdd((unsigned long long*)&stats->chunks_validated, 1);
+			atomicAdd((unsigned long long*)&stats->bytes_validated, chunk_size);
+		}
+		__syncthreads();
+	}
+}
+
+/* --- Main kernel entry point (block 0 = monitor, blocks 1..N = validators) --- */
+__global__ void validation_kernel(
+	volatile uint64_t *tail_markers,
+	const uint8_t *recv_slots_base,
+	uint64_t payload_size,
+	uint32_t tx_depth,
+	uint32_t num_qps,
+	uint32_t chunks_per_qp,
+	struct QpValidationState *qp_state,
+	struct ValidationWorkQueue *work_queue,
+	uint64_t *marker_last_seen,
+	volatile uint32_t *validation_failed,
+	volatile uint32_t *should_stop,
+	struct ValidationErrorInfo *error_info,
+	struct ValidationStats *stats)
+{
+	/* Block 0 is the monitor, blocks 1..N are validators */
+	if (blockIdx.x == 0) {
+		monitor_scan_tails(tail_markers, marker_last_seen,
+		                   num_qps, chunks_per_qp,
+		                   qp_state, work_queue,
+		                   validation_failed, should_stop, stats);
+	} else {
+		validator_process_work(tail_markers, recv_slots_base, payload_size, tx_depth,
+		                       num_qps, chunks_per_qp, work_queue,
+		                       validation_failed, should_stop,
+		                       error_info, stats);
+	}
+}
+
+/* --- Exported Plugin API (loaded via dlsym) --- */
+
+/*
+ * Free all GPU allocations in g_ctx (NULL-safe, idempotent).
+ *
+ * hipFree's result is discarded deliberately, and the casts say so: this runs
+ * on the teardown path, where every caller goes on to zero g_ctx and return a
+ * failure that is already more specific than "a free failed". hipcc marks the
+ * HIP entry points nodiscard, which nvcc does not, so the CUDA original gets
+ * away with the bare calls.
+ */
+static void free_validation_allocations(void)
+{
+	if (g_ctx.d_work_queue)        (void)hipFree(g_ctx.d_work_queue);
+	if (g_ctx.d_marker_last_seen)  (void)hipFree(g_ctx.d_marker_last_seen);
+	if (g_ctx.d_qp_state)          (void)hipFree(g_ctx.d_qp_state);
+	if (g_ctx.d_error_info)        (void)hipFree(g_ctx.d_error_info);
+	if (g_ctx.d_stats)             (void)hipFree(g_ctx.d_stats);
+	if (g_ctx.d_validation_failed) (void)hipFree((void*)g_ctx.d_validation_failed);
+	if (g_ctx.d_should_stop)       (void)hipFree((void*)g_ctx.d_should_stop);
+	/* d_tail_markers points into main buffer — don't free */
+}
+
+/*
+ * Zero all runtime state (GPU buffers + host copies) for a fresh run.
+ *
+ * Unlike the frees above these results do matter: a hipMemset that silently
+ * failed would leave a previous run's markers, stats or error record in place
+ * and the validator would report them as this run's.
+ *
+ * Returns VALIDATION_OK or VALIDATION_ERR_MEMSET.
+ */
+static int reset_validation_state(void)
+{
+	hipError_t err;
+
+	err = hipMemset(g_ctx.d_work_queue, 0, sizeof(struct ValidationWorkQueue));
+	if (err == hipSuccess)
+		err = hipMemset(g_ctx.d_marker_last_seen, 0,
+				g_ctx.params.num_qps * g_ctx.chunks_per_qp *
+				sizeof(uint64_t));
+	if (err == hipSuccess)
+		err = hipMemset(g_ctx.d_qp_state, 0,
+				g_ctx.params.num_qps *
+				sizeof(struct QpValidationState));
+	if (err == hipSuccess)
+		err = hipMemset(g_ctx.d_error_info, 0,
+				sizeof(struct ValidationErrorInfo));
+	if (err == hipSuccess)
+		err = hipMemset(g_ctx.d_stats, 0, sizeof(struct ValidationStats));
+
+	if (err != hipSuccess) {
+		fprintf(stderr, VALIDATION_LOG_PREFIX
+			" Failed to zero validation state: %s\n",
+			hipGetErrorString(err));
+		return VALIDATION_ERR_MEMSET;
+	}
+
+	*(uint32_t*)g_ctx.d_validation_failed = 0;
+	*(uint32_t*)g_ctx.d_should_stop = 0;
+	memset(&g_ctx.h_error_info, 0, sizeof(struct ValidationErrorInfo));
+	memset(&g_ctx.h_stats, 0, sizeof(struct ValidationStats));
+	return VALIDATION_OK;
+}
+
+static int calculate_validator_blocks(uint32_t num_qps)
+{
+	int blocks = num_qps * 16;
+	if (blocks < 32) blocks = 32;
+	if (blocks > VALIDATION_MAX_VALIDATOR_BLOCKS) blocks = VALIDATION_MAX_VALIDATOR_BLOCKS;
+	return blocks;
+}
+
+/* Initialize the validation context and allocate GPU memory. */
+extern "C" int rocm_kernel_validation_init(
+	void *buffer_base,
+	uint64_t markers_offset,
+	uint64_t recv_slots_offset,
+	uint64_t payload_size,
+	uint32_t tx_depth,
+	uint32_t num_qps,
+	uint32_t chunks_per_qp,
+	int validation_mode,
+	int cuda_device_id,
+	int debug_enabled)
+{
+	hipError_t err;
+	(void)validation_mode;
+
+	if (buffer_base == NULL) {
+		fprintf(stderr, VALIDATION_LOG_PREFIX " Error: %s\n", rocm_kernel_validation_strerror(VALIDATION_ERR_NULL_PARAM));
+		return -1;
+	}
+
+	err = hipSetDevice(cuda_device_id);
+	if (err != hipSuccess) {
+		fprintf(stderr, VALIDATION_LOG_PREFIX " Error setting GPU device %d: %s\n",
+		        cuda_device_id, hipGetErrorString(err));
+		return -1;
+	}
+	if (debug_enabled) printf(VALIDATION_LOG_PREFIX " Using GPU device %d\n", cuda_device_id);
+
+	if (chunks_per_qp == 0 || chunks_per_qp > VALIDATION_MAX_CHUNKS_PER_QP) {
+		fprintf(stderr, VALIDATION_LOG_PREFIX " Error: chunks_per_qp=%u out of range [1, %d]\n",
+			chunks_per_qp, VALIDATION_MAX_CHUNKS_PER_QP);
+		return -1;
+	}
+
+	memset(&g_ctx, 0, sizeof(g_ctx));
+	g_ctx.cuda_device_id = cuda_device_id;
+	g_ctx.debug_enabled = debug_enabled;
+	g_ctx.chunks_per_qp = chunks_per_qp;
+
+	g_ctx.params.tail_markers_addr = (uint64_t)buffer_base + markers_offset;
+	g_ctx.params.recv_slots_addr = (uint64_t)buffer_base + recv_slots_offset;
+	g_ctx.params.patterns_addr = (uint64_t)buffer_base;
+	g_ctx.params.payload_size = payload_size;
+	g_ctx.params.tx_depth = tx_depth;
+	g_ctx.params.num_qps = num_qps;
+	g_ctx.d_tail_markers = (volatile uint64_t*)g_ctx.params.tail_markers_addr;
+
+	int num_validators = calculate_validator_blocks(num_qps);
+	g_ctx.params.num_validator_blocks = num_validators;
+	g_ctx.num_blocks = 1 + num_validators;
+
+	VDBG("Creating context: num_qps=%u, tx_depth=%u, payload=%lu, chunks_per_qp=%u\n",
+	     num_qps, tx_depth, payload_size, chunks_per_qp);
+	VDBG("Blocks: 1 monitor + %d validators = %d total\n",
+	     num_validators, g_ctx.num_blocks);
+
+	/* Allocate GPU memory — all pointers start as NULL (memset above),
+	 * so the goto-fail cleanup can safely free any partial allocations. */
+	err = hipMalloc((void**)&g_ctx.d_work_queue, sizeof(struct ValidationWorkQueue));
+	if (err != hipSuccess) goto alloc_fail;
+
+	err = hipMalloc((void**)&g_ctx.d_marker_last_seen,
+			 num_qps * chunks_per_qp * sizeof(uint64_t));
+	if (err != hipSuccess) goto alloc_fail;
+
+	err = hipMalloc((void**)&g_ctx.d_qp_state,
+			 num_qps * sizeof(struct QpValidationState));
+	if (err != hipSuccess) goto alloc_fail;
+
+	err = hipMallocManaged((void**)&g_ctx.d_error_info, sizeof(struct ValidationErrorInfo));
+	if (err != hipSuccess) goto alloc_fail;
+
+	err = hipMallocManaged((void**)&g_ctx.d_stats, sizeof(struct ValidationStats));
+	if (err != hipSuccess) goto alloc_fail;
+
+	err = hipMallocManaged((void**)&g_ctx.d_validation_failed, sizeof(uint32_t));
+	if (err != hipSuccess) goto alloc_fail;
+
+	err = hipMallocManaged((void**)&g_ctx.d_should_stop, sizeof(uint32_t));
+	if (err != hipSuccess) goto alloc_fail;
+
+	if (reset_validation_state() != VALIDATION_OK) {
+		free_validation_allocations();
+		memset(&g_ctx, 0, sizeof(g_ctx));
+		return VALIDATION_ERR_MEMSET;
+	}
+
+	g_initialized = 1;
+	g_ctx.kernel_running = 0;
+
+	VDBG("Context created successfully\n");
+	return 0;
+
+alloc_fail:
+	fprintf(stderr, VALIDATION_LOG_PREFIX " GPU allocation failed: %s\n",
+		hipGetErrorString(err));
+	free_validation_allocations();
+	memset(&g_ctx, 0, sizeof(g_ctx));
+	return -1;
+}
+
+/* Start the validation kernel. Params/num_blocks/threads_per_block are unused (kept for ABI). */
+extern "C" int rocm_kernel_validation_start(void *params, int num_blocks, int threads_per_block)
+{
+	(void)params;
+
+	/*
+	 * PORT: the CUDA original accepts num_blocks and threads_per_block and
+	 * then ignores them, always launching calculate_validator_blocks()+1
+	 * blocks of VALIDATION_THREADS_PER_BLOCK. Honour them when non-zero.
+	 *
+	 * The geometry is the one thing about this design that does not carry
+	 * across devices unchanged: the default is 33 blocks x 1024 threads,
+	 * which a discrete GPU retires trivially and a functional simulator
+	 * does not retire at all. Nothing about the algorithm changes with a
+	 * smaller launch -- the monitor still scans, the validators still
+	 * drain the queue -- so making it settable keeps one implementation
+	 * for both.
+	 */
+	const int blocks = (num_blocks > 0) ? num_blocks : g_ctx.num_blocks;
+	const int threads = (threads_per_block > 0) ? threads_per_block
+						    : VALIDATION_THREADS_PER_BLOCK;
+
+	if (!g_initialized) {
+		fprintf(stderr, VALIDATION_LOG_PREFIX " Error: Context not initialized\n");
+		return -1;
+	}
+	if (g_ctx.kernel_running) {
+		fprintf(stderr, VALIDATION_LOG_PREFIX " Error: %s\n", rocm_kernel_validation_strerror(VALIDATION_ERR_ALREADY_RUNNING));
+		return -1;
+	}
+
+	hipError_t err = hipSetDevice(g_ctx.cuda_device_id);
+	if (err != hipSuccess) {
+		fprintf(stderr, VALIDATION_LOG_PREFIX " Error setting GPU device: %s\n",
+		        hipGetErrorString(err));
+		return -1;
+	}
+
+	if (reset_validation_state() != VALIDATION_OK)
+		return VALIDATION_ERR_MEMSET;
+
+	uint8_t *recv_slots_base = (uint8_t*)g_ctx.params.recv_slots_addr;
+
+	VDBG("Launching kernel with %d blocks (%d threads each)\n",
+	     blocks, threads);
+	VDBG("tail_markers: %p, recv_slots: %p\n",
+	     (void*)g_ctx.d_tail_markers, recv_slots_base);
+	VDBG("payload_size: %lu, tx_depth: %u, num_qps: %u\n",
+	     g_ctx.params.payload_size, g_ctx.params.tx_depth, g_ctx.params.num_qps);
+
+	validation_kernel<<<blocks, threads>>>(
+		g_ctx.d_tail_markers,
+		recv_slots_base,
+		g_ctx.params.payload_size,
+		g_ctx.params.tx_depth,
+		g_ctx.params.num_qps,
+		g_ctx.chunks_per_qp,
+		g_ctx.d_qp_state,
+		g_ctx.d_work_queue,
+		g_ctx.d_marker_last_seen,
+		g_ctx.d_validation_failed,
+		g_ctx.d_should_stop,
+		g_ctx.d_error_info,
+		g_ctx.d_stats);
+
+	err = hipGetLastError();
+	if (err != hipSuccess) {
+		fprintf(stderr, VALIDATION_LOG_PREFIX " Error launching kernel: %s\n",
+		        hipGetErrorString(err));
+		return -1;
+	}
+
+	g_ctx.kernel_running = 1;
+	VDBG("Kernel launched successfully\n");
+	return 0;
+}
+
+extern "C" int rocm_kernel_validation_stop(void)
+{
+	if (!g_initialized || !g_ctx.kernel_running)
+		return 0;
+
+	VDBG("Stopping kernel...\n");
+	*(volatile uint32_t*)g_ctx.d_should_stop = 1;
+
+	hipError_t err = hipDeviceSynchronize();
+	if (err != hipSuccess) {
+		fprintf(stderr, VALIDATION_LOG_PREFIX " Error waiting for kernel: %s\n",
+		        hipGetErrorString(err));
+		return -1;
+	}
+
+	g_ctx.kernel_running = 0;
+
+	VDBG("Kernel stopped\n");
+	VDBG("Final stats: chunks=%lu, bytes=%lu, errors=%lu, "
+	     "detections=%lu, skips=%lu, queue_full=%lu, stale_work=%lu, "
+	     "races=%lu, retries=%lu\n",
+	     g_ctx.d_stats->chunks_validated,
+	     g_ctx.d_stats->bytes_validated,
+	     g_ctx.d_stats->errors_found,
+	     g_ctx.d_stats->monitor_detections,
+	     g_ctx.d_stats->skipped_steps,
+	     g_ctx.d_stats->queue_full_drops,
+	     g_ctx.d_stats->stale_work_skips,
+	     g_ctx.d_stats->race_overwrites,
+	     g_ctx.d_stats->dma_stale_retries);
+
+	return 0;
+}
+
+/* Read stats from managed memory (NULL-safe for optional outputs). */
+extern "C" int rocm_kernel_validation_get_stats(uint64_t *chunks_validated,
+				    uint64_t *bytes_validated,
+				    uint64_t *errors_found,
+				    uint64_t *markers_scanned,
+				    uint64_t *markers_hit,
+				    uint64_t *skipped_steps,
+				    uint64_t *race_overwrites,
+				    uint64_t *dma_stale_retries,
+				    uint64_t *queue_full_drops,
+				    uint64_t *stale_work_skips)
+{
+	if (!g_initialized) return -1;
+	if (chunks_validated) *chunks_validated = g_ctx.d_stats->chunks_validated;
+	if (bytes_validated) *bytes_validated = g_ctx.d_stats->bytes_validated;
+	if (errors_found) *errors_found = g_ctx.d_stats->errors_found;
+	if (markers_scanned) *markers_scanned = g_ctx.d_stats->markers_scanned;
+	if (markers_hit) *markers_hit = g_ctx.d_stats->markers_hit;
+	if (skipped_steps) *skipped_steps = g_ctx.d_stats->skipped_steps;
+	if (race_overwrites) *race_overwrites = g_ctx.d_stats->race_overwrites;
+	if (dma_stale_retries) *dma_stale_retries = g_ctx.d_stats->dma_stale_retries;
+	if (queue_full_drops) *queue_full_drops = g_ctx.d_stats->queue_full_drops;
+	if (stale_work_skips) *stale_work_skips = g_ctx.d_stats->stale_work_skips;
+	return 0;
+}
+
+/* Read error details from managed memory. */
+extern "C" int rocm_kernel_validation_get_error(uint32_t *qp_id, uint32_t *chunk_id,
+				    uint64_t *byte_offset,
+				    uint8_t *expected, uint8_t *actual)
+{
+	if (!g_initialized) return -1;
+	if (qp_id) *qp_id = g_ctx.d_error_info->qp_id;
+	if (chunk_id) *chunk_id = g_ctx.d_error_info->chunk_id;
+	if (byte_offset) *byte_offset = g_ctx.d_error_info->byte_offset;
+	if (expected) *expected = g_ctx.d_error_info->expected;
+	if (actual) *actual = g_ctx.d_error_info->actual;
+	return 0;
+}
+
+extern "C" int rocm_kernel_validation_destroy(void)
+{
+	int debug = g_ctx.debug_enabled;
+
+	if (!g_initialized) return 0;
+
+	if (g_ctx.kernel_running)
+		rocm_kernel_validation_stop();
+
+	free_validation_allocations();
+	memset(&g_ctx, 0, sizeof(g_ctx));
+	g_initialized = 0;
+
+	if (debug)
+		printf(VALIDATION_LOG_PREFIX " Context destroyed, all memory freed\n");
+	return 0;
+}
+
+extern "C" int rocm_kernel_validation_is_running(void)
+{
+	return g_initialized && g_ctx.kernel_running;
+}
+
+/* Returns 0 = OK, 1 = failed, -1 = not initialized. */
+extern "C" int rocm_kernel_validation_check_status(void)
+{
+	if (!g_initialized) return -1;
+	uint32_t failed = 0;
+	/*
+	 * A discarded result here would be reported as "not failed", which is
+	 * the wrong direction to guess in: we would be asserting the data is
+	 * good on the strength of a copy that did not happen.
+	 */
+	hipError_t err = hipMemcpy(&failed, (void*)g_ctx.d_validation_failed,
+				   sizeof(uint32_t), hipMemcpyDeviceToHost);
+	if (err != hipSuccess) {
+		fprintf(stderr, VALIDATION_LOG_PREFIX
+			" Failed to read validation status: %s\n",
+			hipGetErrorString(err));
+		return -1;
+	}
+	return failed ? 1 : 0;
+}
+
+/* --- GPU page touch (--gpu_touch feature, ensures pages are resident for RDMA) --- */
+
+#define GPU_TOUCH_STEP 4096
+
+__global__ void rocm_touch_pages_kernel(volatile uint8_t *c, int size,
+                                 volatile int *stop_flag, int is_infinite)
+{
+	do {
+		for (int iter = 0; iter < size; iter += GPU_TOUCH_STEP)
+			c[iter] = 0;
+	} while (is_infinite && !*stop_flag);
+}
+
+extern "C" int rocm_touch_gpu_pages(uint8_t *addr, int buf_size,
+                               int is_infinite, volatile int **stop_flag)
+{
+	rocm_touch_pages_kernel<<<1, 1>>>(addr, buf_size, *stop_flag, is_infinite);
+	hipError_t err = hipGetLastError();
+	if (err != hipSuccess) {
+		fprintf(stderr, VALIDATION_LOG_PREFIX " GPU touch kernel launch error: %s\n",
+		        hipGetErrorString(err));
+		return -1;
+	}
+	return 0;
+}
+
+extern "C" int rocm_init_gpu_stop_flag(volatile int **stop_flag)
+{
+	hipError_t ret = hipMallocManaged((void **)stop_flag, sizeof(int));
+	if (ret != hipSuccess) {
+		fprintf(stderr, VALIDATION_LOG_PREFIX " Failed to allocate stop flag: %s\n",
+		        hipGetErrorString(ret));
+		return -1;
+	}
+	**stop_flag = 0;
+	return 0;
+}
+
+/*
+ * Has no CUDA counterpart: the CUDA plugin answers this question by whether
+ * libperftest_kernels.so dlopen'd at all. These kernels are linked in
+ * unconditionally, so rocm_validation.c needs a runtime probe instead.
+ */
+extern "C" int rocm_kernels_available(void)
+{
+	int count = 0;
+
+	return (hipGetDeviceCount(&count) == hipSuccess && count > 0) ? 1 : 0;
+}
diff --git a/src/rocm_memory.c b/src/rocm_memory.c
index cb580d5..b6b75bd 100644
--- a/src/rocm_memory.c
+++ b/src/rocm_memory.c
@@ -7,8 +7,8 @@
 #include <stdio.h>
 #include <stdlib.h>
 #include <errno.h>
-#include <sys/utsname.h>
 #include "rocm_memory.h"
+#include "rocm_validation.h"
 #include <hip/hip_runtime_api.h>
 #if defined HAVE_HIP_HIP_VERSION_H
 #include <hip/hip_version.h>
@@ -75,83 +75,31 @@ int rocm_memory_init(struct memory_ctx *ctx) {
 		return FAILURE;
 	}
 
-#ifdef HAVE_ROCM_DMABUF
-	if (rocm_ctx->use_dmabuf) {
-		int dmabuf_supported     = 0;
-		const char kernel_opt1[] = "CONFIG_DMABUF_MOVE_NOTIFY=y";
-		const char kernel_opt2[] = "CONFIG_PCI_P2PDMA=y";
-		int found_opt1           = 0;
-		int found_opt2           = 0;
-		const char *config_path_fmts[] = {
-			"/boot/config-%s",
-			"/usr/src/linux-%s/.config",
-			"/usr/src/linux/.config",
-			"/usr/lib/modules/%s/config",
-			"/usr/lib/ostree-boot/config-%s",
-			"/usr/lib/kernel/config-%s",
-			"/usr/src/linux-headers-%s/.config",
-			"/lib/modules/%s/build/.config",
-		};
-		size_t num_paths = sizeof(config_path_fmts) /
-				   sizeof(config_path_fmts[0]);
-		struct utsname utsname;
-		char kernel_conf_file[256];
-		char buf[256];
-		FILE *fp = NULL;
-		size_t i;
-
-		if (uname(&utsname) == -1) {
-			printf("could not get kernel name\n");
-			return FAILURE;
-		}
-
-		for (i = 0; i < num_paths; i++) {
-			snprintf(kernel_conf_file, sizeof(kernel_conf_file),
-				 config_path_fmts[i], utsname.release);
-			fp = fopen(kernel_conf_file, "r");
-			if (fp != NULL) {
-				break;
-			}
-		}
-
-        if (fp != NULL) {
-            while (fgets(buf, sizeof(buf), fp) != NULL) {
-                if (strstr(buf, kernel_opt1) != NULL) {
-                        found_opt1 = 1;
-                }
-                if (strstr(buf, kernel_opt2) != NULL) {
-                        found_opt2 = 1;
-                }
-                if (found_opt1 && found_opt2) {
-                        dmabuf_supported = 1;
-                        break;
-                }
-            }
-                fclose(fp);
-        }
-
-		// Fallback, works inside Docker containers where /boot/config-* is unavailable.
-		if (!dmabuf_supported) {
-			fp = fopen("/proc/kallsyms", "r");
-			if (fp != NULL) {
-				int o1 = 0, o2 = 0;
-				while (fgets(buf, sizeof(buf), fp) != NULL) {
-					if (!o1 && strstr(buf, " dma_buf_move_notify")) o1 = 1;
-					if (!o2 && strstr(buf, " pci_p2pdma"))            o2 = 1;
-					if (o1 && o2) break;
-				}
-				fclose(fp);
-				dmabuf_supported = (o1 && o2);
-			}
-		}
-
-		if (dmabuf_supported == 0) {
-            printf("could not verify dmabuf support from kernel "
-                	"config \n");
-			return FAILURE;
-		}
-	}
-#endif
+	/*
+	 * No dma_buf pre-flight check here, deliberately.
+	 *
+	 * This used to scan /boot/config-* for CONFIG_DMABUF_MOVE_NOTIFY and
+	 * CONFIG_PCI_P2PDMA and refuse to run if either was missing. Both
+	 * halves were wrong. move_notify no longer exists upstream -- dma-buf
+	 * always builds with it, and .move_notify became .invalidate_mappings
+	 * -- so the probe started failing precisely because support became
+	 * universal. And what it had gated was whether amdgpu_dma_buf_pin()
+	 * kept AMDGPU_GEM_DOMAIN_VRAM or fell back to GTT: driver policy,
+	 * versioned with the driver rather than with the running kernel, which
+	 * on a DKMS install moves independently of it. Today that placement
+	 * depends only on every attachment advertising peer2peer, which is not
+	 * observable before attach either.
+	 *
+	 * PCI_P2PDMA fares no better. It cannot see whether the NIC's driver
+	 * implements .reg_user_mr_dmabuf, so it passes on hardware that then
+	 * fails to register anyway.
+	 *
+	 * Both questions the check was trying to answer are already answered,
+	 * accurately, by the calls that do the work:
+	 * hsa_amd_portable_export_dmabuf() in rocm_memory_allocate_buffer()
+	 * reports whether ROCm can export, and ibv_reg_dmabuf_mr() reports
+	 * whether this NIC can import. Let those speak for themselves.
+	 */
 
 	return SUCCESS;
 }
@@ -163,16 +111,63 @@ int rocm_memory_destroy(struct memory_ctx *ctx) {
 	return SUCCESS;
 }
 
+static void *rocm_memory_copy_host_to_buffer(void *dest, const void *src,
+					     size_t size)
+{
+	hipError_t error = hipMemcpy(dest, src, size, hipMemcpyHostToDevice);
+
+	if (error != hipSuccess)
+		printf("hipMemcpy(HostToDevice) error=%d\n", error);
+	return dest;
+}
+
+static void *rocm_memory_copy_buffer_to_host(void *dest, const void *src,
+					     size_t size)
+{
+	hipError_t error = hipMemcpy(dest, src, size, hipMemcpyDeviceToHost);
+
+	if (error != hipSuccess)
+		printf("hipMemcpy(DeviceToHost) error=%d\n", error);
+	return dest;
+}
+
+static void *rocm_memory_copy_buffer_to_buffer(void *dest, const void *src,
+					       size_t size)
+{
+	hipError_t error = hipMemcpy(dest, src, size, hipMemcpyDeviceToDevice);
+
+	if (error != hipSuccess)
+		printf("hipMemcpy(DeviceToDevice) error=%d\n", error);
+	return dest;
+}
+
 int rocm_memory_allocate_buffer(struct memory_ctx *ctx, int alignment, uint64_t size, int *dmabuf_fd,
 				uint64_t *dmabuf_offset, void **addr, bool *can_init) {
 	void *d_A;
 	hipError_t error;
 	size_t buf_size = (size + ACCEL_PAGE_SIZE - 1) & ~(ACCEL_PAGE_SIZE - 1);
 
-	error = hipMalloc(&d_A, buf_size);
-	if (error != hipSuccess) {
-		printf("hipMalloc error=%d\n", error);
-		return FAILURE;
+	/* Some RDMA devices cannot reach the GPU's VRAM even though the MR
+	 * registers cleanly -- the failure surfaces later, as a gather error on
+	 * the first work request. A host-mapped allocation is still addressable
+	 * by the GPU but lives in system memory, which such a device can reach.
+	 * Opt in with PERFTEST_ROCM_HOST_ALLOC=1. Note this measures host memory
+	 * rather than VRAM, so it diagnoses reachability, it does not benchmark
+	 * peer-to-peer. */
+	if (getenv("PERFTEST_ROCM_HOST_ALLOC") != NULL) {
+		error = hipHostMalloc(&d_A, buf_size,
+				      hipHostMallocMapped | hipHostMallocPortable);
+		if (error != hipSuccess) {
+			printf("hipHostMalloc error=%d\n", error);
+			return FAILURE;
+		}
+		printf("PERFTEST_ROCM_HOST_ALLOC: host-mapped GPU buffer\n");
+	} else {
+		error = hipMalloc(&d_A, buf_size);
+		if (error != hipSuccess) {
+			printf("hipMalloc error=%d\n", error);
+			return FAILURE;
+		}
 	}
 
 #ifdef HAVE_ROCM_DMABUF
@@ -195,8 +190,13 @@ int rocm_memory_allocate_buffer(struct memory_ctx *ctx, int alignment, uint64_t
 
 		status = hsa_amd_portable_export_dmabuf(d_A, aligned_size, dmabuf_fd, &offset);
 		if (status != HSA_STATUS_SUCCESS) {
-			printf("failed to export dmabuf handle for addr %p / %zu", d_A,
-					aligned_size);
+			fprintf(stderr,
+				"failed to export dmabuf handle for addr %p / %zu: "
+				"hsa_status_t=%d\n", d_A, aligned_size, status);
+			fprintf(stderr,
+				"ROCm could not export this allocation as a dma_buf. "
+				"The kernel may predate AMDKFD_IOC_EXPORT_DMABUF, or "
+				"amdgpu may not be the exporter for this device.\n");
 			return FAILURE;
 		}
 
@@ -209,6 +209,10 @@ int rocm_memory_allocate_buffer(struct memory_ctx *ctx, int alignment, uint64_t
 
 	printf("allocated %lu bytes of GPU buffer at %p\n", (unsigned long)buf_size, d_A);
 	*addr = d_A;
+	/* Device memory: initialize_buffer_content() must not fill this with
+	 * CPU stores. Where the allocation has no host mapping they fault, and
+	 * the crash lands in perftest_rand() long after the MR was created. The
+	 * buffer contents do not matter to a bandwidth test. */
 	*can_init = false;
 	return SUCCESS;
 }
@@ -239,9 +243,13 @@ struct memory_ctx *rocm_memory_create(struct perftest_parameters *params) {
 	ctx->base.destroy = rocm_memory_destroy;
 	ctx->base.allocate_buffer = rocm_memory_allocate_buffer;
 	ctx->base.free_buffer = rocm_memory_free_buffer;
-	ctx->base.copy_host_to_buffer = memcpy;
-	ctx->base.copy_buffer_to_host = memcpy;
-	ctx->base.copy_buffer_to_buffer = memcpy;
+	ctx->base.copy_host_to_buffer = rocm_memory_copy_host_to_buffer;
+	ctx->base.copy_buffer_to_host = rocm_memory_copy_buffer_to_host;
+	ctx->base.copy_buffer_to_buffer = rocm_memory_copy_buffer_to_buffer;
+	ctx->base.validation_init = rocm_validation_init;
+	ctx->base.validation_start = rocm_validation_start;
+	ctx->base.validation_stop = rocm_validation_stop;
+	ctx->base.validation_destroy = rocm_validation_destroy;
 	ctx->device_id = params->rocm_device_id;
 	ctx->use_dmabuf = params->use_rocm_dmabuf;
 
diff --git a/src/rocm_validation.c b/src/rocm_validation.c
new file mode 100644
index 0000000..1db1e66
--- /dev/null
+++ b/src/rocm_validation.c
@@ -0,0 +1,467 @@
+/* SPDX-License-Identifier: GPL-2.0 OR BSD-2-Clause */
+/*
+ * Copyright 2026 Advanced Micro Devices, Inc. All rights reserved.
+ *
+ * Data validation for ROCm device memory.  See rocm_validation.h for how the
+ * live kernel path and the host-staged fallback relate.
+ *
+ * Buffer layout is the one compute_validation_layout() builds and
+ * host_validation.c consumes:
+ *
+ *   [3 pattern buffers] [markers] [recv_slots] [atomic_returns]
+ *
+ * with, per QP q and chunk c:
+ *
+ *   marker index  = q * chunks_per_qp + c           (uint64_t each)
+ *   slot base     = recv_slots
+ *                   + (q * ops_per_chunk * chunks_per_qp
+ *                      + c * ops_per_chunk) * payload_size
+ *   chunk bytes   = ops_per_chunk * payload_size
+ *   expected byte = validation_cycle_to_pattern(marker - 1)
+ *
+ * The addressing is duplicated from host_validation.c rather than shared
+ * because that file keeps it in a file-scope singleton tied to its thread
+ * pool; lifting it out is a bigger change than this needs.  If either side
+ * moves, they must move together.
+ */
+
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+
+/*
+ * rocm_memory.h pulls in config.h, which is where configure's
+ * AC_DEFINE([__HIP_PLATFORM_AMD__]) lands.  The HIP headers #error out
+ * without it, so this include must come first -- same ordering as
+ * rocm_memory.c.
+ */
+#include "rocm_memory.h"
+#include "rocm_validation.h"
+#include "cuda_validation.h"   /* VALIDATION_OK and the shared structures */
+#include <hip/hip_runtime_api.h>
+
+#ifdef HAVE_ROCM_KERNELS
+#include "rocm_kernels.h"
+#endif
+
+#define RVLOG(fmt, ...) \
+	do { if (g_rv.debug) \
+		printf(VALIDATION_LOG_PREFIX " rocm: " fmt "\n", ##__VA_ARGS__); \
+	} while (0)
+
+static struct {
+	int initialized;
+	int debug;
+	void *device_base;      /* start of the validation region in device memory */
+	uint8_t *host_copy;     /* staging buffer, device_span bytes */
+	uint64_t device_span;   /* bytes copied back at stop */
+	uint64_t markers_offset;
+	uint64_t recv_slots_offset;
+	uint64_t payload_size;
+	uint32_t ops_per_chunk;
+	uint32_t num_qps;
+	uint32_t chunks_per_qp;
+	int validation_mode;
+	int device_id;
+#ifdef HAVE_ROCM_KERNELS
+	void *persist;          /* non-NULL while the live kernel is running */
+#endif
+} g_rv;
+
+int rocm_validation_init(struct memory_ctx *ctx,
+			 const struct validation_config *cfg)
+{
+	(void)ctx;
+
+	if (!cfg || !cfg->buffer_base)
+		return -1;
+	if (cfg->payload_size == 0 || cfg->ops_per_chunk == 0 ||
+	    cfg->num_qps == 0 || cfg->chunks_per_qp == 0)
+		return -1;
+
+	memset(&g_rv, 0, sizeof(g_rv));
+	g_rv.debug             = cfg->debug_enabled;
+	g_rv.device_base       = cfg->buffer_base;
+	g_rv.markers_offset    = cfg->markers_offset;
+	g_rv.recv_slots_offset = cfg->recv_slots_offset;
+	g_rv.payload_size      = cfg->payload_size;
+	g_rv.ops_per_chunk     = cfg->ops_per_chunk;
+	g_rv.num_qps           = cfg->num_qps;
+	g_rv.chunks_per_qp     = cfg->chunks_per_qp;
+	g_rv.validation_mode   = cfg->validation_mode;
+	g_rv.device_id         = 0;   /* set from the memory ctx below */
+
+	/*
+	 * Stage the whole buffer, as the layout sizes it.
+	 *
+	 * This used to stop at the end of recv_slots, reasoning that
+	 * atomic_returns lies beyond it and is not checked here. That is true
+	 * in WRITE mode and false in READ, where markers_offset *is*
+	 * atomic_returns_offset -- the last region in the layout, past
+	 * recv_slots. Reading the markers then ran one past the allocation and
+	 * fed heap bytes to the comparison as if they were marker epochs,
+	 * which surfaced as a mismatch in the first chunk the traffic never
+	 * reached. Do not re-derive a size the layout already computed.
+	 */
+	uint64_t markers_bytes, markers_end, slots_bytes, slots_end;
+
+	if (validation_safe_mul_u64((uint64_t)cfg->num_qps * cfg->chunks_per_qp,
+				    sizeof(uint64_t), &markers_bytes) != 0)
+		return -1;
+	if (validation_safe_mul_u64(cfg->payload_size, cfg->ops_per_chunk,
+				    &slots_bytes) != 0)
+		return -1;
+	if (validation_safe_mul_u64(slots_bytes, cfg->chunks_per_qp,
+				    &slots_bytes) != 0)
+		return -1;
+	if (validation_safe_mul_u64(slots_bytes, cfg->num_qps,
+				    &slots_bytes) != 0)
+		return -1;
+
+	markers_end = cfg->markers_offset + markers_bytes;
+	slots_end = cfg->recv_slots_offset + slots_bytes;
+
+	g_rv.device_span = cfg->buffer_size;
+
+	if (markers_end < cfg->markers_offset || slots_end < cfg->recv_slots_offset ||
+	    markers_end > g_rv.device_span || slots_end > g_rv.device_span) {
+		fprintf(stderr, VALIDATION_LOG_PREFIX
+			" rocm: validation regions do not fit the buffer "
+			"(markers end %llu, slots end %llu, buffer %llu)\n",
+			(unsigned long long)markers_end,
+			(unsigned long long)slots_end,
+			(unsigned long long)g_rv.device_span);
+		return -1;
+	}
+
+	g_rv.host_copy = malloc(g_rv.device_span);
+	if (!g_rv.host_copy) {
+		fprintf(stderr, VALIDATION_LOG_PREFIX
+			" rocm: cannot allocate %llu-byte staging buffer\n",
+			(unsigned long long)g_rv.device_span);
+		return -1;
+	}
+
+	g_rv.initialized = 1;
+	RVLOG("init: base=%p span=%llu markers@%llu slots@%llu payload=%llu "
+	      "ops_per_chunk=%u qps=%u chunks_per_qp=%u",
+	      g_rv.device_base, (unsigned long long)g_rv.device_span,
+	      (unsigned long long)g_rv.markers_offset,
+	      (unsigned long long)g_rv.recv_slots_offset,
+	      (unsigned long long)g_rv.payload_size,
+	      g_rv.ops_per_chunk, g_rv.num_qps, g_rv.chunks_per_qp);
+	return 0;
+}
+
+int rocm_validation_start(struct memory_ctx *ctx)
+{
+	(void)ctx;
+
+	if (!g_rv.initialized)
+		return -1;
+
+#ifdef HAVE_ROCM_KERNELS
+	/*
+	 * Live validation by default, driven exactly as cuda_memory.c drives
+	 * the CUDA plugin: init the context, then launch 1 monitor block plus
+	 * N validator blocks. PERFTEST_ROCM_VALIDATION=staged selects the host
+	 * compare instead, as does PERFTEST_ROCM_VALIDATION_STAGED=1.
+	 */
+	const char *mode = getenv("PERFTEST_ROCM_VALIDATION");
+
+	if ((!mode || !strcmp(mode, "persistent")) &&
+	    !getenv("PERFTEST_ROCM_VALIDATION_STAGED") &&
+	    rocm_kernels_available()) {
+		int rc = rocm_kernel_validation_init(g_rv.device_base,
+						     g_rv.markers_offset,
+						     g_rv.recv_slots_offset,
+						     g_rv.payload_size,
+						     g_rv.ops_per_chunk,
+						     g_rv.num_qps,
+						     g_rv.chunks_per_qp,
+						     g_rv.validation_mode,
+						     g_rv.device_id,
+						     g_rv.debug);
+		if (rc == VALIDATION_OK) {
+			/*
+			 * Defaults (0) reproduce the CUDA geometry. A device
+			 * that cannot retire 33 blocks x 1024 spinning
+			 * threads -- a functional simulator, say -- can ask
+			 * for a smaller launch without changing the kernel.
+			 */
+			const char *b = getenv("PERFTEST_ROCM_VALIDATION_BLOCKS");
+			const char *t = getenv("PERFTEST_ROCM_VALIDATION_THREADS");
+
+			rc = rocm_kernel_validation_start(NULL,
+							  b ? atoi(b) : 0,
+							  t ? atoi(t) : 0);
+			if (rc == VALIDATION_OK) {
+				g_rv.persist = (void *)1;
+				printf(VALIDATION_LOG_PREFIX
+				       " rocm: live GPU validation\n");
+				return 0;
+			}
+			rocm_kernel_validation_destroy();
+		}
+		fprintf(stderr, VALIDATION_LOG_PREFIX
+			" rocm: live validation unavailable (%s), falling back\n",
+			rocm_kernel_validation_strerror(rc));
+		g_rv.persist = NULL;
+	}
+#endif
+	return 0;
+}
+
+static int rocm_validation_stop_staged(struct data_validation_result *result)
+{
+
+	if (!g_rv.initialized || !result)
+		return -1;
+
+	memset(result, 0, sizeof(*result));
+
+	hipError_t err = hipMemcpy(g_rv.host_copy, g_rv.device_base,
+				   g_rv.device_span, hipMemcpyDeviceToHost);
+	if (err != hipSuccess) {
+		fprintf(stderr, VALIDATION_LOG_PREFIX
+			" rocm: hipMemcpy(DeviceToHost) failed: %d\n", err);
+		return -1;
+	}
+
+	/*
+	 * Fault injection, for proving the checker can fail. A validator that
+	 * only ever passes is indistinguishable from one that does not look.
+	 * PERFTEST_ROCM_VALIDATION_FAULT=<n> flips n bytes in the staged copy
+	 * -- never in device memory -- before the comparison runs.
+	 */
+	const char *fault = getenv("PERFTEST_ROCM_VALIDATION_FAULT");
+	if (fault) {
+		uint64_t n = strtoull(fault, NULL, 0);
+		for (uint64_t i = 0; i < n && i < g_rv.device_span; i++) {
+			uint64_t off = g_rv.recv_slots_offset + i * 4096;
+			if (off >= g_rv.device_span)
+				break;
+			g_rv.host_copy[off] ^= 0xFF;
+		}
+		RVLOG("fault injection: flipped %llu byte(s)",
+		      (unsigned long long)n);
+	}
+
+	const uint64_t *markers =
+		(const uint64_t *)(g_rv.host_copy + g_rv.markers_offset);
+	const uint8_t *slots = g_rv.host_copy + g_rv.recv_slots_offset;
+	const uint64_t chunk_bytes =
+		(uint64_t)g_rv.ops_per_chunk * g_rv.payload_size;
+	const uint64_t slots_per_qp =
+		(uint64_t)g_rv.ops_per_chunk * g_rv.chunks_per_qp;
+
+	uint64_t checked_bytes = 0, checked_chunks = 0, errors = 0;
+	uint64_t races = 0;
+	int first_error_recorded = 0;
+
+	for (uint32_t q = 0; q < g_rv.num_qps; q++) {
+		for (uint32_t c = 0; c < g_rv.chunks_per_qp; c++) {
+			uint64_t marker = markers[q * g_rv.chunks_per_qp + c];
+
+			/*
+			 * marker == 0 means the chunk never completed a cycle.
+			 * Skipping is not a pass: if no chunk completed, the
+			 * "checked_chunks == 0" test below fails the run.
+			 */
+			if (marker == 0)
+				continue;
+
+			uint8_t want = validation_cycle_to_pattern(marker - 1);
+			const uint8_t *base = slots +
+				(q * slots_per_qp + (uint64_t)c * g_rv.ops_per_chunk) *
+				g_rv.payload_size;
+
+			/*
+			 * First mismatch only, then classify -- the same
+			 * shape the host and CUDA backends use. Checking every
+			 * byte independently is wrong here: a run that stops
+			 * mid-cycle leaves the head of a chunk on the new
+			 * pattern and the tail on the previous one, which is
+			 * an overwrite race, not corruption. The shared
+			 * classifier's epoch guard is what tells them apart.
+			 */
+			uint64_t off = 0;
+			int mismatch = 0;
+			for (; off < chunk_bytes; off++) {
+				if (base[off] != want) {
+					mismatch = 1;
+					break;
+				}
+			}
+
+			if (mismatch) {
+				uint8_t fwd[4] = {0, 0, 0, 0};
+				int fwd_valid = (off + 4 < chunk_bytes);
+
+				if (fwd_valid)
+					memcpy(fwd, &base[off + 1], 4);
+
+				/*
+				 * retry_matched = 0: this is a snapshot taken
+				 * after the run, so there is no second read to
+				 * compare against and the STALE branch cannot
+				 * apply.
+				 */
+				enum validation_mismatch_type kind =
+					classify_validation_mismatch(off, chunk_bytes,
+								     g_rv.payload_size,
+								     want, base[off],
+								     0, fwd, fwd_valid);
+
+				if (kind == VALIDATION_MISMATCH_REAL) {
+					errors++;
+					if (!first_error_recorded) {
+						result->error_qp_id = q;
+						result->error_chunk_id = c;
+						/*
+						 * Chunk-relative, matching the
+						 * live kernel path and
+						 * cuda_kernels.cu. Reporting a
+						 * buffer-relative offset here
+						 * made the two ROCm paths
+						 * disagree about what this
+						 * field means.
+						 */
+						result->error_byte_offset = off;
+						result->error_expected = want;
+						result->error_actual = base[off];
+						first_error_recorded = 1;
+						RVLOG("real mismatch qp=%u chunk=%u off=%llu "
+						      "got=0x%02x want=0x%02x",
+						      q, c, (unsigned long long)off,
+						      base[off], want);
+					}
+				} else {
+					races++;
+					RVLOG("overwrite race qp=%u chunk=%u off=%llu",
+					      q, c, (unsigned long long)off);
+				}
+			}
+
+			checked_bytes += mismatch ? off : chunk_bytes;
+			checked_chunks++;
+		}
+	}
+
+	result->race_overwrites = races;
+	result->bytes_validated = checked_bytes;
+	result->chunks_validated = checked_chunks;
+	result->errors_found = errors;
+	result->passed = (errors == 0 && checked_chunks > 0) ? 1 : 0;
+
+	if (checked_chunks == 0)
+		fprintf(stderr, VALIDATION_LOG_PREFIX
+			" rocm: no chunk completed a cycle; nothing validated\n");
+
+	RVLOG("stop: chunks=%llu bytes=%llu errors=%llu passed=%d",
+	      (unsigned long long)checked_chunks,
+	      (unsigned long long)checked_bytes,
+	      (unsigned long long)errors, result->passed);
+	return 0;
+}
+
+void rocm_validation_destroy(struct memory_ctx *ctx)
+{
+	(void)ctx;
+	free(g_rv.host_copy);
+	memset(&g_rv, 0, sizeof(g_rv));
+}
+
+#ifdef HAVE_ROCM_KERNELS
+/*
+ * Join the live validator and translate its stats into perftest's result
+ * struct. The counter set is the CUDA plugin's, so the fields line up one
+ * for one with what the CUDA backend reports.
+ */
+static int rocm_validation_stop_persistent(struct data_validation_result *result)
+{
+	uint64_t chunks = 0, bytes = 0, errors = 0;
+	uint64_t scanned = 0, hit = 0, skipped = 0;
+	uint64_t races = 0, retries = 0, qfull = 0, stale = 0;
+	int rc;
+
+	rc = rocm_kernel_validation_stop();
+	g_rv.persist = NULL;
+	if (rc != VALIDATION_OK) {
+		fprintf(stderr, VALIDATION_LOG_PREFIX " rocm: stop failed: %s\n",
+			rocm_kernel_validation_strerror(rc));
+		rocm_kernel_validation_destroy();
+		return -1;
+	}
+
+	rocm_kernel_validation_get_stats(&chunks, &bytes, &errors, &scanned,
+					 &hit, &skipped, &races, &retries,
+					 &qfull, &stale);
+
+	result->chunks_validated = chunks;
+	result->bytes_validated = bytes;
+	result->errors_found = errors;
+	result->markers_scanned = scanned;
+	result->markers_hit = hit;
+	result->skipped_steps = skipped;
+	result->race_overwrites = races;
+	result->dma_stale_retries = retries;
+	result->queue_full_drops = qfull;
+	result->stale_work_skips = stale;
+	result->passed = (errors == 0 && chunks > 0) ? 1 : 0;
+
+	if (errors)
+		rocm_kernel_validation_get_error(&result->error_qp_id,
+						 &result->error_chunk_id,
+						 &result->error_byte_offset,
+						 &result->error_expected,
+						 &result->error_actual);
+
+	rocm_kernel_validation_destroy();
+
+	/*
+	 * A live validator that observed nothing has not passed and has not
+	 * failed -- it has produced no result, and reporting that as either
+	 * would be a lie. It happens when the kernel cannot see the markers
+	 * the NIC DMA'd into GPU memory while it was running, which is a
+	 * property of the platform rather than of the data.
+	 *
+	 * The staged compare reads the same markers from a host copy taken
+	 * after the run, so it does not depend on that visibility. Fall back
+	 * to it rather than returning an empty result, and say so: the run is
+	 * still validated, just not live.
+	 */
+	if (chunks == 0) {
+		fprintf(stderr, VALIDATION_LOG_PREFIX
+			" rocm: live validator saw no completed cycle; "
+			"falling back to host-staged compare\n");
+		return rocm_validation_stop_staged(result);
+	}
+
+	return 0;
+}
+
+#endif /* HAVE_ROCM_KERNELS */
+
+int rocm_validation_stop(struct memory_ctx *ctx,
+			 struct data_validation_result *result)
+{
+	(void)ctx;
+
+	if (!g_rv.initialized || !result)
+		return -1;
+
+	memset(result, 0, sizeof(*result));
+
+#ifdef HAVE_ROCM_KERNELS
+	if (g_rv.persist)
+		return rocm_validation_stop_persistent(result);
+#endif
+	/*
+	 * The live kernel did not start, or this build has none. Compare on the
+	 * host: the reference implementation, and the fallback for a device
+	 * that cannot run the kernel at all.
+	 */
+	printf(VALIDATION_LOG_PREFIX " rocm: host-staged validation\n");
+	return rocm_validation_stop_staged(result);
+}
diff --git a/src/rocm_validation.h b/src/rocm_validation.h
new file mode 100644
index 0000000..7730f54
--- /dev/null
+++ b/src/rocm_validation.h
@@ -0,0 +1,57 @@
+/* SPDX-License-Identifier: GPL-2.0 OR BSD-2-Clause */
+/*
+ * Copyright 2026 Advanced Micro Devices, Inc. All rights reserved.
+ *
+ * Data validation for ROCm device memory.
+ *
+ * Upstream perftest validates host memory (src/host_validation.c, SIMD
+ * polling threads) and CUDA memory (src/cuda_memory.c driving kernels from
+ * cuda_kernels.cu).  There is no ROCm equivalent, so --data_validation is
+ * refused for --use_rocm at parameter-parse time.
+ *
+ * This backend mirrors the CUDA one.  src/rocm_kernels.hip is a port of
+ * cuda_kernels.cu: a persistent kernel runs for the duration of the transfer,
+ * a monitor block scanning tail markers and validator blocks draining a
+ * lock-free queue, so each cycle is checked as it lands.  That is the default
+ * and reports the same counters the CUDA backend reports.
+ *
+ * Where it cannot run -- a build without hipcc, a device the kernel will not
+ * launch on, or PERFTEST_ROCM_VALIDATION=staged -- the fallback is a host
+ * compare: the whole validation region is copied device->host once, after the
+ * run, and every chunk's final contents are checked against the pattern its
+ * marker names.
+ *
+ * The fallback is a strictly weaker check.  It validates the final state of
+ * each chunk rather than every cycle, so bytes_validated is much lower than
+ * the live path reports for the same run, and transient corruption that a
+ * later cycle overwrites is not detected.  Both paths catch what matters most
+ * here -- address-translation and offset faults, where a transfer landing in
+ * the wrong place writes the wrong bytes everywhere and a bandwidth test
+ * cannot see it.
+ *
+ * Which path ran is printed at stop.  Do not compare bytes_validated across
+ * them.
+ */
+
+#ifndef ROCM_VALIDATION_H
+#define ROCM_VALIDATION_H
+
+#include "memory.h"
+#include "validation_common.h"
+
+#ifdef __cplusplus
+extern "C" {
+#endif
+
+int rocm_validation_init(struct memory_ctx *ctx,
+			 const struct validation_config *cfg);
+int rocm_validation_start(struct memory_ctx *ctx);
+int rocm_validation_stop(struct memory_ctx *ctx,
+			 struct data_validation_result *result);
+void rocm_validation_destroy(struct memory_ctx *ctx);
+
+#ifdef __cplusplus
+}
+#endif
+
+#endif /* ROCM_VALIDATION_H */
diff --git a/src/validation_common.h b/src/validation_common.h
index 8aabc4a..dd8a560 100755
--- a/src/validation_common.h
+++ b/src/validation_common.h
@@ -67,7 +67,9 @@ enum validation_mismatch_type {
  * Portable inline qualifier: works in both C (.c) and CUDA (.cu) files.
  */
 #ifndef VALIDATION_INLINE
-#ifdef __CUDACC__
+#if defined(__CUDACC__) || defined(__HIPCC__)
+/* hipcc compiles .hip like nvcc compiles .cu: the shared helpers below are
+ * called from device code on both, so both need the device annotation. */
 #define VALIDATION_INLINE __host__ __device__ static inline
 #else
 #define VALIDATION_INLINE static inline
@@ -307,6 +309,14 @@ classify_validation_mismatch(uint64_t error_offset,
  */
 struct validation_config {
 	void *buffer_base;
+	/*
+	 * Size of the whole validation buffer -- compute_validation_layout()'s
+	 * total_size. A backend that stages the buffer through host memory must
+	 * size that staging on this and not re-derive it: markers_offset is
+	 * mode-dependent and in READ mode points at atomic_returns, which sits
+	 * past recv_slots at the end of the layout.
+	 */
+	uint64_t buffer_size;
 	uint64_t markers_offset;
 	uint64_t recv_slots_offset;
 	uint64_t payload_size;
-- 
2.53.0


