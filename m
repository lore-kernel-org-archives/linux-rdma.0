Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793366008;
	b=PWIW8hUI7WNlrlFPVSk8WC6BbGaF4ZuNETMyysK3u5lVdUZ8hRQYwSpZFn7UYIVB1LMM
	 fn9mxvaKLRp/DuXQpatd/OLnBuJKLY6T1XJDNCEkv0Y6wKFu4jBXr4j7uIp4LClxMsRdD
	 8XMnjHrJAUBKwlxdhHmTe0OXgJOw6WXctka6SJlswS9n6GU2bi+pFhcQ1lIYPRWSX0v/a
	 QwL1C7uoqWVBYgQvg6rNI1qGjVHSGGzYF9zGuXXYWBdy38osBZ0mIiW8GfbibdgYuvmPb
	 nDCOVJ7RE46BxHghZr578pQ0xbNQh8W4kuCJy8WBl0sMMSJTmzmO3rQYTKo78s59/IA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793366008;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=2Xds9n7/7pA96HaBW8QEttDbaOGpOcuEOFLlYxChNQc=;
	b=SXSuHi8lQikIJOULU7UKkew94SUHq+EdXJnX7JzWGg8pYCzIX/OshFdxQISiWHUcw+eB
	 O3rg2cetXXyjOw2BREtRnWKUfs+mOIfXha1Td6tQPy4GW/S29UCuK+jr69MxznYTKBBwk
	 MCnajA32QcZxauywYXErKVpAAu648EKa4IEkek/7mofVHX3tj1CgBck/FZW7KNg2cT3Rk
	 DWpOlqqctY8zhlWPDvrXMGmdTNJ2I5gsh1DFg7p0YxOaoqJfsbQmLlxOb4G2VgluCDs8q
	 BQt6SerydT7CgaWymwXamG4N40YogWW1XF/WQl+0W87Haaa9ZXd9TaDQyEk/RwsKpBg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Usy10xFg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15801606A31C
	for <linux-rdma@vger.kernel.org>; Fri, 30 Oct 2026 13:13:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Usy10xFg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77A2A1F000C1;
	Fri, 30 Oct 2026 13:13:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793366007;
	bh=2Xds9n7/7pA96HaBW8QEttDbaOGpOcuEOFLlYxChNQc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Usy10xFgPUG6JRLgNvl4WMCfSdKGTmVWxM37FiR6LZAWcj5xCAetJA6z2PB5WqfsK
	 R25liVK/HFF+/IFTIgQ/UoNmjsAe+K+J4gzL2ruANeydFMQV3B2EBAIRUHfUjSA03i
	 90Y1ga/DnLJjSPOG2o4SeaXr5ntrsLjLKtQiLZaY/0SnazCTEadpf+xUnszsia5/a8
	 UfygOm9v430WVaUCaeaDCK0ZvIe7CDJ9VFJxdBwf0Y6Yz930Hmqr4ZA0Ll9RldRsbO
	 Bh+oDBlMCgmq8u4ifSajE31if8oxnVKToNpxaLujTp2gYKGgkX5Y5CBRqv77VSRkAm
	 UnncwWxj/VdZQ==
Message-ID: <sashiko-outbox-191051@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH rdma-next v6 06/10] RDMA/mana_ib: Post send and
 memory-management WRs on RC QPs
Reply-To: sashiko-reviews@lists.linux.dev
To: "Konstantin Taranov" <kotaranov@linux.microsoft.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261030130038.4040789-7-kotaranov@linux.microsoft.com>
References: <20261030130038.4040789-1-kotaranov@linux.microsoft.com>
 <20261030130038.4040789-7-kotaranov@linux.microsoft.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 30 Oct 2026 13:13:27 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> From: Konstantin Taranov <kotaranov@microsoft.com>
>=20
> Implement send work request posting for RC QPs. Post communication WRs
> to the send queue and memory WRs to the memory management queue.
>=20
> Advertise the memory management extensions on adapters that support
> extended WQEs.
>=20
> Signed-off-by: Konstantin Taranov <kotaranov@microsoft.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261030130038.4040=
789-1-kotaranov@linux.microsoft.com?part=3D6

