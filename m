Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B48549EC55;
	Thu,  8 Oct 2026 12:54:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791464046; cv=none; b=Pjvg5/OoR/u/dFhA897hlRKS34WWShrIqNb/4UVtzxLNoErBbI2kCgllPcGDbc1qSEN+XTz3j5bxLcOIdFiI2/1zuoXwi7kOYbNKSgFTK1tYR7GX13ha2j3raGw30O+OkqOBYfXrghbkpISw2p/fS75VD4jVx5Ej9bbhfRZC2Ic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791464046; c=relaxed/simple;
	bh=wbx/v7dn4qGJ7W9jrc2kLOYqQqDHnYXf/jJLAs67Qgg=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=EAgnbpvOiOp5BGyTmnCo7optg1rHoGEjODfaPj8uVw8zV2QClMfBtwFgENI5WnNMuFe0MvM3sFygxuAenXg8LhUL712uWrqO5qdd5GdtoQoGCf8YWkMFmX7D11ka9p1TqAjQ4PFJc4gmw2f6mIZcS1m8s6OmNv+UO4S7Qw9jsME=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cSUbLz1w; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cSUbLz1w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 093951F00898;
	Thu,  8 Oct 2026 12:54:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791464045;
	bh=wbx/v7dn4qGJ7W9jrc2kLOYqQqDHnYXf/jJLAs67Qgg=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=cSUbLz1wvQJZ+iN4pX1xT4dJgFbuDVGMACGqCAmVAHlEzf2bP6lLOwk8sUMrJjWRI
	 FI9vXsn8fD8iOOi1DnvI1TlkrvNy6/BJTK2fUp2az//AyHslvxQnl+xeed7r6e1ZT1
	 R9/urpx2d+xCubwfAyaUENv5GJF64y0lrxb50vGznZSeCmFgXEPTxlommSipeCno6h
	 b4r+bnjvclZ2BwseWmXtxH6iV/z5604Dv0LhY7h5K7YHu6QScKzSiLiQ2tjwpiP28u
	 T9uV/yAGThITOjSHO8/4/WxpQ6JuDr42ys4W+Y4ymA+PISnMxnQIp63RgJUpu0W9cE
	 TRGrS3PFUT0VA==
Message-ID: <sashiko-outbox-164180@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v6 3/4] net: mana: support concurrent HWC
 requests
Reply-To: sashiko-reviews@lists.linux.dev
To: "Wei Hu" <weh@linux.microsoft.com>
Cc: linux-hyperv@vger.kernel.org, linux-rdma@vger.kernel.org
In-Reply-To: <e954bfad6e48734927d900458afc00aa0a9a2e69.1790670523.git.weh@linux.microsoft.com>
References: <cover.1790665894.git.weh@linux.microsoft.com>
 <e954bfad6e48734927d900458afc00aa0a9a2e69.1790670523.git.weh@linux.microsoft.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 08 Oct 2026 12:54:04 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> From: Long Li <longli@microsoft.com>
>=20
> Replace the depth-one timeout latch with per-slot sender and response
> ownership. Initialize each slot under the inflight resource lock, publish
> its bitmap bit last, and release it only after both sides have finished.
> This preserves response-buffer withdrawal and timeout quarantine while
> allowing independent message IDs to make progress.
>=20
> Serialize SQ posting so concurrent senders cannot corrupt the producer
> state. A posted request which times out keeps its response reference and
> admission permit until its late response arrives or teardown cancels it.
>=20
> Return -EBUSY when all slots remain occupied. Admission pressure is not a
> response timeout and must not make callers start dead-channel recovery.
>=20
> [ ... ]
>=20
> Link: https://lore.kernel.org/r/20260908035201.402424-4-longli@microsoft.=
com
> Link: https://lore.kernel.org/r/20260914175044.2a26bb46@kernel.org
> Signed-off-by: Long Li <longli@microsoft.com>
> Signed-off-by: Wei Hu <weh@microsoft.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/cover.1790665894.gi=
t.weh@linux.microsoft.com?part=3D3

