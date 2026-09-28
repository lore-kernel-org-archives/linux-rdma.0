Received: from BN8PR05CU002.outbound.protection.outlook.com (mail-eastus2azon11011046.outbound.protection.outlook.com [52.101.57.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 804B136D9E7;
	Mon, 28 Sep 2026 18:27:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.57.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790620077; cv=fail; b=e44QPyBlqW3cGJIE2nd4w+qMaIGraGe0UtfIA62L/rdyzcP3cZ8F2hF1WhMyp94APgt+mprewlEUTDdNVjfus/O8Cv1j0YOkZyFrKqoD48L2PSvYS2+jOVnvYRgo+3W34OMKmHRmm4dvKbud2AEDOt7Yt6J2yAN2Reo/cSPbqV0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790620077; c=relaxed/simple;
	bh=Cz5FDb+fzI5BXsZNFTbhgdRaKn9mAayBVN7lbcNWk80=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=nX7kKzR/DPlT/Fp8dsVB7C+x9MDKRAvL1YHxa76NDC+3ZknMdzmPRAsgZOwpOeJSQxQtHls+CXnANP9yG6NHPZwMEpb9L+sRFFUiaLGKwAguWELSvJXQ632GNQ1lfA83u7E/iy9KJ8evsLiAxLCRc/Bm8rG8csm3vi747NEz/tw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=AFAeTFWB; arc=fail smtp.client-ip=52.101.57.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="AFAeTFWB"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LNw98uG25vjgtZDMfDR5e7dvTXkBuhhq55L5+q8V3A38BboH9tvIA579YIY+B3gtMIRzPEFWDWSRG5r2XeoNHdN/uOatkT0azPxOR/JMsy+/7VbACAOYt61iHKrJIvsc/eP0MoXMOPVvBPvfckg6AGEMOC6mqD4zzbFeCOr7JUWGYCi2iI27D0lVhlNafAr7bmAXKAtOFU1Aais+JaeFL+24dQUtnWRlFLDygRNQkFtKCHMEsUO4Km3M2yqofQztO/epGy0bD/9jotchbheWYamgr8Y0AyPy30ofjtvL3zEV55NWHnLMv5i/2zFlEynUW7qmP3MMxKyQoTBs+4VBzw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IBY4Aa9SUg1peakQUgbYzif4wUNENze6bpiX95QSwr8=;
 b=oA7c6wgdlM3Ol7F17LOjc6Qi3SEeX55mVtQ9R3VU/HDlT0zmPG+oCRQXaDBluVA2g0XqDVQyZJO57NER8veqKaLw04ZQP26Kj9GBqL9V5yRu9J+ZpLHnzkcvkm+AS4pmnNLz0Jp8JvHO0cp/LvtJCG+PLocwTFl1aii+BdhVn967PqL0Lr8Xy4qU8dKRdd8+VNFFigtgrxIQpH2u5Lxvv+vQ2/07AYJaKI0Eb6gAUchDaHPJ9yywvt9irxidEsRemfKYe/DYjcXizG17sTurOVLuJaVimE9zER6pKcCxhzjznlGTDuYnWwEGOdSfOXxqIsQHjLcV4/JvsvglqLDx7g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IBY4Aa9SUg1peakQUgbYzif4wUNENze6bpiX95QSwr8=;
 b=AFAeTFWBf522Tf1VocVcY6yFhRrnxPFYS8cBJbXEHfcsSucTrQ9q9jMd6RblW5g2Aasv++URVUqt1GVUaN3iAUWRDXnNg8st/r3frn17MW0Hy6FRuHDPPP6rkrCLAYxi6m/8nqybsv507s6CdvMjIJUZzcOuzFytADSScQeMW9YlXyrx3lRXsupQ/mFmc73xNQer15Wtso8nlym/mEEUHfvQcL5HlvKNDxYax3KeHvVjRW9R3TURiI+DZ257sOa+D4miP4PVjUJo6aUaFhaBbmY3njIiveS5sgWDhHPxfVhHsSKAhnZxMku5WwyLPghQNQ1PmDPf74ElptfT+z3WMw==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12) by PH7PR12MB6696.namprd12.prod.outlook.com
 (2603:10b6:510:1b3::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.23; Mon, 28 Sep
 2026 18:27:45 +0000
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d]) by CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d%6]) with mapi id 15.21.0451.022; Mon, 28 Sep 2026
 18:27:45 +0000
Date: Mon, 28 Sep 2026 15:27:43 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Quanye Yang <quanyeyang@proton.me>
Cc: "Md. Haris Iqbal" <haris.iqbal@ionos.com>,
	Jack Wang <jinpu.wang@ionos.com>, Leon Romanovsky <leon@kernel.org>,
	Danil Kipnis <danil.kipnis@cloud.ionos.com>,
	Jack Wang <jinpu.wang@cloud.ionos.com>, linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Farhad Alemi <farhad.alemi@berkeley.edu>
Subject: Re: [PATCH] RDMA/rtrs-clt: Don't WARN on unexpected info-response
 opcode
Message-ID: <20260928182743.GB1783910@nvidia.com>
References: <20260921-rtrs-fix-rtrs-clt-info-rsp-done-v1-1-c64281ed97c0@proton.me>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260921-rtrs-fix-rtrs-clt-info-rsp-done-v1-1-c64281ed97c0@proton.me>
X-ClientProxiedBy: SJ0PR03CA0080.namprd03.prod.outlook.com
 (2603:10b6:a03:331::25) To CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CHBPR12MB731189:EE_|PH7PR12MB6696:EE_
X-MS-Office365-Filtering-Correlation-Id: c16c2654-4580-45ff-78a7-08df1d8e30a2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|23010399003|376014|10067099003|56012099006|11063799006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	m0AnBsNsVJOFE2L9BgcRovCNcHuMGDD+P157uhXm5AVQzoy3hD4rtmtELIj9zTddKildIWoJSNTKtymaGtdueQA3pEWrxH5YNIcSWMASQS3TBk3tF3oxVjcMpQ81ovc771mTxcyJGALG9ieO0DCmxwe/yKVUdDLKCae5SdbFP2tx9kUC6xMRlzGXI07sMPkullb3xexCJJyO9umvLuZrisFG44ZRY+PF7ot5kKFdCQaSCkbdz5OY6X70YJyLZB0uG/xGHacptShRPc9DYTccdG3iatKRRcoK3p/ourTXb+Ybitg0EL0nJ3YqwttheuohVcUqpA+VMId8YdhIrHBY/Or8SJ6p4hugYjhGj5IUQBnzWg9oHpIUtralmP2eHJ+ieNmgKOC8aQtoPTWEyYfIgbphh92YWknnr3IklWxM+dSlrU7JitQ8+NgKMYU0PaXhqROmKyQKeUooSMvM8D5hEDbOLeojRlwlQ+VSdP7n+Sk7gn8oJghqc12XS7z3oFDePvdMPW8p1Ez4fKOEJ+uPFYu8H3mYLpi/lEUsDWwEUpdOrQ47v6HQlww/DziaNhhefdjr6o/RngxBmnlZYlemiy+h8M66EGQE7MIEufZBTluXP4L9MirsscD6nYdHLj6mXFBqyK2FSJhHLDIq50eKJdWg4bLQn6k9HJDYGkVFO7Y=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CHBPR12MB731189.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(23010399003)(376014)(10067099003)(56012099006)(11063799006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?vD2KMpXhZkAVYREhDKCA8n1F4Ah+xCHX6Hp9OYZYP0RLJSh3Bcw/5OCWBEBZ?=
 =?us-ascii?Q?xJKPHKpvVC+HxWCmjVgerYOMEO6VZAVCX2Gx6ot4NcnXY/H4uCyyjoSUzAgJ?=
 =?us-ascii?Q?/fmP7Ai6U2lD6aEozW59tBd2tt4sb89pVFaOEQcsO5xTioYECLrkPI4bW16H?=
 =?us-ascii?Q?uGlvgwZt0YI8Kp7bktGXLd4Lum0DrgoROGYZ8CFlbJ9lOZNFGgbF59zsgAD6?=
 =?us-ascii?Q?fzBl5BId70F4PidaMgOLifxQdK41v+U8p94615XHUc47f9nug+v7wVO3KvUm?=
 =?us-ascii?Q?6B7I0aSEW2iTxMkgr0zZlPml7AS+wtC+l+kCTAc+IG2g+SMk1c9VM7yjKD/B?=
 =?us-ascii?Q?lfi/mWZ9MOX5+RDFVlC1vnAVzrTKB6FboAZh/a7OyU5XyLta3+I7DGRpdASo?=
 =?us-ascii?Q?roSGaDvCZC2m7/I64U6oOxV0uEHWdE29H0PQk5CUwULTrawrLTH5OZoi+4ER?=
 =?us-ascii?Q?W+217rhiQFLA3zE4zY7CdFEVsYXw9dy0uWqy/2d2E1LfWDRak4g6d7YhJCay?=
 =?us-ascii?Q?Zco/2D62tTefodikn3W9ogyDdHwvVoZiX6Tfm0ZLeop70xGy+4SkSCL6bvVf?=
 =?us-ascii?Q?8rG7fBBt2LjmiRQhmeQx1ySRLTKqLZ4R3DRD7dOu/qzBpMqI4tbRgLs/DOkD?=
 =?us-ascii?Q?l6kMFt5ggK63w/QFfUUV1SuyJ7tgXNxSnU3OgHa0p0UddwHRty/rQJGdtG0U?=
 =?us-ascii?Q?Oz0Mi7kW32gbUxouOQfqxuFLh2H3Z2L6oksUdw/Q0UwoN/9DbArTQpo2CmjQ?=
 =?us-ascii?Q?d72HzyZ6Teq40yKbB5fA8/c/TPNCPdzpBeARxDj3fVLA+gNSM75+QW0QBU6i?=
 =?us-ascii?Q?gAJQEUcgXDz6RJAQ+5LNBNa86hXlvo3RZGdJknsdwXhO3MEgZJok3aY2rUNT?=
 =?us-ascii?Q?yh/C5CFxiWoDB1Kz7NyomCXHeS3JFGSWAvhscG7V4BjfcU6xDE9DlcicauTX?=
 =?us-ascii?Q?xfVpeLBteUEGSP1sYF5+dHdtURX9KCrRDBWNvwzJYnM6DxOXkm3gRGJgXNnf?=
 =?us-ascii?Q?wqya7AoOs7ZwvSWPOsoNEAumx5Ly71bXGmsPR3L6d8tCt57OmziJiz7+7Xaf?=
 =?us-ascii?Q?KWhS30qF6s8RwReSw9bacEQxBhiUxBWo9xPdKTMCtCSydZDsYAu+Ea/LHi/2?=
 =?us-ascii?Q?2nGxpDsSlIc2EQuOGc9A5q2Xj2tIscsgEcHMbSwumMcS2+PzjiUhs47vNzKi?=
 =?us-ascii?Q?lrA3Pdx9RuvaULr8hkweUlUB2d4x+iIO4UBkv2Q302gmKH4i6XjS5WdYsJE2?=
 =?us-ascii?Q?wKFn46PqA0WrRfVLH2oD9yGYTCDgZr77Z5Moa4qBdRFfDY46Kjb41lrgOWdf?=
 =?us-ascii?Q?DQp8QePNckQP2tz2tNZfQcI/nBnIo3/hCyorwa8fgThOTg5l8tm+9mhMX9ae?=
 =?us-ascii?Q?l8JEQX4NBzWkNoTcdXks+UqyraOY/6oEYtBKGOrdRVx7xutHNBMQSKXfuDL5?=
 =?us-ascii?Q?X/WbJ3jTQUZA9m7OA/lLnTZ3IFktAdd5LRa/s8KYJgGZbz9vTwI5PY2MY81b?=
 =?us-ascii?Q?VNCslA+51UwCXjkDV7CjBu4p5Mn0IyFwWYTS2tbtaCSRgQ5GNGdW1NwGTn/Y?=
 =?us-ascii?Q?tMk2eckRD1B2nZYE6LJevVAhYMUdNpjOuHSEyBnrKorJpZBV0iB/TlWey0KI?=
 =?us-ascii?Q?0fdAb/5T+O2BvyF00tF9y12Xx6KunDAVTu9IF9Ug0k3xAh80RWzACuPtu2s4?=
 =?us-ascii?Q?7XunCu/3AnXX2TFCLw5KpuuqNRfR+xF2Kl62g3B4EoawjzVz?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c16c2654-4580-45ff-78a7-08df1d8e30a2
X-MS-Exchange-CrossTenant-AuthSource: CHBPR12MB731189.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Sep 2026 18:27:44.9756
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /herm5a6W6Wah5qhxJ379+fd2uGLh3Vgw5QSIYFwHGGH9I09NzEdkRrT4+VOv+h6
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6696

On Mon, Sep 21, 2026 at 09:25:25PM -0700, Quanye Yang wrote:
> From: Quanye Yang <quanyeyang@proton.me>
> 
> The info-response receive is posted for a SEND.  The completion
> opcode comes from the peer, so RDMA WRITE with Immediate is a
> legal WC on that WQE even though it violates the RTRS handshake.
> 
> WARN_ON(wc->opcode != IB_WC_RECV) treats that peer-controlled
> field as an internal invariant and panics with panic_on_warn.
> Treat a non-SEND completion as a handshake failure: log it and
> keep the existing CONNECTING_ERR cleanup.
> 
> Fixes: 6a98d71daea1 ("RDMA/rtrs: client: main functionality")
> Reported-by: Farhad Alemi <farhad.alemi@berkeley.edu>
> Link: https://lore.kernel.org/linux-rdma/CA+0ovCge-K+hcGHXZ4R3Ww5+cg159uxHBeVbKeUSLBRSMT8OWA@mail.gmail.com
> Signed-off-by: Quanye Yang <quanyeyang@proton.me>
> Reviewed-by: Jack Wang <jinpu.wang@cloud.ionos.com>
> ---
>  drivers/infiniband/ulp/rtrs/rtrs-clt.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)

Applied to for-next

Thanks,
Jason
