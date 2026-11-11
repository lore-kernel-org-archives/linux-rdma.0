Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794401767;
	b=mdtVSHaGBlj7En579yUm1GDrU/z3dZdD/Us+o+Gmsf8c4rSgAZw23moLvaPhHWfqDb2+
	 xoTa48pdkEHOQ5OhA17q3KxMfvMVHMJCUkcEPl3+dGGyBseprV7S+w62gqr1mjkJNeHdq
	 Vk2S8lDYtPcVygki5dKjlv5YGe+FfvxXmk9PvfTZNG2gDsEBScC+W/0mloMGJw3rbECd+
	 KYZbSr6yxeD98t4NK81M332/VFm984R7A7ad7rzFE1uPHzcBLrLmZlSMkmRLt4EXmPOF/
	 OvyYIwL5e3uqxhbHjRLVtLWkUgdbNzPXp8+4nhZ7c7CZF8dMrELLQpss4042wFqgoHQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794401767;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=Viq0h3WZ+k2K5p6yp68WgoaHUvcjBzUO5a60gBoJYf8=;
	b=up6w08Et1DFIQ1mLbiQH3yHsvmMWrB88KuPMbJ5vb8XS7S8/08fPlf8jA2xaeibP4Yh9
	 dHcK1jNc6PN6FZgGKY+mp/iR5+gEVI35dIOtTojvdi9y/1mE7s+RHz6yRl9kuMVDt1sKu
	 RcCrYOZgvYIxH4fP4854+IiY9jrw9vDtyY8ASBU7/ZGjqEQCEko2hwsjXmAdl/vbpJQE1
	 WM0pTNRczXsZ8r0rUL1v/O2wS0rwDlgjW8VcBTshcGARV7elhVRj9CUro2s3PlzRdyOkx
	 YbvWvB1w5xxRlGANQIAyT8H++/rD5/dIa2MhCRHYQRTH+AJyqqD/rRH5xJF4Lq9UHcA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nXDwXPFN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D121F606A31C
	for <linux-rdma@vger.kernel.org>; Wed, 11 Nov 2026 12:56:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nXDwXPFN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8569F1F00A05;
	Wed, 11 Nov 2026 12:56:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794401767;
	bh=Viq0h3WZ+k2K5p6yp68WgoaHUvcjBzUO5a60gBoJYf8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=nXDwXPFNpp18AOyROZFf6slPa+6av9iae1tIlgYAhKrHGh4aFibX4EpTf5RYw/yUp
	 yY4xxE68Oc+G9uYplnfs/ceEDkB/df+N2EURMA1tdPQ7jwVy16DYtHPNOFD7jqi6Y4
	 LCvuo7VvQ4vUeAx7Pjz0XLpMlWX4B36QqWMzGHk1KcctgWyGWnXcLhIpUE1hbHo7eF
	 mF3vA3eBmt8XdFuK+WJNaUv/62v7uIxCGvEGE3RpKbOPCxLALnR7nbIHl2em9RaS0n
	 hirZj/bScjacJU4+WeJt54qsKVmc4K1uVu2NF/9N2FJMKtUX3ri/xP+TsCxBxp+kkd
	 a0wKSMOFTIvcQ==
Message-ID: <sashiko-outbox-209026@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH rdma-next v10 4/9] RDMA/mana_ib: Maintain kernel RC QP
 state
Reply-To: sashiko-reviews@lists.linux.dev
To: "Konstantin Taranov" <kotaranov@linux.microsoft.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261111121417.1265896-5-kotaranov@linux.microsoft.com>
References: <20261111121417.1265896-1-kotaranov@linux.microsoft.com>
 <20261111121417.1265896-5-kotaranov@linux.microsoft.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 11 Nov 2026 12:56:07 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> From: Konstantin Taranov <kotaranov@microsoft.com>
>=20
> Update mana_ib_modify_qp_state() to support RC QPs. Initialize the
> packet, message, and frame counters for use by work requests.
>=20
> Arm the requester receive queue at the initial PSN so that a CQE is
> generated when the specified PSN is acknowledged, indicating send
> completions.
>=20
> Signed-off-by: Konstantin Taranov <kotaranov@microsoft.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261111121417.1265=
896-1-kotaranov@linux.microsoft.com?part=3D4

