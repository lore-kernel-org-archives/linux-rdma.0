Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.85.23
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794858792;
	b=Fv19kK8Y0MG2oFBQvcqiZZlCp2cIqBxh/TzSGpM01hOAVNAsdLPO7I637o/Av4xf9SyZ
	 fwLfWhdzn3y/RF0a6Ia9pBlJniK87yyW8Ek4PMkfRh7H8+8BnsXArYhzygmokmYYEmqoB
	 utXl6zyLSS5qRlgiAxxSIxdlwkq9a+BDZiSVoectiZr/aSwOUPjk0tx0V7RvzJAEvEuDo
	 KarSWemHYWVbNklqZSG+YdQmBVTM+QSoKC8WBM16JpoSzhpays4lm75y4EMgyKceyEdr/
	 S7ZEdityIbDD/kR4fQgBzSW9PcUZ/BIu+4h4hQkR5w5+FwEQzb9qM0tzbdVNtcV8ggQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794858792;
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
	bh=mQ/09x4uq9jU1vzfAj5TzUhFLr0s3VBByYeEdcOjjRo=;
	b=CLDbPUlvJaRiIk8JtOcS79L0B5eVjMo2g8e10aNlaj2X9S45keIENKM+abYGH1asDa0H
	 /6lF8rLEg3d1UkIDDmtmJV/jCIOhJeFymQNIVHEF5BbCttJXWFVZHtz1emAgLdtcuOoD0
	 R8pKOe10KlEvt40oGr9Ouf1ZbRuEKJlL12U1bpQs807coZsiK+3mz4d/tf7h/K1/kq8Ht
	 u7vTNLbRL1nnQgBjFN1ssPe2bsD1cj2kx6i/dTcFaYEHxmfvGuz6sY7O1OswxTqqb41jE
	 6p8FGMUc0HEA8EBCX2DIba9f9mz9Ok8Hb0H34P2GbypsNtc6sG0wzgPKu/oVwTePcyg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=CHasZVEI;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.85.23
Received: from BYAPR05CU005.outbound.protection.outlook.com (mail-westusazon11010023.outbound.protection.outlook.com [52.101.85.23])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE951606A31C;
	Mon, 16 Nov 2026 19:53:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BE951606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=CHasZVEI
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BUEF2ZYxlJ/475yJY9rfchZowFH+dUyqA+XwPomFOk8QK3jLpYHqoGPL2Z1pvp1/wWPg4kWV4gST1uU5WRw+APUMFYHL5ZaLyWttKRHJ7rP1rEAD2Fvb1qW+aW//9k7W5QPsWPfu7RhG7Blx3TZgPy6PP2Z4+8xBocIYet9vUn68W/CMp25xhGtgVyzg+8AZ9I2iRT7Lyd67toeuJ031dFwP5rIFirPMovlJj83vbcRTFAZ+DfL09Ykvv8J1t4vCvrqaPtuCPGX5xFiqGwlTiGYxW3jGUarqHkUSscavoe7+ZNMJMv897f45gMEybxDu/NH2l9y6hoMnqbZvSFbOvA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mQ/09x4uq9jU1vzfAj5TzUhFLr0s3VBByYeEdcOjjRo=;
 b=PNitRy54CuEymbQYqyx5Xo9W5bNJ73VB5ZbRyFLkXIplGXuD7k9er16I5lINM7E/qpX+EtE4vFxWV33DQkblCZPt0Z/cmWNSWe84DLrvNaU88h8hLA3Scr4Iq90HShJxXoTcUP6o8/SeNkvVWtm35t7OolX04DjslggJyQw3oYJAza0JPhAOEGTqEqhmLQUM0weJ8TqgdUxx5qE0v98gz7TRF1Ew2MTEVquBkYQQSti6L1WIQZ5TKJDywiQadG0vGOGg8zlOIYBzXcEmgOz+v4cIfvroboPKWWIXsDo+cYL/XuNUzRuuRmcC8n8UeeS7PcUu5GkdKKIbn3fk5yrhpw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mQ/09x4uq9jU1vzfAj5TzUhFLr0s3VBByYeEdcOjjRo=;
 b=CHasZVEILKVZOsH8hvTL7TOHYOwQ5lO3fuK/Mxemt8B3liZth9slgkqxJM9gvaR5gS+YVDlEVx0p3+qdhyLaRCjzIpq4t5VQNPu6tQyl0xJnjIdbippNYHsXLutNX5dvYDCzA34HEpPYfSZcVx+1H/y4SeuQoCBJz691+xNCkop8GF5FEnxPUlUT2jz+RxwCbPIkPqrwlCFu6WLSStrG200PexLvAJSQ/Ll/K8WNaMEO+SRDk34VxYF2a1g/g7NhStJVJ85iyrymNoDqJZEp2v72bXBxZuF6i5+Athz7/X08ucgxw6SIjZrmrf5DbkZmZkdFsRnc6UVPTu0NBmpTNw==
Received: from DS7PR05CA0101.namprd05.prod.outlook.com (2603:10b6:8:56::21) by
 IA1PR12MB8261.namprd12.prod.outlook.com (2603:10b6:208:3f7::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.615.10; Mon, 16 Nov 2026 19:53:02 +0000
Received: from BN3PEPF00022BC2.namprd05.prod.outlook.com
 (2603:10b6:8:56:cafe::4d) by DS7PR05CA0101.outlook.office365.com
 (2603:10b6:8:56::21) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.639.4 via Frontend Transport; Mon, 16
 Nov 2026 19:53:02 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.117.161) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BN3PEPF00022BC2.mail.protection.outlook.com (10.167.248.213) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.615.4 via Frontend Transport; Mon, 16 Nov 2026 19:53:01 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Mon, 16 Nov
 2026 11:52:31 -0800
Received: from nps-server-23.mtl.nbulabs.nvidia.com (10.126.231.37) by
 rnnvmail201.nvidia.com (10.129.68.8) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56; Mon, 16 Nov 2026 11:52:26 -0800
From: Shay Drory <shayd@nvidia.com>
To: <netdev-bot+sashiko@kernel.org>
CC: Shay Drory <shayd@nvidia.com>, <tariqt@nvidia.com>,
	<andrew+netdev@lunn.ch>, <davem@davemloft.net>, <edumazet@kernel.org>,
	<kuba@kernel.org>, <netdev@vger.kernel.org>, <pabeni@redhat.com>,
	<gal@nvidia.com>, <leon@kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-rdma@vger.kernel.org>, <mbloch@nvidia.com>, <markzhang@nvidia.com>,
	<moshe@nvidia.com>, <saeedm@nvidia.com>
Subject: Re: [PATCH net V2] net/mlx5e: rep, Fix races between devcom PAIR event and uplink close
Date: Mon, 16 Nov 2026 21:52:18 +0200
Message-ID: <20261116195218.1120811-1-shayd@nvidia.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <179485349648.3136.17669005426251956349@kernel.org>
References: <20261112182403.3646298-1-tariqt@nvidia.com> <179485349648.3136.17669005426251956349@kernel.org>
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
X-ClientProxiedBy: rnnvmail203.nvidia.com (10.129.68.9) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN3PEPF00022BC2:EE_|IA1PR12MB8261:EE_
X-MS-Office365-Filtering-Correlation-Id: 25b27f35-12b7-4c5e-df93-08df441b38f3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700016|23010399003|376014|7416014|1800799024|22082099003|18002099003|261009223027099003|5023799004|11063799006|56012099006|10067099003|4143699003|261021123027099003|261026121527099003|261026140227099003|261028144727099003|261021121427099003|261022105027099003|261102123227099003;
X-Microsoft-Antispam-Message-Info:
	4R3mGvZrsTqyoSSCZrHwEmfADOJW2AEe6Lnvl0Z9i2maBoO1GWb5CFPvCnlW8iN99ZbmBxxzUC8aW1GEudqd4O1YywCG5C9st0ZCn2J6ccFoLH5F0TxVObqtwLmHs/JJvX7p8MD9etdfGP45vuVSvw19wYApJKUG3LFeQRwRZ3gDuATApScJKy2X4MMz7px3lZDn4opjwTaqUDAGQOuTmDyklwqFzVDAgWdu9WWlEHTOHFJBzo3k1oImUUfBMSf1uUmIEIENys5796YxuftN3DKD35CCIFZiiIPc4UPjMRcmHJ6XIW7Fi7EgE6Lbj/yZwPsN5yY/Xk0C7KZ0GYiPemJ3I4nvnnzqOL4N6wDc+qhjW5L6mft5MhUviOZgRUhLSwmw/flyxK1Ft81gKVkRXLGQHff4bUv7ltQNVrxgsmXIM0sDlyTD46+WQ2OVW8h+IUTUVLXTOF9NiwLj7rjZDemzMYFRjf5uxe5L6rjbkh+0dSx7KojtlhJEJUKzjhCF/YA4yKKlX6kzZ4wIeTC3Of8cnbeu1+HvPfjdagbZvZLKnowuytJQLWBoktvIXBWA9Ez3Wm39qKXv7zemBlwIOrZTxHbpxQiv22SjznpK+0SwzYOU50N87G7P45mcnqcPpFky1fNJIYpbLnwW7yYEy0+ens+E7osXMBXji7lLMrWvsKYgIhldWiYEVNB6LhYYG8ySWJ1ESw05YQuYaVAndA==
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(36860700016)(23010399003)(376014)(7416014)(1800799024)(22082099003)(18002099003)(261009223027099003)(5023799004)(11063799006)(56012099006)(10067099003)(4143699003)(261021123027099003)(261026121527099003)(261026140227099003)(261028144727099003)(261021121427099003)(261022105027099003)(261102123227099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	AVkbOWeqa8GySnNwa49vCntAQfmCQVWCbBL6qDLgLw1LxdIdF1S5pzLWpjg8lOIICuPGdmUimSGXgvLIee5wD3ikQZ6d/pS9Yh/cRwXsYwHXXMxuyiaokglWJql50NctYwwEJ97Z/rGwfzZ05gWBxY+6BzJobJJLpEqoCjqjlw+sRkICvgV1OZT8B/P8b9YpPkU0VJ3RMeos/voziDu1fIYQJFWvQ0c6pv37TG3AyC6BBArqqofobTcxNox5syrLLcdBEo7FHSd9LZDwUrK+8EcdODWQQM9iWYc3zPiqQQdidrwf11S3f6uHdICx2fTd9xeGbcIFCChOE1wXHaf0J/J6PcwRxeVnkJL7dRG1KW4qx7cxjwXIGQ3qdT1jd1e/jAsKHx8f/TrOpFHWadqN+JnP8+fvzYuUrhwKha0CdNB/sfqahbMtyYeBf7tyLJyP
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Nov 2026 19:53:01.8547
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 25b27f35-12b7-4c5e-df93-08df441b38f3
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN3PEPF00022BC2.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB8261

On 16/11/2026 20:24, netdev-bot+sashiko@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential
> issue(s) to consider.
>
> Critical: 0 · High: 1 · Medium: 0 · Low: 0
>
> If you believe none of the issues are legitimate, please reply to each
> issue of Medium severity or higher and explain why the AI is wrong.
> If any of them are legitimate and you plan to respin, please let patchwork
> know by including "pw-bot: cr" as a separate line at the end of your reply
> (one such reply per series is enough).
>
> - [High] The new locking only works if the unsynchronized read of
>   `esw->devcom` returns a valid pointer.
>
> --
>
> net/mlx5e: rep, Fix races between devcom PAIR event and uplink close
>
> This commit adds mlx5_devcom_comp_read_lock/unlock(), which take the
> devcom component semaphore for read whether or not comp->ready is set.
> It holds that lock across mlx5e_sqs2vport_start() and
> mlx5e_sqs2vport_stop() so that both are serialized against the
> ESW_OFFLOADS PAIR/UNPAIR handler.
>
>> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
>> index a50a42581528a..962c70b9b5661 100644
>> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
>> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
>
> [ ... ]
>
>> @@ -630,8 +627,12 @@ mlx5e_remove_sqs_fwd_rules(struct mlx5e_priv *priv)
>>  	struct mlx5_eswitch *esw = priv->mdev->priv.eswitch;
>>  	struct mlx5e_rep_priv *rpriv = priv->ppriv;
>>  	struct mlx5_eswitch_rep *rep = rpriv->rep;
>> +	struct mlx5_devcom_comp_dev *devcom;
>>
>> +	devcom = esw->devcom;
>> +	mlx5_devcom_comp_read_lock(devcom);
>> +	mlx5e_sqs2vport_stop(esw, rep);
>> +	mlx5_devcom_comp_read_unlock(devcom);
>>  }
>
> [Severity: High]
>
> Are the races still reachable if esw->devcom is NULL or stale when it is
> read here and in mlx5e_sqs2vport_start()?
>
> The load of esw->devcom is a plain unsynchronized read. The store side
> has no WRITE_ONCE() and the load side has no READ_ONCE().
> mlx5_devcom_comp_read_lock() also does nothing when passed NULL.
>
> In esw_offloads_enable(), the uplink and VF reps are loaded and their
> netdevs registered before mlx5_esw_offloads_devcom_init() runs. That
> function publishes the pointer and sends the PAIR event right away:
>
> drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c:mlx5_esw_offloads_devcom_init() {
>     ...
> 	esw->devcom = mlx5_devcom_register_component(esw->dev->priv.devc,
> 						     MLX5_DEVCOM_ESW_OFFLOADS,
> 						     attr,
> 						     mlx5_esw_offloads_devcom_event,
> 						     esw);
> 	if (!esw->devcom)
> 		return;
>
> 	err = mlx5_devcom_send_event(esw->devcom,
> 				     ESW_OFFLOADS_DEVCOM_PAIR,
>     ...
> }
>
> The PAIR handler runs with comp->sem held for write. It goes through
> mlx5_esw_offloads_devcom_event()->mlx5_esw_offloads_pair()->
> mlx5e_vport_rep_event_pair(), which walks rpriv->vport_sqs_list for
> every loaded rep and calls xa_insert() on rep_sq->sq_peer.
>
> A rep ndo_open or ndo_stop holds rtnl and priv->state_lock. The
> devlink-locked enable path holds neither across this window. If the rep
> reads esw->devcom before the store above, two things can happen:
>
>   - mlx5e_sqs2vport_start() snapshots devcom == NULL, so it takes no lock
>     and sees peers_ready == false. It then does list_add() into
>     rpriv->vport_sqs_list while the PAIR handler is walking that list.
>     SQs added after the walk also never get their peer send-to-vport
>     rules.
>
>   - mlx5e_remove_sqs_fwd_rules() calls mlx5e_sqs2vport_stop() without
>     the lock. That can list_del() and kfree() a rep_sq and its sq_peer
>     entries while mlx5e_vport_rep_event_pair() is still using them.
>
> These are the two races the commit message describes as fixed.
>
> On teardown, esw_offloads_disable() calls the devcom cleanup while the
> VF rep netdevs are still registered:
>
> 	mlx5_esw_offloads_devcom_cleanup(esw);
> 	mlx5_eswitch_disable_pf_vf_vports(esw);
> 	mlx5_esw_offloads_rep_unload(esw, MLX5_VPORT_UPLINK);
>
> mlx5_esw_offloads_devcom_cleanup() frees the comp_dev before it clears
> the pointer:
>
> 	mlx5_devcom_unregister_component(esw->devcom);
> 	xa_destroy(&esw->paired);
> 	xa_destroy(&esw->fdb_table.offloads.peer_miss_rules);
> 	esw->devcom = NULL;
>
> Inside mlx5_devcom_unregister_component(), devcom_free_comp_dev() does:
>
> 	down_write(&comp->sem);
> 	list_del(&devcom->list);
> 	WRITE_ONCE(comp->nr_devs, comp->nr_devs - 1);
> 	up_write(&comp->sem);
>
> 	kref_put(&devcom->devc->ref, mlx5_devcom_dev_release);
> 	kfree(devcom);
> 	kref_put(&comp->ref, mlx5_devcom_comp_release);
>
> The write lock only excludes readers that already hold comp->sem.
>
> Could a concurrent VF rep ndo_stop load the old esw->devcom in
> mlx5e_remove_sqs_fwd_rules() and then call down_read(&devcom->comp->sem)
> after the kfree()? The stop path did not touch esw->devcom before this
> patch, so this use-after-free would be new on the close path.
>
> Would it work better to serialize publishing and clearing esw->devcom
> against rep start/stop, instead of locking whatever pointer happens to be
> read at that moment?

The esw->devcom NULL/stale reads are a devcom lifecycle issue, not
specific to this patch, and will be addressed in a separate patch.
This patch fixes the PAIR/UNPAIR vs. rep start/stop race on an
established devcom.

>
> --
> Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261112182403.3646298-1-tariqt%40nvidia.com
