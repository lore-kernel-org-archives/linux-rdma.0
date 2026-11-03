Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793703792;
	b=Th1ElFGo/Wq1Mu0Go65LAmclOaTQM1fRbr1fg2s6E8j4dgEJbJ54ljr7hiGk1YMRWOGZ
	 /U/Pg13VPyaOrK5Fq5KJYs48AQ2QilfriLo3l2wOr5RY4Pt0LbMc8+pCpyO55dEqD4sOx
	 OZvJrhsE8YQCDlzSGrZ8LJsHo26Ie6FMcf8oZeTdLJExcC+ujr7mbBOpbyF8E+Aa2ryNs
	 vNUKPlevFckU+Gb2A3i+mZkp+VpyyZVXk7BwADiN5DCq8FjP1ZDahrYFp5rNXO/ZixSai
	 RxJhMUhpxHF2AAsld42+LfCNaWsZjUCkXdgkwDD2hFrP0tssAuILm6z0LLEmpuDOAkQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793703792;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=FEP7fesxMBy/XhXGgM1a1TOiw/YDRJ1dtW3uDe2XSJI=;
	b=2ssKZcRmyOyytT7pb/B7QYzTlfNH0dJrcWxLn6C++EjzjUdG0GZwxud8W8c7IAmeVWzy
	 LUT+rTsLbarnhK5ND5jcjueB9OphsBcFwOeATh+STHZxVSbV6QyXu7xaTGPmQDZw9s2Us
	 t+cEyaHVGUMdZ5AamFxPd9ihbhag+8kaUGp28s6TXT/D8qlQBFk4+vlWbt9c2vl8ytn7v
	 zDnen7/q3HWQJn/l0qklGN7RZiyIR1a2BoBekKy6R0YJttBsxMLCiSWlnZ0GTfQ3qYWII
	 4/6HrO0NVUrj4fPLtXyOZ7sIQ6/Tw5gdjAqpBmaL8hgYLMcQ37g1YbgBWGVDi67Y5Rg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=P1uB+yos;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 556F6606A32E;
	Tue,  3 Nov 2026 11:03:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=P1uB+yos
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A713E1F00A02;
	Tue,  3 Nov 2026 11:03:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793703791;
	bh=FEP7fesxMBy/XhXGgM1a1TOiw/YDRJ1dtW3uDe2XSJI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=P1uB+yosSqtUA9MThmzkvwFg7eTlmRY0HX4Pmd9yxlYHGt66gBssRvUjULzzz3I7z
	 MxEm0DqSHRa3sOnrq2ADZ+/kHjD5z9bUflV0LwI/nCVoFz5YqOIFlSjpYSimtGrXfL
	 iQVANrnR4K4AQCxTdIx9UsM4SH0v/AEZ8X2yajThQLSJjaPP/nNgKiH9ZNBMfXl0gh
	 PkIpqlPCqpc+z3JsWTSvtA4E7TusQvU9CGwrCA2OjB12AV43BY+KqEZnUTxmtw8qli
	 HpEMCvaqTHK2VoEcOVtm8q1SDMrmoQbH6Ebop91WlKK2JJnjxzXnzFEI9Z1WyiOAN4
	 7lZfddStC4Uig==
Message-ID: <sashiko-outbox-195096@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v12 13/19] PCI/P2PDMA: Add KUnit tests for the ACS
 routing decisions
Reply-To: sashiko-reviews@lists.linux.dev
To: "Leon Romanovsky" <leon@kernel.org>
Cc: linux-pci@vger.kernel.org, linux-rdma@vger.kernel.org
In-Reply-To: <20261103-fix-p2p-acs-v4-0-v12-13-912101f93517@nvidia.com>
References: <20261103-fix-p2p-acs-v4-0-v12-0-912101f93517@nvidia.com>
 <20261103-fix-p2p-acs-v4-0-v12-13-912101f93517@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 03 Nov 2026 11:03:11 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> From: Leon Romanovsky <leonro@nvidia.com>
>=20
> pci_acs_p2pdma_request() and pci_acs_p2pdma_completion() turn an ACS
> Control register and a TLP class into a routing decision. Which bits apply
> to which direction and which class is easy to get wrong, and hardware that
> exposes a given combination may not be at hand.
>=20
> Drive both from a table of register values and classes, covering the
> redirect controls per direction and Translation Blocking, Direct Translat=
ed
> P2P and Relaxed Ordering. Direct Translated P2P gets a case with and
> without a redirect to override, since it changes nothing without one.
> Exposing the two helpers moves their state enum and the TLP flags into
> pci.h.
>=20
> Tested-by: Tushar Dave <tdave@nvidia.com>
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261103-fix-p2p-ac=
s-v4-0-v12-0-912101f93517@nvidia.com?part=3D13

