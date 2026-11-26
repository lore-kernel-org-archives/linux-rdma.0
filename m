Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795700104;
	b=ScS+8PEqCv7JL66g2K7IvEY0RfFh7W6cNIh2FPb1R7SAh4rp3iAwJmXWAhcYTyitWGn1
	 eqHx2rV2NyUP64d4GIyT7Qs2t5ZHT5mLpSdLvuaI50Ut0rLQemijngn55HwXw6CPq9/EO
	 cwKOB61rG74pcK5/RnYDHXKmbKutGnUpm2Oa+zR1wTKFy1ZN6kx6wZOfQdeNluLanErZV
	 WTz465U9CCb+0CxEZidGTu09xwSeY3kCJ9XJ1y/BMWbVxTr+A7LSGfYw7u8v/NM/CJSMV
	 DU8Vr3UleQ00eWCaw4GOvFC71FmycF10zNvkFx9XWdnk++j/bTQBaAIOja0mIfscKkw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795700104;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=uxZFYp0iD5XWnqO4XEfJ/0Wb+IyoQJyhBLC5CzOa+VU=;
	b=NwODRu+YlQOmGLlmoiGs0h/KW5n1gf0piAnQHF96rDq5W3fTIpvoeFhpYWE/dwDLaZJn
	 uT2Bla6mFfzTQ7y72IsT5TG0xrvqHDVt6TBS/HkITsPRZ3GakzCDDUzAfOkXlfGTu0xDc
	 d/+VLS7rIyVxx95yPAqbxRCYnqxt23ea0TxZslKlpARNgRhQkAfxJ+kJmGIrgnH/rWzcy
	 zioiDGMvVHus42WCk5qZ3yCghmLHgsraAoFvmNW84abICS3Agb/sMj5X6Bzjiuqy+IdMd
	 qBoOIyp8dnuDBnnxii3mX15wmXgqUp17SaOUBjWbbwZPmKknDhH2Q0RCvFX3QhDCsNA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ioGpJG4a;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BFED606A321
	for <linux-rdma@vger.kernel.org>; Thu, 26 Nov 2026 13:35:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ioGpJG4a
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CDEB1F000CA;
	Thu, 26 Nov 2026 13:35:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795700103;
	bh=uxZFYp0iD5XWnqO4XEfJ/0Wb+IyoQJyhBLC5CzOa+VU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ioGpJG4aptnoG0kRuJeaSGuD5YVZX6B9rIROWaVXMDx0SJ2iHz/HNlLH5FzspPMWI
	 PwmSOXUL3EIgX5KyfJHvUxvQzEX/OrdSem/QRh7TuzoFUR+2Wf/NZ3fjx46kb8c2Lw
	 8SEgJ4e24JSGfMx5a/8pd11amwfFEH5O0tfvbIjUyJB0nzOxU3KozqEb1cIjDJ9cfB
	 zfcoPQPv2aUUMQz63+lRUYOw/KcnEwvrr6wh7MoQ+696Sv7wLd8oGXvWz+QZJHBsHp
	 DDNNU1r7qRrxv7opHTHN+qwWI64/xz8iR3zgfUXsJsqmdoT7Xl2tG8RWn9oRUkA8KZ
	 2kiM8Uw1OMkaQ==
Message-ID: <sashiko-outbox-235622@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] net/mlx5: Free the table after storing failure in
 mlx5dr_domain_get_recalc_cs_ft_addr()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Wanhui Fu" <fuwh1120@163.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261126132229.4028110-1-fuwh1120@163.com>
References: <20261126132229.4028110-1-fuwh1120@163.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 26 Nov 2026 13:35:02 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> If xa_store() fails, the entry recalc_cs_ft has not been stored in
> XArray. Therefore dr_domain_uninit_csum_recalc_fts() would not destroy
> this entry. Just call mlx5dr_fw_destroy_recalc_cs_ft if xa_store() fails.
>=20
> Found it by a self-developed static analysis tool and compile-test passed.
>=20
> Fixes: c0e90fc2ccaa ("net/mlx5: DR, Support csum recalculation flow table=
 on SFs")
> Signed-off-by: Wanhui Fu <fuwh1120@163.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261126132229.4028=
110-1-fuwh1120@163.com?part=3D1
