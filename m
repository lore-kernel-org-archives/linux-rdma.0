Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013016.outbound.protection.outlook.com [40.93.196.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 908F436997A;
	Fri,  5 Jun 2026 17:07:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.196.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780679267; cv=fail; b=I25pBqAPWBq/g7ojU9szSIsYM+9zaduJKGY6W+Ueqvh/zRV+mrlr4TjQJU3/qAcNxlv7j5UKP+fAgvkluYG/yfHe8Ls7kwGikU3G8eyCv+FWil0YXnC5sU4QuI1ShsxdK01qJDmYxbZIBczcCvY0B3xdfcyj+3NAQ2sl2EY4DQI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780679267; c=relaxed/simple;
	bh=tk9ZgSjSvYgH3qSMBQh3/udFB1aytb/HvFVtnk05XoQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=GJchXOnw8OV33Pi+RuMuJZltzg9E1OYKXGQi7mL/axcqa8jmnvQIgMK5E9a+RcmeMKzxAJA5Ockibd/IHKdf0MXh+8EKQBNQlK3edQ5uPyjALriaII5vvyMUOW9dyy4D/ShuU5is7kZGPlu+SL7vZVtgoSWUcE31YkMJWvTdHpY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=fTdboROI; arc=fail smtp.client-ip=40.93.196.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="fTdboROI"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NAqN8JNusRIzTxhwxdVLshYq5Oj1Gybcdt6rsDFthlUZ8cTUiGiqhRm59Xsfh9vZRJ4pVvN0HrI21ZnEIfh9cMhsnzgv9WOMPE7buQAYfHmrapzCowkiZn6tBIGklSX7MfWTaCrB1bY4miHFzRPahbaQgiYKZtX19bfQ0icj+xKvUVX5WZwjg/63CNpy1YXgTcgukmAJW55yd8GSdIMbxkHUIo+2IFnTSRJoMQQmsWwHiw7FJ0kWmW9W33DLJUeo7tfOwK/FszD0Od43ja29JFmUmSRZS9bg+lU3ReuEgBBMQJacPo1CBjmDs2UYrwmKZJRIScTG6MgRrJ6/ihIQgw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=n6WWCD+3cbEEq8UbZFbqcIIXBMoPX4yrxsOUfenKJAY=;
 b=r8zUq6/ZFhA1xishH8+mRy9FLXcklsHArC0+jJmzPWuWFR9IQddtaBTjBBSC4efHYGZeAi9RTLAmQ1c48T/zfebpRk7i/8jFzoQg74gr2pzX8X3fIURWTC3YSS+Fk4BQRx13fuDijQ3eWqpxm90jQC0LvasyX81rpctfEo4rjrdA8d87wncOsXpwvc6E7WU542LeRcbTYr3UFOZG4QB2z6wglGuzuRdIllToKuW9H+unpoI/nps9Y7H859Oa22/cwToz7perdvU1BjIyyrCzx1APf1LkuP/sUAY3e1AGzJBlfl/KnzikQzrUZBaU5nXkofsjO2TIXkyi/nq+UT2pQQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=n6WWCD+3cbEEq8UbZFbqcIIXBMoPX4yrxsOUfenKJAY=;
 b=fTdboROILKvU2SNXYFv/iQPG8409Slc4PjnnpaTKb78LHvYhA5q5OE79sgiqWuWVxXDGAt94YxZPlc9Wcvn0Q5hIISaXNsWme0ZZDv9VyGuiESXnThPLT+nR0KwFELxifJoBklZsVIekQ2eFg52oy6E84/mY6Twn+d4U9u4fW3O7vaXkvgfb843+XIPXm6Vq/JB+uytW2XKl8Isczg2MEicND6Cs8T+BT7M71DZE1xRr3SbT98eQVp6z8/KJ64K2qirSg+jQredQcOxv1ZWOJStPl6pMPqqL+WbuxNBcJ5wDVvguoKMGErM1Zt8Sg3SPNCSsslzQ2kzZCspgnIf/Ug==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by DS5PPF4A654669B.namprd12.prod.outlook.com (2603:10b6:f:fc00::64b) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.92.9; Fri, 5 Jun 2026
 17:07:42 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528%4]) with mapi id 15.21.0092.007; Fri, 5 Jun 2026
 17:07:42 +0000
Date: Fri, 5 Jun 2026 14:07:41 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Michael Bommarito <michael.bommarito@gmail.com>
Cc: Bernard Metzler <bernard.metzler@linux.dev>,
	Leon Romanovsky <leon@kernel.org>, linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] RDMA/siw: bound Read Response placement to the RREAD
 length
Message-ID: <20260605170741.GA2768320@nvidia.com>
References: <20260602194700.2273758-1-michael.bommarito@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260602194700.2273758-1-michael.bommarito@gmail.com>
X-ClientProxiedBy: YT4PR01CA0139.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:d5::6) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|DS5PPF4A654669B:EE_
X-MS-Office365-Filtering-Correlation-Id: 047c3136-f472-40bc-1b2a-08dec324f4a5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|1800799024|56012099006|11063799006|5023799004|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	q+XLmW5AvOdSTPzirLY1MNOccYx9YVFuiAxKtALuAM49PEqaKrmLzy38numcPk/JWqgynBWc64dxbPgr4+l07pkDXU8ospXtBydH5fTYI5ecDF0nz+kjEKSVDapgwHXu6Csr9d2IRRas2DMyHB/K1y4SDytfCuPhz8GdztiJ7egwHN2kAu5ujOJCdBAxFIW7RFDVd1kzyeCL2yWrIAuEzSWK5D4vv6L3Ixl6dU34iBCyvrPwI3fmnGYKFcFuQfdO4u5VIBqWLSTL6FLBYe8DzdcpDRJ89pAE0aC/6O3M2bBmuge2ua/KjmY19Usy++LABfC9b4DSYOH57PyaO2YyuZyjhjJYlwWXnuWKbkltxa+Aa3len2/tXEcWnpT5AZzEske5lcr+7rgc66TikkVrIHsF+fGh081l1X0OMqD7p6PaEGFVlvNZdmh7bITkQtSYsDfAsfQ7g2F5C9v6pp2CfXEsayqsedBgVpcdzGO1vjdqwOmgj8TXgPqESKXmgTBNUhYuudAc/1+E3uh9TeaUhkOj0/7eWDY3LNlqf8+Zk+xyul8cZH/hvdiNtPjPTx93KZDEiyDj44pSyThv1XbRGDJdGhv+50aV8IvC8bQIhNiiJ+VvKCzeUkmlFm2/93SQm9B7YBQxxOJ8Sz9Ua7A1bT2UPz7Ov0XVm89N0a8z9HkHPsdqKWqpZvVl3adhwSz4
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(56012099006)(11063799006)(5023799004)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?rirrzGQNOq0BZUeFPlE+psEgCMeUJLSBaMU1C2FyoBnmzRTgbgiU7fTnKpG6?=
 =?us-ascii?Q?dL733k3iYoy4lPB3M6KzrjqqvDpFnisJzPsezC1ouUSjmHG6dPxXKEAMujjI?=
 =?us-ascii?Q?zi9Zz07AWojLJ9efvT2uO24Pmr1cVPuaHKsoOEwUQyxFxnCUjgINt/pqVLDb?=
 =?us-ascii?Q?2vxUJM1lT8vDLzGYY7NvHbqQBa2Gpp+iurYbJleydwzAV/jMjiIi2dmcpqK6?=
 =?us-ascii?Q?o7WRXDv/6KV7tMTRm7s4+xgcVJurMLpi0US1+D1zvvScg1hE9KejjwXL3cVg?=
 =?us-ascii?Q?utdpgPhCLOk1GeSWElhZDI+ep/V2KeH3BQJk+AQ+lKak7+LeT5GB9WNqR3jP?=
 =?us-ascii?Q?Fbm/mitYr+/oNmCrzxmjVMklC9rZ/GV8csQdVgynYdUw8Ky9OPilAJe0A2Br?=
 =?us-ascii?Q?FgyLYaBLWzUCWMVuJRNk3h9SLutFjm9LPa3N4qk3UICeb9YLEyY4AJl6ss34?=
 =?us-ascii?Q?pMthECdrhyUK1paEXVg1IBZqtuHaaAWeYtum1Jckltp/anUjqHkB4BOzzKRt?=
 =?us-ascii?Q?Rg/7yGdNc+037v7bin3XBVnGGJh/cCg9k3DrjXqXHqhzXMRhgfNUlsUD1eb3?=
 =?us-ascii?Q?tuTQMYFTrSvfBtSi5UXlIy8lcb8BcM3MPsRQcTd+fDtFOcVAVO6lsJItxRho?=
 =?us-ascii?Q?dkVgxUMytLnoHwC73/xdXc1uICY/Pf/xXMXI8IE5CnfjClisBobbjEiJN+VV?=
 =?us-ascii?Q?P476fZRSaO0B27NEs9HBSBU95svXmtBzulF9Jm3OSdwu62D6qUb4zLy9mjeO?=
 =?us-ascii?Q?gw5JtM6gNEYj1pgN0aKYZrTKWg7E1+YoODv5USEkkcr3ruR6wPy4zt8wlAa5?=
 =?us-ascii?Q?lZ8DsytjF7JvgQrv2nPzeR8ab0/GlWAEEIqfyR1C7ZC5ccuQi6Ct3WwUHacM?=
 =?us-ascii?Q?+Yo2NFrho5n8Tl1y/pMQukrmSImHZJ6rjDDbDVG5c0MSjq6sQXuFzWF+sl/h?=
 =?us-ascii?Q?cJ8P2DGVTNrPAvNhKvamaEbcW4Q0khxM9bjKR3x6xwYZkzObP2fz4qvFZSqe?=
 =?us-ascii?Q?gM1IbiqhbGR180Th9Kgadcy0MpxB1HtCzUY7aPvZ871h5ILTCkY1m3lG622i?=
 =?us-ascii?Q?r7uH+v2A7L0yTMvWUd7KpXqaGoZDoAeePBzioGFgjTVvdtVdMqCITqKuZW05?=
 =?us-ascii?Q?u/FDw6bhIigNQQZ9S3uafNlb+lBzD00dwbzopOCp2yB5Imkx7kpO4EbFhiTI?=
 =?us-ascii?Q?dLX3d0cLl/3mZv9iTN7/CK6QNtZlubZnIVWv5pKF5t8dlIxz0ze4e9Yl1ZY/?=
 =?us-ascii?Q?pDDvKYngqXWGJG/8Bmoljb6UEkkiKlQUeA1vCZJT/uSNP0kL04Iekt+84Oc5?=
 =?us-ascii?Q?abNcRLZN2dc9h4JUM1kNjOYkkSNogYJryHxV97LDXGZp8pAI+ggzto96Gi2h?=
 =?us-ascii?Q?NiR2zjklGVXpcfD2rHmFshu4mTF3nMOWH9FngrVJ2sLcFhBTMc4rGGsaVUm1?=
 =?us-ascii?Q?WPcWOfdR+vihRn7qOX6GAmb0SMmt7Z+l1Z5GavMDe4YtjO4PKw2Db9mNKtEo?=
 =?us-ascii?Q?USuZSD67+VooFgb6qVP5RYRRgg73D49oczelePeDnaye8D5wbL4wMd4NoJi6?=
 =?us-ascii?Q?XqawRqLJviwY1u0ouM9Fva+KO9Rv5lVZgg/i/7QqKWrPukS82qlfX0J2sxmm?=
 =?us-ascii?Q?XnyBZl9AHVTjtWLtKXV9nDXm59XWo3rdj8qVCn2ezFRMNIOFpMgsOlIyDDFh?=
 =?us-ascii?Q?rq5faz2BQUqppQzW7xE99YnIiIf0Q5+fOjdCiKDNDdM6kGPf?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 047c3136-f472-40bc-1b2a-08dec324f4a5
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jun 2026 17:07:42.6245
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iMMYllbKjb4ZsXtSGufX2I5FHCXw9fYiUTiIIsPtTT0FN4EnNwIYToGIIqyb+Pxg
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS5PPF4A654669B

On Tue, Jun 02, 2026 at 03:47:00PM -0400, Michael Bommarito wrote:
> In drivers/infiniband/sw/siw/siw_qp_rx.c, siw_proc_rresp() places each
> inbound Read Response DDP segment at sge->laddr + wqe->processed and then
> accumulates wqe->processed, but it never checks the running total against
> the sink buffer length on continuation segments. siw_check_sge() resolves
> and validates the sink memory only on the first fragment (the if (!*mem)
> branch), and siw_rresp_check_ntoh() compares the cumulative length against
> wqe->bytes only on the final segment (the !frx->more_ddp_segs guard).
> 
> A connected siw peer that answers an outstanding RREAD with Read Response
> segments that keep the DDP Last flag clear, carrying more total payload
> than the RREAD requested, drives wqe->processed past the validated sink
> buffer; the next siw_rx_data() call writes out of bounds at
> sge->laddr + wqe->processed. siw runs iWARP over ordinary routable TCP,
> so the peer is the remote end of an established RDMA connection and needs
> no local privilege.
> 
> Bound every segment before placement, exactly as siw_proc_send() and
> siw_proc_write() already do for their tagged and untagged paths, and
> terminate the connection with a base-or-bounds DDP error when the
> Read Response would overrun the sink buffer.
> 
> This is the second receive-path length fix for this file. A separate
> change rejects an MPA FPDU length that underflows the per-fragment
> remainder in the header decode; that guard does not cover this case,
> because here each individual segment length is self-consistent and only
> the accumulated placement offset overruns the buffer.
> 
> Fixes: 8b6a361b8c48 ("rdma/siw: receive path")
> Cc: stable@vger.kernel.org
> Assisted-by: Claude:claude-opus-4-8
> Signed-off-by: Michael Bommarito <michael.bommarito@gmail.com>

I made the changes Bernard asked for and applied it to for-next

Thanks,
Jason
