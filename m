Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.196.55
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795198438;
	b=F/eE43EYkNwcOWHIyLLeKqdE+FU2T+j6aXRKt4TmSqVUCE/yhy1CWswARS7FN1lFOI8c
	 7fbAu6raraBqB4dKj7AN9EBqHQcCTi5Lzi5G+uQQthvHutwsQOramzK0+P/hwbYppGslk
	 KtU4lb6QasKXsh30Xp+7dRNankZSNRVk+m/BcddSJSZor5dJY0bDMDwiOBE87P/EvDmu/
	 8X3WvxN6kX/HQ2Yo4eRp58GRXNfvgit9BH2cyBEVTU9zIOuYUKoG0XMLVQRsDvLmAIk1p
	 fRx525hVW1WxF+QOPRTylp/7LJckKZC59W49O8GyN8Jqyt/HewLr+AVJNGKEHi2FBwQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795198438;
	h=DMARC-Filter:DKIM-Signature:Received:Received:Date:From:To:Cc:
	 Subject:Message-ID:Content-Type:Content-Disposition:X-ClientProxiedBy:
	 MIME-Version:X-MS-PublicTrafficType:X-MS-TrafficTypeDiagnostic:
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
	bh=1j1cnNk37GdQOhAHo+WMH9aS1/oxZmALWnH76+TVbwI=;
	b=ibS7ALFH04/z326HmORzq2/4Q4pfnqLh794ArYmUyXZPMYs1IuvzbgejAxT/euwigOns
	 WrZcrA7LwHyOhwvT5l+BDJ+UjEfRS4dCBBaKK/wAc7+Spl9SODJxbenn6t/GvuKeSVmbz
	 Og7aw+KU9GUyDef3tLq7UDjhlezbqqK/BUabtiWOdp5iGUmhTdiNbCm+LufX84epUrGHw
	 xybvKKHQrwT11ydUieAUaOTzaC65U8n4xie9Uu+nznCCaKlOekL/LXQe04wyrex1A4tg2
	 xRsXHYRHMQq/vTqE8igfRa4Y78qq1vNEt8UTSUTTmXBUhiu0vs7RCSy/Q3jyy/1Yldw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=Ah8U0ASo;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.196.55
Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013055.outbound.protection.outlook.com [40.93.196.55])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B183606C6D5;
	Fri, 20 Nov 2026 18:13:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2B183606C6D5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=Ah8U0ASo
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Xayd6SSmQIC5lCKrjd+kFt5xG9/PayY/iqC+lbYNlKSNnl2Rh7T0QSpzwiRw8g/aWdpr7kURlBzrP1Fi+bHGpoLf6uhGmmhqDoFtm/yIXb+JC+vnRbYf4cUCSUBsEqtpUTsmsWEgBAjrEmoq6u5cV/I9ZgLJOh5hdIjsy6OoBNEPb9wqqYmwXuiczMFrJuV4/YfalT57UPrRks3if1mKr9SSOH+I5zRe/2DDvkcTuhv7vDzIyHy4l8DqfF0x2rgoc/rMe3w/+XKdAgldBMLLeq5e5O+WyMQaNlxsiSCp1naxRuku/ZLxyAbK5amQAbFIFrDP5Ll+U8X+mkuh6k95mA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1j1cnNk37GdQOhAHo+WMH9aS1/oxZmALWnH76+TVbwI=;
 b=ZowoXckV1PxbkG024a6qr6wyIf6/VypbscEE+eH3jGOBEzG0t+XaGdzNibAjppLzdqXRciJ7GEr5QdiCU91A3ByjhcqnSiIlgo4dJgtgeYyBab6m0TjWO5k3nVGHB1kLM0fcMXd3W2LmYcCLmyY3mekStGCjiTwNZpOP7k605G2JdCHijTrUiTlVr5hWARa0j7YYMZavlzQFkH9gvRkM8Gx9ff1D8a77t1ilAMjcqxhaxzJ8vMHkG8GKuvv18yw5snuaVTWpM9HMT6KojzQVGN1ktPjYkH671y0U+Ya9de4vpXp24COgukIGXMMUr0aaFXvi4dinBUyqR3Btave5eA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1j1cnNk37GdQOhAHo+WMH9aS1/oxZmALWnH76+TVbwI=;
 b=Ah8U0ASoVUnILcU7Mxt1RoUJ/KCk8tzAqAYLz9G2int1HSMGZHxb1bBtcW6HmPUX4LdMuXDGiiV654ITmjW5Nmr0MoI9AFdPlGdUoIPw6j5tl/qq5qkB/idGoYq8lom8LywznsMk7wK4zDUhPKNowzZ5E29ehZQEgED3tAx/FgERUsm4j3w6cJDkXqO7iXrgmViU9LPkWZ30PofHctB3JtAzlgnBWlqty0sOU9eW1hbQDr5Ujx+CRlxanC1uDKMorZL922EsT5l50zo6uqHsnldbSJ9k07Y1GJ/M0/Z2bSK9FqcJ8WlfpQ4jwmukffqGqrGFGgCakF2AGDXHPqf/9w==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12) by PH7PR12MB7210.namprd12.prod.outlook.com
 (2603:10b6:510:205::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.13; Fri, 20 Nov
 2026 18:13:53 +0000
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d]) by CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d%6]) with mapi id 15.21.0639.010; Fri, 20 Nov 2026
 18:13:53 +0000
Date: Fri, 20 Nov 2026 14:13:51 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
	Leon Romanovsky <leonro@nvidia.com>
Subject: [GIT PULL] Please pull RDMA subsystem changes
Message-ID: <20261120181351.GA1094775@nvidia.com>
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="HMV4ZkDnUBmDuVbD"
Content-Disposition: inline
X-ClientProxiedBy: BN9PR03CA0486.namprd03.prod.outlook.com
 (2603:10b6:408:130::11) To CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12)
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
X-MS-TrafficTypeDiagnostic: CHBPR12MB731189:EE_|PH7PR12MB7210:EE_
X-MS-Office365-Filtering-Correlation-Id: 05752562-4776-433a-842e-08df473208ab
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|23010399003|376014|1800799024|261021135927099003|10067099003|261022075727099003|261021123027099003|56012099006|11063799006|261028144727099003|261102123227099003|261026140227099003|261021121427099003|261022105027099003|261026121527099003|261009223027099003|18002099003|6133799003|261009221227099003;
X-Microsoft-Antispam-Message-Info:
	id0NV0BPFR1QyNhKCzeqF4YfEc1u7p0OS6ey2K2yLiamH26j5ckPJH+XfWsqgEjZfYa8qWXxP+pN+1pS6r6nckWjijRvl9kgzUqRMt7VSpYyAK5MmousPKODgFw9TaHU4qYZYnBDgE5XdqZ/HUas5wlWCowXgrj0tZOM0U3ECk7dCM2YIBdWFCbnSxiEIma6IqPrpsXDBN7QuN4NlMu8L3mELJ3pqe2dFPh7S+BIm48Och3YLFZJjCdJuBbpSZj1DukWEGf2g7ZjMEYezmtwzJM0sBzAPwvymLtrUqlKcdzCnn+9gunp1AqujLdUJAZA0CBalXOCcoG4DsPtyGmaWmIIzvwVzdReLbE7hXzoFqvKW3q+KjFe8fsl6phludiwnusoRu2cjHD+u3WLxWj5CvF3v0Eqef+aHI6GxxfYg9ZYslNiV5TTEA/0wrgMO8xXHGXSww8WcCkVfGg//Xy71BssZeCs6zd9rqYPA0/1B/c19LqKrq9Rq77wQp9WMnQJ/efLuG0YOzTSL4yJJydufeQh2M7Y9UMIXBe07MWLb5090peDjXiU+GNtsT/e5vgTH8n/QV0R2PjQ+LVZwNAO0/M5L8rKrPawvHVnxB8zRtmXI0c3Hsyo2eqpK8RxnQKXG1BUgZ2vsTOLCRYxFmq90XSM9RMSqATCp47uH7bBAu4=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CHBPR12MB731189.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(376014)(1800799024)(261021135927099003)(10067099003)(261022075727099003)(261021123027099003)(56012099006)(11063799006)(261028144727099003)(261102123227099003)(261026140227099003)(261021121427099003)(261022105027099003)(261026121527099003)(261009223027099003)(18002099003)(6133799003)(261009221227099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?KPf2anUbSYYtGNzQDueN4CjVJdlW0S/aGTS7bhEAxFb5FtklBdXduiFHV8dc?=
 =?us-ascii?Q?eKLAqFTPQSdCB60o0yGMEwZcnOUJuPI4dtkepZP4PDz1R/52BR0nr/WLmAzI?=
 =?us-ascii?Q?uwb7QO2uriJGN93nphDhu9LbS11Jz9BT6vypnjU5U+N0wWHTTW+IUAia6jHk?=
 =?us-ascii?Q?L0D/AHRmSdzUM7bnKDeOqzJK/z/9rymFdsmnBscSQlyR9xm8iY6g18oDHFf/?=
 =?us-ascii?Q?rA4O/f0riB5j/p1RtwM/k+NU2INM975XvAP9cn8VHOO8DP6XFENlfC2Tdo9X?=
 =?us-ascii?Q?RA1yVQ+NNA+0KRwdEo+E/e9287c2CrrWyUw6L3RDoB8Zx4pktY40qwQ7Jyi7?=
 =?us-ascii?Q?h89HNXl7bJfld86wyejXtkPthxXRZAHDiDEKu0VSu3HiISdtI48oGMzR7ilq?=
 =?us-ascii?Q?I2Nc+geqi+1iSasnXLR4BgHzgJUA318Z1VN8Cl1bI1pWkuUVoz8JC5vFODjn?=
 =?us-ascii?Q?NE7i+rhO1xp876J/17beul2cDXtwkxgSAxzVgn21Aq4crjF8jxIU87Oc/U1W?=
 =?us-ascii?Q?IMNbMvvLk5YgLYTcA9L+dJMJnpHueUNYrlR5MXlVUnV0G9SJXgx1Fswi417B?=
 =?us-ascii?Q?X/W+/M9/Qbon9v5lsB8n/YzE61XTI8uJagpK0YhnwNJP4NLHOfmp4H5ftyrL?=
 =?us-ascii?Q?GgSJHJ4GHEv/X1npA+Gq13UXwnFQy7hD1HMmgFd7ur2ziZfCclFtkEhkyHVO?=
 =?us-ascii?Q?f95MjgEIvTxO3Je08nnL/JMuncZ5dWJKEAf5d+nynY+7d4DBjfDRI8F8s2vK?=
 =?us-ascii?Q?fUjTYkK5vVcr31SRV2C9QPIekS8kAscJxYjCxpRp7ahvBeykm9o64arDvN42?=
 =?us-ascii?Q?+c/i2hRYiVLk18qplpVXQH2kYKmgHrl0BWRu9pZlCJxGqpoR91BKk6TuPno6?=
 =?us-ascii?Q?soyLq7h+JmALmJlvF9Kzd9SQkV/1POSo5CNh/SxjvcBBxkOLlbQDTA2JU2Yd?=
 =?us-ascii?Q?8ehzqefJKIqh7Jx8hCWKQUsGcdp+XP5ZbopMyqf8oqI4YV9YutCM4jwTMFME?=
 =?us-ascii?Q?w72Ojv7LasG5RKagGWHCDWIZ9qktStywl41Uwb9TzwMoTg6Gv5k9BqDxWRxb?=
 =?us-ascii?Q?EyfwzIyoFsHjIMIO+02AzeH9lBmQn/Cxsqokd962iR0XQvED6N2Y3s3Rgd9U?=
 =?us-ascii?Q?ecJOG8xZe2ktCvWbfF67Y1y/1FTy4lyKkB/4bQvkKcUEdphJubtUUDVq54ln?=
 =?us-ascii?Q?dagFRezSa82+W9pXMT3Inq3QfI861wkNVOFQbGWKz0m7GO/qx1VbLlEfUvKc?=
 =?us-ascii?Q?z7V+DRiPiL4zGVv6nQmckIhSe2CMbGQwA1yiL8k+m21KOtDSXMcWtddHevYB?=
 =?us-ascii?Q?XhUSEBeTMzE0UzyTQnSiaSitqDYZvBWJROYHZGOWro+8ODoU+bWprnCpbm03?=
 =?us-ascii?Q?Z4b/wzfgOQCNhMUSBvlSJihJB4twJBwHBBkondZtm/gcOMNovA0H3gRc/ylT?=
 =?us-ascii?Q?pxvzWeRSfCZGA4QoU57K9cufFgnV3MamiPqkO2iBW9n1dgBdhUc+Ccsl1taW?=
 =?us-ascii?Q?xOyxc+96F1/mlBpSnaP/HQn010YXEG69MREExJA7RzzPABzTffWDkUe46cBU?=
 =?us-ascii?Q?XPJ0XoISSqotYcrYYazIuZQ17LhPH+bZLUGZhbzIQ62EEP2QBWW6QnEgu01h?=
 =?us-ascii?Q?ShKCPPiIevvsCrBXkr5R8NdDdBqiEFPJp7iS5MUwQ31beRCb+3rYvJuerZ8H?=
 =?us-ascii?Q?pCSM4zGyUQ/vmZU8m6Uyqbs4k2o3WRzP0V5vhLDUYOEnf1X9?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 05752562-4776-433a-842e-08df473208ab
X-MS-Exchange-CrossTenant-AuthSource: CHBPR12MB731189.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Nov 2026 18:13:53.0306
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pcQEqmdtekCs3WOuzARN0pEqwhf3MkYmR1lowVTIvLsnEJi0+iJvHycdCI1lsTZp
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7210

--HMV4ZkDnUBmDuVbD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Linus,

Usual mid-rc fixes for things that look more serious to us.

Thanks,
Jason

The following changes since commit 6628e7d4c6b25c8d18f1345e3a20d21829aae7e4:

  Linux 7.4-rc1 (2026-11-01 13:26:31 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rdma/rdma.git tags/for-linus

for you to fetch changes up to e7732ec135b501e87ab060d992b3b5f2ec4396c9:

  RDMA/mlx5: Skip vport context query on FW without ib_virt support (2026-1=
1-16 06:51:54 -0500)

----------------------------------------------------------------
RDMA v7.4 first rc pull

Usual set of bug fixes, many found by tools:

- Bound checks and counter widths in srpt for initiator controlled
  descriptor tables, out of bounds read and resource leaks are remote
  triggerable

- Use after free races in siw MR lookup and in the rtrs event handler
  error unwind

- Don't leak kernel heap memory to userspace through query_qp

- Several rereg_mr bugs in irdma and mlx4 leaving stale or revived MR
  state after a failure

- irdma FRWR and PBLE/AEQ setup was broken on PAGE_SIZE > 4K

- bnxt_re firmware command channel races around timeouts, duplicate
  and spurious completions, plus poll_cq and FRMR bounds fixes

- mlx5 regressions: probe failure on older FW without ib_virt, and DevX
  umem registration failing for page sizes >=3D 4G

- nldev replied with the wrong netlink command for STAT_DEL and
  PORT_GET

- Small fixes in ionic QID allocation, mthca, usnic and an mlx5 vport
  rep error unwind

- MAINTAINERS updates, including Jacob Moroni as irdma co-maintainer

----------------------------------------------------------------
Abhijit Gangurde (1):
      RDMA/ionic: Use a linear QID space when udma_shift is zero

Deep Shah (1):
      RDMA/siw: Fix use-after-free in siw_mem_id2obj()

Dezhen Lu (1):
      RDMA/mlx5: Fix DevX umem page size truncation for pages >=3D 4G

Jacob Moroni (6):
      RDMA/irdma: Fix FRWR logic for PAGE_SIZE > 4K
      RDMA/irdma: Fix paged PBLE and virtual AEQ for PAGE_SIZE > 4K
      RDMA/mlx4: Fix stale umem and MTT state after rereg_mr failures
      RDMA/irdma: Do not allow rereg_mr to revive defunct MRs
      RDMA/irdma: Do not change mr->pd in driver during rereg_mr
      MAINTAINERS: Add Jacob Moroni as irdma co-maintainer

Jaeyeong Lee (1):
      RDMA/rtrs: Register client event handler after capability check

Leon Romanovsky (4):
      RDMA: Rely on the generic Patchwork instance
      RDMA: Add missing UAPI files
      RDMA: Clean up the INFINIBAND subsystem entry
      RDMA: Remove pointless links

Moshe Shemesh (1):
      RDMA/mlx5: Skip vport context query on FW without ib_virt support

Nikolaos Gkarlis (2):
      RDMA/nldev: Reply to RDMA_NLDEV_CMD_PORT_GET with its own command
      RDMA/nldev: Reply to RDMA_NLDEV_CMD_STAT_DEL with its own command

Saravanan Vajravel (1):
      RDMA/bnxt_re: Drop RCFW completions for cookies with no outstanding c=
ommand

Selvin Xavier (7):
      RDMA/bnxt_re: Clear stale RCFW resp pointer when wait ends
      RDMA/bnxt_re: Honor a completion that races with a wait timeout
      RDMA/bnxt_re: Do not treat CQ error notification as a command complet=
ion
      RDMA/bnxt_re: Reset cqe pointer each poll_cq iteration
      RDMA/bnxt_re: Remove shared page mmap entry on alloc_ucontext failure
      RDMA/bnxt_re: Bound FRMR page list by max_num_sg
      RDMA/uverbs: Zero the QP attrs in ib_uverbs_query_qp

Serhat Kumral (1):
      RDMA/mthca: Fix off-by-one in mthca_map_user_db()

Shay Drory (1):
      RDMA/mlx5: Add missing error flow in mlx5_ib_set_vport_rep

Wang Haoran (1):
      IB/usnic: fix wild pointer dereference in usnic_ib_qp_grp_dump_rows()

Yehyeong Lee (3):
      RDMA/srpt: bound the indirect descriptor table to the IU
      RDMA/srpt: reject zero-length buffer descriptors
      RDMA/srpt: widen the indirect RDMA context counters

 MAINTAINERS                                   | 19 +++----
 drivers/infiniband/core/nldev.c               |  5 +-
 drivers/infiniband/core/uverbs_cmd.c          |  4 +-
 drivers/infiniband/hw/bnxt_re/ib_verbs.c      |  9 ++--
 drivers/infiniband/hw/bnxt_re/ib_verbs.h      |  1 +
 drivers/infiniband/hw/bnxt_re/qplib_rcfw.c    | 73 ++++++++++++++++++++++-=
----
 drivers/infiniband/hw/ionic/ionic_lif_cfg.c   |  2 +-
 drivers/infiniband/hw/ionic/ionic_res.h       | 23 ++++++---
 drivers/infiniband/hw/irdma/ctrl.c            |  4 +-
 drivers/infiniband/hw/irdma/defs.h            |  1 +
 drivers/infiniband/hw/irdma/hw.c              |  4 +-
 drivers/infiniband/hw/irdma/utils.c           | 22 ++++----
 drivers/infiniband/hw/irdma/verbs.c           | 73 +++++++++++++++++++----=
----
 drivers/infiniband/hw/mlx4/mr.c               |  3 ++
 drivers/infiniband/hw/mlx5/devx.c             |  6 +--
 drivers/infiniband/hw/mlx5/ib_rep.c           | 23 ++++++---
 drivers/infiniband/hw/mlx5/main.c             |  3 +-
 drivers/infiniband/hw/mthca/mthca_memfree.c   |  2 +-
 drivers/infiniband/hw/usnic/usnic_ib_qp_grp.c | 13 ++++-
 drivers/infiniband/sw/siw/siw.h               |  1 +
 drivers/infiniband/sw/siw/siw_mem.c           |  2 +-
 drivers/infiniband/ulp/rtrs/rtrs-clt.c        |  8 +--
 drivers/infiniband/ulp/srpt/ib_srpt.c         | 21 +++++++-
 drivers/infiniband/ulp/srpt/ib_srpt.h         |  4 +-
 24 files changed, 229 insertions(+), 97 deletions(-)

--=20
Jason

--HMV4ZkDnUBmDuVbD
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQRRRCHOFoQz/8F5bUaFwuHvBreFYQUCawCN3gAKCRCFwuHvBreF
YV5SAQDVwufIWjZ5hSFn8dlmumA06xhG2YG+Mz6ICxy/87kvWAEA1ZmFlC04cXxi
fyqRAl+SozYURsNT0NBMNRlUD3JcGwI=
=iYxH
-----END PGP SIGNATURE-----

--HMV4ZkDnUBmDuVbD--
