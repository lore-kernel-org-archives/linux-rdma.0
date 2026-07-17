Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11022118.outbound.protection.outlook.com [40.93.195.118])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAFC13750C4
	for <linux-rdma@vger.kernel.org>; Fri, 17 Jul 2026 03:20:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.195.118
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784258455; cv=fail; b=HhoPe+vPY0hKwqCthOjKtmFl3/vgBNy9H/JEUb5Tlvoz9YaGMgYWnlrd4bp3R7nkxsEwuerB/KLqt2dRbhfTo84kwuHEMJagOiOtj+7QqKdeeW8xfotUaZEdU9w0V9qlSxR3auW+/9lfPW4MDEy6vdraz/GKIs8mMWBN/R319P4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784258455; c=relaxed/simple;
	bh=9kakPyOAJMM5MvBJOWLONN9g3amIu7Yowafzz0w6Gf4=;
	h=From:To:Cc:Subject:Date:Message-Id:Content-Type:MIME-Version; b=QbaUVI6saNYdG3j5B+v076jhe1/huvFhJFs3vCCQqbxH6+UDJZW6tEU0WG5id+eIEdThuYSwqHeQ4nVYeJIPIsQ3eUGeIh7uOP+4CDg3aROIDB7bHu2u0jVQotaF0/Q36+1I5BCR+7fM7lYkiPTykVI3HFM54qdQlJ09XJvDIOQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=thelustrecollective.com; spf=pass smtp.mailfrom=thelustrecollective.com; dkim=pass (2048-bit key) header.d=thelustrecollective.com header.i=@thelustrecollective.com header.b=mWiuUOh3; arc=fail smtp.client-ip=40.93.195.118
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=thelustrecollective.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=thelustrecollective.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=thelustrecollective.com header.i=@thelustrecollective.com header.b="mWiuUOh3"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BLxSzdEEwUXQocFNIsSo/Qm/vF6ZDVjQhkraJnURcxRfibCEWPI5Y9E4PO08x5jvYzQvUdcYlje9tng926yjnt9ALy3x183JpqHNjtBAJw+Ee1cvMttHBX/H/kzk5Ho03AbCqSpIfTjAlKz6jlmLyDG778VERSfR7ZQlV9D11qhKUmpsK9Ob5LElQ8HmfVnFYsF204XSxjmYA+5wt1vuocRk/kOxC1A5hGJ6Qxh804K1Fivv0tL73DsrEOI7Eic82lealc074csA0tiryaXmSJPk1uPJ67z7/V1epe8YEYvnU3OLtlsgMVq1X0z9umpfI6t1/FG44F41QRiz52UdWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/ERngahaR72Rq1q61DwU2JCiVnb6+TqDSEd+gCw8Es0=;
 b=gTsRMZA+5ELFMuezxpYqlIkzgaObE7VyhxyaJLBrzo9vIvSP9NlqtedTE4COlazKI3EQvJLr3uO5d1oXQJnT8zdlzGJPQFz7SrksknATVtjYM4pZ+usb7t9yteUCXD2nfb4Qa+rxIEqXcvwBV6zzo5a3pShxlhxcilLcyYZdmRyhvNxzmLpp903zaUF9Q1/49O31Tx8RAhzw9v4CNq7nEf01YPu/s+or64harc1ZO3Pepa/NaQtADzCPkgxsfI7JhtT0mJM/eJdLZsKFMTezI3Uy2KqumD/hdorYWwAgvP80+g3Qg8q2fkkiRvq/GPZmdq++fzgoRHJQKCj/i8djdQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=thelustrecollective.com; dmarc=pass action=none
 header.from=thelustrecollective.com; dkim=pass
 header.d=thelustrecollective.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=thelustrecollective.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/ERngahaR72Rq1q61DwU2JCiVnb6+TqDSEd+gCw8Es0=;
 b=mWiuUOh3MnbvA3Up0eIAoIHTjWkYjFEl65aCylcYq/ZW8QxhKbhrJpgSsstZCtkEHXLuhNCuAeQ2iSXuAtO0qWEMCmHNc+dh49cRk3tJWl0kA6IW0UnybMRFswXM5LMtnOWbZkZgSZDp7pukDFOI/hw1itcaq5qVAU2xmIv0dZk1kWYIlYVNr0qvSGVqBG2WLiA5SRulwf62MSTlTIUDKg/qA/gJCISr3REr7kGNxHymfmFuQO3v22I/8a/5MyA+2k7CDyyQWnVptZaaMlyAPt2nzdKS6OMixPXRQ9nywyxRQ/K/vxELyI0DM+Lam78BcqbCVB0FWSpbekD6LRl3Vw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=thelustrecollective.com;
Received: from DM6PR04MB4682.namprd04.prod.outlook.com (2603:10b6:5:24::20) by
 DM8PR04MB7992.namprd04.prod.outlook.com (2603:10b6:8:7::17) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.223.12; Fri, 17 Jul 2026 03:20:47 +0000
Received: from DM6PR04MB4682.namprd04.prod.outlook.com
 ([fe80::fa5e:6e7f:2655:bfee]) by DM6PR04MB4682.namprd04.prod.outlook.com
 ([fe80::fa5e:6e7f:2655:bfee%3]) with mapi id 15.21.0223.008; Fri, 17 Jul 2026
 03:20:46 +0000
From: Timothy Day <timday@thelustrecollective.com>
To: Michael Margolin <mrgolin@amazon.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>,
	linux-rdma@vger.kernel.org
Cc: Gal Pressman <gal.pressman@linux.dev>,
	Yossi Leybovich <sleybo@amazon.com>,
	Marco Elver <elver@google.com>,
	Timothy Day <timday@thelustrecollective.com>
Subject: [PATCH v1 0/5] Support Clang context analysis for RDMA/efa
Date: Thu, 16 Jul 2026 23:16:53 -0400
Message-Id: <20260717031658.477397-1-timday@thelustrecollective.com>
X-Mailer: git-send-email 2.39.5
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR08CA0010.namprd08.prod.outlook.com
 (2603:10b6:208:239::15) To DM6PR04MB4682.namprd04.prod.outlook.com
 (2603:10b6:5:24::20)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR04MB4682:EE_|DM8PR04MB7992:EE_
X-MS-Office365-Filtering-Correlation-Id: 4e686465-a634-42a7-70cc-08dee3b26440
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|23010399003|376014|18002099003|56012099006|10067099003;
X-Microsoft-Antispam-Message-Info:
	6sX9LSG8eCghBq4RhubG9fSB+07MSVt37xm+AWPjj+/uLa2meAkDKnXfYzbLe3D6S2ToQBR1vch+9pAG1arxUk1FNSKZf5SxZ1HRIbsNreGbKdOdcREZm84hf37yd1H1R9kquYy9+jEoBSYo3EU7WmL4VpfL6hy/m2caRZBLHdH9WrZIIyaey8lYVTQKyQvYTg7jljueY9EZ16BDXi3/O41TlzT9counhcHxrfs7mYPVkOmVFxzVe83n6c+ZChM/s4vyc0duWcE4s6F5L71Qf/ECTViOfqso6JRuxsW6mHuBUimcLKIQKi4074xBhmymCfSQ2hMjv7zA896R9HVkXY5k64C4OKOCUsa52QssVRv0/cWKs1ATiKHxhmOxRgDneMm3j3Og6mHk7WtJR1/1+BJArm2r7H3DqjGmGebvmpR9HbT1GuiLilnZPbbKFQpDXtIJwF0djkbWa13KJBgTEBpH+RBLa/Z+tArIPOip4LXZ6llQpmfzK0CKwAL2RtdEU2cDGjukbFMWDuGdvT/VOZ1vz86UxRG0L8dqBYeoOCfHsJLoHS4Zr09vPZf2wrtyYoUOIqoOz2zYD2ErM1W042YkZjqYCp8D8km2ZonWbd3URpRzHZGV4KhL1GUMCkOU2ZzRis4GYk8Ds+roHE6TCWVrOLZ+IPO9fh0wOJRVtsA=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB4682.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(23010399003)(376014)(18002099003)(56012099006)(10067099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?mM6EtWKBgl7NoGQtTtPNC5+3aJeN+NE8YnQNL5LDoDbf+hvmkiDhTuf2XRg/?=
 =?us-ascii?Q?02B8coRPAeVNBcIuDfuyISY2O38FdChvBMHJVcUbOMImGISQxQvHkzfOAmsl?=
 =?us-ascii?Q?hdCF/DnCFytzxDIrh3tM+KG9VBX0N7PvEOZi7fJ6qnU7AF9iXSdfpXGpo3Ng?=
 =?us-ascii?Q?bC+j0gHpSaZwJ4gCU3jSMzv9FeOpOULLsFne0bF9dR9Huicc84p6a6tohCnF?=
 =?us-ascii?Q?nXqvHNlQP2NXWdeEJEup6BWaDFewNcJcFaja/3BnBSFrYc0wB/1xfZRc96Bt?=
 =?us-ascii?Q?fg+NwRzcdvKm1rk46G79pXf6CpK1/8553vTEqQSYe0CcwxReGTazHAgzX1UH?=
 =?us-ascii?Q?lH4phxAbHLRee+F/yFs5iEgAQ+jESenzl8/CZQSDKJAAht7rOcCS59itoFBu?=
 =?us-ascii?Q?pbsT3rZqWCQzqwAe0/RyiAlTrvkQMo7OqEzbGBfcMQzgSbseCUd5Gz2bFlAW?=
 =?us-ascii?Q?5EvPxtKED8PmOYK3fDES4ktZeUuPlNhcFuN+TyMIox33BHVcJ6SUocMp19tQ?=
 =?us-ascii?Q?2D3CrPCnsa8ycZ2dJbnFiY3UU5KfD6zVbSBAVvpy309zsxkgTILKkcF3UJTk?=
 =?us-ascii?Q?9dj6C2ULX/Z007Hm7YLFGnG8yv+Va/q5KuwEouesNaoDoo4wUrhHxGwpNdk4?=
 =?us-ascii?Q?VS55NSqIiXerVKHUo77LpH/kEk0lMGw25CJNghtbGzT4JiMR7A7VIhn65tvz?=
 =?us-ascii?Q?1Lp0KjmgGLJH3AynNlVqHglYFBvKVOzdgF8nV17ikih+U9+N34HCbIbJitmX?=
 =?us-ascii?Q?9mvkfLNtzRVkIiVUUWO7weF7GFw0/AOAYLwf13wWzYEmnc0DiFf6L2jaf0S/?=
 =?us-ascii?Q?KWVkkPhI/4ZLfCmgnP+q+XyOtRs04PJvU93FMbscyfAC6Y41Gz0RV6OfLjsO?=
 =?us-ascii?Q?MxtL9Wd8BqOtW81D0X+ndIYjY0BlT2PeldP7Y8O6gbtjaFT/sYA15neiRyQ2?=
 =?us-ascii?Q?WHO1Ua335QXFlBaEJeEaK6ZwjYEtZAH1ZSsFaf35robyfge/7jJd5Kq8LCm/?=
 =?us-ascii?Q?AnUZzLIMKTPy0zjd/DoliziAaRu0ThIm7SOY27GztsOqeXIAit6Fib4smSow?=
 =?us-ascii?Q?3qfAKYQ+e4HnLB0D2sm1tv1NFgdvxZ3AIPJjvd6UUv6Aab792Xg60h2tI6Bh?=
 =?us-ascii?Q?EqGTArWHbFtzhcE9k2E3i8kdV7GZm6hR9HtSMTwpBtQoHSnmJ5eKVE1PjKoJ?=
 =?us-ascii?Q?meSEiSMREBS2MvaUY7Xpvw1FLMhFe5Ms2z9w+B9VADuaORbLlgDUHyXErwgW?=
 =?us-ascii?Q?esi/77kIkM0bHBNjYdEO6BAjAxKjpLDJ8E1ogZR5PFbFtVR4GKxPaXU8u/3g?=
 =?us-ascii?Q?PA3jf0LBy2QAx3ZEs4eyli6PKH1zND1x5pDTIvYpPEkrQFk0aq1lZDgTrC0R?=
 =?us-ascii?Q?b5hjDKO8hwCPpWkXhtNC9IQOwsWFxMEBfIIBnepWw4rcTF8H69Oh+yx1CIoO?=
 =?us-ascii?Q?gjMaTzlhQrJmf0upD8KX/qHf08zIyOE19ogmZhbtfNs0g6AI4SROMdYoyTc6?=
 =?us-ascii?Q?DE6TSM6eWZZ0lJdzkSVl5DKr/q4EafmUU7Kh3zuJimx4seIhIVoo+HM7zDYa?=
 =?us-ascii?Q?ifzDa5qQh3vlrxOzHoxjon34T/CGUzWM65RWZXDy2oCc8UMD8WPmtbJvIPTA?=
 =?us-ascii?Q?9zZ5nL3jcem0+BQahOz91715KEBTsJUuz7AULZA1vs+qMF30E5TfZxVgO0GE?=
 =?us-ascii?Q?ABRVWpYN3J/EbJtdab5WLrH23f14Pz1HfLkd9tpV7A8Xq8BX3ajyPQkcagGg?=
 =?us-ascii?Q?tQZXFIW7nNieAZrjB4fh8HraU24d2QQ=3D?=
X-OriginatorOrg: thelustrecollective.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4e686465-a634-42a7-70cc-08dee3b26440
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB4682.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jul 2026 03:20:46.0255
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4c9dec06-8f2c-4233-98d5-ca3cb36218fc
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: the4tHTZx0X46CqS+cSLqGfySZyXZrdbZo/qu4giWwhOfqlJTptVl6EIlmi+GVzXQK6oYwGYQyx76qcWUjiiL8nddpQzs3gloWIwz1NowZI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM8PR04MB7992

Hi,

This series adds annotations for Clang's context analysis to the
RDMA/efa driver.

Clang context analysis was recently added in a series by Marco
Elver [1]. This allows the compiler to validate different
locking patterns at compile time. This series enables context
analysis and adds new annotations.

The series was built with Clang 23 (since the minimum Clang
version for this feature was recently bumped to 23 in 7.2+ [2])
with CONFIG_WARN_CONTEXT_ANALYSIS enabled. I based this series
on rdma/for-next.

I'd appreciate reviews and suggestions. I'm especially interested
in suggestions on how we can make this easier to enable in other
parts of the rdma subsystem.

Thanks!

[1] https://lore.kernel.org/lkml/20251219154418.3592607-1-elver@google.com/
[2] https://lore.kernel.org/all/20260515124426.2227783-1-elver@google.com/

Timothy Day (5):
  RDMA/efa: mark mmio_read seq_num as guarded by mmio_read lock
  RDMA/efa: mark comp_ctx_pool* as guarded by comp_ctx_lock
  RDMA/efa: mark admin CQ consumer state as guarded by the ACQ lock
  RDMA/efa: mark admin SQ producer state as guarded by the ASQ lock
  RDMA/efa: enable context analysis support for efa driver

 drivers/infiniband/hw/efa/Makefile  |  2 ++
 drivers/infiniband/hw/efa/efa_com.c | 33 +++++++++++++++++------------
 drivers/infiniband/hw/efa/efa_com.h | 14 ++++++------
 3 files changed, 29 insertions(+), 20 deletions(-)

-- 
2.39.5

