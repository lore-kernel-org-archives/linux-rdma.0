Received: from MRWPR03CU001.outbound.protection.outlook.com (mail-francesouthazon11011058.outbound.protection.outlook.com [40.107.130.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5D2E4E06D7;
	Thu, 17 Sep 2026 12:42:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.130.58
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789648966; cv=fail; b=g9F2KjU4aDRz4gGy3IV09/Pv2uNlXX7lIss7bcvzhlc5pF+PhDxqGlVwfMzzNVY9M6XLKOGzp1ZGqJ3J7B9j2DfgHetg35++MAYO0Fr4AFF/wdzwKF+CGx0wFCeuPErqYUruVUtqwGekzt3Ry3EAGVxYeBphsSFsCwJGlSXYe98=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789648966; c=relaxed/simple;
	bh=rMhIy6SzQftVY7UwdSyWGdNpg2MJm7y+X9FAw4OAH6w=;
	h=From:Date:Subject:Content-Type:Message-Id:To:Cc:MIME-Version; b=YosgVyQrMCH9Zy66IsBOxAh/fCHUySvFvfFJqTpAaPC7WDEzkj0RV4wdotOFlpBSplTjFH1T9981mowj5l0pKBt8jipSySC0OCzVwJ6RkMkC5yoo+Th2LpYk5iEYDAWDWHeWtVH8vi9l9Km7iDUTHAAsJO2Qrm4vsUqBWOlZ9UA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com; spf=pass smtp.mailfrom=oss.nxp.com; dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b=Q0HuGE3L; arc=fail smtp.client-ip=40.107.130.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b="Q0HuGE3L"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CVTEtV0+8cByEYBzWI8aARJxh4jprVW/hkcCoCyC6TdfjTfDxnxADf11lPWWqJQtJ/8dAs1wvvbiFhK1J41TySj+nrYultgDdY7Qtmx0AolnSq4y6bN75PWrypQzbxS5WlLx8vSOO2RaT7aRpkaw3gPhs9c71veZJyvP7d6CLTUye9ms6F1zV8aTVdpi0jnoCtDDb+JD7hd2tfZq12/H9L+OVIySo4RIeb6qYqOEz9Z2oV/KEVeQ/6Gi8Q9oBbAIhlmbqNUkHe2z2WbWK/vTzYHos9JBMRT19GXXwAWVkE33Oat9ZyU1F8cJ+Vd7KO92Q/Kqn2dqtgFCmHnYeSzAXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VmxiQkP4GLJGGkh2Z3SbbyvUMZWYqnu3WqvX20zXVj0=;
 b=VMP5RONxzKH26dnm6xy+7Ai6KY7p7X//OHFE2DO7KORv/EDetqZpK43SJj1Nf7mp+cWpLGSe/7ei25nLFpU5Vo7K+ZIOjhJarjbZE6sfF5BgXqYyv7C1TNQYimTwdN3vwDP8oisuNgHEg9VipkUsh6v07mJbp0hW3gTeSceLQkILP63o3RWaCI0KODTDwWw03EvgdNJlgKVfekVEq5Vsx+JJR1DMwFPOdTos9EtCrdEOJlCMHQGawsd6MrKPHL18jmFP+6AH3Alv2kDgJNK1ANwmbvPjUrQV+bnVKYZVYXS1+0UHpMmSvxs0tev5jQQ4CpGiyLR9iwzeWvfxkVKGmQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector1-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VmxiQkP4GLJGGkh2Z3SbbyvUMZWYqnu3WqvX20zXVj0=;
 b=Q0HuGE3Lo6f1UUWE88dGMCc3oUnGOIiBnwujWoX48O/TfAbS5TuupkQ+Mm0LkyfmqcnNXZwtBT7Hve+bdeMHAcApmbR3wcDfbTv+L10K99jiPcbpj802XigjPvtcifKtGbPWB7KgBz2gVRAp8d4mzkiF3owc7QPQAft2pRCh7gc9CNR5jcBjEi6xK4i8Fg0RBd3rCDnorOb/y01CgcTs+0+fKWbQArSEN9PgXTBnKT5o63BJikOiuT0z7ap3qMKs+oY2RfNm7tphC8COq+63k6FUMW/9pIas45nPDkEqJiuO/oWei8IyyI9gmyLNukSZQLx8QzJO9HWKA88UQBf12w==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from AM8PR04MB7874.eurprd04.prod.outlook.com (2603:10a6:20b:24d::9)
 by VI0PR04MB11781.eurprd04.prod.outlook.com (2603:10a6:800:2ee::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.12; Thu, 17 Sep
 2026 12:42:24 +0000
Received: from AM8PR04MB7874.eurprd04.prod.outlook.com
 ([fe80::ac38:1699:6f18:c5d9]) by AM8PR04MB7874.eurprd04.prod.outlook.com
 ([fe80::ac38:1699:6f18:c5d9%6]) with mapi id 15.21.0428.009; Thu, 17 Sep 2026
 12:42:21 +0000
From: "Peng Fan (OSS)" <peng.fan@oss.nxp.com>
Date: Thu, 17 Sep 2026 20:39:52 +0800
Subject: [PATCH net-next] net: use assign_bit() where applicable
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260917-net-assign-bit-v1-1-e9c97965e080@nxp.com>
X-B4-Tracking: v=1; b=H4sIAJffq2oC/yWMQQ6CMBBFr0L+2knaGlG8inFRYIrjYjSdakgId
 7fg8uX/9xYYZ2HDtVmQ+SsmL63gDw2GR9SJScbKCC60rvNnUi4UzWRS6qXQxafu5DgcUxtRpXf
 mJPMevGH7Ks8F9/9in/7JQ9l6WNcfdicqdHwAAAA=
X-Change-ID: 20260917-net-assign-bit-81f950e23f6a
To: Dario Binacchi <dario.binacchi@amarulasolutions.com>, 
 Marc Kleine-Budde <mkl@pengutronix.de>, 
 Vincent Mailhol <mailhol@kernel.org>, Raju Rangoju <Raju.Rangoju@amd.com>, 
 Prashanth Kumar K R <PrashanthKumar.K.R@amd.com>, 
 Andrew Lunn <andrew+netdev@lunn.ch>, 
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
 Sukhdeep Singh <sukhdeeps@marvell.com>, 
 Sudarsana Kalluru <skalluru@marvell.com>, 
 Manish Chopra <manishc@marvell.com>, 
 Claudiu Manoil <claudiu.manoil@nxp.com>, 
 Vladimir Oltean <vladimir.oltean@nxp.com>, Wei Fang <wei.fang@nxp.com>, 
 Clark Wang <xiaoning.wang@nxp.com>, Jian Shen <shenjian15@huawei.com>, 
 Jijie Shao <shaojijie@huawei.com>, Tony Nguyen <anthony.l.nguyen@intel.com>, 
 Przemek Kitszel <przemyslaw.kitszel@intel.com>, 
 Sunil Goutham <sgoutham@marvell.com>, 
 Ratheesh Kannoth <rkannoth@marvell.com>, 
 Geetha sowjanya <gakula@marvell.com>, 
 Subbaraya Sundeep <sbhatta@marvell.com>, Saeed Mahameed <saeedm@nvidia.com>, 
 Tariq Toukan <tariqt@nvidia.com>, Mark Bloch <mbloch@nvidia.com>, 
 Leon Romanovsky <leon@kernel.org>, Alexander Duyck <alexanderduyck@fb.com>, 
 kernel-team@meta.com, Brett Creeley <brett.creeley@amd.com>, 
 GR-Linux-NIC-Dev@marvell.com, Shahed Shaikh <shshaikh@marvell.com>, 
 Jiawen Wu <jiawenwu@trustnetic.com>, 
 Mengyuan Lou <mengyuanlou@net-swift.com>, 
 Daniel Golle <daniel@makrotopia.org>, Qingfang Deng <dqfext@gmail.com>, 
 SkyLake Huang <SkyLake.Huang@mediatek.com>, 
 Heiner Kallweit <hkallweit1@gmail.com>, 
 Russell King <linux@armlinux.org.uk>, 
 Matthias Brugger <matthias.bgg@gmail.com>, 
 AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>, 
 Jeff Johnson <jjohnson@kernel.org>, 
 =?utf-8?q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>, 
 Felix Fietkau <nbd@nbd.name>, Lorenzo Bianconi <lorenzo@kernel.org>, 
 Ryder Lee <ryder.lee@mediatek.com>, Shayne Chen <shayne.chen@mediatek.com>, 
 Sean Wang <sean.wang@mediatek.com>, Ping-Ke Shih <pkshih@realtek.com>, 
 Richard Cochran <richardcochran@gmail.com>
Cc: linux-can@vger.kernel.org, linux-kernel@vger.kernel.org, 
 netdev@vger.kernel.org, imx@lists.linux.dev, 
 intel-wired-lan@lists.osuosl.org, linux-rdma@vger.kernel.org, 
 linux-arm-kernel@lists.infradead.org, linux-mediatek@lists.infradead.org, 
 linux-wireless@vger.kernel.org, ath10k@lists.infradead.org, 
 ath11k@lists.infradead.org, ath12k@lists.infradead.org, 
 Peng Fan <peng.fan@nxp.com>
X-Mailer: b4 0.15.2
X-ClientProxiedBy: SI2PR02CA0017.apcprd02.prod.outlook.com
 (2603:1096:4:194::17) To AM8PR04MB7874.eurprd04.prod.outlook.com
 (2603:10a6:20b:24d::9)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM8PR04MB7874:EE_|VI0PR04MB11781:EE_
X-MS-Office365-Filtering-Correlation-Id: ef653d2c-01a8-4e39-11ee-08df14b91de5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|23010399003|7416014|19092799006|1800799024|366016|6133799003|18002099003|3023799007|921020|11063799006|10067099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	0VoWtksQMJLQX4EHuc744d6nPJuZnurzDQvqoCDyOxpCeYj++VUyPZDGuXuTXBUqdbpJuHFTb49AxHLfSMZLJE1hv3dCp2YkGDDGcH0Ar0eMtMo6ipluE4Ngr6AbOg5Zf8Mr96LO4T9eJzXPgSL/hKdTxrbGVtceP9T6TIfvzeTyARv76UljEnWMM5/2hYMOuwHRYl+QO6hNXPNnT9QOpVcTw/zQsoVN9O+cQvBDkq+LW1+KbSaq5FEpnLUCjJTkGoWnjcohrb129hpI9Z97uyQiddzKsJnOzODBSQTPUqrr+gi5inPuNS5CNPhWaomHzPKggdrGYf5zhqfRGwP+BEgJ97OfEoVMGfHkKkBR7zspvbbdkt52/HSqbG9zv6tEOTYnPeXqPxsBUq5abBejA3dfBwTH1ydcomzSTKQOfTcgRVGhAotSTAU2txJbmuwO/KSRnGI8ChjXscxK9jjnzO7HtRLnkoq5TPMRMzUFon6bzOEHpnGJUcBAaH8zN8uNsebMVKbXUfGNB5FAX8cG6zwLjSTHSQgfwoz4R7rbKlSDtqfNe4ejRPJ7QVEnLvTTg+Tz6Pxy+SNEkcfOW0U969Qtef/hkSEFAm52+nwaWAFCuiPDnUHFmtxJ35QeF8KPcLDnhPQkwbmhwqvPprymO/bGFW4vVc9GB4uENgEo3m8272xgXnahTa86c/xqqguqkSGPx9EGNnlp5sOyD0C47Q==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM8PR04MB7874.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(23010399003)(7416014)(19092799006)(1800799024)(366016)(6133799003)(18002099003)(3023799007)(921020)(11063799006)(10067099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?UTl1SlZCV2lJM1FLM212M3B5Um8ra0pGZGNZaExxcUdVYm53UEh2SE5nc2hj?=
 =?utf-8?B?c2VMazZ0YXVnaVg0VzFqWkMzU1V2T1BrUnZ2ZW5iMjV6N3RmdDVYdXBSaktG?=
 =?utf-8?B?Y05nbnhqOXljVlZTcG4xaERieGNjRE81SnFObUpMYm9sOGEvQVh0OGtWZHBi?=
 =?utf-8?B?emRuU0VQMFl2NHUwRnkzK202NjVpdDBnRWRBNkVUZEtrWHFxL21FR2RpeW1O?=
 =?utf-8?B?Zm9FclZQYXFjZWtHa0FmNGltK2dHMTBNbFhyZGd4TXZQZTVyeExpR014ekxz?=
 =?utf-8?B?QVNmK2VYeWp0UFpsU0J5aVF4REZwcUxiNWVFU2hCVHhmdElkNFFlQVFGM3R1?=
 =?utf-8?B?OEhVS25jcDhDdTQ2S1YxYTI4WjIxT1FzRUNvOGxKdllUMXBYU3IyS3lTdDly?=
 =?utf-8?B?T3hIQXhjbWZ0cjlzM3pGVXh5a01TdXAyaHg3bEQ1U1NNV1FVQ1I3aExPYU9i?=
 =?utf-8?B?YTJnejkraEN2QUxEdmV5ZUk0M0FpYm9McWZjb2RHQnFoOTMxbVRaeWFqRWxP?=
 =?utf-8?B?b3V0cWlNVGNCdFpNSHgvNFl1U3FDQ3l1ZE44TkNRN1RvNmp6NnRTVVFOc3JL?=
 =?utf-8?B?Y2cxcks5YnRPQys3c1ExTUZGVHp1K0pQODRTS2lSNWJzUS80dkxIckh4YkNO?=
 =?utf-8?B?aUt6TEludzltYmJJTDBOendSZ0ZNSnNaczJpOStxMFA5ZFVjMFZnUG9lN3Jk?=
 =?utf-8?B?S1Rzc0FhdFNVWlpzc3R5NUJsT3JVOE9Iak1GYXFUMUVBU0k0QXZSN1RwTDRR?=
 =?utf-8?B?NGE2Qm5UZVYzakZUS2p1U1dYTlZhWGF0MWhwM2hoTWtCemVBUGtzLzVONHpY?=
 =?utf-8?B?aW4zUDNUaWsxT1N3SzdDdDduOWVwYVJEbjlIZGRwc1lQa1dTS3hLbVJwWldx?=
 =?utf-8?B?bzdzT1lqKzZKUk5TRFJuT1JTckoyNjFoUlU2MCtZaUNUTzBVSVczclNJWE9E?=
 =?utf-8?B?UGlaYVN1NVhndEZaRUJ1dFE0QVF5aXdDSzhMa01FbTZnM3ZadGhjUzNXZmVH?=
 =?utf-8?B?Z0ZlMDdlS0NTTVRGNGJNN29TZ0ZacjRod2NyNFVaQ3dQTGRZVk8vaGRsNm1S?=
 =?utf-8?B?a3lmY3VxaVk4WlhQMDJkL0JOaWVDSUlNaHhxV1hNajV5TmFvZ2Q1WU9heUlZ?=
 =?utf-8?B?MlQyU2tiRUpHT1JFVVJlOFAzazRSenRSQnc3YjZWbHVDbXh6b3NNZVkydWNX?=
 =?utf-8?B?TkFkbnEvQ3JldlYzQm1kYkFEbGVJZ0oxcFI0T2tBY2pBZXpjTzZEVTMvZEdM?=
 =?utf-8?B?cXE1cVhDZWtXTXc4akNnVXRrKytDbEZ6U1BIRWxBQzUvaEdMdmVtUG9OSW5h?=
 =?utf-8?B?b0xHTHU5OHJxUkpIam1hb3dUdHV6NEptSjk3REwyVXNoWTcrTkZYanJUbkVw?=
 =?utf-8?B?U0ZzRjYyLzJOSUZjamlyUFphMnRFamI3YXFCNFhkaktibmdiZ0h5a2ZvT2Ew?=
 =?utf-8?B?UGRFQktsV3cxWERQOERYdFF4NlhrWUhFbTNWMVB3VVFBSmJCMW10MnN1SjhC?=
 =?utf-8?B?ajU2enhLamV0Y0dqZS83SmhaQWlaTUE2emxyeWRmNkhKcWwyRG91UkRFbnRV?=
 =?utf-8?B?WTZrSk5FdDZnQlZyd0Nlb1pieEJSS2Y1WThjVTdXVmxqczdySktUY2VNOWQ2?=
 =?utf-8?B?cmZKazkzdmk3VGFBUHpwdXlZcWY5YmdDT1hEdEMwMitCRUI3RTI1dFpUekYy?=
 =?utf-8?B?QktwMEljcHVNMmJISTN2ZE9qQ2ZMOWtEUDYzK3BoNGtWeDgrK05lMWZsak82?=
 =?utf-8?B?THpxUjI5Rk9kdXNOQy9EQ3dmMmZYRjl3eUZtTXhNRFpVemVPbG5sVUF5SDNJ?=
 =?utf-8?B?L041QStyUkFEakExemZvWC82TEljalozT2dIb29rRG1qbGtXdk1NbGxZWkV0?=
 =?utf-8?B?RHE4aHo5WGlBbEx3TzJ5aGp4Q2hlc0ZGdGtmVit4L2xiQjVGdnBNb2k1UVRu?=
 =?utf-8?B?WFU1alRiUDlmQTZNbGsrNmk2dUdka1NqaGxiY3NHUnZSSk5CODZyZnVMblNM?=
 =?utf-8?B?Z3pyN2FHSGVYRVViRWsvZ0hkSjQyNmx3VlIzMitWT1JmN004RkJGRGg1Zndi?=
 =?utf-8?B?TVhCVGc3cWNvYWk4SEhsTExsaWJiaERxU2g1U2hSaWpxM005dUtlc0ZCYXFw?=
 =?utf-8?B?VUVReDB5OWowekNDWVpNQ0g1Z3NmcU9iSk40aHQyMldncTNGdkR2RURXcXRx?=
 =?utf-8?B?VVJCaHBQUFg2dnVaQ0dYMGpva090Vnp3WUd3bFptd3BoeXo1bHk4emJqKzZQ?=
 =?utf-8?B?MmMrM0IxRVFBbDNNaGZnLzI4ekpualBrZWR5SEh1QkcvWVNsV09OaEErazBk?=
 =?utf-8?B?dDJkSzBLL0hIYUI1Q0l3dmtlcUc4MlJ3ZHR4TjlRMisyZWpuaXdza2JyWUtP?=
 =?utf-8?Q?3mnzt87gRcsXT6ZKsQ6XZN1JQTLaHr4KXZPLd?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ef653d2c-01a8-4e39-11ee-08df14b91de5
X-MS-Exchange-CrossTenant-AuthSource: AM8PR04MB7874.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Sep 2026 12:42:21.6715
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3QutRa/UmlTsE3m1rGVdsRIFfOGNqYa+aWHps4nfpuPlAXHuhBekSjjIFHHVfSbIufkJOuHkejLMex7IOqTqcuhX7ZQPfw+VmTe08m2aFAINRG5oT9jOtaD9iYstLQkB
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI0PR04MB11781

From: Peng Fan <peng.fan@nxp.com>

Convert open-coded if/else with set_bit/clear_bit and their
non-atomic __set_bit/__clear_bit variants to the assign_bit/__assign_bit
API.

Done with Coccinelle semantic patch:
    // set_bit -> clear_bit => assign_bit

    @@
    expression cond, bit, addr;
    @@

    -if (cond)
    -        set_bit(bit, addr);
    -else
    -        clear_bit(bit, addr);
    +assign_bit(bit, addr, cond);

    // clear_bit -> set_bit => assign_bit

    @@
    expression cond, bit, addr;
    @@

    -if (cond)
    -        clear_bit(bit, addr);
    -else
    -        set_bit(bit, addr);
    +assign_bit(bit, addr, !cond);

    // __set_bit -> __clear_bit => __assign_bit

    @@
    expression cond, bit, addr;
    @@

    -if (cond)
    -        __set_bit(bit, addr);
    -else
    -        __clear_bit(bit, addr);
    +__assign_bit(bit, addr, cond);

    // __clear_bit -> __set_bit => __assign_bit

    @@
    expression cond, bit, addr;
    @@

    -if (cond)
    -        __clear_bit(bit, addr);
    -else
    -        __set_bit(bit, addr);
    +__assign_bit(bit, addr, !cond);

Signed-off-by: Peng Fan <peng.fan@nxp.com>
---
 drivers/net/can/slcan/slcan-core.c                 |  5 +----
 drivers/net/ethernet/amd/xgbe/xgbe-mdio.c          |  5 +----
 drivers/net/ethernet/aquantia/atlantic/aq_nic.c    |  5 +----
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.c  | 18 ++++-----------
 drivers/net/ethernet/freescale/enetc/enetc.c       |  5 +----
 drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c | 10 ++-------
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c |  7 ++----
 drivers/net/ethernet/intel/i40e/i40e_ethtool.c     | 10 ++-------
 drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c |  5 +----
 drivers/net/ethernet/intel/ice/ice_ethtool.c       |  5 +----
 drivers/net/ethernet/intel/ice/ice_txclk.c         | 20 ++++++-----------
 drivers/net/ethernet/marvell/octeontx2/af/cgx.c    | 10 ++-------
 .../net/ethernet/marvell/octeontx2/af/cn20k/npc.c  |  5 +----
 .../net/ethernet/marvell/octeontx2/af/rvu_nix.c    | 15 +++----------
 .../net/ethernet/marvell/octeontx2/af/rvu_npa.c    | 10 ++-------
 .../net/ethernet/mellanox/mlx5/core/en_ethtool.c   |  6 ++---
 drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c |  6 ++---
 drivers/net/ethernet/meta/fbnic/fbnic_rpc.c        |  8 ++-----
 .../net/ethernet/pensando/ionic/ionic_ethtool.c    | 10 ++-------
 drivers/net/ethernet/qlogic/qede/qede_ethtool.c    |  6 ++---
 drivers/net/ethernet/qlogic/qla3xxx.c              | 18 +++++----------
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_dcb.c    |  5 +----
 .../ethernet/qlogic/qlcnic/qlcnic_sriov_common.c   |  6 ++---
 .../net/ethernet/qlogic/qlcnic/qlcnic_sriov_pf.c   |  6 ++---
 drivers/net/ethernet/wangxun/libwx/wx_ptp.c        |  5 +----
 drivers/net/phy/mediatek/mtk-phy-lib.c             | 26 +++++++---------------
 drivers/net/wireless/ath/ath10k/debug.c            | 10 ++-------
 drivers/net/wireless/ath/ath10k/snoc.c             |  6 ++---
 drivers/net/wireless/ath/ath11k/htc.c              |  5 +----
 drivers/net/wireless/ath/ath12k/htc.c              |  5 +----
 drivers/net/wireless/ath/ath9k/ar9003_calib.c      |  5 +----
 drivers/net/wireless/ath/ath9k/mci.c               |  5 +----
 .../net/wireless/mediatek/mt76/mt76_connac_mcu.c   |  5 +----
 drivers/net/wireless/mediatek/mt76/mt7925/mcu.c    |  5 +----
 drivers/net/wireless/realtek/rtw88/debug.c         |  5 +----
 drivers/net/wireless/realtek/rtw89/core.c          |  5 +----
 drivers/net/wireless/realtek/rtw89/mac.c           | 10 ++-------
 drivers/net/wireless/realtek/rtw89/regd.c          |  5 +----
 drivers/net/wireless/ti/wlcore/rx.c                |  5 +----
 39 files changed, 77 insertions(+), 236 deletions(-)

diff --git a/drivers/net/can/slcan/slcan-core.c b/drivers/net/can/slcan/slcan-core.c
index 7439849d5c84..c9414faafe66 100644
--- a/drivers/net/can/slcan/slcan-core.c
+++ b/drivers/net/can/slcan/slcan-core.c
@@ -131,10 +131,7 @@ int slcan_enable_err_rst_on_open(struct net_device *ndev, bool on)
 	if (netif_running(ndev))
 		return -EBUSY;
 
-	if (on)
-		set_bit(CF_ERR_RST, &sl->cmd_flags);
-	else
-		clear_bit(CF_ERR_RST, &sl->cmd_flags);
+	assign_bit(CF_ERR_RST, &sl->cmd_flags, on);
 
 	return 0;
 }
diff --git a/drivers/net/ethernet/amd/xgbe/xgbe-mdio.c b/drivers/net/ethernet/amd/xgbe/xgbe-mdio.c
index 12770af031eb..c56587384d57 100644
--- a/drivers/net/ethernet/amd/xgbe/xgbe-mdio.c
+++ b/drivers/net/ethernet/amd/xgbe/xgbe-mdio.c
@@ -1202,10 +1202,7 @@ static int __xgbe_phy_config_aneg(struct xgbe_prv_data *pdata, bool set_mode)
 	xgbe_an_restart(pdata);
 
 out:
-	if (ret)
-		set_bit(XGBE_LINK_ERR, &pdata->dev_state);
-	else
-		clear_bit(XGBE_LINK_ERR, &pdata->dev_state);
+	assign_bit(XGBE_LINK_ERR, &pdata->dev_state, ret);
 
 	mutex_unlock(&pdata->an_mutex);
 
diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_nic.c b/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
index 01792f7abf96..42e0fe9248f2 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
@@ -1717,10 +1717,7 @@ int aq_nic_setup_tc_min_rate(struct aq_nic_s *self, const unsigned int tc,
 	if (tc >= AQ_CFG_TCS_MAX)
 		return -EINVAL;
 
-	if (min_rate)
-		set_bit(tc, &cfg->tc_min_rate_msk);
-	else
-		clear_bit(tc, &cfg->tc_min_rate_msk);
+	assign_bit(tc, &cfg->tc_min_rate_msk, min_rate);
 
 	if (min_rate && min_rate < 20) {
 		netdev_warn(self->ndev,
diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.c b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.c
index b8af508f9c98..b337e61f9c81 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.c
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.c
@@ -207,10 +207,7 @@ void bnx2x_vfop_qctor_prep(struct bnx2x *bp,
 	 */
 	__set_bit(BNX2X_Q_FLG_TX_SWITCH, &setup_p->flags);
 	__set_bit(BNX2X_Q_FLG_TX_SEC, &setup_p->flags);
-	if (vf->spoofchk)
-		__set_bit(BNX2X_Q_FLG_ANTI_SPOOF, &setup_p->flags);
-	else
-		__clear_bit(BNX2X_Q_FLG_ANTI_SPOOF, &setup_p->flags);
+	__assign_bit(BNX2X_Q_FLG_ANTI_SPOOF, &setup_p->flags, vf->spoofchk);
 
 	/* Setup-op rx parameters */
 	if (test_bit(BNX2X_Q_TYPE_HAS_RX, &q_type)) {
@@ -2370,12 +2367,8 @@ static int bnx2x_set_pf_tx_switching(struct bnx2x *bp, bool enable)
 	q_params.cmd = BNX2X_Q_CMD_UPDATE;
 	__set_bit(BNX2X_Q_UPDATE_TX_SWITCHING_CHNG,
 		  &q_params.params.update.update_flags);
-	if (enable)
-		__set_bit(BNX2X_Q_UPDATE_TX_SWITCHING,
-			  &q_params.params.update.update_flags);
-	else
-		__clear_bit(BNX2X_Q_UPDATE_TX_SWITCHING,
-			    &q_params.params.update.update_flags);
+	__assign_bit(BNX2X_Q_UPDATE_TX_SWITCHING,
+		     &q_params.params.update.update_flags, enable);
 
 	/* send the ramrod on all the queues of the PF */
 	for_each_eth_queue(bp, i) {
@@ -2764,10 +2757,7 @@ static void bnx2x_set_vf_vlan_acceptance(struct bnx2x *bp,
 
 	/* need to remove/add the VF's accept_any_vlan bit */
 	accept_flags = bnx2x_leading_vfq(vf, accept_flags);
-	if (accept)
-		set_bit(BNX2X_ACCEPT_ANY_VLAN, &accept_flags);
-	else
-		clear_bit(BNX2X_ACCEPT_ANY_VLAN, &accept_flags);
+	assign_bit(BNX2X_ACCEPT_ANY_VLAN, &accept_flags, accept);
 
 	bnx2x_vf_prep_rx_mode(bp, LEADING_IDX, &rx_ramrod, vf,
 			      accept_flags);
diff --git a/drivers/net/ethernet/freescale/enetc/enetc.c b/drivers/net/ethernet/freescale/enetc/enetc.c
index 04c49b680709..c6571b5cc842 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc.c
@@ -88,10 +88,7 @@ void enetc_set_congestion_mode(struct enetc_ndev_priv *priv, bool enable)
 
 	spin_lock(&si->gen_lock);
 
-	if (enable)
-		set_bit(ENETC_RXBDR_CM, &priv->flags);
-	else
-		clear_bit(ENETC_RXBDR_CM, &priv->flags);
+	assign_bit(ENETC_RXBDR_CM, &priv->flags, enable);
 
 	for (int i = 0; i < priv->num_rx_rings; i++) {
 		u32 old_rbmr = enetc_rxbdr_rd(hw, i, ENETC_RBMR);
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c b/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
index e7318f236315..7b92a3c73ef6 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
@@ -474,10 +474,7 @@ static void hns3_update_limit_promisc_mode(struct net_device *netdev,
 {
 	struct hnae3_handle *handle = hns3_get_handle(netdev);
 
-	if (enable)
-		set_bit(HNAE3_PFLAG_LIMIT_PROMISC, &handle->priv_flags);
-	else
-		clear_bit(HNAE3_PFLAG_LIMIT_PROMISC, &handle->priv_flags);
+	assign_bit(HNAE3_PFLAG_LIMIT_PROMISC, &handle->priv_flags, enable);
 
 	hns3_request_update_promisc_mode(handle);
 }
@@ -1210,10 +1207,7 @@ static int hns3_set_tx_push(struct net_device *netdev, u32 tx_push)
 	netdev_dbg(netdev, "Changing tx push from %s to %s\n",
 		   str_on_off(old_state), str_on_off(tx_push));
 
-	if (tx_push)
-		set_bit(HNS3_NIC_STATE_TX_PUSH_ENABLE, &priv->state);
-	else
-		clear_bit(HNS3_NIC_STATE_TX_PUSH_ENABLE, &priv->state);
+	assign_bit(HNS3_NIC_STATE_TX_PUSH_ENABLE, &priv->state, tx_push);
 
 	return 0;
 }
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c
index 30e38cb4843a..08040a492985 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c
@@ -341,11 +341,8 @@ static void hclge_set_vf_promisc_mode(struct hclge_vport *vport,
 	vport->vf_info.request_mc_en = req->msg.en_mc;
 	vport->vf_info.request_bc_en = req->msg.en_bc;
 
-	if (req->msg.en_limit_promisc)
-		set_bit(HNAE3_PFLAG_LIMIT_PROMISC, &handle->priv_flags);
-	else
-		clear_bit(HNAE3_PFLAG_LIMIT_PROMISC,
-			  &handle->priv_flags);
+	assign_bit(HNAE3_PFLAG_LIMIT_PROMISC, &handle->priv_flags,
+		   req->msg.en_limit_promisc);
 
 	set_bit(HCLGE_VPORT_STATE_PROMISC_CHANGE, &vport->state);
 	hclge_task_schedule(hdev, 0);
diff --git a/drivers/net/ethernet/intel/i40e/i40e_ethtool.c b/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
index ef9d1e78c16a..6a992df06fa1 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
@@ -5263,10 +5263,7 @@ static int i40e_set_priv_flags(struct net_device *dev, u32 flags)
 		    test_bit(priv_flag->bitno, orig_flags) != new_val)
 			return -EOPNOTSUPP;
 
-		if (new_val)
-			set_bit(priv_flag->bitno, new_flags);
-		else
-			clear_bit(priv_flag->bitno, new_flags);
+		assign_bit(priv_flag->bitno, new_flags, new_val);
 	}
 
 	if (pf->hw.pf_id != 0)
@@ -5284,10 +5281,7 @@ static int i40e_set_priv_flags(struct net_device *dev, u32 flags)
 		    test_bit(priv_flag->bitno, orig_flags) != new_val)
 			return -EOPNOTSUPP;
 
-		if (new_val)
-			set_bit(priv_flag->bitno, new_flags);
-		else
-			clear_bit(priv_flag->bitno, new_flags);
+		assign_bit(priv_flag->bitno, new_flags, new_val);
 	}
 
 flags_complete:
diff --git a/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c b/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
index a26c3d47ec15..0087f7ae0c4c 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
@@ -1158,10 +1158,7 @@ static int i40e_alloc_vf_res(struct i40e_vf *vf)
 		pf->queues_left -=
 			total_queue_pairs - I40E_DEFAULT_QUEUES_PER_VF;
 
-	if (vf->trusted)
-		set_bit(I40E_VIRTCHNL_VF_CAP_PRIVILEGE, &vf->vf_caps);
-	else
-		clear_bit(I40E_VIRTCHNL_VF_CAP_PRIVILEGE, &vf->vf_caps);
+	assign_bit(I40E_VIRTCHNL_VF_CAP_PRIVILEGE, &vf->vf_caps, vf->trusted);
 
 	/* store the total qps number for the runtime
 	 * VF req validation
diff --git a/drivers/net/ethernet/intel/ice/ice_ethtool.c b/drivers/net/ethernet/intel/ice/ice_ethtool.c
index bf9a821c543b..51388ec05a90 100644
--- a/drivers/net/ethernet/intel/ice/ice_ethtool.c
+++ b/drivers/net/ethernet/intel/ice/ice_ethtool.c
@@ -1751,10 +1751,7 @@ static int ice_set_priv_flags(struct net_device *netdev, u32 flags)
 
 		priv_flag = &ice_gstrings_priv_flags[i];
 
-		if (flags & BIT(i))
-			set_bit(priv_flag->bitno, pf->flags);
-		else
-			clear_bit(priv_flag->bitno, pf->flags);
+		assign_bit(priv_flag->bitno, pf->flags, flags & BIT(i));
 	}
 
 	bitmap_xor(change_flags, pf->flags, orig_flags, ICE_PF_FLAGS_NBITS);
diff --git a/drivers/net/ethernet/intel/ice/ice_txclk.c b/drivers/net/ethernet/intel/ice/ice_txclk.c
index 48459f971cbf..3bca4443f03a 100644
--- a/drivers/net/ethernet/intel/ice/ice_txclk.c
+++ b/drivers/net/ethernet/intel/ice/ice_txclk.c
@@ -286,12 +286,9 @@ void ice_txclk_update_and_notify(struct ice_pf *pf)
 			if (ctrl_pf != pf)
 				mutex_lock(&ctrl_pf->dplls.lock);
 			for (int i = 0; i < ICE_REF_CLK_MAX; i++) {
-				if (clk == i)
-					set_bit(ptp_port->port_num,
-						&ctrl_pf->ptp.tx_refclks[phy][i]);
-				else
-					clear_bit(ptp_port->port_num,
-						  &ctrl_pf->ptp.tx_refclks[phy][i]);
+				assign_bit(ptp_port->port_num,
+					   &ctrl_pf->ptp.tx_refclks[phy][i],
+					   clk == i);
 			}
 			if (ctrl_pf != pf)
 				mutex_unlock(&ctrl_pf->dplls.lock);
@@ -315,13 +312,10 @@ void ice_txclk_update_and_notify(struct ice_pf *pf)
 	 */
 	if (ctrl_pf != pf)
 		mutex_lock(&ctrl_pf->dplls.lock);
-	for (int i = 0; i < ICE_REF_CLK_MAX; i++)
-		if (clk == i)
-			set_bit(ptp_port->port_num,
-				&ctrl_pf->ptp.tx_refclks[phy][i]);
-		else
-			clear_bit(ptp_port->port_num,
-				  &ctrl_pf->ptp.tx_refclks[phy][i]);
+	for (int i = 0; i < ICE_REF_CLK_MAX; i++) {
+		assign_bit(ptp_port->port_num,
+			   &ctrl_pf->ptp.tx_refclks[phy][i], clk == i);
+	}
 	if (ctrl_pf != pf)
 		mutex_unlock(&ctrl_pf->dplls.lock);
 
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/cgx.c b/drivers/net/ethernet/marvell/octeontx2/af/cgx.c
index 8ced44a4495e..ade394c2beba 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/cgx.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/cgx.c
@@ -981,15 +981,9 @@ int verify_lmac_fc_cfg(void *cgxd, int lmac_id, u8 tx_pause, u8 rx_pause,
 	if (!lmac)
 		return -ENODEV;
 
-	if (!rx_pause)
-		clear_bit(pfvf_idx, lmac->rx_fc_pfvf_bmap.bmap);
-	else
-		set_bit(pfvf_idx, lmac->rx_fc_pfvf_bmap.bmap);
+	assign_bit(pfvf_idx, lmac->rx_fc_pfvf_bmap.bmap, rx_pause);
 
-	if (!tx_pause)
-		clear_bit(pfvf_idx, lmac->tx_fc_pfvf_bmap.bmap);
-	else
-		set_bit(pfvf_idx, lmac->tx_fc_pfvf_bmap.bmap);
+	assign_bit(pfvf_idx, lmac->tx_fc_pfvf_bmap.bmap, tx_pause);
 
 	/* check if other pfvfs are using flow control */
 	if (!rx_pause && bitmap_weight(lmac->rx_fc_pfvf_bmap.bmap, lmac->rx_fc_pfvf_bmap.max)) {
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/cn20k/npc.c b/drivers/net/ethernet/marvell/octeontx2/af/cn20k/npc.c
index 2b67671a2bd8..7c829b1da3e5 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/cn20k/npc.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/cn20k/npc.c
@@ -857,10 +857,7 @@ npc_cn20k_enable_mcam_entry(struct rvu *rvu, int blkaddr,
 	}
 
 update_en_map:
-	if (enable)
-		set_bit(index, npc_priv->en_map);
-	else
-		clear_bit(index, npc_priv->en_map);
+	assign_bit(index, npc_priv->en_map, enable);
 
 	return 0;
 }
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
index d80d2c00bd84..93c5c4b298bf 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
@@ -1233,28 +1233,19 @@ static int rvu_nix_blk_aq_enq_inst(struct rvu *rvu, struct nix_hw *nix_hw,
 			ena = (req->rq.ena & req->rq_mask.ena) |
 				(test_bit(req->qidx, pfvf->rq_bmap) &
 				~req->rq_mask.ena);
-			if (ena)
-				__set_bit(req->qidx, pfvf->rq_bmap);
-			else
-				__clear_bit(req->qidx, pfvf->rq_bmap);
+			__assign_bit(req->qidx, pfvf->rq_bmap, ena);
 		}
 		if (req->ctype == NIX_AQ_CTYPE_SQ) {
 			ena = (req->rq.ena & req->sq_mask.ena) |
 				(test_bit(req->qidx, pfvf->sq_bmap) &
 				~req->sq_mask.ena);
-			if (ena)
-				__set_bit(req->qidx, pfvf->sq_bmap);
-			else
-				__clear_bit(req->qidx, pfvf->sq_bmap);
+			__assign_bit(req->qidx, pfvf->sq_bmap, ena);
 		}
 		if (req->ctype == NIX_AQ_CTYPE_CQ) {
 			ena = (req->rq.ena & req->cq_mask.ena) |
 				(test_bit(req->qidx, pfvf->cq_bmap) &
 				~req->cq_mask.ena);
-			if (ena)
-				__set_bit(req->qidx, pfvf->cq_bmap);
-			else
-				__clear_bit(req->qidx, pfvf->cq_bmap);
+			__assign_bit(req->qidx, pfvf->cq_bmap, ena);
 		}
 	}
 
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npa.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npa.c
index e2a33e46b48a..334dc3e888f4 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npa.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npa.c
@@ -169,10 +169,7 @@ int rvu_npa_aq_enq_inst(struct rvu *rvu, struct npa_aq_enq_req *req,
 			ena = (req->aura.ena & req->aura_mask.ena) |
 				(test_bit(req->aura_id, pfvf->aura_bmap) &
 				~req->aura_mask.ena);
-			if (ena)
-				__set_bit(req->aura_id, pfvf->aura_bmap);
-			else
-				__clear_bit(req->aura_id, pfvf->aura_bmap);
+			__assign_bit(req->aura_id, pfvf->aura_bmap, ena);
 		}
 	}
 
@@ -184,10 +181,7 @@ int rvu_npa_aq_enq_inst(struct rvu *rvu, struct npa_aq_enq_req *req,
 			ena = (req->pool.ena & req->pool_mask.ena) |
 				(test_bit(req->aura_id, pfvf->pool_bmap) &
 				~req->pool_mask.ena);
-			if (ena)
-				__set_bit(req->aura_id, pfvf->pool_bmap);
-			else
-				__clear_bit(req->aura_id, pfvf->pool_bmap);
+			__assign_bit(req->aura_id, pfvf->pool_bmap, ena);
 		}
 	}
 	spin_unlock(&aq->lock);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
index 3ed59ced0407..261c466a4d36 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
@@ -2320,10 +2320,8 @@ static int set_pflag_rx_no_csum_complete(struct net_device *netdev, bool enable)
 
 	for (i = 0; i < channels->num; i++) {
 		c = channels->c[i];
-		if (enable)
-			__set_bit(MLX5E_RQ_STATE_NO_CSUM_COMPLETE, &c->rq.state);
-		else
-			__clear_bit(MLX5E_RQ_STATE_NO_CSUM_COMPLETE, &c->rq.state);
+		__assign_bit(MLX5E_RQ_STATE_NO_CSUM_COMPLETE, &c->rq.state,
+			     enable);
 	}
 
 	return 0;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c b/drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c
index 07440c58713a..7c0585fe1ee7 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c
@@ -66,10 +66,8 @@ static int mlx5_fw_reset_enable_remote_dev_reset_set(struct devlink *devlink, u3
 
 	fw_reset = dev->priv.fw_reset;
 
-	if (ctx->val.vbool)
-		clear_bit(MLX5_FW_RESET_FLAGS_NACK_RESET_REQUEST, &fw_reset->reset_flags);
-	else
-		set_bit(MLX5_FW_RESET_FLAGS_NACK_RESET_REQUEST, &fw_reset->reset_flags);
+	assign_bit(MLX5_FW_RESET_FLAGS_NACK_RESET_REQUEST,
+		   &fw_reset->reset_flags, !ctx->val.vbool);
 	return 0;
 }
 
diff --git a/drivers/net/ethernet/meta/fbnic/fbnic_rpc.c b/drivers/net/ethernet/meta/fbnic/fbnic_rpc.c
index bc0f38b6a2b2..ab6e342ec3fa 100644
--- a/drivers/net/ethernet/meta/fbnic/fbnic_rpc.c
+++ b/drivers/net/ethernet/meta/fbnic/fbnic_rpc.c
@@ -126,12 +126,8 @@ void fbnic_bmc_rpc_all_multi_config(struct fbnic_dev *fbd,
 			set_bit(FBNIC_MAC_ADDR_T_BMC, mac_addr->act_tcam);
 			mac_addr->state = FBNIC_TCAM_S_ADD;
 		}
-		if (enable_host)
-			set_bit(FBNIC_MAC_ADDR_T_ALLMULTI,
-				mac_addr->act_tcam);
-		else
-			clear_bit(FBNIC_MAC_ADDR_T_ALLMULTI,
-				  mac_addr->act_tcam);
+		assign_bit(FBNIC_MAC_ADDR_T_ALLMULTI, mac_addr->act_tcam,
+			   enable_host);
 	} else {
 		__fbnic_xc_unsync(mac_addr, FBNIC_MAC_ADDR_T_BMC);
 		__fbnic_xc_unsync(mac_addr, FBNIC_MAC_ADDR_T_ALLMULTI);
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c b/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c
index fc8c50e8f365..119ac720c078 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c
@@ -655,15 +655,9 @@ static int ionic_cmb_rings_toggle(struct ionic_lif *lif, bool cmb_tx, bool cmb_r
 	if (pages_used < 0)
 		return pages_used;
 
-	if (cmb_tx)
-		set_bit(IONIC_LIF_F_CMB_TX_RINGS, lif->state);
-	else
-		clear_bit(IONIC_LIF_F_CMB_TX_RINGS, lif->state);
+	assign_bit(IONIC_LIF_F_CMB_TX_RINGS, lif->state, cmb_tx);
 
-	if (cmb_rx)
-		set_bit(IONIC_LIF_F_CMB_RX_RINGS, lif->state);
-	else
-		clear_bit(IONIC_LIF_F_CMB_RX_RINGS, lif->state);
+	assign_bit(IONIC_LIF_F_CMB_RX_RINGS, lif->state, cmb_rx);
 
 	if (cmb_tx || cmb_rx)
 		netdev_info(lif->netdev, "Enabling CMB %s %s rings - %d pages\n",
diff --git a/drivers/net/ethernet/qlogic/qede/qede_ethtool.c b/drivers/net/ethernet/qlogic/qede/qede_ethtool.c
index 647f30a16a94..037882a34203 100644
--- a/drivers/net/ethernet/qlogic/qede/qede_ethtool.c
+++ b/drivers/net/ethernet/qlogic/qede/qede_ethtool.c
@@ -492,10 +492,8 @@ static int qede_set_priv_flags(struct net_device *dev, u32 flags)
 	if (dflags & ~BIT(QEDE_PRI_FLAG_RECOVER_ON_ERROR))
 		return -EINVAL;
 
-	if (flags & BIT(QEDE_PRI_FLAG_RECOVER_ON_ERROR))
-		set_bit(QEDE_ERR_IS_RECOVERABLE, &edev->err_flags);
-	else
-		clear_bit(QEDE_ERR_IS_RECOVERABLE, &edev->err_flags);
+	assign_bit(QEDE_ERR_IS_RECOVERABLE, &edev->err_flags,
+		   flags & BIT(QEDE_PRI_FLAG_RECOVER_ON_ERROR));
 
 	return 0;
 }
diff --git a/drivers/net/ethernet/qlogic/qla3xxx.c b/drivers/net/ethernet/qlogic/qla3xxx.c
index 776840f60d01..1466ec85de24 100644
--- a/drivers/net/ethernet/qlogic/qla3xxx.c
+++ b/drivers/net/ethernet/qlogic/qla3xxx.c
@@ -1581,10 +1581,8 @@ static void ql_link_state_machine_work(struct work_struct *work)
  */
 static void ql_get_phy_owner(struct ql3_adapter *qdev)
 {
-	if (ql_this_adapter_controls_port(qdev))
-		set_bit(QL_LINK_MASTER, &qdev->flags);
-	else
-		clear_bit(QL_LINK_MASTER, &qdev->flags);
+	assign_bit(QL_LINK_MASTER, &qdev->flags,
+		   ql_this_adapter_controls_port(qdev));
 }
 
 /*
@@ -3343,10 +3341,8 @@ static void ql_set_mac_info(struct ql3_adapter *qdev)
 		qdev->mac_ob_opcode = OUTBOUND_MAC_IOCB | func_number;
 		qdev->mb_bit_mask = FN0_MA_BITS_MASK;
 		qdev->PHYAddr = PORT0_PHY_ADDRESS;
-		if (port_status & PORT_STATUS_SM0)
-			set_bit(QL_LINK_OPTICAL, &qdev->flags);
-		else
-			clear_bit(QL_LINK_OPTICAL, &qdev->flags);
+		assign_bit(QL_LINK_OPTICAL, &qdev->flags,
+			   port_status & PORT_STATUS_SM0);
 		break;
 
 	case ISP_CONTROL_FN1_NET:
@@ -3354,10 +3350,8 @@ static void ql_set_mac_info(struct ql3_adapter *qdev)
 		qdev->mac_ob_opcode = OUTBOUND_MAC_IOCB | func_number;
 		qdev->mb_bit_mask = FN1_MA_BITS_MASK;
 		qdev->PHYAddr = PORT1_PHY_ADDRESS;
-		if (port_status & PORT_STATUS_SM1)
-			set_bit(QL_LINK_OPTICAL, &qdev->flags);
-		else
-			clear_bit(QL_LINK_OPTICAL, &qdev->flags);
+		assign_bit(QL_LINK_OPTICAL, &qdev->flags,
+			   port_status & PORT_STATUS_SM1);
 		break;
 
 	case ISP_CONTROL_FN0_SCSI:
diff --git a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_dcb.c b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_dcb.c
index 576340315e0d..ef4a0376baff 100644
--- a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_dcb.c
+++ b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_dcb.c
@@ -644,10 +644,7 @@ static void qlcnic_83xx_dcb_aen_handler(struct qlcnic_dcb *dcb, void *data)
 	if (test_and_set_bit(QLCNIC_DCB_AEN_MODE, &dcb->state))
 		return;
 
-	if (*val & BIT_8)
-		set_bit(QLCNIC_DCB_STATE, &dcb->state);
-	else
-		clear_bit(QLCNIC_DCB_STATE, &dcb->state);
+	assign_bit(QLCNIC_DCB_STATE, &dcb->state, *val & BIT_8);
 
 	queue_delayed_work(dcb->wq, &dcb->aen_work, 0);
 }
diff --git a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_sriov_common.c b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_sriov_common.c
index 0704dbc52d82..a106f961e177 100644
--- a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_sriov_common.c
+++ b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_sriov_common.c
@@ -1488,10 +1488,8 @@ static int qlcnic_sriov_channel_cfg_cmd(struct qlcnic_adapter *adapter, u8 cmd_o
 		goto out;
 	}
 
-	if (cmd_op == QLCNIC_BC_CMD_CHANNEL_INIT)
-		set_bit(QLC_BC_VF_STATE, &vf->state);
-	else
-		clear_bit(QLC_BC_VF_STATE, &vf->state);
+	assign_bit(QLC_BC_VF_STATE, &vf->state,
+		   cmd_op == QLCNIC_BC_CMD_CHANNEL_INIT);
 
 out:
 	qlcnic_free_mbx_args(&cmd);
diff --git a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_sriov_pf.c b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_sriov_pf.c
index 7052d34aad45..c69b41e317d2 100644
--- a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_sriov_pf.c
+++ b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_sriov_pf.c
@@ -773,10 +773,8 @@ static int qlcnic_sriov_pf_channel_cfg_cmd(struct qlcnic_bc_trans *trans,
 
 	cmd->rsp.arg[0] |= (1 << 25);
 
-	if (trans->req_hdr->cmd_op == QLCNIC_BC_CMD_CHANNEL_INIT)
-		set_bit(QLC_BC_VF_STATE, &vf->state);
-	else
-		clear_bit(QLC_BC_VF_STATE, &vf->state);
+	assign_bit(QLC_BC_VF_STATE, &vf->state,
+		   trans->req_hdr->cmd_op == QLCNIC_BC_CMD_CHANNEL_INIT);
 
 	return err;
 
diff --git a/drivers/net/ethernet/wangxun/libwx/wx_ptp.c b/drivers/net/ethernet/wangxun/libwx/wx_ptp.c
index 4708e7f3958f..ea6865b23f5f 100644
--- a/drivers/net/ethernet/wangxun/libwx/wx_ptp.c
+++ b/drivers/net/ethernet/wangxun/libwx/wx_ptp.c
@@ -450,10 +450,7 @@ static int wx_ptp_feature_enable(struct ptp_clock_info *ptp,
 		wx->pps_width = 120000000;
 	}
 
-	if (on)
-		set_bit(WX_FLAG_PTP_PPS_ENABLED, wx->flags);
-	else
-		clear_bit(WX_FLAG_PTP_PPS_ENABLED, wx->flags);
+	assign_bit(WX_FLAG_PTP_PPS_ENABLED, wx->flags, on);
 
 	return wx->ptp_setup_sdp(wx);
 }
diff --git a/drivers/net/phy/mediatek/mtk-phy-lib.c b/drivers/net/phy/mediatek/mtk-phy-lib.c
index 608072fbfde9..4c4eca870bde 100644
--- a/drivers/net/phy/mediatek/mtk-phy-lib.c
+++ b/drivers/net/phy/mediatek/mtk-phy-lib.c
@@ -136,22 +136,15 @@ int mtk_phy_led_hw_ctrl_get(struct phy_device *phydev, u8 index,
 	if (blink < 0)
 		return -EIO;
 
-	if ((on & (on_set | MTK_PHY_LED_ON_FDX |
-		   MTK_PHY_LED_ON_HDX | MTK_PHY_LED_ON_LINKDOWN)) ||
-	    (blink & (rx_blink_set | tx_blink_set)))
-		set_bit(bit_netdev, &priv->led_state);
-	else
-		clear_bit(bit_netdev, &priv->led_state);
+	assign_bit(bit_netdev, &priv->led_state,
+		   (on & (on_set | MTK_PHY_LED_ON_FDX | MTK_PHY_LED_ON_HDX |
+		    MTK_PHY_LED_ON_LINKDOWN)) ||
+		    (blink & (rx_blink_set | tx_blink_set)));
 
-	if (on & MTK_PHY_LED_ON_FORCE_ON)
-		set_bit(bit_on, &priv->led_state);
-	else
-		clear_bit(bit_on, &priv->led_state);
+	assign_bit(bit_on, &priv->led_state, on & MTK_PHY_LED_ON_FORCE_ON);
 
-	if (blink & MTK_PHY_LED_BLINK_FORCE_BLINK)
-		set_bit(bit_blink, &priv->led_state);
-	else
-		clear_bit(bit_blink, &priv->led_state);
+	assign_bit(bit_blink, &priv->led_state,
+		   blink & MTK_PHY_LED_BLINK_FORCE_BLINK);
 
 	if (!rules)
 		return 0;
@@ -254,10 +247,7 @@ int mtk_phy_led_hw_ctrl_set(struct phy_device *phydev, u8 index,
 		}
 	}
 
-	if (blink || on)
-		set_bit(bit_netdev, &priv->led_state);
-	else
-		clear_bit(bit_netdev, &priv->led_state);
+	assign_bit(bit_netdev, &priv->led_state, blink || on);
 
 	ret = phy_modify_mmd(phydev, MDIO_MMD_VEND2, index ?
 			     MTK_PHY_LED1_ON_CTRL : MTK_PHY_LED0_ON_CTRL,
diff --git a/drivers/net/wireless/ath/ath10k/debug.c b/drivers/net/wireless/ath/ath10k/debug.c
index fb61e53ff4c3..e11eb7a6cdf2 100644
--- a/drivers/net/wireless/ath/ath10k/debug.c
+++ b/drivers/net/wireless/ath/ath10k/debug.c
@@ -2004,10 +2004,7 @@ static ssize_t ath10k_write_btcoex(struct file *file,
 		ath10k_core_start_recovery(ar);
 	}
 
-	if (val)
-		set_bit(ATH10K_FLAG_BTCOEX, &ar->dev_flags);
-	else
-		clear_bit(ATH10K_FLAG_BTCOEX, &ar->dev_flags);
+	assign_bit(ATH10K_FLAG_BTCOEX, &ar->dev_flags, val);
 
 	ret = count;
 
@@ -2118,10 +2115,7 @@ static ssize_t ath10k_write_peer_stats(struct file *file,
 		goto exit;
 	}
 
-	if (val)
-		set_bit(ATH10K_FLAG_PEER_STATS, &ar->dev_flags);
-	else
-		clear_bit(ATH10K_FLAG_PEER_STATS, &ar->dev_flags);
+	assign_bit(ATH10K_FLAG_PEER_STATS, &ar->dev_flags, val);
 
 	ath10k_info(ar, "restarting firmware due to Peer stats change");
 
diff --git a/drivers/net/wireless/ath/ath10k/snoc.c b/drivers/net/wireless/ath/ath10k/snoc.c
index 8de133fe2a72..8f171ab6f4de 100644
--- a/drivers/net/wireless/ath/ath10k/snoc.c
+++ b/drivers/net/wireless/ath/ath10k/snoc.c
@@ -1532,10 +1532,8 @@ static int ath10k_snoc_modem_notify(struct notifier_block *nb, unsigned long act
 	case QCOM_SSR_BEFORE_SHUTDOWN:
 		ath10k_dbg(ar, ATH10K_DBG_SNOC, "received modem %s event\n",
 			   notify_data->crashed ? "crashed" : "stopping");
-		if (!notify_data->crashed)
-			set_bit(ATH10K_SNOC_FLAG_MODEM_STOPPED, &ar_snoc->flags);
-		else
-			clear_bit(ATH10K_SNOC_FLAG_MODEM_STOPPED, &ar_snoc->flags);
+		assign_bit(ATH10K_SNOC_FLAG_MODEM_STOPPED, &ar_snoc->flags,
+			   !notify_data->crashed);
 		break;
 
 	case QCOM_SSR_AFTER_SHUTDOWN:
diff --git a/drivers/net/wireless/ath/ath11k/htc.c b/drivers/net/wireless/ath/ath11k/htc.c
index 5f9ee5e633da..07fc959ed74c 100644
--- a/drivers/net/wireless/ath/ath11k/htc.c
+++ b/drivers/net/wireless/ath/ath11k/htc.c
@@ -244,10 +244,7 @@ static void ath11k_htc_suspend_complete(struct ath11k_base *ab, bool ack)
 {
 	ath11k_dbg(ab, ATH11K_DBG_BOOT, "suspend complete %d\n", ack);
 
-	if (ack)
-		set_bit(ATH11K_FLAG_HTC_SUSPEND_COMPLETE, &ab->dev_flags);
-	else
-		clear_bit(ATH11K_FLAG_HTC_SUSPEND_COMPLETE, &ab->dev_flags);
+	assign_bit(ATH11K_FLAG_HTC_SUSPEND_COMPLETE, &ab->dev_flags, ack);
 
 	complete(&ab->htc_suspend);
 }
diff --git a/drivers/net/wireless/ath/ath12k/htc.c b/drivers/net/wireless/ath/ath12k/htc.c
index 92138caa2a82..7227bed91ade 100644
--- a/drivers/net/wireless/ath/ath12k/htc.c
+++ b/drivers/net/wireless/ath/ath12k/htc.c
@@ -236,10 +236,7 @@ static void ath12k_htc_suspend_complete(struct ath12k_base *ab, bool ack)
 {
 	ath12k_dbg(ab, ATH12K_DBG_BOOT, "boot suspend complete %d\n", ack);
 
-	if (ack)
-		set_bit(ATH12K_FLAG_HTC_SUSPEND_COMPLETE, &ab->dev_flags);
-	else
-		clear_bit(ATH12K_FLAG_HTC_SUSPEND_COMPLETE, &ab->dev_flags);
+	assign_bit(ATH12K_FLAG_HTC_SUSPEND_COMPLETE, &ab->dev_flags, ack);
 
 	complete(&ab->htc_suspend);
 }
diff --git a/drivers/net/wireless/ath/ath9k/ar9003_calib.c b/drivers/net/wireless/ath/ath9k/ar9003_calib.c
index 2224cb74b1d4..5ea18c87e12e 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_calib.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_calib.c
@@ -968,10 +968,7 @@ static void ar9003_hw_tx_iq_cal_outlier_detection(struct ath_hw *ah,
 		      AR_PHY_RX_IQCAL_CORR_B0_LOOPBACK_IQCORR_EN, 0x1);
 
 	if (caldata) {
-		if (is_reusable)
-			set_bit(TXIQCAL_DONE, &caldata->cal_flags);
-		else
-			clear_bit(TXIQCAL_DONE, &caldata->cal_flags);
+		assign_bit(TXIQCAL_DONE, &caldata->cal_flags, is_reusable);
 	}
 
 	return;
diff --git a/drivers/net/wireless/ath/ath9k/mci.c b/drivers/net/wireless/ath/ath9k/mci.c
index f82bb2349928..62ad761d6a76 100644
--- a/drivers/net/wireless/ath/ath9k/mci.c
+++ b/drivers/net/wireless/ath/ath9k/mci.c
@@ -348,10 +348,7 @@ static u8 ath_mci_process_status(struct ath_softc *sc,
 	if (status->conn_handle >= ATH_MCI_MAX_PROFILE)
 		return 0;
 
-	if (status->is_critical)
-		__set_bit(status->conn_handle, mci->status);
-	else
-		__clear_bit(status->conn_handle, mci->status);
+	__assign_bit(status->conn_handle, mci->status, status->is_critical);
 
 	mci->num_mgmt = 0;
 	do {
diff --git a/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.c b/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.c
index 2f925d22b9aa..2c49f3b493bd 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.c
@@ -2034,10 +2034,7 @@ int mt76_connac_mcu_sched_scan_enable(struct mt76_phy *phy,
 		.active = !enable,
 	};
 
-	if (enable)
-		set_bit(MT76_HW_SCHED_SCANNING, &phy->state);
-	else
-		clear_bit(MT76_HW_SCHED_SCANNING, &phy->state);
+	assign_bit(MT76_HW_SCHED_SCANNING, &phy->state, enable);
 
 	return mt76_mcu_send_msg(phy->dev, MCU_CE_CMD(SCHED_SCAN_ENABLE),
 				 &req, sizeof(req), false);
diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c
index fa29c486a455..aeb017516186 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c
@@ -3467,10 +3467,7 @@ mt7925_mcu_sched_scan_enable(struct mt76_phy *phy,
 	req = (struct scan_sched_enable *)tlv;
 	req->active = !enable;
 
-	if (enable)
-		set_bit(MT76_HW_SCHED_SCANNING, &phy->state);
-	else
-		clear_bit(MT76_HW_SCHED_SCANNING, &phy->state);
+	assign_bit(MT76_HW_SCHED_SCANNING, &phy->state, enable);
 
 	return mt76_mcu_skb_send_msg(mdev, skb, MCU_UNI_CMD(SCAN_REQ),
 				     true);
diff --git a/drivers/net/wireless/realtek/rtw88/debug.c b/drivers/net/wireless/realtek/rtw88/debug.c
index b67d69b01f87..3a10f1bbe0e0 100644
--- a/drivers/net/wireless/realtek/rtw88/debug.c
+++ b/drivers/net/wireless/realtek/rtw88/debug.c
@@ -1051,10 +1051,7 @@ static ssize_t rtw_debugfs_set_force_lowest_basic_rate(struct file *filp,
 	if (err)
 		return err;
 
-	if (input)
-		set_bit(RTW_FLAG_FORCE_LOWEST_RATE, rtwdev->flags);
-	else
-		clear_bit(RTW_FLAG_FORCE_LOWEST_RATE, rtwdev->flags);
+	assign_bit(RTW_FLAG_FORCE_LOWEST_RATE, rtwdev->flags, input);
 
 	return count;
 }
diff --git a/drivers/net/wireless/realtek/rtw89/core.c b/drivers/net/wireless/realtek/rtw89/core.c
index 454d876aeb88..dacc2d889a46 100644
--- a/drivers/net/wireless/realtek/rtw89/core.c
+++ b/drivers/net/wireless/realtek/rtw89/core.c
@@ -7365,10 +7365,7 @@ void rtw89_core_rfkill_poll(struct rtw89_dev *rtwdev, bool force)
 	rtw89_info(rtwdev, "rfkill hardware state changed to %s\n",
 		   str_enable_disable(!blocked));
 
-	if (blocked)
-		set_bit(RTW89_FLAG_HW_RFKILL_STATE, rtwdev->flags);
-	else
-		clear_bit(RTW89_FLAG_HW_RFKILL_STATE, rtwdev->flags);
+	assign_bit(RTW89_FLAG_HW_RFKILL_STATE, rtwdev->flags, blocked);
 
 	wiphy_rfkill_set_hw_state(rtwdev->hw->wiphy, blocked);
 }
diff --git a/drivers/net/wireless/realtek/rtw89/mac.c b/drivers/net/wireless/realtek/rtw89/mac.c
index df396fbfca26..68da8908f14c 100644
--- a/drivers/net/wireless/realtek/rtw89/mac.c
+++ b/drivers/net/wireless/realtek/rtw89/mac.c
@@ -6046,10 +6046,7 @@ rtw89_mac_c2h_pwr_int_notify(struct rtw89_dev *rtwdev, struct sk_buff *skb, u32
 		goto out;
 
 	rtwsta = rtwsta_link->rtwsta;
-	if (ps)
-		set_bit(RTW89_REMOTE_STA_IN_PS, rtwsta->flags);
-	else
-		clear_bit(RTW89_REMOTE_STA_IN_PS, rtwsta->flags);
+	assign_bit(RTW89_REMOTE_STA_IN_PS, rtwsta->flags, ps);
 
 	sta = rtwsta_to_sta(rtwsta);
 	ieee80211_sta_ps_transition(sta, ps);
@@ -7004,10 +7001,7 @@ void rtw89_mac_bf_monitor_calc(struct rtw89_dev *rtwdev,
 					  &data);
 
 	rtw89_debug(rtwdev, RTW89_DBG_BF, "bfee STA count=%d\n", data.count);
-	if (data.count)
-		set_bit(RTW89_FLAG_BFEE_MON, rtwdev->flags);
-	else
-		clear_bit(RTW89_FLAG_BFEE_MON, rtwdev->flags);
+	assign_bit(RTW89_FLAG_BFEE_MON, rtwdev->flags, data.count);
 }
 
 void _rtw89_mac_bf_monitor_track(struct rtw89_dev *rtwdev)
diff --git a/drivers/net/wireless/realtek/rtw89/regd.c b/drivers/net/wireless/realtek/rtw89/regd.c
index 14fab6b1a74a..b9a5ce218b1d 100644
--- a/drivers/net/wireless/realtek/rtw89/regd.c
+++ b/drivers/net/wireless/realtek/rtw89/regd.c
@@ -421,10 +421,7 @@ static void __rtw89_regd_setup_policy_6ghz(struct rtw89_dev *rtwdev, bool block,
 		return;
 	}
 
-	if (block)
-		set_bit(index, regulatory->block_6ghz);
-	else
-		clear_bit(index, regulatory->block_6ghz);
+	assign_bit(index, regulatory->block_6ghz, block);
 }
 
 static void rtw89_regd_setup_policy_6ghz(struct rtw89_dev *rtwdev)
diff --git a/drivers/net/wireless/ti/wlcore/rx.c b/drivers/net/wireless/ti/wlcore/rx.c
index 307fab21050b..4d6f5a047782 100644
--- a/drivers/net/wireless/ti/wlcore/rx.c
+++ b/drivers/net/wireless/ti/wlcore/rx.c
@@ -316,10 +316,7 @@ int wl1271_rx_filter_enable(struct wl1271 *wl,
 		return ret;
 	}
 
-	if (enable)
-		__set_bit(index, wl->rx_filter_enabled);
-	else
-		__clear_bit(index, wl->rx_filter_enabled);
+	__assign_bit(index, wl->rx_filter_enabled, enable);
 
 	return 0;
 }

---
base-commit: 0d9d0dbf2fddcff5859d623e90ca73c4054276e1
change-id: 20260917-net-assign-bit-81f950e23f6a

Best regards,
--  
Peng Fan <peng.fan@nxp.com>

