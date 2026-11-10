Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794279693;
	b=DlCfTk8MHo3WdtHFr6akR3EqSS38o5Zj6GPhZqqCDU9UZT9lv51jRsDX91tYETKmQuBY
	 /Qt2W8i1on25GJRd4INXM2bgPF+dEmil4nNQOJ2ueWGREV8FUnjppP4FoeJmuWtX0ObRD
	 5oTyAwXgdOHsZ4I048sTjSGYt2rnlX9P3YMc+x2m5uEevVpGwAyb6Fi8e3O1fUXPO+x7r
	 9EN30C1P9KR9L3w0iSwxK7dcS3BQcIC7S1aT4F24Ud0N6tddewMvl1kbpb7EUfBu8w31F
	 5jXSlVpVZev0q2oETeSwF9sDtCbCjOwYm/1AcMG8aneL2xTjMHsgZOfZh29rVlf0sOQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794279693;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=pRrDHox4qDE3kdQ+Gin0j5v4oZ6MkdO3ZPBBtDeZtaQ=;
	b=AuTXthapyeWxmOukuBIktKrUcj7TQ/ZS+8ysdVcFfcEAxJrzmjs/oQPnw7PzWSWTfc1H
	 gkubiqwQ1r/8N99tEAYW20JRqhpaU5+niBNyMtFzznpxmHzsQoSHpsABMiofRbmRZarPx
	 7wooHImRRJD+sl6mOX0g7KXLoLRydokDIjxxQv+P8aVEZFcylZ9aV/HveLAZnu+8tIaZC
	 Or8JGmlPw35GZU4YM9yfIW3OQHEtLuCv+RRBZnIYjtGz/x+1RiXR7U97PtrLLWJQYMslD
	 diHkzHmJ7mIsQQfcyJtSfnUxJDtLR4sFLyghj/qlJySdERV4VnLQZ72uXR1zwJLMseA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bp+vcue0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 893A6606A326;
	Tue, 10 Nov 2026 03:01:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bp+vcue0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B92CC1F0089F;
	Tue, 10 Nov 2026 03:01:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794279693;
	bh=pRrDHox4qDE3kdQ+Gin0j5v4oZ6MkdO3ZPBBtDeZtaQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=bp+vcue0KmOwFLkpqKRpEvKNAkn4dnpj0Qi+I938zEYaQrHriHbTMYQdfuc/0jUKk
	 Ha4kIkOgPpXcPVCUWw+XD84d3mbA+HxwheequHrybXh/vyTNOmUTgmJnU6sSURJp+X
	 S4HXjAzif7+qtd6znbybPswBMquoeNR84ODWlN0kskDFaiGHSJwIU8HcXQQqSgnuTy
	 FCShdD7woWAGMbrE4XaBK/B5a+dVlDd3iNQAY8JNjYbhFAtpf6nmehZfPk8Oa7hMv2
	 rtLhGExOR9wd14nlm2xn7PMjdIqvk48hCHbnOuJB+vUzgAR5rFTgkLVWH874wasP9B
	 AM3E7BAIKscQA==
Message-ID: <sashiko-outbox-206085@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next 12/14] net/smc: annotate data-races around smc
 sysctls
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jiayuan Chen" <jiayuan.chen@linux.dev>
Cc: linux-security-module@vger.kernel.org, linux-rdma@vger.kernel.org, linux-s390@vger.kernel.org, "Heiko
 Carstens" <hca@linux.ibm.com>, "Vasily Gorbik" <gor@linux.ibm.com>, "Alexander
 Gordeev" <agordeev@linux.ibm.com>, "Christian Borntraeger" <borntraeger@linux.ibm.com>
In-Reply-To: <20261109025425.328445-13-jiayuan.chen@linux.dev>
References: <20261109025425.328445-1-jiayuan.chen@linux.dev>
 <20261109025425.328445-13-jiayuan.chen@linux.dev>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 10 Nov 2026 03:01:32 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> autocorking_size, smcr_buf_type, smcr_max_links_per_lgr,
> smcr_max_conns_per_lgr and limit_smc_hs are read without any lock while
> their sysctl handlers update them with WRITE_ONCE(), and the SMC netlink
> handlers toggle limit_smc_hs with plain writes. Add READ_ONCE() to the
> readers and WRITE_ONCE() to those handlers.
>=20
> Signed-off-by: Jiayuan Chen <jiayuan.chen@linux.dev>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261109025425.3284=
45-1-jiayuan.chen@linux.dev?part=3D12

