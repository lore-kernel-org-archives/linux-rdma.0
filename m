Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88CE43F23D0;
	Tue, 13 Oct 2026 14:38:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791902332; cv=none; b=brGEfkGnMnaOAd9CI5YGaIfJ56S/5UwvIwz9Vn6ZG+/R783Vgxw7b55fqdBOpH2g5KmauHhS/G799ckGoDzLCGsxG336cM379HyIjDjMcGc0Rs0CE7WIrkN9/E1Oo2ay3GyQHdepQinAvvHSvRre9YHdt5d8u+ZbO3k/OUCzYNM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791902332; c=relaxed/simple;
	bh=GBGraetRNnAWZk7RNEv2ehPIlKr9CdBrJsF86A8sm2E=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=f/JeeaWfPIkH7nEi9J5+zy4Iba2WX3v9FtiIrtOWNpPdoYyRoFHMhpu5Ldf0ubRv8iJqOWIx5nN0+BnWQryOz6BQ8JEBbsPOq2nXBK1xAWjEwWxnTJ3Hpai4IKoljNq0dvMghHNNYzKtqtmZG8jIfJBMsf0qRWjHM2upYyTQA48=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UNOwY4k0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UNOwY4k0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE40E1F000FF;
	Tue, 13 Oct 2026 14:38:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791902331;
	bh=GBGraetRNnAWZk7RNEv2ehPIlKr9CdBrJsF86A8sm2E=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=UNOwY4k0e3iolXIAFyU6Ol6Kjqk3Q+aSxhh2pV5ZJB5tbLRm+OZMkCsueJsJQJVwR
	 o5ZZhKgHl5jGul9P7r4fJqMsNYgQDAczzU31ZqnLYPC0TTOvUuErpWycAsY1w87kxy
	 ka4tHsq68M2gpsyFDo7iYYkAAMUTfqJRpH4iUGi3maPSUxrP/ZBVQsKfSsP2dI/c1t
	 cp0ldjCZJav/msqOzVC2K9qGYS/Kw+5hKHQAjdkzJTvUEp/tNXKNM0vBjm498uNjex
	 lwWKqnlCHmhYfsWMV0ZqoxNm3G00lkIALVV4dzO0nN5Kxf7slMDdu1TUqRdwHUuNUW
	 QswApJnoJblyw==
Message-ID: <sashiko-outbox-169924@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v11 05/19] PCI/P2PDMA: Evaluate ACS controls at the path
 divergence
Reply-To: sashiko-reviews@lists.linux.dev
To: "Leon Romanovsky" <leon@kernel.org>
Cc: linux-pci@vger.kernel.org, linux-rdma@vger.kernel.org
In-Reply-To: <20261013-fix-p2p-acs-v4-0-v11-5-72cf8c96e617@nvidia.com>
References: <20261013-fix-p2p-acs-v4-0-v11-0-72cf8c96e617@nvidia.com>
 <20261013-fix-p2p-acs-v4-0-v11-5-72cf8c96e617@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 13 Oct 2026 14:38:50 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> From: Leon Romanovsky <leonro@nvidia.com>
>=20
> ACS redirect controls below the path divergence reject valid nested
> topologies, where traffic already has only an upstream route. Sibling
> functions can lack an internal peer route even with redirect controls
> clear, so ignoring their shared ports can incorrectly permit bus
> addressing.
>=20
> Evaluate directional controls at the divergence and account separately for
> unsupported internal routes between functions sharing a PCIe link. Require
> usable Upstream Forwarding through their shared ports before considering
> the host-bridge route. Reject unreadable ACS controls.
>=20
> Fixes: 52916982af48 ("PCI/P2PDMA: Support peer-to-peer memory")
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261013-fix-p2p-ac=
s-v4-0-v11-0-72cf8c96e617@nvidia.com?part=3D5

