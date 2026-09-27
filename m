Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B4003D9524
	for <linux-rdma@vger.kernel.org>; Sun, 27 Sep 2026 12:05:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790510706; cv=none; b=StBnQIrC+9PqWWuerw03JDoN6S3bjrHLlW05Abn2ChkqtMhihMgWQtgjyF+ZLr/T0/w+bleCSQUwM5zQIDsqLZZKEIB0kmoSzm/8l53tzVxf2EOnZqBbZGgOHgIDgWd279w6UM+aXztgybuUZbpOqh+Cef4j7lblMvuebr2dAHk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790510706; c=relaxed/simple;
	bh=iPX48SdAvj/1m1zwmV3xbVjmSaz00d2Z70DrGkAZUHg=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=PWEGU3rdlN2ATpgc0ft9mLIInMYtEpkBVeZjNxGiy/iJovSvLZ3Sk8hqcptcq/EO3SWx5tZNTFFj5FE8K/no8waH0Bqa65VQZ8FX9ZDLjh7aIzU8oKSLKHNekmT04FjrVZP+XsZ5Df5dKOlXQ2tFB29opIVYmiwrjM1l490kfWY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AjAlKjT5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AjAlKjT5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E14121F000FF;
	Sun, 27 Sep 2026 12:05:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790510705;
	bh=TXDwP6L/viEDTVf2Ir2dHSPKjhBiEZ2x7CyC9q7U0ds=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=AjAlKjT5r6GCMikHAQB1ZfY9ffCc9VGvK1Oj8kbix8w22vldl1o/9Np6oveFHCgq1
	 a3yG5UNmtDA9pfnhEnqCBuEjhezGPwOCa1txeOTprsfY6r4oVIRT5i1cB1kF7NYo6m
	 uqNl8Dui4Z7mIrg+5JIVwsCJyVt4GCGCdHvEJiPU2eTbfkirS+jWz0aQ9MxYWg/3XY
	 pgOAT7gzdZ/hdqoBa9Jm9kz5vBSJKNEDddcNOckJQJOVNJuaonyPUVsc8sKnz4dvKE
	 wl7W7b1DubC1UqIhrzG32xq4eLxEekkjIbAS+md4yKfycPKK1Vg+5vWTwK/u+r2ihm
	 BGJj0xLETDEHQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] RDMA/siw: Fix length of first chunk in siw_try_1seg()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Serhat Kumral" <serhatkumral1@gmail.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260927115351.12245-1-serhatkumral1@gmail.com>
References: <20260927115351.12245-1-serhatkumral1@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 27 Sep 2026 12:05:04 +0000
Message-Id: <20260927120504.E14121F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> When a short-single SGE payload crosses a page boundary, siw_try_1seg()
> computes the length of the first chunk as the amount that spills into
> the second page instead of the amount left in the first page
>=20
> 	part =3D bytes - (PAGE_SIZE - off);
>=20
> Use the remaining length of the first page as the first chunk.
>=20
> Fixes: b9be6f18cf9e ("rdma/siw: transmit path")
> Assisted-by: LLM
> Signed-off-by: Serhat Kumral <serhatkumral1@gmail.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260927115351.1224=
5-1-serhatkumral1@gmail.com?part=3D1

