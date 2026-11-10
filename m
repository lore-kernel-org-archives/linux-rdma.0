Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794285400;
	b=CaWEfnk1p+EngULFv3VqJ+SW7OTs/9fYNuQrLKCNtK/Bvijh1Di+j0oPk6DDZ7gv24mb
	 ed5bnwozFflA6Dz8U/gkiUh+CrAhRoxzgD432W68yZuKHVQcWR7x6uZS10IL/g/4dgOTU
	 n9haicN8U/CrdyGVnHSkRAZf2ef4zvdvppqPE4WcGtenlGg7TqTXnGIfWKngii9HeCBiM
	 LPdBuie8QDyAuU9F97/PnuyZetVcHBFOlwNgKmdhpxzVyXzLGUOGhPAq4IlX8dO2W2ARq
	 HGDjjpPVWrsLGAX0vxGW7692hG75zLsp0jjbGQNAJfiKnNXm3FLwrZ8OJjhu9tGnuZw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794285400;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=tSj9bHkBst39Ta1Rae1cd1CF5Gpmb+vjBbBuk7uWE/Q=;
	b=UHDvlOeSMW5yrQJLUcG8o+0tKdn7YU0vXSM/F0WTDdAm2mzpMTPvNP3JpeFpalntVkIQ
	 ZjfDwjxeJmr2NVo6DZePhsnbLEdBWL9tY5/viCS2FrnFw/T5eH0Dw9PVBL1IymXbQ4NH2
	 sTlgnSIcJ0uZijiUK7QHj+/aYlTMSbAJn0nd7VYGZZvm1UWZvrQF5koiRYwhXB839IrHd
	 Lg3FF6cV9PibXiN55/zHfkgBRDQ/MpOaPcm8WaB7Wm3C9jt72swnqAhgctXyTMpx+cdOA
	 77+m1FfjauJfE5WHl8GEb5KvoiPwoDU5JEcVYYS7KAR0XFfucWm531W/8xQ7EcUd2pw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=aWWBQOBt;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23150606A325
	for <linux-rdma@vger.kernel.org>; Tue, 10 Nov 2026 04:36:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=aWWBQOBt
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4C0E1F008A1;
	Tue, 10 Nov 2026 04:36:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794285400;
	bh=tSj9bHkBst39Ta1Rae1cd1CF5Gpmb+vjBbBuk7uWE/Q=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=aWWBQOBtm86gMUuUgFASVXL1UgJERH/h1qnhtFEXBM/LlmsbdfZWC4LMcuaD4La6w
	 9mIc8SvZ6X0S02h+sJj1Fmiokpta5lZKcYfxnXuUHWDosMlIbSiKRMP/eQs3tvh5an
	 7p2O2YKn5geMJaFyY3Xj14w64xnHGKGWoriaJLSN2MviI4PEFYjrHL9g8ohPMlASG9
	 79xq/3I2USxROvMhJ09COGHIog30L+AdSVxOY3p3cMLtctdrTrrvwapCMVEi3IjWH/
	 X2SzUWdmX2g9L+uCIS59vzFKAu+FrBEm0Bphp4osPPQvljiXKwqkGFGZClE2hQMLnc
	 io92bKvr33XRQ==
Message-ID: <sashiko-outbox-206218@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH rdma-next v3 04/13] RDMA/core: add the reliable
 unconnected queue pair type
Reply-To: sashiko-reviews@lists.linux.dev
To: "Eric Davis" <eric.davis@broadcom.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261109-uet-ib-core-v3-4-3e7e7ffed2e9@broadcom.com>
References: <20261109-uet-ib-core-v3-0-3e7e7ffed2e9@broadcom.com>
 <20261109-uet-ib-core-v3-4-3e7e7ffed2e9@broadcom.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 10 Nov 2026 04:36:39 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> From: Eric Davis <eric.davis@broadcom.com>
>=20
> Add IB_QPT_RU and its userspace counterpart, together with the field
> layout of a reliable unconnected queue pair number used by UET.
>=20
> Such a number uses all 32 bits, unlike the 24-bit InfiniBand and RoCE
> one, so exempt it from the restrack assertion that no queue pair number
> sets the top byte.
>=20
> A relative number is named within a job, so pairs in two jobs may share
> one, but restrack keys a queue pair by its number alone. Until it keys
> them by more, refuse the second such pair with -EADDRINUSE rather than
> leave it untracked.
>=20
> The provider posts its work requests, so the write post_send and
> post_recv commands refuse such a queue pair.
>=20
> Signed-off-by: Eric Davis <eric.davis@broadcom.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261109-uet-ib-cor=
e-v3-0-3e7e7ffed2e9@broadcom.com?part=3D4

