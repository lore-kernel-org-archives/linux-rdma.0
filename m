Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793874064;
	b=eJwzialHxGM1Beb5FFAQjZLDI5FmeVbIaa6vd8vubfDuqUjszcInPAnaZEHvbhA/noqk
	 BeMApXifgjTlbC2U0CC7DGgYmi4TfRjcyORstaY9KqKI3lLocXoYtBCwasSCYaA4Z/CKh
	 q+9xi1g3HvHpxdnf2lYN4sCXtIw0glJTVSfIRIIRl3oBNUgy4wmExaW+k+ABA3/BfdSdz
	 2IeR+rM4AqryklNJCR3QKJPCx3UrV0l+ss47mpHp5k0pb1LgFfpjFNZ7GkdHUHv2pHAMh
	 ZuLXmQz0vfLWUTTFpV2XU0IBHT15sTHs3WWLoXa2ZrG1XQLK943wh0Ze+oKLtGbp68A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793874064;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=+CP6P+FVcHKMcgujTyBiP1GwXlEMg1lvCxtYdOtHw34=;
	b=azAL/wIx36K7OMDZ0/JO2V9g3RynCsFYYL3kJMAkOkAjGYPIq+sca2u2rWZW8bFyRKSA
	 v77Bd1ZvKiTdNa01DSsswgXHsrxEyUDZ3EgZwxjWhubluqSzbsqBi4VJA51BQWL7pUv6J
	 qVlwQiBMBvfAh05jJ3cIhZFaP10V3jy90qkzkCXSrLBK1bI33WGwtMHzm3CK+5V7GUvGs
	 cxYxXK//ZC2TYjNvHbMeeMdqkVcMfrJwZ6Ja9NcmsrMDHo3WOuw0rbPQEpYF3lKI3svrq
	 rGvorQcDpdQW21OHDrTmCiqU4OmXjM0GR0tRCHEEtcM76QlKsg3/qCu3Vf48yo/OPYQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=fSGyKhf1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA074606D822;
	Thu,  5 Nov 2026 10:21:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=fSGyKhf1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71B691F000C1;
	Thu,  5 Nov 2026 10:21:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793874063;
	bh=+CP6P+FVcHKMcgujTyBiP1GwXlEMg1lvCxtYdOtHw34=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=fSGyKhf1wMcbq9UeRyrM99caZjiTFQf8jKBNlF51DJqzll9c88o6VYYW+qlkkS1Db
	 MvFDB01+jdEhFnxT0mFwTgkbu08i5xbaaHISEfdLP6hFylAzj9CBrI33k0ipv49Ksw
	 n11J7YDeuTZh4MF4bdPr02JafETtTA1zSSPIKR5L6GeyU1HSgESrrDMKP5b/eSapRe
	 a04dBGMQZ18EwNP8Fg8NkMxx5yqfJHO3R5CT6W6/yWCRuY7kOtR7t8SLdc3plFWPTT
	 1IdtI87tJye5OTfXxPtLRzkeg6b8E0r9e3DDpuLxAMKLjF8mk4wjxI5CR36vctE9f6
	 uXMng/3NLfBLg==
Message-ID: <sashiko-outbox-198842@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v13 05/19] PCI/P2PDMA: Evaluate ACS controls at the path
 divergence
Reply-To: sashiko-reviews@lists.linux.dev
To: "Leon Romanovsky" <leon@kernel.org>
Cc: linux-pci@vger.kernel.org, linux-rdma@vger.kernel.org
In-Reply-To: <20261105-fix-p2p-acs-v4-0-v13-5-3dd065907c3b@nvidia.com>
References: <20261105-fix-p2p-acs-v4-0-v13-0-3dd065907c3b@nvidia.com>
 <20261105-fix-p2p-acs-v4-0-v13-5-3dd065907c3b@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 05 Nov 2026 10:21:03 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> From: Leon Romanovsky <leonro@nvidia.com>
>=20
> ACS redirect controls below the path divergence reject valid nested
> topologies, where traffic already has only an upstream route. Sibling
> functions can lack an internal peer route even with redirect controls
> clear, so ignoring their shared ports can incorrectly permit bus
> addressing.
>=20
> Evaluate directional controls at the divergence and account separately for
> unsupported internal routes between functions sharing a PCIe link. Check
> Upstream Forwarding at every shared Downstream and Root Port only when a
> host route is needed. Reject unreadable controls needed for that route,
> and keep redirect advice when clearing controls restores a direct route.
>=20
> Fixes: 52916982af48 ("PCI/P2PDMA: Support peer-to-peer memory")
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261105-fix-p2p-ac=
s-v4-0-v13-0-3dd065907c3b@nvidia.com?part=3D5

