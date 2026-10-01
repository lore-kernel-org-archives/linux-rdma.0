Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21DC34B8260;
	Thu,  1 Oct 2026 12:01:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790856116; cv=none; b=Dd4oAYSNRb7n1PlC8zQlFU/O9VjR3lq2s3RHFeYHtzkw0hOkE9KifacugRfU30Nw7cuiflFH837wErT7IC5L18eZq5XT/coYmLnelvWtoM7R5sMqcAJJSnLmv9Cq+Yd9bpEWPM5AGZfoa3m3mDGEcQe8+tMaIw0U9Clqa93OfjY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790856116; c=relaxed/simple;
	bh=CQSTihuvb/SazjypSDkBT7pkKSV2l50EwDS1UfOSrTc=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=WXE504AmjsmOhwEh8Po9ybTIHm3uhqRXR+lh6wPL5nY4kPpgvzAGsm/vLfZ0uBCydD8RbRDUQ56t21KdC3efDMfcmhDQ9IwY8fkO1pC9b3ajpdpGnbwaPZuU/wHSYOvftOZ7jIDyDyOIvGlS4idz6xPyf7GnR5bgfhUS/oxHi3I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iPeILIQY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iPeILIQY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C8571F000FF;
	Thu,  1 Oct 2026 12:01:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790856114;
	bh=CQSTihuvb/SazjypSDkBT7pkKSV2l50EwDS1UfOSrTc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=iPeILIQY1rAYJYQuur7i29DQtkJesf77WMxcHo97Qf+yZ0M1gjZLAcMt39pYJrgz2
	 2pbjcD8uwgGmbkPKULoT+2KAdLa19bK1EfCGhc49NqL+T4s8WLSXbeoycd6C50MMUJ
	 ih0HrWrobMq4T5DXiRX7nOOCs1n5DT1pMp4ojo7iA2z6irhkI1K81fKJaTuTqK3Mu4
	 btcxhoo6d3VAUcdNk3efSEMGfNCaZLcudqUe4Xo5ic9e+Jc4te5Q8PG/3z6WXFLs3f
	 u8HHCf6RcmBqsy1xcmWr7qVYD3wZQ0FH3Ge/J065VeezpLTbwCkRj5lox6yGDN8h5R
	 TWr8DWrIe5Idw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v9 12/18] PCI/P2PDMA: Add KUnit tests for the ACS
 routing decisions
Reply-To: sashiko-reviews@lists.linux.dev
To: "Leon Romanovsky" <leon@kernel.org>
Cc: linux-pci@vger.kernel.org, dri-devel@lists.freedesktop.org, kvm@vger.kernel.org, linux-rdma@vger.kernel.org, media-ci@linuxtv.org
In-Reply-To: <20261001-fix-p2p-acs-v4-0-v9-12-1a8e0f50ddd9@nvidia.com>
References: <20261001-fix-p2p-acs-v4-0-v9-0-1a8e0f50ddd9@nvidia.com>
 <20261001-fix-p2p-acs-v4-0-v9-12-1a8e0f50ddd9@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 01 Oct 2026 12:01:53 +0000
Message-Id: <20261001120154.5C8571F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> From: Leon Romanovsky <leonro@nvidia.com>
>=20
> pci_acs_p2pdma_request() and pci_acs_p2pdma_completion() turn an ACS
> Control register and a TLP class into a routing decision. Which bits apply
> to which direction and which class is easy to get wrong, and hardware that
> exposes a given combination may not be at hand.
>=20
> Drive both from a table of register values and classes, covering the
> redirect controls per direction and Translation Blocking, Direct Translat=
ed
> P2P and Relaxed Ordering. Direct Translated P2P gets a case with and
> without a redirect to override, since it changes nothing without one.
> Exposing the two helpers moves their state enum and the TLP flags into
> pci.h.
>=20
> Tested-by: Tushar Dave <tdave@nvidia.com>
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261001-fix-p2p-ac=
s-v4-0-v9-0-1a8e0f50ddd9@nvidia.com?part=3D12

