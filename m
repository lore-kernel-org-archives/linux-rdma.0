Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794438823;
	b=AD/8Tva38tdBao4adjNx1amecamyxwgUmD4cyyAwuLdt6goMrsIKKFx46HqTHn5j0bGm
	 dLFjsEZ7MiZ804QmjoxRtRgXO1EmOwBmqwOYFRwC9uCwutqlSuJ8kr12YU/BYKqr1ZI72
	 MJaNx/E+4oAizqZ51DscSo8g0L0u3mXXcUnzBlXm+3KwQU56txa25i2uwZDuhw1PSmnqh
	 FbNYzwanLoztuT/gcplyZqSjO0d+ML2L4R1igHrUiyL+k7mNtsyk0OOYAKMxwSompVNrE
	 AYKJEzw54vmq+V8+pYEsIRVmg3CzD3mFilAjRVqC3MXU8yc1CSuyCgB2+rB8lKYI2Ig==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794438823;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=oktJtAJhMyw2OW9RkgURZL/WbJiA8gkW+TOsEdJsmRc=;
	b=gVldlkeHOatAqEc9prYYiFBtVCqbhvMTYKHmipdkU0w71fOSr4D+lnx84BBhjrblkykU
	 ZQGbALNa/OyM8CvNdYFEcOVM0YKSAfapyjKJ6PCXTiFiuTFjPFlSbFwCq/n9YGAT9zjRe
	 ndD9CaIl4XPOo/gVeCgn277hx9Zox7zKPIrOtU/VH0YldfH1H3Tk0ULqGObpqHHR2HIdC
	 emyOaX6J59fK68huY3Wn7bGlFfinpbuP64WQSS/9TK+rJKtUjcPxbf+BeYZjaTzTQQvkr
	 O9ZYjUF7rbJwqDnLdN347w0DXpZcVnYiLB++hNm7Ptt+wJuLgHZtbTs0T5StVY5vutw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ccY7Cvsc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18343606A327
	for <linux-rdma@vger.kernel.org>; Wed, 11 Nov 2026 23:13:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ccY7Cvsc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1F0F1F00A07;
	Wed, 11 Nov 2026 23:13:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794438823;
	bh=oktJtAJhMyw2OW9RkgURZL/WbJiA8gkW+TOsEdJsmRc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ccY7CvscX71N6Ob3daoeO8JOa+LzjGtN7qXeYRnenEuFLj7HQhN88RQBDcvITOBwY
	 9Zc3G4lo2UaPw//WWa1lMBvhns6SgLXtJKp59gNR4HrVqyZm/XMxTrI85GfYRoaQiJ
	 ZZHdCYdeua29Ef+RSetoqn7eV9C9HDlvGn4n61ALt3DelWJxsTRGzT29Hx4IowjFkB
	 Cv4jnugQBs3RFNysaqh+gqStNBAHl0DdFB4fmHkfh1NdMm9Ae/ko7x2q+9yndMeF5W
	 sPIeMjmXtTq1sax+LRHUjdD8p0CuYSN1EBAETDpT4+0221cidDT7bJlWDyEOuHqPoT
	 kiTwSIaatejYw==
Message-ID: <sashiko-outbox-209847@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next 3/5] net/mlx4: factor HW loopback DMAC into
 mlx4_en_set_loopback_dmac()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Joe Damato" <joe@dama.to>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261110231304.1859217-4-joe@dama.to>
References: <20261110231304.1859217-1-joe@dama.to>
 <20261110231304.1859217-4-joe@dama.to>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 11 Nov 2026 23:13:42 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> Extract the code which copies the destination MAC into the WQE for
> eSwitch loopback into a helper. This helper will be used by a follow-up
> series implementing software USO, so USO packets between functions on
> the same port are looped back too.
>=20
> Signed-off-by: Joe Damato <joe@dama.to>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261110231304.1859=
217-1-joe@dama.to?part=3D3

