Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azon11011002.outbound.protection.outlook.com [40.107.208.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D3D3367B7A
	for <linux-rdma@vger.kernel.org>; Mon,  8 Jun 2026 18:27:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.208.2
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780943246; cv=fail; b=E2G2i8tOM53xMFOmdGkvY6dVyouf4nUVe7IM27xxAOvQyaeXrdcnNUdoPDXCPabLt1lrHgkgG0TFNeitv99lf3qZk/mnQRTdCIw/CRwS7J7LPQVXRX91NUsBaLjzrxSAGidJ5ybpZ4iPLau7N31O3atikCxGZtz7faew6YCtd70=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780943246; c=relaxed/simple;
	bh=Kh7q0zgSTADeyP/FiO9UT6OdSObQFvhefhIfPThLPZw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=DTUCaRa6QPkk8zGbO3GnbN63K+pUDiiIyzJvOhSwNBuJzP//RofZ2fblBNj1Tw4PvP3v/kM5Y2uUK7AozSTAjzg4pqWAholrgJg316bjT9Aotfy0SFDp39uMf8DCAcg+S8xfF5PZgDMlCQKSnucCuDMm6xR0QlKVzbG+E/Av9MY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=WnTqjeUR; arc=fail smtp.client-ip=40.107.208.2
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="WnTqjeUR"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Z6JSMNYigEt2sombZ1s4UdW/ZF4Nsy3sH/IZQBon60nOPnXgejgWsmhTkasOlvFYZGUOybdyD/KUpAYBjC4Ep0OZZdysCFR+wcZbpy9qQg6YfxuzGbs5wzyKm9YJzlfqdIQXLaN81SOiYHyMFJzf7U0wEHCGqFATWxlOh7q1z++67KzEQ9GtQMS0XOXLn8JNTXoR/9zlB/oMu+/FMx1xpPZjfCxZIJef62gGR3/z/uZNUruD3ZBxqvVKsHMj8SYS8we+Mr3AAdc1vUOUNgOV3Ar2nvVXmJudTKWjTbMxpn+yCp7QFC+w4EmjwqdL97spnPTtt2PTY1XXPjptk7g8ZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=M6ZLXamszqw5ZUrEfa6ZtuPXd6Jvu8wpHxmtRvV9vVM=;
 b=qaQFQGL3QgFGjWjdjo5cNS40sa326V52+ekKaK0t7mBrKgBazYtGNyshDxgWHK06wIbDgD8kEYbzYI/62oPR1GTiOfyn6IDhworwFEHlZEIVG5nn/B1cZuIyqNPSLvV02ekK2AV02rYtdx/yxBf9c0m4fxfYLcCLT3knhd+1wF+RmUgvxzskJHqiBRJ9pIYMMZhJ3SuDM1+hvODKRlI6C4+lMUAL6LfXCEaBXtPn1oH6SN/JZ5s46YxaEkqAAXgd+WX4FUN7ZTO2P4bd80yEDfeHLh7EgijCmLPTQCKdxVCIVpT1blyGqU/U7D+/pm1l2b4IR4VuQUneosPJjoeU+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=M6ZLXamszqw5ZUrEfa6ZtuPXd6Jvu8wpHxmtRvV9vVM=;
 b=WnTqjeURfMCsbORvtbOP/cvmjetONDTrD7NDFZ2KsQHM+zLAEciSMHqk7qRbYpztnDyeAstJWR/FMxN5ZZQRl1WEJs9z8jQx9ZzjGL3DRcY4TXpC40zjP9bAxIiWbXNwsraoJVtPJDefwo6h95tUlZ04DKA0pFWQlXotDxxA5SFRIwNX4eFp9Gr1tixJhMtepMN5+nuBGlGBVCdKv3WbTuA8EOYeZoanFu0o7W4XKrCrSFD9uKYiBGQT9v8DHiLlfloDD1wQep1jjV+uJwA4WuvmzUOduK6XRaWwggjv5XJbHr78RtI2MefiU35Y+BzLFaeza368fk/Awz1TAaCwIA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by DS2PR12MB9751.namprd12.prod.outlook.com (2603:10b6:8:2ad::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.92.12; Mon, 8 Jun 2026
 18:27:20 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528%4]) with mapi id 15.21.0092.011; Mon, 8 Jun 2026
 18:27:20 +0000
Date: Mon, 8 Jun 2026 15:27:19 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Aurelien DESBRIERES <aurelien@hackers.camp>
Cc: linux-rdma@vger.kernel.org, leon@kernel.org, haris.iqbal@ionos.com,
	jinpu.wang@ionos.com, gregkh@linuxfoundation.org
Subject: Re: [PATCH] RDMA/rtrs-srv: Fix integer underflow in process_read and
 process_write
Message-ID: <20260608182719.GA92631@nvidia.com>
References: <20260608134802.5019-1-aurelien@hackers.camp>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260608134802.5019-1-aurelien@hackers.camp>
X-ClientProxiedBy: BN0PR02CA0059.namprd02.prod.outlook.com
 (2603:10b6:408:e5::34) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|DS2PR12MB9751:EE_
X-MS-Office365-Filtering-Correlation-Id: 2eca6ed9-9e8b-44da-f038-08dec58b939f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|1800799024|11063799006|56012099006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	oEUZUxjYyi2fYnPIpxO+p0hfDQ2mklXF10DugitCfmhLtluPtQsoLQJazPeEEoE0bQ1MSmeV0unB3bGy5au7gkg1HreHQpnSkRK9UR1/PRw0peSMrc69TcWXBn0++BUSg8j2hKMzU/5xgICLGxwNxLeQ20tpmiR/2wIMpfJhNcJQVAqZQUrfsAV1fEAGDTd9rY0BK1foeJYDzRhTCfWgoUWeJIPw9+veYwYac/DhojZtqOHmcJyyrBUCbfygcuWHKc4VYfbobTWQ/3m5jx3pCQqalskoGfOu3Hhc5HWPPmwvpkJuygStEHi6ivkse1iYHc1XaGZwFncG5Ok2iC7QW7knyzV1k9qa3cPA3zz/t2Ffh2f0bPb1z4WkC8cjDcNAIl1s2D9McZ3k4FdxRsxesW/eUIW6YN0Mydpf7ONhnA/YPoFvxdVwSlfgjQCmLW9sV8XBIkOX+Bm3Ju4vUkzVplxznNe57cahcHHiFG1lLJXZYYDFVibK7jhBW33kXes8nEsaMa2sWHolOkrUlNm1cIggDp3CpHxBk3pP0eI4K+5JAiBy/Qs65UNc2sGrVQ6B4Fd3LYFuyrsB2wZG4eamU+QFR4Vd8TJWPvvkMSBSCH1f7gy6SgZ/+2k2FJN+wsE/uTujWxgEc1ktcpu2XIVae2ugw0yMRpRuQ19xlMykC2k8jeQKIxneCtnwuMlt0nc9
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(11063799006)(56012099006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?pZF1XUKIE9bbCTeFpb0JHIvtu2EFJLKgeKFrJAVDbL6H+9euns9paKys3vkX?=
 =?us-ascii?Q?cFG+BSEmpK0gvyUWy+PqbbtkGTeDegVlXJyqcZPmMaIRLE42M9waK3JtUAOm?=
 =?us-ascii?Q?whgscZGV0cKYuajm9+yyrsSoTjrL21Fn1/batvIeoAxway7srawd3Mhx2Dxm?=
 =?us-ascii?Q?f9HenUSozVa9ICOloOoD14rP5dO2IwA7iAOk6zBzzhQiU/FR0Ble6uHqm4Wc?=
 =?us-ascii?Q?XI/wYLDKuI7M+BQYHovMt68nPLuAg8YnCbiyiflRcu6Wdkj7KY4sGWHEJ1UY?=
 =?us-ascii?Q?r8oAwBNRYRrcldN1DLVx0u4lfdPtSAcT/1mLXcE7unrVmf8OOA7xOvj8X4Dl?=
 =?us-ascii?Q?j18cQwIETrwov4bvZyQmZQ05d62VKhAV0Gj9DB1pl2vT9/D0QCRWmBLMWlmo?=
 =?us-ascii?Q?xe9pnY2pphuGfNpQBi/607mUjORaJW5f5kadfJPE+cUsEXmlXB9LX0BA04RE?=
 =?us-ascii?Q?mKCofk5ThhZ28cZnhPzPMEfIoaunya4voIRLcDppH8X1ZF9xbFr56SP/Ntiu?=
 =?us-ascii?Q?gBftmfP0OM8EIfLIF10bQgWc0PAlrKhOrUhgLA7HXGC1RAtcakFwPq861y8S?=
 =?us-ascii?Q?Tojn09qwBBRs7Qu5GjtHCV/oyLzDMqfA969rumbAaWV8EiDxbv/fEMNZ72qz?=
 =?us-ascii?Q?GW55SatExbe6JczSlrASgFwMnKqNYp4GOTaOSaQBR0IsJ6nJGOKUUFYFbsF2?=
 =?us-ascii?Q?r9jheq+rOYuPVB3g+QeZHwNEfFQoax8MxnmJCOPrsWpG89vGmLbBu9aYfqvo?=
 =?us-ascii?Q?B/yizBc/cdm8RSEPcSg+xtwnQQjol2GLVJ9InCYjBkukqtOSq4ZknyLEfQBQ?=
 =?us-ascii?Q?1ZoPT9GLafDj6rODv/3npi72t1eGjw9RE8NvnMhQi+E8Y8k09eehrOGb8vLJ?=
 =?us-ascii?Q?8V8rdKT1nIeIOlts8pF8i3bNKGS9eSOFrpWO9LkaS9TVUyOa1t7PdZ5HjKNn?=
 =?us-ascii?Q?2kbI0CqEgKUSuYx7HFqwbtfSqlyIMelBVuyohddb7Ue7mKu0PsXnbPVC00nS?=
 =?us-ascii?Q?uv0a37ZKmxwyyTLYMJLCQ3s29ufuyO8oMlsbkcYSRTIjZS0ssfdImoaamPzl?=
 =?us-ascii?Q?b1OhsQbs+x5kSaAOGwQJQcS9pkz/Qba+5TmZrDcpEcF2NYvCFlZQEtoHQwUH?=
 =?us-ascii?Q?DQAt0zr7OtJwrFqXfZ9rggBjTmxEKl0brPA96U6RsrP3ZQnfwYHJLD7E8aTe?=
 =?us-ascii?Q?+oYRja8R4C21hnnCTkOz3Oh8qqKkxswQGNqxXEaFderJMz/y5uSkhGokeRdt?=
 =?us-ascii?Q?iFqvXFienW9Wtay8Lo811SHJ3hJVxAF8kk/61DxhSCyR8I90jTIhd4YfQchQ?=
 =?us-ascii?Q?/AQECcGL6Bk5DN/e7E2p2441CzOgnxUebqJPAPqip5ZIkXW6kTOfTiMgabSq?=
 =?us-ascii?Q?xBSoYIjT6Jjnb8udliyEr8p1sW7igL1pEWjNbPBWei0xGU13++HkwjEbjvrC?=
 =?us-ascii?Q?/zgbMdw5Te09lWceWME7xiUe4FSgvKZxVEYgknI9Yeh7EJvl5l33KuvjgO6d?=
 =?us-ascii?Q?THsRecKYr9HCwztQDZ0gmH5f0subKi3ybXQiRBEOvU37JzBKmTgDjFbBbtvV?=
 =?us-ascii?Q?FsnHqWETSWh16dkWBtz2Ddw+0L5007/W/g99WGK5TmrMhc8BdYR4qIRgJM7t?=
 =?us-ascii?Q?EP+9uxLyjzpCElRUJ5+eOsfXby/RFT3sjSObZ6LQPnfwP5cf3J3u3A5SdDhw?=
 =?us-ascii?Q?76CBAkiwz555YsQCjzd724gfwA5zVnSueoF0XyXwLtL13QW5?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2eca6ed9-9e8b-44da-f038-08dec58b939f
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jun 2026 18:27:20.2731
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: czvrXw+vklAC6lW6NEcrIy6E4+HPcSlr7pYEEv39Ixn+LKXN9YMYbfmY5tlzxmkE
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS2PR12MB9751

On Mon, Jun 08, 2026 at 03:47:15PM +0200, Aurelien DESBRIERES wrote:
> usr_len is read from a network-supplied message field (le16_to_cpu)
> and used to compute data_len = off - usr_len without validating that
> usr_len <= off. A malicious RDMA client can send usr_len > off causing
> an integer underflow, resulting in data_len wrapping to a huge size_t
> value which is then passed to the rdma_ev callback as a memory length,
> leading to out-of-bounds memory access.
> 
> Fix by reading and validating usr_len <= off before rtrs_srv_get_ops_ids()
> in both process_read() and process_write(), ensuring the early return
> path acquires no reference and has no resource leak.
> 
> Reported-by: Aurelien DESBRIERES <aurelien@hackers.camp>
> Reviewed-by: Md Haris Iqbal <haris.iqbal@ionos.com>
> Signed-off-by: Aurelien DESBRIERES <aurelien@hackers.camp>
> Assisted-by: Claude <claude-sonnet-4-6>
> Acked-by: Md Haris Iqbal <haris.iqbal@ionos.com>
> ---
>  drivers/infiniband/ulp/rtrs/rtrs-srv.c | 12 ++++++++++--
>  1 file changed, 10 insertions(+), 2 deletions(-)

Applied, thanks

Jason
