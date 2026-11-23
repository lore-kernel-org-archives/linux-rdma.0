Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.61.17
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795428655;
	b=L/lFsbbG8Vd1BplVq63Nfd2rWDg6h5mI8Q6ozNpwjOofq3amjXOjj+fP6Dqr/vG+mvsR
	 v1jRNUM1tWLcLGMtlMdXwN9LRB9HKgIORtQGyA0y6ytF/i6nll/sM9hiXT8Mr45+ZX58R
	 7eDw4z3O7nFHlCMZnzwPYuOS9KTraQtu4ESRDQ85DWEkQVq/pTjVt501Y5/CBEayil0fy
	 dmbhLQsJpLFzMKyUND9PJ4G5yZ6oS23mIvY01UPUxCQmOVk8CxhK4v0VYfAJI1MNqSrVm
	 XSJFw/M4nLdkl8c6dt6klE1pfSyVpzappfL5iX0AvyQJFkUkTO70p4qM2YDizdHDBFw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795428655;
	h=DMARC-Filter:DKIM-Signature:Received:Received:
	 X-MS-Exchange-Authentication-Results:Received-SPF:Received:Received:
	 Received:Message-ID:Date:MIME-Version:User-Agent:Subject:To:CC:
	 References:Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:X-Originating-IP:X-ClientProxiedBy:
	 X-EOPAttributedMessage:X-MS-PublicTrafficType:
	 X-MS-TrafficTypeDiagnostic:X-MS-Office365-Filtering-Correlation-Id:
	 X-MS-Exchange-SenderADCheck:X-MS-Exchange-AntiSpam-Relay:
	 X-Microsoft-Antispam:X-Microsoft-Antispam-Message-Info:
	 X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-Id:
	 X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=CU2Ol3e2ETvYiNKS8DMRqokxdRqY4DHV+b03CeEi2hA=;
	b=eJnsxe8setGL/IuKYnYQSSMTeYxTk+NkJ8tsunyNQ9Tn0tYtU+wZZXHAe77arSHupngQ
	 WUJHe3HdEczh5qvXKqBXcLvN2Js6zr/qMce/wDdht8CBF29FvmlXAhvgnBrxokfIqlBiT
	 dXT9k7ORGynwZdM0fj9HZK9rodM/PBMgWWvlLe0f9rKInH46RytKq31985KTwN3obbqAx
	 Fl/l3r0z06/E/xhT37vFGFmhVR5yb42S9UCGAJ+/o/RwGLtWfT/HB8SN0Gq2OWtsd5Kiu
	 uXS6NoeQoYykO2mi3cRxoA8E6KDjNzb3kFTBNfOvQUkY6dUN+xY1Bd89uPYDCJ6hKwQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=oNfTy0hW;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.61.17
Received: from DM1PR04CU001.outbound.protection.outlook.com (mail-centralusazon11010017.outbound.protection.outlook.com [52.101.61.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B774606A332;
	Mon, 23 Nov 2026 10:10:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9B774606A332
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=oNfTy0hW
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JabmtaroAgqSnDNPFFCX4K3KuSAweSF2j7RVQvFdVKEQfteCU8IxtWNaWOficO47KHqUEEj+v5TEquFBlLN89V8MuBV/R5SeJq/WdyAsIbfK3V9I9TKNgtZjwTBJqHjdjCfYket/19Sg4ClJdYrHXB/0Lnhg2+pZL/TOBv8wBcUGFS1R7aDYfmDe8XQE6fbpTJZyIVdrsdj+mat3ZfMk5gQicHLIIiFuAzFuPUP7QTR4Dj6DqGyZxwIwATGi9b+76kA+eLRsnxNpRbZzGB2CjQrNqqRIMbT1vteyMMXyW4C/sk2jARdrBUosxcgZ5WkibClT4+dPZTyXNfmuA1eF+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CU2Ol3e2ETvYiNKS8DMRqokxdRqY4DHV+b03CeEi2hA=;
 b=xZvmygPtcj4D9Y/m3YRuvUajdwKn/PHtG+4BGO1kyhkwvuQ3wXPX7nKjGjfaQiTwLvAwkjFzmP1s+vnuiGr83UQrQ4d4pZlrf6Z9W4GlsmzBARGmlXeDspFfBvVTRUVCS6WNmYGeWGFa9jHTQyPusiL9X5H1SlBCkQbU7Uqim7wujSc6Cnm8+9mmH8IVo0c6w+vTPmClKkoLEF+I2W+Fpl/Vo0dvnho1NeiEna7h7n/Ckmcuf7cjqpLQ91oym+NN7ZecFKnt2cTb/xyImIbE1/+e5egynQqNshIYh5Z3GGQoHz8u4HTRJWwXThVD+AkOqW6952xSzxqkHdD0l2aeeA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CU2Ol3e2ETvYiNKS8DMRqokxdRqY4DHV+b03CeEi2hA=;
 b=oNfTy0hWw4qGRvob4JfRS45lNbn+5xoKNGNGXNJ8D8N2AGeQufsm8UlhwTdmVTM2Jhoh6YKOPcimMmx6q8BS11L/+I67lPWMVXbQKPhU5xrAqJ3wmdnX/da2kdJ3vLItsVhYg+WYwlhEDRKWP8AmCmi9/MXrYTQO1UvIDl+PHKaRrFGsGACD+Bo/p8gjuXE4baMjPGerIuyEmHJMe50P8s03pdR4s0n9mrRQcP7VEf2haAqUMCjS0ZgiKE9IQKjKHwM0DwWOGlcxF3f/uWBjBY1jBVSB2X0DqbLDF0d78Vty4FYSsazrM43Y3YdX6zxnjs6JhkhFML0x/po7zbD9tA==
Received: from BY1P220CA0009.NAMP220.PROD.OUTLOOK.COM (2603:10b6:a03:59d::7)
 by PH7PR12MB8107.namprd12.prod.outlook.com (2603:10b6:510:2bb::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.639.12; Mon, 23 Nov
 2026 10:10:41 +0000
Received: from MWH0EPF000C6186.namprd02.prod.outlook.com
 (2603:10b6:a03:59d:cafe::64) by BY1P220CA0009.outlook.office365.com
 (2603:10b6:a03:59d::7) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.639.14 via Frontend Transport; Mon,
 23 Nov 2026 10:10:41 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.117.160) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 MWH0EPF000C6186.mail.protection.outlook.com (10.167.249.118) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.639.5 via Frontend Transport; Mon, 23 Nov 2026 10:10:41 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.57; Mon, 23 Nov
 2026 02:10:25 -0800
Received: from [10.221.229.87] (10.126.231.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.57; Mon, 23 Nov
 2026 02:10:19 -0800
Message-ID: <f765cd8b-0624-4ccb-90c5-417563c3d229@nvidia.com>
Date: Mon, 23 Nov 2026 12:10:16 +0200
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net] net/mlx5e: TC, fix a NULL pointer write in the peer
 flow error path
To: Zhao Li <enderaoelyther@gmail.com>, Saeed Mahameed <saeedm@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>, Mark Bloch <mbloch@nvidia.com>, "Leon
 Romanovsky" <leon@kernel.org>
CC: Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
	<davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>, Jakub Kicinski
	<kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, Moshe Shemesh
	<moshe@nvidia.com>, Akiva Goldberger <agoldberger@nvidia.com>,
	<netdev@vger.kernel.org>, <linux-rdma@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
References: <20261118025708.86215-1-enderaoelyther@gmail.com>
Content-Language: en-US
From: Shay Drori <shayd@nvidia.com>
In-Reply-To: <20261118025708.86215-1-enderaoelyther@gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWH0EPF000C6186:EE_|PH7PR12MB8107:EE_
X-MS-Office365-Filtering-Correlation-Id: cb4c8ece-cab8-44c5-cc79-08df494a07a5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|36860700016|1800799024|82310400026|23010399003|11063799006|261021123027099003|10067099003|261022105027099003|261028144727099003|261022075727099003|261026140227099003|56012099006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	qIP6HNgQqbSHivIAluVmW7McWX9VQK8qlpyOuh0r/OPw96rBhSk3Cib1vo+Zqc9D4wClA7+xy35vcavyY2mPFSOF3e5AmejZ2Xv0EQ2ml9PhgnERj6jAHS6Vwymf5eO+uaQsCjK981x5BFib2zqu1fi523dC1O5ZmY8AZpeVVVs+aW1lvWhzSFXv5V5HuwSjwebjr8Ru9UiKX/OfDdw9wiBa2eMoC/FSHibjdgRySvuCJEJlua0msJ8RtXy6lY0O1geVi+0wdsxPDwDHQkBgEShQy5Dh3GjEgygvr+vr6MP+goiUSO6hAhGrsb6lTDYgHF+3tai0rSQ8SbFXgWCgdWTyoKPTf6gD1QY3j1Yk9nlxiy49eN4dFqZ0YvZK9Kd7ATHBjxJudoaSMjN6Ii67Wo0/5ofEWFCissmnHfn5CWKiREkHh9vppDUJYfv2a8N7/b4Q9XF1oslgi31UqwpcpbUWqVHsllXT6WdYEZ6QAlvC7ObUYJ3GP8c1XK/ezYcf5LFY6JKkkRdVmCogMpySsW7J93I4l/+WB4wu/OZwRn2/vD9Wv4wJOCvgfvSXcKo0zUX/V8qMsS05egRRrYU55PFn3QfH0ltNoNTwDjbOhShUlxOtRfWjnDGVEsusMIENRWPU4v0miFdZ/LcKePWJ89mnQOzvsnjFJSp7XUIdq2jGQgzOGJk+rAZAniPVG+URYNnPX4NAR4TJoDfI/jMKOA==
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(7416014)(36860700016)(1800799024)(82310400026)(23010399003)(11063799006)(261021123027099003)(10067099003)(261022105027099003)(261028144727099003)(261022075727099003)(261026140227099003)(56012099006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	Lc4JZrfi9VmftamvyR7kLJaObzIgr8Cc8Aha9XU4zTyFZBwKDQd1ykLx6KZdU/zGgoHH1oUkMGolC/lshH5MIY3BbX2ARIkkYZIxA1aQlz7qocLDhjrgw5hXJJlEik9aTdkyaqKIWKtFjriys1bpjJtpsI1Ma7SupDOHnrHLx2Ov/CiK9cE9hG+/hiE0hen+LwQ8tzL5lt7AGUfMXMTAJWxSKNF1byx/BlFvu5aHn38bo9X29w9tuJRltzRmOfN4oCwNOeKbFSdyjzsUPKsSooE/7A1QZ4+WOV2YcKUEYzueO6UkPUFK2IpOFp4PDNFfTIObmvTz3b6ooY/2BPHMBG5IFSY+byfxW49HoFaAZDeLhwDXooLh0u3J/8DLZhJbwYbdNxubcK8WYf7gQsP/IPuljOvOGqVxTrME7LXKnHb/VppZ11BQXXx808u1lGzp
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Nov 2026 10:10:41.3655
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: cb4c8ece-cab8-44c5-cc79-08df494a07a5
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MWH0EPF000C6186.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB8107



On 18/11/2026 4:57, Zhao Li wrote:
> External email: Use caution opening links or attachments
> 
> 
> The peer flow add path hands the duplicated flow over to the origin
> flow before it looks up the peer entry for the peer vhca_id. When
> that entry is missing, the function returns -ENODEV, and the caller
> then deletes the duplicated flow with list_del() on its peer node, a
> list head that was never initialised and never linked. list_del() on
> such a node writes through the NULL page.
> 
> Look the peer entry up before the duplicated flow is created and
> handed over, so that a missing entry is reported without leaving a
> duplicated flow behind. The entry cannot change in between: the peer
> loop in mlx5e_add_fdb_flow() holds the devcom component's read lock,
> and peer_flows entries are only stored and erased by the pair and
> unpair events, under its write lock.
> 
> Found by code review and not reproduced; compile-tested only.
> 
> AI assistance was used.
> 
> Fixes: 9d608a40c2d4 ("net/mlx5e: TC, track peer flows in a vhca_id xarray")
> Signed-off-by: Zhao Li <enderaoelyther@gmail.com>


Reviewed-by: Shay Drory <shayd@nvidia.com>
