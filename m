Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794490210;
	b=OIsi5ZF3LwuDdPjMx/OMyrF2EEYJXxpr/cEjky5KpZOBoEfq68B/PxVI1LlObFrSTDy/
	 Ygcyiec50KDMSV+20eyyYPfCgPlQaVdXFgvGfYtPw1n7nYwOsYUjWWgaxRvMHi6gJ57iQ
	 7XjiQ6yr/DlcuGxEeR/BlanrcxPJ6e+o3UbEG7jN0SMtVg7ce+SQvr5uL5gXDtED+1hT+
	 X3Smb8JqJHi+ZCZcidzBx4kVyCemwnq9GLrhg/wg8OKHoB+86uF9cQnHmUigazgA8xjoU
	 arXI8qlTph9Q8IjaJJyZizBZoGyiofY9t2DbDqMC9nhYHMD+LB8Q2KzbQqyDOXLV1AA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794490210;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=nnaH4nu2FbTKzUmwkmnigLUCLVTUwraTpT4CyX2gHlI=;
	b=lKqtIRImW+GgRzs3EMlTDf3x/RIW6ERHPTtbAU/syhGIoLNcTEKFx3pEVqluB8/nw77i
	 Z8WzzRAgXg12g8HeNJCMxDLeR4uF4D7nweRR35BQ7nEx3poODIyIJrEjc9EjmfHgcAU6o
	 SaK8Hdm2J4JxW71A/jF5R3xx7OoAsfnktjAZcyh32+P6s1p61+ztp4RRW3JDI4ranxV00
	 eR6A9IOgc8qcpO/dPiSuGhiaWiijvvEnjDpxLXNq5wY7sdGVFOE3kXPtny8aSEsDnPIA/
	 fPG3KzQSkVJhbPfrdm8Egz1aBwkMNrXhDKxrxRRyHgarNzqonKcZXBr44mpBSPbro5g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="ilwBsv/p";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A3A3606A32A;
	Thu, 12 Nov 2026 13:30:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ilwBsv/p
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC8A01F00A06;
	Thu, 12 Nov 2026 13:30:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794490210;
	bh=nnaH4nu2FbTKzUmwkmnigLUCLVTUwraTpT4CyX2gHlI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ilwBsv/pyAbWUIi7QbP0RzC0dq7877lHCBLt7mFg3OKgIj+hzD/7BL9YTjNJntDut
	 OxqR8Q4ySFPdsuLzDE390+eNT9Et/NHw45WaPaYlQ9g7uXw+41lnrJ2fJsPp62iJnd
	 6JhRhCfImzmI/yuaDrYihSpszGqe91BkZoqtM4TGjx7bYSYRW33dFBw/8kiDu0xH7L
	 AFptFLMHAG3GrGd28gB8cH9wE1ge9Ml8OfKISc+KMJtT49CMKEiAIa0Mw65vgzAVJX
	 W/IC2hZKZAQzNzZ9qHA7ODCzZc4YhmtFYl+BqyEhqjHFxjtocAIaKPZexaG/JY7gat
	 N6InZlT2N7psw==
Message-ID: <sashiko-outbox-211185@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net v9 2/6] net/smc: bound the receive length to the RMB
Reply-To: sashiko-reviews@lists.linux.dev
To: "Bryam Vargas" <hexlabsecurity@proton.me>
Cc: linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org, "Heiko Carstens" <hca@linux.ibm.com>, "Vasily
 Gorbik" <gor@linux.ibm.com>, "Alexander Gordeev" <agordeev@linux.ibm.com>, "Christian
 Borntraeger" <borntraeger@linux.ibm.com>
In-Reply-To: <20261112-b4-disp-0287c16e-v9-2-e5e8fa688177@proton.me>
References: <20261112-b4-disp-0287c16e-v9-0-e5e8fa688177@proton.me>
 <20261112-b4-disp-0287c16e-v9-2-e5e8fa688177@proton.me>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 12 Nov 2026 13:30:09 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> From: Bryam Vargas <hexlabsecurity@proton.me>
>=20
> smc_rx_recvmsg() sizes the copy from bytes_to_rcv and starts it past the
> bytes MSG_PEEK or splice() already took. A forged producer cursor drives
> bytes_to_rcv past the RMB or negative, and with a conforming peer it
> drops below the peeked count when a MSG_PEEK|MSG_WAITALL reader sleeps
> while another recv() consumes what it peeked. Either way the copy reads
> past the RMB into the reader's buffer. poll(), SIOCINQ and the deferred
> accept read the same raw count.
>=20
> Make smc_rx_data_available() report at most what fits in the RMB behind
> the peeked and spliced bytes, never a negative count, and use it in all
> of these. Cache the RMB length for the unlocked wait, where rmb_desc may
> already be freed, and drop released bytes from splice_pending under the
> socket lock, with the consumer cursor update, so a reader cannot run
> between the two and count them twice.
>=20
> Fixes: 952310ccf2d8 ("smc: receive data from RMBE")
> Fixes: 9014db202cb7 ("smc: add support for splice()")
> Fixes: a4b6539038c1 ("net/smc: fix data error when recvmsg with MSG_PEEK =
flag")
> Reported-by: Sashiko <sashiko-bot@kernel.org>
> Closes: https://sashiko.dev/#/patchset/20261008-b4-disp-f7cd3d96-v6-0-fba=
616c0920c@proton.me?part=3D2
> Closes: https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261008-b4-d=
isp-f7cd3d96-v6-0-fba616c0920c%40proton.me?part=3D2
> Closes: https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261008-b4-d=
isp-f7cd3d96-v6-0-fba616c0920c%40proton.me?part=3D1
> Cc: stable@vger.kernel.org
> Signed-off-by: Bryam Vargas <hexlabsecurity@proton.me>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261112-b4-disp-02=
87c16e-v9-0-e5e8fa688177@proton.me?part=3D2

