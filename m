Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5257B1CAAC
	for <linux-rdma@vger.kernel.org>; Tue, 22 Sep 2026 01:09:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790039360; cv=none; b=N+qd1j0VwIjlUIlaWJ+lTEGIhOEAFNc3MJ2RjdSMwMdRcWLVv9VZkxjGKZsWdSHAMQXQ7vZx9Ii2TBnjSaYZMmX051HSMpK1ReLOI9OW2KoCwkicFQd8xAv2mnhrElc4YZ2OIBdoUy4E1M2Smr4Z/VaiAyofab9Y7GrxatD9msI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790039360; c=relaxed/simple;
	bh=9/S0LQLGbtDX+Gj3QKiO2BAHIBjE3knhKdHqX6K862Q=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=rPCGTtBgpu6NJljKgVMaOxDqEGQEfkx5/XqS+AT35wdkdaCUL0ZNX1dQKvvS2+am9pTVSGy8vnU9lrclxkju/PFwBw23WGGLtOQG6AqIsJZ77DVnr1DEm7deLgrYDZCq5hViUPO3tIPMXQlqpzjxEafsV/wyHgvHi49EobFjHQY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=b6Qcu9dw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="b6Qcu9dw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3D1E1F000FF;
	Tue, 22 Sep 2026 01:09:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790039359;
	bh=9/S0LQLGbtDX+Gj3QKiO2BAHIBjE3knhKdHqX6K862Q=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=b6Qcu9dwxZvltuNuS+kRGONASrS8et9UZBcZ8R+kLprB+kB8ROi/668wfwrEKEHQJ
	 dj3kncaIxtvkzN2jBMuL5KlT5jzUtHsX9YY7LUU77m9R+WeUIrvRYopeK2xHIUtbcT
	 jofUcPSngkAXk3KPz/OKc2uwPNiLEx2IS6QkdzfmWjKcR8eRF+w8v7iwh/bB5eHzgw
	 O/pGQUSXPXcFmnHXYKzjRoEyVkYbi806GszvaF90yuvsK2BYREMXJTN0yW1rGFQGFa
	 bSEs0aTOKWHB2flbAMKs5SUMeiztiIC4mk0sTCXKgWc7Y7/BU4ko6pP9AyUY5ztPX7
	 aNO3ucsLl4KMg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH for-rc v3 1/8] RDMA/bnxt_re: Fix integer overflow in
 send payload size computation
Reply-To: sashiko-reviews@lists.linux.dev
To: "Selvin Xavier" <selvin.xavier@broadcom.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260922061230.7909-2-selvin.xavier@broadcom.com>
References: <20260922061230.7909-1-selvin.xavier@broadcom.com>
 <20260922061230.7909-2-selvin.xavier@broadcom.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 22 Sep 2026 01:09:18 +0000
Message-Id: <20260922010918.D3D1E1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> bnxt_re_build_sgl() summed SGE lengths into a signed int, which could
> overflow. Make it return u32, and have bnxt_re_copy_wr_payload() report
> the size via a u32 out-parameter with the return value carrying only
> the error status, instead of overloading a signed int with both.
>=20
> Fixes: 1ac5a4047975 ("RDMA/bnxt_re: Add bnxt_re RoCE driver")
> Signed-off-by: Selvin Xavier <selvin.xavier@broadcom.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260922061230.7909=
-1-selvin.xavier@broadcom.com?part=3D1

