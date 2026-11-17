Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.209.43
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794937777;
	b=qVf9tIj3IgmatfkH3TYCoY2oMVdVgEAmnIP5TZmU/Z+uzCvswdODQXy/W7ud4lFRiL66
	 Y1ZCyXn7eN8Yk+aYEIuYID/goQ9n99q3DppqA/AmgGoUIzT1OVNTm63EV2DIVrEmq16GG
	 vRR/KBQEbtyI/THv966Y01YlHt+j33lMpKQDPwQlyk/Ym1y5VCWwbxcO71+0yAa9jG5dm
	 LmS9WZmbUW+44uaeKGFi9y2wxypuwpaS2YQ3m32zd6OeLzSNqH8jzr891e+XwEXqkuKIP
	 eOVUVeORbYW8bD6DgbgMQD24cJC2MbTR92oIdaqQ/p6D/kqRhfGM6CnYyhZINCBjv/g==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794937777;
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
	bh=Km5G3FmV5yGoAhuMzZSYQAjeYrj4BvJb75OIyz44dUk=;
	b=qcuxYsdIPV604RAZBmLsuVeJiZT3dSE7xBaUHWJqLBD9V2Kuu4UMxDk/MVTcQzjAVKyT
	 BSSwzYhCtXVGPJJiSgwfntD25AFImogsHP3PJC3WSWE7asW4J3Cjwk68X7GXGzgvwdtnj
	 WyK14wY5UTZ8SMS9y24zaHqYmr+DPYeSa7Ar0pT1fgfHD8LK9rKaScDKfO/M6mvi5mFTJ
	 NsG8Oi79elQFs62lLgboBt2p3eFcy4tJwm5n+LfuU7Pg2lTCzOIfa3ulkT9sqM0s1OfB9
	 uexpWTG0UTCUcoglLbtTBQ3EJhyyP9fH7rTy4B5BYG7Kh2OaHJruWXbZ3vmu6Y9MJBA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=JXvrmsi1;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.209.43
Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11012043.outbound.protection.outlook.com [40.107.209.43])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42DC8606A332;
	Tue, 17 Nov 2026 17:49:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 42DC8606A332
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=JXvrmsi1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JwZbdruEKSQlg209OAAniI4VdSaZCUpLtIkkcjcxHYpVvU867MsQ16ks2UxDtIbtvqqGgeAj4DjShirfuhWDQXuyW4NPvFFmEvc6vMQURUtXLbDI+nD0F2ZSBko3ckwLMXGU6dcDLP6fG/aG13GdoDDgWezaMxhqqpoDH1BLZJr4Nc5UQ5qncLPEtGrh0H5waiyF4AHx51xbJmVnnO5VbAD3WDQ6HyBVq3MetAlBHjJhwiG5kN5vZODDrVaOc/9GAe88o4FpAqtJ02lYQMqI1Q679jfCtkJ/bGQLuZ3ySVd2QdDHRvXE9wBZNU5HZPUeFBYQ9LUtMS6HERozyzLRRA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Km5G3FmV5yGoAhuMzZSYQAjeYrj4BvJb75OIyz44dUk=;
 b=AKTf8t+Ap6ssrGTEADUwNkmDHE5Jx28sN7GDO1Trspi/YYIN1zFv+2L7rAHS6sGC5+LK0d09fChYkn/iz98MQN/18+FhA0WDeHzIfkBNCxGkw0ZBexE5P0lB0oooriDzHBsoROidCNbDg+J6i//O4JV+utQSh5AevrZ8QFW+uTFPeH6NApmLvNlAB/XqNrkrkftq0UahRlXY+tm+0pitVtAdDbwKD8fEWa++km+4AbYjomwzlleQZu6OL8qHpq2i+9IYhwUziox4cnLEEou+5Ky2VpYrqZE/8+sjAt7IcU5wWALbE0Ff8FU8RDCzQ5pPVphkKQ3UsB+tn+IB2msMOQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Km5G3FmV5yGoAhuMzZSYQAjeYrj4BvJb75OIyz44dUk=;
 b=JXvrmsi1XFs26mMHPmU9xWqIw+WTAmie1kD9FhO6r4oIsWIJxkitu1ymCH33D1cz48JOoNX5LX6rrwVbLkUcW1mn7O3Gc50VJlQ73N/0s9okZLGttgxP3JuHLbC0Rf7ur4t/NUfG3pcipZcKnd6fOaBMhJ+yzxRx5/mtLy7aEc8/28qXQrCxp+bvZwIt1v+0S/OMv8Mxajy9fQftIx/6DnCr0TLMGprV0/lDy+G1rp5G2ftD5O6qRZl+mrpQOJlKaN8yd1OlhtwR96cJfoXGVxs6am870dUddhGa9wL5ZKi7MSZRdpbYVM4ngvEYmL0YHko1JZwj/F3lzPzCTwkySQ==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MW4PR12MB6802.namprd12.prod.outlook.com (2603:10b6:303:20f::19)
 by SA3PR12MB8811.namprd12.prod.outlook.com (2603:10b6:806:312::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.14; Tue, 17 Nov
 2026 17:49:28 +0000
Received: from MW4PR12MB6802.namprd12.prod.outlook.com
 ([fe80::51f4:a3d9:b44e:9587]) by MW4PR12MB6802.namprd12.prod.outlook.com
 ([fe80::51f4:a3d9:b44e:9587%4]) with mapi id 15.21.0615.013; Tue, 17 Nov 2026
 17:49:28 +0000
Message-ID: <aa4a9b49-4f63-48e5-9c96-1cfef109d21d@nvidia.com>
Date: Tue, 17 Nov 2026 19:49:21 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next v4] net/mlx5e: advertise tcp-data-split support
To: Dimitri Daskalakis <dimitri.daskalakis1@gmail.com>,
 "David S. Miller" <davem@davemloft.net>
Cc: Saeed Mahameed <saeedm@nvidia.com>, Tariq Toukan <tariqt@nvidia.com>,
 Mark Bloch <mbloch@nvidia.com>, Leon Romanovsky <leon@kernel.org>,
 Andrew Lunn <andrew+netdev@lunn.ch>, Eric Dumazet <edumazet@kernel.org>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 Gal Pressman <gal@nvidia.com>, Cosmin Ratiu <cratiu@nvidia.com>,
 Dragos Tatulea <dtatulea@nvidia.com>, Carolina Jubran <cjubran@nvidia.com>,
 =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
 "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
 "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
References: <20261111170558.1654691-1-dimitri.daskalakis1@gmail.com>
 <baf3a990-c9a7-4bf1-a1a7-a2b8976591bc@nvidia.com>
 <cc814750-79f5-4eef-9c9b-e7bda86acc78@gmail.com>
Content-Language: en-US
From: Nimrod Oren <noren@nvidia.com>
In-Reply-To: <cc814750-79f5-4eef-9c9b-e7bda86acc78@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: TLZP290CA0003.ISRP290.PROD.OUTLOOK.COM
 (2603:1096:950:9::17) To MW4PR12MB6802.namprd12.prod.outlook.com
 (2603:10b6:303:20f::19)
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
X-MS-TrafficTypeDiagnostic: MW4PR12MB6802:EE_|SA3PR12MB8811:EE_
X-MS-Office365-Filtering-Correlation-Id: 09773567-a0a3-4068-e232-08df44d320a4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|23010399003|376014|7416014|366016|22082099003|18002099003|261009223027099003|3023799007|4143699003|11063799006|56012099006|261102123227099003|10067099003|261022105027099003|261026140227099003|261021121427099003|261021135927099003|261026121527099003|261028144727099003;
X-Microsoft-Antispam-Message-Info:
	WpGTMEjkrf6CkI0pnRTjRypV00+LflOPXRAZ+J+65xp3tQjqBv5ILGTINN8Q0GryiCt9Sz0YxDQuFLVLAk95q4DxTX7HsjKtJIDlA5enmAyAfTs3hXJZQB/oUmUI3yVqlGM0hqSEva4oz5ICagwx0I53nn2QmE3Slbl456ZfHpFPsBKMjrRX+9orclHb+7ov3WEIkNobedW8wfC8pFJHMyPUHSySe7E24iKyRuPBbj9rJ4FpVQv2cE2mnblxzfuf3I0a4kgusGv2BLsHqyQAJTb5TLmiW4u99i/lTydViKdFU6c4bugzOcNR0wN9/LB8g815/I9weG/s5tk4IIKqv/xqgdLLT235MeRI87sv5XYmnY72QG7G9/NyC67G8GH6o/q39vQWJ1vg1bM3gO2VtYSg/TDHwhszZk+bsnjDYrhU1RiBekQn5Xk1zBF3gzx/X6KgT8Qxhzi5toHg/JlV+X6MA84npl7EQPNRCB4MTBp1I5zMCdSquyJHzjIFi/XBKF1re9MaH8smMk1c4ICHD0qtrfFydWQ5UeUAxSwTPiOwXnQEsbmY6NdtA6rtjKYnYCZ5POEJoNv5KjmHuxOrRzH5KoYsAumoZFzeXJNFmO4OeVHVP0gOOfwsdjFpIsiKoR3xhaYKI92WpI2wv9oQXFG/+gXxOb38wRjcVlZJD+w=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR12MB6802.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(23010399003)(376014)(7416014)(366016)(22082099003)(18002099003)(261009223027099003)(3023799007)(4143699003)(11063799006)(56012099006)(261102123227099003)(10067099003)(261022105027099003)(261026140227099003)(261021121427099003)(261021135927099003)(261026121527099003)(261028144727099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?VXZ4NDdKOVhhMSt3V25WYzRuelhVemZHdDg5RHp3alZNb1hKd1hyd0RWL282?=
 =?utf-8?B?ZFZCSW56UTluNytWclNQd0JLZzhFR1E0Y00weUp4YS9ET3ZiSmhzRmxqaGVn?=
 =?utf-8?B?RXZ1ek1TZFdTYnovTUpZbndPQjJsaWFlYW5YTlo4cktNcXg4eXVhWklNUkMr?=
 =?utf-8?B?NG1EM0xNdDZaY0M3TVRZK2ozVFZVMlV4c2xna3BDT09zdUZ6TjJ0NzUxQnpE?=
 =?utf-8?B?L0QrQXlLWkhGaTFhNDFrN3JlVmdCMTZ4d0NwMmlnaXBpZ1VGeEZ5ZEkraUph?=
 =?utf-8?B?U3ppR21WeVZWNkc2UzY5V2lNTlBoYVdiWUM1Q2tSV0grWnYxT00xSm50TlBG?=
 =?utf-8?B?c25kRGZpck1VNFh0Y0kycHN4UTVqNGJ5dG5OT2ZMMWJqRXRUZGg0Mmp4NU1x?=
 =?utf-8?B?SlhrdTNmelNuSWtzRjRwQkUreUxQdXlqMXhCOEsvTElJd2s1WGVqMkNTRW9K?=
 =?utf-8?B?WjhtVDdhRGZrNGhUY2VUbWx2allyN3lBdlVHTlBQczY4SDhPYkhXMDVPU29s?=
 =?utf-8?B?RmJwdGpkak5NcHlzVmNJZiszNjJUVjNoUmQ5YUU1ZVpaSC81ZXFWZk9tQm9w?=
 =?utf-8?B?MERQQmI5TjEvcWdiT0FSQmY3cmgwSUcrRjVFZmUvVUNaVFY1aU12YmV4eDkv?=
 =?utf-8?B?WWl1dk1nVG9oTHovVnlaZ3lOempaT2NtSGFTMk9vUlBFcHJtcit6eTYvSjRn?=
 =?utf-8?B?U1RiNFJKRVN2RUJnQ21NdmlEN2N6eGFDWUtBYTlzMmVvc3FBSStaSzl1R2FS?=
 =?utf-8?B?cTIxbWcweHNncVBGWlAzM0Q0MGlobTh5d1VCek13d3VQV293dUpRRFhLWHkv?=
 =?utf-8?B?Ry9uYkkvMDRPQTZnWXJzbDVzS2xWT0NCeURwY3hRdEt5eGdsZUdDbzhQQ1Nn?=
 =?utf-8?B?SEo4OVBXUHpBVnhxTEF6Q1F5RTE5MVRScHQ4OUl0djZRRlUvM0NHdTU2bUhQ?=
 =?utf-8?B?ZFZWVDk2M1ZseTF2MXh1MjBqcjViQVlvOVpCVXNKVkRCbG1XUUhhNWpPSEtD?=
 =?utf-8?B?VU5wbzIxbU4ybkh5VThKSWdSMkxYRnFjMklwendIVjRVcW5qT3Nad0NiS25E?=
 =?utf-8?B?QUpwZmplaWNQeEVvY01RMEgxalROS2poR0NRVDdYMWcxYXIvcXZrUzg3bTFY?=
 =?utf-8?B?U0FubWlIWmxweDJwNXBzTFBNY1JtMDRIdDFXZHB0T3dtaTArMHJzWXB6TkdJ?=
 =?utf-8?B?SEZwcUFoZXMxKy9TWnBmOFdyREcrRlplN1cvNkRBbFBGTFpuRDVJclJBYkhn?=
 =?utf-8?B?dkVxM3BhR3Z4eUcxS21GSmNLa0FuMFBna0Z2QU1ncmJHL2xvVXV3K3lJU3gy?=
 =?utf-8?B?VEhIZW4yclNTYmY1NkdjSGJQbHRyOEk2ejZ0ditFQzEwYmR3NlNIM3Y3QlJr?=
 =?utf-8?B?MDJUL1M3SS9WczEybEdlNTF0RWdqYXZGZE5HQU1tMFJ0NUtaYXhXL0I2NUM4?=
 =?utf-8?B?K1poZ09Wb0g5cUNwb1htbVBZSEMxU1dsbkRMRy9GTDIzWGhCQ2owT2w5cW4x?=
 =?utf-8?B?NVlicHR3SUk1U05uTWpGTjR1UUFSNGF6NWNLY2V4bk15eHoxOVd2aFFJNlB6?=
 =?utf-8?B?VWJ0clVnSnFVbWd1QjNpTmwrWkRyOTAycHloSUxaeThjaW5MZ0NCRll4K0Fh?=
 =?utf-8?B?L0NoZEN3by9CZW1qaUN5d3hUVlNieDRBRTFrTWROVVlRZTNqcDBzYldDaGV3?=
 =?utf-8?B?eTJsek00Z2VXZ3Y5blVvTUJtZjVCS2t2NUF4TElJL2w4b0NjbU8yM3hBMHZJ?=
 =?utf-8?B?K3JEZjkyOFFHM2tQMEFPdCtzZ0EyZmV5SU5IQW1FcXpCQTE1d3dxUm9WNW1j?=
 =?utf-8?B?RnpZNEcyQlh4akUrREIrL3VsK0FCSnVLNUR4WmtTazNOS0MzbTJMa1NDZmpa?=
 =?utf-8?B?bENjK1NOa0orK3lmOGd2a1VuUzdwRmhRblZ2Y2lwWXAyVXN3YlRPcmtleW1J?=
 =?utf-8?B?QmQvMU5CSnNodjRXNHZVaWlQaFNMUG1od2MrVzhKcm5wbExnSndFTE5uckwz?=
 =?utf-8?B?VThUZXdTVmZRRjBDTXhHQkgvbGI0Q2Q2SUt5TTlaV1hBeTRKc1RTNjliTENW?=
 =?utf-8?B?RWJNVmR4Q0xvdlJOZnlSWE05eE5Kc1BIKzZIVElHV0twOFBud244VUIvYU95?=
 =?utf-8?B?QTVsUmdubXJqS1FnVUN4T1JNRjJqcnMycGN4OUVWdTVRNGswKzhqQlhFUUkv?=
 =?utf-8?B?eWZIWG1xSlk2ZWdPKzVYYkNnTkI0NElaeTNhd3R1NWVKUDlqSmg3S1AzMVNB?=
 =?utf-8?B?YWtmYk00TURGK1NYYnhtY3cwc0FGOGtJZlZESzdoWHpvMWNoNUhJMnhNaGFI?=
 =?utf-8?Q?cQbo+o+UG7O4cdaIT+?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 09773567-a0a3-4068-e232-08df44d320a4
X-MS-Exchange-CrossTenant-AuthSource: MW4PR12MB6802.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Nov 2026 17:49:28.8361
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qyB4bCgaE911dlGz6fJ/SCGfZ4QxGwR1OX7VpzCMBELi0h6tkHnzTWHafGn3ZgEapGSPnvyJ2IEPwk7WMGX/Zg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR12MB8811

On 15/11/2026 22:59, Dimitri Daskalakis wrote:
> On 11/15/26 2:39 AM, Nimrod Oren wrote:
>> On 11/11/2026 19:05, Dimitri Daskalakis wrote:
>>> Changes in v4:
>>> - Nimrod and sashiko pointed out that not reporting DISABLED for
>>>   tcp-data-split makes the feature look unsupported. This conflicted
>>>   with my attempt to block users from setting DISABLED, locally sashiko
>>>   found several scenarios where ring changes would get blocked.
>>
>> Can you please share those scenarios?
>>
>> I think blocking 'disabled' was the right direction. Allowing it doesn't
>> give users anything new, only a way to pin HW-GRO off, at the cost of
>> another dependency between the two knobs in mlx5e_fix_features().
>>
>> We can still report 'disabled' when HW-GRO is supported but off.
> 
> I should have saved the review, I reapplied v3 and added an else to 
> disable tcp-data-split if the merge type is not SHAMPO, here's what sashiko
> reports.
> 
>  [Medium]
>  Does this reject a value that get_ringparam reports?
> 
>  When HW-GRO is off, mlx5e_ethtool_get_ringparam() reports DISABLED. That
>  is accurate, because SHAMPO is not in use. Before this patch,
>  "ethtool -G eth0 tcp-data-split off" was accepted in that state. Now it
>  fails with -EINVAL whatever the HW-GRO state is.
> 
>  This affects any netlink client that reads the rings config and writes
>  the same attributes back. The whole request fails, including any ring
>  size change sent with it. The changelog does not mention that existing
>  users of "off" will break.
> 
>  A narrower fix may be possible. mlx5e_fix_features() could clear
>  NETIF_F_GRO_HW when hds_config is DISABLED, like it already handles
>  ENABLED. That would also fix the mis-reporting and keep DISABLED usable.
> 
> Netlink users that call get then set with the received parameters will
> get a failure. This generally applies to users who save the current ring state,
> and try to revert back (via netlink or ethtool). A subsequent sashiko run
> highlighted the manual use case via ethtool.
> 
> I recall sashiko had more severe feedback, but those cases may have been
> from the incorrect feature updates I fixed here [1]. The feedback is technically
> correct, though I'm not sure how much it matters in practice. v4 implements the
> narrower fix sashiko suggests, so it works for users who write back stored ring state.
> 
> [1] https://patchwork.kernel.org/project/netdevbpf/patch/20261017005401.1582755-1-dimitri.daskalakis1@gmail.com/

Thanks,

I'm not sure the write-back scenario is worth worrying about. The
drivers/net selftests for example always restore to 'auto' first rather
than a saved value, which seems like the safest way to reset this knob.

Still, there may be some merit to the point that blocking 'disabled'
would break setting it while HW-GRO is off, which works today, even if
it's not a very useful flow.

IMO both approaches are acceptable: v4 as is, or blocking 'disabled' as
in v3 plus reporting it when HW-GRO is supported but off. You can keep
my tag if you go with the latter.

Reviewed-by: Nimrod Oren <noren@nvidia.com>

