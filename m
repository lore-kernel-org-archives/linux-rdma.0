Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.193.15
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795630691;
	b=3D1oQiy61R1ngua1fzf5b9KvGZzNiuj9e97+OzvriFnZEwtL5g5S7Hbu4zufFCkQiQop
	 3D+gu6z+jrttmon9wDQpdM0jPRVwc/Ob687Io04ktjWQTExpketfBWpcUpro4iUkLIWJv
	 zsab0avQRto64VPMcL1uShO9Qd8uyCCCDPcpGjFm9ChlLbkkAp9togoBm1IH9TnvKiBQy
	 lTV38JtB0piCtkW1njD6zNcdgihKIUo80x2hVRf//PslYjdxnK8q4HYoSo8m7NwIqKsIc
	 qDaWA+VSg9qJGNjP3DXCY+zPJXfvpwZ649Gy0KtNwDJpkWj+z8b8hRBai00nTTmIkNg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795630691;
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
	bh=fVZN/fdJ6gAxdrH6s93CyLZ1X49Wg0BRNkGXljCGlbc=;
	b=OmNfjdFaXTek6SvUETCocDRoba78THsu54GK8+VNpBkcOSx9d+mQ92BkvFBSKh37gyVr
	 wVOQkZ1qJGYBdBSaDa6DLX6+LHUOzt7e3nqSzmGBpcG1zVbwOO6tWZqyRy2Vsw2GIF1ka
	 0HXD8Vy+lPz03gEGDVJmC/1Wc3+6KIXbS65MY5V+xtN3dYoOiMFycAlan8NTXG6l1cooD
	 PJO9l+eNmhwK/umuzAk8qWNOZRiP5bkDgYoBgO+m3CwtX7yQBOABIzMsW74YFNWlscp++
	 hr2jlhAiAkMUu2DUnURrKYeKcYaewnJLDqmnlFMSiV2YzUG2r3XzWLnhq8FzGsRazXQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=amd.com;
	spf=fail smtp.mailfrom=amd.com;
	dkim=pass header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=gDzgqeMf;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.193.15
Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazon11010015.outbound.protection.outlook.com [52.101.193.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06B51606A327;
	Wed, 25 Nov 2026 18:18:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 06B51606A327
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=gDzgqeMf
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hVk4CyMeRsQNU0aopVQKwDICODcQx0rdiw2Zq/6LJmDL+NXvTBv9zq395HTWNo4LIp4l2DHNpFV5jZ3lERRYObECUhp8rkq2vaSrtuhlSvbaA7fY558uXp7Iz4Ek8JaIm7NtOqJFRkV15LHAFuXkAiym6pZxp1elT5ksc0nfsRvXhfvndCIcLURgYlhm93RubwJ8drZiG5+rxteOdTjUIHvbLYdJFVuaPLWU7D7jO6Uo+UkWjtV/p/X3Ws36srKTc46EmWleFYsl9p3wFAmLOVhxa8DqQph8fAQSd2FChw4rD2azm7H0h6sOZWxOc5ayFKsWcWoO5CkHFWeAtBWgGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fVZN/fdJ6gAxdrH6s93CyLZ1X49Wg0BRNkGXljCGlbc=;
 b=xFVxjq87z8xot6B93yD2a4rw3h05RkEiLqp25f3efN2S25MUQsUwZiu7NPTPiJ2/wN6NMlNR8QOJWbYZksQ0x2pj5Y287kKDEwKaxQ/DRKm8PfsuAMO+xmqemOf6LkCBltDy0d5JiNEqBFh/j8WuOmpVRGD84ZsvA+n/GaEN3iAQSzseXH0MeIUmt0nkEtoiKGLMffNsYbJC7Yk3PoRhlAK6xRo9+Nm6x174iatexqIlwnAgT9kJyDcPOFSXfCsmqn4XmhEQoIwrVKjir+Fsrdi25m6+3cB3sXl7OUzgKb14PJP+kUYYg2+ACfgX5U6FEZlEM3fsWzm9TAf3yHFYUw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fVZN/fdJ6gAxdrH6s93CyLZ1X49Wg0BRNkGXljCGlbc=;
 b=gDzgqeMfN05HN3SBG0+uk2+/sRprdsXEntGRAvmzAFqzyOeFMTu5aJ6cpn8XEzGTjBESydLptGlwXPWKYRlnBClZ+EXhOYdREjDNpODcXUJW5nIOiE6qSnji3wgDJG5egT9K4o0tHWb91IOf4HIsLGBrpP38NXXyAyF/M0iDi5U=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from SJ0PR12MB5673.namprd12.prod.outlook.com (2603:10b6:a03:42b::13)
 by PH7PR12MB6609.namprd12.prod.outlook.com (2603:10b6:510:213::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.639.12; Wed, 25 Nov
 2026 18:18:05 +0000
Received: from SJ0PR12MB5673.namprd12.prod.outlook.com
 ([fe80::c3e5:48f8:beb6:ea68]) by SJ0PR12MB5673.namprd12.prod.outlook.com
 ([fe80::c3e5:48f8:beb6:ea68%4]) with mapi id 15.21.0662.001; Wed, 25 Nov 2026
 18:18:05 +0000
Message-ID: <5fb8bb60-7d9f-49b1-899c-40a890fdc14b@amd.com>
Date: Wed, 25 Nov 2026 19:17:51 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 03/24] dma-buf: Add the SGT DMA mapping type
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Alistair Popple <apopple@nvidia.com>,
 Sumit Semwal <sumit.semwal@linaro.org>,
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
References: <ad46d60a-189d-4dd5-9ad8-ecfd3c90f9d9@amd.com>
 <20261123165716.GM179082@ziepe.ca>
 <7ac7edd0-5c38-440a-b26a-21bcbb6f4702@amd.com>
 <awT8prWsj11TBdmP@nvdebian.thelocal>
 <63eb7b6e-e0a8-4443-a434-0301ed59beae@amd.com>
 <20261124142032.GN9566@ziepe.ca>
 <7a5a2d3a-e42e-4dc0-8d22-8dd1bd249501@amd.com>
 <20261124194618.GC114530@ziepe.ca> <awZ_Os1pXelOGaFP@nvdebian.thelocal>
 <fb9a6b12-c134-4e40-86a5-dbcb59c0b91b@amd.com>
 <20261125155559.GL246011@ziepe.ca>
Content-Language: en-US
From: =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>
In-Reply-To: <20261125155559.GL246011@ziepe.ca>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: FR4P281CA0170.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:b7::11) To SJ0PR12MB5673.namprd12.prod.outlook.com
 (2603:10b6:a03:42b::13)
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
X-MS-TrafficTypeDiagnostic: SJ0PR12MB5673:EE_|PH7PR12MB6609:EE_
X-MS-Office365-Filtering-Correlation-Id: f6663ed0-833a-4f71-8223-08df4b2072e0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|7416014|23010399003|366016|261022115727099003|261028144727099003|261026121527099003|261022075727099003|261022105027099003|261026140227099003|4143699003|5023799004|56012099006|10067099003|261102130727099003|11063799006|261021123027099003|261102123227099003|261021121427099003|6133799003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	JmSPTPyL4snGzAzwmSyNoAQA3FggNief9Q+beqh+vxcQw5/BcmdjG3K36jgaWBEyXWQKY1HepbV/uB4FTF7CSfDB8hYbyXtv6blTUiwTjFCh7HuBcOUYuB/LzeDvu0oEcwX7f0VNK5GWXImi7mVN614M0ro153zLlYJGN2znBFATQ+tx9S2+1Socz2x5vnurRlnw4hzj+OAI3Bx1iKwoz8E8WtUUcvpnN6zkZXgGHe5YWfjmuKUZcFWOKXkp7ZoA6Mcf6EoTgpKmYRUxrwvu5SIWXYyaw37QQLW9RUMbqOgiGZYtGNhxF5w0Iu3MCJrrmFQWhWC8A9QFjbnct3dNf4fZPotcRgol94VTiGsv8mrvxdJR5egt77iRaq5gS5xChcCfFc5AQ65xIPOglCsNzTwbXWk8lLTrE1w2dJiFrbk0dkm3MfT2qxHBSHXC4xqf2357CVukSexs8fR4RKbNZNyen1OE1LIPKlRAVPRKZ+/bbIF6rDg51S/3NhwKKDjOnIi0KeRk+235pjnxV78u/hCEY6BWPkC4Lxt/Pr5bixEtsf0fRRbx7pvcviJnVZOQkCQgDw1JFBAGU+fPTEdwcIh/FNHzxdaVymlXLTvtshfOAXVOcjbmkrhhguEvbSWggBhhL74S+DpZXGUfXdX4rPM7DdSGDWjmpVpNUCVGJqY=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR12MB5673.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(7416014)(23010399003)(366016)(261022115727099003)(261028144727099003)(261026121527099003)(261022075727099003)(261022105027099003)(261026140227099003)(4143699003)(5023799004)(56012099006)(10067099003)(261102130727099003)(11063799006)(261021123027099003)(261102123227099003)(261021121427099003)(6133799003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?di9uYUEvMzM1ZUUvWG11cXo4L0dGN3hTQ1lVU21EWG5GOEhzUGZZUkJ5ZzVN?=
 =?utf-8?B?aWRJaGxnSmd4R3FBSGNNOGZrM1MxMnl0anJKTXFqcWt4U1pxNUQzOWZTc1dG?=
 =?utf-8?B?MTgwdFBuNmVYOTU0TGV0VUNFMFJJNWJlVEtrZU1oZ3h5em5mZUF5NXdJbnNi?=
 =?utf-8?B?OVJUTlF3SmRweWQxaFEySEVlcWFPMGRnbE1Lam1LamZTMUJaUS9DUENFR2NZ?=
 =?utf-8?B?cng2SXV1Qm5iQ240WC8yNjRRRkNLdStRVktoeHNuVUppM0phUHRQT1ZoTzBJ?=
 =?utf-8?B?bm5ka1U4TXVMQURtUmtPNElCQzZDMi9VRjNta1UwTkVqTGVKNG9tdnF2c1d6?=
 =?utf-8?B?UzJpcWRuTVplSTdkMnhMSVROZ0xveFlpR3kzWWhlbXZJNkIzclZORFNYaG1n?=
 =?utf-8?B?R2pHWlRvREpBT3VTbWR2OEpPdDJER01uKzc5QjBNcXJ3R21MZTdiOTFtRWlw?=
 =?utf-8?B?d0JnbUJUbWFCU01QT2ROakVKSHlJOE9xbEJNQncySVVEaERkTGsxKy9hVzJp?=
 =?utf-8?B?UXZlSUdUdlA3Q0ZRa0s5YUJUNzFXeGZSelNGcjJEb1lrWk8zOWppUUV3ekRq?=
 =?utf-8?B?bnJCVXJ0N1BITTQzbjVzT0VNQ1BGaGl1VnBaK0dVZXA2MW01d1BwV3g3WVRW?=
 =?utf-8?B?bmoyT1oxMjJHQU90dUFYeUkyZVBLZUxGZDJ3bWFUMHBmcUdmckJ0VkxCSEJY?=
 =?utf-8?B?MnJrVllsVWpkbjNJN2hFRWF5ZExKTTJ3dC9BQ3ZjWll3VExyR2IwR2Nub2lu?=
 =?utf-8?B?L2RoMGVCRUN5cTgvN21Ya1ZUcFczeVFFRVI2U3ZmMElpWi9rTDVtN293NzhC?=
 =?utf-8?B?REI2UTRydlhINVVRTWorYXoxeVZud1JBcUhWUHVpbGczUjNpMXB0aG96d05p?=
 =?utf-8?B?VGpCWmE1NlRySExpNjRRY1hDVDVVOU1yUXJXeVpoK0dnUWovdUt3ZE1nZERS?=
 =?utf-8?B?V2daaXRnc1A2Z0tzWG13YnM2bEVNaTFjTXZhdWNWTmlPYnExYWYrdTFnMFpR?=
 =?utf-8?B?Q25sa29aYWFBUUU3WnFUR0ZLMzdZZm5lQlBOc2hTSDM0UjJqekF6NmdVU24v?=
 =?utf-8?B?aXVOY2g3YmNKeExVdVVjaDRqdDNmN2pIcllEMEdtZkNlV2hLd3dpODZibXJx?=
 =?utf-8?B?TjNMcU8rVnVCVHBWeXhmZ01vbnFjSnZzYjR0ZVZVWTNTSFNPUm9EaktCdnhz?=
 =?utf-8?B?SzVlazVIRzZ1TFRXQWR6bDFlUU9lS2ZJUWVIbUZvdWd1MmhsSSs2S3QrYzdQ?=
 =?utf-8?B?NmdiRFJLRkdQek53bDl5bW4vekk3MHFMQVorR2lUbjJvK0hDQ016S3J1UHJv?=
 =?utf-8?B?cWpKSmRSa1V3bGdkYUxCNitwQTlDQnk3aU1GQW9hMnRvV3A1N1hQem9LMG5J?=
 =?utf-8?B?c2NDbkNiZ0w0MUNYS0hkU21WUVNub0RROGRlbFVQbFhzcTU1U1RRcEJhZ3N2?=
 =?utf-8?B?ZEs5Q0pJWFFtdmpldHdzaHphaGFOTERjMkxUQjN6Sm81V3RaSWN1eXVQOG9k?=
 =?utf-8?B?cU1LUjZtTmgzZVZBR3pBVnZIbCttRGJtNENDRHdBRWUwYmo0VW9oTHpQb2dW?=
 =?utf-8?B?TmZaOXJuMVdMRVhudXNieXBScFNiYXVOK2pCNXVhMU9qRDd6RHZPYU8wa3NK?=
 =?utf-8?B?dEJBcmp0NldTYzdNZXZ0T29TKzQ4dENBZTh0bWxUbVpZU1NLWEpIcWhzK29J?=
 =?utf-8?B?Z1ZKbk1iQ1BtbkVDcitBWlM3WTlkN3l5TjhTMXcyYTY0UC9UNUplNUlnRU93?=
 =?utf-8?B?amRvcmp2ZnNPYU5CNTZFc1hIWUJFMmdoV05zTnVLZU9TdVVoYmFYM0daRGFK?=
 =?utf-8?B?OXd0Q1NTVFVQVjlSWDZocExMMFZWU0JsR3lSZ0hwY2Jzb2taUG1aMlppdUxS?=
 =?utf-8?B?M0dYdlVQdGVhZFZxcmtsYjJZVWRSVWRyZmh4NHEyU3VTVXR6ZlkxY2JJVmdY?=
 =?utf-8?B?TWZHblhIck41TWVIRVFzamsyUjFQWHFEZDIvQU55ZVVibE1yUWt1WHBpME1q?=
 =?utf-8?B?QSs2a1JPcGtwYmhJT1RMcUMwNkdnaEVMUlZJNDl4OXdIZ3NhTElja0hHRVRH?=
 =?utf-8?B?U29KOFJWdzJRVUZudmVPNFVMRmlDNzJuamxyd3BXRmlIaUpjNy9rMmcvcnNn?=
 =?utf-8?B?QS83U1N1TXNWMzJ5NzR3Wk9TY2E3a1d1NG4xTndZVlEvR3RDOGNhRDZ0eUVL?=
 =?utf-8?B?N2pJaDNBbnczK2Y1QWRyVWdkU3BtUE9TeDdBZmdQWDhkcGNPMHE4Q1c3UEJh?=
 =?utf-8?B?L2FDSHZUK1luVXpkU004UlNtdFNYNHBhMVFtZEJkTGk0cVpEUlNrUUZOR2FY?=
 =?utf-8?Q?lyJSRbwRoDqA4NuSt4?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f6663ed0-833a-4f71-8223-08df4b2072e0
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR12MB5673.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Nov 2026 18:18:05.1243
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LRPOz1HssV9UudqDQuPsXwYtJPdHkmaQeFq9nqYmRUjTPnFAhYVNN+DG69ejg/pd
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6609

On 11/25/26 16:55, Jason Gunthorpe wrote:
> On Wed, Nov 25, 2026 at 12:19:08PM +0100, Christian König wrote:
>> The low level API which talks for example to the IOMMU driver for
>> creating the information how to access the buffer is simply not the
>> task at hand for that framework. The stuff we already handle is more
>> than complicated enough.
> 
> No matter what name you give it we need something in the middle that
> can see the phys_addr_t and the iommu_domain..

No, absolutely not. That should be given to the exporter so that the exporter can call the DMA API to create the DMA addresses for the importer.

The idea here is that the importer give all the information to the exporter so that the exporter can do the mapping on behalves of the importer.

> If you don't want DMABUF to be that thing, then I'm not sure what you
> have in mind.

A P2P DMA API the exporter can use to create the addresses for the importer.

>>> If I drop the type/placement negotiation for now and focus on SGT removal I can
>>> simplify things a lot. Plan would be something like:
>>>
>>> 1) Introduce a new C data type (dma_phys_list?) for exporters to pass physical
>>>    location info and context for mapping.
>>
>> Something like this maybe?
>>
>> struct {
>> 	u32	mapping_type;
>> 	u32	num_entries;
>> 	union {
>> 		dma_addr_t	*dma_addr;
>> 		u64		*generic_64bit_addr;
>> 		...
>> 	};
>> }
>> ....
> 
> "phsyical location info" means phys_addr_t and related, not
> dma_addr_t. Step #3 has it as the *input* to dma_phys_list_to_sgt().
> 
> The flow today has the exporter get a phys_addr_t (ie a struct page),
> build a scatterlist and directly invoke the DMA API.

Yeah and that is completely correct and should stay that way.

> The primary issue here is the exporter *direct* call to the DMA API!

Why?

> We cannot disconnect this from the DMA API, ie to use an iommu domain
> or ualink, if exporting drivers are hardwiring calls into it.

Well the plan is to not disconnect it at all. The exporting drivers just says to the underlying API here is my buffer please map that for this importer and that result is then given back to the importer through the DMA API again.

> Fundamentally the need is for the driver to get the phys_addr list,
> exactly like today, and then pass it to an op which formats that into
> the right data structure for the importer. Be it dma_addr[],
> iommu_domain, or some ualink_addr[] - or whatever.

No, the phys_addr type should only ever been seen by the DMA API and not by DMA-buf.

Otherwise DMA-buf becomes the middle layer for creating the DMA mapping and that was I want to avoid.

> This is the main issue here, disconnecting the exporters from being
> hardwired to the DMA API.
> 
> That's what Alistair is explaining. This sequence:
> 
>>> 2) Introduce two new dma_buf_ops - map_dma_phys_list() and unmap_dma_phys_list()
>>>    - which are replacements for {un}map_dma_buf that converted exporters use to
>>>    return a dma_phys_list instead of returning a sg_table.
>>>
>>> 3) Move dma_buf_phys_vec_to_sgt() somewhere other than drivers/dma-buf and
>>>    rename it dma_phys_list_to_sgt().
> 
>>> 4) Update dma_buf_{un}map_sgt() to call the new map_dma_phys_list() ops and
>>>    dma_phys_list_to_sgt() to create an sg_table for unconverted importers
>>>    importing from a converted exporter.
> 
> Effectively converts all the exporters to produce a phys_addr_t, and
> then moves the DMA mapping action into one single place in common
> code.

Ok in that case I have misunderstood that and that is still a clear NO-GO from my side.

The exporter should talk to the DMA API and create the mapping on behalves of the importer.

Regards,
Christian.

> 
> With one single place we can figure out how to replace it with a call
> that does an iommu_domain:
> 
>>> 5) Add dma_buf_iommu_map() taking a IOMMU domain/iova/offset/size to be called
>>>    from iommufd for mapping an attachment into an IOMMU domain.
> 
> But that relies on iommu_map having access to the dma_phys_list *which
> is true physical*
> 
>> I think a whole bunch of other drivers would be really happy to use
>> that interface as well, yes.
> 
> Right, that is clear now, that it is not just iommufd that wants a
> dma_buf_iommu_map()
> 
> But I don't understand at all how you imagine to implement
> dma_buf_iommu_map() if you don't want this in the DMABUF core code.
> 
>> That totally sounds like a plan to me.
> 
> I'm confused if you agreed to what Alistair said :(
> 
> Jason

