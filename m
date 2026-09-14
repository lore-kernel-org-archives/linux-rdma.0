Received: from CY7PR03CU001.outbound.protection.outlook.com (mail-westcentralusazon11010007.outbound.protection.outlook.com [40.93.198.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14AAA474247;
	Mon, 14 Sep 2026 13:48:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.198.7
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789393682; cv=fail; b=cxW5HhKPk7qUi4ZA3+KV7RcJQ27yGAcO68xovUHzbhVgCixUF4KD69gFNzGqB1vQS+KfBDFcQGuFKDJNLQ79/Szcxu6PUS0l+f1wXgRh9eKA2/yCPDnnzw11vOEMiXy1JAssgwZroxfG1HlcbiHXLydVY9JekfadCxahodF8ueI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789393682; c=relaxed/simple;
	bh=cADowz7JQRnbuIwqF03raAyZFhiQQ9aaPS6mrskSKQE=;
	h=Date:From:To:Cc:Subject:Message-ID:Content-Type:
	 Content-Disposition:MIME-Version; b=DPlnsPWDq9SeDHlYV5PIrcFhIfkAu2LkRerGGCGKjaFgwYA3tGujyfCxILZ4i1x7PNR4XIvW1hnIAO/5cuuG4e+bqb7Acnl9vyT1ON6Jdk1927eVQYnLvDprnXkJFW7vdxDquuYHCXrQKeMS/bhobnqweyTg0pd9DlWgEKaB99Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=sNBTEPal; arc=fail smtp.client-ip=40.93.198.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="sNBTEPal"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tJS6gKpO2FrWc0r4EXxKqla9KUtLU6eKvzWCPRILbRovqDvPPw1Yj6Na4a14gEEtOrhmlvCHVR+QBNUffgE0LStZqpijTnFSTnqnxTi3fRvMg224GBTejyLTQhBoc0D1Jk9dltzHJPcoYphZ2hFo5ZuyW+vZNSi4AOEeYXyQEm4KCzuO95eFwvuId0hp0JqDXHfK7AcgNGo/ChiAQKNBn9urQJjD2kPW1NhbsZG+d+6zk47zytQC1+IA0UJo1Z0vN8ahVlvZLGdsX7Ambqy2+ee/skVMpJnVWTbChMuoD1ESAz3C0dUCAcanlPYYGEoQbrofgoqnY2bBjX7oqdM5Tw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hLTuOuy4XO6MJ72t2cWz1QXytbVCZhwB1rQ3Y/8t6vo=;
 b=nSLZBYb+JT3wQW2M+cahJpAP7GWoE+UVF3pnO0T/ndythsxJmCNDrzdtbwkXdkCdID8lPbkrNKz+QHv+sdqYrUX1o0yO07mTcb14Bkpqjfy4jLOHIZNraBVh3XDBcBAGpW9hUZSj9R5Uxgifk1WRBisEsD5CeVtPuFfsz2lCaHNExJQJpP69BeQWdti1O8dOiZUyDKyWIIPzegHjkcOv1dEsYg7m4NPYriSYU7JQ4BAQoSjaumejaO1Hv25bSI9Zk020wjAZvhoyJvqCdo9EbilQNvR5azuoBpwRNGGMG+MXJO0VA2albmkw+yED1iceC5AP6FsMJa9uTVGoPCmxqw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hLTuOuy4XO6MJ72t2cWz1QXytbVCZhwB1rQ3Y/8t6vo=;
 b=sNBTEPalZQ6c0ghzQxujL4RRK9xDWhti28266SsAU4cRShbkHcJn7/IvBUs3mwjI9Wm9wBUAMcUxwABjVrcyUoaCdQKgs4oDN8T4F9JTNuNWgMNUTxesX3QVVpiTSQ0Uo336HEqtMUDN9MkgRWhKFjLjjl6p5UlPChPFORCdYJjhnpcCiabZYHh1PwFZK4tFafnypnZfNfKkuYkWdXCGgLdixyGb3++LOhf7rE19BCjHBPOnLfi4rslnNpBEe9fb/i23C6AfpxExdihdPzbNKSXlBtcBGKi35sQ1qTp2zhG9qyOxhKqswqwO8io9fKY2jXrwLUeVVteDVWZ5DSon6Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12) by DSSPR12MB999236.namprd12.prod.outlook.com
 (2603:10b6:8:374::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.11; Mon, 14 Sep
 2026 13:47:57 +0000
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d]) by CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d%6]) with mapi id 15.21.0406.007; Mon, 14 Sep 2026
 13:47:56 +0000
Date: Mon, 14 Sep 2026 10:47:56 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
	Leon Romanovsky <leonro@nvidia.com>
Subject: [GIT PULL] Please pull RDMA subsystem changes
Message-ID: <20260914134756.GA192443@nvidia.com>
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="NJBR7btByq5qizc/"
Content-Disposition: inline
X-ClientProxiedBy: YT3PR01CA0043.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:82::10) To CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CHBPR12MB731189:EE_|DSSPR12MB999236:EE_
X-MS-Office365-Filtering-Correlation-Id: dbaf2235-4b0f-4f02-6342-08df1266c864
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|23010399003|366016|18002099003|56012099006|11063799006|10067099003|6133799003;
X-Microsoft-Antispam-Message-Info:
	/laXYMUZ3odH3oWKV9YewItlwAJEVTHwxDZ5oRdMVVwBOhd3FwC2GgxKB7AXTo+f8yv91jRMGq4kJ2BtqPdMmmEz4sIHrQUryPXpQYYYOy7yKN745ApypHlWPddAkpjoKigG9PWcE3RIo/06Ey+pLscRbNyCMwy6wrz6g5zWEzwSDY5rLqV1Gj0zP/SkkpjwJ8lSVMej7Fxhg/5rddi1x+iujxKicStUCJHBxGkwVqUjbZ+w1xSA7fT1zlN9Y6ep7y64MNrCcj4335e7iXtDnrkhhaix+aKqeVOUBQ89CwenCydOrO7qbz31jwhyoFgLDrqzSP/vs8RNNLqQjKV11fQMN0DefZRX9q244FeTGehghOKlG6ch9BHLpf5x9rDgX+CB40mlHqu9zRQXp0j/5VnSNVynz9oVqvHPPw8Pkf8tNGf+rp8A+Mn9ctx5OYC8eiM7w3hVUpxg0GEPdXu5SuzX1R9azwIYXEbfFidFsKMpkrZFv3HihfKgCqEWIE9lGi1fZ7zX6qFnRxL9llJaKy1wf+yQ72KgaUtBwfYVxVlr/u2O5el6S69j5dTB6F4P6i6e5V+l7aI+DQqrGy9VrYX1SmQcQ3qk+BwQeaYwNYPhLPkBe7C3YlXofbbw7ZsYwlMe9CEU09DqjDZVkWeXXL7eEGFhmbTjYus2Z8MqAnE=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CHBPR12MB731189.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(23010399003)(366016)(18002099003)(56012099006)(11063799006)(10067099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?US9zbEVqV2hiMnJra1FBeFk2RjZ4RHdhb29JdTF5NFNuUHF3QlhxMytkZzlK?=
 =?utf-8?B?LzlSUHo1NUJ0WDl6c1NkY1dCRFVXSGxpYjVqOTBzMHNGekF5VHQ4MVJtR0hS?=
 =?utf-8?B?NVZ0cmJKUmhwcTdYeXJlRFVLNVM0WGRzSStWcWNON0pBMldjdXNYTWJFWmpL?=
 =?utf-8?B?Wkt2YjlabnU5NWtpME9ic2xlZENvemw0aGoxR2NGbjJDVHBrWnkwM1BvcmZ4?=
 =?utf-8?B?OUNJSDd5RHkrczBGeXM2dDhISHBHV3BkbWVoRVFuZW0zOERONkowOFNCSEpW?=
 =?utf-8?B?S29Zb3ZwUEJDQUF3aDlTelJBekxMOU5hZ1VqMVlYWTlmbCtSZjNKakNmdnJh?=
 =?utf-8?B?Z2Q3RmRjcDdwSU1ocWZaYTNCU1A2KzVNSWRXblFPdmpxNTVCbWQ1S3pITVpq?=
 =?utf-8?B?UE90c3E3SW0yMUU0eVFreFNaWm95dXFVV2pqMCtBSVJPTlcwckdDaW5tVDFn?=
 =?utf-8?B?c1ZzcmZnRGphN3RlSy8rYmxyNTRORTFiRDUyVXVYTFpWRk5ya3ozanUyYXJ5?=
 =?utf-8?B?QlA1VDlGbmVreHYrdG1PTUc5Z0tmalVtNzRIQllOQ3l1a0x0MjB4aExBbHUx?=
 =?utf-8?B?ZWNYSXlabmhXS1NrYzlyVEpVb0lXWkdWOFQxZnA0SnNyNmx5TFA2R3k5Y3Zj?=
 =?utf-8?B?YUhWa3A0elRVRTdJcTBUVzJlMWtCZVJVRGp3Y1JqRFRwM1Z3NUFUOGlkQ2VF?=
 =?utf-8?B?OCtqQXZRbE9DekNXSHdrMnpRT0JYT3ZZay9ESHNYdFdXL09DRGhYNm92Qy9Q?=
 =?utf-8?B?cnRsQVAzZ2FQNmRhbVN1cGpqWk9ocW9qU2tpU3QrRDNKRjJvbWtCQ0JtVk5m?=
 =?utf-8?B?NjBwUFkrNzk0T2J6YjNWREs4OU9PbmlZNXF3OGFxdU80RDBMUkh6bE1SRGZy?=
 =?utf-8?B?V05yRTVBa01pK1d3VWVFZFJleGZtZUJ6N3RRTVBvQk9ld3JtczdLMitRWjFs?=
 =?utf-8?B?T0M4MWZYRVgvZ2FOWjM4YVdQT2dDNjkyRnZEN1JHTnpZVHgxVG14ZWRURitO?=
 =?utf-8?B?V3BKQ0wzaC9CS0Z5YjVhMlZLaVFLQjRZOS9pRlo5UUhuZTI4Zi8vdnFsYmV5?=
 =?utf-8?B?STI1dTdyRlUvSlR4Wk1vdkZ5RWV1Ti92cnVNcmNJbGRIS1hjVDNoRTVHT0Vl?=
 =?utf-8?B?czY5Ny9XSDBLU3lrWHV6Y0lTVFBzaDlmV1phTHZHdFJpRXRDemRzcUpzTjIr?=
 =?utf-8?B?d3NkWTZMK3lpRE9ZMytOb2xoYXMrYjFQT0xrRzI2QkRIdnR1RXA5QXFqNmRR?=
 =?utf-8?B?MXlkMElLdlhWYlE5a1ZNOFVRbUR3dWVMR3pndnVXYTYzTUJSekd1aUVnUVBI?=
 =?utf-8?B?SWpsbHkxOXpUYmwyc2hhZXhtRWdnWXNxcy9ZbXZFUTl2OE9XWU1mU1M4RUhK?=
 =?utf-8?B?UVExYXJ2SXJpTXU5eGhTOXN4MHVEZnJkZ2FManNuaDY2RlByVUFIellsSWh2?=
 =?utf-8?B?VkdyL1ViM3JFNzFQbWFwYW1GK2FJQnRaeXk1Q3MxZXhKNFBrMkhValVqa1dp?=
 =?utf-8?B?QTIveEVqSEFsOU1GMHJ3RTNRMjVpbjVuaHE1WUFxL1cwZ0NMbTJmemVjUjZH?=
 =?utf-8?B?R3BDTnRLUzdkQWxTYnNQQ3lzZkEvZmI2clpRSGo2NFhCRDN0a0NkNEJaWjRR?=
 =?utf-8?B?NjVQczQ3dXBvQ3BnbjdPTmsvTjFmdlRMTGYrYlFkbWRwOTJqTDZmcmcvOEdo?=
 =?utf-8?B?eU1nV2Y1UHVYR2s2NTV3ajh1TmlFTmF0Vk5KN2QwdDVZbmVzbXF4OWRrSFZW?=
 =?utf-8?B?blIyeXBjUkFyYi84TjlHQWdtbWhIUE4rVGdZdHQzYlVIUERvclBWdm5iQUNU?=
 =?utf-8?B?Nm0xclNMckhmWlFUS24yWS9nczVtTjE1MkYrSTJ0VXVlZ2dYMzJxVGVnclpN?=
 =?utf-8?B?L2ZVTjNRSlFsbUFFSFAzRFdESlNFSWYrQ056cTRZTnUxNUhzdEZra2VVUjZj?=
 =?utf-8?B?K1JuYTJZUWJCU1h0SHA1ZnhNL012QS9uWVBZVnpybXdrL2FhV2FSYloxQjdI?=
 =?utf-8?B?TXVkYTgvNlJNbHdSWUxQb1E2RWc1UjB6cXNvblV1RnI1Q043VkRYbm5OZTVw?=
 =?utf-8?B?cWpPZERiaENabjN3ZDRSVTgwRFc3akluTGFhVm1HbnBKYmdxem9FTkJ5M3o3?=
 =?utf-8?B?anFYUUNnanNkTU9PdXN0cGlBQlhOaDZLOFVnWDNGOFNxSmZPOUkra3ZRUlZO?=
 =?utf-8?B?Q2JpUGg2NFQ2Z3FhR3BCdmtXREJ3V202aDJ5b0VyRTBoc0t4ZDhuVXBja0VC?=
 =?utf-8?B?LytyeE0wVVRxTkd4cUQydzE2R2R2OEZjZkJjeWtFcjhGZlpHLzRzcW1jUjNz?=
 =?utf-8?Q?yhmF65zAUhwQ34Y0m2?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dbaf2235-4b0f-4f02-6342-08df1266c864
X-MS-Exchange-CrossTenant-AuthSource: CHBPR12MB731189.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Sep 2026 13:47:56.8947
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7B7I12p1y+uaa9q4NoTKSi+ALRf9z70nxjU06U6SANn2kJfQwiXftKHhmphJCmY+
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DSSPR12MB999236

--NJBR7btByq5qizc/
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Linus,

Collected rc fixes, as usual alot of probably AI fuelled stuff, and a
few bugs that people were actually hitting.

Thanks,
Jason

The following changes since commit cee9395acd8043be0644b25c34bfa86623f2b935:

  Linux 7.3-rc1 (2026-08-30 13:34:40 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rdma/rdma.git tags/for-linus

for you to fetch changes up to 9ff797e516dbc1ecb73701ec4c24055712d44411:

  RDMA/siw: Bound fragmented header copies by the remaining length (2026-09=
-10 11:15:46 -0400)

----------------------------------------------------------------
RDMA v7.3 first rc pull

Lots of bug fixes from the last weeks:

- Various error unwind bugs

- Several more races and bugs in siw and rxe, including remote triggerable

- HFI1 corruption with its credit scheme

- Remove a bogus user triggerable dev_warn

- Lock __ethtool_get_link_ksettings() properly

- Fix a lockdep loop with diassociation

- Several storage related bugs, some triggerable remotely

- Do no leak physical addresses to userspace in bnxt_re

- Fix wrong irq context for the xarrays in erdma

- User triggerable race in ucma with multicast

- Race in ipoib with multicast flushing and destruction

----------------------------------------------------------------
Bart Van Assche (1):
      RDMA/srp: Fix srp_remove_target()

Carolina Jubran (1):
      IB/IPoIB: Avoid restoring OPER_UP after multicast flush

Cheng Xu (1):
      RDMA/erdma: Use IRQ-safe XArray helpers for QP and CQ tables

Gang Yan (1):
      RDMA/rxe: Fix integer overflow in mr_check_range() leading to OOB acc=
ess

Guoqing Jiang (1):
      RDMA/siw: Clear association under lock if siw_qp_modify fails in siw_=
accept

Jacob Moroni (1):
      RDMA/irdma: Enforce local fence for IB_WR_REG_MR

Jeffin Philip (1):
      RDMA/core: fix refcount bug in iwpm_get_nlmsg_request()

J=C3=A9r=C3=A9my Jean (1):
      RDMA/siw: Bound fragmented header copies by the remaining length

Krystian Kaniewski (1):
      RDMA/core: Reject unregistering netdevs in ib_get_eth_speed

Leon Romanovsky (2):
      RDMA/efa: Keep admin queues alive while IRQ is registered
      RDMA/efa: Keep EQ resources alive while IRQ is registered

Li RongQing (2):
      RDMA/uverbs: Fix potential leak of resources->collection in flow_reso=
urces_alloc()
      RDMA/mad: Fix receive buffer leak when PKey enforcement fails

Linkai Gong (1):
      RDMA/bnxt_re: check create_singlethread_workqueue() in DCB setup

Michael Bommarito (1):
      RDMA/rxe: insert mcg into mcg_tree only after rxe_mcast_add() succeeds

Norbert Szetei (1):
      RDMA/rxe: validate access flags before swapping the MR's PD

Or Har-Toov (2):
      RDMA/mlx5: Remove warn on missing representor in query_port_speed
      RDMA/uverbs: Fix mmap_lock/disassociation_lock circular dependency

Quanye Yang (2):
      RDMA/rtrs-clt: Fix CQ pool leak when connect is interrupted
      RDMA/ucma: Serialize join and leave on copy_to_user failure

Ryan Mehri (1):
      RDMA/rtrs: guard against null kobj name

Shuangpeng Bai (1):
      IB/mlx4: Fix use-after-free on pkey sysfs registration failure

Shuhei Takeshita (2):
      IB/hfi1: Resolve the credit-return buffer through the send context's =
node
      IB/hfi1: Fix the PIO_CRED credit-return mmap

Sriharsha Basavapatna (1):
      RDMA/bnxt_re: Avoid exposing umdbr to userspace

Weiming Shi (1):
      RDMA/rxe: Restore HMM_PFN_WRITE check in ODP write paths

Yehyeong Lee (2):
      IB/iser: reject a remote invalidation of an unregistered direction
      IB/isert: wait for deferred control PDU completions before releasing =
the connection

 drivers/infiniband/core/iwpm_util.c            |  9 ++---
 drivers/infiniband/core/mad.c                  |  3 +-
 drivers/infiniband/core/rdma_core.c            |  1 -
 drivers/infiniband/core/ucma.c                 |  7 ++--
 drivers/infiniband/core/uverbs_flow.c          |  1 +
 drivers/infiniband/core/uverbs_main.c          | 25 ++++++-------
 drivers/infiniband/core/verbs.c                | 12 ++++---
 drivers/infiniband/hw/bnxt_re/main.c           | 10 ++++--
 drivers/infiniband/hw/bnxt_re/uapi.c           |  6 ++--
 drivers/infiniband/hw/efa/efa_com.c            |  7 ++--
 drivers/infiniband/hw/efa/efa_com.h            |  1 +
 drivers/infiniband/hw/efa/efa_main.c           | 33 +++++++++--------
 drivers/infiniband/hw/erdma/erdma_main.c       |  4 +--
 drivers/infiniband/hw/erdma/erdma_verbs.c      | 18 +++++-----
 drivers/infiniband/hw/hfi1/file_ops.c          | 23 ++++++++----
 drivers/infiniband/hw/irdma/verbs.c            |  2 +-
 drivers/infiniband/hw/mlx4/sysfs.c             |  4 +++
 drivers/infiniband/hw/mlx5/main.c              |  7 ++--
 drivers/infiniband/sw/rxe/rxe_mcast.c          | 50 ++++++++++++++++++----=
----
 drivers/infiniband/sw/rxe/rxe_mr.c             |  3 +-
 drivers/infiniband/sw/rxe/rxe_odp.c            | 16 ++++++---
 drivers/infiniband/sw/rxe/rxe_verbs.c          | 13 +++----
 drivers/infiniband/sw/siw/siw_cm.c             |  7 ++--
 drivers/infiniband/sw/siw/siw_qp_rx.c          |  2 +-
 drivers/infiniband/ulp/ipoib/ipoib.h           |  7 ++++
 drivers/infiniband/ulp/ipoib/ipoib_ib.c        | 12 ++++---
 drivers/infiniband/ulp/ipoib/ipoib_multicast.c | 16 ++++-----
 drivers/infiniband/ulp/iser/iser_initiator.c   | 16 ++++++---
 drivers/infiniband/ulp/isert/ib_isert.c        | 22 ++++++++++++
 drivers/infiniband/ulp/isert/ib_isert.h        |  2 ++
 drivers/infiniband/ulp/rtrs/rtrs-clt-trace.h   |  2 +-
 drivers/infiniband/ulp/rtrs/rtrs-clt.c         |  8 +++++
 drivers/infiniband/ulp/rtrs/rtrs-clt.h         |  2 ++
 drivers/infiniband/ulp/rtrs/rtrs-srv-trace.h   |  2 +-
 drivers/infiniband/ulp/srp/ib_srp.c            | 14 +++++---
 include/rdma/uverbs_types.h                    |  2 --
 include/uapi/rdma/bnxt_re-abi.h                |  2 +-
 37 files changed, 240 insertions(+), 131 deletions(-)

--=20
Jason

--NJBR7btByq5qizc/
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQRRRCHOFoQz/8F5bUaFwuHvBreFYQUCaqf7CgAKCRCFwuHvBreF
Yf2zAQCWHxA34KBKiEN4HNVscPodT62Jm9PjLXtE1wLqJf4rDwD/ewF66iPWnKkd
lrir1BG+sizp63JXQNqFxKOPRULM/wA=
=brns
-----END PGP SIGNATURE-----

--NJBR7btByq5qizc/--
