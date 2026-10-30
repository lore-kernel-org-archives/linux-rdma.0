Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793336066;
	b=kvXq+S6d35AlS6NVyhIvBHUc4aNMvMhwJUn9Cq9kRtBYbyJ42fZyLkO26I4W4lp5SoSG
	 5W27KEnHx/mswvDdktQg1vLAbvfVmpSQEBL+lpq9/tbjxVLkM2jxfhcvgeT2c6bFYfQtR
	 ztlRPyARNEtqIFTWOwOVYbg0BztyfC3Md1i97JyB3W6ejIeVbIBz7OJqqrFfu4oVTd6XL
	 RNnuy9HJNyXsfDDajedWjGYWGCCXIXi98OuuOAeXJW2WRd6uaB5nHaanBrfvqIhUqXHYL
	 ajDH+LvFjXIWvpyKHeNRRP01Sk9Et2UocjubqI4oj8B4vnLB/dtSZv38GHWCiPphnnA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793336066;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=ptSgSnzSMtX/uvvclA1OH8ZyFySL1/4Bdkk3eT+VeFs=;
	b=Co9RdkUWX/6uGToUTlr2RFLcIM8NLi4HbaM1osWcAnSDTyA4JpPpndJ24DmyTVTu1iMe
	 oPtmxlaAhfR6Mj78JmTaT/7GCGs8exEHDvfaJjmF2Lha36SlqLMCT+ljtkA8YLwZmLiMs
	 ncP+AgCl855ojbakAwlhe4mbKcM/FNqa0wKBiJ5Di42uRHxEvsr0UWCUOdDmUekDmQlr1
	 5u3Z7E5t6z2asmTEz8NrvvXwC9tL6+FCPDcnpulNRHxGuVCs8UoZYZo0c95K7/Zk13pWJ
	 S0XLEY9UOSyFLPr76cUbV1DZ8p2v7oVpxgGKfa+ijt/DEogibKF8vO2JLJinyJKiEoQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kXy0zFpi;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C67C6606A324
	for <linux-rdma@vger.kernel.org>; Fri, 30 Oct 2026 04:54:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kXy0zFpi
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8097F1F00A15;
	Fri, 30 Oct 2026 04:54:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793336065;
	bh=ptSgSnzSMtX/uvvclA1OH8ZyFySL1/4Bdkk3eT+VeFs=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=kXy0zFpiy83pkDILXAI+bGo/wMfa0bIxmoGFdn+ytEOrsopu7+AwTwv0dJw6UncwI
	 QMWtkarOLhYdt1C1gjSwwrRm+eBY5sfJR0U/s/ntg95obyJD/jsk2aXDblBS/2J3ih
	 IRqp82sJULIuUAfMvzYSUIl8E01chDJ5aiKWtMnk0WX8q/WAVWdqjyd5tE7D9WUCs3
	 COMzkI7NzfIC8N/+QacUNX0mOfPB7hrYiBTZcWlE+sDjgzNTpi5AGQL7la+114FmKs
	 egkrTDzjwCOnItqCH92h/NCulIchKaTTuEzUbAEiQDt7tairYzLufclXPSeEa076b9
	 ADUxT5zOZ4Ycg==
Message-ID: <sashiko-outbox-190463@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [for-next v4 1/5] net: ionic: register PHC for rdma
 timestamping
Reply-To: sashiko-reviews@lists.linux.dev
To: "Abhijit Gangurde" <abhijit.gangurde@amd.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260610154216.712374-2-abhijit.gangurde@amd.com>
References: <20260610154216.712374-2-abhijit.gangurde@amd.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 30 Oct 2026 04:54:25 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] ionic_get_ts_info incorrectly drops software timestamping capabi=
lities for devices supporting only RDMA timestamping.
--

commit e70a276bad5dcce2118c120bed8e5cd4bc2c22fd
Author: Abhijit Gangurde <abhijit.gangurde@amd.com>

net: ionic: register PHC for rdma timestamping

Currently, the driver only registers the PTP Hardware Clock (PHC) if
Ethernet hardware timestamping is supported. Update the registration
logic to register the PHC if the device supports either Ethernet
hardware timestamping or RDMA completion timestamping.

> diff --git a/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c b/driver=
s/net/ethernet/pensando/ionic/ionic_ethtool.c
> index 78a802eb159f0..154ea1bef85d9 100644
> --- a/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c
> +++ b/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c
> @@ -1018,10 +1018,14 @@ static int ionic_get_ts_info(struct net_device *n=
etdev,
> =20
>  	info->phc_index =3D ptp_clock_index(lif->phc->ptp);
> =20
> -	info->so_timestamping =3D SOF_TIMESTAMPING_TX_SOFTWARE |
> -				SOF_TIMESTAMPING_TX_HARDWARE |
> -				SOF_TIMESTAMPING_RX_HARDWARE |
> -				SOF_TIMESTAMPING_RAW_HARDWARE;
> +	info->so_timestamping =3D SOF_TIMESTAMPING_TX_SOFTWARE;
> +
> +	if (!(lif->hw_features & IONIC_ETH_HW_TIMESTAMP))
> +		return 0;

[Severity: Medium]
Does this early return omit software timestamping capabilities for devices
that only support RDMA timestamping?

Before this patch, devices supporting only RDMA timestamping (where
IONIC_ETH_HW_RDMA_TIMESTAMP is present but IONIC_ETH_HW_TIMESTAMP is not)
did not allocate lif->phc. Because lif->phc was NULL, ionic_get_ts_info()
would fall back to ethtool_op_get_ts_info(), which correctly advertises
SOF_TIMESTAMPING_TX_SOFTWARE, SOF_TIMESTAMPING_RX_SOFTWARE, and
SOF_TIMESTAMPING_SOFTWARE.

With this patch, lif->phc is allocated for RDMA-only devices, causing the
ethtool_op_get_ts_info() fallback to be skipped. The custom logic here
only sets SOF_TIMESTAMPING_TX_SOFTWARE and then returns 0, dropping the
SOF_TIMESTAMPING_RX_SOFTWARE and SOF_TIMESTAMPING_SOFTWARE capabilities
for these interfaces.

> +
> +	info->so_timestamping |=3D SOF_TIMESTAMPING_TX_HARDWARE |
> +				 SOF_TIMESTAMPING_RX_HARDWARE |
> +				 SOF_TIMESTAMPING_RAW_HARDWARE;

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260610154216.7123=
74-1-abhijit.gangurde@amd.com?part=3D1
