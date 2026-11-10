Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794316262;
	b=oFa/DDCgBK9L7bzJQ9J+G045YfO9mTvslTA9AqGPB3gjNZKQxVTqOTaQZpYDiLq2BIzY
	 fipL4H13RX35OZiAkAL7XrUvvLOhPNOr6QTfOAWpT3GLdBh/BSq15Xvo2G6XQ0Ns307Q7
	 2jqShLp96RPRoc3IMEcp7/HbT0i+wV67pg+XL2Uo8YNw21mDsVfU4vlFA9zkxTy0jpTH6
	 Hoybykxe5Et8oB2fI6zGyNQDnfNmS1BHOqLLw/tskhFAJUBvQ16C1lavxr5si58RBrKCf
	 iqiRZn7vsqupGrkRTq2F0vnCL4MQnqOg5sjCH+4gEs2id96Ozm+qBe/ToPJUczl1unQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794316262;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=P3t5t8a1LX+1hKRvYaCa7k0WiRCLd0od+YEV1onEngc=;
	b=OOO5jMebnHjksQaaONuXTbDiFMvzD/ulZzz57SRvCsYAPNdPzbTTYjkHrH4FSYylnCBr
	 KZwtBNs0od3HjG71LS/feGkleRjQEE2zLwE0HvD5Yfx3bn/8aR5lvMiuD0VQPTyeKh7lk
	 4DEgzpQsGeyhD1VL7SQsF7XQNh90j99/uMosp8Rhz4bOcTIADH6MvwSNWLbIlb9UUwp6F
	 G0xHYupiHdYpVRCfmiyaYomBGS5+AF8ipxjzMWeASzZPL6fEzU5F55Sv2pQvjh0RdZFa6
	 ZylVoZiH2UOlxkUh234EXP9FaEXb1Z3545BxITrrWI8jUiKyypqgzDIL7PIKQw+Z4jg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=e+7eELVO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CFFE606A748
	for <linux-rdma@vger.kernel.org>; Tue, 10 Nov 2026 13:11:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=e+7eELVO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C29271F0089F;
	Tue, 10 Nov 2026 13:11:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794316262;
	bh=P3t5t8a1LX+1hKRvYaCa7k0WiRCLd0od+YEV1onEngc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=e+7eELVOPx/iYMGBWAvhdLYvPS7iPCY5pTNITIxh8g2ZicLcFh09QVulUnEyBfUtS
	 twQ2RODt4cQb2wEo6/LDfaEGZxgAnzzGF585zynpnsybgpFERUxbfY72nK5zDWbbLV
	 QCxH29ucRGmZQFXTHx2rgdzYjtRzbKNKu2rgA6IRKFIa59KFU3UcXjM4QNT79xHfGb
	 ZonAm67WA+MOtNcoKsRWoBZ61k51oAS93st0RQeXOQ3WINySvlXcXhLix+lfXsTAfF
	 zpn9KXRBqDpvHlMHth/Dh4QNBd+pWvrJgcBc5d6f9nqGqoAQA2BmoB+dtLGuR/wE6M
	 Am7PMGMgRmWvQ==
Message-ID: <sashiko-outbox-207093@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next 04/10] net/mlx5e: TC, refuse a tunnel key wider
 than the VNI
Reply-To: sashiko-reviews@lists.linux.dev
To: "Alexandre Cassen" <acassen@corp.free.fr>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261109131039.959438-5-acassen@corp.free.fr>
References: <20261109131039.959438-1-acassen@corp.free.fr>
 <20261109131039.959438-5-acassen@corp.free.fr>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 10 Nov 2026 13:11:01 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> VXLAN and GENEVE flows truncate the key and the mask of enc_key_id to a 24
> bit VNI. An exact key above bit 23 already selects the wrong VNI. Flower
> is about to accept partial masks. A mask that only covers bits above 23
> would then match any VNI. Refuse a key that no VNI can match. GRE keeps
> its 32 bit key.
>=20
> Found by an AI code review agent while auditing the users of enc_key_id.
> Tested on ConnectX-7 with firmware 28.48.1000 in switchdev mode on VXLAN,
> GENEVE and gretap devices.
>=20
> Signed-off-by: Alexandre Cassen <acassen@corp.free.fr>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261109131039.9594=
38-1-acassen@corp.free.fr?part=3D4

