Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB0444D0A18
	for <linux-rdma@vger.kernel.org>; Thu,  8 Oct 2026 18:16:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791483419; cv=none; b=NRrRwHmGWEn6uEWFFj8g39DhnduiH1+IJGYFUYZuhv2M2VRms2PNdOql5NudR5M1kBEvl/LlM6e+i23upcFcKv6Ny5soEB+oEMDBphVf+eKdxHX+ismubELPoTesgfkz7PNuvpYSk2XPckpVmdKsywjXd2HBpfiE+p/Wist1bDE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791483419; c=relaxed/simple;
	bh=AAYclzb1zwLC5cPKegK059A74HPoLXguVBAh0BzYBLo=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=YnmjPj5sodf6mfCFMaeFSL7KPCWNJ2IGDqscjID8xv10dxUkIK06WGPU8WlTLve+p6VcwBDsw2TENjpM9CUGpbc+4hoYKZdSCEbcpEPST5dglBxg308yYuT0We9LPl7R+7yvsyPxi9q35qFJIEPerQfFwrJH7YgLA87NQIMFdMY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ToG+OGah; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ToG+OGah"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68F021F00893;
	Thu,  8 Oct 2026 18:16:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791483418;
	bh=qAe15mq1BpzxwIcVhWzI0A40fMUDDC1KdVZ7WBl9XRY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ToG+OGah2ToHux6TxOw6XacdvmU2BN/8AQlUB6/RfVE2xS90n772zKbtG7OvfqD9B
	 qeYFdwkCsRNWdc529yE5YOmjM4/JXcjDqgRoYDY7cg+XM5Cz3pQ+brjqwKeE5i0wFd
	 ZZlwLIVJ2ekuf402jXH2OVHP1sz1w4Cp6ql8refU1TRAqPW6j9ypYlR8oMW/ID4Yv7
	 PlXxg89A53IsyzDCs4RirUloLxfar9T5ag9dq58hco90CivJ6i7ObS3FgnRoOoyR/D
	 ICzMe5Qtwg8jSPb6bK+yV8JNskbN8NbxFRGhIDocSvVGoJPv4bh5shGAvNxnvpo00Y
	 eBoAMCCsefhaA==
Message-ID: <sashiko-outbox-164446@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next 2/9] net/mlx5e: check for failure when pulling
 the Ethernet header after XDP
Reply-To: sashiko-reviews@lists.linux.dev
To: "Josef Bacik" <josef@toxicpanda.com>
Cc: linux-rdma@vger.kernel.org, intel-wired-lan@lists.osuosl.org
In-Reply-To: <20261007-b4-pskb-pull-tail-drivers-v1-2-9512b0fb977b@toxicpanda.com>
References: <20261007-b4-pskb-pull-tail-drivers-v1-0-9512b0fb977b@toxicpanda.com>
 <20261007-b4-pskb-pull-tail-drivers-v1-2-9512b0fb977b@toxicpanda.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 08 Oct 2026 18:16:58 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> When an XDP program leaves less than ETH_HLEN in the linear part of a
> multi-buffer packet, mlx5e_skb_from_cqe_mpwrq_nonlinear() pulls the rest
> of the Ethernet header in from the frags with __pskb_pull_tail() and
> ignores the return value.  If that pull fails, eth_type_trans() later
> finds less than ETH_HLEN in the head and BUG()s in __skb_pull().
>=20
> Use pskb_may_pull() instead and drop the packet if it fails.  Pulling
> min(ETH_HLEN, skb->len) keeps today's behaviour for a frame shorter
> than an Ethernet header.
>=20
> Assisted-by: LLM
> Signed-off-by: Josef Bacik <josef@toxicpanda.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261007-b4-pskb-pu=
ll-tail-drivers-v1-0-9512b0fb977b@toxicpanda.com?part=3D2

