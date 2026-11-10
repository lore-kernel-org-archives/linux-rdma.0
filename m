Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.196.57
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794322093;
	b=LNC6ibp26cVPLd9yVgHuhMuWXyxSmW85bA41zUVOfd/iyhvw7zvXWe7ONmurrWj0GFsF
	 4aEFQBxK1obgdy/hsyb6s2vfu+H77GnPrE8NKrTfU52Ed0Qdqvx5AJTiGD+MSZB8gkv+4
	 hdytbSyuK36te+3lyNUaSuF13vxMwBQIv4JCLexk0OtNPgIdVV6BgvOQdGgQXIAOTEMzh
	 8m+rSzoWHqdk38GBXSvwbnBK+ARqJ21lzgxe9X2vk1nNM2sw1ZqK16sOgCyo1wCxJUyEk
	 XwEMNeinfst2aNTPowdJ78duPcUG0mQhOVdZlQ/kFrOoK3b8B+0v7lEoQ0rGKynBh1w==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794322093;
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
	bh=/7vzJXD5HIpeT4vP0HtLxP8Iyru23UYdREZILPO9A0c=;
	b=p2Pu8Q3XocKXOR2/JGhRncHl1OlRVS4W8tChExOG1oGAYsbSSTaLsW7O0aHL+xQmZ3ix
	 msM1ff9bfdn+E1EjANL0pnxNyQDYUYv1F3hVQhs9+f95MDFBX9dLWzR5Za5sN7ju61dz1
	 tD2KAsN1dys4vbVxVRzaUjCaiMSWBN2doBlcIiGO0iu28+vKBNmc1vLsl/oEhzG2lg0Gc
	 4WaW3czhpTDRFoaH1gPdqIdVNcM81b8JN2ogvDHf5xJ6yZcZw24DVfhntRYfTjRWLNGyu
	 9T8Q5iOCa3AB+JIeF1cxF+pMk9KdnXEXo9MGsqeFlR2tNrO8aS7rO4vwnvpOD5KftyA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=AP2UDmRT;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.196.57
Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013057.outbound.protection.outlook.com [40.93.196.57])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1396E606A332;
	Tue, 10 Nov 2026 14:48:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1396E606A332
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=AP2UDmRT
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VKbgbF5IoclNA5bnLABJZdPOPpdS1RQMTBTANqKB6z5cR6tWalUvBIz5myYllWbUGoVJklu02dKyUnehmFSsczMUcGGv+0gIrwbf1hNJAy0WmWwgWiNF3QbxxrMh96fqPRZwL8HoeRpy3UnpZrCyXVequLYw3g/t/tLRHZaQx0qDQ9KwbQwW1axiPX2zie9BXT1f882deDGHSVM67dNrxVEIJm/dfuTz9duZ1wVDwBtBAyiEO33R037S++LTPByg0DvfOdejrXI1k8w0mWhV9KgLUzVGwbqE96f46N1U3NYqkx1irw5qawG09kHm0cqVu7UUeMS0lJDuSVrkEm3NUw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/7vzJXD5HIpeT4vP0HtLxP8Iyru23UYdREZILPO9A0c=;
 b=XFEDtSIaca/zFazLJV1COEp+IC/gjE68Biwxmmd9p20l9MgDj2RCCePC6bPiaDSBDY+xlEMH9gOx5zdXiacA8R8+xzncOvFIg4TD7Ge/YdefkSyg308FdUFA/x9bBJwWRiYVRufQyx/E6gFAxu60QNr3LH5APhbjWEMpilbc8Y/Yh3FZ8QNY0MwujhC1DkJzpCoQpU40eAoM+8Xoq7UQttm4Um7o95C2t9Ca2MbuMipnpvNI4ESurusAFPX47NNgV/t3/RO0A1yjepo2qAL1uY6PESzgCpiFO5+CeqozW2AzuC4U8oSoZ/Lu8xl9mgXx0wM+T3D4pEyoBQzTqgRlsA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/7vzJXD5HIpeT4vP0HtLxP8Iyru23UYdREZILPO9A0c=;
 b=AP2UDmRTt7E4CgOWS7VXGsbsOBB+v00NuY9zTfeZ2FWjh+xoUMZOE5ykKM9JkYLNGp7svkQid4MAoXLfZh4Oa4OSHsX9xhURCLQB1gStLhVbwgl8AO6+0L02oFTWZVEr7L80BfV057ghnLc93OrxKLJmviSxDlzU+x/jpzbzsml64y55L0hjT+mcw/oMOJFqkScUWH3piRRyF8SDJopwxQNBb7C63YKjG4zoKEBzwKGr6ahBRf+86kOmkRxU81uy7ZK9XUzUOSwFaY9ZV81gRSduluhPv6c3W4gvDlUpluQUt0gO0FPyZTUZuwZj1sKUi1jQsQQv1dYH6XI/P6TbAA==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from IA4PR12MB932075.namprd12.prod.outlook.com
 (2603:10b6:207:12d::15) by DM6PR12MB4090.namprd12.prod.outlook.com
 (2603:10b6:5:217::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.569.10; Tue, 10 Nov
 2026 14:48:06 +0000
Received: from IA4PR12MB932075.namprd12.prod.outlook.com
 ([fe80::5a6f:1f74:6ccb:cf2f]) by IA4PR12MB932075.namprd12.prod.outlook.com
 ([fe80::5a6f:1f74:6ccb:cf2f%5]) with mapi id 15.21.0615.007; Tue, 10 Nov 2026
 14:48:06 +0000
Message-ID: <8fe2397c-22e2-478a-9650-de71408e3a9f@nvidia.com>
Date: Tue, 10 Nov 2026 16:47:56 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC net-next 4/7] net/mlx5e: Drain old TX SQs before activating
 new channels
To: Rishikesh Jethwani <rjethwani@everpuredata.com>
Cc: Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
 <davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>,
 Jakub Kicinski <kuba@kernel.org>, John Fastabend <john.fastabend@gmail.com>,
 Kuniyuki Iwashima <kuniyu@google.com>, Neal Cardwell <ncardwell@google.com>,
 netdev@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
 Sabrina Dubroca <sd@queasysnail.net>, Willem de Bruijn <willemb@google.com>,
 Alexander Graf <graf@amazon.com>, Aviad Yehezkel <aviadye@mellanox.com>,
 Bobby Eshleman <bobbyeshleman@meta.com>, Boris Pismenny
 <borisp@mellanox.com>, Boris Pismenny <borisp@nvidia.com>,
 Carolina Jubran <cjubran@nvidia.com>, Costa Shulyupin
 <costa.shul@redhat.com>, Dragos Tatulea <dtatulea@nvidia.com>,
 Eran Ben Elisha <eranbe@mellanox.com>, Gal Pressman <gal@nvidia.com>,
 Ilya Lesokhin <ilyal@mellanox.com>, Jacob Keller <jacob.e.keller@intel.com>,
 Jonathan Corbet <corbet@lwn.net>, Leon Romanovsky <leon@kernel.org>,
 linux-doc@vger.kernel.org, open list <linux-kernel@vger.kernel.org>,
 linux-rdma@vger.kernel.org, Mark Bloch <mbloch@nvidia.com>,
 Martin Karsten <mkarsten@uwaterloo.ca>, Randy Dunlap
 <rdunlap@infradead.org>, Richard Cochran <richardcochran@gmail.com>,
 Saeed Mahameed <saeedm@mellanox.com>, Saeed Mahameed <saeedm@nvidia.com>,
 Shuah Khan <skhan@linuxfoundation.org>, Simon Horman <horms@kernel.org>,
 Stanislav Fomichev <sdf@fomichev.me>,
 Stanislav Fomichev <sdf.kernel@gmail.com>,
 Stefano Garzarella <sgarzare@redhat.com>, Tariq Toukan
 <tariqt@mellanox.com>, Wang Zhan <wang.zhan@smartx.com>,
 William Tu <witu@nvidia.com>
References: <20261109114734.2087878-1-tariqt@nvidia.com>
 <20261109114734.2087878-5-tariqt@nvidia.com>
 <CAKaoeS0AC-czE9g8OWi=+oenZYRsgXjRkSX-BsX2imHhKNW+QA@mail.gmail.com>
Content-Language: en-US
From: Tariq Toukan <tariqt@nvidia.com>
In-Reply-To: <CAKaoeS0AC-czE9g8OWi=+oenZYRsgXjRkSX-BsX2imHhKNW+QA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MI1PEPF000008D1.ITAP293.PROD.OUTLOOK.COM
 (2603:10a6:298:1::42f) To IA4PR12MB932075.namprd12.prod.outlook.com
 (2603:10b6:207:12d::15)
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
X-MS-TrafficTypeDiagnostic: IA4PR12MB932075:EE_|DM6PR12MB4090:EE_
X-MS-Office365-Filtering-Correlation-Id: 67adf4b0-fa4f-4dc4-4e8f-08df3f39a145
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|23010399003|1800799024|376014|366016|22082099003|18002099003|56012099006|261026140227099003|261028144727099003|10067099003|261022105027099003|11063799006|4143699003;
X-Microsoft-Antispam-Message-Info:
	ko05CjHV55+YaO/54x2zKwzpolvIH+cnFYv8LPxeTKvImI6g1nRvQXpHZHxb5j0NYQHO7791ArU0PhXW5KIBLoT+JIWIZCKeMHnobX7j9TFFxFWIt5MMOunjz64p/QwtbU9orlKchXM0VPR8V8pqGEO1/Ovk7Y82DBfzGCzV+LyDtPUIeRkPBLv7nVaYDe5XY8M9HSWIzJ7QMe4VXB+YxXHmTSQ/dS1wiLI6HHEPUyF1psOaU4gUdsps+s4UddFnb+kqDrrB/DNkUSEWFnsBf3GTo0ptoczhjT2p0aCe5MyGhRpLKMvbUahsgW029PYJ6UsSxuQzTY3K925NAaw3Co6j6iCmrOAMRd7SLj7Yoq8RYqICc3CA6iyCfgb/Ngb6X32O7nhqGQVIISVX0sk9HOm4+KgaYVkwtke4HO5BnpugXjj/0S45h3bahYfWdKsvgGwzkTjqYm+z5avzgMhjFrMSDcr0+/S2ID/6x2UPa5T0GtNPbYwdoe959LWlPgpXFunmjUXCbnISCfvpx37R2acNCVBp6COJLKIYY88h3a1vbuMpG8jSpkoaohLT8qWjd+tV2dtqdKsakGRr/sbO2idcYg9OhP1shDCUyGfqm06rOdarklBWN5C7hKPcXFNfQnKG3RCTpEaQL9rc4+j/Z9hJMdE9rUDnnUgkB33sUQo=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA4PR12MB932075.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(23010399003)(1800799024)(376014)(366016)(22082099003)(18002099003)(56012099006)(261026140227099003)(261028144727099003)(10067099003)(261022105027099003)(11063799006)(4143699003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?bUt1OTJSZ0JrZnFVTXFiSmZ2SzR1aVZnbzZHRXhpeUdENzA2bjRwNTQvN3Rx?=
 =?utf-8?B?R3dkRHExL3lpT3Q3cERIMEM3d0MwNTJwNG8xZlgzTHNvLzFFQzAxRjVwWDNX?=
 =?utf-8?B?UW1BT0treFZpZ2J1WHpXTnlrUkhjQUJnbUkzb1daVEpwWEhIWi8yaEZDU1Z1?=
 =?utf-8?B?dzhFWFpXc2ZiUW96UnV4bzZLYi9LbC90SU9yN2psRG15UmJDNkg5Y0ZBZWVO?=
 =?utf-8?B?MmlkMmd5djFneFZGdnpUVlUxNXlad1ZvanhZQU53UlRXemRWc3dEcWNHMlZB?=
 =?utf-8?B?TkNDNmluK0RFYXV6UDUzdk80SlZ2SHlyQWNiaEl4NUx2bFp5MkpIYzkwRXdU?=
 =?utf-8?B?NkNlTzVFVmsxN2hOR3NvSDdvYnIyemw0ZzlvQm9jRzdlQWJwVjUyTE14aE9u?=
 =?utf-8?B?cGpUUXFvUEMzUVpxclBFMlhHVHFMbStyUTRPbGF5NXk0SDFCb001dE91VVRJ?=
 =?utf-8?B?c0QvUFJ6L3k2K2ZvVVFNZFJ2UDNSOHk5bXRjdTdtTEh5RkxQMS9vY1FNam1p?=
 =?utf-8?B?SWFWVmtmdmlBZVJRdk1aQm91VVJpMEE1Z203blJIZnlqb0hPemprbWJSSTUw?=
 =?utf-8?B?WnFDRjdvR05mSDZKb0Q0aWc5WXVTYU1veXltTTViazZPYXVneDdEVWZKMHR2?=
 =?utf-8?B?V0N6cVhtMkkzQmR0UjNxQkNBdlgzTFp0cEVyQjN1TGR1bkNrMUFqN25tL2VP?=
 =?utf-8?B?SFdkMzd0N0ozZU1hVXd4L0VweExGMnEwU0Mwdi9COSt3SDlZdlkrRTZUQzJJ?=
 =?utf-8?B?YlVpbUxUVU50ODBJOUN1NE5yRW9XaDVtQ25QRm9Vck1BUjZMMjlRTDdzTHQ0?=
 =?utf-8?B?WFBPd3ozUVQ3Kytpai9FRFlDSWc0ZS95cGc0L1VrWXBzYkdIRURMaW56Snh2?=
 =?utf-8?B?MXFzWHRraFM5SFNLZjlrVFlPT0VTTzNMSHdhWVNod09VZVcyQ2NQRWZoU0JV?=
 =?utf-8?B?cGtDaVUweTRSUEErVmRUN2xzaDdUN25MajVEdE9yY2NyRzM5RU1GVk8zQlcv?=
 =?utf-8?B?UUhrQ1RJNUlFQU9uQWFScFVrSDZ3MjgvVnZLYkFsRngwQ3F1VGtSd0tocm9B?=
 =?utf-8?B?R2M3VGZWZlFMMnlvTllnRXNvMW5GNVJVWlBwamNiQzMxU0t1NEJIZ2dvU0Nn?=
 =?utf-8?B?R0pKbDVIbE9obEE0dWJSdXJnS1B1MmZISUtDS3puZ3lBWEsyRFFhaTNqM2Rh?=
 =?utf-8?B?aWRpL2djTzQrekE3RXFTZDNKOExOaFFuY201Mlg3NzlWdSs4Z2ZWUGN1Q2pP?=
 =?utf-8?B?NkNKVmUzYVowZU82VnRzL3JWb3hhTGcvOTNlb0Rsb1RHaGw0cnRuVUprVUlL?=
 =?utf-8?B?L1V4SndGTXh0Uzc1MkxTWlQ1b2ptbCsvT3hhaWl1cGY5WklHSGNHd2JUVzNo?=
 =?utf-8?B?dXBlZ2g2UmcrZkpZaVpFRFR5T2RjQ1JyTXM2UzN1K0puTDJjZS9ONnd0VXk5?=
 =?utf-8?B?UGZRR2RNbFQ0YU1oUW0yem8vc3BsdUViS1VmSUVnSFRYemszd3B0T2dzbVRV?=
 =?utf-8?B?dGFjNFBvQnM2eVVheG9DNWw1TGprT1Q0ZTB0cG5aYW5JbHc3ZmRIWFY5WnZU?=
 =?utf-8?B?RGRZOHVtTlpITFVzM3I1Y0FuZWNKYjhYbWFoUW1WOXhHeTZyK0IvaUFRUWFE?=
 =?utf-8?B?Mk1VRE0ybXZSM1pSWGtzZE9EL2U3QUtjZW05N2twaklCek03dy9ONmpTUEVw?=
 =?utf-8?B?SWhJQXVOOHc2K0FiVGY2Zkhqc3VZSlF1OWRGVTVKT3Q1Z3M0NjlkbUo3T1JX?=
 =?utf-8?B?L2N3L05maWs5cFh5RlYzaEJvdElxTUdYVHdsSnRid3VjMytYQlQ3WWpyZ25R?=
 =?utf-8?B?V1h5STJWS0d2MGU3UjZKSUVMVUtVdFZ6T3pZaHV0QXBLYWU4SUc2K0tpNEQw?=
 =?utf-8?B?MHpnVmFBbFhsWVVjVTh5c3Z4bDJzSVYyNSt0QnV0SE9CVEczUFV0UHhLeGw2?=
 =?utf-8?B?d215OVBYYkZzQVJzbnJjVTQrZHI0QWx6Mk54ektmVnNoRCtzZU9VWHh1NURW?=
 =?utf-8?B?Nmhwa1ZUcVdwbG41MjFUWWZxeGxpZmdEcU1JR0RUSTdhMHhkcXhKVWMvK1R1?=
 =?utf-8?B?bDE1UVRiT2FDVVZVdC9BalZUeC9rMkNZQm96MU5iYTB1eTlQTjllYjRZdG50?=
 =?utf-8?B?cWF4SUQvS0lWaU1Meis0M2ZZVE1Ha1RzekFPaXgwbHQ4UHEyN3crVC92ajRp?=
 =?utf-8?B?RkVTZlNCRGJ4Mmtkcmx4Q3FVNGdUOVpBR3B6N3BPR1BweGlPUTlCM0hvWGlO?=
 =?utf-8?B?aW1vaWhnNmtDTFYyYWRUVmpRNWtNTEE1RTV6dzgwa09Kbk11ZzgwYjBKVDBI?=
 =?utf-8?Q?wLI5z27yD/aJ01+MYn?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 67adf4b0-fa4f-4dc4-4e8f-08df3f39a145
X-MS-Exchange-CrossTenant-AuthSource: IA4PR12MB932075.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Nov 2026 14:48:06.2550
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2F2R1pYfv6A7mUaSKin+f8qIgMZQZ2JXl96AmxlzFEfEgWnSw+nptWAGHDoCmq8IB6/cyvH7319tHy5Egamk8Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4090


On 10/11/2026 0:19, Rishikesh Jethwani wrote:
 > The regular/QoS drain and the timeout ordering look right to me. The
 > PTP SQs can carry TLS data, though. Their indices are in
 > real_num_tx_queues and txq2sq, and egress skbedit can select them,
 > bypassing mlx5e_select_queue().

[...]

 > I'd prefer to include the PTP SQs in the drain/close ordering.

Agreed, v2 drains the PTP SQs with the others, so a timeout closes the
old PTP channel first too, along with the old channels.

Thanks,
Tariq
