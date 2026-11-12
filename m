Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794474345;
	b=Kf2wPfQzpGiiot/cZcRNNkhJSYRts6pYE24Ae/7Ox6ZYoX8h609k6wxaICTCHGk1O1uU
	 TtpgxpGGLl09W1ZxzmqXIXYJzqP5OAD3kGP504fEHHYnNp0sl/xray8m5CSE8c04cvBUJ
	 7fn+xkB/LE8/Uv3CEWdvB5dBQN2sDJJhjnZGgpQvweuj/xgjjBlBgJcNRIDv2v3/GkCPx
	 EMx5QF/qQFotsyg5xW5k4Z2+k6kHFRhorZXa1POqYgjVUhvOBarFm5K5ZbhU3FR4xMUIW
	 oFNv9rVcibszYO3vzcCWBmfGRa0Bt6AdZv/z24AGmYfDHh5GMEPTCf9VMc9b24L58nA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794474345;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=pC95PCOwgW6SkjHJB895jzDie0Tlpk7BJlrl2NFMI1c=;
	b=YacJ8BWjwmMy3RQJl9VekBZjhL2/t831Jgy23ZmbUA7RSnR3KvRVHfZUroAVdfbPpzid
	 fBJyLtNp9G23I4Qx15gaZVQF7nLT0h/9O7EjPCinV5gQH1Q30oazhN8KjWC/nRNh9wmFz
	 xl2EcCygHw3j1wglCoqiBrdhEAhXA2F7goyZihoS3Lct3X4F16Atun2eFKp2grP/6+IXB
	 q/m4fcHpc7xgWs49meKQ/ZeN/xAtMjThJf4LaSAXSSGK7071qFP0GCPP6uYQ7PcOoIhIY
	 qT+NNYwAhudGtjlpqhmNdAd28u2TW/AfsLRu/lpX4ur75wWrTIeKN9zAiKnkFDXgwuw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VGg2sJju;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F072D606A333
	for <linux-rdma@vger.kernel.org>; Thu, 12 Nov 2026 09:05:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VGg2sJju
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 629151F00A05;
	Thu, 12 Nov 2026 09:05:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794474344;
	bh=pC95PCOwgW6SkjHJB895jzDie0Tlpk7BJlrl2NFMI1c=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=VGg2sJjuYpzMcbtqY5PkgGwPQBVM/ORG03vUjGwbL5XiGADUb447JDRiAU1M6XTlK
	 gEVmAZdWI1IhjbgmnERa3iG3/gvzDU6T+cO2yUPXLf8KTbZzWDcdWvjxKR3z7Z0+Ux
	 mmnlm2oaYcyQOk0+LGALrF+ODYMjQbPVDj+H7OqWSU4mZbHwkmo5CkAo/QVLn2l4/v
	 LEGiyas8pwexwsRQjlmoTk/HLq+GBZpIJ6VIblu2vFgJFAnD7Abm+wJV2lhK5JSvYl
	 loh+CjO5vzy9aweBwJRGMC5rCpgwPlxNU182Jh9FpUFD70Y+5I6ApbzwS+PlcY4R91
	 WL3GnZ1cjf0hQ==
Message-ID: <sashiko-outbox-210821@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH rdma-next v11 2/9] RDMA/mana: Create and destroy kernel
 RC QPs
Reply-To: sashiko-reviews@lists.linux.dev
To: "Konstantin Taranov" <kotaranov@linux.microsoft.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261112084716.1483342-3-kotaranov@linux.microsoft.com>
References: <20261112084716.1483342-1-kotaranov@linux.microsoft.com>
 <20261112084716.1483342-3-kotaranov@linux.microsoft.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 12 Nov 2026 09:05:43 +0000
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
> Implement kernel RC QP creation and destruction. This feature requires
> extended-WQE and power-of-two-SQ support from the HW.
>=20
> Signed-off-by: Konstantin Taranov <kotaranov@microsoft.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261112084716.1483=
342-1-kotaranov@linux.microsoft.com?part=3D2

