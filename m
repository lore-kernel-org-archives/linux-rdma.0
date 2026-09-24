Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0F2D4BC009;
	Thu, 24 Sep 2026 17:43:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790271793; cv=none; b=ZLzhGcIAgnuBv0AFAIZHmZCqAD2d0r1p1YhjJtKxTvl514hH/N/nag0KpHoqiZRZANFd85duWOfYLxORHONOCP+k1kAlzsSyGFiwRy4vRuIJkG45tCdfuxekaYd1LXrT/VHd3ulmLKHVxd2T3yQ9amsE/1hM/NJt8r/tncZlmiE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790271793; c=relaxed/simple;
	bh=p4/x1jKDHwfl1gP6Yc3r66dO7l61MEJys8RiAtqw+hM=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=RPoBPnZdHSlwqsHpHxbHzlfrbvEjvkiUo9vxagfW0lMwCf+xhQJnHF9I0ucruTWTIq6wvqAoQ9lFIYtk/DuKIeXilYvALMS8eif1c1JWZDDOFg0lrXjc8Yduuqqw3RrTOJjnsEvsF78GMrAoj6PKRrS9RXaQ2RrNqFNvgb4hfmI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=J9qp/6GF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="J9qp/6GF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E3A61F000FF;
	Thu, 24 Sep 2026 17:43:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790271792;
	bh=p4/x1jKDHwfl1gP6Yc3r66dO7l61MEJys8RiAtqw+hM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=J9qp/6GFzSyqtFQZ5g/nEIL5RRl5BjOLB4pccH033YqNDqaWIdgrUhCuxFpj9fdaj
	 iXNgjIqDlU2ufPJvUKQDXtylSewz2YM73zOqoSHzyJJRCeHrbxkXIL2Fxfa1LmGP22
	 T+eoQsDycxktJwH/0QYv+Ju2HThWQgbaT/WT63M/LF8HH3rZGMyJVlIC8FvJnoOtUq
	 WWAQsyOMYVor0FdHNoGje9rm4afEbz7Icqj4Id6R8FvQmEg27TfEBGQg12EocAhu+H
	 lxPTv5dCt8QPVBfE6hIGUsACwxrbQ0DAthdu65T1j2Swv06rDnF9zuj9S+JvvF3gCa
	 RXfepAHwvkW2g==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next 4/4] net: mana: Add support for CDX device ID
 0x00C2
Reply-To: sashiko-reviews@lists.linux.dev
To: "Manish Awasthi" <mawasthi@linux.microsoft.com>
Cc: bpf@vger.kernel.org, linux-rdma@vger.kernel.org, linux-hyperv@vger.kernel.org
In-Reply-To: <20260924173054.589291-5-mawasthi@linux.microsoft.com>
References: <20260924173054.589291-1-mawasthi@linux.microsoft.com>
 <20260924173054.589291-5-mawasthi@linux.microsoft.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 24 Sep 2026 17:43:11 +0000
Message-Id: <20260924174312.2E3A61F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> Add the CDX transport as mana_cdx.ko for device ID 0x00C2, using the shar=
ed
> gdma_core.ko. Allocate interrupts at probe, limit queues to available
> vectors, use 32-bit DMA, and keep CDX auxiliary devices separate from PCI.
>=20
> Signed-off-by: Manish Awasthi <mawasthi@linux.microsoft.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260924173054.5892=
91-1-mawasthi@linux.microsoft.com?part=3D4

