Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795138323;
	b=NElntkZgDZOiU4P1sWGK9tfhSVYvv8IT30X6a9frnepE3QvVTHv4KPsuMiSarlMqk9Ek
	 4P/5J8rwx5bzp7SMU3QK3xJeRooJH+ijvxz2eW81cU1IPuXCkG/7K5XYn9E3XR9ATs9Cq
	 ieFN4yVkAF8hrbBFKWLBbpkLRqUhyWnS3nrIp/SnCQPNO+x9oa5NyQirr7zcf63Ie0AK3
	 +Dj1KS9nZE334JHo8EOjZBxADlm29r7Oa2KbGk0KtVzFYTAHjTzmcRA4SPtj3OK2sqF/a
	 Ki0boSpgQNGl+NuvoOQ9diOnDGa5k9SnxzxnXgh2vrWjw9w/iWGvguRmKtwkTB4E2Fg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795138323;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=TQ3efFJHBCfb/clND+S3FxhrNonUr6UAmDTCqDvO6h4=;
	b=x4qr1qOlwrBYHvBTZLhUYlt6+LVE1+YtNN+tDkKtaxirhB1SXLwH4Nd4N8xAclQ8sZwk
	 sDlqmVJXYRwqfvmTa/LEZYlw0m3y0gDyzOUU20oLXl7NZ9ENkDr7agKQhBgUCTLUQdCYf
	 i8lOaP1HLHn0rhsLRdJPpAwFGN20IaoGYTT47LiArKHyxQ+82yxlkg9JnDE5iKvh8TMjs
	 OfGxCVmLhMeyI5SAwJq5RBkMBoIOSmWjhHEXZ0UbfwCre1S8rOCjqQB6iCahIV9+b5xQV
	 MlL3w6na/jzTY6V5NwdnaHxedMWqGu1O3wOdbz6qBYQU8K44WMiFao8BPPMrZk9RTsA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=CUyinNH3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90CF5606A333
	for <linux-rdma@vger.kernel.org>; Fri, 20 Nov 2026 01:32:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=CUyinNH3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 134FC1F000CF;
	Fri, 20 Nov 2026 01:32:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795138323;
	bh=TQ3efFJHBCfb/clND+S3FxhrNonUr6UAmDTCqDvO6h4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=CUyinNH3LhZ2yaU4wKZFb1VZDmpSMegh/AvbNws5SOMJd8Z7swpK1ol9VaoQKqTyV
	 fJC2XqQbHJFLr1SLvuvIKIjiY7X0Aw+W3soVkAfYkY8Bp2oeGlSJ1XOMRJWTucSr6v
	 AxHB7MMwBQ3+ezWKer0VX/aZT18p+8lEMD80ujQ8GYvE4FdMAknl2rL/1meEqaHPVY
	 1ifHi3Dzf/CbdfYNS+P/HyIFEtSFu7BmgKjNcLAeB/kAgl7Lllqk4twRdY99PZObO6
	 aPglg0gl0Er/ef4j1Pk0pni6iyUPrnHZN6ScXyGuXJVaIpgnadUbL3bz56Twv32SfT
	 XuVlrOwtBGodA==
Message-ID: <sashiko-outbox-224319@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v2 12/12] Documentation: networking: psp:
 document socket-less associations
Reply-To: sashiko-reviews@lists.linux.dev
To: "Todd Freed" <toddfreed@meta.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261119013103.1092559-13-toddfreed@meta.com>
References: <20261119013103.1092559-1-toddfreed@meta.com>
 <20261119013103.1092559-13-toddfreed@meta.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 20 Nov 2026 01:32:02 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> Describe PSP associations, and how they differ for the socket and tc use
> cases.
>=20
> Document the new netlink commands for socket-less PSP, and what
> userspace must do on key rotation, since the kernel keeps no state for
> socket-less Rx SPIs.
>=20
> Document the psp tc action, and the flower psp_spi, psp_ver, and psp_dev
> matches.
>=20
> Add a new section to describe pre-existing PSP device stats.
>=20
> Signed-off-by: Todd Freed <toddfreed@meta.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261119013103.1092=
559-1-toddfreed@meta.com?part=3D12

