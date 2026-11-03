Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793745298;
	b=0VRLlLHzET45Uva/U9RhN+hH3ymuZLri0OyYUYa5MU4fchylZPoozGD57GJeCLE3K95z
	 ThWLbUlZ336ncCmR5jrRe3Vw8Ysl1tR9GR3iDG1kpT/mjGdJGu81W8icLq3iSzV3dio1U
	 2sa5Qn8KuQmFAg2LeYBVtXk0lV3ci3p18HNh2DCxEKEWktrb+6Be8izNbkyKBPBF/CaK5
	 uCUUz9WPRJZtP3qQfV+NfOmqEWyDb2CbYbKt1kRPoDXG0r25ThyyifLpG+sMR+u7GLVty
	 HKaIUL36ZlrzSdfNjCjKoBHgTh/f7OxCnNfC9bkxV8IhxOgdaS6uRhKicPD7tCotH7g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793745298;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=HVxBqZr0/5q/+A9yu3TZC4lBuRZ17Q6RT0pNlI9/8jY=;
	b=iKyKZhJNEcMYv55yqyLr9jfB2Mo+XibQQsx1k1FNpJZ39GdMpHTfZ3MtwJKJvHUM6Vn0
	 hLdkKMJub8Gig0hb/pTRNGxLDA2nBMxE+CxnQ92vy7H2Wa+riCeKAujAJNea04VoSDGB3
	 pjuwyRVWDKxwpvlNsWw625AL3H1O+096iXiTbXqQvi2D+GAl91Q5h89fvtLMWjNPXs4gD
	 ytdlOGYhIi7/qVQv6AD/pJGlejLoiYdZ7bG5Iyv7tDo4AeB4dH5HHipbySkJLqEzOKHur
	 x0eTV38aqdaq09eEZGbDjKR0bas6QvJURyz3pODJhV5BugyAoPDzfp9l6oIAo0DAGng==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=E6n186el;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C38B1606A31B
	for <linux-rdma@vger.kernel.org>; Tue,  3 Nov 2026 22:34:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=E6n186el
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CB171F0093A;
	Tue,  3 Nov 2026 22:34:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793745297;
	bh=HVxBqZr0/5q/+A9yu3TZC4lBuRZ17Q6RT0pNlI9/8jY=;
	h=From:Subject:Reply-To:To:In-Reply-To:References:Date;
	b=E6n186el9Nzh0IXyftZaUtxKK7kJEBTbNGjfyveLMnxgiDmzBTMzlMDT8SEYxTWw6
	 50U4MJuGvXW+uX+eE2goXK7ofwPH0tQUC7I79auaopHyxDgdc7V96WjZas1amReHXm
	 PADknW8I1bc190po9jGEefu2VaSZocinrql8ch+PIkpeJSi/erwheqZY2avJ1IlB3d
	 9cr0Mmd7LsYrr56T/FBNcWPBlU81EcdH1rJ71cSSQwTyh4irc53sm/OWFYfX4Y0WBZ
	 jYJWxDVoJAkCo1vpG1pnmBromUTeYPqHdE+nH1xEtvcBEq/DYMeuB6/Amo5PEJLxCO
	 uPqy8Lna3252Q==
Message-ID: <sashiko-outbox-196128@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH rdma-next v2 03/15] RDMA/core: Allow optional access
 flags in dmabuf reg ioctl
Reply-To: sashiko-reviews@lists.linux.dev
To: "Michael Gur" <michaelgur@nvidia.com>, linux-rdma@vger.kernel.org
In-Reply-To: <20261102223325.2115128-4-michaelgur@nvidia.com>
References: <20261102223325.2115128-1-michaelgur@nvidia.com>
 <20261102223325.2115128-4-michaelgur@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 03 Nov 2026 22:34:57 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> The uverbs ABI reserves the optional access flags range as best-effort:
> drivers should accept any flag in this range and treat the actual support
> as opportunistic, never failing registration when an optional flag is
> requested.
>=20
> Add the optional access flag to the allow-list of dmabuf registration
> ioctl. Uverbs users can now request any optional access flag on dmabuf
> registrations and drivers will apply the flag's effect on a best-effort
> basis when supported.
>=20
> Fixes: bfe0cc6eb249 ("RDMA/uverbs: Add uverbs command for dma-buf based M=
R registration")
> Cc: stable@vger.kernel.org
> Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
> Reviewed-by: Yishai Hadas <yishaih@nvidia.com>
> Signed-off-by: Michael Gur <michaelgur@nvidia.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261102223325.2115=
128-1-michaelgur@nvidia.com?part=3D3

