Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.53.45
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794319897;
	b=YHDW2do0HoX7mVfsHRUIQqcuL603h5UMaEDP/sG2DvUu7F+wAS4zYPB94jIXxnwvEL5K
	 OPE6fIdY9dEJlb7th8flcT9igZs2QWEYcWCcdNH/YEHzzSY6T+qzyHTcRGXEoKG3h842P
	 dBCJ/PBxEoIaf9Sf2tvbdMRugBJvd8rmSX69YDsUQkdsM8/xeMOPEbn0Fg3pN3v4LwaBH
	 xhCm8eJhDkE/3MJy+Pwa0Z//6e3WePoykZmliBAm0f+G00M+0wiXHZHAqio8qhwjq78oh
	 tMVezNI3dzTcsqjGZHc1rdPyiD34krOTTWu3gmGj/MkqzTDDpCF7uSkX6i3kw1dO02w==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794319897;
	h=DMARC-Filter:DKIM-Signature:Received:Received:
	 X-MS-Exchange-Authentication-Results:Received-SPF:Received:Received:
	 Received:From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
	 References:MIME-Version:Content-Type:Content-Transfer-Encoding:
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
	bh=BivtSQqIUwWNq3ZVsrdCMmnwulN+HBv0CJU4axuq6+U=;
	b=G9xVB2STNJ2edjSTuOUF9KMlpJC4nRAhvVypO/wqog+qoMcV6IeUIs4EhvlGszMc2VTt
	 ZfE2A8m3KuoGQEEjcz5AGQs84A7MkI2k7e4/tqiv2x1H/n3RmV8TliKkhl+OD19C1HvFO
	 mpUrcXW8S394sYRjNV60xCwf7JURj9BZgSc44aGm8Gpgngy5exVoSkas8ZqNqeDTS2KsO
	 XNYv0gZhULkPwWnu3tDdDHUVo4xdrayvZEpk6S4sbm3mI+Yz2OZk/o4aCGVysR2HHOspR
	 5fhlLu1l6ZeP+3bnL3FDI+sknAGXyWP4LbQ1n5UtCl01rKMktUHDe2i1qNV/hf6uOrw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b="Dim0J/oQ";
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.53.45
Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazon11012045.outbound.protection.outlook.com [52.101.53.45])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BC13606A31C;
	Tue, 10 Nov 2026 14:11:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8BC13606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=Dim0J/oQ
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tsyrOJKy+1nKP6aEgl/129Rq3H2Hob3B/BEjd3lfuKelHmKxzctwLx4pBt7T+s9lD0KNlLHEe00fFz6q99j+bEHJX5Mr/qTjdEO0i7NoMXLCA7muA0CGxy/oa9/J0grYlCF+cA0Dab8EF4fvHDDZiwYraggzb8wDS6ZXr/JJkE4L4X2V3/tN+Iz9TgJ88WQMMj4AC1Tf/DVNjVWmxftn1VU1ASj9l/W1mVP+3tt672BJg4EXmWNeG3YAeVTddUT2p9tW8aQLUniFA3lTmabhf3LaTVVqtvCklm5J5lsukMEHIkql1+dT0AQRCZU9MOOHm/pQ1PV1gOeoE8dGnwB6MA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BivtSQqIUwWNq3ZVsrdCMmnwulN+HBv0CJU4axuq6+U=;
 b=Brcat6h3Z054Z9yAZteVuEegO3masdm/hsfBo3q0nO0Mh+uGYiC5VdwP2OhFFBVfNUuFYXPBlUilh3T14FkEJ5ZlJBhFGi1583SkOWakFXvCB/5RCMuryAa1rPz+jdgihF1HdXtBRaUrCKrL3F68StArVTuinbDJXL+hfJZ200TV6t2LtRn6YzOrIInUDeTQDyoVk+08nanq4dj0j46fnRPHKOp24W97v0RcWuS4/5DLK/PiXVDXjkBmMobGlp/3Vic6zFbz5yMThSdu6OWqQ2ukg1eP45FYko6mmUneyZVM7AnT2bzlqYq+06nzUt7bQsFhdE5GV/hmP09KvK+5RQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BivtSQqIUwWNq3ZVsrdCMmnwulN+HBv0CJU4axuq6+U=;
 b=Dim0J/oQpVb9A15RoQ8K3fWtTDNXlLpiziXF5/lkJ6oSz1bAv5pYdHLWjuli0kexHyfSFRnXTjje/yBwG/1JeaJvMHiDlxUsk7BCDsfsKYqMM/FkvZfbNHsUfxkkya2D8cvuaWvfn8BJ4pogOHzvZWMXUo3ywPXFVCC9fh5d7sqQbqYmORncyw5jv/ljXOzuJqoliWJER02AJhwM3phsB/AbVfW1XHvJT2Xg7SeRLben8IqH496CKJBDXxA0m+kOy5+C4vPXZLxjlc7EHvPEN8IoR7NLA2uOyaoC3+2Zly5C3U3TXUA98YhLhOuDXvf2baX+g81n6jjG5Jno2rjpcg==
Received: from PH8PR21CA0001.namprd21.prod.outlook.com (2603:10b6:510:2ce::25)
 by CH2PR12MB4248.namprd12.prod.outlook.com (2603:10b6:610:7a::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.8; Tue, 10 Nov
 2026 14:11:27 +0000
Received: from PH7PEPF0000000A.namprd04.prod.outlook.com
 (2603:10b6:510:2ce:cafe::76) by PH8PR21CA0001.outlook.office365.com
 (2603:10b6:510:2ce::25) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.639.0 via Frontend Transport; Tue, 10
 Nov 2026 14:11:27 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.117.161) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 PH7PEPF0000000A.mail.protection.outlook.com (10.167.243.41) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.615.4 via Frontend Transport; Tue, 10 Nov 2026 14:11:27 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Tue, 10 Nov
 2026 06:11:06 -0800
Received: from nps-server-23.mtl.nbulabs.nvidia.com (10.126.230.37) by
 rnnvmail201.nvidia.com (10.129.68.8) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56; Tue, 10 Nov 2026 06:11:00 -0800
From: Shay Drory <shayd@nvidia.com>
To: <pabeni@redhat.com>
CC: <tariqt@nvidia.com>, <andrew+netdev@lunn.ch>, <davem@davemloft.net>,
	<edumazet@kernel.org>, <kuba@kernel.org>, <netdev@vger.kernel.org>,
	<agoldberger@nvidia.com>, <cjubran@nvidia.com>, <cratiu@nvidia.com>,
	<edwards@nvidia.com>, <gal@nvidia.com>, <leon@kernel.org>,
	<linux-kernel@vger.kernel.org>, <linux-rdma@vger.kernel.org>,
	<mbloch@nvidia.com>, <moshe@nvidia.com>, <ohartoov@nvidia.com>,
	<phaddad@nvidia.com>, <saeedm@nvidia.com>
Subject: Re: [PATCH net-next 05/15] net/mlx5: LAG, decouple iteration end-of-walk from MLX5_MAX_PORTS
Date: Tue, 10 Nov 2026 16:10:52 +0200
Message-ID: <20261110141052.433725-1-shayd@nvidia.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <e15d78be-1e80-469d-96e1-dd83cd90a929@redhat.com>
References: <20261103171009.563034-1-tariqt@nvidia.com> <20261103171009.563034-6-tariqt@nvidia.com> <e15d78be-1e80-469d-96e1-dd83cd90a929@redhat.com>
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: rnnvmail201.nvidia.com (10.129.68.8) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PEPF0000000A:EE_|CH2PR12MB4248:EE_
X-MS-Office365-Filtering-Correlation-Id: ef4844ad-8e02-4844-9142-08df3f34829e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|82310400026|1800799024|376014|23010399003|4143699003|56012099006|11063799006|22082099003|18002099003|10067099003|261009223027099003|261028144727099003|261026140227099003|261022105027099003;
X-Microsoft-Antispam-Message-Info:
	raRp2I6RwotfMOYWRcXOf9IscNkjX0aOZalAQP2E7+lZKUiqDz/LpbKWgJtGqNNDhP169W1LK0Yn8N03FeUtkpXeX9ijn+386Ol2IHcPmgrHcAq3jNkfO5MPtDRjZl7PlBKy+9KMTQHRyAd8SgB0tZWQxz0BgMKkpcnSHfiiPJhRglk389T8A4AgjTK3qExwQ9Qkb6UGsujbcA0n96M9dUgV1ilxT9cbkP5QsY9cHs53yOUBPQ1UZn8EX/iav7ukHi9HV1BaYN1fN+ZpuuS/XTrpvPCJz17m1I9wO9dAwK0JBsJw2Hj8YP679pZvUq7cWVH0/av+uwQeM/3P+0Yak3Zet2KKl+xFhD/Bt0TKqki614pm6qZRnjd1dTy34eAsT+xF9tGmnunn0wVntQkxlXXDBK5nYzVRhV3x2c+1m4SClsH3A08f1tApsvvTj78SGZ1JsN1V+MWOa7YTYuR6vfXn9xA1HQPHyDWGHtf1o32zFJeHDlomW39H7LCWdWgzoNRRlpn3j++acTUPVEXNa/7UyahtqMmjkMibhO+aeUlkm0MBSvBGLvZXiKmN5JhAiOlyAepuusaDkz03320bWDy4kcZBIQYLKfHHFx5TkeQi24dmCXG/h+6FvoM/PjCYbwhka0WoAUiQ0Zr1hkuTPWa04SpLY2HBV+qRgSWT3Axec1+mja0T5ePyUC5sF5vtRMrqU1rjIn9w351b5hQ1Ag==
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(36860700016)(82310400026)(1800799024)(376014)(23010399003)(4143699003)(56012099006)(11063799006)(22082099003)(18002099003)(10067099003)(261009223027099003)(261028144727099003)(261026140227099003)(261022105027099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	g+5mENEJglTCu8UFXOp0yXjvXMTSaGIvEz/RCiz/VWzy6euF+u0gSvnFHLUSJ745zIzt4COER5dWXR5eJguxraAb8sGXMU/FS7OppLt0ONmlTlJsQNggzN9AEPCK2h+a63ek9/lRg9lI4W1mJn1r96F6V/v14iRwBVK3HEmKSO1wut0TeyEu6laBltAcGkPvFSFxbx6omIWUgf6D3jaVR2N9CdDH8AduFNR9mYuKD/74/KKw/ykytq6Rq/gAPg+IU4dT4LspvFGgMQMpA17DJEprz70YXe4NIDV7i90cLjiRQ9e1K6ukA+v5ezDrjIaPB5cpivpPIbu8MJrOsyD6Q/CH1eFrdFWYV3AZAeU2ZL9J2OiMVZgNSzUyS9aGrRmv7ViewZuZS+nQOaMjdw8BiU6QfJ1KcawdaIWugQPiLM6Rtv7dpIE0HxdmZUc6lAzt
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Nov 2026 14:11:27.1285
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ef4844ad-8e02-4844-9142-08df3f34829e
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	PH7PEPF0000000A.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4248

On 10/11/2026 13:00, Paolo Abeni wrote:
> Hi,
>
> there are a couple of unanswered comments here...
>
> On 11/3/26 18:09, Tariq Toukan wrote:
> > @@ -2095,7 +2096,7 @@ static int mlx5_handle_changeupper_event(struct mlx5_lag *ldev,
> >   				break;
> >   			}
> >   		}
> > -		if (i < MLX5_MAX_PORTS) {
> > +		if (i < ldev->ports) {
>
> [medium]
> Should this compare against ldev->max_funcs, like the other converted call
> sites?
> The iterator's end-of-walk value is now ldev->max_funcs. That holds both in
> mlx5_get_next_lag_func() and in the mlx5_lag_for_each() condition.
> Indices are never compacted and max_funcs never shrinks. So a PORT-marked
> member can sit at an index in [ldev->ports, max_funcs) while the ldev still
> has ldev->ports members. One way to get there: more PFs than num_lag_ports
> join the ldev, and a lower-index one is removed later.
> In that case the inner loop finds the matching pf and breaks with
> i >= ldev->ports. idx has already been incremented, but this block is
> skipped, so the bond_status |= (1 << idx) and has_inactive updates are
> lost. The later check would then fail:
> 	is_in_lag = num_slaves == ldev->ports &&
> 		bond_status == GENMASK(ldev->ports - 1, 0);
> Wouldn't that leave this bond silently not offloaded?
> The old i < MLX5_MAX_PORTS check covered the whole index range that the old
> xa_alloc() limit allowed. This code is unchanged at the end of the series.
>
> This looks valid to me.

This is answered in the cover letter: mlx5 creates an ldev per sw_guid,
and PFs have a different sw_guid than VFs/SFs, so only PFs share this
ldev. The only case with more PFs than num_lag_ports in one ldev is SD,
and for SD the netdev notifier, and with it
mlx5_handle_changeupper_event(), is not registered. So a PORT-marked
member here always sits at an index below ldev->ports.

> >   			if (netif_is_bond_master(upper)) {
> >   				slave = bond_slave_get_rcu(ndev_tmp);
> >   				if (slave)
> > @@ -2360,13 +2361,16 @@ int mlx5_ldev_add_mdev(struct mlx5_lag *ldev,
> >   	if (!pf)
> >   		return -ENOMEM;
> >   
> > -	err = xa_alloc(&ldev->pfs, &idx, pf, XA_LIMIT(0, MLX5_MAX_PORTS - 1),
> > +	err = xa_alloc(&ldev->pfs, &idx, pf, XA_LIMIT(0, U8_MAX - 1),
> >   		       GFP_KERNEL);
>
> [high]
> Can this let member indices reach 8 or more while several arrays are still
> sized MLX5_MAX_PORTS?
>
> this is solved at the end of the series, so not really a problem.
>
> Note that there are more unanswered comments on patch 15/15.
>
> I think a v2 is need. For the future I suggest using smaller series:
> 15 non trivial patches will have increasingly hard time with AI
> reviews.

Ack, will prepare a v2.

> /P
