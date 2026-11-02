Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.208.51
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793658845;
	b=PcfgnDQwal2lUc/Voro/q8JcKPdqg0/1VU9aKXoFUKsJMToheF9I6MPf7ljXqeNBF5CE
	 WH3kb+h1zCIFs8Xzpw/bU3An2/hSegA5Y2LBS49GJJ4If1I6BnEhUzZKHRWeOG5pS+26a
	 q6X4QlRBp4OPWDtohtuYEPCG0OMC9h59nt32bDJ4w9JSF3sFiO6m08HguALfgC9bR44MP
	 npk80om+S0C+5OpJfsWkHbdMY55ag715WAFSy7oC92KuGElUkZrUhNzlnvuPsZBw2MwzN
	 3JOupWxwrMAWXk0DHue1nuQSd0zY/a1vIuH26J6iUw7Q8xX/BYn05TAkQw9u72u0Wgg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793658845;
	h=DMARC-Filter:DKIM-Signature:Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:
	 Content-Transfer-Encoding:Content-Type:X-ClientProxiedBy:MIME-Version:
	 X-MS-PublicTrafficType:X-MS-TrafficTypeDiagnostic:
	 X-MS-Office365-Filtering-Correlation-Id:X-MS-Exchange-SenderADCheck:
	 X-MS-Exchange-AntiSpam-Relay:X-Microsoft-Antispam:
	 X-Microsoft-Antispam-Message-Info:X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
	 X-MS-Exchange-CrossTenant-UserPrincipalName:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=tFl+N/ZBDyY/4wNDe7raFNezXqu+vcai0yw3GKKoDAA=;
	b=M5YmuxzmkUvyHnsP8WQ/9NsCzjBEYtoldObQEb8qmBNPDJvFLaGgBSen776LV0EbhZ2F
	 1khuClyFpt3OBCMWx2Ek85Be9fkLT10NwdQnG1uk/LlbweaBANW7ADeq0SINGG1mKcz0m
	 xJSmBzaoo7xfH7Vsa957ndPoTToiyTzPOMCGjafojDDR3jQtCvuhtQyDB8kXbZq8fHIDX
	 FYcU8TWs6dXqmwnKMsDMdlQGr9c4FGh1psINA4i509pkvZTqdD+Y0OZZx60rD1k2KYR6W
	 j29kM0qKqFyq4lOIqAWBfla8Feo2CdJDc2lx5DFIcjLnst1LtrRHQ8X0zL+igf1WvVg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=RZ4RjDur;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.208.51
Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azon11011051.outbound.protection.outlook.com [40.107.208.51])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43F5C606A32C;
	Mon,  2 Nov 2026 22:34:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 43F5C606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=RZ4RjDur
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xA5DT5dd6YinZVn/TWRyGr5hQ+zSCaTPWq+ICSP38xbIwko+wIQT9hSF516cRR/J7t6BkWepEILwHF9i+c4H2rcMJ/qxP2Luab+eNSOZxZAqrMyIXS5hbeKtRDLvlKV18VO92FaCEoOObCVP4ve0nApUhqpxyQHTTvU9F/ur9ms1Nx0dy1WC33I8GreNBpNAQdYXdviavh9ww1La9UfvGJNfAjj6DzK9t0MWjVvLjzz0xuFcTRxq1xSlNPudcVthjytBe+8jhv7OjdPm3keoVQJ69ACz9I2MFAW5nyHAo9sod6JifJNvbAmO89NvdVLE4U7C5fyPsMPuU7qYhI2OUQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tFl+N/ZBDyY/4wNDe7raFNezXqu+vcai0yw3GKKoDAA=;
 b=MlcDKUb6F9aysnGERYyFoTRfMUqDLKPlZgfFCmdQ+w75ZPsneKPl6O7vcU8RHm/CKR5ax6UfxIaPvgJQBu0gM+ZfP8X443wjHNhA8rhR1+nIw4z8nIhuhBu7IVilfSxwIMGMDBsc2lKSKYwW1fm/I6qofJJBVznVmMrbJu0IUdPsV/4h9oZbyPw8zmDI1euR3jJ50d+qh58ACunSSRjaycJRlggRSBD1DmDYC+0CZZm1GvS1MNlZXhTArHvvkZRRF3DH689xCJn3ilqSV7i8zouSKUSpJJou5EerMOMQOmylZaOsJNplo4V9Bh7/Uc9uY/6nm//CpbOs/kU0YCaEFA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tFl+N/ZBDyY/4wNDe7raFNezXqu+vcai0yw3GKKoDAA=;
 b=RZ4RjDurE4fA3RPb9+Xcyw4B6hNH78bo1ZThklPEFzu7GaaZSaSjw8TxORkXmFWYH9HU/3Cp8ZsHlVWyoi1wwdG+Pkqp7VnZZLOt/A9c47KYzw3TKgh/F65vgotm/+xqtMKkVxWwInQpg2oA9QZe8WrpSbQV7Z19+ZDPx/39s1g5j04KDPfHWlRevNFi5pfK2w+VN4j2OfulY36s5bC+yUIe7ER9y1LPys+3rixLleLrfgRxFJRrKXpJumLcWGeUWKj3nOzV0LDqCoFHJ7RxIsUDJKucFkxMA1Wto5JxJtKiKYGh9YlXosFoRgkMaoV6z7WSGnC4sofljT2e/imUig==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6478.namprd12.prod.outlook.com (2603:10b6:930:35::19)
 by DS7PR12MB5792.namprd12.prod.outlook.com (2603:10b6:8:77::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.569.12; Mon, 2 Nov
 2026 22:34:02 +0000
Received: from CY5PR12MB6478.namprd12.prod.outlook.com
 ([fe80::51f:ab92:7d1a:441b]) by CY5PR12MB6478.namprd12.prod.outlook.com
 ([fe80::51f:ab92:7d1a:441b%2]) with mapi id 15.21.0569.011; Mon, 2 Nov 2026
 22:34:02 +0000
From: Michael Gur <michaelgur@nvidia.com>
To: jgg@ziepe.ca,
	leon@kernel.org,
	linux-rdma@vger.kernel.org
Cc: Edward Srouji <edwards@nvidia.com>,
	Yishai Hadas <yishaih@nvidia.com>,
	Michael Gur <michaelgur@nvidia.com>,
	stable@vger.kernel.org,
	Jason Gunthorpe <jgg@nvidia.com>,
	linux-kernel@vger.kernel.org (open list)
Subject: [PATCH rdma-next v2 02/15] RDMA/mlx5: Allow optional access flags in DEVX UMEM registration
Date: Tue,  3 Nov 2026 00:32:55 +0200
Message-ID: <20261102223325.2115128-3-michaelgur@nvidia.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20261102223325.2115128-1-michaelgur@nvidia.com>
References: <20261102223325.2115128-1-michaelgur@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TL2P290CA0004.ISRP290.PROD.OUTLOOK.COM
 (2603:1096:950:2::13) To CY5PR12MB6478.namprd12.prod.outlook.com
 (2603:10b6:930:35::19)
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6478:EE_|DS7PR12MB5792:EE_
X-MS-Office365-Filtering-Correlation-Id: 91d00459-a43f-4053-ffc3-08df39316471
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|23010399003|18002099003|22082099003|10067099003|56012099006|261102123227099003|261009223027099003|261022105027099003|261028144727099003|261021121427099003|261021123027099003|11063799006|261026140227099003;
X-Microsoft-Antispam-Message-Info:
	4TfKgrAQ1zeYDyEnjgF4Ql/0mEyqq9eukQ+Mnm7YTD3pU+dqJnW1IsjYExohQTDnME58ZeVMuYc818h+VD5Wi1IlgpxujsKSS+NohGdozyaHtXFFoxZjP81fGsH9uzj8hNE/tgEQJLfLJyRhPAe64H5Z7tRO5HQj0iw155nfZ+UQyOJ4W2048rZBBdXmGtJMfNoSAf/I8MsHMhridiA49YO212k4XCkiAxOgII2agC8Wml0naUka37AFC3vwAoZhTWlbXMNFLsBvNZ4Y0pbqaY/nfScsQR7zHxL5uUNt2u1xxDJTXvlYZYfOWBHXmd0KOdoSP6AxnX54RHfnY0Dsr8lHZoT51weyQ22F/JPpP0IxlAwCOTeelsfO4hPfa3O7n1tb9QifSV8fiBukcBTBG1TwKP8plVS/AsO8y4ZZZPHke7h+oaplVZ5yUjiH4f8T3PIuC0SNI1/0ZkTizzCZDB5fGleKxD7IEihSMH7jtZH6o53q2d/xBiETs4rAz4MCx6pk51g7nPOvF8fxD6TNRdebNtXkwTahCI5QBAKkQSCkY2pwzX00OHHw0bzPCpwfKXEtHjF0KxmPHeBm5dGwW1CG58r6vtA3dEuJ4h/qeMBDLvkBmUCKz4DJpKC5k5mOqtM9nBwUMevnDkqywBhA3nhgHLDx2eq5EQm84NCIfJg=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6478.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(23010399003)(18002099003)(22082099003)(10067099003)(56012099006)(261102123227099003)(261009223027099003)(261022105027099003)(261028144727099003)(261021121427099003)(261021123027099003)(11063799006)(261026140227099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?x2K9GHtlYHzbDOjFTDwlNxe4mSMcGFD8j7MxdQOrOewKfvn26sOyvi7Qq0FP?=
 =?us-ascii?Q?ZqwHjZDmMn4ACWHIWry62FX0txWCP5G6LAsY2U/+f5JVTzPA+7MuIE0ygVeE?=
 =?us-ascii?Q?u4OYGGfwqadkY0/Uc/AAAn+bS6Zgde7KDjR9+9SklQD76v7E9oZjhZYyHBQg?=
 =?us-ascii?Q?BlWoXFL4Sch7eEZou84m0IZ9uaHwkd7HdXFop0Rw5o2EYwRYjaQ5WHUN1XMS?=
 =?us-ascii?Q?fDOlthi1lmq2AKoBgBCtrblAgwCFKBZ/Ad9ZAbBGnsZWQxBFZnj/d/PUECgv?=
 =?us-ascii?Q?8JgLSBFQfUlKFNZjQJ6D12zQpxQwEOeuERoCruF3+TOj08E96ZTabyULrvYs?=
 =?us-ascii?Q?F0YSTnIki283l7vtBLgNfyLuoegs8DbE+1AxupEwAhhj3F3KzLjHCknQYgno?=
 =?us-ascii?Q?6hsQ1XIWCFH/eQjFM4ryX8T559GfWJGsrg2ZaVmgQobMhdI0RxwAreetBGkT?=
 =?us-ascii?Q?PfVNRkFCMDJs+v6YsXGf+rPFfoVdMJctNVOOCmLbm74yB51qYFuQFrIYlmIS?=
 =?us-ascii?Q?2NSmY2ckH2bZHor5ghGs5/Yx7/55NYwiHv49EB3SzjNJqqq3zco3gtcG1WXl?=
 =?us-ascii?Q?Cvdzzz73w7lr3gLxGdiFZyYBFRSLOurS4U4Yej8yyp837kMjZg0WYsaz3dfm?=
 =?us-ascii?Q?hK2tSCet5BC39sQRNBwuhdqKD2iJeUIsupE+qeqFGOr2yqkcYSagG1eIqB3J?=
 =?us-ascii?Q?gzqtG4n0ZgLqnMtwaAd2jbgeOywOY9LuIE1vRvchOxffV8aNvIzq9zVX3vug?=
 =?us-ascii?Q?HackZamHHW4ssuZdEQqKPxt0d7EEY9ixjYe8b2pZWHEX4hm5uT7rD4Ts0X/t?=
 =?us-ascii?Q?OZ9IXkXumVltiTQ6xFNj3DNr+ccuA/4ktJjuiJR7LJpBgWHtazOYCxUkgfBw?=
 =?us-ascii?Q?+OrDzaA+piTesLdxpFPwYNSdLEZV80VDCU8e8XyDSa2b28YuRO7+mba1DAy1?=
 =?us-ascii?Q?6ncngJYoIUenpW0KceMcD5npfPspS7TK/nXd4WKUb47j0mlwimsTjE1luL5K?=
 =?us-ascii?Q?HE9JyzRYOt2d+xK1XzfUBgLJ5g/eEv8i0tkByhRYgoaOWHLaazRA8nSoK0xJ?=
 =?us-ascii?Q?sXev4nTHt1p/X0qQ/0VnYIn63FhCdpzDE87g09jSqjzJgtmtDQscjzXFHLAg?=
 =?us-ascii?Q?1mdd4+wCL/g/jpojXoueooz1n5UXO8plGNDo6WRVlimw4q58vVQMmy2JuouT?=
 =?us-ascii?Q?ywWwQ6FuVGgPcYRG1TVF2g1PCFkshhBx7yymn3SvhlUFb6vlgoq+hcNRTyDj?=
 =?us-ascii?Q?Ly2k1Yl2yD6e6UwvPN9+f7YTB1CZNDipOIEMZhryIvv9eA9VUllABVxzMe+E?=
 =?us-ascii?Q?IehtDQgeKE4cP0eAa4h0iVHrZP9hmZUNNfJHkBvjDrc9EvbVktaz2MhZI9Wa?=
 =?us-ascii?Q?CAanqwLbQVW+/WcWpwSlbruEOMR0p/EA1mO9mgwfH7SafmqHC2lfKIfO+rhb?=
 =?us-ascii?Q?CEMiJm87HgyUx+ITYiVDDTehNawI8lsLKelC+3XvMVN61N1Pm3/uX5Si1cWS?=
 =?us-ascii?Q?aR4y5bfez0VwCSYun8Yd7f1bzdhype9qFml9Hm5qxxAeAsBxCrgI8oaFiCsM?=
 =?us-ascii?Q?sF90vsJvlbcIdLzdsLRCLsNTyMBBbqEADbOIYBmL0Ig8BdWSM2y1Wvld8yTy?=
 =?us-ascii?Q?9AmMyd0fVcUCDdNfTUeQjiP+CVJ0ES/ocT8AqHcTUxsu2JvqWOGT5Rh9bWtZ?=
 =?us-ascii?Q?+yoM161KiyCv41EpCk3wDB6qmrpUGY+fETOavlQt+yCJxFQPpiqkk6palSuj?=
 =?us-ascii?Q?iF3KMjD54w=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 91d00459-a43f-4053-ffc3-08df39316471
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6478.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Nov 2026 22:34:01.2024
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UB4b44XM51cW1tJGWDqy2vwxr8sZJjg/Hs4GwGu0MFhREqtF7cIhxA2fA5PhWAhZsevgaaEoglTjuvhPtsgFlQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB5792

The uverbs ABI reserves the optional access flags range as best-effort:
drivers should accept any flag in this range and treat the actual support
as opportunistic, never failing registration when an optional flag is
requested.

Add the optional access flag to the allow-list of DEVX UMEM registration.
Uverbs users can now request any optional access flag on these
registrations and mlx5 will apply the flag's effect on a best-effort
basis when supported.

Fixes: 72b2f7608a59 ("RDMA/mlx5: Enable ATS support for MRs and umems")
Cc: stable@vger.kernel.org
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: Yishai Hadas <yishaih@nvidia.com>
Signed-off-by: Michael Gur <michaelgur@nvidia.com>
---
 drivers/infiniband/hw/mlx5/devx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/mlx5/devx.c b/drivers/infiniband/hw/mlx5/devx.c
index fc6f793dcc65..ec281a4ba42e 100644
--- a/drivers/infiniband/hw/mlx5/devx.c
+++ b/drivers/infiniband/hw/mlx5/devx.c
@@ -2410,7 +2410,7 @@ static int UVERBS_HANDLER(MLX5_IB_METHOD_DEVX_UMEM_REG)(
 				 IB_ACCESS_LOCAL_WRITE |
 				 IB_ACCESS_REMOTE_WRITE |
 				 IB_ACCESS_REMOTE_READ |
-				 IB_ACCESS_RELAXED_ORDERING);
+				 IB_ACCESS_OPTIONAL);
 	if (err)
 		return err;
 
-- 
2.52.0

