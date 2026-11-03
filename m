Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793694348;
	b=DNHZ+sZBVXyt2/1+w0JcThSjQpo7aqIrGSXSa6OmhazufTbPcIsRQdo2sMuWbkBUsE9O
	 rfeVVAHnZH3jTFROiTZk8CBZcf4MNiD//DUAIJCNizz0sO1vNFwKsLuqSPxiomQdlSQ3w
	 t/v66pEmWO3jkGUBRA03p+wr8TWPO3UyeXLY2i4WJhaZKVwjiwhIynbAVGlz7jt5jotQl
	 E0tur/EALnovqSw0KeYdaVe4jCpVR+1EYgorE5YXcVVpOk2u3oGJyqKIfKyTOXQTzKUzZ
	 KQxcRu6UWALCCnegyuWEkxRo+GO6qk9kYUw5e8KkKCzw1TweOM3KlQspKdc48ONNAPA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793694348;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=HmuTOr23OmIA3VI8BaLVJ3BTmHQ1zX46c9wuPz9fgEs=;
	b=Sf/FtLHbvNgowkaBOQWBGpZgk4oLa0EUGMwTyEcq3bHM1eP+y8Wx8ol2dfjuAXDScViK
	 rbef/oaF7LLFtir48RJ2dBlo7+7Y6+PDFtqr6gqiLOyTbq5ZF9buPSBdn2hCnYIRFjDzq
	 tVMDxjxYStGO2EgzPs6P/JvkBfrBou2pPtTQ6HfABruzE5aMfWUhgUozczX3WUSx1TnwT
	 nE2q7M3QUlgIY+S80ai+zOKoqrMqwk1iFL0qW7NEU6CcwEac0w9RMA7WXFMD/IS+0fgyG
	 hwzB6kH80e9HEzc9YWIco5DhFYUth7YgP5aDdHFgX1lb3VOU77A3Q8LyjhjYYf0Aaog==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GAdQCSCD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C0FF606A324
	for <linux-rdma@vger.kernel.org>; Tue,  3 Nov 2026 08:25:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GAdQCSCD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25D6C1F000C1;
	Tue,  3 Nov 2026 08:25:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793694348;
	bh=HmuTOr23OmIA3VI8BaLVJ3BTmHQ1zX46c9wuPz9fgEs=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=GAdQCSCDuojngZnHdzMZ6FrOzh7kmK9mySwoBcd0a70UUY3OWZUz19QeHPNxWX6z5
	 K3TOzTkDPq0dky6z8oW6G1X3OFF5rL1i9bM8TsAxsL4fB6fPgBl9KfLrF62Pmmqgdc
	 5VAseW64URJWm4KLlmpTn2wNUiC5j/M9n+fzhl9LfdOgBHvNs7o2rPmvLP0phwLIfV
	 P3Qo0B/M8wCFXSWpjVO2UDoVk2oedlzj8uQ1Iqb0mi4D9b90eylaJbu7CnHuMx7WnX
	 +lNnZn3yCqDJUMMXwGl5aW41QokuhtQvtgbAMxBbFy7miQXwkbKmRcCYCxowwv6Zsq
	 nPWpW0Yq2ZQVQ==
Message-ID: <sashiko-outbox-194823@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] RDMA/qedr: Unwind user queue setup if doorbell recovery
 setup fails
Reply-To: sashiko-reviews@lists.linux.dev
To: "Wentao Liang" <vulab@iscas.ac.cn>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261103081732.1144512-1-vulab@iscas.ac.cn>
References: <20261103081732.1144512-1-vulab@iscas.ac.cn>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 03 Nov 2026 08:25:47 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> qedr_init_user_queue() pins user memory and allocates its PBL before
> initializing the doorbell recovery record. If the last step fails, it
> returns directly without releasing either resource. The CQ and QP
> creation callers treat this as a failed queue initialization and do not
> release that queue, leaving its user pages pinned and PBL storage leaked.
>=20
> Free the PBL on doorbell recovery setup failure, then use the existing
> umem cleanup. Match the PBL allocation mode: RoCE uses the populated PBL
> allocator, while the other path allocates only the table descriptor.
> Clear the freed pointer as well.
>=20
> Fixes: 97f612509294 ("RDMA/qedr: Add doorbell overflow recovery support")
> Cc: stable@vger.kernel.org
> Assisted-by: DeepSeek-V4.1-Flash and OpenAI Codex
> Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261103081732.1144=
512-1-vulab@iscas.ac.cn?part=3D1

