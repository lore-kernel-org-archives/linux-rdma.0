Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D9C439524E
	for <linux-rdma@vger.kernel.org>; Wed,  7 Oct 2026 15:53:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791388394; cv=none; b=QyyL3SDVzJrYubUij8Ww3H1tW/AoBoaccYU0ZolGN7osNHsuoSjwV7O0Qm8AF6YoQdn3WpkfBbKew8QFLHbQKuNG9FI1EQMDHxPIYTfkU0zBKhRuMBpLo3uGvoFdeZMVBf0xVIEGN6a2BvPauEZHA2REfy1jzyORMf/6FoYdwzo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791388394; c=relaxed/simple;
	bh=OTQfNnWUCcUMRkkavvAFOMJb1ZByMjksv8CGXqgPKLA=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=jtxT6gGBpJ6zf8sgmKBsi/8fojAw33eBZyV8Q9Dc0UYXwof1TC29HS28ONC9IFQ93FfIUegrjLpIrQRaiJd/qBgIh6hJ8fSWy6YlwJMv4UQmifFfqU1pfqoOHLgOlb3ud4Vm4icY+GqLwSlSt0tO3EH4nsfS6LZxqGicr77pnYc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FAwVVxNA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FAwVVxNA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 151371F00893;
	Wed,  7 Oct 2026 15:53:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791388393;
	bh=OTQfNnWUCcUMRkkavvAFOMJb1ZByMjksv8CGXqgPKLA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=FAwVVxNAInb3/RBhQvdK8YtB9gw8qUPLS1wFd9KnFXZ6XkqLPOgzD0kDZy3J1Fsla
	 Z7odOZFXziZCPKrqoPtkoYTVvEbcJBG9hvBgAd0De4GCex7nwPLoYmr39rBujzsW5K
	 95gS1DMQCh5QGnNxUOQ42k6/XxHXkfq4TT0YaF6MFYjnnlM9nU6B/9Uwc12tDpWs7t
	 oB1Eeb8aeeLaRfMgrw3C18wralT1XQ23rdR0rOS2zyb/OUiGv55v09iJqH+qrc4zVa
	 YGaYMnCDZJv57GYBQca+c4k7Y/23wbtUwVOE9EXvlvMbHWiAq9rRve7VHWRLhamSrS
	 Y1fhpI4WKmiqA==
Message-ID: <sashiko-outbox-163171@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH rdma-next v3 06/10] RDMA/mana_ib: Post send and
 memory-management WRs on RC QPs
Reply-To: sashiko-reviews@lists.linux.dev
To: "Konstantin Taranov" <kotaranov@linux.microsoft.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261007153330.2979799-7-kotaranov@linux.microsoft.com>
References: <20261007153330.2979799-1-kotaranov@linux.microsoft.com>
 <20261007153330.2979799-7-kotaranov@linux.microsoft.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 07 Oct 2026 15:53:12 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> From: Konstantin Taranov <kotaranov@microsoft.com>
>=20
> Implement send work request posting for RC QPs. Post communication WRs
> to the send queue and memory WRs to the memory management queue.
>=20
> Advertise the memory management extensions on adapters that support
> extended WQEs.
>=20
> Signed-off-by: Konstantin Taranov <kotaranov@microsoft.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261007153330.2979=
799-1-kotaranov@linux.microsoft.com?part=3D6

