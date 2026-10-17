Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C7E61891A9
	for <linux-rdma@vger.kernel.org>; Sat, 17 Oct 2026 15:39:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792251565; cv=none; b=VXXvuXRunP1nH/ejV2eTax0rVnFLyoJYorGfu2+K3WZvKdI5LUPQ5Y99PUyI5DDgJhqyMWVsLApwjLESpQPd3cPWDqWu4/6eP4d+7R4m8aUg8xO2dwpQkjpQlnmSDpKO1KOFd5VoDRV+sywmHCNqlCzC+Sybz/t4cqY6RrxSavw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792251565; c=relaxed/simple;
	bh=g3Y4nuTPwRGELD2GnhswOBoOGnLF3J+r8RuxjzAocx8=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=jZEDhxYww3oTKqq4AUh5PnOTaamShkAvppWNz9ZcjKQhJOSngKI1c1LlMpCxDyHRgGK+rUIoT8IKBB1gXXy73ufqTHx/K+cjIVK3S3HAAPGyMkeQ7HCz0nJuUraKjuCnONlozfJFbbFyOs4K/7Nt2/TH7yh+sCNF9+ch9EHzZ2Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eFl/Ubl8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eFl/Ubl8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB9481F000C4;
	Sat, 17 Oct 2026 15:39:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792251564;
	bh=g3Y4nuTPwRGELD2GnhswOBoOGnLF3J+r8RuxjzAocx8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=eFl/Ubl8iw4TGLrcZsN2vgahNPtID3FNtrY3fgQycJz8Gx7f0Zg5SCBPp9ek1InjH
	 Igg3oxF5Wp6oSbnlbR9Ja7bpn4Jx4tlDGR+g8E/YrHjo8X963YxUu5d3topvNi3ROw
	 GmDXmp2aDUpAQJGG4f8DecnjZt4gFysoyW9w8uwq+ryvEn3Fds/v2bIFHZi4IgWzU2
	 9uzIZvXZ8FtpWx7bGxsYSadxi9rfzMBwuWmRYoCMumR9pGIC65ZkSJ5iSThv5uXRPY
	 lBQ6hvCbf0shL3gFW/X1FfNNb7Az2dZ57YLyDpSrEkz9q/Ia7GraHEt/usJPzWp5PJ
	 SngCEd2tRy8aQ==
Message-ID: <sashiko-outbox-175601@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v7 01/13] net: mana: add queue-set allocation
 and teardown helpers
Reply-To: sashiko-reviews@lists.linux.dev
To: "Wei Hu" <weh@linux.microsoft.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <05911ee531022aa0103a35b45a70995aad74dc71.1791710735.git.weh@linux.microsoft.com>
References: <cover.1791710735.git.weh@linux.microsoft.com>
 <05911ee531022aa0103a35b45a70995aad74dc71.1791710735.git.weh@linux.microsoft.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 17 Oct 2026 15:39:23 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> From: Long Li <longli@microsoft.com>
>=20
> Add queue-set allocation and teardown helpers using a scratch port
> context without releasing the vport. These prepare reconfiguration
> to retain its running queues if replacement allocation fails.
>=20
> Leave ordinary mana_dealloc_queues() byte-identical to the pinned
> base. Do not introduce reset generations, sibling-port rebuilds, or
> an incomplete independent failed-FLR TX-buffer policy change.
>=20
> Queue-set retirement itself performs no function reset. Its caller
> must drain old published TX queues before publishing a replacement;
> unpublished sets have never admitted TX. The first live-swap commit
> adds that nonresetting pre-publication wait. These helpers have no
> live replacement callers yet.
>=20
> Signed-off-by: Long Li <longli@microsoft.com>
> Signed-off-by: Wei Hu <weh@microsoft.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/cover.1791710735.gi=
t.weh@linux.microsoft.com?part=3D1

