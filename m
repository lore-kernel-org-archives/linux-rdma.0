Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11013010.outbound.protection.outlook.com [40.93.201.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C48B2BE65B;
	Thu, 20 Aug 2026 13:52:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.201.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787233931; cv=fail; b=Hvws7lC48A5GI+EANx6sBFsMd/BH6LuIVl921ubSmqV73I/2z7euonVckHUsNxpMpeTydUtXi9lix41fBYy7tMfvXuRuH6U5MyB06kSpIHoPeiJlWTh3fCZwK3SwHY7dAjSbNv40UUmnxjrNKsvt4lWWSv1bL081B8YBG1PQCeI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787233931; c=relaxed/simple;
	bh=ExLUYyi84xReqyWWfjM1vLH25BLC2ap6OLlIpk6gNUM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=h+m6wqwTGAXie/l2DKRLopBoQJHt/U0mjRyCFOuuciL+071sNnf9wMccRTjxC2jGfCCoxGf+2wtHQWsHZsN7+J9sABpMRp+tu7hvngfH8dlPpJ/gx/HP3dsKhGQZrclDVcMEC2cx2R4kDl2NdR6zEaPd9meReQSR2LHGUh4EmbU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=ThDhZue5; arc=fail smtp.client-ip=40.93.201.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="ThDhZue5"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tg0DM9HYZAGTg9HOWhqV1aXZgxrXZq4F996sg8UynrQytrLMzDmFu/12JpMfjzDCfpogCorRJT2GKh1dwAPNsQbtjvnNUAd5xy8/mhRdZl/C8b4hShKjbiLbIXiGIlDTj5E+ld8/dZyJiqnb5Eof0kKDGBJL9MnFTc8LW/vrZg/GiW0xDGZ+AwYMHnu8z2UUARwJe02DmD3PkWRAap4PMtCMRrMG8jjZcZVNXNWwWSPWQvS15DLsreS8q3WX947SahwZAdjOXXpyT6OWTd250XJH3WBYPF70IllGJtmPD4ihPrxRvxIf4inULY0+l2mvOnb1N0sSwsNAy8BJmSezZg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=e8k91gMu8WJp2f6KNS3Xg73Ur6icGOiuTdL+CSpKaQw=;
 b=F9lQBLNEApxWwfVjRo4NhkYPh9ePRHAjSvhJFUb3HEf5Jfam8UZ8LI3OIwE/6QWUkN0b8otEW1WG9MMgKIzFFxR5i2UieW92Ge8/lMw33K/r7PlOv/lTWH/EUqcaj9ZChOelxgim9HLUuoQpyfRIpaNwux5VzAxAXbFcI5FTG+wyR7UX9eo5CYtiOol6HkbImjaAjG4UzEtbUSholPlKLasEYg0/n7bYqko6eVKYVZ8cXBHOuYzZVa2Kvewp6Sww+li8rHoiwpxEi1+52GcYz17bdEqudlUHtIrNPYQ5rjxA42RuRSxu3STbn3Si2XSuGvqeDrjZAQkDnHM8Sce7YQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=e8k91gMu8WJp2f6KNS3Xg73Ur6icGOiuTdL+CSpKaQw=;
 b=ThDhZue5nC2MYysXxY7y8kJO7BFzHszVFIF/HZSD05ZnEQXhPlCKrPpFB5n79RlObqXRWt6s8SRd8wKXW3EGUSHTj4ogFuZ3pNnl9YUfMixRRdHZq0GXuTjd1sco0bpJHPZbHclhVVW0Y0HApQii+6xCyNsxZ9uI8HQrxHAwdwaNEs3TjgKouI6frXTQv8Re1NeUPaz8ngGRUhYiDQC2uiyT5qVWaTrQwZ6lFlElTJSvuVX8xPZbh9ITXi/oMTpAyIu0ndtfxwuNmnOY9X5TqVsPBoIZ/yvxVkzwrnAROgv7gzP5r1rrU0hdDOk3gAFhnsDWreTPD+CCskmmPW1fPw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by BY5PR12MB4049.namprd12.prod.outlook.com (2603:10b6:a03:201::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.315.17; Thu, 20 Aug
 2026 13:52:05 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0339.008; Thu, 20 Aug 2026
 13:52:04 +0000
From: Zi Yan <ziy@nvidia.com>
To: Kiryl Shutsemau <kirill@shutemov.name>
Cc: Qi Xi <xiqi2@huawei.com>, akpm@linux-foundation.org, vbabka@kernel.org,
 longli@microsoft.com, kotaranov@microsoft.com, jan.kiszka@siemens.com,
 kbingham@kernel.org, surenb@google.com, mhocko@suse.com,
 brendan.jackman@linux.dev, hannes@cmpxchg.org, linux-hyperv@vger.kernel.org,
 linux-rdma@vger.kernel.org, netdev@vger.kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, sunnanyong@huawei.com,
 wangkefeng.wang@huawei.com
Subject: Re: [PATCH] mm: drop stale MAX_ORDER references
Date: Thu, 20 Aug 2026 09:52:03 -0400
X-Mailer: MailMate (3.0r7024)
Message-ID: <AF9812A4-550F-4E3A-B67C-EAF6F9F56982@nvidia.com>
In-Reply-To: <aocAePwuxr4te2jG@thinkstation>
References: <20260818122408.4182417-1-xiqi2@huawei.com>
 <aocAePwuxr4te2jG@thinkstation>
Content-Type: text/plain
X-MS-Reactions: disallow
X-ClientProxiedBy: IA4P220CA0002.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:208:558::13) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|BY5PR12MB4049:EE_
X-MS-Office365-Filtering-Correlation-Id: 9e0c0c47-17f0-4e81-8dd7-08defec237be
X-LD-Processed: 43083d15-7273-40c1-b7db-39efd9ccc17a,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|7416014|1800799024|366016|376014|11063799006|10067099003|56012099006|4143699003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	tJPY4qBQScn3eCeb6OxjEUYxSOFFqFtHxELSs1b8TqiNLeTuJBFqo2c3ae1bCPuIZCdYTiHDfh0UxK5wdBtxi9gd0Bg1xi3mCHDR3KXE5LdDkr12yE+bx2cwP7NKQK0vcP1F7QceShfsuj3CGlxUMY2FBk6KaL4Rm8Lhan2ZBr2x6xdos3LahLZb/ly0L6hkbERmtsANmVdl0HgQ3OrDWWJV1OBJoH6/ipX3HRxf5pEf0nfEPkSpDxuOyN6o3BaoM/urh9eaFJSFnZtCpPJjMzuw1HUQs27SZbd3cf79l9ZjpTIJuzgQ9o3poXtAhxnBUQAISzORVNfZZPcf7SoLr/k8VmdhpftyXVqXAnIpIgh3tiPTw3xGAvoYESa5/ausELFh8EwNmFusqfolDp/2gt6R3Ak3M3d385J9zQmu7t2SjRuGpIEYVqh5myRXXFWuVluXEtHa7MO8Nw/bjdv/pfvFUe9JXPL96bl7SMjQ20s5wIPnVrqYkyLUcQA+EEpCeyeVGtpa6wAkF7rbIenZZ/ft8nHh+zmRgpK20/EDZiJFeDU2Fh0xH1JwEidAfP75xRulfOGpAaV/MZoDOJatJe6xZT+MIXCFvWnsyDSDp4VbRAhPLS28Bw387oSuoHF+84+dF/Vg2G0tOmuFtAjpCAckXlXiMu49p5tw7cA572E=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(7416014)(1800799024)(366016)(376014)(11063799006)(10067099003)(56012099006)(4143699003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ZckewxLex4Ttjp3NnL8QsomnsTssyoL+zKdb9aX2aBnZmLrabVHhgfmE8Fc7?=
 =?us-ascii?Q?UnnY9qwy/21mt6h2RXnnEpXo21J8tNDXOLtAGyL/1ACA+d73n9tM3OWSW3ZV?=
 =?us-ascii?Q?Jj9GCE1vAkD2wSKH2a7zYGNyv8xGLPWDD/dXFj7gFEFaMYv8OEiwbpDJBOW3?=
 =?us-ascii?Q?mlGSdm8hkDwbyPvelDsaVOTAk+zf/3CTHgbsJeDs8yiFs7170wwVjPPxpOf7?=
 =?us-ascii?Q?3QvXDxxirSbVIPDD0jgyHm9I4MlueX2pZsH1NkqIfb0fQRUQ1t+laqLcOqKU?=
 =?us-ascii?Q?oxgZcOO6ltZuMjGMKQiFH6XnpaWHBXTrPSxGRE1HzLJ0LE0xDCHD0Oz9RAw/?=
 =?us-ascii?Q?Ws+P1YVgvsW7EytysQxYD1LC86CsKgVLFdrPQ1Y27Hgm62Usxqy1EuItmMBg?=
 =?us-ascii?Q?ckb4boKBi9o4DqaU7t156AKoqIiyKi6UO2ysD1mBBIQERw21RGpFMqYz9FA7?=
 =?us-ascii?Q?jgePyIXRmraO9J9n6hGlpBuEvnd/yrxNHdQOWgWnmRZLwZ8tiwYSX0qk6/0U?=
 =?us-ascii?Q?z/RzDyiRk/rS/wdAGgYUSZF1qzmoeGokM+4+9GefAi21LKTe+vK17iVt7jkZ?=
 =?us-ascii?Q?F1M3l7Myz2I9/eqJy4UOs6pKGrdkuyMY5w/sZZ3PwM+mhEuRLCB+fzIy1/IE?=
 =?us-ascii?Q?D8ff3Hbim0DjjW0rzDsuB8qm+poLP9IjfTtK34gvbN2KOmqBcjzVoPq4fJ0A?=
 =?us-ascii?Q?tAQZwf3YMlGdLQU6yZSivkVN25DgOOrUYyRmUiRwIELs7WU+LDE9ST1Wlee4?=
 =?us-ascii?Q?WaefhtFYRNK5kf+Ue4sKqrw6nA7lCwBybEAaXhjcdMEZrmU1NQ8npWM047Pq?=
 =?us-ascii?Q?Gl3jfrth/vl3fx06dl+Kd0a0Y+2p6J9nKu+CeuLtMkDSz++TVRV5Qcp6Zekk?=
 =?us-ascii?Q?Ck3TsB9015QpMPpNmz8Ba2171Ttx5G5oyhiZefbia/KT7w/JTyNiu9jZK9mx?=
 =?us-ascii?Q?YQFHjthVNkacx4IjBNOIblM0HoDw3GH7P6EACtMV89o5hTwzBdrndmM0Newc?=
 =?us-ascii?Q?e0oS1K4xoTaw4wBxijELtuiBJVNqDPo/3txABN9qB96CXnkOP3IdNl0stg/W?=
 =?us-ascii?Q?vTD3d7r4L4jUWqwZ9mvTKyd4y4B90bINzCR3XLw7dq939KeJjvc4fh1s3koE?=
 =?us-ascii?Q?cxG4PDHMO4xFm1mkJcMhaiDNEoFgpG7m+nGh7Ht2ysruOFYxv/ggWGqHHM+J?=
 =?us-ascii?Q?xzn+56dl+cPHUeM20FDy3pByw+042sq78+WXa6JrL3zAn98wL+dxxCM7kb0i?=
 =?us-ascii?Q?ytQO1Mkh62iCbbRaAdzl6qmHzko66Tf5x0S8XFmM4u6mXtBIQ2yhVV3vlTvH?=
 =?us-ascii?Q?LoeTYa1EPjldM9FhB3r+Nitbz7HpwvCBBlGS+n5bPpQdmYCFXedbVdVTMZBv?=
 =?us-ascii?Q?CUTwP6h52RDnBQOPduY+wiDxakbL4oLlfXBIXd6iAc/f+gCwKlLHs2RmGfx8?=
 =?us-ascii?Q?hI6JAX/VUop6HsHWoYQV1qrWGe8aC9YCvgs8fLl6q6Syae5zXtMRmtAUznb9?=
 =?us-ascii?Q?oZ+49Y0DvbJuUV4oC6D23S2slo7XXkk8TiZcp3IZrmzsQ9gwpCXL29RyRFVR?=
 =?us-ascii?Q?FVFRh7c7VPV539SwBlpkbssTwkMPBNV/57z5Vl3fHHtAGLUuyi3y5cqxjf5k?=
 =?us-ascii?Q?QxjBLgiz1aNFWTS5T+p3I26AA3z7qBNsOVN5e/tZDMcV5A8yP/lIq2gg1gdp?=
 =?us-ascii?Q?0h2bAVpnd81Je0bwKuRWyzp8UmchebmqqR5LVAA5bsP6rrBx?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9e0c0c47-17f0-4e81-8dd7-08defec237be
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Aug 2026 13:52:04.8080
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jjAvoAKZSL9yOqzQU5S3292YDCZnbMA29GE0O6B2Hg7rittGSdE/xLKxrFJg1ovl
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4049

On 20 Aug 2026, at 9:27, Kiryl Shutsemau wrote:

> On Tue, Aug 18, 2026 at 08:24:08PM +0800, Qi Xi wrote:
>> The treewide rename in commit 5e0a760b4441 ("mm, treewide: rename
>> MAX_ORDER to MAX_PAGE_ORDER") left a few spots still using the old
>> name:
>>
>>   - two comments in include/net/mana/mana.h and mm/page_alloc.c;
>>   - the gdb helper scripts/gdb/linux/mm.py, where self.MAX_ORDER is
>>     a local mirror of the kernel's MAX_ORDER define.
>>
>> Rename the leftover instances to MAX_PAGE_ORDER so the tree is
>> consistent.
>>
>> No functional changes.
>>
>> Signed-off-by: Qi Xi <xiqi2@huawei.com>
>> ---
>>  include/net/mana/mana.h | 4 ++--
>>  mm/page_alloc.c         | 2 +-
>>  scripts/gdb/linux/mm.py | 8 ++++----
>>  3 files changed, 7 insertions(+), 7 deletions(-)
>>
>> diff --git a/include/net/mana/mana.h b/include/net/mana/mana.h
>> index 04acb6791dbd..1d5bed71d6a7 100644
>> --- a/include/net/mana/mana.h
>> +++ b/include/net/mana/mana.h
>> @@ -40,8 +40,8 @@ enum TRI_STATE {
>>  #define COMP_ENTRY_SIZE 64
>>
>>  /* This Max value for RX buffers is derived from __alloc_page()'s max page
>> - * allocation calculation. It allows maximum 2^(MAX_ORDER -1) pages. RX buffer
>> - * size beyond this value gets rejected by __alloc_page() call.
>> + * allocation calculation. It allows maximum 2^(MAX_PAGE_ORDER -1) pages. RX
>
> Should it reference MAX_ORDER_NR_PAGES instead?

It is fixed in v2[1].

[1] https://lore.kernel.org/all/20260819082052.3338603-1-xiqi2@huawei.com/

>
>> + * buffer size beyond this value gets rejected by __alloc_page() call.
>>   */
>>  #define MAX_RX_BUFFERS_PER_QUEUE 8192
>>  #define DEF_RX_BUFFERS_PER_QUEUE 1024
>
> -- 
>   Kiryl Shutsemau / Kirill A. Shutemov


Best Regards,
Yan, Zi
