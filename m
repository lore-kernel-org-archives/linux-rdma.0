Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11010010.outbound.protection.outlook.com [52.101.56.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27B0949158C;
	Wed,  7 Oct 2026 12:28:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.56.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791376130; cv=fail; b=nNk5fpIlA5K7GjQxIm+WTKKSbjtC++pY0L/G4AmOxJId8eZI/OF0hL58FfTxI00k7oJM3yvimxNNNuTNdjFL+MJ3Fk/3kWn5VhyDPzbSgAajQpJmKHFvs2zPfZ8W3L3k4OlAt+ixtyafmXUwi2l/1aSP6G5HkI2JVNmeJ8xkg1E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791376130; c=relaxed/simple;
	bh=dxHO6BJpT2CCrR5UnHDL06muFJE8yhOcN9xPPkf5eCk=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=YWWGEI7HswwunimZw5Igku7NykVinyzY6FBLdmg+0RQBSvURMIPkOMfJC5xb4MiA+MxVvmmtPCTbsSbUiQaRVVbamGDKGoQ4vv6vAlNyIsvQF/E9u1Rndrbv7EUaNosYAQAeSyg95nH0vS9y9tL+LaX0GmKI4WuABRW3R2J/Ye8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=ankEm3EJ; arc=fail smtp.client-ip=52.101.56.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="ankEm3EJ"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WK3bu0sOXaslZuknzhG4sZrdEHMLzwdfVKVv2aG5So8qox+IvOeogN/o5k+YjFf2TapTe/KuUJIh5S+QnTdwAKDJEaL7/3/ZaJViNEK7mjjLPNpgqaRUVRB0xOVzvpA1PIHTmDLXpi4nuWkkG9I4Ts6+X5sWv0l7HgBqeJKow1UOWrOGW5WE2Bf7CXvhQ2OD9EkroakGh2eKa2KqVH587hXynz7sBBtq3LXrxX3pmkbnWKAXn/xQxRX20WpkM8+a1z6avBvfKGvcqM53FR4fsZS5q91VpWXoIoFS6FBK5hdC78dcivMkPCrIPzLTgsaOAcd6aTUc4Pq0ga7RZ+8a5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=w40A4VKZaVONL9nN8kTnCSxbyJhtCFzUgjwQXbvJa5g=;
 b=P5ZQZzPNvi/9reH/Zm5BcX7w008VvgW7O7d0K7h1RjyJIBFzFOapxpU6jcaEfSLniLZF1ahcJxLTfGZ1/FCL0Tg+JtrAh6DyU0uMBk7QjvkwTpN3amPYcyOCEB1nP1Bcy1YWEnM6wftfceJKsCxBQHjc6KXQGR/nD/ymUjNksjWGESHaO4vRschO3TEU3+PEaH5Xhz8Y2vzfFVTAtQ1Bo0qGFzXhr5tdaBqPldX5vlSQZRxQPV1gviuY+dwQiJp0RS0fnbKvz1KyxGsLuxCvfg3NQ2swRrFj4n6+sXGFqTeNOLFQk0eM9dBJBBMCJ4MI8OT3Je4Rz6zbqSLynliBmQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=w40A4VKZaVONL9nN8kTnCSxbyJhtCFzUgjwQXbvJa5g=;
 b=ankEm3EJa9CExW/Qg7rntcfcyzD7+4KP3Tck9EUL+iXNubPkRAvxqP1Wz3KJIvERfSq/e6YWZzyvKGqtaEyLzhTaB4bO9Ul49B4vR4yvIWHF/t/IcCZ8xU/13OdM73ywsPgB8YdSU3uNPuq2lPGWQgkqrk8F9ASOogiGitZxfp5TphLEF/mIXpLoPekaOKOY1VRnhy3Gg5Pa5PSK22wagAkGTP5I1cugHOd+llYMFJy9pS2Re6+tjFuhT9ys53JA7aMD7NkXeIsDJHQle+1Z/9L1fa6BqfAsLEc6moSx4gsGQx+wUyyutj+0YvdqHCpGHPMNwVdrE36uwvJC9saouw==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SA3PR12MB239779.namprd12.prod.outlook.com
 (2603:10b6:806:5a5::7) by SJ2PR12MB9190.namprd12.prod.outlook.com
 (2603:10b6:a03:554::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.496.16; Wed, 7 Oct
 2026 12:28:32 +0000
Received: from SA3PR12MB239779.namprd12.prod.outlook.com
 ([fe80::2ac4:299a:52e3:5d9c]) by SA3PR12MB239779.namprd12.prod.outlook.com
 ([fe80::2ac4:299a:52e3:5d9c%6]) with mapi id 15.21.0496.015; Wed, 7 Oct 2026
 12:28:32 +0000
Message-ID: <f47082d2-dc2b-450d-844f-7c6bda66c051@nvidia.com>
Date: Wed, 7 Oct 2026 15:28:25 +0300
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net V2] net/mlx5: Lag, reset vport speed on MPESW teardown
To: netdev-bot+sinfo@kernel.org, Tariq Toukan <tariqt@nvidia.com>
Cc: Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
 <davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>,
 Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
 Paolo Abeni <pabeni@redhat.com>, Edward Srouji <edwards@nvidia.com>,
 Gal Pressman <gal@nvidia.com>, Kees Cook <kees@kernel.org>,
 Leon Romanovsky <leon@kernel.org>, open list <linux-kernel@vger.kernel.org>,
 linux-rdma@vger.kernel.org, Maher Sanalla <msanalla@nvidia.com>,
 Mark Bloch <mbloch@nvidia.com>, Moshe Shemesh <moshe@nvidia.com>,
 Saeed Mahameed <saeedm@nvidia.com>, Shay Drori <shayd@nvidia.com>
References: <20261006112415.259157-1-tariqt@nvidia.com>
 <179128616987.2231598.8807408813571443447@kernel.org>
Content-Language: en-US
From: Or Har-Toov <ohartoov@nvidia.com>
In-Reply-To: <179128616987.2231598.8807408813571443447@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR4P281CA0339.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:ea::13) To SA3PR12MB239779.namprd12.prod.outlook.com
 (2603:10b6:806:5a5::7)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA3PR12MB239779:EE_|SJ2PR12MB9190:EE_
X-MS-Office365-Filtering-Correlation-Id: f11c1e01-1d57-473f-bcb4-08df246e7fc8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|7416014|23010399003|18002099003|22082099003|11063799006|4143699003|6133799003|10067099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	qh6CyK5evMGT/asLFFnHxVLsVYw+6kxitVRjGUgIdAPM1Vmvraygl7OBg/FmJCqo00Xb6IrNHnJCsebb6jdVAy1KpsM6P1xgEF9xgYxwYynPst4NPhuO7hxUUO+7M4fxputJ4Szrdy/rd/niGJbwr4ni6ciEe+1FQ68f5jWJv5dzSImebt/liTTVyCboX7KuKOvhjGkNUlhgml1eJN/v+4V26G13a8nPJVLRXjHWYjU9xKJEzWZ7bOmHHkzY2SRdnBPOtyugm0VaVsErmd/SGov6+ulICumTZddB2xfdhnKC+py5D7quDrZhg6cIQoQ/nsIFH4q6CwSpQ7n1Ujb0pLH6kUxE2KCX8C1bnWolH0mEUIzQiIWVuMWy9IKbFaRfDoYrhQF9K1wJV4ujrkNXJPj1VtjhpoeiV6qt3Wa75XQAP/EbWtDBkFDsDUJXNETKE5qzUcKz3gxuPTyuphTdI7eqxylSez6dry7+HqQkzSDYxHTBBAS6S7icbGC+agO5cMe07eLn8XIZDGsiXMhJaYdmCDys+G4XOA2seWe7r9gPXiETFT1Rpb4H+iJZRiN6KCoApo+MBPZdZL1t/adayizTTyMAhawHPXU6XBHbXbOu7EufhT5qybate7iuHnMmIFyXWZNL8435/auUrMvT/gDmwohZwiAwp57usy3wD2k=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA3PR12MB239779.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(23010399003)(18002099003)(22082099003)(11063799006)(4143699003)(6133799003)(10067099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?RTBLK2l0dDFvazdlUVhXSzJsSUpkTVFGT3ozMlpReHpqbmVJNjlrQnRSRGlk?=
 =?utf-8?B?c1pjRUNsdlZqNnJ0RlorOHZJNUNHZFdnc2EwT0VoSjRSTXB5d0ZqODBRVW5K?=
 =?utf-8?B?dmh4VEl6U0IrcDZGTW4vNjJPeVV0N3pvVlI1OHhWdmdSb2VTKzZrdG15MTFy?=
 =?utf-8?B?SUVHZWpsa0F5aEtPWVVLb0dDU0NVRlJROU1QU2xBeXJoenJHUndIVVRhYTZ5?=
 =?utf-8?B?VDRLSlNYTXZ4dTJzOCtqbGNvNGxLdjUxRmN1MndaZ1I0MXQxa1lNSXBmUFlM?=
 =?utf-8?B?UWVRNno1R3k1Sis3Y0NZMlNzM0NHdGxtL3lPTFZwNnQ5bXBVNUVYVGdIa1JN?=
 =?utf-8?B?cDI2NHU2bW9zdXM3RkhtQjBHRk5RbFJhWGVGL2NyV1Y1a3NKaS9EaStQNWUv?=
 =?utf-8?B?TzVZWkovUEUwajRiWWQ2MFR1aHcxK08zNTJ2Z0pxbmhGQjRlbnFaMFZsVVg4?=
 =?utf-8?B?VjhIMFpzS1NQNmR1cnJCdHhpMHRsdytJMlpwSy9Rb3QrajNkY01SRDZUejZz?=
 =?utf-8?B?UWliMm9jeU5EWGIwcG1sT1FmdTRaRWRranVSWTM4UW5QN2g0eElnMCtxdCtM?=
 =?utf-8?B?OXM0QW5QeVc1blAxb0gyZWhHL05zQ3QvVURnWVBVRkNBTGpDQi81RU9kNnZ2?=
 =?utf-8?B?b3RyRmNCWCtkZ2tnZjJqK3AwTzg1bXJuUWs5WGI0WDByWklVWWZ5ZzFZY2lF?=
 =?utf-8?B?RGcvWmV1Q3htQk5GZnRKSXI0MVdDVXZSdkNUbEFiL2E4a2EzcklFK0hDTG1I?=
 =?utf-8?B?YXZ0bEZJTWxYNVFqL1h5Qmh6NW5HNDUrdENqVUZVSmptV2dZR2ZxdW1RU0lY?=
 =?utf-8?B?K0lUUHNtcVVOaG1DOFNXczQwRkJaZ29Kd3hRbU1pb05SWStkUVhqR1ZGWitP?=
 =?utf-8?B?SEk4RVBFdnJuNnpGRk44aldJYnp1MkFCZURRekpWVVA1NzRRMGdLdnZ0TW41?=
 =?utf-8?B?U1hEK0JoY0RYMFZTMHdFc2tyWmoyYU54aFRUU0V0WG4xalBvVWVtc1JjWFpv?=
 =?utf-8?B?TVcyeE5YMVY3STg2eTI1WlUrZ0k2bW9vUzllY3dia2lsREpqOGlDZXNlZVR3?=
 =?utf-8?B?WmJxWHZtTVdYMDdNVVdpa1d4dkRZZjhMSCs4QmFheE9zYVF5Yk5PTE0wMStu?=
 =?utf-8?B?TEY3aWlZZVhYOFpteXY5ekpKTjhNVXdrZTJnSlNSSjFMbTRnYkdKWjE0UmZD?=
 =?utf-8?B?MUtsUnRWd3R6NjNBNUdMMjdKcHphQTZ4WENWdzdaTzlneTlFbmJZQkJDWWs0?=
 =?utf-8?B?U3NpK3F1QzYvcjR1NXRpbzE1ZjB3S3ZvSTE5WW5ncGd3WWkrekxNVEN3UTJ2?=
 =?utf-8?B?Y2JxSjBVWTFmd0pCcm85bFhrWlZRcGtsMzQvbGFGdTd1U2d5UytKYzVQR2ly?=
 =?utf-8?B?N0UyWDFhOURGaXpFb2ZXamJrc0g0TjdscTk3UEZQeEN4L1M0YTlFalVvWnYx?=
 =?utf-8?B?d1QrNDNwZWlSaFlLQW8rTWw4TFRGR1lWWjVwY2Y5N0pURVRRcTRieTgvQncz?=
 =?utf-8?B?TUIyZ1BRazhycG0yTVFZQjdDZVRaNGNwaC9pU2Z0ZGdlY1g2dE1zVFljeVFT?=
 =?utf-8?B?WlJuY1RpM0RaSG1hTExDVWU3dnlqd3B3YUw0SFYvdXpBK3NQeWUvVEN0eTJN?=
 =?utf-8?B?cjNUaitWbmRzVTg2Z1VHTER1MVJLb3FpZGZuN0h6VUpJdWhickZXRE9LQzQr?=
 =?utf-8?B?ZFpoUUFYdGxXLzZxT1JZWFFXdDhISnROWXZybk5jY0R0bGlMRzVLT0cwUXpv?=
 =?utf-8?B?bXNpaEtMZEh6QktvS1JjSFVoTytUWlpXWlFtY2ZHWkc3ZzFGRGJzUzVNWFU5?=
 =?utf-8?B?SitRLzhIMW9jelJEUnREcW1vSVB2ekphUHc1UEtlYlRuZkVwcHNteFNQQnBI?=
 =?utf-8?B?MUhRUG9SWXhtOHJiVU9QUkdkWndZRHFQZ0Nzb3YvMnlqT0d2SUt5UWcxOStX?=
 =?utf-8?B?ejcyQzNENGRRNm5JMjZ1cWx1MXRZZVBMbGhMOGxCeHpLM3VMKyt2cnc5eGtB?=
 =?utf-8?B?cnNjYm9lb294RE1VdlZib21lVkkvWS9RMUNLUVdrMi9RS255YnpZbWc5dHFx?=
 =?utf-8?B?bkxtVkR0RDhFemo5ak5pd0o2bkNCSXlmMndNczBZVm5mUUtPdVV0dlRHOWZ3?=
 =?utf-8?B?ckNDRVZvbngxbzVvT3E0WEdqbXMrNnE5WVBuRzcwVHZyNDlBTk5Gb1J6ZU1l?=
 =?utf-8?B?R2JXa2VDdXIzRXhRS0l3QUF1MWt3YVAybWMyZFgyYnErNHhzRWVqa1crY01T?=
 =?utf-8?B?dXZJY0Z2cHdMZWs1bzRTdjhCN2c2V1B2MmxEWHRKYVp1Q3BJcGRCRVI3YnBM?=
 =?utf-8?B?bG44eHlicFdoL2dRSlZRVmdaTFVMR1ZpVHZHWE5HemVqN0lBVTkxdz09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f11c1e01-1d57-473f-bcb4-08df246e7fc8
X-MS-Exchange-CrossTenant-AuthSource: SA3PR12MB239779.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Oct 2026 12:28:32.0922
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AUkHPo5+BqsR8HXX18lyORDW30wXWuWbJ4EfWeF0VzCxOaabqqq8EeFBgpcvwFgfKb09uDZ3/guFKBhXyGP6uw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB9190



On 06/10/2026 14:29, netdev-bot+sinfo@kernel.org wrote:
> External email: Use caution opening links or attachments
> 
> 
> Hi!
> 
> This is an automated message. This series looks like a fix, but its
> commit messages seem to be missing some information:
> 
>   - How the issue was discovered, e.g. hit in production, hit during
>     development, syzbot report, manual code inspection, LLM or static
>     analysis tool scan.
> 
>   - Whether the issue was actually triggered, or is only theoretical
>     (e.g. found by code inspection). If it was triggered please include
>     the symptoms, like the stack trace or error messages.
> 
> Please do not repost the series just to address the above. Instead,
> reply to this email with the missing information, so that reviewers
> can take it into account. If the series needs another revision for
> other reasons, please include the information in the commit messages
> then.
> 
> The evaluation is done by an LLM so it may be wrong, if you think
> that is the case please reply and explain.

it was found by code inspection but it is not only theoretical. I 
reproduced it on CX8 by enabling MPESW, tearing it down and see that 
query_vport_state on the VF still returns the aggrgated speed.
