Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793068768;
	b=Z26xAqEJFaetb05K/puHnXwfkYcM1lLPVp8Nz8cAWApSRX6vdIMR/LN1xqRoxMU3nBaN
	 tPF2luHrvydsImq8ZD8YrOdEnqVcDVqkGJcbUxQpfVLXQMxF0bpTAqQGQQtWqB8Ekdvbd
	 h5eOtit10TEKEGBJ7fRi4fkMGFf12keD9OGAozohe+majE7ZtPkX9Q95XjHESafMHxXRR
	 u9uMKGIpkhpktht6ErrqaVakd0grrOKzgTVLGOrmwLv4ks08ECXi7J/O4uiCyi3otV/uc
	 hUqndxhCH84WcVn7fI8RTylnrUA9DJCT780ACng4hgW4yFxoemDmrsJQg/+c3gMHKCg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793068768;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=tvekes/3F+dcKD9Wu31VnKHwtp3WEzFNFBeQB/1E+IE=;
	b=k9wWcaNmeoBI0OhdENDmm96EGBQ9dlv9V3T2zq458dB01N++E83kzXtXippSJctujJjj
	 mlI0L3pVv3lMYVK4plwk4IP5sUtHt+RZfrTOZ+PpiJj239/67Jkv5YPTBcE7Ni0bfj0FJ
	 VwhLXavF44GNGkIt3AUDAXnq6BePf81kyyHQsGtJ2YCmRuiYXZz1E86kth42JQPNRggLF
	 445l1QMejAyibtnGHDVwkoBxtCXiaj/XbpWIcmuz7l1hjzeog1PKXPEalYfg9MUHnVNap
	 pzYo0GFQ9UOdfWl4WP3HwjoKh0EeehLMgTkMEmBdkXAGdbRxYbtpGJVfjMhGMFcOo3Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="L/crCMey";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4099A606A31A
	for <linux-rdma@vger.kernel.org>; Tue, 27 Oct 2026 02:39:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=L/crCMey
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6EAA1F01825;
	Tue, 27 Oct 2026 02:39:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793068767;
	bh=tvekes/3F+dcKD9Wu31VnKHwtp3WEzFNFBeQB/1E+IE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=L/crCMeycrEadAsoaph7H6fK1wsejmJUWhCXpsTRl6nMi7JpFPjpiTEG6CwmtHVe0
	 SQi/eNyIMAxieELQ16xddHncAfyHR+SZP65rLmhfC8z9K3+Xe17OM5lgt+E68QyyfR
	 7JL+c1755NBmoiqhDnvOXS8I50Wy75lNsq2jcV2oNyzKQ02zYrCinM0dkeq3Q45Qa2
	 raVF0+xXFVrvf7V5qtRIk1QXlkbe7GXtjb0NfC47uRtE2Fp1F9wVWKedElQz1BrNvI
	 ZGXqd+De4qvepJ+NIcwcTDTL7g2qrcSK7R1P4A4byo5LUQYBYfQnq8Yszoe5pSlSgd
	 42y2HlNL27bCw==
Message-ID: <sashiko-outbox-186027@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH rdma v7 6/7] RDMA/zrdma: Implement context, PD, and mmap
 operations
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yanze Zhang" <zhang.yanze@zte.com.cn>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261027021119.2325798-7-zhang.yanze@zte.com.cn>
References: <20261027021119.2325798-1-zhang.yanze@zte.com.cn>
 <20261027021119.2325798-7-zhang.yanze@zte.com.cn>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 27 Oct 2026 02:39:27 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> Add implementation for allocation/deallocation of Protection Domains (PD),
> User Contexts, and memory mapping (mmap) for doorbells. This patch also
> includes the basic device initialization logic required for registration.
>=20
> The SRQ doorbell area is not page aligned on 16K and 64K page systems, so
> the mapping length is extended to the page boundary and the size
> reported to userspace is the very same length. Otherwise the tail of the
> doorbell area would fall outside of the mapping and the mmap would be
> rejected by rdma_user_mmap_entry_get().
>=20
> Signed-off-by: Yanze Zhang <zhang.yanze@zte.com.cn>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261027021119.2325=
798-1-zhang.yanze@zte.com.cn?part=3D6

