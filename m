Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795660198;
	b=FuvX8PvW4UywHH+TKMQtLvuqVTpxVwdFGPM2FA8yFPwZ/HGdTBjl2pPUwbL9REZN86av
	 a6SYb2GKLTTxNKHxhhF9E8+IIClquxr6tMpgalioj1iOE378o76t7PWsxJKEfz6SN2lJm
	 ZaVe9u6ar2klwDZ8IMVaOgkK4YRIEFn3/ciYSDsiIiuzr2geErrxLG+HJuIpT8DBOwjKq
	 gDpcMUc2yE5UyfzcOBudaaHrb0THjS+4vyWqb8GLvCT4JnqC9SqHw4pVHklt5nMOy2IBW
	 UpIfSg4ZPDoOzkXaMogBG/FQPsZ/nqgSK4Wws9/bQNGBznxWCkiWmhQlO7Yo7dqnqPg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795660198;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=YlqXnreX7vUYgflr769u6NnkMmFi4xf/G1kBkM2goNQ=;
	b=Dmnc9HvWoeTXdlmqJgB+p4/KDoon8t71uOWYX7QGuV6idZzrstvpP3n0wgJAaK3GXNWU
	 oEx1AOFsCasfT6HDFLmnPfU3Lfba2nSUwVcJxk7LyDXa7ozuqAUDSWlzueaEDLIfjFBo2
	 m93X8Eih4dowRJT/VvgIc0IOLs2rXcr+UC0LkaVEROvKAYxqG26XEMjp5EgTdrF0AY9nZ
	 cWK4rmDTlDVLL4RoHRpS4oimIsPGwh8UVczYLDFAssCHhkdyeGeoWbpfcCZIQuFUBKF6/
	 UpJFCSNbL3RkezwRF8s5Xt1LYh/HvQimsltWyE+Fd09ntlkPylkZGNd2kyVP7KJVyNA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=cAuVbsCp;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9563D606A31E
	for <linux-rdma@vger.kernel.org>; Thu, 26 Nov 2026 02:29:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=cAuVbsCp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 032E61F000CA;
	Thu, 26 Nov 2026 02:29:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795660198;
	bh=YlqXnreX7vUYgflr769u6NnkMmFi4xf/G1kBkM2goNQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=cAuVbsCpEZ9P6AlTLxFXcS8SYnri6yd5s/5lLJ1bMpgFDa5t3g3kOv2w2NKrTDEJL
	 ubnMYw0i06NQh53qWfpQvpt/IFg4y+H/LeOOo0wSRhCBsq2ogWyB2dvxY5W5qWuzr1
	 sBf48PXR4/bwJlL5sDvxaCpsV7jucNRQM6rkrDrFHSr+ODiR38tmcumq8OwNp38XxV
	 65LU3ofoBmh+jh1ZngBRCrDXtylRX/AmGRUk6D/CiuyZLPzTDL6XgaA4042PdBMrpS
	 ++WRMq2Pmieuk3Qz/Obx2OClazPk5J+u2SYbHTGjdro7wHyyu/gbjwKtlllTOU8+Ht
	 d4gbEnqxzmjSA==
Message-ID: <sashiko-outbox-234641@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] net/mlx4: fix error propagation in mlx4_load_one()
Reply-To: sashiko-reviews@lists.linux.dev
To: mdshahid03@gmail.com
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261125022913.205366-1-mdshahid03@gmail.com>
References: <20261125022913.205366-1-mdshahid03@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 26 Nov 2026 02:29:57 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [Low] net/mlx4: missing Fixes trailer for mlx4_check_dev_cap() error
  handling
--

commit 855b07b65d1b72a91e4c54acff77056b29d5be87
Author: Mohammad Shahid <mdshahid03@gmail.com>

> net/mlx4: fix error propagation in mlx4_load_one()
>
> The return value of mlx4_check_dev_cap() is not assigned to err at
> two places in mlx4_load_one().
>
> If the helper return an error ,execution jumps to err_fw,but err may
> still contain zero from the previous successful operation.
>
> Assigning the helper's return value to err ensures that the error is
> correctly propagated.
>
> Signed-off-by: Mohammad Shahid <mdshahid03@gmail.com>

[Severity: Low]
This fixes a bug introduced when mlx4_check_dev_cap() and both call sites
were added.  Should it include a Fixes tag?

  Fixes: de966c592802 ("net/mlx4_core: Support more than 64 VFs")

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261125022913.2053=
66-1-mdshahid03@gmail.com?part=3D1
