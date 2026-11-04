Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793810631;
	b=eDz+FJBhTcvsN9LZyOo8AAxO0GLCAQgRaQZwUWjiUBM0fj+DjmcP3htLIVn5hfP60smd
	 NhqGhggvVGto2rcfgSX8x2Gs3s4uRfoAu/fR/yhJHibIr5oQNk7gRQ1E5CXOg818IXOwQ
	 XaZn61BZ0oEti55nFAFVIsSWTjpYTKykTNSyo5+zc2Zpf1HNVMsNvtT9LADcF0zNCYdBz
	 b3lJMhptv9m6ONUD3g54XwQtW1/qZN3ZLaIWN/tF2ZacTS1cNHhKbjAwPWeHJdUOogijX
	 ZhxQRQ1b0Gw9LMaVMekFK1Xa3dkkrZGJun8qP5izqdSNdGOMFPKI7RSzglsE/1a8NpQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793810631;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=azB31zvqdPu4LHG7GgtNq6MsSTRkXvzh77Nc9Y4POMg=;
	b=CFx94SBIzrJKtrQgZYYHg/sWRIpmDIiKNQiNWCrqXd2eZQelkFhFO8vc7E55lx3wmD1B
	 EzYKZnFJKp04sUkWPRI+ivU6odPuyOl29Xs6e3ezWVhiP1TBhytOkl4k25U9CXFOjxaEb
	 fE2A5SrVXW8UpkoT26BwhuADRuT7D55LIec2Y12kpVI4VIHySaRYd+zS5JvAqy31EKxVi
	 Nh+w+DHMQZ4hNgA8vZZXXGua2KiA6AA7Pe2XUbtmyOqD6mYsUgXdKQwvSWOa5M/A39C+X
	 ljS9e/SjVXFrKZK0YSqoJm0IUGKJZqBKGOBUOhZwXzNqltyQ/957VfMmI2EnNAjLjEw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JlhK8vGj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D037D606A33B
	for <linux-rdma@vger.kernel.org>; Wed,  4 Nov 2026 16:43:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JlhK8vGj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 883C41F000C1;
	Wed,  4 Nov 2026 16:43:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793810625;
	bh=azB31zvqdPu4LHG7GgtNq6MsSTRkXvzh77Nc9Y4POMg=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=JlhK8vGj8vJkdIDpScVb66lIBH6NBG4VaVWyP/ZbPlOo/ISoJOHhX1Q6mEm01eCR6
	 9qb9ri7hNngaazQRBUYxoR5GCYjn03cmTi10MgHBLpevdoQvmrC9WoGaO79PEYsbAE
	 ZSk7YCec3djYL5XUAXolpvT8QZYYqui6QRFhUT0eOvjVEhJtwZwhB21nweF2wd/BQl
	 0/FB35wsMomtUIyGrjoDdeBeZSUr7A8trn2QY+uAWBQmFNcfhdj+/PPsfJNcqXz0Gk
	 RSq9JfneRk/1dm9WHsKFXJUcJp3nQaiTWYhNos/jBeQ2OmOkzp6Bglpv+TV1qmBZI+
	 +7+lp/ZnBVExg==
Message-ID: <sashiko-outbox-197661@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH rdma-next 08/23] RDMA/core: Suppress kverbs_provider for
 adversarial_mode devices
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yishai Hadas" <yishaih@nvidia.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261103163949.1554-9-yishaih@nvidia.com>
References: <20261103163949.1554-1-yishaih@nvidia.com>
 <20261103163949.1554-9-yishaih@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 04 Nov 2026 16:43:45 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> In adversarial mode the NIC is not trusted. Kernel ULPs such as MAD,
> IB CM, rdma_cm, IPoIB, SRP, iSER and NVMe-oF trust what the device
> reports, its completions and the data it writes, so they must not use
> such a device.
>=20
> Add an adversarial_mode field to struct ib_device and clear
> kverbs_provider when it is set. add_client_context() then skips every
> client but uverbs, the only one that sets no_kverbs_req, so the kernel
> ULPs never bind to the device.
>=20
> The driver still implements the kverbs ops, as the uverbs path shares
> them, so kverbs_provider can't be cleared by the existing check of the
> mandatory ops.
>=20
> Signed-off-by: Yishai Hadas <yishaih@nvidia.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261103163949.1554=
-1-yishaih@nvidia.com?part=3D8

