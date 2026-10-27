Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793093629;
	b=firXEeILD3W05BJ3ZTQasdM1To+xH3bJ6PGfjS8C1A6C0u+ZM6bRnhnFimFQiXDLQCfi
	 Ec22uctZcApHeisZtDZUhHeA4owLwz4eewOkBr5tbctsH48ipG5vuZlndFnPC0KYNr1Em
	 R4OtOOhnShlGVdPTG+t2tN94liIXQNng15Sd8WwlOMjbwihMrlODORJ+EFlmRkIqrBbWJ
	 ympBOtISwe1mzIkEZ00j0Q5+2OeGX/JQjPWUbZkhZmMyvKnk8JXEI4LuOkXU2QF7JKdlL
	 ErOBhowpJ8hYuCmUyNBcBqxU35SMIRmnszmBbqIxGk+p6/GNDadzf/TgeXo3D8a+6uQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793093629;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=hkgCHX5/VwcDmtnbeGYRUHSHRazZyhm7+20rd+tHDpc=;
	b=zsa1eCmOYBQgIkMP1WfKqbPdyj8OImegLbl2xMSY3iwBhA+8f4SSw1z8m2C5HB8VAtSu
	 LXpx16gDxkFWgWcnZSRlzM19dHXqtsBCXFEXiGNDgRYXX9uXbiILIb838A0XCMDw9wdZi
	 MyCCsZ26L03fd6gS7ijJZoIhK27RP3S4WzIIK7ELqqk6ui7syQQLJ5xC+V0YqcdkRlIwa
	 KJT7ZIsWoue9gb3L2JKpql60gu+TqlKiKR4wWQwwAwdlTNr/ZojDBSGXBp+ffwSJa4GSe
	 pRigohdlk08dy1s0ADm4pcw0Oar1ML8PtgAcH4+X6Z6k+BClNhSwf7HWUJqiblLtk6g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HC9zh7w5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83709606A32C
	for <linux-rdma@vger.kernel.org>; Tue, 27 Oct 2026 09:33:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HC9zh7w5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00AEF1F031E2;
	Tue, 27 Oct 2026 09:33:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793093629;
	bh=hkgCHX5/VwcDmtnbeGYRUHSHRazZyhm7+20rd+tHDpc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=HC9zh7w56Pwqmvyz1gkkD+b/n78Ur5mLjY5cWZrXw4Pz2Py6QadIUmd8cgVF5sb/x
	 5uHSzJplE4gT5KUx9ASEEnSaihzLnZbYzFmQjAbBrhHmzXw/9pBG3uhyQWx0veq0US
	 ZGARBjbOFEb3aGWVG6V33BAmTI64PcdUhf/BZcS/cwKEnZHrLPKVqoLkPstrxPbELz
	 UtlTCBKC85DPuzcHGRl5cA2+2berrGQnVG+cELI7Zmwl2ETpbLKldoE/G6M90hdFrP
	 72KMviBCzUPD7eVftuanAqiJLwk0NG5EgYWT89wUaDHM1nuR9qqRWJUjSkk4NXO3rA
	 /1n/cGNdZh4Lg==
Message-ID: <sashiko-outbox-186325@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [for-next 3/3] RDMA/ionic: key recv completions by producer
 index
Reply-To: sashiko-reviews@lists.linux.dev
To: "Abhijit Gangurde" <abhijit.gangurde@amd.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261027092353.1961552-3-abhijit.gangurde@amd.com>
References: <20261027092353.1961552-1-abhijit.gangurde@amd.com>
 <20261027092353.1961552-3-abhijit.gangurde@amd.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 27 Oct 2026 09:33:48 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> The recv completion's wqe_idx is the RQ producer index. Store the
> wr_id at that slot and write the same index into the posted WQE. A
> posted flag on the slot rejects a completion for a recv that is not
> outstanding.
>=20
> Signed-off-by: Abhijit Gangurde <abhijit.gangurde@amd.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261027092353.1961=
552-3-abhijit.gangurde@amd.com?part=3D1

