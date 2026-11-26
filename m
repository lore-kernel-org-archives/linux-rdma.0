Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.196.37
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795704227;
	b=Sn8cVsih/Ofm/pr9TBsRbXbbK4ON4BZaKQTEEUvhLj7sFxjvP/EZWfeR+zZAWpY7/u/y
	 3Tuyj4JPYHyhogdGwMjMM5H/DY9IQQMVzIlHCiiS1FvYVtnpLxtublFTXt4TGsx7U8jgq
	 juE9TJg5IUT/aVL78dAD9RG0vX9rd5DAYUObkwcHLtAq+ZfiiuZaNqxch+0EIgVpOUF0M
	 Jj4MTBYSkXRFpr9mFJiU/KP0e3pDf9iCByLQelFxHH1V6KqZcgEr6d19d2hC0eQo5FuOq
	 hUJKXxajZpFfhQ0agvFVsoruIKKnG7QA6MHWg4exNXQr9OQV1mg4pwkp3XT3sqGBiPA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795704227;
	h=DMARC-Filter:DKIM-Signature:Received:Received:
	 X-MS-Exchange-Authentication-Results:Received-SPF:Received:Received:
	 Received:Received:From:To:CC:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:X-NV-OnPremToCloud:X-EOPAttributedMessage:
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
	bh=KVtO4FOl8iynkeWBoCEwK239ELf4KCzlKtz8Rw01ISU=;
	b=TfqB1A6sVCHy91JrHSp1+bPCEMDvg1vn7nR7lY+sBBAorHFTvEesQbEMRZVp2AVWDq0c
	 HzvVxomcdsHb9RjYxWR6lbfVXATeo6SV8+kIShOn+Y8LjsLnW/QNhaA/1G2eM6DOsRaUH
	 dWk1TLq4wqkvtEEqof15Kz6iTaT76+sVELWr41VlCgAe//J5n2Akl3PENyME3zO5jYr/J
	 H6jg+OILCGLRKKlpfE4sQrIp9t74rlwAbwafzDmOiewgpa90mBpCrvtzsEdlBBWZ8P10U
	 YYjuPir2aWZoWlF+q5DR7cdW87bts9sF0A/gcnNgWkSbdQAGJ54hsLRwqbLRktd3kpw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=K9hIEc99;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.196.37
Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013037.outbound.protection.outlook.com [40.93.196.37])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5F15606A31C;
	Thu, 26 Nov 2026 14:43:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B5F15606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=K9hIEc99
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OvoJZG0cmJjPrggTdNuSDostjrANdAHbL0Ho74/xBqybUHsWqpMahldHDoKm/+JmhvSASG3TLfnt9wQbDxhSc8C8mN2FE3EUWlCD2Jc1oC5BDkDTTKfXfK5l5FB+ycVuoK4qZM/Dtb00SPErOzgWVKcsw7d/wqNArHMvwDxiAcC78L7Ld4s/LSlRYVoFcNrmjB+YsEqIc6hUWWeH3CYztNOrQHoFaL9aKWoAujD/c0JporVuipy2SHh51mFi+RxYbns8AhD0jHhy1UPFdGZInuJE3yStqXSki3UmJP+r249AXYpobpTdE6/jmIcXk7NK/BhsCQ/HlkcQ7kjG+0krVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KVtO4FOl8iynkeWBoCEwK239ELf4KCzlKtz8Rw01ISU=;
 b=HB2lKxbiKM+4GmXNvn5DPoj3Dquaxr5i+/BoKUPw+i/oaasPwWhvUTfLGN7Sw7o74+ym2y7YBSY8DPF1UFVMJUXx69MbPGwXJRIFKM/yw9PVCCGV/IY8SlOZExWJM+GObuGeuAkAohRorqKbxiXWTdhjYj4ltq6+kuraIehV1ow0Fs+c8qSJ5JJnGpP/aSqKaXVY5Addvs1FHqGeJ4erDgg8/V08+b4drG3t5J7R356726O5tQRVe4IsNZqZocYf+NowU+3UiDQipElbZ2TmyKCvbOIW4WXffFEzhA/F3QUzdRAUnE8ZQFwYidzO9Hs/GkxJHhVx9IjeHiUaqgjd4A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=ddn.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KVtO4FOl8iynkeWBoCEwK239ELf4KCzlKtz8Rw01ISU=;
 b=K9hIEc996X8yGHpEcZbMsuwke75frelYtOnIrl3+s4jeTgKWC95gWfY40K/m93HOtDL5HFCSkqWBbTv68Icn9buRErcYmcv+Iu2S3hn7oqfudOFkbEbcWajtbccuxkeDE0osvXoY4J8Tdq8Wjx3nojMgSzf5EICap0pIlXL74veYpwS1bTrV+NqCpVbhkXKUXyYJj3T/IF7UOpRf3+2PnJFSHTmycJpjfX3SMW4qnT6mF4fi+kRA2qTzMFa7Vsc9AWcwKNgG+YEIgiAbYaZfoggF1JtKsiX29zn49APNYd5kvni7I1iPh9YmpBevOambbgBBAizQX8IF9DGEMKxjLg==
Received: from BY1P220CA0040.NAMP220.PROD.OUTLOOK.COM (2603:10b6:a03:59e::16)
 by PH7PR12MB6835.namprd12.prod.outlook.com (2603:10b6:510:1b5::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.662.6; Thu, 26 Nov
 2026 14:43:41 +0000
Received: from SJ1PEPF00002310.namprd03.prod.outlook.com
 (2603:10b6:a03:59e:cafe::2e) by BY1P220CA0040.outlook.office365.com
 (2603:10b6:a03:59e::16) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.662.7 via Frontend Transport; Thu, 26
 Nov 2026 14:43:41 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.117.160) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 SJ1PEPF00002310.mail.protection.outlook.com (10.167.242.164) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.688.5 via Frontend Transport; Thu, 26 Nov 2026 14:43:41 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.57; Thu, 26 Nov
 2026 06:43:30 -0800
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.57; Thu, 26 Nov
 2026 06:43:29 -0800
Received: from f43.com (10.127.8.9) by mail.nvidia.com (10.129.68.10) with
 Microsoft SMTP Server id 15.2.2562.57 via Frontend Transport; Thu, 26 Nov
 2026 06:43:27 -0800
From: Dragos Tatulea <dtatulea@nvidia.com>
To: Etienne AUJAMES <eaujames@ddn.com>
CC: Tariq Toukan <tariqt@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>,
	"Leon Romanovsky" <leon@kernel.org>, Mark Bloch <mbloch@nvidia.com>,
	<netdev@vger.kernel.org>, <linux-rdma@vger.kernel.org>, Feng Liu
	<feliu@nvidia.com>, "David S. Miller" <davem@davemloft.net>, "COURRIER
 Guillaume" <guillaume.courrier@cea.fr>
Subject: Re: [PATCH net] net/mlx5e: guard child PKEY channel stats lookup in rx path
Date: Thu, 26 Nov 2026 16:41:22 +0200
Message-ID: <20261126144122.3886594-1-dtatulea@nvidia.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <awcn1-LpcFgzRKgq@eaujamesFR0130>
References: <awcn1-LpcFgzRKgq@eaujamesFR0130>
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
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PEPF00002310:EE_|PH7PR12MB6835:EE_
X-MS-Office365-Filtering-Correlation-Id: 9220d6ba-8815-4b7f-925b-08df4bcbaa54
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|36860700016|376014|23010399003|261009223027099003|22082099003|18002099003|11063799006|10067099003|261026140227099003|261026121527099003|261022105027099003|261028144727099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	WnlLN68hgDftZtbpuvQii0V9pZUbjcUpO+DocKj9f9PnSTTWnHGU6aUcWJiKSlntsb+59KKM2MNNdm1ZJoWXLCt0tIbl5/fGfXrL4lS75rWcZVV9Ltt0Rjk28AOrrpE996Oj++Mqx+IyWrrjrXWXYo925ZHntWZ68Teenqg4ObaAL1gQw5mZJzFP3wRT82u5uwu7L502HAgeYfHJhrKxxtkvyyoOyEQN7wk1laiDY1j93oq8LvYQLtt9NO2zIU+BrBODYAW+wnxbaK0JFJ3KVhCnV0LCmQFDUJGkewCe/hfnO0yqsJlQfvJPs6gOH6iPesr+PwKEPKoGTZxylkdSbbgxh85S0ezH/lkHGLfKq3J2uIWpP5H9Jjj7RoyLrb2tkUp6jw4ACuOcSD+ecirux2HUzjgVDd4P7XBuKTi32hda+nxycZwRPv5MN+oc2VFQWaKH4s/QCAvYtf1K0i4g7FX/WOVHHqndB04p/1EQNOSKohD+eDH6tm5jDsX6uHTyRTtcwwBiTymbIhUGT9e8SN6gbHmkYUlOmAjVha4m8NvK3FuCaOv5VROi+iGVnlTGhbLkqtbXBHA+GUTtMUFbIwQWYPdrfdb6BlDQbp7TwxGz6IAUFCl2HKpGb2Cf7BOZYt8kt0NXOAbZTls4bEPYg9Y1pkbw96arDTx9ulvJEI102jRJy2I0z3pIb5wgUzhULbpFcOlXG/NXAd/f1iFZ6g==
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(36860700016)(376014)(23010399003)(261009223027099003)(22082099003)(18002099003)(11063799006)(10067099003)(261026140227099003)(261026121527099003)(261022105027099003)(261028144727099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	J36Yj3byxSwf5Nvre093j+u5w/8kcZg1wGLtPKVDyszxeZHzFxF5MnkLhxzCfCp19WPQheb4Z54xpq20gtsBAgmqSnyo7Rn+qXwCxNiVut65iPuR2Q2t3FJNlihKECrOsVv76XMs/KnkhcfDHUq9c3RXM7cljA8gCv79dXpea9jQucflw22nHJb/RuIIb9DTlbYJf/7zyrKA9g54YDg0X/9dc5A0vleW+ZuhiCg6K22Npm6u1yoOYspaamcol85aIOflTYm86BBDTiT1v24+RTtOxtgivNrieLSf/+megS3P9aTyS0ZE32CguHri1HztB0VehUnLYqfPtZqXeET3wfpCP2aYJVjkRd1FelW8oSifoWn05mWM6WpA4TKrbJR5yboTSXmLQZlOvU6ZYbqqHgMyjn1r15BQ5nDnAoDuTM3Z1mVMZWES202KFBqBkcrf
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Nov 2026 14:43:41.7524
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9220d6ba-8815-4b7f-925b-08df4bcbaa54
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF00002310.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6835

Hi Etienne,

Thanks for your patch!

On Wed, Nov 25, 2026 at 19:24:23 +0100, Etienne AUJAMES wrote:
> mlx5i_complete_rx_cqe() uses the parent's rq->ix to index the child
> PKEY priv's channel_stats[]. The child only populates entries for its
> own channels, so on a parent channel with a higher index the entry is
> NULL and the stat accounting crashes.
>
> The race occurs between mlx5i_complete_rx_cqe() and mlx5i_pkey_open()
> (bringing the PKEY interface up). Once the QPN is registered in
> hardware by mlx5_fs_add_rx_underlay_qpn(), packets for the PKEY can
> be received before all the channel_stats entries are allocated.
>
> Look the entry up through a new mlx5e_channel_stats_get() helper that
> checks ix against mlx5e_stats_nch_read(). This is safe because
> mlx5e_channel_stats_alloc() allocates entries in order and
> stats_nch is published with smp_store_release() after the entry is
> stored, so every ix < stats_nch is non-NULL (paired with the acquire
> in mlx5e_stats_nch_read()).
>
> Fall back to the parent's rq->stats when the child has no entry for that
> index. The fallback runs in the same parent NAPI context, so it adds no
> new data race.
>

There are 2 issues here, each needs its own fix:

a) Packets shouldn't be steered to the parent RQ before the pkey netdev
channel stats are allocated. Fix by moving the flow steering setup
(mlx5_fs_add_rx_underlay_qpn()) after the channel open in
mlx5i_pkey_open().

b) The thing with the resizing of the parent channels. Can be fixed
by allocating the max number of channels for the pkey netdev. AFAIU,
`priv->channels.params.num_channels = priv->max_nch` in
mlx5i_pkey_init() should do the trick.

Thanks,
Dragos
