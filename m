Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793712228;
	b=p2qpYFGR56F+TubrIqR1/5wn0tekFafC+RO6NqnZ5jtM20J/R+akKO3Oe/093CwlwWfo
	 jjVLZziQ/8FBatYVNUw6l6z+cToqTHFkPrTvLpDcWwouwFyShtcRWhJEHFOZIcyTaJ5oH
	 MI3ZVYZb/ziB5hPzNZMFJWkVlN0N3ebOoLnYg7xLT9ukNTyQbhGVLZ1uK7vIAfF/bTzqs
	 /U6HdYeGL9u1k2sYGsw5A74mg8BZCv3dRn1Mpmz2YpkPpF16DVslCMyKFOSafteyj7t5Y
	 qtRLHk2InXEwsCKd6wrZLELda13KyBHk3ca/Bn9soOYqewcjjiStzL0mM4v5d/wgy2w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793712228;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=0VLDRMMKdGSDwQjs78pqtryqWvWaM//5I2vQKkhwcCk=;
	b=4H8f5+xuovPCrJ27v6T5RcIjC6ahkl9jLXou3t7eV7BKVgaKYk5kQuDBR+zBg8nrGTke
	 WDeCgAQw6qMMtUNMKzXa+fsSNiw739F8BGxVAhbBYw55pvy5ZrCOYFD+/lXfd0xRjKgf6
	 LROaOfYeUcTT5T46djJrAmbHleV+24zaHmf69LaxS/HtLCnF887GVFdw2xxvY+6Osmmhr
	 GjXpbpjI6gtd0HvnNFDOAZUJzNUAkdWLwNRI0QI0phVhZQMvKbeUNfblfjVQhAAtpliVy
	 mSmQE7uHOqG6TSGm0Mspktjt4ArNeHyy4bXrIrdOfUd4yXwLVqoaSoS0RePGukOvgJA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="kyoj/Q5M";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DB8D606A32E
	for <linux-rdma@vger.kernel.org>; Tue,  3 Nov 2026 13:23:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kyoj/Q5M
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 141E01F00A1B;
	Tue,  3 Nov 2026 13:23:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793712228;
	bh=0VLDRMMKdGSDwQjs78pqtryqWvWaM//5I2vQKkhwcCk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=kyoj/Q5M9VhXH+eEVJcxHI0+ChoMNZNrU3C1/8SGlileT6lfBqQWnWvlQBYQmNMDj
	 7dwBrwcHfqZmCNPpIzxXWfbFbLMQieys5PywwRc+FmLMeE0/u2kD07o3jQXW6wG07q
	 R31dFLVw1Trz1G5svFcXpmmXjBGx4iKZGXSuzC299MbtBdu14X8grPvgBtkZj3hrsK
	 NbmumPHCqNdjKVHizqDdC3lkTUvxawCRZuyRK/MvjN8fnb0jSYg4hM1iadmx2cGXHD
	 ttv4FuXL4pMmlEHxwOofkWs96ox/MElZ120J7hvQ/nVvK7BWWvbXHe9lqomna5A2qU
	 vfZIkH18qZo+A==
Message-ID: <sashiko-outbox-195334@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH rdma v9 7/7] RDMA/zrdma: Implement context, PD, and mmap
 operations
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yanze Zhang" <zhang.yanze@zte.com.cn>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261103125654.2707069-8-zhang.yanze@zte.com.cn>
References: <20261103125654.2707069-1-zhang.yanze@zte.com.cn>
 <20261103125654.2707069-8-zhang.yanze@zte.com.cn>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 03 Nov 2026 13:23:47 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> Add implementation for allocation/deallocation of Protection Domains (PD),
> User Contexts, and memory mapping (mmap) for doorbells.
>=20
> The SRQ doorbell area is not page aligned on 16K and 64K page systems, so
> the mapping length is extended to the page boundary and the size
> reported to userspace is the very same length. The V1 and V2 contexts do
> not know the size of the SRQ doorbell area, so only the first page is
> mapped for them.
>=20
> Signed-off-by: Yanze Zhang <zhang.yanze@zte.com.cn>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261103125654.2707=
069-1-zhang.yanze@zte.com.cn?part=3D7

