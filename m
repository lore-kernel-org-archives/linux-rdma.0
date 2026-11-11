Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794404820;
	b=CiZTKENSgpsyJapW+5748SnNiesww/oKsw4HXRxWO8wDMXcg9evgX2hEXSHnR3tJfBha
	 SxabZakgnB55Vdu1Szw8JMvCX27vx7qGri//3BTc2PhypS85YL4em4/I8v6HK5Zt8DxsI
	 ellcqbM9OVyq29l/39P7iaO0mcmV1qAmAPIympB4PMhLq0F+OifZFtZBb6RrshmMWRhm+
	 XikFGf0VYg5W0smtDTuBtQQPRdOeA1KcVnQMCmryhqt4PQzAXmnewMbY/igql6a8K6UHp
	 TAVAVIWRq0mUa2AG/NjN/l4FTSk89/S9kO4Hk+WFo28JXHKJZnCwEKKLf67z+nUGy8Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794404820;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=JBTBowbi13DcnwoVJGImKxOvgwSI/H4ASQucPhvweds=;
	b=z0Nnugrjz9RIlrlSbBZiZAuA6EfCRJ4Yk3xLTFMaZPyOnlfUI1EiPaeetPH4W6TauZXf
	 1iwljdCPBrFYmCKHXy7jZa2Ey+SUoB1YD66U0CzBaPC6zWWFvpCK4VJ8X/VscebM1TLSz
	 hIbrKICcz+Bn+ErskT/vPSWWcGe7DcLrrHkawASg11yhV5LKq1gN6m/cVB3Z76cxrvFjD
	 P/yZsvVTG3q8RxM0W2MtMGEBht6lh3M/acjK8L805jKOp8w+UFAFyEGecfaGy2+GLWPlm
	 g4SSX0VSojSNSeDqHRJm4Q3U/gd9uobzNBF1kiU5ADnneDh7DcIM/LyRcsbUdvUUjIg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QJwo0jBR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18D1A606A332
	for <linux-rdma@vger.kernel.org>; Wed, 11 Nov 2026 13:47:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QJwo0jBR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B68BB1F00A06;
	Wed, 11 Nov 2026 13:46:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794404819;
	bh=JBTBowbi13DcnwoVJGImKxOvgwSI/H4ASQucPhvweds=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=QJwo0jBR9Dw6GqR4tc2pPOI9SB7+7vRYP5+SNmg+y6hxvSB5uJn8Pc9ZGKdZwZsjP
	 Et6CQ0+0Q6PFQG6MScsMJoRKweOu10fNWWU04OY3nR2kaq09ACry8YYnCf4CsHt0XM
	 nZ+Om+O4jsESRVYsxqUmuRvpAedkjklq7B6XvN3eB6HY/wecGW22/laHElON4HCKM6
	 WC2glizeMCHDRWYMAiTagP3TYUO7QJPByhg+RSR8I6vg2E6Md2PQSDE/LdjOFBgGiW
	 m5qaXOWO9weaooTsAfHOGGTPRikXGThVsddeXL7+W86egSrI4yU1gRwabes3JCyFo3
	 Jqo7jFhcKDuhQ==
Message-ID: <sashiko-outbox-209109@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH V1 rdma-next 24/24] RDMA/mlx5: Advertise adversarial
 mode via ib_device::adversarial_mode
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yishai Hadas" <yishaih@nvidia.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261110134320.34408-25-yishaih@nvidia.com>
References: <20261110134320.34408-1-yishaih@nvidia.com>
 <20261110134320.34408-25-yishaih@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 11 Nov 2026 13:46:59 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> Set ib_device::adversarial_mode during capability init, so that every
> mlx5 device in a CC guest runs in adversarial mode. The core then keeps
> the kernel ULPs, and so rdma_cm, off the device, reports adversarial
> mode to rdma-core and lets only adversarial-mode-aware userspace open
> a context on it.
>=20
> Signed-off-by: Yishai Hadas <yishaih@nvidia.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261110134320.3440=
8-1-yishaih@nvidia.com?part=3D24

