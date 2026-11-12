Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794474042;
	b=wdu15q3P1scC7oG5t3/vzti5GIRiquo9GY0muKqaw2jQuplz9kO5nHxs8Aty/mAYdWdP
	 X1KQU58RTAK0BCGkwu4nT6U4Y0CBXNGU2BCaAWErAoqXNXy56MfUMwrs59h2tE8mcqg2S
	 ABwC2UkCOmTFwTW0SYEqAKnZ1foSlIDG1GhUR+yd1YYwW+npq9A8YnV9gIB6V//ql4RW3
	 2xez2f93ir7jfn6aAeiE/g6rfMNHKtPehccnomypXvytbmSgRcK2JdTOySn2dpxkCszN7
	 GYuOC7mM2Iw2KzWdk6P4dsjZBb4eiuYVXhaXfi7EMWiOE9nGhsAEPgzK+exIaq08YaQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794474042;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=ioefC2JnI6i1nASvN5lWMVyWzy/viR/0Ptta1qO4/Po=;
	b=QnjVBpyChQMEJZB9TL+rsaCcNBZO4b5M/UE/FjJN2ZMZBh3bOrFiJ1qcsCADmcHBV8+W
	 Fd+iBDDDxLlgb7GuQLGnWKw04l5bP7+Pk4R7J3b+xlaxGnLnCFidG91I/6OSXQJujiB7c
	 6HGqmBVGZ90Pydd5IqX7IJAS8ZT/mOV9492i95SCaeRnXiKTeXG/7eNQTqbDG7m8WDKJb
	 aYI2WZc7dEsMSm84VyiZXeA6lEw54zjOcQpq8pzMObgSYMUeOaD4w+eK06ogBI9K9IKiP
	 qcs/VsWTLjy3VhFmZI9IuPOnZSbSO0csMq8pSfsd/KXc9VxHhwelS0Tdj3UmVndG0jg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Hayd+sdG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3D3A606A323
	for <linux-rdma@vger.kernel.org>; Thu, 12 Nov 2026 09:00:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Hayd+sdG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B5A41F00A05;
	Thu, 12 Nov 2026 09:00:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794474041;
	bh=ioefC2JnI6i1nASvN5lWMVyWzy/viR/0Ptta1qO4/Po=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Hayd+sdGXiEDrw3cc1AmEskKozFDjDsSh6L2umvFIp9T00XwUYa9BglbWsEVZN8Oj
	 mWBLQ6jovmMiFGfrPVm9Inbax6MQ/28fBj46i144sDnCmPcFMcGU0GYkhQKkezUY2i
	 8I3KNIfgCGhtpjuzf0EwfU/HsMhSy6ZgrPog/1KObDanZAeorB3TkWHnwSE6CfRFyh
	 ad81TcQyylTaG/+o4flZykB7zaRz6Sc8sjny8toeBlbhqINwhtCQw/FDFaZ4pzT3mY
	 WQme6CXUX57L5EdjmJ+QelTYhFScrcvVgPE3YLzSkPpZp/zorTR4SUqIzF8FboKm4w
	 Ih2n2Ye62X8GQ==
Message-ID: <sashiko-outbox-210813@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH rdma-next v11 6/9] RDMA/mana_ib: Post send and
 memory-management WRs on RC QPs
Reply-To: sashiko-reviews@lists.linux.dev
To: "Konstantin Taranov" <kotaranov@linux.microsoft.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261112084716.1483342-7-kotaranov@linux.microsoft.com>
References: <20261112084716.1483342-1-kotaranov@linux.microsoft.com>
 <20261112084716.1483342-7-kotaranov@linux.microsoft.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 12 Nov 2026 09:00:40 +0000
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
> Implement send work request posting for RC QPs. Post communication WRs
> to the send queue and memory WRs to the memory management queue.
>=20
> Advertise the memory management extensions on adapters that support
> extended WQEs.
>=20
> Annotate the immediate-data OOB fields as little-endian to match
> the encoded values and avoid Sparse endianness warnings.
>=20
> Signed-off-by: Konstantin Taranov <kotaranov@microsoft.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261112084716.1483=
342-1-kotaranov@linux.microsoft.com?part=3D6

