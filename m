Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA5073A5438
	for <linux-rdma@vger.kernel.org>; Sat, 17 Oct 2026 12:06:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792238807; cv=none; b=CZhJbWbYsrTK7mzapxeeff4bXeqsKjBaAfLypHcAoZzp+VwNNqj5ncCBGKpVGfEWAPvdk/k4qrdIZ9galwjWcVZhMu+2otw7c2CKVcSz/LR8aaZpNc6Kk9bzDISl9SBw2UD8yNLjwRflZSnOJ4EIoX0lgWfjTLNsQD4TV4MZtn4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792238807; c=relaxed/simple;
	bh=hkVo9pPVm+n88E2RgRM4jiVyxR3fyW8sIVm76Fcl3d4=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=sNONymM1R/5vnVKDYjM/M7tWnVvjk4SesxYR9XG8ec82hh9Eq+XI9m1yQL7NIi2cpqTr/krcUIeBo/0fk5kBNKTrpiQ+rPUXH+ZnbRFB8LaMshB1dxqkFIo3n2jTNS1lsPyjLYD6rQX/vO4A+oyg5L0TIl7ByWxCT4/B7mYDnZo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PeDElv+m; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PeDElv+m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A00531F000C5;
	Sat, 17 Oct 2026 12:06:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792238806;
	bh=hkVo9pPVm+n88E2RgRM4jiVyxR3fyW8sIVm76Fcl3d4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=PeDElv+mqte+ytsUot8aF2kAC76gts6oH6J1B9Rf08eDSHH03gW9skzfHpKrWHJ74
	 MCRuHczRY2+sz72zqSBPiD9YVtQucBCP+U0DyChucQ6wpVAykcykx3s4cba9sdipSZ
	 vT4V29nqtaR/3xAGIztZDBaH1Ibi+qMtDJtXAC6uFGtJ5r7HnM7Xx8HXIrb+JFjsHB
	 v7dD/JWfErRhfuUPvE9hxXtNVlRvBTMYel5Ar9fDGI8sTLavQvNXbdE4M1fgJeW22N
	 yPjdPzf8kYUZWfhgeiNwfB6e10IsGVOQT91lO6z0wUB2GNMETTihXOZg76AoVDce3p
	 fZFWJFRYDA+hg==
Message-ID: <sashiko-outbox-175500@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v8 2/4] net: mana: give each HWC message slot
 its own completion state
Reply-To: sashiko-reviews@lists.linux.dev
To: "Wei Hu" <weh@linux.microsoft.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <6e6a337c466b86d93c52ea0adb5c7121ea3e9a7e.1791998462.git.weh@linux.microsoft.com>
References: <cover.1791998462.git.weh@linux.microsoft.com>
 <6e6a337c466b86d93c52ea0adb5c7121ea3e9a7e.1791998462.git.weh@linux.microsoft.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 17 Oct 2026 12:06:46 +0000
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
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/cover.1791998462.gi=
t.weh@linux.microsoft.com?part=3D2

