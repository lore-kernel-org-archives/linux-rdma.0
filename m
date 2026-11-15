Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.62.70
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794742087;
	b=VYxjqrK5/p5MBhTwyM8Nv+TfCdivN+hiqN6fG8kZArAq5ugdN2HmqhXZUyoPJR5T3ViF
	 0xaQkOyvh1CtVJLcSs0cz5UCoKmEhGRi4Fh8edsv6tQ8PsP6jMj/wbwQR0lJjjZ2PDQpc
	 Qgo/v55Nz9QRlTzdyU3GYyOZ4YQF9fuDB401JexkvSDbJkkbUKaEe64lycHJyXcKyEv9Y
	 Gj2ykfjXqEjJVc7UGK+D+g7Cp2kX9qJSQSCHPdMqVdofat676d7JN6owmIpu42r/wICvm
	 A5H5iSCRQCwf+iqmQeg8Yvn5d3ErnbUhwKxUjH9phHzN5CBaM4TQ/RUs7LNNDQfXqvw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794742087;
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
	bh=7XC2r+QohA2Y0kD74Z3vRJFLvhHSKt1gJ/5tQ4ygZ8E=;
	b=sGLM5Glp+Wlgqo2wk2YvYgqU7VoEqIKW+T6yUy/Vm/o3KB7N42+0si0pvlfL8GtY/vxt
	 2Hgdk0P31FXKijR2q4UtRIQx8/FgzfYhrgD6UCsdSlAwasUnw0Jyb8TIwEklAlfNEyUvP
	 IeNawp9uE1A5Ci69OdNPCeUFvL8s1quTMsNZymndEBYoajizVWV0Gxk589F7btDmb0D+O
	 E1suzM12/xbh78PXENSDO4ZTYa46yPbciSUojSyEJd77KFfmEWHWvubUX0OoRyLT95s0D
	 LI8TTgA9xfiCO1SvMeOf4bgT1bizymq4Jv0uxa+qRnFc8CfdqqlwJ1xIaMHPiH+RpdA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=FZjPSSPg;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.62.70
Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazon11011070.outbound.protection.outlook.com [52.101.62.70])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7AF0606A31A;
	Sun, 15 Nov 2026 11:28:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D7AF0606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=FZjPSSPg
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yOw0NbfiWC9hffnzENB6/IVP1FDvRUTXETZDXm3q4Dv0sTiLMLHzthnwOkePQI8cO+yGXja/PMpsCQkl4NJ586Ei5FXKA6yiwMz6VguGZbvoFQ39wDF1e+L2YaIPpOJJfG9B/Pt1uVXTu2G7gJ3zwEL7k8yKHkyKpqi7olKUCndji4AZbGYFHVFQIzra61OJGySj91tolONBXmpmbvxymc5aSpToW+UCsy8u4xvh4DK4P+rqeBjql2vD2m9xUoHNbhoa6xpQr9HkSpCNpcxsYY3vuEIGptiW1mtYtF/Md2Z4iOq4lppUBd4Tl/XYvykmDOAqc0PW/7hYFn5hPvVnRw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7XC2r+QohA2Y0kD74Z3vRJFLvhHSKt1gJ/5tQ4ygZ8E=;
 b=I4Cl9d2/kKVGwms7jx9NglKgGD6X9wOeFbqXVdmAQNGGj0SyiQ9d+Q3Zj8+ONDsUDekd+rgmtJH42keDyEwTUqibXrcPx0k2BddHqZzcJniR6StzYwjf1PebA3n4vR/QviheVTF+a0ML2AzJCOvg6SMTWcaK/rxT5RFmQSnJGSYm9k1NjHwMFTRA5vDPl8gTEyUjZuXjo0/XlYBevcXuGAFTCcuGIvYUyspt0+n0te6W8BnaOKBgMSMfYJBUGgPVe7o+UGpSpcf/aCGbNQHOtSSN++gTbVSEO6qSlfJwQm6or3Tgxt0CRm/oEkL1DiK6lIB7VyaSiraevprGCWHxKw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7XC2r+QohA2Y0kD74Z3vRJFLvhHSKt1gJ/5tQ4ygZ8E=;
 b=FZjPSSPgCCbOECMhr8k+HmjYP4iq45MLbb/JSBKLIZO8bgKCQxqTF5UifkxXzGZtAILvV1z8yd2Aq54IqV0JoMHJQcN4zjINc64QP8HLe6pn71+JTTHpppN3+O9n/V8qfR5CP+u4Qa8TZ54feMV3YbozZDHCb90jaXVPhzD21MuhJ6IzXtHxfkcOeTvL0eTzzpAvTQokzkzt7ACitF5wnjxHLYWFwu74w03ONP2PB8G5ULM50pAIfcBWbGiMjOTKUT5xyqBGEaooiboANt+Uq6VJpah5vIz9rEjFDv1b+Upu6LHkP9Dcd4CdOVzW1d0TaiTP2Dg0S34dciQ0HM68wQ==
Received: from MW4P223CA0027.NAMP223.PROD.OUTLOOK.COM (2603:10b6:303:80::32)
 by LV0PR12MB273923.namprd12.prod.outlook.com (2603:10b6:408:3b5::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.13; Sun, 15 Nov
 2026 11:26:25 +0000
Received: from MWH0EPF000DD30F.namprd05.prod.outlook.com
 (2603:10b6:303:80:cafe::64) by MW4P223CA0027.outlook.office365.com
 (2603:10b6:303:80::32) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.615.13 via Frontend Transport; Sun,
 15 Nov 2026 11:26:25 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.117.160) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 MWH0EPF000DD30F.mail.protection.outlook.com (10.167.249.7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.615.4 via Frontend Transport; Sun, 15 Nov 2026 11:26:25 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Sun, 15 Nov
 2026 03:26:15 -0800
Received: from nps-server-23.mtl.nbulabs.nvidia.com (10.126.231.37) by
 rnnvmail201.nvidia.com (10.129.68.8) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56; Sun, 15 Nov 2026 03:26:10 -0800
From: Shay Drory <shayd@nvidia.com>
To: <netdev-bot+sinfo@kernel.org>
CC: <tariqt@nvidia.com>, <andrew+netdev@lunn.ch>, <davem@davemloft.net>,
	<edumazet@kernel.org>, <kuba@kernel.org>, <netdev@vger.kernel.org>,
	<pabeni@redhat.com>, <gal@nvidia.com>, <leon@kernel.org>,
	<linux-kernel@vger.kernel.org>, <linux-rdma@vger.kernel.org>,
	<mbloch@nvidia.com>, <markzhang@nvidia.com>, <moshe@nvidia.com>,
	<saeedm@nvidia.com>
Subject: Re: [PATCH net V2] net/mlx5e: rep, Fix races between devcom PAIR event and uplink close
Date: Sun, 15 Nov 2026 13:26:02 +0200
Message-ID: <20261115112602.1011088-1-shayd@nvidia.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <179458366354.2168702.9670595647220092131@kernel.org>
References: <20261112182403.3646298-1-tariqt@nvidia.com> <179458366354.2168702.9670595647220092131@kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: rnnvmail201.nvidia.com (10.129.68.8) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWH0EPF000DD30F:EE_|LV0PR12MB273923:EE_
X-MS-Office365-Filtering-Correlation-Id: 34a64caf-931e-4404-05b7-08df430b48f7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|7416014|376014|1800799024|82310400026|36860700016|10067099003|56012099006|11063799006|4143699003|261026121527099003|261026140227099003|261028144727099003|261022105027099003|261022075727099003|261021121427099003|261102123227099003|18002099003|22082099003|6133799003;
X-Microsoft-Antispam-Message-Info:
	uxRnX3BzTkNpTV0b/TqQNemeXWOTNSpp9AFouJx/ouUdLsJl+eSabXJUmNRAWhHHahuQWbvx+wK/o7Fsb9ibb1hPNhAEq4eW4QuWBlGpivcNi6Ty5ypNaUyXVSgjrkL8rXaVUgrstFoy1+rpgSBXd/tbhTVFuR8pAWn06ImbcbiZfJ7hqxHltIh+aGzx6/2eMQCPce1etk2bNm9qQphgj4Wkf/zvjIY3jsAUfdwxk2naA3SI7ySTGbJiDElJGQZQeFg8TXex4L1G310AhKDdD7OCCAm5B0GU/0PVlDczrLTvbAl/gYLp2Qy1Rlv1mcUXmdQtkKn5/fOKcOoXI3i+R1r1gWVcOyQgGBAOq7YaUQMLWBEQYBoehBl8Ca9dL6BXozhu/Z//i1RoXJHk1+YQSwnsD+EwsfPI/lCo1u5vVB8dSh/YGtZGctyRdsyUbdpwBaaI/kEIz5ySOFco8RHAFfyk4tubfxE2kxi3/Wvb5AMg6HiIQU1lzlX/oVfpsvgzbrQQ4zDG5BVLkHvcdB4dgbXWWVJaDAmizSKv896ys2+EJbb7y3alDpxFA9/yYTx7DMRXEgMnHOaIRFP3oLU4egxpBJakCUCt5lkjo0IWlpX1SClJeSDTdyktTMDhNgGK+zZEH5E43vMVebc7Cgo/KUEuyD+oG+FgaYAhlSlpOmDCxKq+pBwxXv5PvLY4jTqYadto+bdIB6bC1E0NKy24Ew==
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(23010399003)(7416014)(376014)(1800799024)(82310400026)(36860700016)(10067099003)(56012099006)(11063799006)(4143699003)(261026121527099003)(261026140227099003)(261028144727099003)(261022105027099003)(261022075727099003)(261021121427099003)(261102123227099003)(18002099003)(22082099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	w/W8B5HjKNZ6k9OncfFIaoAm+OvoJ14bfOj8gbMKLn/xgt4tBLXzRs/cca83x4ovF9WqYKD9DaGPuegy0zSoGrKswXLh1GPH/Vv9RGRxxKTarTiJ4Uo+duBef2N/Pre38TT7TCIH07C+PwKwa46+Gv4m/b2sd56JhPhbOyaJtgIahsrrBxKJ4PiKyLa2L41zFr3hSLPi8Tnd2L7IvaIpjMWfDFvtzRpxev7lbD9JFKiUCZPWGziCk36dje/LMhUr1tMIOoJIvqKiEJyqvKHMUtjRJ0fnWAEaOfvO4fvQO72GnZdlOmic84Jx9eJCNUwpqa0+vWFzZkIyWA0jCJvE8edB5C5rQ0gMowfnjN36OlIuwo2Z8J0C+fmYn007b1G93N91Tq3E2PdjL0E+3qFdF0OHAnSFlj53D+9koKzeL7TkhuRA3GxIH2YfZIvSxptN
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Nov 2026 11:26:25.6750
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 34a64caf-931e-4404-05b7-08df430b48f7
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MWH0EPF000DD30F.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV0PR12MB273923

On 13/11/2026 17:27, netdev-bot+sinfo@kernel.org wrote:
> Hi!
>
> This is an automated message. This series looks like a fix, but its
> commit messages seem to be missing some information:
>
>  - How the issue was discovered, e.g. hit in production, hit during
>    development, syzbot report, manual code inspection, LLM or static
>    analysis tool scan.
>
>  - Whether the issue was actually triggered, or is only theoretical
>    (e.g. found by LLM and not proven at runtime). If it was triggered
>    please include the symptoms, like the stack trace or kernel messages.
>
> Please do not repost the series just to address the above. Instead,
> reply to this email with the missing information, so that reviewers
> can take it into account. If the series needs another revision for
> other reasons, please include the information in the commit messages
> then.
>
> The evaluation is done by an LLM so it may be wrong, if you think
> that is the case please reply and explain.

Hi,

The issue was observed during OS boot, while a boot script moved the PFs
to switchdev mode. It reproduces by bringing one PF uplink down/up
(mlx5e_sqs2vport_stop()) while the peer PF toggles legacy <-> switchdev
(devcom PAIR/UNPAIR).
