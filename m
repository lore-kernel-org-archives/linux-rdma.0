Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793711896;
	b=Ash+XRTvBxu8KKP+6pBTm+A7WKJgatYJCxXUPk8RIzG9MP3zjl7NKZIsm04sSSZWuKuv
	 mU4Fa+7ZKcvwFT53QwXieWCAbReSTERcukkkezTT4MN2tIw7J/lcAUKIP11g2XLvRnyks
	 +DIes23+84vOZuMqu7pwmowyGwM+AC5eZiXr0zfkx+z1mnpYRVag0QC4QFJj8LpdHZhCU
	 n2cYMz2yheu8SXJGoYGY0foEyVlzNNCrQrzANFxuIhHVRLt9J2gZxHjwJWt273yYZtIbD
	 qNLQQ+j4W5ORV7gtzvoa8NbSqtOs+qOiyTUr1QXYxPL6N8cruvl2x7ln9A0Ah/K2dLg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793711896;
	h=Received:DKIM-Signature:From:To:Cc:In-Reply-To:References:Subject:
	 Message-Id:Date:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 X-Mailer;
	bh=Mg+sRO/KXxvHyFf8BGRU0spjt12/Bths67pMAyAuXQM=;
	b=boJQeAQ3BjGL7Lp1lC6xnpAUuKw+rIonvBMXKvFFEVm1pcgZjcvZ+q3rLi8hU2KIQMVT
	 Fk0UOza8yrCUh/22SSEXdE4HQs4j99+2Hsb3nhsx9EnrVrQsSM9NZbeMQOb2fGiAfOUX0
	 acGoq/iHZL+FAl/G0Tp6/N2DojwYKzHfwiPRh/716XwHLwfpKW7j/j9oPZgMpgFjeHlwk
	 3MJEMVVM6TXI2eyiBdKOmYK8ty2Xh5VCm5+zyCfIDwoBupdEdsn4mm49BUSbW9HVd085Q
	 975np8aOB6AF0BR3NW43NMcbYNidxgmREoGwc31Pv1GpKmW39g9kNO57gw02dO5BQQA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Ze6Ur0Km;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 354D8606D806
	for <linux-rdma@vger.kernel.org>; Tue,  3 Nov 2026 13:18:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Ze6Ur0Km
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40DA21F0093A;
	Tue,  3 Nov 2026 13:18:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793711895;
	bh=Mg+sRO/KXxvHyFf8BGRU0spjt12/Bths67pMAyAuXQM=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=Ze6Ur0KmdrysVdx+mYIQU9NBv2fPEEsU/C1mTyALWE1IzRAsBpXeQlyAV9Qb5DvUg
	 Vkppo+iMFczLKYSDUF4cZqkaLY7CBPn8B7FO6L7yYs8fVjySvK6tuWwoJrIfCJlOJ7
	 zkKgS6JMDmg+06rVrZ0iZsGIbw1KP4PA8QU/TGhNl4mxDgpcutH+TEPzYb+hDxf/pd
	 W74VTHOZHMibJFCziBeG8PMz+JgYlEyy6nQYpN3r/CxQx1s34QFuvFGMpoCKwQ9vlu
	 3okyagjs/EAsXGUS9ohVFBOj9h6B91Ypa6pTvz62PLiFeAl4jjXWXABYwRMDZmtJQm
	 N8zRqmuNpxC7g==
From: Leon Romanovsky <leon@kernel.org>
To: tatyana.e.nikolova@intel.com, jgg@ziepe.ca, 
 Jacob Moroni <jmoroni@google.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261029133121.1204636-1-jmoroni@google.com>
References: <20261029133121.1204636-1-jmoroni@google.com>
Subject: Re: [PATCH rdma-next 2/3] RDMA/irdma: Do not allow rereg_mr to
 revive defunct MRs
Message-Id: <179371189316.1725532.6470435945125559364.b4-ty@kernel.org>
Date: Tue, 03 Nov 2026 08:18:13 -0500
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15-dev-18f8f


On Thu, 29 Oct 2026 13:31:21 +0000, Jacob Moroni wrote:
> An MR can become "defunct" if a previous rereg_mr happened
> to fail in between deregistering the old MR in HW and
> reregistering it (e.g., due to ib_umem_get_va() failing
> in the IB_MR_REREG_TRANS case).
> 
> In this case, the MR is left in a state where the umem may
> have already been released.
> 
> [...]

Applied, thanks!

[2/3] RDMA/irdma: Do not allow rereg_mr to revive defunct MRs
      https://git.kernel.org/rdma/rdma/c/6b5c8236e3008f

Best regards,
-- 
Leon Romanovsky <leon@kernel.org>

