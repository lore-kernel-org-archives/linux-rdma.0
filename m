Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.193.70
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795074073;
	b=ObeHoCRox4qd2dKjisr0XbbBYsmnQ2XiLJAdVeumVGjITPbEWaQnF/1VFsOyXS9Vw+FS
	 h+8gyW2VDFTEFBtMZ/bkBluM6Xs5rw7wz8HWz1sxt3460byIlH1TKpBUBQv+5Jhpb9LSY
	 ka+0KtjPQeyMu4C0iHP9oYTqItAIMvTwPtv05zCRKy6tgzpw0ZG7m1iJZ4aH1BjuJaLIm
	 dsfRoe3BuwUC/hz0M+G0d88yvg7m3q9HsyKix2ZWk3sOlD09wexCIwaCUS9ObkPMinDZN
	 Yqh3EBZXZqg23kbOj6ux7CqRChRzbF4IEgm5ci0a5e+uc0Jw/H/RDyipzkTAaR8Seyw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795074073;
	h=DMARC-Filter:DKIM-Signature:Received:Received:
	 X-MS-Exchange-Authentication-Results:Received-SPF:Received:Received:
	 Received:From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
	 References:MIME-Version:Content-Type:Content-Transfer-Encoding:
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
	bh=0OMzCPnzemhxLHaIP9+/TQuppjZ9Y8Bj2nUiryMAsjk=;
	b=aveojFCAUHpvdegZ8iaS5gdYCKNjpH3rASPku7jWjyD9Yzrqsq4SxscgRHg24v4g5xhr
	 gl7fAiYrgkRHtAoLbDGXhHX1FnIhk1z50WdpZESBvC9RRpqNAiMtCXsYHwer0elBNyvvh
	 SSlxaD7pJDgvVrlJmbd9rn58Y13BrKN+TO8cPBtJUDqH8mpOPIYlb3mzI2E5AhJ7zqLIa
	 j8ycrZjZhdku1dtydFnPgLxsaxUmoPHg4soZ0hDjXElnHsU6P1oFksObcgqE4AQyoae6R
	 oyG70wzyhJz9cZ5od5xSknMvkZ7HGyypg5mO8ccW/alASadR/X3sXW4E8N0MG3k3JHw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=qCNAzwTN;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.193.70
Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazon11010070.outbound.protection.outlook.com [52.101.193.70])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15C13606A320;
	Thu, 19 Nov 2026 07:41:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 15C13606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=qCNAzwTN
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nM+ycLDbs7yLtaCiGlnor+mDcHsevXM5byVGJSk1pdqOjL2JzvlVEdgr2uulb+fHeCvoK/Cy02QSi0nTAM68DKS0pApeYD7RZK41x3HPCRBNMoep+qKAX9RIBX0Dtq7pxSO4tfkIPuMCf75Hfs97YAvMD/UhUHeGq/0q3c069Ot41gf+MM06dKMCi6K5VtYMmZin0SZZ2ggriHyN9Jmd2sYPBgWb1z7aJ6UTBGVYY4Pv1sNIrnizT76WyjrgbMGmCTXIbgcIQytsm+Dx00A96g9Zn0TLtqFnW3ffmLPK2PWKsNurlYvRPHVlPwQvQLiIQiRIQaEXnO7vumA80ddZ2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0OMzCPnzemhxLHaIP9+/TQuppjZ9Y8Bj2nUiryMAsjk=;
 b=OlFHx8Cgd6yZV0kPeWQZbpLNc13J5vcXuDg2b79T5EtT7BZ8SHWhOeYkvlcLkO0jYgio1d8UkWC7haysAVGrjkm8EyOqqj3Mf8oWTvoGvqWoKtgU1PP+xjFOkBsMpzuDIxQc2Bn+/bA8DXnL0CL4Eqv1AM+IlSECIsdj604x3glaWbq5h1J/2yyRDJCMdywQleUXURTyKM3uoxMjUaZ4MI4RXNolNwnaBCJSBDa7yfUt8vzQNlIwydDL/Ay/uWoS1CHs93twr/T6hY9NQjrRtEosyFkmQlU1clq8s0xOp+jqkmjCcgchZiQVBj6UyfABaV5QqNPa9KnonNXCm+1sOg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0OMzCPnzemhxLHaIP9+/TQuppjZ9Y8Bj2nUiryMAsjk=;
 b=qCNAzwTNH+Jvn6cEUP+ywoTB/u6v451ac3jsgXZ5Kc9n/EY8vizbvq0PlG5+snVbuE3wmQm6tcml8D39wCqIFM6tmTocZRD4XNuqtzxs520CUVpRiwzjwyzK8xehleUlYOzAXym7kLQXBGsAmWF32m5s7FryaRig2COSvqrwSUvjJrOW6WujBm1asBkXH1ZfSfQAP7FG36mXJBJTTN6B0xDXFGKA1xhO1nR1m0cc5bc65q7kQSEUMe2dBrtceu7G8JSYAnns2w/eu/PPQ9dWir5mpc5mq1m4razGRvjfcmk5fgu0mLYPKivfiaOPZWe5oJIQA5UTe1CHWCUye/Yspg==
Received: from MN2PR20CA0039.namprd20.prod.outlook.com (2603:10b6:208:235::8)
 by CH0PR12MB8485.namprd12.prod.outlook.com (2603:10b6:610:193::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.16; Thu, 19 Nov
 2026 07:41:06 +0000
Received: from MN7PEPF0000014D.namprd04.prod.outlook.com
 (2603:10b6:208:235:cafe::ac) by MN2PR20CA0039.outlook.office365.com
 (2603:10b6:208:235::8) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.615.13 via Frontend Transport; Thu,
 19 Nov 2026 07:41:06 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.117.161) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 MN7PEPF0000014D.mail.protection.outlook.com (10.167.254.39) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.639.5 via Frontend Transport; Thu, 19 Nov 2026 07:41:06 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.57; Wed, 18 Nov
 2026 23:40:51 -0800
Received: from nps-server-23.mtl.nbulabs.nvidia.com (10.126.231.37) by
 rnnvmail201.nvidia.com (10.129.68.8) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.57; Wed, 18 Nov 2026 23:40:46 -0800
From: Shay Drory <shayd@nvidia.com>
To: <netdev-bot+sashiko@kernel.org>
CC: <tariqt@nvidia.com>, <andrew+netdev@lunn.ch>, <davem@davemloft.net>,
	<edumazet@kernel.org>, <kuba@kernel.org>, <netdev@vger.kernel.org>,
	<pabeni@redhat.com>, <cjubran@nvidia.com>, <cratiu@nvidia.com>,
	<gal@nvidia.com>, <leon@kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-rdma@vger.kernel.org>, <mbloch@nvidia.com>, <moshe@nvidia.com>,
	<ohartoov@nvidia.com>, <phaddad@nvidia.com>, <saeedm@nvidia.com>,
	<udar@nvidia.com>
Subject: Re: [PATCH net-next V2 01/10] net/mlx5: Distinguish VFs/SFs in the SW system image GUID for LAG grouping
Date: Thu, 19 Nov 2026 09:40:37 +0200
Message-ID: <20261119074037.1583630-1-shayd@nvidia.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <179499791273.3136.2247906810795336370@kernel.org>
References: <20261116103010.1129666-1-tariqt@nvidia.com> <20261116103010.1129666-2-tariqt@nvidia.com> <179499791273.3136.2247906810795336370@kernel.org>
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
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN7PEPF0000014D:EE_|CH0PR12MB8485:EE_
X-MS-Office365-Filtering-Correlation-Id: 474808c5-63cd-4985-55fe-08df46107867
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|82310400026|36860700016|7416014|376014|10067099003|56012099006|5023799004|11063799006|4143699003|261026140227099003|261028144727099003|261026121527099003|261022105027099003|261022115727099003|261022075727099003|261021135927099003|261021121427099003|261102123227099003|261102130727099003|261009223027099003|18002099003|22082099003|13003099007|3023799007;
X-Microsoft-Antispam-Message-Info:
	qMruR1qF53PYF0NSgS6+2zx06KoPziZ7SsuYJ7+8XXlBR32laSLOBXhusMORtlZcpSlyuikKNyDOJGzeI32rZqowDEsHlge2RO2evaoOOtS+N64AuYddXqL34vsOi5dQulvsQt9fR+ZeRM/qndFzwyaOzLWlzHsp1bhRaHrWifeixu+CMec8jr5JUR751bMynWuToyLL2oBqlgI+OAdN3E2EFsEDkMtt3Kob78vebRE/VBCC61ZnBTxZmVGpA0nDsen1vTNO6mB7b3e4A8mNLnVQoMIpyCZQSVHMQzmd4hR1kN0XP42DpCQhHxcVo9MjXFyTc1TmJeuz8Hu0xzNK3FjjdJS/Frqge03ozMpxlZCWsS7U2Nb7nCMrVKSHH60wMf4ZlMzTW4CUDFzd6Jt15MEScbrvij3nBn5Fy0EFAfLIbPz0IKSKgRUxAHnLhFLPMVkOVvCEHN3lAcyyav7b5IValDWKCHMYs3cTURKXFC3/5CoZr0YXBvTTV8v5qb2vmX63Gv3KWRErxZ5/RKwNi/02sHLmxhi7CicAroOF83yiB7snd7kpZpCJZth8BxBi9RWdRpzbJqFc2lbhB/kYpALrkLpFhA4r5N9M7gsSBAagPwcZ1TKnVTKVV6BSF4VJr2rLEEfwjRqOQcBTz8BHgXOgIHNtn8hq7CximSzN7WxF6JYGOJbKbh6McL5EUG2/hiy+mv3iEZUWnutfZdNvHg==
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(82310400026)(36860700016)(7416014)(376014)(10067099003)(56012099006)(5023799004)(11063799006)(4143699003)(261026140227099003)(261028144727099003)(261026121527099003)(261022105027099003)(261022115727099003)(261022075727099003)(261021135927099003)(261021121427099003)(261102123227099003)(261102130727099003)(261009223027099003)(18002099003)(22082099003)(13003099007)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	VVlBmC6L8sJNmQ0NUto8Af6A+BE46BmoxIwxWXUoY4bqItmoPZx7wPj+trOL2Din1oAab2E//3RcGYhSks+DHYkYsLbt9oTLgDsCrycEMkOmTPVV2GEPO5PY95gFCUGHWcMl3tH5UtzRVMoGhHTubvWZaRYCCvEa4EnOrDCdAo7JT/WK/gV0wQKo8zjsQSEBsjCNT7wSF1IFhwL5OPs8qvBWJELV3EPbBEE2HGInpdXfZZy0GK/2IPsKaAM2afevhJAcQ1Z6RJtD+5KeXzi0zSak37Ytn/rGxr8X/WZKU7ms+w39bcdnLld/fEXJTPHTndfUmTlVt9D2QSl6evCUeNwpxpSBfsjELowWllc9PeU2gZiESzB8dePS4p+jeNx1TQSyPTBiJrCYC951ofg/iex5JmGYhshM+16lpPpRRrUsIeNG8bdwSRv+mP4OGOH+
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Nov 2026 07:41:06.1591
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 474808c5-63cd-4985-55fe-08df46107867
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MN7PEPF0000014D.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB8485

On Wed, 18 Nov 2026 10:31:52 +0000, netdev-bot+sashiko@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential
> issue(s) to consider.
>
> Critical: 0 · High: 0 · Medium: 1 · Low: 0
>
> If you believe none of the issues are legitimate, please reply to each
> issue of Medium severity or higher and explain why the AI is wrong.
> If any of them are legitimate and you plan to respin, please let patchwork
> know by including "pw-bot: cr" as a separate line at the end of your reply
> (one such reply per series is enough).
>
> - [Medium] The patch changes the SW system image GUID of a VF/SF that
>   passes mlx5_virt_lag_is_supported(): mlx5_sw_guid_vf() or…
>
> --
>
> net/mlx5: Distinguish VFs/SFs in the SW system image GUID for LAG grouping
>
> This patch changes mlx5_query_nic_sw_system_image_guid() so that each
> discriminator byte after the FW system image GUID has a fixed position,
> and trailing zero fields are trimmed. It adds VF and SF marker bytes that
> are only set when mlx5_virt_lag_is_supported() is true, and it raises
> MLX5_SW_IMAGE_GUID_MAX_BYTES from 9 to 11.
>
> > diff --git a/drivers/net/ethernet/mellanox/mlx5/core/vport.c b/drivers/net/ethernet/mellanox/mlx5/core/vport.c
> > index 78f3d15b599d0..bab43df6a7d72 100644
> > --- a/drivers/net/ethernet/mellanox/mlx5/core/vport.c
> > +++ b/drivers/net/ethernet/mellanox/mlx5/core/vport.c
> > @@ -1308,10 +1308,37 @@ u64 mlx5_query_nic_system_image_guid(struct mlx5_core_dev *mdev)
> >  }
> >  EXPORT_SYMBOL_GPL(mlx5_query_nic_system_image_guid);
> >
> > +static u8 mlx5_sw_guid_load_balance(const struct mlx5_core_dev *mdev)
> > +{
> > +	if (MLX5_CAP_GEN_2(mdev, load_balance_id) &&
> > +	    MLX5_CAP_GEN_2(mdev, lag_per_mp_group))
> > +		return MLX5_CAP_GEN_2(mdev, load_balance_id);
> > +	return 0;
> > +}
> > +
> > +static u8 mlx5_sw_guid_sf(const struct mlx5_core_dev *mdev)
> > +{
> > +	return mlx5_core_is_sf(mdev) && mlx5_virt_lag_is_supported(mdev);
> > +}
> > +
> > +static u8 mlx5_sw_guid_vf(const struct mlx5_core_dev *mdev)
> > +{
> > +	return mlx5_core_is_vf(mdev) && mlx5_virt_lag_is_supported(mdev);
> > +}
>
> [Severity: Medium]
> Does this break the same-HW check between a PF and a VF/SF that passes
> mlx5_virt_lag_is_supported()?
>
> Suppose the VF/SF's own caps report multi_uplink_eswitch=1, lag_master=1
> and num_lag_ports < 2. The VF key then becomes guid + [lb|0] + 0x01, which
> is 10 bytes. The SF key becomes guid + [lb|0] + 0x00 + 0x01, which is 11
> bytes. A PF never sets either marker, so its key is still 8 or 9 bytes.
>
> mlx5_same_hw_devs() requires the lengths to match:
>
> drivers/net/ethernet/mellanox/mlx5/core/dev.c:mlx5_same_hw_devs() {
>     ...
> 	return plen && flen && flen == plen &&
> 		!memcmp(fsystem_guid, psystem_guid, flen);
> }
>
> That means it now returns false for any PF paired with such a VF/SF.
>
> mlx5e_tc_is_vf_tunnel() only reaches that comparison when out_mdev is a
> PF and route_mdev is a VF/SF:
>
> drivers/net/ethernet/mellanox/mlx5/core/en_tc.c:mlx5e_tc_is_vf_tunnel() {
>     ...
> 	if (route_mdev->coredev_type != MLX5_COREDEV_VF &&
> 	    route_mdev->coredev_type != MLX5_COREDEV_SF)
> 		return false;
>
> 	return mlx5e_same_hw_devs(out_priv, route_priv);
> }
>
> For a virt-LAG-capable VF/SF route device, will it now always return
> false? These are the paths that would be affected:
>
> mlx5e_set_vf_tunnel()
>   mlx5e_tc_is_vf_tunnel()
>     mlx5e_same_hw_devs()
>       mlx5_same_hw_devs()
>
> - In mlx5e_set_vf_tunnel() the check fails and the code jumps to out with
>   err = 0. The encap flow is still offloaded, but without the VF vport
>   source port rewrite (MLX5_ESW_DEST_CHAIN_WITH_SRC_PORT_CHANGE plus the
>   VPORT_TO_REG metadata). The encapsulated packet then goes straight to
>   the uplink and skips FDB processing of the VF vport.
>
> - mlx5e_update_vf_tunnel() returns -ENODEV on route updates.
>
> - On decap, mlx5e_tc_tun_route_lookup() no longer sets
>   rx_tun_attr->decap_vport to the VF vport.
>
> - In mirred_nic.c, the NIC-mode redirect check
>
> 	if (priv->netdev->netdev_ops != out_dev->netdev_ops ||
> 	    !mlx5e_same_hw_devs(priv, netdev_priv(out_dev))) {
>
>   now rejects redirects between a PF netdev and such a VF/SF netdev with
>   "devices are not on same switch HW".
>
> The commit message says:
>
>   "so a VF/SF that cannot join a virt LAG keeps its current key and is
>   still identified as the same HW as its PF."
>
> That covers VFs/SFs that cannot join a virt LAG. It doesn't cover the
> ones that can, and none of the consumers above are updated.
>
> Should mlx5_same_hw_devs() compare without the VF/SF markers? Or should
> the LAG grouping key be kept separate from the key used for same-HW
> detection?

No, this is the point of the patch. A VF/SF that reports
multi_uplink_eswitch and lag_master (and num_lag_ports < 2) is a nested
eswitch manager. That makes it a different switch domain from its
PF, not one more vport of the PF's FDB, so it must not be identified as
the same HW as the PF. Without the marker it would also be grouped into
the PF's LAG, which is what the patch prevents.
A VF/SF that does not report these caps, i.e. every VF/SF that exists
today, keeps its key unchanged and is still the same HW as its PF, as
the commit message says. Dropping the markers inside mlx5_same_hw_devs()
would make a nested eswitch manager the same HW as its PF again, i.e.
undo the patch.

> > +
> > +static u8 (* const mlx5_sw_guid_fields[])(const struct mlx5_core_dev *mdev) = {
> > +	mlx5_sw_guid_load_balance,
> > +	mlx5_sw_guid_vf,
> > +	mlx5_sw_guid_sf,
> > +	/* New fields should be added at the end */
> > +};
>
> [ ... ]
>
> --
> Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261116103010.1129666-1-tariqt%40nvidia.com
