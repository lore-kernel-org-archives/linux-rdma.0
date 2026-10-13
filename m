Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81DE35038E5;
	Tue, 13 Oct 2026 14:44:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791902700; cv=none; b=hvihzblBy8QpkfdeTVzCN9rhp4TObrnsy1KfXipWZ4agHu1kO+G2qRMq/RPTXwoEVwastDzzjKH8cZbtLFVFJGKHXG93ZOxqSWczyoGhinLRL98IL0UTl0Et4IesZkg7WPpy5Y/5u07xaR8VyuME09C9YYZzIvJDn8uW4ewCG+Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791902700; c=relaxed/simple;
	bh=T5Yb9Gaa7pDyYyV58ID8SZiwFxPqMfOROabOzIBUz0o=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=liyhMuUI15i5IYng7lxIn/2YmGvgCXhyMjHe7d5n0xlf/vTWt583I8CEQgDy1nxss/ZlL0WW6cImSQak+v7qBWpKt4/2I7fJA1mr6YcnTZgzdDuhI2n6yCgQp9E6fPqJ9ld5+JezdOQ+MSOLm13//vCQERra2LGSHw8yr2qMNMk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mXLMReCA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mXLMReCA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2A641F000FF;
	Tue, 13 Oct 2026 14:44:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791902699;
	bh=T5Yb9Gaa7pDyYyV58ID8SZiwFxPqMfOROabOzIBUz0o=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=mXLMReCAWsApSwptlT2jf323X7OG/1uSDO+vLSsd+goo5dkc+iAIMu0yIOMMsoEBA
	 T/PBS99UgEu0ns/k42R3Uq2DC5CdbyJWmE2oXdN5Z8s5SRP17/YDiPtpKTDtUSJGTF
	 72KF/Qy2hwfnpN+Y4K3btpglPqDhrzDoE4YdBT1v2iJzJMB1Nd1LdJqiUMh9EuXJQA
	 XNYda5nE+mIQpH3XV5ZEk5vauyVAT5Ms0aG6CBqD+INQnxklHrTtqYqMOe9GQHhvGL
	 LnLBdn561HQxZNT1OuNcT5KBOX1GW7cGTzeFO14lkjhVSuBQr6sfeBEDoY8Dkg16vG
	 bebbznvPWfVWw==
Message-ID: <sashiko-outbox-169931@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v11 15/19] PCI: Add KUnit coverage for ACS isolation
 checks
Reply-To: sashiko-reviews@lists.linux.dev
To: "Leon Romanovsky" <leon@kernel.org>
Cc: linux-pci@vger.kernel.org, linux-rdma@vger.kernel.org
In-Reply-To: <20261013-fix-p2p-acs-v4-0-v11-15-72cf8c96e617@nvidia.com>
References: <20261013-fix-p2p-acs-v4-0-v11-0-72cf8c96e617@nvidia.com>
 <20261013-fix-p2p-acs-v4-0-v11-15-72cf8c96e617@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 13 Oct 2026 14:44:58 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> From: Leon Romanovsky <leonro@nvidia.com>
>=20
> Direct Translated P2P does not weaken IOMMU isolation because a Translated
> Request carries an address supplied by the IOMMU. Config-space reads that
> fail or return all ones, however, leave ACS state unknown and must not
> report isolation.
>=20
> Exercise both cases with fake config-space operations. Also cover missing
> and unrequested controls and a missing ACS capability.
>=20
> Tested-by: Tushar Dave <tdave@nvidia.com>
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261013-fix-p2p-ac=
s-v4-0-v11-0-72cf8c96e617@nvidia.com?part=3D15

