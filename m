Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793803637;
	b=wL77pqUuB5Mbp6S0fmFK0KufY01yI7CmnLh9pSE4c6UW/vrsF05frAMbK+OYJ0R9CxYt
	 xlMV+hzY/+i9NpAnwvrm1aWJEKEd+e4qIV4NKUipT+01H+lu1gkWo15wrRGKCiYKuiHUJ
	 FVAM/cWbt/3NYTIoCs25tVpSOycM8GeVEVMMXEP/ipaNe1DaQvgXmfUzFReFoGM1Gs9sL
	 R2df4BOEsOK4BNVxpdIpND6nPPeBtt+xTJAal3Bx6H6ML+DbQkT526UEsOR0eAGKYA3GQ
	 jydBicy4NbGhoXZ7bTQuNfGZt489zU8mNt5/+/zCrlTqEFHF/TuIZQUZW3P4y6D1PpQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793803637;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=rjpYOOoegzssyHKZNpQGH43rWW33Tc3ffXESaOiHHz8=;
	b=JQ8Oe8L7XS9qkhMNKBfjjBLuMLViygnJq+bfqFMEo5ccK1ohd5W3qBgorF8f10wDXJl/
	 H0AoYtGhsBCmHalvglwrmnsujFFvRv4IaCvnjsXzPpwD6BQ3r4TIj6QlU7+zXUaYzToXE
	 jGm1Ct5gOKCJvFI6h6ue2hWZUfuWaGQ0xV4U0Pvruq98ce/J0fsPOvqgCJ12w7zm6OJx9
	 EeThsN2zKtpvzGFZKJ3mbMKTXmWAVBsLxLPGT0+tpkDzN+J/6A8qLQo7V4nmH/1+vGJyE
	 KzFcTZ4HqdBS9rUH3nPD9mCNifZpTHfvsYczyNbepoqF/LNZooQKRPjeRttvqpVFwCg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="K2wM/ugy";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C7CB606A328
	for <linux-rdma@vger.kernel.org>; Wed,  4 Nov 2026 14:47:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=K2wM/ugy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8B351F000C1;
	Wed,  4 Nov 2026 14:47:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793803637;
	bh=rjpYOOoegzssyHKZNpQGH43rWW33Tc3ffXESaOiHHz8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=K2wM/ugy1EivArEBR1xlw1l9E8H/adJ/UgZwjHJzSKzYoEMt9ahOrkyfXEqPFF+3e
	 +3SzwAhHmTdUlV61yUFEm3Fpv5nWbx4iuRaoisEmhWqsDkq5khqMT2k5TsU4u12qTc
	 TCz7b9Nk8uYhsEidyKaw/aoR94fb1zb6+eCNYNzKcXEcUKkIK6F5zgFvSi8rVlKtXY
	 PupsIk9QlaiPmHk36ABPf/eEoJtbL6Lm420iOqLaIhw7ELcBCq5EFjb9l7G9GasG/H
	 9PKinyd5RnVNCsICrduQ54UgMdkdgZroHO6wIUO1Rw61XwqfHTYsMCnW6WlSXwmVae
	 IKMo/enuxdsQg==
Message-ID: <sashiko-outbox-197463@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH for-next] RDMA/uverbs: Zero the QP attrs in
 ib_uverbs_query_qp
Reply-To: sashiko-reviews@lists.linux.dev
To: "Selvin Xavier" <selvin.xavier@broadcom.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261104200244.52979-1-selvin.xavier@broadcom.com>
References: <20261104200244.52979-1-selvin.xavier@broadcom.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 04 Nov 2026 14:47:16 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> ib_uverbs_query_qp() allocates qp_attr and qp_init_attr without zeroing
> and copies fields such as alt_ah_attr, path_mig_state and sq_draining
> to userspace. Drivers are not required to set every field in their
> query_qp() callback, so uninitialized kernel heap memory can leak.
>=20
> Allocate both structures zeroed.
>=20
> Fixes: 7ccc9a24e012 ("IB/uverbs: Support for query QP from userspace")
> Signed-off-by: Selvin Xavier <selvin.xavier@broadcom.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261104200244.5297=
9-1-selvin.xavier@broadcom.com?part=3D1

