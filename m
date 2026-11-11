Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794404809;
	b=wUWVMoT5LAGLMDZdDmKZnRShiOfkl26Jr+zMnNNbQxi7qAwo0pewT9Szqt7g/LUgPQKD
	 iSBuhoXn0mqCMN6TJiaFX3UAvjiIz5KpQ65noOhnSgsZ/sbAEVrTa4vVcOs90Si4yAKPs
	 SWW1y4sC6aoOu3Siy6vTGrZQfvkFPxkseFPrzn9pMOfnlq/Bg3PlThul7L8laq2vgi6sf
	 HXENZc9L3+4372TFP/PBA/7GrlBB6oVdN2vedh/y7PJLywNADHs7yYFAH6Xug/Y8DJgEx
	 enncETpqFsvmWPHrM/Nvc6gJ4u/9Ie6dee01gq27FFyG6tnAMQyfWAfDnfFi8oUJN9Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794404809;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=QMGXNxfyhruveJvjtM7sWayp537nutiZXflmikOX1as=;
	b=Uq+QSzFmPwkWXZESKxnY9WhSoikamfXvT3sjUgYO9nOt05/xsbue016SqBM8wZNpllNv
	 RCOE1LVD/roxoTfRNsxpb6R3AJv90dYPotAjr4hNnqEL4exOIBuLCKoD3PSJkj88Msvvb
	 NyhIwpONl5JjtTht4dBpf45jFL+srCM7enwXVh6xYqMdafXTcgPgM8m+bWkulY2YwBHid
	 22uboi54DMuxaXyrOsz4C9dyAejck713EZ82kcqTnavdHrlffwm+z3KyC1atWtSku5YzE
	 6I3HrSs5o8yHvc29Cyua8ywMjaqZp9LBJHpITfxI903FGGEVS/EKf5XJO5Txje+MSyA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ikRnkS6W;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B587606A331
	for <linux-rdma@vger.kernel.org>; Wed, 11 Nov 2026 13:46:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ikRnkS6W
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FA5E1F00A06;
	Wed, 11 Nov 2026 13:46:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794404809;
	bh=QMGXNxfyhruveJvjtM7sWayp537nutiZXflmikOX1as=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ikRnkS6WODVkxbgv9BK9OQybDE5rK6VtcV0ZXf6QlJHtVRiojCGscf2bZJV4msB42
	 yU7RETrBGnQqbeBS5pzboFZ4259gn5sx7DoFuPcZFS1jpTKnp23duI1NCEqIgJu8Bb
	 XIpi1TI9Kcb979M+A+Xk6hiL1QfBAss/cPeVWn80ArWBvaQgKF0supJb4aJV9OddsL
	 iyHTvoetfs28NtaVxPOTVCPPlshaQ+7Ph/GVc0UN6MyCCiVTL8qJfAzGIOhJhJKdbL
	 RscscwlC/hOQOrdQEXAfyVsng0Y6B0x0DIaGuFhhKUknV5oGqfDgf1/CcxMve5Jhar
	 WJcSJ5t7yDxxA==
Message-ID: <sashiko-outbox-209093@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH V1 rdma-next 08/24] RDMA/mlx5: Derive
 mlx5_ib_adversarial_mode global from mlx5_core adversarial API
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yishai Hadas" <yishaih@nvidia.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261110134320.34408-9-yishaih@nvidia.com>
References: <20261110134320.34408-1-yishaih@nvidia.com>
 <20261110134320.34408-9-yishaih@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 11 Nov 2026 13:46:48 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> Cache mlx5_is_adversarial() in a driver-wide mlx5_ib_adversarial_mode
> in mlx5_ib_init(), shared through mlx5_ib.h. The mode is the same for
> all devices, so a global avoids reading it through every mlx5_ib_dev
> and keeps the checks at the call sites simple.
>=20
> Signed-off-by: Yishai Hadas <yishaih@nvidia.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261110134320.3440=
8-1-yishaih@nvidia.com?part=3D8

