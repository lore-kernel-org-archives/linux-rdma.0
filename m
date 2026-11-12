Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794474791;
	b=NOcCL+lg7TZFhIs3QfDZdDb9DCkxX4RF5ZOFt9Z0I6qL+XSvfQJ7C9pePa1wMEkP26XG
	 hDOSE0cFazsHOGSIjh93GuRFuxnV18XxQJP+NOTvqbdJQq11J+EUe3BdsluZz6K91QX6U
	 pvb76FZRHoVIPtQLEXAcaxuBHTAt8Rkj7DEq7rV8XnWNSpdKINoN12Aa8E5+Hc0Yd4c+6
	 IX2Vi3zY0b//oNxQsxB1SJzMELv98NtopqcwMh4gCdnWimQKv4bUiN1uYHdsprGW7hf4A
	 v7cLXoUCAlnFbW+sjuCSask3ZOwZ0rL8w4GbTGjL78jcDV4VJhL2PF/RXx1EUyOgmQg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794474791;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=679f9RbOydMVQF7QroKngvZ1lr/qDeE7QLk+ajdv+3Q=;
	b=EkTU0svd7hdowWibH2kHii3BZJSB/NBjW5zPvAIxGkvcrSgUyd14st3tD9RbYmTSdgUF
	 WF6q70XsVzESfTAHk8U+m3s1JCNCJdtmxu/1BjUz513va7Eo2rutrki1SQhact6N397J4
	 g8IUy8UA01ut59Z1yOkP0X6kzFz/xQxiElBvZ52Vp1MVucm1uDi4M7rbLmp7z98w0TKJe
	 pmaczDhWVxE//YGxI1CR78X01mKJKxea1LZDgC4sD7Ski/qDVaq2kYhXhdixqz+bwaPmt
	 hU91ttiu/eLOfGstKMHVfveKrB9tsMiJD2qRfxI9P5HPdyYVJ9QR3nW3xxleZICPryA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="cusAkL/S";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECDAE606A330
	for <linux-rdma@vger.kernel.org>; Thu, 12 Nov 2026 09:13:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=cusAkL/S
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8597D1F00A05;
	Thu, 12 Nov 2026 09:13:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794474790;
	bh=679f9RbOydMVQF7QroKngvZ1lr/qDeE7QLk+ajdv+3Q=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=cusAkL/SMiNBbH/4lgeaCQQfOsN63lvvXrMYfTEqHLMk4OXzTrBv8IHJ4OxxcaXb3
	 BPsW8ERyKahiec81lqI1F2909Ha72zVBbsJ4JotCXX0a4Ih8FKpxhVu4ondPVtTxzQ
	 VK1Mt8pKo58y4dKx7qoGODm582+Wonc4965S9fW8A7PTA5A06fIOMDPlaO/W0aFbtt
	 bf7P+QFzLTu43mhx8yz2LXn15C28NKh0DTjUEDfXOodDbKJOzhLLHr3a4L9U0IjbPL
	 LZxVvSD3xnGpHOaLVXVnuEBUpcKx7H65KVMUpO1w2NHuUIActQ6Zad08OGB0M1iKB5
	 LV6+CW2LFzY3g==
Message-ID: <sashiko-outbox-210838@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH rdma-next v11 7/9] RDMA/mana_ib: Poll RC completions
 using PSN and FSN progress
Reply-To: sashiko-reviews@lists.linux.dev
To: "Konstantin Taranov" <kotaranov@linux.microsoft.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261112084716.1483342-8-kotaranov@linux.microsoft.com>
References: <20261112084716.1483342-1-kotaranov@linux.microsoft.com>
 <20261112084716.1483342-8-kotaranov@linux.microsoft.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 12 Nov 2026 09:13:10 +0000
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
> Decode RC receive completions, armed-PSN notifications, and MMQ
> completions. Retire requester and MMQ shadow entries using their
> sequence numbers, honor cross-queue fence dependencies, and suppress
> successful WCs for unsignaled work requests.
>=20
> On an ARMED completion, rearm the next signal PSN to generate the next
> send CQE.
>=20
> Retire acknowledged successful unsignaled WQEs even when the WC
> array is full, so they do not unnecessarily defer PSN rearming.
>=20
> Signed-off-by: Konstantin Taranov <kotaranov@microsoft.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261112084716.1483=
342-1-kotaranov@linux.microsoft.com?part=3D7

