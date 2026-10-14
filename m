Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5759648167E
	for <linux-rdma@vger.kernel.org>; Wed, 14 Oct 2026 08:06:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791965188; cv=none; b=C0VTKZgBVURqZMzpspFIG8Ycpr7k+K8Xv2CG2yqsLO1+09cftjLeHd0/XFH6IuwdFYBceFOawrgxvbzVFXIZlnkQhej+1gXN21baU8Ia0iuLxjy97iVcYCOWAcib8D4/IVQ3cnhjcmBHvL1R3hvZ4deIGZOoYQQ6ZYGEaUbB69U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791965188; c=relaxed/simple;
	bh=Ha5MoUdoh7kqgdhnIh5NscQadjuo7nET0BKO0hiF05M=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=f5QKiBUCqcRSZwKLZPqc5BwLMlJfVfRfQhCiYTWMRTIaGxh9PLNEVf+8sa+Ro7570cBF1/rbYdCjA9MjZ476Ga1TFclRHynseRqhxvWmQahJvga1S98Kv3P1utd7nRonxTQLz89y0WLLduc/D5KwP443pf0Ow/ONgK9NcSM6zK4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ak2bK7nY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ak2bK7nY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B94C91F00898;
	Wed, 14 Oct 2026 08:06:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791965186;
	bh=Ha5MoUdoh7kqgdhnIh5NscQadjuo7nET0BKO0hiF05M=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Ak2bK7nY6ZHuh7X8EBlSg/3gyokHqC5zctaKYGUblibUn6j6HtTIS7sIYqbMBLqE/
	 gf5TX4LUsniihuA9DtZY/lylkvzpT4DAH00fUsfDnJsYp2zSqiW27osmBf3mL93x/W
	 yETw8yzmbO4UT5D7npIQFK4iMkREafMdrvi/N9bPdyCyQkCHacA7AtOmn5T+xMQHii
	 zf/EjJktq3aZV6Y8qS7eC+N/GakfSjjAuKn4Fjsv7sLYdLl7yhg3c4LBGgmwzv9buN
	 cKgZp2AlGBtE+x1n6SYQBO+asxPpEHNnj34pK3RKB0Fz8oyEPaTvUlOGdke0QnZO9n
	 XdirVdW3INcoA==
Message-ID: <sashiko-outbox-170993@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v7 2/4] net: mana: give each HWC message slot
 its own completion state
Reply-To: sashiko-reviews@lists.linux.dev
To: "Wei Hu" <weh@linux.microsoft.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <b6a611e9de0f67b48ddde2948e257128df1e90fc.1791561995.git.weh@linux.microsoft.com>
References: <cover.1791561995.git.weh@linux.microsoft.com>
 <b6a611e9de0f67b48ddde2948e257128df1e90fc.1791561995.git.weh@linux.microsoft.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 14 Oct 2026 08:06:26 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> From: Long Li <longli@microsoft.com>
>=20
> Concurrent requests require the response handler and the waiting sender to
> agree on the lifetime and result state of each message slot.
>=20
> Protect the caller's output buffer, Linux error and device status with a
> per-slot lock. Publish the output buffer only while the sender is waiting
> and withdraw it before every return. A late response therefore cannot copy
> through a pointer to caller storage whose lifetime has ended.
>=20
> Reinitialize completion and result state when the slot is acquired. If
> the response records its result while the timed wait expires, return that
> result instead of reporting a false timeout.
>=20
> HWC responses contain only the slot ID. After a genuine timeout, prevent
> the serialized bootstrap channel from reusing that ID until teardown. This
> keeps a stale response from completing a later request before the next
> patch replaces the depth-one latch with per-slot sender and response
> ownership.
>=20
> Split response-status handling and request cleanup into helpers so the se=
nd
> path has structured returns rather than phase-jumping gotos.
>=20
> Link: https://lore.kernel.org/r/20260908035201.402424-3-longli@microsoft.=
com
> Link: https://lore.kernel.org/r/20260908035201.402424-4-longli@microsoft.=
com
> Signed-off-by: Long Li <longli@microsoft.com>
> Signed-off-by: Wei Hu <weh@microsoft.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/cover.1791561995.gi=
t.weh@linux.microsoft.com?part=3D2

