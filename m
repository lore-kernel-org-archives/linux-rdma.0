Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794403204;
	b=Ga6S0DhW1mtiLI66XgkqMhkTW0Um55C1BMCT8c8kC47AK9teqUBUDTxKstXy0mKv0Tgp
	 eMxGLhXXmk9bpVKK44EHpo4I2y778g16u9E3nV7Hob8bqeoLVd8KM6RbzP1Wcao3/b2Xx
	 xPvmMir8fesYv5N0udcJHgiqNfuLG94HmtCAJ6+dhfSVUzVSIxqKIB2zXQpLGBowP2lmS
	 DG8jMWNKFuki5V+hInedlPPBC3EAtp1+aqy2LjHjJGQjVY/TBrSBbA+73vBvtWMZ5Fb0h
	 EdrpoBVk9yJUrxS6zzyETLLv58+x5uM/aZtJRLD/ViuBzf/hBfC/VQQirGCoPv8MRGw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794403204;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=5U7fXdhcWHGo+AfnENw+qvfZAwvIbC09uMgnRt3gG3M=;
	b=IOZsUZF+NFdH7QsjCz1ORT6zsScK9/ajgnljfWg5/WvuwIaxU/fC4ZrHimIpke178nZx
	 iapwyEUexlF2fl1P+ISofhGbUPr6SAt1zmp6f+flTq88ZXg//xGSuC0eBqFFEPpjoLIJ4
	 qUKuRD9vS0K8LMyLJ4BAFxfaEEMihxOJ7hVSEt3urFfXILfvdx0lwVWXR/Zzyk8is+wBY
	 hQqrW1e8lVR6OwfdaMjqsHzfZDspi90BkSs2KbXYEyr3z2sBXZx36y882Xib8u+LhlDEx
	 QfL+zzj6Pl/Nt4Lers8R0Az/dUB5DxPA4HU5pWT6v9bwwUKoUMyK81lIEx4oCcrGKAA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=A2E4u6c3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46CEB606A326
	for <linux-rdma@vger.kernel.org>; Wed, 11 Nov 2026 13:20:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=A2E4u6c3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B45B21F00A05;
	Wed, 11 Nov 2026 13:20:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794403203;
	bh=5U7fXdhcWHGo+AfnENw+qvfZAwvIbC09uMgnRt3gG3M=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=A2E4u6c395yY8xYOu//K6/E2gGzlYaSJUyWxyJcw82xZEaeMzUBZLUit6aAQ8FEr3
	 ODKhKQupGnr813blyaOBsfdjta4xTpw/S1dEUv9ZYMIW0rEfPNW0HsJfsVNtxI1hXn
	 ptw0zj3rBLsTaRChRlIACSKTkFLd6QeT6RMOpRHgCRXTJkhiqZL0yTwTE6ZAPw8Ga3
	 h0UlbocnymlyfcLFfy4mxfkUpfqKMYkXXKEXUaoAstE5BjSXn1Sz1JyHHnfouhbmYr
	 7MnXlGWEixGLIJWRs6RdYzN4IMPmluU3/GQMfiF9eqa2ObdqcIO7GiBOtnu9K0vbjS
	 ibOV7U0+Id+0w==
Message-ID: <sashiko-outbox-209054@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH rdma-next v10 8/9] RDMA/mana_ib: Flush and notify CQs
 when kernel QPs enter ERR
Reply-To: sashiko-reviews@lists.linux.dev
To: "Konstantin Taranov" <kotaranov@linux.microsoft.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261111121417.1265896-9-kotaranov@linux.microsoft.com>
References: <20261111121417.1265896-1-kotaranov@linux.microsoft.com>
 <20261111121417.1265896-9-kotaranov@linux.microsoft.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 11 Nov 2026 13:20:03 +0000
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
> Complete the RC software flush path by adding a kernel QP to the CQ
> error lists when it transitions to the ERR state.
>=20
> Invoke the CQ handlers after the transition to flush pending work
> requests.
>=20
> Signed-off-by: Konstantin Taranov <kotaranov@microsoft.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261111121417.1265=
896-1-kotaranov@linux.microsoft.com?part=3D8

