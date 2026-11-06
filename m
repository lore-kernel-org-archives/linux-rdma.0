Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794004534;
	b=1kMd97qZwYZqK10XUd1xpNLpiAeH6jsQqoaaIOqOaL3qM979uSzQ6NU+qtcmZgGUCpFr
	 r1hdoq/g9KBGiOMCR/gP6cAdIy2ePzgZpkxo531smtZqlB5RxYIgSvPVWBXKEDMIazDaJ
	 XQVXUjArysrTBUY6130GIM6gsXdTpJ3kXC6nY3UO69/bz+lNhsJ41I9QvDdyW6IIFoGpJ
	 +9eE5mxGldclrtccOJL6/xfCs7XzVsS152CrqWoETweuf+GSWsnrYcaG47xNFdXaLaj4j
	 t7aWsqX+zr2WydKFpW8mvhN5DtVS7CuT7KkR7t5yPa9hwUhD/uChW/OybvBa3spmJUQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794004534;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=/+YF70gO09Wl7IuA4uBA5NHMWG28d/LH1MhjDDHcyFk=;
	b=FesqeS3kpx+oiVDxDi4cuu6HqHDpR0Aw/y5uwxJDxoPsrEvvJtYEhvLwLm3AYXD1hjKD
	 TAeUsRhWuoQK2PrhvIDlsgXnbsNdRTSEBb0Xk+PI4lmbRBYP8bP6lzHaYm2xg2B0vZP8X
	 ESz3VvRGE8/TSFgPX2D8HEYmep88uiYk7wWGe79vIubEduCpxjysX21MD6MI2B8uv4l2C
	 OlpcxV3WAXSmY0h+JIT7fIt53WY8X7ajhn10RNYRR2HD4BY4Os2CHHTkNazOsl816LQCx
	 CyQiYUeaSP1zUnMqcB0fA8u+6cJUmHFLgE0fg233e+YZANA4ev6nVVSgexn3FgMURrw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=SHuXcOzS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF98C606A326
	for <linux-rdma@vger.kernel.org>; Fri,  6 Nov 2026 22:35:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=SHuXcOzS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F03B1F008A1;
	Fri,  6 Nov 2026 22:35:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794004533;
	bh=/+YF70gO09Wl7IuA4uBA5NHMWG28d/LH1MhjDDHcyFk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=SHuXcOzSUPRv1rWk72J120nJMti7HOm6OUE54wzIbabww0PDsajcJJ8rbBFbn7B+V
	 z1/qLLq36wNYqLmQChfyWh0lD4uCJUJIO+y9ojWGiY9EIp8jVMG3z+delRlLO4GqZy
	 oUhX7NOj9Jvs01ct0PsLBpKLe/t5m3iNmi9haDC5ZEIyChL2z9MNUtTTXCEID/a3A1
	 8Ht/eak64brmcEPB5iW0W9WTFrJKK7+kc2vm+CBt1iLE5uOokI/Mx1EWXjy+Jh5ZDh
	 pKtlOSolieIOaH9bLTmpEX6Vs93vCyn9xy+kDtVX+M7Iz64uLHWXGboUwH1uWYb6fg
	 UuNTcZw8MRBRA==
Message-ID: <sashiko-outbox-202337@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH rdma-next 3/4] RDMA/irdma: Fix CQ scrub for SRQ
 associated QPs
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jacob Moroni" <jmoroni@google.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261106221201.2266301-4-jmoroni@google.com>
References: <20261106221201.2266301-1-jmoroni@google.com>
 <20261106221201.2266301-4-jmoroni@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 06 Nov 2026 22:35:32 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> When a QP is destroyed, any pending completions for it are
> scrubbed by setting the QP handle to NULL so that the CQE
> is skipped during poll. However, completions for SRQ WQEs
> use a different offset (40 rather than 8) for the QP handle
> but the driver did not account for this.
>=20
> Fix this by checking whether the CQE being scrubbed is for
> an SRQ WQE and if so, clearing the correct offset.
>=20
> Fixes: 563e1feb5f6e ("RDMA/irdma: Add SRQ support")
> Signed-off-by: Jacob Moroni <jmoroni@google.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261106221201.2266=
301-1-jmoroni@google.com?part=3D3

