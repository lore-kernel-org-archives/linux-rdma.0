Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.52.31
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795075881;
	b=oE8pN01X9fFlkkdd0D7zGlziVlrZqv/CpaNnva8LxPA988+XFvVmXVev8qNxN1BNf04L
	 pSyWL+5g2Op/o9Udrk0/atVXrLv5+MdEboqzEKt0hq6hfLNYrCNZNfgQ6Ebwt37HcXNrh
	 Ou7hLN0SVUU6jSFbPICW/v8Tn+uKUOnjsplbLzNUwuZP1eRheev2Wg+gRzgX3SqK8Edaa
	 Jkx9NNUhLkuVI2C1zv9Dsxs8C022h9UZQiueeSAWY44MWauCNhQiAxMILrFiECe2Xbxot
	 kNN0otQ7+Mh40Embwt2yXY4hN7LlkmS2R4bfhpvDvNH1zXaxJbF/5gEIknja4m2EGfA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795075881;
	h=DMARC-Filter:DKIM-Signature:Received:Received:
	 X-MS-Exchange-Authentication-Results:Received-SPF:Received:Received:
	 Received:From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
	 References:MIME-Version:Content-Transfer-Encoding:Content-Type:
	 X-Originating-IP:X-ClientProxiedBy:X-EOPAttributedMessage:
	 X-MS-PublicTrafficType:X-MS-TrafficTypeDiagnostic:
	 X-MS-Office365-Filtering-Correlation-Id:X-MS-Exchange-SenderADCheck:
	 X-MS-Exchange-AntiSpam-Relay:X-Microsoft-Antispam:
	 X-Microsoft-Antispam-Message-Info:X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-Id:
	 X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=ynJWM/st+sqcCsjBe0QSi2HNnVpcdYjjXYbzcgJTBPc=;
	b=qsSZgITpIQXPhA18phVwdX1ZJwrA1xW9XxDXFyDZCBFtaWE+iP4aiFCh/PtgUBN6fwFy
	 Mi7SNmtwiwvbLz6wT8wFdsVIH7IFAlX7Kb5dPg30f7ImX5exPY4PGhWAKqD7JlXy3XG+j
	 gGlCz6m+wWDPCMOwilyaIdZtMICXepLw57mziQBdrwG/L7eP79/ihw/d6W6R0+LAAnShK
	 vm6OhIhwifyCNif70M7sZQPA+Jz+PcwLhEykB88BTTQjBcCP/Ks3BvBazJw3TEzfTdjkD
	 g9wz+DjF7laEXNU4psAlpfLa2x76vAir2/6XZQTMLtcH1sUZA0J99kBauCXBWrSAXyA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=fOFmZnh3;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.52.31
Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11011031.outbound.protection.outlook.com [52.101.52.31])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1431A606A325;
	Thu, 19 Nov 2026 08:11:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1431A606A325
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=fOFmZnh3
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jhC44jFlKbCullr/xU1Ar3BMktSolJCFATPKXWDAI/P/Eb81HSeutJ+NzbN2idsEpPYpKlq7iC0FEgNQhWB3QLAodcCPgMeLtUDsEjjVcn2KrrcFxCM39bUHLTwi7jj6gSQYR1chn81ROeFq4BpBykE3sCZ2oDVNh4jA1rzHCCdLP6kvELU/ocyGsKov8nMAuVgBJ3P8UF3puVv5zk/SE944aaCRcPS3KMbGP9Vqb4v9znVVYdYZ5Q1cSS0B16AyPDuAZkS2pYdHSzBQ7luBpKhQ/J0hs64kCVnNjYP6YnG3aQGLvUSti7/5RCQogmU8H/Xm04wKKXmv75emqktDLw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ynJWM/st+sqcCsjBe0QSi2HNnVpcdYjjXYbzcgJTBPc=;
 b=oclymRckBjLVhwQ60xXi0cvdZVaIoLONY0ITOD6ouA0JHl0RUQnOx/I5xWQszwCuOftHUmwDG68TdtrV6TBPKNmWxtsfnV4XmhIdmXqP2RdbvXORnzOhfCloVDYPETo93LRKkzkVZoziSQY8fy94D60RTs6r4sSmZxZCBtzWqTbIpLfnHIRVhbNoCby01gOWADBYnAy1ZupxEw3Jn7eanqw1VbWJhMEv5eR9DKGR9qHf1yv16qqaQUhsLHzdcNJ+ke5di/UVzZGyP6e4XyKE5wCbPz1GetOlmkFg4m5pvt3NAI/J0ukVwSv1iv7kKMU3gPyLtef3qpRtIsOZIux+CA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ynJWM/st+sqcCsjBe0QSi2HNnVpcdYjjXYbzcgJTBPc=;
 b=fOFmZnh3Qg46TT10oFDEX4j8fHKlZNop/OdGiKglYa8beAXDV55ou282SKwyuLvF2YiIdigNTLDo+wE8p635pYRQ05xOvdVklNtdZJz8w/myyF8OOh4ova53PlpPyCd37RdmkEvLeRlrfrFqlEmsbXkWuK0KXCyKtgPb6Ynyk8Ia7UuiT/aH4Tmehsj8AWSMjx5425+eqLt34ceq5Rb8EJnR8HBceB4YC8Zq66iPLjtH+rAgQITlxua4oZyJKrjwe+JeYC0nGSdEU8SVuZqXAetBJOx1CTq4HgzvstqqbRJV5FRzI+01NG8MR+u4nBS/kKftkm21j6KwLpJ06tTQfw==
Received: from DS1PR06CA0019.namprd06.prod.outlook.com (2603:10b6:8:23e::7) by
 MW9PR12MB999208.namprd12.prod.outlook.com (2603:10b6:303:301::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.14; Thu, 19 Nov
 2026 08:11:15 +0000
Received: from CY7PEPF000000EA.namprd04.prod.outlook.com
 (2603:10b6:8:23e:cafe::6) by DS1PR06CA0019.outlook.office365.com
 (2603:10b6:8:23e::7) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.615.14 via Frontend Transport; Thu,
 19 Nov 2026 08:11:15 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.117.160) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 CY7PEPF000000EA.mail.protection.outlook.com (10.167.247.166) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.615.4 via Frontend Transport; Thu, 19 Nov 2026 08:11:15 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.57; Thu, 19 Nov
 2026 00:10:59 -0800
Received: from nps-server-23.mtl.nbulabs.nvidia.com (10.126.231.37) by
 rnnvmail201.nvidia.com (10.129.68.8) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.57; Thu, 19 Nov 2026 00:10:53 -0800
From: Shay Drory <shayd@nvidia.com>
To: <netdev-bot+sashiko@kernel.org>
CC: <tariqt@nvidia.com>, <andrew+netdev@lunn.ch>, <davem@davemloft.net>,
	<edumazet@kernel.org>, <kuba@kernel.org>, <netdev@vger.kernel.org>,
	<pabeni@redhat.com>, <cjubran@nvidia.com>, <cratiu@nvidia.com>,
	<gal@nvidia.com>, <leon@kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-rdma@vger.kernel.org>, <mbloch@nvidia.com>, <moshe@nvidia.com>,
	<ohartoov@nvidia.com>, <phaddad@nvidia.com>, <saeedm@nvidia.com>,
	<udar@nvidia.com>
Subject: Re: [PATCH net-next V2 05/10] net/mlx5: LAG, decouple iteration end-of-walk from MLX5_MAX_PORTS
Date: Thu, 19 Nov 2026 10:10:45 +0200
Message-ID: <20261119081045.1586897-1-shayd@nvidia.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <179499791433.3136.10916264856961246459@kernel.org>
References: <20261116103010.1129666-1-tariqt@nvidia.com> <20261116103010.1129666-6-tariqt@nvidia.com> <179499791433.3136.10916264856961246459@kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY7PEPF000000EA:EE_|MW9PR12MB999208:EE_
X-MS-Office365-Filtering-Correlation-Id: dc70c933-2882-4205-57be-08df4614ae94
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|7416014|376014|1800799024|82310400026|36860700016|261022075727099003|10067099003|5023799004|56012099006|11063799006|4143699003|261026140227099003|261028144727099003|261021121427099003|261022105027099003|261026121527099003|261102123227099003|261009223027099003|18002099003|22082099003|6133799003;
X-Microsoft-Antispam-Message-Info:
	ZM1OipQTPnEp/OSzzz109HcC3WcQn88Vb5RT1+wW7IDkt8PFnfNVInvSnfqc0OTgqLHoy8+htxGwWoEJJEfa9lmO71Jrv8XcqiildwMdpZf/X+E9fw+8tAkqqIA1i5Yg+RrlERdeSc1mPI4ugB13a6MIIzi1Ow5P7mBkp49vCuPmCLf0xcFEz0lc9VIBjSYuW9ibwz+stBqJif3n0r4IHl3EVHk71SrW67QGbJgA+Jx18rHTMjnK4h8QdFEWMetUa9Az51y6FzS+scfMCJmTYd/hhOi2j2Q4AkIce+d3WLqvCrO40yvcx241lR9psAM+zPsTcqv5rRpVMT8HBsExS42I6YQz7tRXzTiCMz7P701+bgkhYl+P8XYbnaNDj+VHqILHxQUNaQjiPVh0sNzbG0hA7gUQIyJWVIw5VIhlRvqDBFsmJn2ydaIz9NvTm/nadXfmVgE8dX/cIPyVvCiBOpC0hiipWdOrTgwJjkFYTb3e+/yw+fGOdratpVjqTPMIOPncWeeRKJ/4RheeXLPG2SdWTZGBFcv0ncSviulmGYLIIBHU5475yHlmBCNNYgIwfvgEaxoLvnnpDQ+hMqlcwpLF4aZxH3oBGY92fzTDfJF6xgZMxW7wvDqwNuF/JKS0LkbdOe8+P1scG1UWLd9LECzzB6WcrLS7iBxKDh9P6Ivk56Z/8iFiL22Fbfq8Dn/Ld0FiRhZU9GDImdSNdH/nfA==
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(23010399003)(7416014)(376014)(1800799024)(82310400026)(36860700016)(261022075727099003)(10067099003)(5023799004)(56012099006)(11063799006)(4143699003)(261026140227099003)(261028144727099003)(261021121427099003)(261022105027099003)(261026121527099003)(261102123227099003)(261009223027099003)(18002099003)(22082099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	HqVGTndlyHVQj9SrEXgkXrfzc4wKTVThwJ2c2EC90WktibpI1v3ssPYIXQlBY49sKKhwY+AgRnhae1uptgZK+icyxjLsnyyC6g7gvzWWmvRtaDtYtNrUbKj3PZF/IeBduhlc1oqrol4SJ94n5+9lea9ECc8WNzPr/4btlV8L5vaqRyMP8lbuRBsQq2BJqMh8LRYOxmSxHuXcn/2Vg9wOdcKneiNgkdsfacb7si47XCVaC+tFuAteRjJA4asZ873cfe70eDQO0A9fxLuhpzso/cdkapIuU2p8KWidykmanGwREtiE11L6K8DtYGZ+UgOD8K3TYKnQLMIppzQLVsx6hTAQlFPSFFfsyYozNAla2ALjs4ud+1eSc/g16Iwuu8WVayKptzc/mSSqBTLvNIyORxnLUXOJ42svMRZbkxEpJRWTibpWfsoJo6RiM6a3fDYf
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Nov 2026 08:11:15.1184
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: dc70c933-2882-4205-57be-08df4614ae94
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY7PEPF000000EA.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW9PR12MB999208

On Wed, 18 Nov 2026 10:31:54 +0000, netdev-bot+sashiko@kernel.org wrote:=0D
> Thank you for your contribution! Sashiko AI review found 5 potential=0D
> issue(s) to consider.=0D
>=0D
> Critical: 0 =C2=B7 High: 1 =C2=B7 Medium: 2 =C2=B7 Low: 2=0D
>=0D
> If you believe none of the issues are legitimate, please reply to each=0D
> issue of Medium severity or higher and explain why the AI is wrong.=0D
> If any of them are legitimate and you plan to respin, please let patchwor=
k=0D
> know by including "pw-bot: cr" as a separate line at the end of your repl=
y=0D
> (one such reply per series is enough).=0D
>=0D
> - [High] mlx5_ldev_add_mdev() raises the xa_alloc() range from=0D
>   XA_LIMIT(0, MLX5_MAX_PORTS - 1) to XA_LIMIT(0, U8_MAX - 1).=0D
> - [Medium] mlx5_handle_changeupper_event() now tests whether the port was=
=0D
>   found with `if (i < ldev->ports)`.=0D
> - [Medium] The end-of-walk sentinel used to be the compile-time constant=
=0D
>   MLX5_MAX_PORTS.=0D
> - [Low] In mlx5_lag_create_single_fdb_filter() (shared_fdb.c), the=0D
>   max_slaves argument to mlx5_eswitch_offloads_single_fdb_add_one()=E2=80=
=A6=0D
> - [Low] mlx5_lag_dev_alloc() sets `ldev->max_funcs =3D ldev->ports` only =
at=0D
>   the very end.=0D
>=0D
> --=0D
>=0D
> net/mlx5: LAG, decouple iteration end-of-walk from MLX5_MAX_PORTS=0D
>=0D
> This patch adds ldev->max_funcs and uses it as the end-of-walk sentinel=0D
> for the LAG xarray iterators in place of MLX5_MAX_PORTS. max_funcs grows=
=0D
> when a member is added at a higher xarray index. The patch also raises=0D
> the xa_alloc() limit in mlx5_ldev_add_mdev() from MLX5_MAX_PORTS - 1 to=0D
> U8_MAX - 1.=0D
>=0D
> > diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c b/driver=
s/net/ethernet/mellanox/mlx5/core/lag/lag.c=0D
> > index 669b2167a82d2..cbef6ab1e38a8 100644=0D
> > --- a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c=0D
> > +++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c=0D
> > @@ -395,6 +395,7 @@ static struct mlx5_lag *mlx5_lag_dev_alloc(struct m=
lx5_core_dev *dev)=0D
> >  		mlx5_core_err(dev, "Failed to init multipath lag err=3D%d\n",=0D
> >  			      err);=0D
> >=0D
> > +	ldev->max_funcs =3D ldev->ports;=0D
> >  	return ldev;=0D
>=0D
> [Severity: Low]=0D
> Can a netdev event see max_funcs =3D=3D 0 here?=0D
>=0D
> By the time this assignment runs, register_netdevice_notifier_net() has=0D
> already made ldev->nb live. mlx5_lag_mp_init() has also registered the=0D
> FIB notifier, which dumps the FIB and can take a while. Until this line,=
=0D
> max_funcs is still 0 from kzalloc.=0D
>=0D
> Suppose a NETDEV_CHANGEUPPER for a bond in the same netns arrives in that=
=0D
> window. mlx5_handle_changeupper_event() then runs mlx5_ldev_for_each()=0D
> with max_funcs =3D=3D 0:=0D
>=0D
> - mlx5_get_next_lag_func() returns 0.=0D
> - The loop exits with i =3D 0 and idx still -1.=0D
> - The new "i < ldev->ports" check passes.=0D
>=0D
> The handler then executes:=0D
>=0D
>     bond_status |=3D (1 << idx);=0D
>=0D
> This is a shift by -1. Would it be better to set max_funcs right after=0D
> ldev->ports is assigned, before any notifier is registered?=0D
=0D
The window is very narrow and harmless: bond_status stays 0 and the=0D
handler returns early, so nothing is changed. It will be fixed in a=0D
follow-up.=0D
=0D
> [ ... ]=0D
>=0D
> > @@ -2094,7 +2095,7 @@ static int mlx5_handle_changeupper_event(struct m=
lx5_lag *ldev,=0D
> >  				break;=0D
> >  			}=0D
> >  		}=0D
> > -		if (i < MLX5_MAX_PORTS) {=0D
> > +		if (i < ldev->ports) {=0D
>=0D
> [Severity: Medium]=0D
> Should this compare against ldev->max_funcs, like the other converted cal=
l=0D
> sites? mlx5_ldev_for_each() now ends with i =3D=3D ldev->max_funcs. This =
patch=0D
> also explicitly allows members at xarray indices >=3D ldev->ports, since=
=0D
> mlx5_ldev_add_mdev() grows max_funcs for that case.=0D
>=0D
> xa_alloc() hands out the lowest free index to both port and SD members.=0D
> For example, after a PF is unbound and rebound, SD secondaries added by=0D
> sd_lag_init() can hold the low indices, so the matched port PF can end up=
=0D
> at an index >=3D ports.=0D
>=0D
> In that case the loop breaks with i equal to that index, "i < ldev->ports=
"=0D
> is false, and the PF is treated as not found. Its bond_status bit is neve=
r=0D
> set and has_inactive is not computed for it, so this never becomes true:=
=0D
>=0D
>     is_in_lag =3D num_slaves =3D=3D ldev->ports &&=0D
>         bond_status =3D=3D GENMASK(ldev->ports - 1, 0);=0D
>=0D
> As a result, the bond is never offloaded. Before this patch, indices were=
=0D
> capped at 7, so any found entry passed the check.=0D
>=0D
> The notifier is only registered when !mlx5_sd_is_supported(dev), so this=
=0D
> may need a mixed or unusual topology to trigger. The check is still the=0D
> same at the end of the series.=0D
=0D
No. mlx5 creates an ldev per sw_guid, and PFs have a different=0D
sw_guid than VFs/SFs, so only PFs share this ldev. The only case with=0D
more PFs than num_lag_ports in one ldev is SD, and for SD the netdev=0D
notifier, and with it mlx5_handle_changeupper_event(), is not=0D
registered. So a PORT-marked member here always sits at an index below=0D
ldev->ports.=0D
=0D
> [ ... ]=0D
>=0D
> > @@ -2359,13 +2360,16 @@ int mlx5_ldev_add_mdev(struct mlx5_lag *ldev,=0D
> >  	if (!pf)=0D
> >  		return -ENOMEM;=0D
> >=0D
> > -	err =3D xa_alloc(&ldev->pfs, &idx, pf, XA_LIMIT(0, MLX5_MAX_PORTS - 1=
),=0D
> > +	err =3D xa_alloc(&ldev->pfs, &idx, pf, XA_LIMIT(0, U8_MAX - 1),=0D
> >  		       GFP_KERNEL);=0D
>=0D
> [Severity: High]=0D
> Is it safe to drop the MLX5_MAX_PORTS limit before the arrays that depend=
=0D
> on it are resized?=0D
>=0D
> This limit was the only thing that kept both the member count and every=0D
> xarray index below MLX5_MAX_PORTS (8). Neither __mlx5_lag_dev_add_mdev()=
=0D
> nor sd_lag_init() checks the member count.=0D
>=0D
> At this commit, once an ldev has more than 8 members, these writes look=0D
> like they go out of bounds:=0D
>=0D
> - mlx5_mpesw_metadata_set() writes ldev->lag_mpesw.pf_metadata[i]=0D
>   (u32[MLX5_MAX_PORTS]) under MLX5_LAG_FILTER_ALL. lag_mpesw is the last=
=0D
>   member of struct mlx5_lag, so this writes past the kzalloc'd ldev.=0D
>=0D
> - mlx5_lag_rescan_devices_locked_filter() fills the on-stack=0D
>   devs[MLX5_MAX_PORTS] with devs[num_devs++] without any bound check.=0D
>=0D
> - mlx5_lag_query_cong_counters() fills a buffer of MLX5_MAX_PORTS entries=
=0D
>   with mdev[idx++].=0D
>=0D
> - struct lag_tracker::netdev_state[MLX5_MAX_PORTS] is written at the=0D
>   port's xarray index in mlx5_ldev_add_netdev() and in=0D
>   mlx5_handle_changelowerstate_event():=0D
>=0D
>       tracker->netdev_state[idx] =3D *lag_lower_info;=0D
>=0D
> - struct mlx5_lag_definer::rules[MLX5_MAX_PORTS *=0D
>   MLX5_LAG_MAX_HASH_BUCKETS] is indexed by i * ldev->buckets + j in=0D
>   port_sel.c, where i is the port's xarray index.=0D
>=0D
> Before this patch, such a configuration failed cleanly: xa_alloc()=0D
> returned -EBUSY and sd_lag_init() rolled back the secondaries. An 8-port=
=0D
> SD configuration, for example, would now give 16 members.=0D
>=0D
> Later patches in the series fix some of these:=0D
>=0D
> - "net/mlx5: LAG: replace fixed MLX5_MAX_PORTS arrays with dynamic=0D
>   allocation" makes pf_metadata kcalloc(max_fns) and sizes the=0D
>   cong-counter buffer from ports.=0D
> - "net/mlx5: LAG, drop MLX5_MAX_PORTS scratch array from device rescan"=0D
>   removes devs[].=0D
>=0D
> At the end of the series, though, lag_tracker::netdev_state[] and=0D
> mlx5_lag_definer::rules[] are still sized by MLX5_MAX_PORTS and indexed=0D
> by xarray indices that are no longer bounded.=0D
=0D
In this series a 9th member is impossible: an ldev holds only=0D
PFs and SD secondaries, and no HW has more than MLX5_MAX_PORTS of them.=0D
VFs/SFs join an ldev only in the follow-up series.=0D
The limit can't be kept until all arrays are converted, since not all=0D
of them will be. Some arrays are used only by a PF LAG, others by both a=0D
PF LAG and a virt LAG. The shared ones, the fns xarray included, are=0D
converted in this series (pf_metadata[] and devs[]; the cong counter=0D
array is converted as well). The PF LAG only ones,=0D
tracker.netdev_state[] and the port_sel rules[], keep their static=0D
MLX5_MAX_PORTS size: they are walked only over PORT-marked members, in=0D
the hash and queue affinity modes. A virt member is never PORT-marked=0D
and sits in its own ldev, and a virt LAG supports only MPESW, so these=0D
arrays never see more than MLX5_MAX_PORTS entries.=0D
=0D
> The commit message also says:=0D
>=0D
>     No functional change; this only removes the dependency on=0D
>     MLX5_MAX_PORTS.=0D
>=0D
> Isn't dropping the xa_alloc() bound a functional change in itself?=0D
=0D
The xa_alloc() change is already in the commit message ("remove the=0D
xa_alloc() limit of MLX5_MAX_PORTS"), and the answer above explains why=0D
it can't let in a 9th member.=0D
=0D
> >  	if (err) {=0D
> >  		kfree(pf);=0D
> >  		return err;=0D
> >  	}=0D
> >=0D
> > +	/* max_funcs is the iteration ceiling; grow it, never shrink. */=0D
> > +	if (idx >=3D ldev->max_funcs)=0D
> > +		ldev->max_funcs =3D idx + 1;=0D
> >  	pf->idx =3D idx;=0D
> >  	pf->dev =3D dev;=0D
>=0D
> [Severity: Medium]=0D
> Can walkers that don't hold ldev->lock see an inconsistent max_funcs?=0D
>=0D
=0D
No, all these walkers run either during LAG activation or while=0D
the LAG is active, and membership doesn't change then.=0D
=0D
> The end-of-walk sentinel used to be a constant. It is now this field,=0D
> which is written with a plain store under ldev->lock only. Each iteration=
=0D
> of mlx5_lag_for_each() loads it twice: once as the return value of=0D
> mlx5_get_next_lag_func(), and again in the macro test:=0D
>=0D
>     i =3D tmp, tmp < (ldev)->max_funcs; tmp++)=0D
>=0D
> Several walkers don't hold ldev->lock:=0D
>=0D
> - mlx5_mpesw_sd_devcoms_lock(), called from mlx5_mpesw_work() and=0D
>   mlx5_lag_disable_change(), runs under the HCA devcom lock but before=0D
>   mutex_lock(&ldev->lock).=0D
> - mlx5_ldev_add_netdev(), mlx5_lag_get_next_peer_mdev() and=0D
>   mlx5_lag_query_cong_counters() hold only lag_lock.=0D
> - mlx5_handle_changeupper_event() holds only RCU.=0D
>=0D
> sd_lag_init() adds secondaries while holding only ldev->lock. The writer=
=0D
> order is:=0D
>=0D
> 1. xa_alloc() publishes a zeroed pf at idx =3D=3D old max_funcs.=0D
> 2. max_funcs =3D idx + 1.=0D
> 3. pf->dev =3D dev.=0D
> 4. The PORT mark is set.=0D
>=0D
> Suppose a reader's walk ends while the new pf isn't valid yet. It gets=0D
> sentinel N back from mlx5_get_next_lag_func(), then re-reads max_funcs as=
=0D
> N + 1. The loop body then runs once with i =3D N, skipping the !pf->dev=0D
> check and the PORT-mark filter. In mlx5_mpesw_sd_devcoms_lock() that=0D
> means:=0D
>=0D
>     sd_devcom =3D mlx5_sd_get_devcom(mlx5_lag_pf(ldev, i)->dev);=0D
>=0D
> runs with a NULL dev, which mlx5_get_sd() dereferences. In=0D
> mlx5_lag_get_next_peer_mdev(), a NULL or non-port dev could be returned=0D
> as a peer.=0D
>=0D
> Also, on weakly ordered architectures nothing orders this store against=0D
> the xarray slot, so xa_load(N) could return NULL as well.=0D
> [ ... ]=0D
>=0D
> > diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/shared_fdb.c b=
/drivers/net/ethernet/mellanox/mlx5/core/lag/shared_fdb.c=0D
> > index 7c7e6c832a93d..29048b0c27977 100644=0D
> > --- a/drivers/net/ethernet/mellanox/mlx5/core/lag/shared_fdb.c=0D
> > +++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/shared_fdb.c=0D
> > @@ -71,7 +71,7 @@ static int mlx5_lag_create_single_fdb_filter(struct m=
lx5_lag *ldev, u32 filter)=0D
> >=0D
> >  		err =3D mlx5_eswitch_offloads_single_fdb_add_one(master_esw,=0D
> >  							       slave_esw,=0D
> > -							       ldev->ports);=0D
> > +							       ldev->max_funcs);=0D
>=0D
> [Severity: Low]=0D
> Is this change intended? This argument isn't an end-of-walk sentinel. It=
=0D
> is max_slaves, which goes through esw_set_master_egress_rule() to=0D
> esw_master_egress_create_resources(). There it becomes ft_attr.max_fte=0D
> and the bounce group's end_flow_index for the master's egress ACL table=0D
> in firmware.=0D
>=0D
> With SD, secondaries take extra xarray indices, so max_funcs can exceed=0D
> ports (for example, 4 on a 2-port SD card) and the ACL table is created=0D
> larger. max_funcs is also a high-water mark of xarray indices that never=
=0D
> shrinks, not a slave count.=0D
>=0D
> Bounce rules are only added for SD primaries, so ldev->ports seems to=0D
> have been sufficient already.=0D
>=0D
> This doesn't match "No functional change" in the commit message. Could=0D
> the change be explained in the commit message, or dropped?=0D
=0D
Only the ACL size changes, and only for SD, where more PFs than=0D
ports join the ldev and max_funcs > ports. The rules installed are the=0D
same as before, so there is no functional change.=0D
=0D
> --=0D
> Sashiko AI review =C2=B7 https://netdev-ai.bots.linux.dev/sashiko/#/patch=
set/20261116103010.1129666-1-tariqt%40nvidia.com=0D
