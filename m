Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.196.11
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795594287;
	b=B9JmbXDBSuLbZTBCrONqZd+znsV7CRasJNxgzZowfkajdRsOAzMh8J5gHNNRxMzWsrjp
	 lcIinIFWkivDwiP+kTC8ZuQRY1hs0PvTl/mp5RZh4R64ASquRXa+qm6OW0zCxj3f3J7Sv
	 8Wav2FcQd0O6p+/G0eTTAdx/erL39zYNlqhJakM1Z6Kn595/aLYlX2dmEEkl1Ie4KK+VK
	 65V7lMk9+w36t0E5CqzhiWA7ZeTSXrs0FpLJ6tnvGOfKTzWYBxT2Z1cfi3dbUMjtjLHpa
	 RNFvqBo8q/H2B3uasLgCYNgSRHyekDoZjtufzoxMpm8CvD6to/s0m4N74yuYRC1wBEg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795594287;
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
	bh=wjLAVMuoxEybg0vZTt5h0ilbTDdeGBtPunpL+OiTSUE=;
	b=KOI7Nic8exuOh0bt4AxfIX19QOENTauQiaGzVp3pE4cs75Qbiur0BG11YMjXTuqc7q7n
	 GayU2toBNQvh5tIt0/WoBLZpXGafEPf4Bh3NhnQvIjp7OSexpuQw8b7IagiY6Z8OTQSeo
	 i4jUCbTbzLWqV/PcCD1ztuii28XfrsutKuQtc09VUz7nJ+Xw+Oby5+6QnwJI7YE0Ib0cc
	 a9A2EodH3ytNF0FtGLAZXJnVJmlzc7FOp0ZmRqAvvDrwCQWS6ncSBhVj3zRowEULRjxEB
	 6wAFEZ5pWjCsGs7Vd7ScmuZqGe+e7sqYoBDDM3rGD91TZ2kJ4tNjd0QcNutlvUskStw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=PRG9kQup;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.196.11
Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013011.outbound.protection.outlook.com [40.93.196.11])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E952606A326;
	Wed, 25 Nov 2026 08:11:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8E952606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=PRG9kQup
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bNwWtgolRqJjPlGv7tLEcmQWXniTutslCxqmOtD3tZCCa01HyMFL7m9GxcBtulk0/bkxb6HuAWorQOdqUXZfAqJEtx6NRTv2DA5FATRd6pjNBLYJLOQRKYxJtBzvoXHk/NfNb4TN2BY27aXDINWNGiU0gvFfQfVswPHK5XTHtUZK2UHDqzyxyBk8XLKo27a8g9AKB2gcC/QHO856WkyGn/kaF+IMUHmnOhrsQj0LdxRCuoPtmwk8w8SPLS9TlyfgvLtWXRv/YwVOhus7oYOrYEOdEI8W6d6wsFvj+hBzO0a4x7B8D1O43ST51CtaFQneHKGDGRH2sL642fDvvxNadg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wjLAVMuoxEybg0vZTt5h0ilbTDdeGBtPunpL+OiTSUE=;
 b=Ydg0pKDeAefLJDGUuOE83F7IdaP/nsnjQlQJqVmcdq6BLrBkkax+XYAHpLkiEJe0AokmAw7O9PVJNb+Cn2YgHK7b9PD5YMpc8aTj8/npl/bpTXNJ6sRzWCf7Djycd0DhJE0+4Lg76UGap1tJofeBUL0ET+svjjomWakDQ/D6PDXJilmHCNrMeqHLixhMD9YYSWXf2UJmh5J3TBB0qFWHWsvi55m2l38A4hlb6VPu95JiaVZMnlurRepI8qYJpxFdu6J6rKLMboenRuLzT+gBZny0ZQ/d/Ragv+9bhFJ6sbiMZHAIQ+hx8s65mZs/kA5DouthTlSf+//JxOBRJKhpDQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wjLAVMuoxEybg0vZTt5h0ilbTDdeGBtPunpL+OiTSUE=;
 b=PRG9kQupKgkzUi41JWvqind/Xw6PSyILnNyzH7FDVJw1l4+sXvd60z62oIao61ZvLi6vDdRDhG+TFMOlpg+RzkXoUE05JtbfWHGba+nbx0TjruovxSAoeJxBd0PecxcP1vvPDJTPXYvIKhc0gyUnZ1znw20lpk0jKWbI5kUKPam8dkJUfGjyIsqjzbtf5TahG1TQyg79SuD0/cijo7fv+6v2yvvhZBy7hrYOL2Jfcmp3+ug05PPA86stHYc6UvG8H5ogjgytgNexWCfPlT4q+6stL1VaY7cycs0YY4GkmiBCmcuyTTsG3rCk6id6JtTqI6NIKsnHH0f2aT071cIqsA==
Received: from PH8PR05CA0006.namprd05.prod.outlook.com (2603:10b6:510:2cc::6)
 by IA0PR12MB8905.namprd12.prod.outlook.com (2603:10b6:208:484::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.639.14; Wed, 25 Nov
 2026 08:11:20 +0000
Received: from PH2PEPF00048912.namprd05.prod.outlook.com
 (2603:10b6:510:2cc:cafe::52) by PH8PR05CA0006.outlook.office365.com
 (2603:10b6:510:2cc::6) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.688.4 via Frontend Transport; Wed, 25
 Nov 2026 08:11:20 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.117.161) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 PH2PEPF00048912.mail.protection.outlook.com (10.167.243.68) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.662.3 via Frontend Transport; Wed, 25 Nov 2026 08:11:20 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.57; Wed, 25 Nov
 2026 00:11:01 -0800
Received: from [10.125.207.116] (10.126.230.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.57; Wed, 25 Nov
 2026 00:10:56 -0800
Message-ID: <63027688-545c-4f89-80db-268b763e77ce@nvidia.com>
Date: Wed, 25 Nov 2026 10:10:52 +0200
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
Subject: Re: [PATCH net] net/mlx5: SF, remove probed SF devices when arming
 vhca events fails
To: Changyul Lee <lcy8047@gmail.com>, Saeed Mahameed <saeedm@nvidia.com>,
	"Leon Romanovsky" <leon@kernel.org>, Tariq Toukan <tariqt@nvidia.com>, Mark
 Bloch <mbloch@nvidia.com>
CC: Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
	<davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>, Jakub Kicinski
	<kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, Parav Pandit
	<parav@nvidia.com>, <netdev@vger.kernel.org>, <linux-rdma@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
References: <20261117031141.1720619-1-lcy8047@gmail.com>
Content-Language: en-US
From: Shay Drori <shayd@nvidia.com>
In-Reply-To: <20261117031141.1720619-1-lcy8047@gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: rnnvmail203.nvidia.com (10.129.68.9) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH2PEPF00048912:EE_|IA0PR12MB8905:EE_
X-MS-Office365-Filtering-Correlation-Id: b129d5fe-8768-478e-a66a-08df4acbb031
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|7416014|376014|23010399003|36860700016|18002099003|22082099003|56012099006|5023799004|11063799006|261028144727099003|261021123027099003|261022105027099003|261022075727099003|261026140227099003|261021121427099003|261009223027099003|261102123227099003|261026121527099003|10067099003;
X-Microsoft-Antispam-Message-Info:
	dv5dlcvAHyuw3NwcMtGLeix8PRLM4iGGpJXMzRXzM3ayHh/0FmeNtYwCFrjSBQYV1MKOf5eK0MDGvr8g+zIvMnQ7qL8XK4Hn75bxeUU/I03baZRVMy2xxTCW8eFVWoypxqb3yyLz9j8Gwpnswnn5E4IbBtVFIjWD3pIppeRIYsnxTtaKCub7J58PekbNu2PBeo2A7FEIrsZx54isRF1AS+9xmYjp1+OHnrfZ7HYUCkceyQiUMizsLN2NBXyGcU1Xnb8KObFfLCUAh0yUbngdJMGbriCm9KzZFasP2wHcpgSuixNvFnXatPhTYqAVTRoCHSpZKtHsZxGtn/l5A6hf3RUxBJBZHcbEeDC9xbjDWK/EQrwy3TCIiXeb5R03xQi4zMRf1A1IYHIdY4DiZkFMDU93vIaTfShRiLuc81TL2i/7qo9OE8iN74u6fprcQe8ga73tVH7E9PonR+BY3g4Es9kRncrwi1lfkN0aen4WYPxo6LbbKd7Hiva5YBDqKC3aRMJ9ENaMU+9AzDk9Ks+1F7qJzY+uKG33tq5LEk6Eq0j/3Cc3vmv+fesDmt2mw/3b5BTxfCaO7kIPYH3tyHK+nOoxrpETwc6tEzFhcDY8n/bccwWpG8EQa4C2i4Fy2wfcvMyjyk7Xfk9aGUUkoY3GjJ2oOS4KDK3xDaD7tPlroq7/coRj4G0YazRA7ISM2yrNfs+fpx732sr/phrh/Z3NEw==
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(7416014)(376014)(23010399003)(36860700016)(18002099003)(22082099003)(56012099006)(5023799004)(11063799006)(261028144727099003)(261021123027099003)(261022105027099003)(261022075727099003)(261026140227099003)(261021121427099003)(261009223027099003)(261102123227099003)(261026121527099003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	8v6Ys9XrJwS5Y0+h+sboZP6NC7VBrInqtHv/6+V3kbMgzFcKC5rHSVAL3YHWFelTEYNP2/2CJTb60GtqAZnXHasNu6sucDJf9vQ8RiaZr2Kc+Q0RjoJpw26rvA8Nq/EsKEESQRVfx3olacVYJfq58qP+/IzWdHn747kg8ySBUXF6V/ciLXprkGBDh2YgytrX2Ry1VrfgIIvF5DvGVDWZPuboZee9uCdooYjVlTjwBYYdiLOe6lIvrO4yHdFE7eJI+xP7JM4bcl9MzsIxGI1h3Yi84f2ohxV2F+Wbot7L8OcvDt2Gdz+/rMCfzqrpaMeH7ZSJFKCdO0oRAQdU3B7YMQKCqLJpnpBhCJZI40SIBcYeYfYNb4h+wBRhfK2vomDJV4ENoO0TpGWMbSXCaGVPHce6z5bX9vWq/O9kb/0dVwDWC5Zo+QEFeYIKhcMU1jMJ
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Nov 2026 08:11:20.3866
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b129d5fe-8768-478e-a66a-08df4acbb031
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	PH2PEPF00048912.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB8905



On 17/11/2026 5:11, Changyul Lee wrote:
> External email: Use caution opening links or attachments
> 
> 
> mlx5_sf_dev_table_create() queues work that probes the SFs which are
> already active, and then arms the vhca state events. If arming fails,
> the arm_err path stops and flushes that work and frees the table, but
> the SF devices that the work already added stay on the auxiliary bus
> and in table->devices. dev->priv.sf_dev_table is set to NULL, so
> mlx5_sf_dev_table_destroy() returns early later and nothing removes
> them, while they keep pointing at the parent mlx5_core_dev.

Hi, sorry for the late response...

once an SF is armed, the DPU can activate it and the event handler
probes it, so arm_err has needed this since SF aux devices were added.
Please re-spin with:

   Fixes: 90d010b8634b ("net/mlx5: SF, Add auxiliary device support")

and adjust the commit message accordingly. With that:
Reviewed-by: Shay Drory <shayd@nvidia.com>

P.S.: the race pointed by sashiko is pre-existing and should be handle
in different fix

> 
> Remove them with mlx5_sf_dev_destroy_all() after the work is flushed,
> as mlx5_sf_dev_table_destroy() does. Move the helper up so that it is
> defined before the new caller.
> 
> Fixes: 4f57332d6a55 ("net/mlx5: SF: Fix probing active SFs during driver probe phase")
> Signed-off-by: Changyul Lee <lcy8047@gmail.com>
> ---
> Found with a static analysis tool we are developing.
> 
> Compile-tested only, with x86_64_defconfig plus MLX5_CORE, MLX5_CORE_EN,
> MLX5_ESWITCH, MLX5_SF and W=1.
> 
>   .../ethernet/mellanox/mlx5/core/sf/dev/dev.c  | 23 ++++++++++---------
>   1 file changed, 12 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/sf/dev/dev.c b/drivers/net/ethernet/mellanox/mlx5/core/sf/dev/dev.c
> index e75cbf333898..44f6292ad59e 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/sf/dev/dev.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/sf/dev/dev.c
> @@ -328,6 +328,17 @@ int mlx5_sf_dev_notifier_init(struct mlx5_core_dev *dev)
>          return mlx5_vhca_event_notifier_register(dev, &dev->priv.sf_dev_nb);
>   }
> 
> +static void mlx5_sf_dev_destroy_all(struct mlx5_sf_dev_table *table)
> +{
> +       struct mlx5_sf_dev *sf_dev;
> +       unsigned long index;
> +
> +       xa_for_each(&table->devices, index, sf_dev) {
> +               xa_erase(&table->devices, index);
> +               mlx5_sf_dev_remove_aux(table->dev, sf_dev);
> +       }
> +}
> +
>   void mlx5_sf_dev_table_create(struct mlx5_core_dev *dev)
>   {
>          struct mlx5_sf_dev_table *table;
> @@ -360,6 +371,7 @@ void mlx5_sf_dev_table_create(struct mlx5_core_dev *dev)
>   arm_err:
>          mlx5_sf_dev_destroy_active_works(table);
>          mlx5_vhca_event_work_queues_flush(dev);
> +       mlx5_sf_dev_destroy_all(table);
>   add_active_err:
>          kfree(table);
>          dev->priv.sf_dev_table = NULL;
> @@ -367,17 +379,6 @@ void mlx5_sf_dev_table_create(struct mlx5_core_dev *dev)
>          mlx5_core_err(dev, "SF DEV table create err = %d\n", err);
>   }
> 
> -static void mlx5_sf_dev_destroy_all(struct mlx5_sf_dev_table *table)
> -{
> -       struct mlx5_sf_dev *sf_dev;
> -       unsigned long index;
> -
> -       xa_for_each(&table->devices, index, sf_dev) {
> -               xa_erase(&table->devices, index);
> -               mlx5_sf_dev_remove_aux(table->dev, sf_dev);
> -       }
> -}
> -
>   void mlx5_sf_dev_notifier_cleanup(struct mlx5_core_dev *dev)
>   {
>          if (mlx5_core_is_sf(dev))
> 
> base-commit: 7475ea8b58616b33c04afb976cf0fbaad9dd63fb
> --
> 2.43.0
> 

