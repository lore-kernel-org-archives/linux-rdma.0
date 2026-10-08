Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B085F49B5D7;
	Thu,  8 Oct 2026 12:54:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791464045; cv=none; b=bcMy9vCd4InToNuCGGoM2ZGe8oTsi5engxz+tjgOJmwJn4Xup6JOpuS2114dDulRNqLuAUWDrCj3D/kMrEgqwTXaOA6Rf1dZubx2f3vdySsU5layRWYEnazpVbuiY92dUesxK4OeWQnMj2/Nx9qLZOP4W64apH5Tu1B+5/yS5MQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791464045; c=relaxed/simple;
	bh=7bfj7AyTL/zmGP8FIqqLqEtrx5SPfm7jaeWMD4rGd2Q=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=WcwYmwtqtW2FEif3kQodwGEreiUHxM0B/Zu/xnPaAV+nGaFHgTWhG2ndlJke5Nu42SAiN02gqmKZNahSHEwtv6YOPC6Q/3V4wHlwnhYfD//QC37qYIHD4M7LT2lEdcs3Mcevt2MqKHkZFbu9yHCv/ub482r7CxDrrjIliheOIok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HuzH5R44; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HuzH5R44"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5652A1F00893;
	Thu,  8 Oct 2026 12:54:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791464044;
	bh=7bfj7AyTL/zmGP8FIqqLqEtrx5SPfm7jaeWMD4rGd2Q=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=HuzH5R440E2Om5Q+vG3Sye8Hz7t/LGBazG+yqenaVdPFT0RHaoL2LpjFMJUYzEFRr
	 Jif5F+M2F0MiuaM77JOHmWbL/hSHWhTXTce2w0sSSIJe9NNhdPlBHLaRMCJA0Zpxdv
	 QYymXvh16eC2gYV7inTl0Wc45M5gfS4PqSwxc7bXnainEMaWwwl5k8n/bbWLcrIWdc
	 EOTe+CoR/Kwe5ZEu6jXNEgL340HDBVlVa6QrdB1dGz2uUqhzueX+pRd3k66EcmXS7W
	 J8x7SpS1WIYftKhMWSmJ/q9EYBwlFXkzjvONvZdDibp2oaRgPwEbSCg/WBRWryU6VR
	 pktd+MV0Dlsxw==
Message-ID: <sashiko-outbox-164179@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v6 2/4] net: mana: give each HWC message slot
 its own completion state
Reply-To: sashiko-reviews@lists.linux.dev
To: "Wei Hu" <weh@linux.microsoft.com>
Cc: linux-rdma@vger.kernel.org, linux-hyperv@vger.kernel.org
In-Reply-To: <58fd3296e5fa48a9fc91eb4059a4f4162d4d8479.1790670523.git.weh@linux.microsoft.com>
References: <cover.1790665894.git.weh@linux.microsoft.com>
 <58fd3296e5fa48a9fc91eb4059a4f4162d4d8479.1790670523.git.weh@linux.microsoft.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 08 Oct 2026 12:54:03 +0000
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
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/cover.1790665894.gi=
t.weh@linux.microsoft.com?part=3D2

