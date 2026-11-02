Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.56.11
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793658878;
	b=ifyJGUg+vHM+muNeCSR/TYhio0s9RwL0enSq4Y+Y8mHriK2YKU4UCXhBnrIpVPwzC2Wg
	 wWbTtPaQdU89vj1rDTrvDm9lF7Ss0U4dRrgyfOZD1imQ8rdwA8KrDUWxKU6/3J9AQxb48
	 rJldJfxQgt1ib+/oizAccO6HqvGKNj0B8nPUSBIF8I1g0+QgzD4oNBF5sq7PRy+MIQiOv
	 8cpm0MiTXVXXSYN4/aYSceompwb22qGNRWkuxksW0r7UlQWR08y+JKpzuZCClI0XAoMQm
	 SrnGXClfpaWESfxamve4KaHtI426AEQtLZ0rfsDUQluS489Wm1rHwbLiIGUqKWR1/kw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793658878;
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
	bh=chlDV6jJFxPVLHjFaJ3yss/BAquSRsBzdfMizbHYBM4=;
	b=5qSpdKB9Gm4J8MekP6MKove3tO11Zk1d/ZW+7VpShsqyBzHjKcGb329nikal4TXtIYMP
	 bACR8+3P5T+Mz35TRyA7MGevHzkCfkN6U+VTrrB8plSwLK1mFM+3BWBDlyCJZGV9tRq7z
	 Au48ZTJ338F8075CAM+QF2cu4L5hmEAK/IsC7xvn8f0oGdU+gOuhJxV4o78zTKSaZUsmX
	 MQhEIosH8rk0gJuNT5OERIRgkc0Ot7xOHs6kFb038Ogl05cmEVySLZ91pSNO8+DeXdTrz
	 LU6pYOl6Ab6EltnGOcyUHwQPgprwd67BCsOPc1vY7ZUCr2tPTWsQGYopBJ2zK7nfxjQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=R2wZ4+bQ;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.56.11
Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11010011.outbound.protection.outlook.com [52.101.56.11])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6E47606A326;
	Mon,  2 Nov 2026 22:34:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A6E47606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=R2wZ4+bQ
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XDOk1G8RAOqjrNaLoN5PFoW/G6eMw0HTtE2gmpQeuZJyUafa/QyZTa8CbSiUVxjOP25g2tBb+J50oHGSzYQ1KDF+OwSdVJJB8c5/eqU9Tj+GajltSiEPljy8KkOQlxn0R7EkODyR0KenT5iC46+1AcozbKRShCRY6ptlceH4Gu0q6oqbWQObCx+sR0Cl+1hE45RI3GeZqIsVty1pI9EQPDzFZrudb3utY2lP7+Qent9ZT9UyBLctOevxKk1zy/zZQBYX1+8dfkk6WXMgH9uKOdR+g/wEBU1j+aPKs1V6cIhfskLBzZip+eHswdnGspnJKZY1e2i2K5+Mw/6fiBv+jQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=chlDV6jJFxPVLHjFaJ3yss/BAquSRsBzdfMizbHYBM4=;
 b=SPsIZbyBlDrA1CMT8KgUsJEzmvYSKLgyijbRd9OFBxitYYWFaqIjIch2JkHFxhg4iMqLFx7viGdSn+ilqdK/TveaLHgXQ9DurF7W1B3vFYlpTZhpSASa/XHueGC0HTt2Nkr890KkwasdTMTyuID0yzkMYVxU68kHdWgfuLsWM9ZTf+wzdXBTHceOV2oWOzyYVmdVnxahdCnEf2FgUReuU7DQS32uZJ/f9/RlxakLkq+0fYOxMxdPmZ21DDN/PSoLbewL7AIZ6zSN3j+4wJV6BcJDRGobMELG5NHLKq6y5qrt5i1Am+ovPee8IXttu7WSf+3VuKBQAcXhRP8Bv98yjQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=chlDV6jJFxPVLHjFaJ3yss/BAquSRsBzdfMizbHYBM4=;
 b=R2wZ4+bQVaztcDO2jDgrIWwXs86zSgaigX7KHU8hjiwG6mfB/7vSGu9WoIdOWGS87/m+NRKN8NToD1fJPfI1dlaZ+QZNvaDy7h2I/wHI/xcZ4z3Mb9exapaED7Ucyy3EA2lMifVtda9W/Gg7CCg97fXBhmAckqdnSHHS40Q04VvCuu+yu3z9eLG9ntJ50o/GPCen9s6dcn2ApsEmBK++9PlYoaJvvlvO5SBcOXhnW3+sNDmdybThlIvV4QwjUrJcBZ65tsnY/bKCpSX7E0kR9gYzzChhcYnjfkqoxh8zvQ+7IRovXCTWBIVHMLx9ZCYdsp2vNOusth7/Ay8dcCuR8w==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6478.namprd12.prod.outlook.com (2603:10b6:930:35::19)
 by PH0PR12MB7905.namprd12.prod.outlook.com (2603:10b6:510:28b::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.569.12; Mon, 2 Nov
 2026 22:34:33 +0000
Received: from CY5PR12MB6478.namprd12.prod.outlook.com
 ([fe80::51f:ab92:7d1a:441b]) by CY5PR12MB6478.namprd12.prod.outlook.com
 ([fe80::51f:ab92:7d1a:441b%2]) with mapi id 15.21.0569.011; Mon, 2 Nov 2026
 22:34:32 +0000
From: Michael Gur <michaelgur@nvidia.com>
To: jgg@ziepe.ca,
	leon@kernel.org,
	linux-rdma@vger.kernel.org
Cc: Edward Srouji <edwards@nvidia.com>,
	Yishai Hadas <yishaih@nvidia.com>,
	Michael Gur <michaelgur@nvidia.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Mark Bloch <mbloch@nvidia.com>,
	Andrew Lunn <andrew+netdev@lunn.ch>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	linux-kernel@vger.kernel.org (open list),
	netdev@vger.kernel.org (open list:MELLANOX MLX5 core VPI driver)
Subject: [PATCH rdma-next v2 07/15] mlx5: Consolidate mkey ordering setting into a single core helper
Date: Tue,  3 Nov 2026 00:33:00 +0200
Message-ID: <20261102223325.2115128-8-michaelgur@nvidia.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20261102223325.2115128-1-michaelgur@nvidia.com>
References: <20261102223325.2115128-1-michaelgur@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TLZP290CA0001.ISRP290.PROD.OUTLOOK.COM
 (2603:1096:950:9::14) To CY5PR12MB6478.namprd12.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: CY5PR12MB6478:EE_|PH0PR12MB7905:EE_
X-MS-Office365-Filtering-Correlation-Id: 571a64db-6241-4dc6-6660-08df39317709
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|366016|1800799024|376014|23010399003|6133799003|18002099003|22082099003|10067099003|56012099006|261102123227099003|261102130727099003|261009223027099003|261022105027099003|261021135927099003|261028144727099003|261021121427099003|261021123027099003|11063799006|261026140227099003|261026121527099003;
X-Microsoft-Antispam-Message-Info:
	+m/6+hDaW6Opd+WLpKQ/W5EOFH2J+U2rT0apPPN2XIMQ5PBYHtbx0deuTzujHMY4g2Yts39UcYoNbLj6KGyhKaic3xK99CCZD0luH2n9CV+I525BcoOnacCXC/JcEmoAz4PR9hsAa/nRKNxITi76JMqvNcCRahfoJC5wYIOWVtxdVGP3+7B8i+pPzitK1frUuJPlNCRR5N+waNzud0tsGtqylqGWrY595hRVubGiedbwvQW0kEG42gteWXJjOPdH6oaq6G4MRSPXFb8LtYO+cne44I46TFIMN0S37FSms+p2XfDwZCVgZT25c8l+0SbRji94jYxU5amBZGwizswLDnfPNRhjTShNVq9mxs1pZWW4H99WCiDl0R/GzjiMNbONpad94l2q/D1w6eiZ/7ZlRZIdsemQlZqBtkdv40qECXuMQi5KGQs/6ZTmemsDsejolZhqySAstmpBm3JIyIMm03sMAreVaWf6mdvOnFej6WgX6guTFnmnTRjNBLf1OnvzkHZW14oRYlWVkoMYZQWhk72X4No4eSU65BFp27KirNqAb2uMi/vYK0lgYrgVn8cOEqh5VqwdzJgUWnKoAceY+9AwI14luNc/tsCfHBYApqop69jWPqHSG2r3ZdEO/AcU0zExaO5XIWo/VJRk5fC7GeSe7nBexHN/IAZm5PbC66k=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6478.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(366016)(1800799024)(376014)(23010399003)(6133799003)(18002099003)(22082099003)(10067099003)(56012099006)(261102123227099003)(261102130727099003)(261009223027099003)(261022105027099003)(261021135927099003)(261028144727099003)(261021121427099003)(261021123027099003)(11063799006)(261026140227099003)(261026121527099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?n30RkIUxXsxBSymzMto5M+bTfF7lePw0UGYxaAlYKvR+FtMD57CStRokPY4n?=
 =?us-ascii?Q?5Lx4aXpR55ZEsnLmYJgCKoD1Rrj0yZsYqtnAjEIcA2hyufS7hZ+avVmxcVQx?=
 =?us-ascii?Q?RCcL1C3zSvWIMJMZ5FTebArmVbmq1I9aKhg2CFj+z71+iC4RQ4FJCTpcGUjC?=
 =?us-ascii?Q?+NzLFPfexWyXOiH6cAvteGgrF1l/VpRZu0lL8knetvxOjrxwnQXLfjYfZtUR?=
 =?us-ascii?Q?3Vglbfu1PNk+4Tt4h4yQAufW5zBGxlGEVXzAlOABd3T7P9+N6je5KRsnZQLz?=
 =?us-ascii?Q?O8vUWMF8/ypNQAE5g4A6MpiHC5o2R0UygroGsF8RBF83AaDbUEJCVnErrbOv?=
 =?us-ascii?Q?0jxvCkNmxSrrLoa96/BmdbJxoDMb/2kU7MaCWNGxi0vONe8DumYdpKFxeaZg?=
 =?us-ascii?Q?bAlUe5Ln14OG115p1ox8KHucH/qQmKYs4reFobzb6dBdv1YhqWzl3vwbjAEw?=
 =?us-ascii?Q?kLka6T1DXqOYbdbD9u1cKwFtRu1hLYc269RK5rdlthSvzeDAw8TlRaDjAGyt?=
 =?us-ascii?Q?fDPJwKcP1GJrZMNepQr/uLgUBNwVyeZcsCPdOUCW5BSLOsBTkA+q46eiFcof?=
 =?us-ascii?Q?dLJDovbSeXtDOVU4yDZe1rdPyLwBH2rt/0BKu+k3d/XLntpExqSf3JwewXQO?=
 =?us-ascii?Q?bDu/RVC4e01IGol5mieNt6QQCr94bW5T0vAe7OPb8QGUxsJjocGv+2TI503u?=
 =?us-ascii?Q?XD9xngOJ0sLRQhT4V0DXKYrxmMgxSfITLE6/57kZ2oQBSnYXl9YQKNZRb4dN?=
 =?us-ascii?Q?RfLWWqGaIzotM33i1n7+ioTnTyB0InimsFKp0sMzg/bwpNhXCPeGtigizCZF?=
 =?us-ascii?Q?qOnJnoTxp/yE/F+LtjpF97yhdVM9MzHQcTydkuad6O7tHgy35v3+XTUxX37c?=
 =?us-ascii?Q?Zvyq0X3frW73bvRXjvv6UQi6yu+C8Rm30vEdO8n87SthX5uLc/LjiwO88wPQ?=
 =?us-ascii?Q?EFK+CK/klXSOXNx43piWIgD+fy1L9SNRbZ5iQi/lCqx0+EUmtXidr7xMsDXE?=
 =?us-ascii?Q?8f/Zy2V8V6wJYtbB2X9MtL4rImxhl+4sAURzsFcHTK86AgicliU5uYW13S36?=
 =?us-ascii?Q?NQDQog6SdOX41UDOFi3GYIx1TPoh3K1gOZpS8Lf6NrbjTFv7qbFgvrhcYPyY?=
 =?us-ascii?Q?IXimEWZkhXnv1x2NhFMH8gznnpiF/14PQ3Gi/pS4vg5thmNAZ+7sAMjCZhdK?=
 =?us-ascii?Q?7hgLrAg9F71xFQH5l0yzkiksn1nTVluxg0UQjgPtRURJoesmRJzNDERuAEeb?=
 =?us-ascii?Q?VxR3J+r+LB0vEyk0Vjto+G/CVc8ifXf588d+nGGrzZlcvJfuLP3r6KtoqJsI?=
 =?us-ascii?Q?PEZmQYlEz7kAdLuxBIp6eLVgh4A8Ah27mXZnzr4sCiI33N5+AKu2FKVqgsOQ?=
 =?us-ascii?Q?g/3pt20/MNOWJME7ueKKsmMdop7uzMBT41ezkxWxhnA4wTqbfBYuLuatWYad?=
 =?us-ascii?Q?SLL2FZ2ryQpjYJ65cN50z4Y5yKFhmot8M3weUhS6I84UcFMj/KbubmFdUBB2?=
 =?us-ascii?Q?rFyJtPscO6up/wU2+BEYSSTRtOsUOR7hZOiYYRvausQH1PyWTj363Usbz4h1?=
 =?us-ascii?Q?XX0FHrFf2S3fBejTCYJuoycm6DFNn5XarylNCuSt5wjfznRYUjEnzqyit6RK?=
 =?us-ascii?Q?UPNPHtj9ZWkxoMWdvAuI6upURpq9SeMsnxjlkhQJWMZ73SlMpYH7axs1ozAh?=
 =?us-ascii?Q?NbcXCsPoP1SaWFFEx3+VJ10BqSLMP+NRHUDAFKlz5oS41LjWhK96ZRIigbBe?=
 =?us-ascii?Q?WW5EBTJxWg=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 571a64db-6241-4dc6-6660-08df39317709
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6478.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Nov 2026 22:34:32.4258
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pN+EaVGpLWivvq/z1QvypFQtP8+tTDNHJDSCGzfm2CLiAKdPp6Ukp+wav0GXM2UEeuKuTbaewQv2LNlXymyrQQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB7905

Consolidate the mkey ordering setting of all mlx5 consumers into a
single exported core helper. The helper takes the requested ordering
level (strict, relaxed or unordered) and sets the mkey ordering fields
according to the device caps, so consumers no longer open-code the cap
checks. The unordered level is used later in this series.

Switch the RDMA MR creation and UMR access-modify paths to the helper.
As before, strict ordering leaves the mkey context untouched.

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: Yishai Hadas <yishaih@nvidia.com>
Signed-off-by: Michael Gur <michaelgur@nvidia.com>
---
 drivers/infiniband/hw/mlx5/mlx5_ib.h          |  7 ++++
 drivers/infiniband/hw/mlx5/mr.c               | 12 ++-----
 drivers/infiniband/hw/mlx5/umr.c              | 10 ++----
 drivers/net/ethernet/mellanox/mlx5/core/en.h  |  1 -
 .../ethernet/mellanox/mlx5/core/en_common.c   | 13 +-------
 .../net/ethernet/mellanox/mlx5/core/en_main.c |  4 +--
 drivers/net/ethernet/mellanox/mlx5/core/mr.c  | 32 +++++++++++++++++++
 include/linux/mlx5/driver.h                   |  8 +++++
 8 files changed, 55 insertions(+), 32 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
index 86465d9d2b5a..dd1fe8fd4220 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -1675,6 +1675,13 @@ static inline bool mlx5_umem_needs_ats(struct mlx5_ib_dev *dev,
 	return access_flags & IB_ACCESS_RELAXED_ORDERING;
 }
 
+static inline enum mlx5_mkey_order mlx5r_access_to_mkey_order(int access_flags)
+{
+	if (access_flags & IB_ACCESS_RELAXED_ORDERING)
+		return MLX5_MKEY_ORDER_RELAXED;
+	return MLX5_MKEY_ORDER_STRICT;
+}
+
 int set_roce_addr(struct mlx5_ib_dev *dev, u32 port_num,
 		  unsigned int index, const union ib_gid *gid,
 		  const struct ib_gid_attr *attr);
diff --git a/drivers/infiniband/hw/mlx5/mr.c b/drivers/infiniband/hw/mlx5/mr.c
index a15610c6211c..6f57dfc7f4cd 100644
--- a/drivers/infiniband/hw/mlx5/mr.c
+++ b/drivers/infiniband/hw/mlx5/mr.c
@@ -70,16 +70,8 @@ static void set_mkc_access_pd_addr_fields(void *mkc, int acc, u64 start_addr,
 	MLX5_SET(mkc, mkc, lw, !!(acc & IB_ACCESS_LOCAL_WRITE));
 	MLX5_SET(mkc, mkc, lr, 1);
 
-	if (acc & IB_ACCESS_RELAXED_ORDERING) {
-		if (MLX5_CAP_GEN(dev->mdev, mkc_order_write_after_write_ro))
-			MLX5_SET(mkc, mkc, order_write_after_write, 1);
-
-		if (MLX5_CAP_GEN(dev->mdev, pci_relaxed_ordered_read) ||
-		    (MLX5_CAP_GEN(dev->mdev,
-				  relaxed_ordering_read_pci_enabled) &&
-		     pcie_relaxed_ordering_enabled(dev->mdev->pdev)))
-			MLX5_SET(mkc, mkc, pci_relaxed_ordered_read, 1);
-	}
+	mlx5_core_mkey_set_ordering(dev->mdev, mkc,
+				    mlx5r_access_to_mkey_order(acc));
 
 	MLX5_SET(mkc, mkc, pd, to_mpd(pd)->pdn);
 	MLX5_SET(mkc, mkc, qpn, 0xffffff);
diff --git a/drivers/infiniband/hw/mlx5/umr.c b/drivers/infiniband/hw/mlx5/umr.c
index 144cf851c41e..2f3147c7f78f 100644
--- a/drivers/infiniband/hw/mlx5/umr.c
+++ b/drivers/infiniband/hw/mlx5/umr.c
@@ -445,18 +445,14 @@ static void mlx5r_umr_set_access_flags(struct mlx5_ib_dev *dev,
 				       struct mlx5_mkey_seg *seg,
 				       unsigned int access_flags)
 {
-	bool ro_read = (access_flags & IB_ACCESS_RELAXED_ORDERING) &&
-		       (MLX5_CAP_GEN(dev->mdev, pci_relaxed_ordered_read) ||
-			pcie_relaxed_ordering_enabled(dev->mdev->pdev));
-
 	MLX5_SET(mkc, seg, a, !!(access_flags & IB_ACCESS_REMOTE_ATOMIC));
 	MLX5_SET(mkc, seg, rw, !!(access_flags & IB_ACCESS_REMOTE_WRITE));
 	MLX5_SET(mkc, seg, rr, !!(access_flags & IB_ACCESS_REMOTE_READ));
 	MLX5_SET(mkc, seg, lw, !!(access_flags & IB_ACCESS_LOCAL_WRITE));
 	MLX5_SET(mkc, seg, lr, 1);
-	MLX5_SET(mkc, seg, order_write_after_write,
-		 !!(access_flags & IB_ACCESS_RELAXED_ORDERING));
-	MLX5_SET(mkc, seg, pci_relaxed_ordered_read, ro_read);
+
+	mlx5_core_mkey_set_ordering(dev->mdev, seg,
+				    mlx5r_access_to_mkey_order(access_flags));
 }
 
 int mlx5r_umr_rereg_pd_access(struct mlx5_ib_mr *mr, struct ib_pd *pd,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/ethernet/mellanox/mlx5/core/en.h
index a3945195f454..eea4844d7645 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -1203,7 +1203,6 @@ int mlx5e_modify_tirs_lb(struct mlx5_core_dev *mdev, bool enable_uc_lb,
 			 bool enable_mc_lb);
 int mlx5e_refresh_tirs(struct mlx5_core_dev *mdev, bool enable_uc_lb,
 		       bool enable_mc_lb);
-void mlx5e_mkey_set_relaxed_ordering(struct mlx5_core_dev *mdev, void *mkc);
 
 /* common netdev helpers */
 void mlx5e_create_q_counters(struct mlx5e_priv *priv);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_common.c b/drivers/net/ethernet/mellanox/mlx5/core/en_common.c
index 2dbcf6673916..f01340998f52 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_common.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_common.c
@@ -38,17 +38,6 @@
  * Global resources are common to all the netdevices created on the same nic.
  */
 
-void mlx5e_mkey_set_relaxed_ordering(struct mlx5_core_dev *mdev, void *mkc)
-{
-	bool ro_write = MLX5_CAP_GEN(mdev, mkc_order_write_after_write_ro);
-	bool ro_read = MLX5_CAP_GEN(mdev, pci_relaxed_ordered_read) ||
-		       (pcie_relaxed_ordering_enabled(mdev->pdev) &&
-			MLX5_CAP_GEN(mdev, relaxed_ordering_read_pci_enabled));
-
-	MLX5_SET(mkc, mkc, pci_relaxed_ordered_read, ro_read);
-	MLX5_SET(mkc, mkc, order_write_after_write, ro_write);
-}
-
 int mlx5e_create_mkey(struct mlx5_core_dev *mdev, u32 pdn, u32 *mkey)
 {
 	int inlen = MLX5_ST_SZ_BYTES(create_mkey_in);
@@ -64,7 +53,7 @@ int mlx5e_create_mkey(struct mlx5_core_dev *mdev, u32 pdn, u32 *mkey)
 	MLX5_SET(mkc, mkc, access_mode_1_0, MLX5_MKC_ACCESS_MODE_PA);
 	MLX5_SET(mkc, mkc, lw, 1);
 	MLX5_SET(mkc, mkc, lr, 1);
-	mlx5e_mkey_set_relaxed_ordering(mdev, mkc);
+	mlx5_core_mkey_set_ordering(mdev, mkc, MLX5_MKEY_ORDER_RELAXED);
 	MLX5_SET(mkc, mkc, pd, pdn);
 	MLX5_SET(mkc, mkc, length64, 1);
 	MLX5_SET(mkc, mkc, qpn, 0xffffff);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index c3c2c5720c6f..efd69b1bfb59 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -462,7 +462,7 @@ static int mlx5e_create_umr_mkey(struct mlx5_core_dev *mdev,
 	MLX5_SET(mkc, mkc, lw, 1);
 	MLX5_SET(mkc, mkc, lr, 1);
 	MLX5_SET(mkc, mkc, access_mode_1_0, mlx5e_mpwrq_access_mode(umr_mode));
-	mlx5e_mkey_set_relaxed_ordering(mdev, mkc);
+	mlx5_core_mkey_set_ordering(mdev, mkc, MLX5_MKEY_ORDER_RELAXED);
 	MLX5_SET(mkc, mkc, qpn, 0xffffff);
 	MLX5_SET(mkc, mkc, pd, mdev->mlx5e_res.hw_objs.pdn);
 	MLX5_SET64(mkc, mkc, len, npages << page_shift);
@@ -801,7 +801,7 @@ static int mlx5e_create_rq_hd_mkey(struct mlx5_core_dev *mdev,
 	MLX5_SET(mkc, mkc, lw, 1);
 	MLX5_SET(mkc, mkc, lr, 1);
 	MLX5_SET(mkc, mkc, access_mode_1_0, MLX5_MKC_ACCESS_MODE_MTT);
-	mlx5e_mkey_set_relaxed_ordering(mdev, mkc);
+	mlx5_core_mkey_set_ordering(mdev, mkc, MLX5_MKEY_ORDER_RELAXED);
 	MLX5_SET(mkc, mkc, qpn, 0xffffff);
 	MLX5_SET(mkc, mkc, pd, mdev->mlx5e_res.hw_objs.pdn);
 	MLX5_SET64(mkc, mkc, len, shampo->hd_buf_size);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/mr.c b/drivers/net/ethernet/mellanox/mlx5/core/mr.c
index 678f0be81375..eced7d24948c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/mr.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/mr.c
@@ -35,6 +35,38 @@
 #include <linux/mlx5/qp.h>
 #include "mlx5_core.h"
 
+/**
+ * mlx5_core_mkey_set_ordering - Set ordering flags in mkey context
+ * @dev: MLX5 core device
+ * @mkc: Memory key context buffer
+ * @order: Requested ordering level
+ *
+ * Sets the ordering fields in @mkc for @order based on device caps. Call when
+ * creating or modifying a memory key. MLX5_MKEY_ORDER_STRICT leaves @mkc as is.
+ */
+void mlx5_core_mkey_set_ordering(struct mlx5_core_dev *dev, void *mkc,
+				 enum mlx5_mkey_order order)
+{
+	bool ro_write, ro_read;
+
+	if (order == MLX5_MKEY_ORDER_STRICT)
+		return;
+
+	ro_write = MLX5_CAP_GEN(dev, mkc_order_write_after_write_ro);
+	ro_read = MLX5_CAP_GEN(dev, pci_relaxed_ordered_read) ||
+		  (MLX5_CAP_GEN(dev, relaxed_ordering_read_pci_enabled) &&
+		   pcie_relaxed_ordering_enabled(dev->pdev));
+
+	MLX5_SET(mkc, mkc, pci_relaxed_ordered_read, ro_read);
+	MLX5_SET(mkc, mkc, order_write_after_write, ro_write);
+
+	if (order == MLX5_MKEY_ORDER_UNORDERED &&
+	    MLX5_CAP_GEN(dev, mkc_order_read_after_write))
+		MLX5_SET(mkc, mkc, order_read_after_write,
+			 MLX5_MKC_ORDER_READ_AFTER_WRITE_RO);
+}
+EXPORT_SYMBOL(mlx5_core_mkey_set_ordering);
+
 int mlx5_core_create_mkey(struct mlx5_core_dev *dev, u32 *mkey, u32 *in,
 			  int inlen)
 {
diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
index abb99371ff13..901744e3d63a 100644
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -697,6 +697,12 @@ enum mlx5_sw_icm_type {
 	MLX5_SW_ICM_TYPE_SW_ENCAP,
 };
 
+enum mlx5_mkey_order {
+	MLX5_MKEY_ORDER_STRICT,
+	MLX5_MKEY_ORDER_RELAXED,
+	MLX5_MKEY_ORDER_UNORDERED,
+};
+
 #define MLX5_MAX_RESERVED_GIDS 8
 
 struct mlx5_rsvd_gids {
@@ -1037,6 +1043,8 @@ void mlx5_trigger_health_work(struct mlx5_core_dev *dev);
 int mlx5_frag_buf_alloc_node(struct mlx5_core_dev *dev, int size,
 			     struct mlx5_frag_buf *buf, int node);
 void mlx5_frag_buf_free(struct mlx5_core_dev *dev, struct mlx5_frag_buf *buf);
+void mlx5_core_mkey_set_ordering(struct mlx5_core_dev *dev, void *mkc,
+				 enum mlx5_mkey_order order);
 int mlx5_core_create_mkey(struct mlx5_core_dev *dev, u32 *mkey, u32 *in,
 			  int inlen);
 int mlx5_core_destroy_mkey(struct mlx5_core_dev *dev, u32 mkey);
-- 
2.52.0

