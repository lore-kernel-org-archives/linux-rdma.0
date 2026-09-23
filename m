Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azon11011062.outbound.protection.outlook.com [40.107.208.62])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6A704CDA0E
	for <linux-rdma@vger.kernel.org>; Wed, 23 Sep 2026 11:58:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.208.62
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790164687; cv=fail; b=ayWIl8JQCFZEvZw8nL1967n2lF9WJ+IGFOo6yAJV1bxHLCksGeLhkxYWLQ6q7lQ5GjUKWoCIbzf4E0XtB8uk0kAl3DdBJe1MLo30QjQtxrfDKVDnhsO+fhUW6k/agY3BBat5FrrKrsr5gEjUwSmbNVJ60IgZLo9TC8BiSEiBYhg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790164687; c=relaxed/simple;
	bh=cjYP7obznD4MbiCG3d1tT1ULEKckQB/00ngXAtbzrR4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=e/tVw7r72SFwVUIv1RJv9L3ImT8EdlbC8QuoJX1qMYQwKIj3Av0E1gsaoVeFzdCUduZzXqyw86NL9tw+NlZrKRtLrWvX3jXW08rFYTwY6lrVW9IGzCxGdh26O5S0/HD+jJTtVtw+yyshk59LfVJVG/SmYIIEeJQJLMvvS/E8zkw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=WT03EZBu; arc=fail smtp.client-ip=40.107.208.62
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="WT03EZBu"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZU8uYNEtILNQTCNNwYR9BFEpxE8ddp7fGbw1u42zleBV1yTJzbKktxvHaEI4dNdJOvrD8smZ9PSoDAMB5anMssbxcUcMXDppK1uAPeuoNfQWzsXxsOxWmL0UNfgY/p1cRcRaDPudV0pvEJEcOWZMjJ4giEgWb1D3MAW2n5u4oTLPAE1rYpgaGwy9g1NpBU53dfV/wki+02sywTrGihTpLVXZCxS1Ejj3xM6FI37tROt4NWx1gyg1XV+VsJLKWBwBkKyZq6I0L0UkxyojfDq9WwY1++k/4HkeSr3h3l4+ClmqganH2Y6K4uqbZH2qq+LsXoyd7OCItsnZb0uLK7caqw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/R942O3Hzex+WsabRvlzSgjBrgZkAAleXkCHcahhxVk=;
 b=pvCf8+MFpogOzMkMxQjRoll2NPGUG90MZn0lrvZ0fKni+AT/OsJ+sm5jQR7j3Yqrh1Ep8NURFGp/bTh/8wmhXS7FqU0jkELVasNPPCnjkklN8j0bIGEafIk5vZt3K/KQkWJVDc7j0v3P4B6+5exkI5E6YSStUWRCwwYscXdIPHTuO0kAwSoYe5oTvtviRmz4YqW+gXzg0rRR9V+p4pwKHtvQwT/YMVtamaRcq4GhVa/ntrdzbeQuDUzDyPEArQgPpi8xW1z6FODHWUuZ5mPSu9AzBLEg9CIybdPo49XMAkIy4/fphrVWb+RXjbAXGVPrbR6NRKG+/HAaXlNbkAKP8g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/R942O3Hzex+WsabRvlzSgjBrgZkAAleXkCHcahhxVk=;
 b=WT03EZBubhJ8KaKsI+loGX263VUXjzkVaUWNXp4QE3Ovqco00MhUbkhtj0uiQLMYbc3wFn/fZpwC/MteiAjUvmH7MEWuLsD1b2yXY0MGMon7f0hjDDVq1tpMpqYEYZEkBbib5oM14mxz+FZ4O1p+NJkOUY6bAsU1fLpJHzQuz2QtzQr18EFZFzxYyepNWrT8G344RF/VYtGjIrqUqSm83hoYEl4L+NjHvyDsHXCGoVDD/uXqF/uGF2/xKYIgmCU2H94oI75E3mJGstCFRDN/DCt9jsNavcp4kaUJn4DgmZ6XsDxJkjYw1Jgf4stTy3FtFjU5tagD4MofTO5oKhZTsQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12) by DS6PR12MB152050.namprd12.prod.outlook.com
 (2603:10b6:8:410::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.16; Wed, 23 Sep
 2026 11:57:57 +0000
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d]) by CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d%6]) with mapi id 15.21.0451.014; Wed, 23 Sep 2026
 11:57:56 +0000
Date: Wed, 23 Sep 2026 08:57:55 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Leon Romanovsky <leon@kernel.org>
Cc: Michael Margolin <mrgolin@amazon.com>, linux-rdma@vger.kernel.org,
	sleybo@amazon.com, matua@amazon.com, gal.pressman@linux.dev,
	Firas Jahjah <firasj@amazon.com>,
	Yonatan Nachum <ynachum@amazon.com>
Subject: Re: [PATCH for-next] RDMA/efa: Use __GFP_RETRY_MAYFAIL for ring
 allocations
Message-ID: <20260923115755.GE2545495@nvidia.com>
References: <20260917105101.9365-1-mrgolin@amazon.com>
 <20260923105127.GP563127@unreal>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260923105127.GP563127@unreal>
X-ClientProxiedBy: SN7PR04CA0184.namprd04.prod.outlook.com
 (2603:10b6:806:126::9) To CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CHBPR12MB731189:EE_|DS6PR12MB152050:EE_
X-MS-Office365-Filtering-Correlation-Id: 18e0e408-2444-4e6a-6c27-08df1969e83b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|23010399003|376014|10067099003|56012099006|18002099003|22082099003|11063799006|4143699003;
X-Microsoft-Antispam-Message-Info:
	6vzRBRLGs/H3Hln6FK0DRSjVrkYv0oFucjE97ggRgidaC35G/tBm11aoZYrviB9YpBuiMpu3goxiOwaFkSb2RA4fb7f3iXhmLH+W6i/71vaee4sOi52L8cIJcPiVPIMP6qZkI6T+NDUlE4dpAr17dKwXbWkZGE24DrXNvAJjAMiey/xH7l4m2+LIFBaDpV7nqOXTORFXIviACiqrIyAikqtqiR/CwsEvJDpe0hFrtxfE91OND4zrVxUfrj0TdN0zqoTapRjqQdDbF0CFTmrWFH10TfQswW7LvOJjw+JSAfflXy7g+kC/osaNav5L7bgovhjXMJerFVe1jiEmQoE1mW7B4q5VP9tJMnM4nmU2tyCsxzU+Ph7rVE6W7fAhoN//6j8MWrmPObZ31xa+zeYakVlqHm5At+aXbdl6sazUvjcMDXehVaq84pxFVFkHvLLxAczlsf9LinYvUSDpYM/5hK8Qx1/cUn8GFtWWGeU5VvXYHcWOWTIgBgcVgOpk4o3A6ybUgW3PTFTlOPGioLySfd5FrnI0fGpcRC3uXMNSAfFkrXAgzbMliZsbbEXWwjNgePEv6z5buwrCiYEcCVtfesltXZ3gbKWn5D+y0RkQPMZCqFwQ+9+PBY5DeL/lE0HW9E+IJSgtNnXDOPScP+piWHBX+1dk4FXU5rcbtbi9UaY=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CHBPR12MB731189.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(23010399003)(376014)(10067099003)(56012099006)(18002099003)(22082099003)(11063799006)(4143699003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?maouOR842ySbckPCu9mArlR3Lt6XPzlBJibpfYFaeDGTuaUtg4qLhhIyd6Yc?=
 =?us-ascii?Q?VKXLS8HGfauXsD2sFMQbgqLiM490LQGPNPp6mD12owb6fUbi7UMC00fFJj17?=
 =?us-ascii?Q?avP2g1PeZjuXXMx7k1ZBaEOqJkrWBQubLBA0af6AM19RZ2e2UwYQ3IJKuLA3?=
 =?us-ascii?Q?UR8SkPoDdG/1iFCoZbrlImDfC8DKShJZqjNvVsdXkBogFw2QuYhThJHSFPs+?=
 =?us-ascii?Q?CyuaSP0iztgYfyI+LWTigoivpXSYH5/LFGDn+TIN5Ty1Up3Uquxr9Zr5dK7U?=
 =?us-ascii?Q?3AyPidSah6frpVVmClhEceszz/A6Xt6ywgXTDBOpsDX57LC3d5BvbLnqvDcg?=
 =?us-ascii?Q?S6zbAf2chhO73siX1M51LHo9Ct04kXuolv8rviCVaFG/JY+Mqcg3tvZjHWEn?=
 =?us-ascii?Q?d/hOTtrfZVR3rLPW2pLg6thJFrVXYjEC1qDAAqtubhTTyAVrFSFv0SPVQR+F?=
 =?us-ascii?Q?xOKXqdPcqdwAt5q2Tvow+ImMj2+G7oX17pTCKgYfUkRZPkOVw+db0dWHpL3D?=
 =?us-ascii?Q?x4pEbgvUwsUeQsvHBbeAlsSSunWNkzZ9RbnAzK6Z5Lg4ZwutFTGgm57aIvPe?=
 =?us-ascii?Q?Vb5IbN09AIqBV9PhL5v8VA9wysm4B4Vta1Nj6/yk4e+2CRy9kNOU6R1eEpB7?=
 =?us-ascii?Q?ji8X8rrNze6n6+wIRj1o/aW+Z5Mo1dfCGWoZscQnoVXTOscx5nSz4OZEYQ9v?=
 =?us-ascii?Q?iQeczfsAp6h2KAYf7oE7gHp+hfH0tuJ0v/v39SqmqBdkk92cmcdTeNccbJbD?=
 =?us-ascii?Q?OTtoK+A/ccOqF6dAoDdOdnOBZIIRQgzwA9ZlER5cbPjppeykeKVPmOVdf2mP?=
 =?us-ascii?Q?Jp0PSTMJmNOlsUFnN7XApEohK4t5EVKFqZb/KfWnBGLJj3JHCBuuI/knqwWI?=
 =?us-ascii?Q?u8wQbwmmMdEbcBRf7yD1lzcZLOeE0HzfU+E1YSiEGyS2ZAaRav3ynpU+ZfsE?=
 =?us-ascii?Q?C/zZ0k/1dWROI2P9MvnUXGrdctndQK0Wzx1eXFAlbAC/cViixK8NwuCtqvwz?=
 =?us-ascii?Q?SufP4CeRSd+gkhwzaggXvZTkAneIniTta4x6p0DOUTL//mhe+qaTV7GyJ3r/?=
 =?us-ascii?Q?NW5S+JhJySg2Ju+TM26bjT7HvQ6xG5vYdUgH7oSBw+8ZJyZL7yEiqy77cF25?=
 =?us-ascii?Q?xafdPEa8OBEzDIzuId1+QuRMrCelKqoa0KbWrHJhxZbp4uKABEwu6G7msFii?=
 =?us-ascii?Q?hKnA7YsWc593oSeMIDPX02HVa353luNJ0Ms8Fr4gK4272Jbn1pNgRLw4Hrnr?=
 =?us-ascii?Q?17YoYeJsuBLsr2Qc9/nR7GsAH3Ov8C5CKqG8/4x9dR9laM3kMBBrmDpDpa7F?=
 =?us-ascii?Q?pevUqStACNuXInGxMO+dfiL8AOxrYF3HHqCIkj8ce96OEnbYjJ9+0uhhLTw5?=
 =?us-ascii?Q?oLh2p619Z0cfm7B6na+mlWZ3VhQ5Cu3na47JO3Y+mEsxgapRIatCAB2tQvCu?=
 =?us-ascii?Q?yns+RKTfbUsYU4IlelPxpxt7v5Ethn4hEunxcli5t1UJdAPR7GSSE7jblMA/?=
 =?us-ascii?Q?nOQa3/XJj6eQ7VDIKESTVovkYl2KmmzIIb/BOvx+hWPdxzePW6JxSVahLqLS?=
 =?us-ascii?Q?AD/80DmXE6rZKttyXykuxDSy2HL+z+MbDN42eFgj08CUg0hUxijCukxPGORv?=
 =?us-ascii?Q?J8BYz0kqXMv7IVptE3BJyk+Z72XRwosLO2RneJMgll1dR+H6kZ6QkWsm29oN?=
 =?us-ascii?Q?0c4vuMRB3bxCLZGlVWYLlijucVsD/ahKdFM1621vopWcfVkt?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 18e0e408-2444-4e6a-6c27-08df1969e83b
X-MS-Exchange-CrossTenant-AuthSource: CHBPR12MB731189.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Sep 2026 11:57:56.9055
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DfyHu7COUR/pJwxD4o3KNGui9rVuqiwKXb2S0J3sdCbnYxx9lAod+S3lCyOr0iiQ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS6PR12MB152050

On Wed, Sep 23, 2026 at 01:51:27PM +0300, Leon Romanovsky wrote:
> On Thu, Sep 17, 2026 at 10:51:01AM +0000, Michael Margolin wrote:
> > RQ and CQ ring buffers require physically contiguous memory. On
> > systems under memory pressure, high-order allocations can fail
> > even when sufficient free memory exists because the allocator
> > gives up after a single reclaim and compaction attempt for
> > costly-order requests that lack __GFP_RETRY_MAYFAIL.
> 
> What sizes did you see fail, and in which flow?

.. and many other drivers has spent alot of effort not having high
order allocations like this because they just don't work.

Jason
