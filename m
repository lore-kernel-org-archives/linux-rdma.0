Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08C0B375F81;
	Mon, 12 Oct 2026 13:18:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791811102; cv=none; b=UgIOgVg8qZem68vIOkKq8B2W0/2CgAYLz5+nZkOXTZX/ouOiOD3dFZh1dTLs5Pk3xMgWoAPnDOSsp/73/FpjXXqHN14GMfwjITaSGQXV4IcmyB6ZLtJcf12MgxUdCQOuLtmVb+AKLYSKMUKT5KBZmoomG+IJsT3I6+YEMtRFW9g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791811102; c=relaxed/simple;
	bh=PloYP3m6dPLiqL5MoersveTlvLMJVh7AeE0KiHUrk/Q=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=ecRm1bQPU6ZW8mJ0JxtmZWV0mxN4eMkVkhEpGrM5e+8+B4/sLvcuhq0RSZp0X25EWQ0qVwW3SP43q7xHR2hlXftViZ4zCsa3DoYjJ/mmMweNozA5lZtP4TaQG2mhq17/jSMBh36vkGupYdUtuYtFJk74EcYGIOzcQqCY+I/nkf0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ESCqcYMJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ESCqcYMJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E9D91F0089B;
	Mon, 12 Oct 2026 13:18:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791811100;
	bh=PloYP3m6dPLiqL5MoersveTlvLMJVh7AeE0KiHUrk/Q=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ESCqcYMJ3fgb+RPmLjYWXEiSm6Z0B9WiTdX0etnWbRUzHs5iW3+oXHsiFjx3VvXtk
	 YOj+7Y0V84hLjlHAwuBtCatUPXRsO2Aae8NqbrR5+Az3/YXfGfQBkbJo7AyQJnCa59
	 XeQ1WDr3ZeGTgXQECHI0F10HSSzq7bk2oWkeJZI/cM2GgWd7Raq1e8n+SuX/GUtpKb
	 5cSjBvGszjIL4nHoW2ULLzZZ3ykRLxnhf9Pj0svevq5YXu1ek85nEG2FK0qcnSg9Ni
	 484qAaeTtpmmTg78q8PMDsCqc8errW+HYpjhouRfrzyVsPHUcpz9h+OTmZmTeW5lAy
	 SERlPILrOmFWw==
Message-ID: <sashiko-outbox-168161@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v10 08/18] PCI/P2PDMA: Route Relaxed Ordering
 Completions directly
Reply-To: sashiko-reviews@lists.linux.dev
To: "Leon Romanovsky" <leon@kernel.org>
Cc: dri-devel@lists.freedesktop.org, linux-rdma@vger.kernel.org, media-ci@linuxtv.org, linux-pci@vger.kernel.org, kvm@vger.kernel.org
In-Reply-To: <20261012-fix-p2p-acs-v4-0-v10-8-6ffe7b7a4517@nvidia.com>
References: <20261012-fix-p2p-acs-v4-0-v10-0-6ffe7b7a4517@nvidia.com>
 <20261012-fix-p2p-acs-v4-0-v10-8-6ffe7b7a4517@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 12 Oct 2026 13:18:19 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> From: Leon Romanovsky <leonro@nvidia.com>
>=20
> ACS P2P Completion Redirect leaves Completions carrying the Relaxed
> Ordering attribute alone. PCIe r7.0 sec 6.12.1.1 redirects only those "th=
at
> do not have the Relaxed Ordering Attribute bit set", and sec 7.7.12.5
> describes the enable bit as "applicable only to Completions whose Relaxed
> Ordering Attribute is clear". P2PDMA reports one answer for every kind of
> TLP, so a client that sets Relaxed Ordering on its Non-Posted Requests,
> and therefore receives such Completions (sec 2.2.9.1), is sent through
> the host bridge for a redirect that never happens to it.
>=20
> Route Completions directly for the classes that set
> PCI_P2PDMA_TLP_RELAXED_CPL.
>=20
> Reviewed-by: Logan Gunthorpe <logang@deltatee.com>
> Tested-by: Tushar Dave <tdave@nvidia.com>
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261012-fix-p2p-ac=
s-v4-0-v10-0-6ffe7b7a4517@nvidia.com?part=3D8

