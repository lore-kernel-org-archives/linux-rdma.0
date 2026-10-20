Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.52.19
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792482351;
	b=03LIciybpK21LNHeMf8PU99fG+HEZrtJV4mqQXyJQgWabz5H2kt+1ubBbp1tDb8qhsz5
	 HVD+1LSmizCbQUmkRft4SPdbGmPRPHOt7jDm+RO1hlvQ1WJ4p8I0EVImrTtZJYG9jeWcs
	 nMLAfcV2+z9CuzfDYL72O1Sd/6TFY06wmQMR2v1LPAIbUylAZxpf4JiBQzPYz+BPqQ1Mx
	 tbnD90xb1c4Cg7eMBOFO50qlhd2vm6rXMi90kQCi2bE2hPBBQj/AnWFB3ydikWB79OnLZ
	 ku6uGFP1HJGTVoGH/JQaIvjJirFM6uqSbsALuPCYWFr5lWW34ZYIommvT5/o/Dz1EbQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792482351;
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
	bh=qhWhDpMncqGPHchBTlGFIns20uwVdpZvbF5pdNoDL/8=;
	b=fOYkUc0ZpGjJ7z8vvC6dIrhF0SVaTG7ElyWynBc3mhC83v5tyugg+pGt5W3JPs8kMmyy
	 +rMDh7mV7NU7y8ahU7yOpuGACmd9DEZNl7fgL6cKy1s/C2yTIIpf8jWmFNLCPgh+S5deT
	 teWL9P2AYxS2Tu3GKvkgV0glYo6LZlgxutTkdLJqVQ0DWjFT2fZAUsiWdjKdHVH9zzWuV
	 gLGifh/leQwSi6YIO9r1xwa4woSPcZG2aG4ZTgqzbdQn0I3KlUhtbQTIW1VF9WV9YuDBf
	 xpr61fUKVwKsGTrK/oAHSBlhOXm2pj8XscqJ79T5y08lVLvIH+/7CCI/1qwh/IIR0VA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=h+Mabx+t;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.52.19
Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11011019.outbound.protection.outlook.com [52.101.52.19])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24A9D606A329;
	Tue, 20 Oct 2026 07:45:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 24A9D606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=h+Mabx+t
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jlSZHnEyUdTsnDyDTztur8T7sb82gf+PffyhO5ydRhRUVIIJj6OClOJkAFoM1Ds9i246/wcS5QDGdFIfoZ0meTFeNAgwRmnuSkXcTw7Ol0DwaifJ/AheDz662Yl0Ma639A3vYjA+93WIjDcgDG4dPAtbuqOjhvFxRioCqsDDQrkTMriaDcLc/eT+rxRRxoeOKbaHJ9OLHvA38xUi4jKniK4gdSIuvaBoxwOhDaXqDLnFZIATyIdfjd54W/laq6EI5tOKWW+h2N3kdjLwKnjT6POkIA53tdbedld0dCk0kqrifKoJ/I1uWe7WTZJVQU+rkNBb1XNt3zDFHTkvqYashg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qhWhDpMncqGPHchBTlGFIns20uwVdpZvbF5pdNoDL/8=;
 b=nQZwiHtepkbaAhnuaGwl/WV+xwphmXJd9I282JQGgf0Uji/cpaw/OzbS8H4vC9lXfEbIsnf63gTl4ZNEL6C3BkT5DGSkHwUswVbSBPfwXyxamcwYug6vMGVA47mqEloqsi8WXRLNAy3IJ/522RokNZQC0FpnH57vnMVgHx8olhyb712oAp8w1HUf3s4V0o3PxMz8tGXTXW8EY9Im74/QEr2RvM1QtVzBcOD56nBArvflr5wjaz0Nzor/mqCU/auZb+QnE5TCoabg3EH43LHf8+uBt+kbydheK9swzktS1FDR7iD35fdKCeKqA0Z5fKSGc9DZ+dsIdJ7rRfXsJVE5QQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qhWhDpMncqGPHchBTlGFIns20uwVdpZvbF5pdNoDL/8=;
 b=h+Mabx+tkW+yLei2jV/tfPb8PWd98Qkbg5yrqlxP6eucP9PQv1XurF7MWVE6Ce5ZpPJD9IsfAS/wHipWxBOBhCU8gEU9w4W+x7Ih0X6c9x1lPIOev6YqlX6c1bsNz+nh84R4L0YQ+COdshPI4fdyd+JQWmfkBeWQDEktanh+m0/sJAWwJHe92WB7NmjW5AZwXVHc35CXBoxJVp5Vlpf3riW1niYaDiSdx8uEk/drIalCSHPZkeULMAOvpI2/fAlImYLrlKQ2oO8nDyjYcxiVuAFRi9e5MaIJmeE8EnBtcDExRwy429qUUNXN3JVQYd+c6JLzE+rm8BoRqIjVShUwIg==
Received: from MW4P220CA0026.NAMP220.PROD.OUTLOOK.COM (2603:10b6:303:115::31)
 by MW9PR12MB999210.namprd12.prod.outlook.com (2603:10b6:303:301::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.15; Tue, 20 Oct
 2026 07:45:47 +0000
Received: from MWH0EPF000C6192.namprd02.prod.outlook.com
 (2603:10b6:303:115:cafe::2d) by MW4P220CA0026.outlook.office365.com
 (2603:10b6:303:115::31) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.522.20 via Frontend Transport; Tue,
 20 Oct 2026 07:45:46 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.117.161) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 MWH0EPF000C6192.mail.protection.outlook.com (10.167.249.102) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.522.6 via Frontend Transport; Tue, 20 Oct 2026 07:45:46 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Tue, 20 Oct
 2026 00:45:29 -0700
Received: from [10.242.141.178] (10.126.230.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Tue, 20 Oct
 2026 00:45:24 -0700
Message-ID: <2196aa2d-7cc7-44e5-b11f-1bde7bf5a9dd@nvidia.com>
Date: Tue, 20 Oct 2026 10:45:22 +0300
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
Subject: Re: [PATCH net] net/mlx5e: rep, Fix races between devcom PAIR event
 and uplink close
To: <netdev-bot+sashiko@kernel.org>, <tariqt@nvidia.com>
CC: <andrew+netdev@lunn.ch>, <davem@davemloft.net>, <edumazet@kernel.org>,
	<kuba@kernel.org>, <netdev@vger.kernel.org>, <pabeni@redhat.com>,
	<gal@nvidia.com>, <leon@kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-rdma@vger.kernel.org>, <mbloch@nvidia.com>, <moshe@nvidia.com>,
	<roid@nvidia.com>, <saeedm@nvidia.com>
References: <20261015085744.1109107-1-tariqt@nvidia.com>
 <179240043161.3135.7551017781405209816@kernel.org>
Content-Language: en-US
From: Shay Drori <shayd@nvidia.com>
In-Reply-To: <179240043161.3135.7551017781405209816@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: rnnvmail201.nvidia.com (10.129.68.8) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWH0EPF000C6192:EE_|MW9PR12MB999210:EE_
X-MS-Office365-Filtering-Correlation-Id: c99a85bb-dca5-418f-6596-08df2e7e271c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|23010399003|36860700016|82310400026|56012099006|4143699003|11063799006|5023799004|261009223027099003|10067099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	IdEXVUk7sflKHvQWiYEjaiYaIA2+O7ptibE6aM+XcVVjiUwOffg0HXuFeUnvfBjayzJJEbNVWKAIdD21jfgbbRKmIg4l7Z3YQe4AYAekIgEP5lz7Lyp+3q2Uw+b/U+TUPsK0RvCPZp99yu3LRsZxUYJdZXdv4DkNw06gwTL5Et9GWQjBXsRpnMukTCKXb34oCzHmIgqbI1YTJv8i6mrXhivSS5Cg1dT9FGyH8cd8TVR6uT0Nf0VcvU7qbFsh8RQQTl46iNCsQWZdsH8wugAxLLVaop/u61GmuzyHO+Jg21MqA11kU7aP8ZD+DlTOnNLLXZcFZL26fdDxPy2Qzy8eB8NHn25hpNkH1Kwjaqax9mq4s0KqjrLVnkeVPTVxTJjMcVGuw3LG5Zw9QmSWrR+3R4JypCWoDl3ykfWf06HHt9zeWd076dhs4yVDUQnq/fq3PilmLXNdYltcoxmV1e5JpSXjzQQru2/1zJwzl20jQLYneq4cHx1C+E3BnHOUwaikcmeqale0LoOqpeb/++3f5Elg0y3hik5EqYc4BGLYKiQaMxewjfrAurWpDoJKqVoIElutpF5DllT1eqsyCm2mIMjXLUhR6RGK1F+VeKS4tmHFmHBN0UMBLLs81OMQdEBwRZljLIKgNdaF/aLdjKjEwKERNv09Xm5Z6v0Iq+zk0L9eEg7RmbxBIu6XDBdnVxveeJHjMR+KjUZXst+OkS9w9w==
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(23010399003)(36860700016)(82310400026)(56012099006)(4143699003)(11063799006)(5023799004)(261009223027099003)(10067099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	gxF3/Dn9zFgfKyp8lEN7vW938c47IQwxkJIcizAC4mRBq33QBado6jINpDOBlXWIjozM6oDjT65wA5WqET30DvxUZFzlnHhXGLH3YvqbFQQvhy1dfintRoOI64S8CETL+zPZhrm41/2YrZqAmL5YGdxDvUfpJvDzmEj3HBdwQ+my5whmRWPOkP3iWGpXV4WiBnEecsgbASKxpVtN8k1Fi5FrwdRs0Tgnt42AM39G3ew+DdJKpS6Mg66/Hb21bluyVBBzW9ypD/G/SF0qeSspXuNfuclSKy1WwDtAcG5J6u26hrAtuDdhTJJFWXnQO+nB7+eYA9PlbZtQj1++0PznChqJ+HfAxcACBDLEXH7VJcouvQLCz1+I8MTT2SOkK6iFMZcI+mc/DK4rIxCTMhrH2djh7cJF0hzMbMU6LyFymyLadq7WxkyTCkbwDu1rNOvv
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Oct 2026 07:45:46.5801
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c99a85bb-dca5-418f-6596-08df2e7e271c
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MWH0EPF000C6192.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW9PR12MB999210



On 19/10/2026 12:00, netdev-bot+sashiko@kernel.org wrote:
> External email: Use caution opening links or attachments
> 
> 
> Thank you for your contribution! Sashiko AI review found 2 potential
> issue(s) to consider.
> 
> Critical: 0 · High: 2 · Medium: 0 · Low: 0
> 
> If you believe none of the issues are legitimate, please reply to each
> issue of Medium severity or higher and explain why the AI is wrong.
> If any of them are legitimate and you plan to respin, please let patchwork
> know by including "pw-bot: cr" as a separate line at the end of your reply
> (one such reply per series is enough).
> 
> - [High] The fix is incomplete.
> - [High] The patch adds a lockless load and dereference of esw->devcom to
>    every rep channel deactivation.
> 
> --
> 
> net/mlx5e: rep, Fix races between devcom PAIR event and uplink close
> 
> This commit wraps mlx5e_sqs2vport_stop() in mlx5e_remove_sqs_fwd_rules()
> with mlx5_devcom_for_each_peer_begin()/end(). The goal is to serialize
> rep_sq and sq_peer teardown against the devcom ESW_OFFLOADS PAIR/UNPAIR
> event handler, which follows the pattern already used on the add side.
> 
>> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
>> index 88a170e40bd9..7211faaffd8d 100644
>> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
>> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
>> @@ -629,8 +629,12 @@ mlx5e_remove_sqs_fwd_rules(struct mlx5e_priv *priv)
>>        struct mlx5_eswitch *esw = priv->mdev->priv.eswitch;
>>        struct mlx5e_rep_priv *rpriv = priv->ppriv;
>>        struct mlx5_eswitch_rep *rep = rpriv->rep;
>> +     bool devcom_locked;
>>
>> +     devcom_locked = mlx5_devcom_for_each_peer_begin(esw->devcom);
> 
> [Severity: High]
> Before this patch, the stop path never touched esw->devcom. Now every rep
> channel deactivation loads and dereferences it with no lock held, and does
> so before the esw->mode check in mlx5e_sqs2vport_stop(). Can esw->devcom
> be freed while this runs?
> 
> esw_offloads_disable() cleans up devcom before it unloads the reps:
> 
>          mlx5_esw_offloads_devcom_cleanup(esw);
>          mlx5_eswitch_disable_pf_vf_vports(esw);
>          mlx5_esw_offloads_rep_unload(esw, MLX5_VPORT_UPLINK);
> 
> mlx5_esw_offloads_devcom_cleanup() frees the devcom before it clears the
> pointer:
> 
>          mlx5_devcom_unregister_component(esw->devcom);
>          xa_destroy(&esw->paired);
>          xa_destroy(&esw->fdb_table.offloads.peer_miss_rules);
>          esw->devcom = NULL;
> 
> The free happens in mlx5_devcom_unregister_component()->
> devcom_free_comp_dev(), which does kfree(devcom) and then
> kref_put(&comp->ref, mlx5_devcom_comp_release). That also frees comp if
> this was the last member.
> 
> One possible interleaving:
> 
> CPU0 (ip link set <rep> down)
> mlx5e_rep_deactivate_channels()->mlx5e_remove_sqs_fwd_rules()
>    mlx5_devcom_for_each_peer_begin(esw->devcom)   /* loads P */
> 
> CPU1 (devlink eswitch mode set legacy)
> mlx5_devlink_eswitch_mode_set()->mlx5_eswitch_disable_locked()
>    ->esw_offloads_disable()->mlx5_esw_offloads_devcom_cleanup()
>      kfree(P), possibly frees P->comp as well
> 
> CPU0
>    comp = devcom->comp;
>    down_read(&comp->sem);
> 
> The ndo_stop path holds rtnl, the netdev lock and priv->state_lock. The
> devlink mode set path holds the devlink lock and reps_lock. Nothing
> appears to serialize the two.
> 
> Could this become a use-after-free on the comp_dev and on comp->sem? The
> start path already has a similar unsynchronized use of esw->devcom, but
> this patch adds a new one on the close path.
> 
>>        mlx5e_sqs2vport_stop(esw, rep);
>> +     if (devcom_locked)
>> +             mlx5_devcom_for_each_peer_end(esw->devcom);
>>   }
> 
> [Severity: High]
> Does this fully close the race with the PAIR event?
> mlx5_devcom_for_each_peer_begin() drops the semaphore and returns false
> when the component is not ready:
> 
> lib/devcom.c:mlx5_devcom_for_each_peer_begin() {
>          ...
>          down_read(&comp->sem);
>          if (!READ_ONCE(comp->ready)) {
>                  up_read(&comp->sem);
>                  return false;
>          }
>          ...
> }
> 
> In that case mlx5e_sqs2vport_stop() still runs, with no devcom exclusion.
> It calls list_del() and kfree() on each rep_sq, kfree() on each sq_peer,
> and xa_destroy(&rep_sq->sq_peer).
> 
> The PAIR handler, though, does all of its rep work while ready is still
> false. mlx5_esw_offloads_devcom_event() sets ready only at the end:
> 
>          err = mlx5_esw_offloads_pair(esw, peer_esw);
>          ...
>          err = mlx5_esw_offloads_pair(peer_esw, esw);
>          ...
>          mlx5_devcom_comp_set_ready(esw->devcom, true);
> 
> UNPAIR sets ready back to false once the last peer is gone. With two
> ports, every first PAIR and every re-pair therefore runs with ready set
> to false.
> 
> One possible interleaving:
> 
> CPU0 (ip link set <rep> down on eswitch A)
> mlx5e_rep_close()->mlx5e_close_locked()->mlx5e_deactivate_priv_channels()
>    ->mlx5e_rep_deactivate_channels()->mlx5e_remove_sqs_fwd_rules()
>      mlx5_devcom_for_each_peer_begin() returns false
>      mlx5e_sqs2vport_stop()
>        list_del(&rep_sq->list);
>        kfree(rep_sq);
> 
> CPU1 (peer eswitch B entering switchdev)
> mlx5_devcom_send_event(PAIR), which takes comp->sem for write
>    ->mlx5_esw_offloads_devcom_event()->mlx5_esw_offloads_pair()
>      ->mlx5e_vport_rep_event_pair()
>        list_for_each_entry(rep_sq, &rpriv->vport_sqs_list, list) {
>            sq_peer = xa_load(&rep_sq->sq_peer, i);
>            ...
>            err = xa_insert(&rep_sq->sq_peer, i, sq_peer, GFP_KERNEL);
> 
> Can CPU1 then walk a freed rep_sq, or call xa_insert() on an xarray that
> has already been destroyed?
> 
> If the insert lands between the xa_for_each() and the xa_destroy() in
> mlx5e_sqs2vport_stop(), the sq_peer and its peer FDB send-to-vport rule
> look like they would be leaked.
> 
> The commit message says:
> 
>    "The add side (mlx5e_sqs2vport_start) already guards the peer-rule work
>    with mlx5_devcom_for_each_peer_begin(), i.e. the devcom read semaphore,
>    which excludes the write-side event."
> 
> mlx5e_sqs2vport_start() uses the same ready-gated check:
> 
>          if (mlx5_devcom_comp_is_ready(esw->devcom) &&
>              mlx5_devcom_for_each_peer_begin(esw->devcom))
>                  devcom_locked = true;
> 
> As a result, its list_add() into rpriv->vport_sqs_list can also run while
> a first-time PAIR is walking the list.
> 
> Would both the start and stop paths need exclusion that does not depend
> on comp->ready? One option is to hold comp->sem for read whenever
> esw->devcom is non-NULL, which would need a new devcom helper. Another is
> a lock that the event handler also takes.

good find, will fix

pw-bot: cr

> 
> --
> Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261015085744.1109107-1-tariqt%40nvidia.com

