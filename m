Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.48.51
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795517529;
	b=XUfHdgAYbSgIZNNvJT1ReNht2y7CuA3B6dddvGHHoMnpYGvmjvKJ20rwZr/AXZKQl0pa
	 MktsCPNXPllJuVBzyBLi6iJiGSHDeNpXZWRxqauAjCRauO4WvUYUZEGPZxCPoghIG10mT
	 HGvEXYEYqtDxjIMHgjix5jRGr01/YnAr/IBwFrb7QTkeyzWshcAsThOaY90lRmTaZBn5B
	 P+9ElgEK202l2FlvKiYrwC/RSaPSdAM2Ip50ujo6ci95B/Fv2PvYj5/opB7rI1kpaFLLR
	 DzsvKVYUjxyomMlT2SWAX84AuknmBF5eOzUHJO0PCdpLaqD/tLuGr2NryB1Awst+OeQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795517529;
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
	bh=Pk0I/CGpDS2q/x0h4Km5qz56JqnLpgbXayckhbtOzG4=;
	b=kIJV2nD9l0zmN2zrUu9va+eL81qsu76dTEqAvDj5rSyTH0o5fU2c12CaRbdZASTFZY3W
	 wyrm7jg+EiXjkpuNVw8ryk0cL2ycOrUYFrm+Q1QBMdl0yfyq3mIP3qG2LlXzxaxd35wBE
	 5FadWsPVgIM6/PPikG4XEzzc1c8p8v+ZoDeNaGMY6KpYUa4Z9gMBG+ovsPqMil/LhP+Pl
	 0IiEbbvPnOTMsUe6oc8OzDC+L82h4PzLck3Ffo3U2OeUE6B1ayV6VZquoSjF1d0r42ZnZ
	 svuX5Fw6I1Tk/DVzUF65NBgg0ODRJ0aFb7c84oI21WIa04uKeMfAibBi23iabLVlAXA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=DNrsO04J;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.48.51
Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11012051.outbound.protection.outlook.com [52.101.48.51])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EC4C606A31E;
	Tue, 24 Nov 2026 10:52:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1EC4C606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=DNrsO04J
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=b/pspp2ZymHObMV0cOwP6Hm/29M8PElziwYfVJDLduDo2ANejQqV9cI36lyfQoX4nayRM4g4S3GHo0PgbjqxR41N/JLyGCvX3GhdWuvzQiB8u9m+q10FQkLVNOl7WPOpae8MlHugsycCGLM/Nm/uGOznLfXrXU/+2MXhqHhHCdINud+y3yfVR7Vf5ecoFLBtKv+dKds5OgkOUxA3fzw+K/ex7/zU/2mTdfwawq4RM4nr6UlQUT+aYYh0Ns2RP48fmoe3HNcMTJhi0duuIQ+kxuYHBwtdFZoh2iX2oZxGMeulmPaebjJhMclo9Wb/iDmEcDcJh7It5cdKZWjtuBrmJQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Pk0I/CGpDS2q/x0h4Km5qz56JqnLpgbXayckhbtOzG4=;
 b=Z3ZCROhcQZpwYvsHHMm2nu3kGRVc8vZ2L3nVylL3cHAdfiKRa+RRA2TZq/FW/7H25xwQ44e06PEXyRxjIfuTQChD/xRxd+AAlEWCST4Vj5WJE0r7euk+FvBjhXaMIUhHd0649TMuo4i9VxSxBbKJuErhCA435fDK3db3ndw58ALbdOI6iuLludU1qzWLJnQ/7SCifNY2+rvMvQ5bBxgF9YjOdrtJhSKLj5PCoyLUZQatdIpJX5inxMXOWjGe3VnNZS6lzUO02+6vShFxK6lkFFPxFtUJJ/60PHRY1K5GPOJgBipIqmNPJWaDvOgFfNsABeacrRuG9djQrdzd8lhCOw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Pk0I/CGpDS2q/x0h4Km5qz56JqnLpgbXayckhbtOzG4=;
 b=DNrsO04JbwR54FLL1hA9uhjwgM5iTzTOqC7T5RJRN3oEuf9CIDb/M6aamayKakAb+aLdlH01w3fgBb68rZmqb9uNG1AURUCVmmOOMFxXGWYpZdEOf9xV3mNNxcoV1tG+X5u2AkgZPicS3LoE19yLCb6dgdnS3Azk8MWo9j79l41+fR0mJc1KbJ9MHvUGUoXT8j2+BMMEqa4Nco7K52L1L61jOwtdxIqkrBYLhBqk3HYZNTWr34htWRgJliRJE21vk8vikUZXMP8axt2EzOly1EdJmGc15wUodNhUnWgFeiH4X3jhpezVVlsnNW867Y0AW7n3y+MSsb88nUWUSkYN7g==
Received: from SJ0PR03CA0224.namprd03.prod.outlook.com (2603:10b6:a03:39f::19)
 by DSVPR12MB999284.namprd12.prod.outlook.com (2603:10b6:8:41d::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.639.13; Tue, 24 Nov
 2026 10:52:04 +0000
Received: from BY1PEPF0001AE1A.namprd04.prod.outlook.com
 (2603:10b6:a03:39f:cafe::3d) by SJ0PR03CA0224.outlook.office365.com
 (2603:10b6:a03:39f::19) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.639.14 via Frontend Transport; Tue,
 24 Nov 2026 10:52:04 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.117.161) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BY1PEPF0001AE1A.mail.protection.outlook.com (10.167.242.102) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.662.3 via Frontend Transport; Tue, 24 Nov 2026 10:52:04 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.57; Tue, 24 Nov
 2026 02:51:52 -0800
Received: from [10.125.204.85] (10.126.231.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.57; Tue, 24 Nov
 2026 02:51:47 -0800
Message-ID: <1d674c41-a897-4aee-a88b-b41280b8419a@nvidia.com>
Date: Tue, 24 Nov 2026 12:51:39 +0200
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
Subject: Re: [PATCH net-next V2 3/5] net/mlx5: E-switch, drop master egress
 rule under a SW vport LAG
To: <netdev-bot+sashiko@kernel.org>, <tariqt@nvidia.com>
CC: <andrew+netdev@lunn.ch>, <davem@davemloft.net>, <edumazet@kernel.org>,
	<kuba@kernel.org>, <netdev@vger.kernel.org>, <pabeni@redhat.com>,
	<agoldberger@nvidia.com>, <gal@nvidia.com>, <jgg@ziepe.ca>,
	<leon@kernel.org>, <linux-rdma@vger.kernel.org>, <mbloch@nvidia.com>,
	<moshe@nvidia.com>, <ohartoov@nvidia.com>, <saeedm@nvidia.com>
References: <20261120075959.2533702-4-tariqt@nvidia.com>
 <179550916987.3135.15857697066223649709@kernel.org>
Content-Language: en-US
From: Shay Drori <shayd@nvidia.com>
In-Reply-To: <179550916987.3135.15857697066223649709@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: rnnvmail203.nvidia.com (10.129.68.9) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY1PEPF0001AE1A:EE_|DSVPR12MB999284:EE_
X-MS-Office365-Filtering-Correlation-Id: 135491e3-9ec7-453c-d1fd-08df4a18f9d9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|376014|7416014|36860700016|23010399003|6133799003|18002099003|22082099003|261009223027099003|13003099007|261021123027099003|261021121427099003|261022075727099003|261022105027099003|261102123227099003|261026140227099003|261026121527099003|261028144727099003|56012099006|4143699003|10067099003|11063799006|5023799004;
X-Microsoft-Antispam-Message-Info:
	uJ44nhgFpzrgnfYqWQrstzu7xGsk5v5l+5tMsuuvDP062GjOBv3lu+SYx3aaDza/2iXL/+w9yjpbKiMjrHjRYPtuW+CldYE0B/0HUeYLT64l/ImistDXrc5vZ53H/q8hXpkuGF/GhSgn1WGbSTtFcNASR6J6xTUmQoxVblPFBWqpk/5tS01oeFxxsF5QnfIo0cuVuPld7yhfTsODWbYD2H1VXBXJjXOk/V0g8QE0c7vdcTyzDBU3SviYTaUNrV0PxRla/dgcOt5ZxDjJFnE92IuY8NdJjoEJIWdCONsyke+aVgDCffUHdBMJKZAo+SL58rzjCjmGSu/PIL+JWL77MQFpZuhD1G9/P7wgE6JajgshdUfCxE+UpllpVueHNByLZ5ecVYxiY3llhx6HPSXNYVIZrZvVMI8J6AYt7XMCSEiQ/B3mN8T8LKS5PGEQBTq9ei+3Xtz15c0laNhGS9bQLpoQwRhmMHhBHOX5WXZLRziF4gJzrhVNmp7FltYy8xfGs1c09BDTxmHfh7dKmq30y09ZS9uhDCOTozsNpf/8i/gadYB3yHGormnofsyvYxZEvXKwcNIE4pXspjTojFnHE+Px5OKaMA9RYTvoPznt853MJfs479+aCRNQoR+/ldtvg38cMyMyZC2wEYp4HhgZ4oCHjQaVkbeyokYk//Xv6VjzhxJgFBCD5hyb08IknOqr/4dRaBiTfxgPVXyGAJs94w==
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(376014)(7416014)(36860700016)(23010399003)(6133799003)(18002099003)(22082099003)(261009223027099003)(13003099007)(261021123027099003)(261021121427099003)(261022075727099003)(261022105027099003)(261102123227099003)(261026140227099003)(261026121527099003)(261028144727099003)(56012099006)(4143699003)(10067099003)(11063799006)(5023799004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	4ipJD7XbEqlV8fCvhCAMMku5EVWmAZJJjzwf59iCU5I5F2i2HZusvuxc+ld8+FsikcJpingktknzOWQrU/iwPAnaSe+eQBJ6i5ndMhP6bv4tazBOm//xzMTo3+znsUIJ7dobMFWO3FFROO3eHGs9gbG7x5GcraRaMETpuHyvpLEfTWEGd6qfsRJDOrmkOFolFuj6+uAHHqUQGb6ZaTxnrrS6LKm7JK3AsP6XHSF/+a5evf8EhbkDl8vAwCvH6ou+0FdpQEW6ctSEm2y8tM39WIsahEffV06wLuUwgzWP2uW6drXZq3kkOMZ+VnSMbQlKO8R5RjgStE4pdYGDFPcX5p5KhRvlvUdrLMqwCNxYd1Re0IndRIRAN7eS4DR+D8kCalRtmhNBtF0NhLK2OGZF2cgnuEg+Q3w6jQYDqLVXE5v9LvpwFY71TGwKspwJtS3r
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Nov 2026 10:52:04.1005
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 135491e3-9ec7-453c-d1fd-08df4a18f9d9
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BY1PEPF0001AE1A.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DSVPR12MB999284



On 24/11/2026 10:32, netdev-bot+sashiko@kernel.org wrote:
> External email: Use caution opening links or attachments
> 
> 
> Thank you for your contribution! Sashiko AI review found 2 potential
> issue(s) to consider.
> 
> Critical: 0 · High: 0 · Medium: 1 · Low: 1
> 
> If you believe none of the issues are legitimate, please reply to each
> issue of Medium severity or higher and explain why the AI is wrong.
> If any of them are legitimate and you plan to respin, please let patchwork
> know by including "pw-bot: cr" as a separate line at the end of your reply
> (one such reply per series is enough).
> 
> - [Medium] mlx5_eswitch_offloads_vport_lag_del_one() calls
>    esw_set_master_egress_rule() for every slave that passes…
> - [Low] The commit message describes the conflict as a general property
>    of the software vport LAG: the master egress rule redirects the…
> 
> --
> 
> net/mlx5: E-switch, drop master egress rule under a SW vport LAG
> 
> This commit removes a slave's eswitch master egress rule when the
> software vport LAG slave egress rule is installed. It restores the rule
> when the vport LAG is removed. It also moves the MPESW metadata cleanup
> in mlx5_lag_disable_mpesw() to after the shared FDB is destroyed.
> 
>> The software vport LAG emulation cannot. It is a catch-all rule in the
>> slave eswitch's egress ACL that forwards to the master's manager vport,
>> while the master egress rule redirects the packet after the FDB - past
>> the point where the slave egress rule is evaluated - so the bounced
>> packet never reaches it.
>>
>> The two therefore cannot coexist: drop the master egress rule when the
>> software vport LAG is installed, and restore it when it is removed.
> 
> [Severity: Low]
> Is this conflict already present in shipped kernels for MPESW over SD
> groups?
> 
> Before this patch, MPESW over SD appears to install both rules for the
> other SD primary:
> 
> mlx5_lag_enable_mpesw()
>    mlx5_mpesw_teardown_sd_fdb()          /* clears fn->sd_fdb_active */
>    mlx5_lag_shared_fdb_create(FILTER_ALL)
>      mlx5_activate_lag()
>        mlx5_create_lag()
>          mlx5_lag_create_single_fdb()
>            mlx5_eswitch_offloads_single_fdb_add_one()
>              /* master egress rule for each SD-primary slave */
> 
> Then mlx5_ib loads on the master:
> 
> mlx5_eth_lag_init()
>    mlx5_cmd_create_vport_lag()           /* sw path, group_id != 0 */
>      mlx5_lag_create_vport_lag()         /* FILTER_ALL */
>        mlx5_eswitch_offloads_vport_lag_add_one()
>          esw_set_slave_egress_rule()     /* only this, pre-patch */
> 
> Following the commit message's own reasoning, that pair of rules
> misdelivers traffic.
> 
> The software vport LAG came from 98d56915eef5 ("net/mlx5: LAG, introduce
> software vport LAG implementation"). MPESW over SD came from
> de464720489c ("net/mlx5: LAG, add MPESW over SD LAG support").
> 
> Could the commit message say that the existing MPESW over SD
> configuration is affected, and add the matching Fixes: tag?
> 
>> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
>> index 57f58e79478e4..2072921c1fffa 100644
>> --- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
>> +++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
>> @@ -3380,12 +3380,32 @@ void mlx5_eswitch_offloads_single_fdb_del_one(struct mlx5_eswitch *master_esw,
>>   int mlx5_eswitch_offloads_vport_lag_add_one(struct mlx5_eswitch *master_esw,
>>                                            struct mlx5_eswitch *slave_esw)
>>   {
>> -     return esw_set_slave_egress_rule(master_esw->dev, slave_esw->dev);
>> +     int err;
>> +
>> +     err = esw_set_slave_egress_rule(master_esw->dev, slave_esw->dev);
>> +     if (err)
>> +             return err;
>> +
>> +     esw_unset_master_egress_rule(master_esw->dev, slave_esw->dev);
>> +
>> +     return 0;
>>   }
>>
>>   void mlx5_eswitch_offloads_vport_lag_del_one(struct mlx5_eswitch *master_esw,
>> -                                          struct mlx5_eswitch *slave_esw)
>> +                                          struct mlx5_eswitch *slave_esw,
>> +                                          int max_slaves)
>>   {
>> +     int err;
>> +
>> +     if (mlx5_sd_is_primary(slave_esw->dev)) {
>> +             err = esw_set_master_egress_rule(master_esw->dev,
>> +                                              slave_esw->dev, max_slaves);
> 
> [Severity: Medium]
> Is this restore correct when no master egress rule existed before
> mlx5_eswitch_offloads_vport_lag_add_one() ran?
> 
> On the add side, esw_unset_master_egress_rule() returns early when
> vport->egress.acl is NULL and does not record whether it removed
> anything. Here the rule is recreated for any SD-primary slave. The two
> sides only match when a shared FDB installed the rule beforehand.
> 
> mlx5_eth_lag_init() creates the vport LAG whenever mlx5_lag_is_active()
> and mlx5_lag_is_sw_managed() are true. Neither checks the shared FDB
> state. With an active LAG that has no MLX5_LAG_MODE_FLAG_SHARED_FDB
> (ROCE, or SRIOV with shared_fdb false), the sequence would be:
> 
> mlx5_do_bond()                          /* no shared FDB */
> mlx5_eth_lag_init()
>    mlx5_cmd_create_vport_lag()
>      mlx5_eswitch_offloads_vport_lag_add_one()
>        esw_unset_master_egress_rule()    /* no-op, egress.acl NULL */
> mlx5_eth_lag_cleanup()
>    mlx5_cmd_destroy_vport_lag()
>      mlx5_eswitch_offloads_vport_lag_del_one()
>        esw_set_master_egress_rule()      /* new ACL, group, bounce rule */
> 
> Does this leak the egress ACL table, flow group and bounce rule on the
> master's manager vport? mlx5_deactivate_lag() only tears down master
> egress state for a shared FDB:
> 
>          if (test_bit(MLX5_LAG_MODE_FLAG_SHARED_FDB, &flags)) {
>                  mlx5_lag_destroy_single_fdb(ldev);
> 
> The leftover bounce rule would also redirect traffic that reaches the
> master's manager vport into the slave eswitch. On a later shared FDB
> activation, esw_set_master_egress_rule() would find the stale entry:
> 
>          if (xa_load(&vport->egress.offloads.bounce_rules, slave_index))
>                  return -EINVAL;
> 
> so mlx5_lag_create_single_fdb_filter() would keep failing until the
> driver is reloaded.
> 
> A non shared FDB LAG from mlx5_do_bond() needs the netdev notifier.
> mlx5_lag_dev_alloc() registers that notifier only when the allocating
> device is not SD capable. So this path seems to need an SD primary in
> the same ldev as a function that is not SD capable. It is not clear
> from the code that such an ldev can exist.
> 
> Would it be safer for add_one to record whether it actually removed a
> master egress rule, and for del_one to restore it only in that case?

No. vport_lag_del_one() is reached only for a SW-managed (SD or virt)
LAG, and such a LAG is only ever active with a shared FDB.

> 
>> +             if (err)
>> +                     esw_warn(master_esw->dev,
>> +                              "Failed to restore master egress rule (%d)\n",
>> +                              err);
>> +     }
>> +
>>        esw_unset_slave_egress_rule(master_esw->dev, slave_esw->dev);
>>   }
> 
> [ ... ]
> 
> --
> Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261120075959.2533702-1-tariqt%40nvidia.com

