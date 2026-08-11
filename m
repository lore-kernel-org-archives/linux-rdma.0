Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazon11012059.outbound.protection.outlook.com [52.101.53.59])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26869476CCF;
	Tue, 11 Aug 2026 19:32:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.53.59
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786476736; cv=fail; b=LTU+li6ZD7jwZiDmAzqlE5+hRr3HMmEulW/x2LZ9YYhBNLrkUK/JW4qESVJ5yhjMJ9kfrBet+sDgKMc1GeFZdaN6IyBoUAc8ApUxO9HSXvrgeBmiS9uPCDSeEanxc5T+m6CL4Qeo9Jh74CZceLJ/W2yRh8QyMqcOvKu009KYdvY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786476736; c=relaxed/simple;
	bh=52AxxKKl8UjWrWfWpsR+tROMRNnhYlDl12oICN6bTNY=;
	h=Content-Type:Subject:From:To:Cc:In-Reply-To:References:Date:
	 Message-Id:MIME-Version; b=DlyMcltVPpr7ssQI5LzmLZ2qRUtb9GVQ0wRDLpItrRNGooKz+DIdsQW0JViQ145LX//YWNlS5fHscZU/MYzTZGxxXt3Ow9oF3BGzO1TtTndEg+Vrg/XbphA2CG/b1+TVI7K2T2mMDQK5CcJxeCEVAiuqmUBaU84Bk3x2D+ivCi8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=OKaamobc; arc=fail smtp.client-ip=52.101.53.59
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="OKaamobc"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=T6YK2YMAX2fXEc1e7t+IlGh2C4l9t8lpizz0udAmYWN6CBYFXpWS0ht6wEo1c1L5e2qtwE4b6/3mjfeYf1mIi+NSYB6XyUu7ghr2Yz2MD0OjftrG5SptXd8QPAYThJ+MTXKqHwayZA92dTQUCGirYLfVCL5B897opci7nIVOZ70xkkMEm/2cG1RaIpjsUeRmApo9b7tanrkndKqq+i0IRAkLmzs1BpKkFIV7JSO9gQ7k60FrrWbXlJaXEs2l09Q8ZlM73Vqog+17Sp/qgcmpwXhGses3uw0F3TXnh2HTIojljpOJ7bbt4M+g4NAwRoSNhOC3UCjZ4IWToISzfDfAAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ytDCWL/kPGfDteC94JqwusNQW7YCUzfr/6KK8wIfawk=;
 b=yfY1In2Y4SRzwNWxaE9FuXqVa97bYWITLuLhwjIr4ScXzggw1zETpDytxNiv9CQUd42hppIEirG3FzrM5oRsY/Ri2MTEHJkqQO9TuYj06AiTiO1bo4ZFiaAJGXuwDB/y26kp/En8rk3S4Og2TwSrb15KfI8bYcU33SMrZsJXTwPOpyCvXh2BtBQNtOZOGbKG40kXXZ4PAN6H/lkBk628lP28bBZgFiuJ8ZGFdthOWTTIMqd6kcuKnJZWuLUhYeveKCKl+KYhp6A/9b1AdY4ZLVhXaTDm7Ht297W703pggFHpGadKyu/eWlNCSuiJ9Rlt16sXaEjGAJerXAS/Y8LLDg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ytDCWL/kPGfDteC94JqwusNQW7YCUzfr/6KK8wIfawk=;
 b=OKaamobcFiTNt8Jj7lyXw61DboOhoH7ehOqKQ75tRP16qmolsdHr/ORZHxN6oVXirjVdOIXnykMaYWW1sHuWX7b5M03si8QQWQhgzfJ+wKxlX1brmFmpHs3VVYTGy/36XMmgg7A82qlQoUR47NeiahdAOF0Db4IpEdRIePYYqFx71mRz0KItVMSekqfqArvpEnjbvnFN8Rv9XQYVk3Ru6XTvKYhxm7SrFw19X6w+mzH/kEL5JZfqvvh0fOFopJMWms+7qd6hs0IM4DOG89UVl+YNzciwtMKADyG2WP4SRbNqhWYD8k8A/2gvIKvLYLidJ6Ejpvtq214AyyCMWI8pxw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by IA5PR12MB999277.namprd12.prod.outlook.com (2603:10b6:208:608::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.25; Tue, 11 Aug
 2026 19:31:55 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528%4]) with mapi id 15.21.0315.011; Tue, 11 Aug 2026
 19:31:55 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH rdma-next 08/15] net/mlx5: Enable relaxed ordering on
 resource dump mkey
From: Jason Gunthorpe <jgg@nvidia.com>
To: Michael Gur <michaelgur@nvidia.com>
Cc: jgg@ziepe.ca, leon@kernel.org, linux-rdma@vger.kernel.org, 
 netdev@vger.kernel.org, Edward Srouji <edwards@nvidia.com>, 
 Yishai Hadas <yishaih@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>, 
 Tariq Toukan <tariqt@nvidia.com>, Mark Bloch <mbloch@nvidia.com>, 
 Andrew Lunn <andrew+netdev@lunn.ch>, 
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
 Kees Cook <kees@kernel.org>, linux-kernel@vger.kernel.org
In-Reply-To: <20260726092943.2880176-9-michaelgur@nvidia.com>
References: <20260726092943.2880176-1-michaelgur@nvidia.com>
 <20260726092943.2880176-9-michaelgur@nvidia.com>
Date: Tue, 11 Aug 2026 16:31:35 -0300
Message-Id: <178647669514.282103.17588681955803460454.b4-review@b4>
X-Mailer: b4 0.17-dev
X-ClientProxiedBy: MN0P220CA0011.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:208:52e::23) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|IA5PR12MB999277:EE_
X-MS-Office365-Filtering-Correlation-Id: 51b706a6-1d3a-4f1f-3e44-08def7df3100
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|23010399003|376014|366016|7416014|56012099006|11063799006|10067099003|4143699003|6133799003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	OEBv7tgDOb3JeRJoVYAnf6F1vSZUepzIMsKRh4+Pfl3AiC4aOgSd+bf01oXwtSXMhZs9FbP8iuqOkJsGX29onKW4xHtr0GCUmNzJOJU+xXRhwLUsXQpz7fehgyzYHwI+3pBsSJMT9m4ywYx6DZQziSnO0ttrQBPdM5LVwDyKIBHwOHd+U3+vKQp8zduyhxSbIEbldyAkNxND/n6gjSOI1w0uW410QF9Gve9taVkvi9afkIYT0EpQGU0NB3GcV341e3VpRx/zHT4cMA0bbvgbDtQVexZqJ82AYvSsPXcvkRDntpZsLge01qPUkuY1YRwrpI3ZSRQGiz4zg/6UvGwEwQxfKtNl9thy8H/ewq2khRf8hEfE0S87930YcDqMkdgujBXtgnA32gOBW9cRfKfIR12nOirtprH1/+hCwwZZo3UOKR4ykh93Le9QXHxqqK2+JuVTtHiMQ2n+tj2u9tOlbi3lqNrOv0dVVLf17NQQPloSgSh/cr8Z/Pvudf88u7humiQi46XmNTPBND9VMrriJE/flhsGLSwq5NsCoqDdkgagDImx0q5BiIiqk48tCjbiFAUCTIfaVTbdhJviBx4gujyZTwCpTPHDoRpkWg3vEHsF/VjSWsrsXAMXdRDe/l2dH5u0VG3cTKi0/7cGd75vO+lazsULFIxj+aJBo2bx6N8=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(23010399003)(376014)(366016)(7416014)(56012099006)(11063799006)(10067099003)(4143699003)(6133799003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?b2ZZWWNmSDhmVENQRVBMREZObnNTdkxFcU5ib2oxTS9lOG9mNWpaTkZ4VFZq?=
 =?utf-8?B?cTZZdzNaSHRyeEs5aVRpR1E1dVpxQXNHU1R6Z2pyb3VHSVRCMy84aEROUnRi?=
 =?utf-8?B?Um1hSGF2VitKWlUvZUY4MENoWnBNbnJHRm9rRWNoTE4rVTNJWG9YVmE1cEtw?=
 =?utf-8?B?eVlCOENmZmhUaWxjUmZScjQ4Sy9Ed2QvUk1vbjJuYmFwbUMrMkI1OVU0M2t2?=
 =?utf-8?B?V0d1TFF2UHBkdklRc09Ka2x5SGRRd2phL3NMc3Q0WU9CMGd3Y21lVUx5dHJM?=
 =?utf-8?B?SktaZDBObFhobHE3RnEza1pyK2VTNWxwc3pCZHN1TlUrdktncmFXRjNjRldI?=
 =?utf-8?B?aGlBSEZkNzg1eU81ZzNuODBYenhxek9sQUdkZmhVWjNXTkxUcUtYT3NFR050?=
 =?utf-8?B?UmwvQk1Ua3lhUFdlNDM3YnpjK3gxWlgrWTVkTUhVYTBxeWZOSFdMb05PY3k0?=
 =?utf-8?B?RXBkUFVDRVQzZFhUMGl1NTZhUEdKM0VBTkZ2RCtCbkpLQTB6VmVJNmlJbUI1?=
 =?utf-8?B?dWVpalRCVkpxS1hLTmlraERPSGl3RWl0UUxLbWNYUDQxQlBucHpDek9tbVl4?=
 =?utf-8?B?ZnozUnJURWdiZTlNME5CaVRjOHR2QmVSTUNEdlZlYlJET1Y5ZkdQODNmbFl1?=
 =?utf-8?B?UHpBbzI2SUdmb0dCWVBGSzVZTEd1dW5EQ2JTaWhGUTErOGh5SXdoVzdOaTVZ?=
 =?utf-8?B?U2pvOUtEZDhxRzhZL3c0bnM4eEdFUTN2dkxWQ2RHNEt4dGJSVkRTQXNycDRk?=
 =?utf-8?B?RkdBdGk1c0ovSGVGWjhUeTFla0VTWEcreEU3Sk1ZYjRkL2UwZk9zbEVaQW1I?=
 =?utf-8?B?QklpWnh6T2JNSFB2Z1hMbGJVUm5DVkV6bnhTaXJnTlRyNWxrS1d2YkxBRVFH?=
 =?utf-8?B?d29HR3hoTGlsSGY1bkRsYVFDY1A5K2ZiRm13dWRPbCtHL0hyLzVzSzcyMFNC?=
 =?utf-8?B?UW91UTUyQUlJY3pMRkNTc1N6dE5hWUpnY21wcTdFd3FmSTkzVWMwZ1lHY0l3?=
 =?utf-8?B?QXlhVmxtWVZZbG9DNVl3cG9ZOVpmK2VlN0xnWHhMZDFtQy9nTVlRbWIveG1p?=
 =?utf-8?B?RUpXcm5sVjlXTEswak8vUE9oeFIzQkJnZytvTWxmZFhRZFdtcXNDN2N3d1hw?=
 =?utf-8?B?RVJkMWdYUWkxSlRxREFKTUlzTnZ3Z0JPanY3Zkt2OWJISWxlemI0TzVXazN4?=
 =?utf-8?B?WlpXd0UweDAyL21NTGc1ejRxN3hJZVVKWTFVVnllbjFjSHBWZVVkZU5oYUpL?=
 =?utf-8?B?NXIvVDhDeklXNE5RZXI0MmlXMUowR01zS1lVUmw0b2l6Q1h3NFJ0OC9LMGdq?=
 =?utf-8?B?dXRqT3ViR2VLciswdGU1RjFLbjFsUHVtVW50MlY4SWlnTzhGVEplZE1DcXQr?=
 =?utf-8?B?N1d4MXBHYUVmQUZjbThCcmR2MForRndEajlrcEFMclVDdFVPeDhxR05nWkVY?=
 =?utf-8?B?dnpraXhENUUxdFMyVjVvT1ZDQ01BOUx5VFVzNmNTaGxzTk4ycURDRFBSTSti?=
 =?utf-8?B?MmlsVjZTU2V6Y1RvdUk1ellaVERUSllMRE1Ya1dkVnVUenVkOStuSmJQa24z?=
 =?utf-8?B?dkg5aUF4U2ZkVlUvYk1UZnA5Wlc2OVdYWFowMHpLa3d2OXJtOW5jemdSQkFl?=
 =?utf-8?B?Wjloa243YWpkTFdYVzI3THpnYTR2V2puN2dUOW96N3UrcW9VNHBkMkdQbWI5?=
 =?utf-8?B?U3hrVFlUTlUzSE5MQnJJVU41U1hObzJNd25Udmp0dDdtbHY0Q2ZYdFdRbUh5?=
 =?utf-8?B?dVBOVHdEYWcyOHdhN2E1K3c1UzVjWEpMUUR1SkRlSmFkUU1NSi9XUEtHbXo4?=
 =?utf-8?B?eC9iazdMNWlNYWpQRWZNeVBEbUQwU3hXL1VaaEJTTm5wYnNoSmhRYi9aUnRB?=
 =?utf-8?B?cklycENoNTllcUZLK3BCREZPSDNwU2xqa2ZvY1QwR0pSaGZucmJmQTQ4TnBo?=
 =?utf-8?B?emVWQTZGSm84eVcxU21zUTNQWGlHRnVTQnpFZWVudkw1ZXNHL295RGxCdzcv?=
 =?utf-8?B?TnlVako4d2tzM3kvZ0p0ZEhZNDRrM3c5RkZZU2psODlxc25LODFEemQrMDNN?=
 =?utf-8?B?d3pyTW4vWXRWNFNBbk13NXhSbTF4aXp2OE9RWXVLU2h6WCttVXMvbEE3Y0ZY?=
 =?utf-8?B?cktJbkt4bDU0SVlQTGpmeWIyWVE5Q2k4Sk9iRkNUNHI3K0F3QUp4MVl5RThC?=
 =?utf-8?B?emdiT1MwYkd4WjFZZm81WU4zV1ZEOFhOVG5DeDg0L1VyU3FFLzV0cWc3OWwz?=
 =?utf-8?B?a1haZHdoanZqK29qOHk3cEVRSjdQemdWZUZOeGxrb3hkVENveC83TllzQnRp?=
 =?utf-8?B?aGxISDdUcWgycGtyOFpUamhUS09mUGFxMVN0ZDN6cncxcFhGeTFYdz09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 51b706a6-1d3a-4f1f-3e44-08def7df3100
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Aug 2026 19:31:50.8178
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GtGOtvQmEIvsJwo0lMf+upjNYyYi5dqBTDhCiJJAb53sfpXIDIJyL8jOXmWS4xel
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA5PR12MB999277

On Sun, 26 Jul 2026 12:29:22 +0300, Michael Gur <michaelgur@nvidia.com> wrote:
> As resource dump logic reads data only following an event that is
> delivered with strong ordering, there is no need for strong ordering of
> its memory accesses.
> Add relaxed ordering access flag to its registered memory, thus allowing
> better performance and allowing resource dump on HW that restricts
> strong ordering.
> 
> [...]

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

-- 
Jason
