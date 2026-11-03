Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793745297;
	b=AvEXk9v+iSSpImzrfPHCJ3NAAFo5ncra/rcPqVcc4NaZ8Z0DXQCldkmWhDonJoW40M4a
	 Hr/nceCPwk0DLdOG9fT0Ou9JAovsHU3DwgWgvtJ5VxXvo3faIbDBxcvjVVCC9OA7P1nW0
	 PTo5GhBreMpOm7pNbWIYMIWPDF5B+Pcy8JUR3ivrU3iwDFnXt9fZNAyYLL0ZsrogixR7j
	 WU47oPqVSgsQjYYnng4dy0+HArsGiG1RrJDvh/rPGGT2XTKV2iN9aTHJzUXBVHlxwQJSV
	 RflsSMgMMLgpLjuCzUqZisizL+D+97lVnQez/kJe5RvR7J1pK5LCTbSauvjC17OUcNg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793745297;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=J8cCVpqyCbbViZxinXPv4NZS1JluKHDHrRisb69dC9w=;
	b=rcfjVYtxosmOHrS/dP9IjcJClhhq/WvCFBZ03akqx7yJyq3ay5EB66L8ctYycaA7KigY
	 4m9rud5LvMr/qOta/IQ9XhptNTNou1kLQZwu8AN0vfHw+KK9BcvK4+IiH5PZQL1JmbTne
	 mJWWWRWNXnChSDi7bsiu4VNSEH+IcQ5P1FJMapIyr1eKpGjAczz5aLVDFxP1YAcV996qh
	 Uc+OxMAVqC8CWqf1oHx2qGMwmDX4KSo1UK+tJKE+GIoqRTYt4HDduE1uhJbT04yC51rXB
	 0rEzHLhFtUn8OgRtPa8b3khdEpMuWO7rVsS6hfz1rPsCNRdw5eqHHLffGJqO31dfdpA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=F78S4BOG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0181606A31B
	for <linux-rdma@vger.kernel.org>; Tue,  3 Nov 2026 22:34:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=F78S4BOG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49EFB1F000C1;
	Tue,  3 Nov 2026 22:34:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793745296;
	bh=J8cCVpqyCbbViZxinXPv4NZS1JluKHDHrRisb69dC9w=;
	h=From:Subject:Reply-To:To:In-Reply-To:References:Date;
	b=F78S4BOGmqilBM5w9sF+FGEgf8rLx8uOOJrz2cAMlCWJo9lV0/oAF7XgTygN+zheM
	 1M2HBzWko9Ajd/a9nn0FwjNjbPbtuvm+/Uz2Dz15EFWoboiQhyXguiThSXoLcftda4
	 6lKIGY99BNw4G0ScX8HRvM17In0zQJoqRb7uQvc/NZ3KG01ZuYtBq+Y77m2rsiTp/s
	 KIJl15N0iAdjW4TwqxJ1P/vEOZK7pnPU+MVb440b0E0hTErq9THWxs8TwL+EWEhSn8
	 7vJbO5SKciq7FpxpfrKX9blN2aUtDYB+Hag0ttr7SCxCv9BqATQaxgEYzjzNis0VBs
	 zHMNruFeq8PBg==
Message-ID: <sashiko-outbox-196126@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH rdma-next v2 01/15] RDMA/mlx5: Allow optional access
 flags in DM registration
Reply-To: sashiko-reviews@lists.linux.dev
To: "Michael Gur" <michaelgur@nvidia.com>, linux-rdma@vger.kernel.org
In-Reply-To: <20261102223325.2115128-2-michaelgur@nvidia.com>
References: <20261102223325.2115128-1-michaelgur@nvidia.com>
 <20261102223325.2115128-2-michaelgur@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 03 Nov 2026 22:34:55 +0000
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
> Add the optional access flag to the allow-lists of DM registrations.
> Uverbs users can now request any optional access flag on DM registrations
> and mlx5 will apply the flag's effect on a best-effort basis when
> supported.
>=20
> Fixes: 68d384b906cf ("RDMA/core: Add optional access flags range")
> Cc: stable@vger.kernel.org
> Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
> Reviewed-by: Yishai Hadas <yishaih@nvidia.com>
> Signed-off-by: Michael Gur <michaelgur@nvidia.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261102223325.2115=
128-1-michaelgur@nvidia.com?part=3D1

