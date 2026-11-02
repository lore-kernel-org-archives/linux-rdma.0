Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.201.58
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793658917;
	b=mUfnYUu1S7t+kPZoeViEMPfxtEHTczRsNvMQgPP1kTdIyu/+ZJcdHHwIMUPBv8Ilf5SG
	 nG0EKgEoJvdMuATAx6tLWbPLvHtZaRIbbWIMVCqQJeX+1dye5FpFh7VGoCZL8ryj5LTXG
	 fspxNDNFFLmXNDY2SdK7yVJ/jJf1iohd8QpZDnPBIUU5eu+y2ZiHx11VxuG/bDeiKSTOX
	 DL8X7PfgCpiHnPjoRNHLnI6CJqYDprKqzYj52CyoOeWSHUtIvQugbEJeY5tgtap4Z8lgr
	 kgcAfnnFBFKl92PgMu+7aC3+Q5nRGXgfp9UMd45VHy5hUfIDvKbShUfNy6cnu92I7fQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793658917;
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
	bh=Ulv3xklO2h98FxBMuyZ/DlHaQL7bjI0f5FpPYIu1bsc=;
	b=K9Y143/pBwgyjXkbQkoF5EmM1ktM5JJUNVmuznqUUDYYGNGph568MQ41DHiWdIYFeufH
	 7afbj0+zrdrpK2XnzefwjlnhSt5WUb3rmB4amVMbdVBPNyTAsEH4dh+dF/MGbehiqb809
	 M5sS7x6eEUNBJHgTtFI5ePBDvBKi64+8s133saAlbTI9gvKb6sFtbN8bsPnWKuEGRT1pV
	 /c3WZbiwI+KsaeYPq8HPy5+3ERDEWF1zNP6abIZLbP1wRbC5hc+FnJNeItTXh7Hld+nSa
	 AfWjKSdD/liOx3k8cxG23Q0rqjNkvoak5dNpnbYY6bHrvgbG8CFsY0+abuMt++HRuPQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=aJRyLhey;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.201.58
Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazon11013058.outbound.protection.outlook.com [40.107.201.58])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07F4E606A329;
	Mon,  2 Nov 2026 22:35:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 07F4E606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=aJRyLhey
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QTCKasD25zgBZMkuOEtDRXPdAJ5rzYdhCjx7UUP2T4nFH4u/DJWo3oaCfq8pJ+h3EcfOjb4kKbZEvfKV1tLDrdVWv6I9STUeRQtcJ28jZLKAl9Gw1HKC+wsrt+AG805crE7GLze36HNbbRpXJ/sYuLZZvpvg7hqtW64xVtZM7RfC+dEl1tNkilHv+1OWWXv6+3bjSLLeRgl4FLFVCFclXeTedN6Fy4DzgWC8Y32mERbkk+6XgP9X2NJLhkvFU1vhhoTGE6cWvUMdZ2twbWWdRSqCAM66Ke/hg8D+nI78IZ6Rc7pR1Q/UFSzrPiq9YYX8TZSPezVeUh/a2GrtB83sBA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ulv3xklO2h98FxBMuyZ/DlHaQL7bjI0f5FpPYIu1bsc=;
 b=F2QRK9Fh2EpGChE5yHnOhfmpntB4oBgpE3POKZLdNwQ/4qquZDeM+ejGftDtKlV+sXOpEvLVKkolBMaOeHxKbb3YjKUHDjSnr6jzxHbUyIkrYTfmBsBFy6bQ4hImOOOFyKULBeXP/BphZsYaFmGWw9QKi8FwWzWrit6nQq2e5eb6epkciDgR2ZXyVzEf92ot6TE6+vkSvy+quLAwLl4MpELjSrPRxj0+TKjCCuu8TpsUlxxqM/zdPrDtAjRFc3Ndgacn2ZJRX004/9On4+4TXbicd37nc6lx21aid3eop8QQSkkbdZGWPWPWUhuX7Wwba7s58avcGnyw3DKjj76/2A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ulv3xklO2h98FxBMuyZ/DlHaQL7bjI0f5FpPYIu1bsc=;
 b=aJRyLheyt8ywYo/xRxPDQ2fU6q1mLQiXan7HC4kwIIfMlhujYKlihYZQFk8mKBnxmXxZHV3LWRc/novlAjcEm/uhXD4XKEn8yG9slF+EIhex4/35AZmUAb1cQDQhpuT1poF5Uw3MngxieMQfuHGK/gfjRLbawdBBFsg6Rm/seTvqZ71aCiOeUT/3UktvoZCGbaqVjqVirAA+Q0wDBkDbVnhdAw/iCoJO6f3A6JufNgUzmsVA8tkb8UW4j81W61mZY0WW4Kd2th0biLtU/hrO+6ERo1xFP43hCGFg5E0BPbJij4sTSi8Xfl19Q0xRLxUZ2I/IX9h7jJSeEDEsDyh91w==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6478.namprd12.prod.outlook.com (2603:10b6:930:35::19)
 by SA1PR12MB7038.namprd12.prod.outlook.com (2603:10b6:806:24d::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.569.12; Mon, 2 Nov
 2026 22:35:11 +0000
Received: from CY5PR12MB6478.namprd12.prod.outlook.com
 ([fe80::51f:ab92:7d1a:441b]) by CY5PR12MB6478.namprd12.prod.outlook.com
 ([fe80::51f:ab92:7d1a:441b%2]) with mapi id 15.21.0569.011; Mon, 2 Nov 2026
 22:35:11 +0000
From: Michael Gur <michaelgur@nvidia.com>
To: jgg@ziepe.ca,
	leon@kernel.org,
	linux-rdma@vger.kernel.org
Cc: Edward Srouji <edwards@nvidia.com>,
	Yishai Hadas <yishaih@nvidia.com>,
	Michael Gur <michaelgur@nvidia.com>,
	linux-kernel@vger.kernel.org (open list)
Subject: [PATCH rdma-next v2 15/15] RDMA/mlx5: Enforce relaxed ordering when HW requires it
Date: Tue,  3 Nov 2026 00:33:08 +0200
Message-ID: <20261102223325.2115128-16-michaelgur@nvidia.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20261102223325.2115128-1-michaelgur@nvidia.com>
References: <20261102223325.2115128-1-michaelgur@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MR1P264CA0002.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:501:2e::7) To CY5PR12MB6478.namprd12.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: CY5PR12MB6478:EE_|SA1PR12MB7038:EE_
X-MS-Office365-Filtering-Correlation-Id: 376728ca-d824-4a9f-105f-08df39318e0d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|23010399003|6133799003|18002099003|22082099003|56012099006|261102123227099003|10067099003|261009223027099003|261022105027099003|261021121427099003|261021123027099003|5023799004|11063799006|261028144727099003|261026140227099003|261026121527099003;
X-Microsoft-Antispam-Message-Info:
	B424IdEyuekn5TZkq2bCHLnXORNZZ5YayBHFs69Gsn2FNV8/E5lrFCC0h/jSl+b0fLWFhJoDr/hnEInBFw7yDGlDHusZL5pugSUfj77ezPE8g+s49mC2H6ZwqJDEIhOZCnYPtQnxpa5aGeWf4dTo/qfqqkABfUFIWjRQOvUnLP99NcEnnwMBkWWVAv0ogce8O5NMrIhjezPfrpuGx8YyHQzj9TfEeq4aKtFYuL5sKxBU95BggUq0ZLmgiYRWgLbpKi+fVDQhqgE4Pk3hRWuNkjZy1bdNXAORTUH0SccEWScUFaDdGEs568xJwymhEy/Mlg5ycYU+TnqyzC3pj91qMNSJG3+EWvS2X6rbyD0GG+tRhT62sfJeesQ1X88JfDDebvSrA+Yv+PE8TDeChunItghHcRs1gsYJbQV+4oGcL8crwYrCm6PcxwupHBRUtRU1Vtiqu7EoE8sRizFM9YqJCOnyM2Czm+W6CdPt83iNXjHkV0TyUp07wv1l/mjVISieuxWN9DXy3v2HwfdV4/PgAZQlDHqL1oZLh9slsLhVQs18MQ0NTGUVgY1YJNf/RqlVCqjRr/8uE/Jnq9sFN7mtovZtmd4+QuMJ1KhfLylHf5py8UW95UVbphNn8ADcVwX3WywXvpEHv/a4D9Kn4ekCvKkx58vluLhERYnZVL38czE=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6478.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(23010399003)(6133799003)(18002099003)(22082099003)(56012099006)(261102123227099003)(10067099003)(261009223027099003)(261022105027099003)(261021121427099003)(261021123027099003)(5023799004)(11063799006)(261028144727099003)(261026140227099003)(261026121527099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?WcU2c+BoOJLBB2Nw8DTbWAUOILi7gh2ylIdneRpyt0jdcgY+f+zIs/sah75D?=
 =?us-ascii?Q?HTMpAUqOsUT8yZo+nzeRTYcBCmjQuZpX/Ea0tpghXMdT6UEQ2IcfQugaUJCn?=
 =?us-ascii?Q?j22b1XAsXk5FiA8hk2nREMRo8G9Ilt+EsgQ89tdDzNbRX/APwTwNPHW0EM/Q?=
 =?us-ascii?Q?FSCKWZQ3D31l5rzOsvM4xBP1KGSrktv+eKjscrTE4qo8Fbs41w1IwwxBtaMb?=
 =?us-ascii?Q?Gzvz02dF+7HmQM9XHElIQEFy1mGZqmQiMOipBEPaAypT+haQBhffbQksPHVo?=
 =?us-ascii?Q?N2H30I9hJTKmJ+RlrmJdt6agOkYUWnBWOjdT2apSkuOSRDQK2+fDMDYe2R2Q?=
 =?us-ascii?Q?3s2egJUgQvYrQrGMCFEV067oe0oB3TtETc5qteIRorOYyvsW4NCqCwhAJSn2?=
 =?us-ascii?Q?fOw4U4MqGdmXrbNml6JEcaVgCYEY1usiOzNLqivo99Oxy+ZkZSaw7JUnvORc?=
 =?us-ascii?Q?N7dqUJbBiWJEq8XUazcqNgeJG1vLxFPna5x3FsVSxZ/MRxssO/JWpfISuXP7?=
 =?us-ascii?Q?6r26/4ORHYKedoiUPymxXGytofspTLmxaI10S95Xowtsf7/h0NFYhdpJKPED?=
 =?us-ascii?Q?z/4ivLjE5t4BnrLMGZh2DOt6PeJ3rDpvBQ9WyxuxSfzxH+3k1d1dbf9DmaYQ?=
 =?us-ascii?Q?NLxJ9XdtXg8gYuTJ3alkd0edf3aQ3ryToLEbuCPmBw9f7Pwlzy4Qe7nXYm+x?=
 =?us-ascii?Q?oMvsmRYrz7kjrcvyprI5hwmi6xHmf786e8B0kVISdHjQQKBsYb/vKwCP20Y6?=
 =?us-ascii?Q?jZFqs4dxDSUELmo2Yr+PvGHuyho/QDatzEDbE0RfrJkKhoMRorYisbz1j/ep?=
 =?us-ascii?Q?jfVOMtGvP7+4udNWXj/JKhM8U1t9ZaAWyEpmJnKb8XRAkRqs2TD9BmnXmx4i?=
 =?us-ascii?Q?uLjH1sk/CMVrT5ytlk9VlEoFDMoswodWcN07QML1P6z2rG+TGyPYW9zdy2Tw?=
 =?us-ascii?Q?zZepV3Oi2fjUDC7TVOs5mYRFWVgRF6VZciRc5O8bjIUPyyGatAHQePMNIm+0?=
 =?us-ascii?Q?gGJ6z9rp/df7kN73zvRSkRmliYIonukuuZFwYoMieSx/9X13OqGLBVRmBXHJ?=
 =?us-ascii?Q?mezTP/dzR4Ip9tvTcDXe9OomoAganHGE9pOi1t1Gegp2OI4P7IAdpJw22xNA?=
 =?us-ascii?Q?POFjTUmUZi1OMnby9gv+uQIPE4uqn1kqZBspjEqMBmWrhQ3Un7DthB6bK6RQ?=
 =?us-ascii?Q?F1IZeGSxcgoqAORBTtKnsCc9urwOMy4035pPao3B4+NXcx6w7AF8AmunxgXW?=
 =?us-ascii?Q?A3HtR0fN2zhkjRCgYGahKOOb7pb4Zqy70Xv0bA85jFSzsOdHwYidLXtCg2aE?=
 =?us-ascii?Q?1BwZpOJiKytpvjlA7TPWoU9cPbxXT6YaW1k8Myxd6ABx7sSKHhixn135cUtf?=
 =?us-ascii?Q?1wZyrbOWHHM9uen56p0dKlv0DScLxKi44ac9Cf3QRNoOwjTRWilqSjcLl5Om?=
 =?us-ascii?Q?52G3atAF/ree+kd0hAEOHnW+84oZK6tVpFux2WAuAMNTfFik42UQYPgDbazw?=
 =?us-ascii?Q?mbM9ZRy4oOvCEEMsumLmoMhM7JpFrEMrHU10/h9qI726tYCk/T7Hx4aGx9DG?=
 =?us-ascii?Q?1i5mB3bPswdruQzIpGQsiJCWjihxhBoz6FOA69fB4aMGXAAYG3XTpsFaIAop?=
 =?us-ascii?Q?yk7m45MyGaoogh9ovVQwj/JxPVuEEa2h6CweLZ77NoRLdSqRflOw/eIkJ09K?=
 =?us-ascii?Q?Itodnur3LutAaE3uZgsU2XHYE8yN79larsGNlmgnTMexzpRuNiZwdLBFwtU7?=
 =?us-ascii?Q?gm+2N3jjpQ=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 376728ca-d824-4a9f-105f-08df39318e0d
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6478.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Nov 2026 22:35:11.2144
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: e/BFV1IuqY7FrO6nytJIqwvyLs3YGzfEw2MsVriev2v4VibDAbEhw6l7XWIP8oq9ggFMRQ/lQWRtfUQjxdwf/Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB7038

Add relaxed ordering validation (relaxed or unordered) to enforce no
strong ordered mkeys are created when the HW disallows it.
Reject MR registrations that do not request IB_ACCESS_RELAXED_ORDERING
or IB_ACCESS_UNORDERED.

Invoke the validator from all user-facing MR registration paths,
including the Device Memory path (mlx5_ib_reg_dm_mr), and from the
FRMR pool build_key callback, so that an admin request to pin a pool
with strong ordered access fails up front rather than on mkey creation.

Reviewed-by: Yishai Hadas <yishaih@nvidia.com>
Signed-off-by: Michael Gur <michaelgur@nvidia.com>
---
 drivers/infiniband/hw/mlx5/mr.c | 34 ++++++++++++++++++++++++++++++++-
 1 file changed, 33 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/mlx5/mr.c b/drivers/infiniband/hw/mlx5/mr.c
index 6848515e06d7..7952d80349dc 100644
--- a/drivers/infiniband/hw/mlx5/mr.c
+++ b/drivers/infiniband/hw/mlx5/mr.c
@@ -78,6 +78,16 @@ static void set_mkc_access_pd_addr_fields(void *mkc, int acc, u64 start_addr,
 	MLX5_SET64(mkc, mkc, start_addr, start_addr);
 }
 
+static int validate_ordering_access(struct mlx5_ib_dev *dev, int acc)
+{
+	/* If HW disallows Strong Ordered writes, RO/UNORDERED must be set */
+	if (MLX5_CAP_GEN(dev->mdev, mkc_order_write_after_write_ro_only)) {
+		if (!(acc & (IB_ACCESS_RELAXED_ORDERING | IB_ACCESS_UNORDERED)))
+			return -EOPNOTSUPP;
+	}
+	return 0;
+}
+
 static void assign_mkey_variant(struct mlx5_ib_dev *dev, u32 *mkey, u32 *in)
 {
 	u8 key = atomic_inc_return(&dev->mkey_var);
@@ -288,6 +298,7 @@ static int mlx5r_build_frmr_key(struct ib_device *device,
 				struct ib_frmr_key *out)
 {
 	struct mlx5_ib_dev *dev = to_mdev(device);
+	int err;
 
 	/* check HW capabilities of users requested frmr key */
 	if ((in->ats && !MLX5_CAP_GEN(dev->mdev, ats)) ||
@@ -297,6 +308,10 @@ static int mlx5r_build_frmr_key(struct ib_device *device,
 	if (in->vendor_key & ~MLX5_FRMR_POOLS_KEY_VENDOR_KEY_SUPPORTED)
 		return -EOPNOTSUPP;
 
+	err = validate_ordering_access(dev, in->access_flags);
+	if (err)
+		return err;
+
 	out->ats = in->ats;
 	out->access_flags =
 		mlx5r_umr_get_unchangeable_access_flags(dev, in->access_flags);
@@ -673,8 +688,13 @@ struct ib_mr *mlx5_ib_reg_dm_mr(struct ib_pd *pd, struct ib_dm *dm,
 {
 	struct mlx5_ib_dm *mdm = to_mdm(dm);
 	struct mlx5_core_dev *dev = to_mdev(dm->device)->mdev;
+	struct mlx5_ib_dev *ib_dev = to_mdev(dm->device);
 	u64 start_addr = mdm->dev_addr + attr->offset;
-	int mode;
+	int mode, err;
+
+	err = validate_ordering_access(ib_dev, attr->access_flags);
+	if (err)
+		return ERR_PTR(err);
 
 	switch (mdm->type) {
 	case MLX5_IB_UAPI_DM_TYPE_MEMIC:
@@ -837,6 +857,10 @@ struct ib_mr *mlx5_ib_reg_user_mr(struct ib_pd *pd, u64 start, u64 length,
 	mlx5_ib_dbg(dev, "start 0x%llx, iova 0x%llx, length 0x%llx, access_flags 0x%x\n",
 		    start, iova, length, access_flags);
 
+	err = validate_ordering_access(dev, access_flags);
+	if (err)
+		return ERR_PTR(err);
+
 	err = mlx5r_umr_resource_init(dev);
 	if (err)
 		return ERR_PTR(err);
@@ -1028,6 +1052,10 @@ struct ib_mr *mlx5_ib_reg_user_mr_dmabuf(struct ib_pd *pd, u64 offset,
 		    "offset 0x%llx, virt_addr 0x%llx, length 0x%llx, fd %d, access_flags 0x%x, mlx5_access_flags 0x%x\n",
 		    offset, virt_addr, length, fd, access_flags, mlx5_access_flags);
 
+	err = validate_ordering_access(dev, access_flags);
+	if (err)
+		return ERR_PTR(err);
+
 	/* dmabuf requires xlt update via umr to work. */
 	if (!mlx5r_umr_can_load_pas(dev, length))
 		return ERR_PTR(-EINVAL);
@@ -1161,6 +1189,10 @@ struct ib_mr *mlx5_ib_rereg_user_mr(struct ib_mr *ib_mr, int flags, u64 start,
 	if (!(flags & IB_MR_REREG_PD))
 		new_pd = ib_mr->pd;
 
+	err = validate_ordering_access(dev, new_access_flags);
+	if (err)
+		return ERR_PTR(err);
+
 	if (mr->is_odp_implicit && !(flags & IB_MR_REREG_TRANS)) {
 		if (!(new_access_flags & IB_ACCESS_ON_DEMAND))
 			return ERR_PTR(-EOPNOTSUPP);
-- 
2.52.0

