Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794325530;
	b=Oxrhnvdnl4THIFfn6JLsr4qYUq9jFB0Av1rTZrajXkgsgciU00n69LprYWJA0M0Vd6//
	 qwFM/ka9uafx9wmWTqK5sO7UYghkHm0klY1BfFuXx5i0vUmMrQJ4WcaUgOE5t0KAVY1lL
	 PIMOAHwnH7g9uqTk77DOxowiXGUrc3sT2fepbcorDjDEiHoN8tWOz008PgBwZMaZpD9bX
	 /PLTkkC+TY4RDv+ZVRs9TNQjxNdPcHYPOaJqUB6l7G6l4FP4LOcP4375tDBIsnrESgK3O
	 isUSiK3HJG1Vxex/yaE0VkiLoa6r8S8WcXdT8/UVyAG3eNCkuAGG/9plfHYWXF/Ok8A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794325530;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=B2D3U+K2dgjYntkp7AbOmxjmj7WCeRXys49lIfDaQBk=;
	b=Ba4rKVUR2H8+GXljoxZyYWT1DgnORENAxtMV/txQBysT/O/nr6atj1RWhmOhOhBVK+Mr
	 ApEjKXWZ+56Eyo1UkCvxgqxzSna23im2S76rvb/iME0wINGQNhzdF/UsLltrMNsL4oflt
	 KFc1tmleYVRxHERXWZ7b7prmpOr08iQc3n/xTwJzzAuSfTOCeIJSAP9msnUDv6NK5Bakj
	 rVCRYSg8aWBeZda5qpZKI7Gdnxg97S2H7ymA/SDn1M2h6Q9wv3I6efr5guUHE8yLi1uKO
	 zYr06XDzY9KELSyTVpDEHb+YoI7yojh0Ae+pZX+FZBMtqCH1H+cBo06DvlKl4txf5jA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Etmh6q1E;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 665F4606A330
	for <linux-rdma@vger.kernel.org>; Tue, 10 Nov 2026 15:45:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Etmh6q1E
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 144E81F0089F;
	Tue, 10 Nov 2026 15:45:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794325530;
	bh=B2D3U+K2dgjYntkp7AbOmxjmj7WCeRXys49lIfDaQBk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Etmh6q1EHTfSx+4RhUY5N5cp61SC2i30mxiClzrHwj0HelxlXmcWbj+Yrjn3mLOj+
	 BuzPpymfQgMzz7Jqg5XEBfoljMeBahRPy2bg1tvhQoNThLgoblUP9KwAVzAXIR//qk
	 dF5+yzRKG21F8ailqBGDYDMe5o5+O9L81fjwJU9/IUd5e97f+z4DzcUOtLpyb/0z7d
	 kCgIftJbvXDcOng3GKbC1Z5fMQdbNXONvJWnTkNR5zJdn42s7+L/+FymQ0SSfOEdUe
	 bnR5+l2H+Wo93tA1GLhi62+KmeybVCxlUU4znScn+/R2NK+zN+tAOJ9ata1ScBEpZB
	 5Cxt2sfMgcgkA==
Message-ID: <sashiko-outbox-207287@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v10 1/4] net: mana: prepare HWC ownership for
 safe reinitialization
Reply-To: sashiko-reviews@lists.linux.dev
To: "Wei Hu" <weh@linux.microsoft.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <df083dc6ad8a8958398e04afe66ca2c5f4bfb040.1794208055.git.weh@linux.microsoft.com>
References: <cover.1794208055.git.weh@linux.microsoft.com>
 <df083dc6ad8a8958398e04afe66ca2c5f4bfb040.1794208055.git.weh@linux.microsoft.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 10 Nov 2026 15:45:29 +0000
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
> Dynamic HWC queue sizing tears down the bootstrap queues and establishes a
> second channel before publishing it. Prepare the existing HWC ownership a=
nd
> teardown paths so that sequence cannot free or reuse state still reachable
> by either the PF or an EQ handler.
>=20
> The shared-memory aperture carries one request at a time. Serialize the
> complete ESTABLISH_HWC and DESTROY_HWC transactions, including possession
> polling and response validation. Record setup_active immediately before t=
he
> MMIO submission and clear it only after DESTROY_HWC is acknowledged.
>=20
> Treat an unacknowledged destroy as retained PF ownership. Fence the HWC EQ
> and withdraw its CQ from dispatch, but keep all queue memory and wrappers
> for a later teardown retry. A new channel creation retries that retained
> [ ... ]
> Link: https://lore.kernel.org/r/178910960115.219967.13830871915506436112@=
kernel.org
> Link: https://lore.kernel.org/r/179196575238.434549.10775387794024020898@=
kernel.org
> Link: https://lore.kernel.org/r/sashiko-outbox-170992@kernel.org
> Signed-off-by: Long Li <longli@microsoft.com>
> Signed-off-by: Wei Hu <weh@microsoft.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/cover.1794208055.gi=
t.weh@linux.microsoft.com?part=3D1

