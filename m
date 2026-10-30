Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793384595;
	b=Vn3GCMSgEDFa6hIVlIhiWAi2A6lVduWqwCMjhal6lXyA9i4Tike5T7rBkByR8AJPIWnF
	 hlcDS0A6QE6hlkJahjfpCf4WMUB2Nh5iZL3bWJa7jwBDvJc7SVyJM2JMbjdWwf9EPvcl7
	 fjGBHOUGacZVjaxJT8V5Gb3M9CQeFbMUtrOexaizd5BcEm6PNMYKwX53Hwe+xRbKmYZmH
	 rscCfY2lcK2kuqBRd2oinXtGWcuNQwb9/7/LLVE6I0Ig60avSAuDqD40So0Ei7fA/ccdt
	 zQwA9olvUJDSK61ukELNYVRAQpnEd5sYojq2bH/EwPdFIAEOQ61KzdkwKCrwS3LXV7A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793384595;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=vb0exaD6tHKUzyoHBaH5agAG80od0wjE0mnDJZ0u4Kw=;
	b=Jv/432sh+2cIK+VlSUyRsMHYMo1tYBkV1KlTG+Em0caRXo23do8tTlG5gOBUAR3+wYC1
	 +ASCT/jmvB4NWE3EtHtrBjmLDQBn/Lhl0goKrS2l2Vp0RFgKeFVGAb+4PdbiTwl3P4wZe
	 iFR/hIu60jWcky6HGWPCjVE0qSlPSU8ZM61Ga7wIzIM3G/674jEO/eIMGfL24G6jzzkG6
	 naVfwRYC2BZO7asMY9/+v83pvo7IPVQwgFVeXJGwQak5i7geYh8516mGm/UxI91TJERjw
	 dhBGG+0u1+Z+alEPz/+y7C5bHMZe+dpdh1rn/f9XeEUyP7C7+RDzLcxnLUU7G66nTiA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=SfR8Ctro;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D856C606A31A
	for <linux-rdma@vger.kernel.org>; Fri, 30 Oct 2026 18:23:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=SfR8Ctro
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F7571F00A02;
	Fri, 30 Oct 2026 18:23:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793384594;
	bh=vb0exaD6tHKUzyoHBaH5agAG80od0wjE0mnDJZ0u4Kw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=SfR8CtroMeu4PbP3Nmb9agbodXh5WEoqn1aKgp6d7yia8FbIWwbRuswljQo/2RthF
	 0GjxFvSVaeeenZifG8+SWgfjR/3DJ7QALuEdsA4WimKfg9hIMZra0BYivGXcu2Eu77
	 Kt9GhC0NFtjOcvBLkPkF9rp81Mbl60Fs+1ljpQIJBSVBcOK6KwLhAcizz8Z4QFoau4
	 zvcY1xYF1tDsiNjC9BnKMplp3BMjCTAWmmNxDR+qoib1E3ZMxu7pIwpWSFkbZSM2Td
	 9nMPNAKa+ti43yfEyuk9XzdixwHGyjd4+D4vu6Ce7KIkP/uKZfX1N6MhJ/OJTZd53X
	 xhj/MmArwELvg==
Message-ID: <sashiko-outbox-191404@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH rdma-next v4 2/6] RDMA/irdma: Register irdma UVERBS
 ioctl namespace
Reply-To: sashiko-reviews@lists.linux.dev
To: "David Hu" <dhu@x6u.co>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261030181512.2056056-3-dhu@x6u.co>
References: <20261030181512.2056056-1-dhu@x6u.co>
 <20261030181512.2056056-3-dhu@x6u.co>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 30 Oct 2026 18:23:13 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> From: David Hu <xuehaohu@google.com>
>=20
> An irdma UVERBS module is now created. An irdma specific shadow buf is
> defined for CQ, while QP and SRQ reuses core's uapi definitions. This
> works since core builds shared core ioctl parsing tree first, before addi=
ng
> driver specific `uapi_definition`.
>=20
> Destroy paths are automatically handled by core dispatchers, as objects
> are now registered in the parsing tree and no additional driver specifics
> are needed in destroy ioctls. Resize, Query, and Modify continue to go
> through write() cmds.
>=20
> Signed-off-by: David Hu <xuehaohu@google.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261030181512.2056=
056-1-dhu@x6u.co?part=3D2

