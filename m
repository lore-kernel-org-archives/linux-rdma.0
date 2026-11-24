Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795482964;
	b=wCfDJF1vjPJpXroOqRnt6zKov2fZd40ZIvW0go4CDrHH4+t3HJt9JapLlcrFuNgDzi7b
	 xf6GlyJA99PHhpRk595E9QjojcIDAXxSGTataLEJobuUeKm4l/8Mrtqg3GPBfNmCp/1Ii
	 EQWXK99YHPxnNfEaBnh7q8esp8KvhkmdtRDPA5y0SOwOTKml8ZvlJkgnxi9f7sDyQMK/5
	 URnySI/2sDpAMBFPzzUAV6ajzjNbaDnuKXDIP+m/QlafBBh/Mym97fST6Lrkpc5IyXeJc
	 D4wlAjz8gfGp6scxNMdESMqv/myE9aXU0X7VZQjau3FLQ/ziv28DAyZV0c8Z8VsCcFw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795482964;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=e6kfOkFAvUVHVpCea3UZRCBn0TzDtngCKnWwUSaQ/5A=;
	b=TVLh4CT2DAcA5t2cHYTJ4PYnf+bJclCyj20TSmoiDKLlEpuiC0HHN6mG0w7huEXh6WiX
	 lWxVSUH2I7wpx0dcpK1OMVczLIxs0lf60X3fFcFhvOSh1WY3NSyHNNtMl4bozJUH6yXeU
	 8HXha5y0d2jcR+QTw0R2ceHeGIm2Le4YilJTFrIfNKPXn7tD3jz6RzvShVKqcdgsRhuBE
	 b7Oq16wcubtGKUcjomGJsvdDl5oT2Hxqi1VCHmUJ+L9cty2x4nMh6ukb0bSHtGJLn7UtJ
	 +zs3gk7/i8jYEWT0V+HIfDjGZ5oHLFYw6KMgehRK4nZ2eW9Xk6R9IFjN+xDtd3RuVNw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Dg4OhJRS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22271606A321
	for <linux-rdma@vger.kernel.org>; Tue, 24 Nov 2026 01:16:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Dg4OhJRS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A13E1F000D8;
	Tue, 24 Nov 2026 01:16:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795482963;
	bh=e6kfOkFAvUVHVpCea3UZRCBn0TzDtngCKnWwUSaQ/5A=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Dg4OhJRSCI54y/exD+DfSK0FVeq9dbUWQVyygYH4Ggtsfy1HCFVDcHRRk0e8yCwWI
	 QxESj5NLWpcbb6ULlIK1FxKtQsVZ78IcezXsCSoaLazBowcgaQioWCjC59rX2atLKv
	 6TL/EUXbMarUsFsh+H5b9q7z09Z5jrgOYFJtR8tMumuEqgvqO21x58PwDQD7nDpv+Q
	 pzbM3+rGqUx+GFR7nAOxJux4NGzKyxPcTqxkfCO6dpsxK29i0EnNk7ZR+Xf5k5QL+V
	 xW/sFvWSO3HPpmkjzA6bOWx5kEN0Ob/0xJsRhtcdqTzQTIxoOFWg9v7r/wIN/EwPRV
	 NkZFoSUudvBUw==
Message-ID: <sashiko-outbox-230338@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net v7 0/9] psp, tls: don't send offloaded contents in
 cleartext
Reply-To: sashiko-reviews@lists.linux.dev
To: "Todd Freed" <toddfreed@meta.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261124010601.3995693-1-toddfreed@meta.com>
References: <20261124010601.3995693-1-toddfreed@meta.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 24 Nov 2026 01:16:03 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

Sashiko has reviewed this 9-patch series and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261124010601.3995=
693-1-toddfreed@meta.com
