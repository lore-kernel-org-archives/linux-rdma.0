Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794325531;
	b=fI+aEeQSKnTs8Lvr/hUGWNXQUnzkxDCIwjfJ9uux7DfHrYxByZyvtpZBVgbg94Fmg3xN
	 wcvwqaKNHpBCj/aEsJfQtDNaie+1r99j/O9RqKFWpgomgxIl9Gbsu79SSsLkNqPF6Rh+6
	 AAa8PEsnoCKLe8uMf42bv3PunRhVqFKM4HzkZUWKVB2ZL9wOc62+oLBoFomaQ6kPU11Vy
	 iwLaODIvqIwSf0deHuplgOIyrF3L2r43oMfHY7W4GqafFbA1NIdp12i7OuPrGoQaMTXy3
	 i/S8Pr5AF8ApwMknjgGrduGgr2TD3UIU12tDi+Gs0io4QOGLX0gKU1zjSfmFUejDJ3w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794325531;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=DRvAWINHCO4tAK0CEPdlD4AS0MIGze+cfne8CP97g/s=;
	b=4aLKNyWDAM0YHOKij6WACtGOJxQiEe9k9aOe01/kzB8W6yVun00veAtItQZVG3PqNTK4
	 GRxevEZQYtN2F3gGRJLc+2XLGi682lObgVdSfv7+aSL5adJ5Qkyd1fAdqyTPFHa7NCLXC
	 4tGuWumc4UE/f238LOqa/IW3yulmcLKBRfPnkq8Z4BSJ1ibkBAb+PMAbMUeA1OV7zgrzB
	 OODuM8uJ+2V0ZKNGhVhNKJ4M0E145J6oKpbUjOxEREH57K7NiGy+UtpyV0BX47ronklFM
	 WqDPezlVzrCV/8gMIM2tgSIYbBHwoCTTYXZTkpRqsOZW4eZdWybKsT6RXtOn1H71OLw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ebddtLq9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F7F5606C42A
	for <linux-rdma@vger.kernel.org>; Tue, 10 Nov 2026 15:45:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ebddtLq9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADBDA1F008A1;
	Tue, 10 Nov 2026 15:45:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794325530;
	bh=DRvAWINHCO4tAK0CEPdlD4AS0MIGze+cfne8CP97g/s=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ebddtLq9L83CUD1Y4OP4qfBxwovNcyM4EK90+paBlKy/82goJwjoT2K7htI7bHQ3d
	 rzplAI/LESW4LMA5/OYJLLWppOkOr11sNtsSFZGswdC9Z9m8vALdVBGuREEsKcqy5e
	 YelfAUNO0l8QdeXXgo06yoeSRFRS+QlaPGRmC4r6iwFUPqUtdLAspEh9644pHmQKb1
	 83I/9mfd7fjQRYaZyO8h+iayMtMc6A0zRWEIA6AFHBJNvoGV0YqJLTfF5oKlvp4iUJ
	 9b/r4AUYH+W38qTFyJiO4F+abI72/s87gHU+CPpz0MluJi06BxdLKctQCbvngQq2Sn
	 0+zR/s/IsQ0Sw==
Message-ID: <sashiko-outbox-207288@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v10 2/4] net: mana: give each HWC message slot
 its own completion state
Reply-To: sashiko-reviews@lists.linux.dev
To: "Wei Hu" <weh@linux.microsoft.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <d3c71452bb2938a5c1fcfebb32d44827eaea94e9.1794208055.git.weh@linux.microsoft.com>
References: <cover.1794208055.git.weh@linux.microsoft.com>
 <d3c71452bb2938a5c1fcfebb32d44827eaea94e9.1794208055.git.weh@linux.microsoft.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 10 Nov 2026 15:45:30 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> From: Long Li <longli@microsoft.com>
>=20
> Concurrent requests require the response handler and the waiting sender to
> agree on the lifetime and result state of each message slot.
>=20
> Protect the caller's output buffer, Linux error and device status with a
> per-slot lock. Publish the output buffer only while the sender is waiting
> and withdraw it before every return. A late response cannot copy through a
> pointer to caller storage whose lifetime has ended.
>=20
> Reinitialize completion and result state under both the allocation and
> per-slot locks when acquiring the slot. A response handler can still hold
> the per-slot lock after the previous sender has returned its admission
> permit, so an unpublished bitmap bit alone is not sufficient protection.
> If the response records its result while the timed wait expires, return
> [ ... ]
> Link: https://lore.kernel.org/r/20260908035201.402424-4-longli@microsoft.=
com
> Link: https://lore.kernel.org/r/179196575434.434549.4428132041097324407@k=
ernel.org
> Link: https://lore.kernel.org/r/179196575640.434549.9102950927041409151@k=
ernel.org
> Signed-off-by: Long Li <longli@microsoft.com>
> Signed-off-by: Wei Hu <weh@microsoft.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/cover.1794208055.gi=
t.weh@linux.microsoft.com?part=3D2

