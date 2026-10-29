Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793248834;
	b=dJG03i2lloSuB2mbfDBhSBzk50goZv7ZdKiUxS7zzvrH197BxT6HsgyA3u9zwaKpF0Q7
	 Jm5jV79le/E65tMdMfWDmGX7ZOAF+exbV3EyHoE/gx4G5Q7BjbyvrcDOXeWMWO/lYzEbN
	 tJ1PJYlRCp7Y4wDdwrZU+ihO3JIxW1GW7tdKZdK3f9Yz3E/tx92JrLrfTtjQ7NZr1OWEq
	 McYJ+XrSJO6+/Ih4IYrSJLAL6yiXd43wxsCSWyskEfUZygx7Chj5oDdDVTdraTXV1LbEO
	 AbxDLvfSC7jSfiY3ugfuG5+Ap4QlE+HkumLC/gmEbavIzXoIAnCggU+tZ1YywfDr78g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793248834;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=Bb+wJWK5bUy+7bqxatMlAalWAmOX/zx7oUjT5cENwlE=;
	b=pYiYs5TDadtvg0/dX0r//Xr9OXQdiKc5EOxFqmK3LvQymREzmEZYUSgI6/DY/1Lg42X+
	 feHrFPY32BFAnc/somD6XQqePY7dhn8IS7PIU+T3XTx32zFC3aGp+OTa+Houbfb7l2hhZ
	 /3LAv1LS8QkPvF1uXz9r9D0CbWdDIOaJzoM5mdZpI4azW0ukvBzvRAWlJcUvk1FApOiU/
	 6Z4b7BkGAp/hZB2pNfcyL9jkvkHLit4+6IKhXokbJEgkZjokldSnKMPXtlU+jntxoABO+
	 shXu8783XprdUxVwljYlo7XPlxYqJyBjSNMjtjaqRnEScKgBieFF6SBdcV1OE/cl3XA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HOqWyBd4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1A85606A31A
	for <linux-rdma@vger.kernel.org>; Thu, 29 Oct 2026 04:40:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HOqWyBd4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D02C1F01825;
	Thu, 29 Oct 2026 04:40:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793248833;
	bh=Bb+wJWK5bUy+7bqxatMlAalWAmOX/zx7oUjT5cENwlE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=HOqWyBd4yAKHtoqEgZk7sK/Z6hnfCn1IKE8HFnWfEr5mP6bVxZ5rD5AIZh8e4/opt
	 0h9T8HBnckpi9FPVCNgv7WtpeMGtNOdS/PxxCDrn3RTpXUJ9hg7rIwmWIYexzoYc7h
	 15INQKcAR7mz1epbckoEgTuDLF0IiC+cPE4sr5O3HBD68OjZmuanxNOzYCzQBcVVHJ
	 xccYHFhBLhqHij0qEGJUngP8345V6Ad7gSXOwwiDsHQxrokoTRgvm85Ea57WbYssuH
	 al5q51KL6Y0pq+mzJdx6jkxm8ZPTk4NZp+Ku2A/73WPTvug9ZC2dHPGzT1il3KqeXV
	 0IU2E/BY8i6jg==
Message-ID: <sashiko-outbox-188708@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 3/3] RDMA/rtrs-srv: Reject an empty pathname
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yuqiang Sun" <izaiahsun@gmail.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261029042719.75868-4-izaiahsun@gmail.com>
References: <20261029042719.75868-1-izaiahsun@gmail.com>
 <20261029042719.75868-4-izaiahsun@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 29 Oct 2026 04:40:32 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> process_info_req() uses the pathname sent by the client as the name of
> the session device and rejects names containing '/' or '.', but it
> accepts an empty one.  dev_set_name() succeeds for it, and device_add()
> then fails in kobject_add_internal(), which warns about the empty name.
>=20
> Reject an empty pathname together with the other invalid ones.
>=20
> Build-tested with x86_64 and arm64 allmodconfig (W=3D1, sparse): no new
> warnings.  Run-tested under KVM with KASAN, lockdep and kmemleak, using
> a small user-space rtrs client that sends an empty pathname: the server
> now rejects it at the check above, nothing is reported, and an ordinary
> rnbd map, I/O and unmap afterwards still work.  Not tested on RDMA
> hardware.
>=20
> Fixes: dea7bb3ad3e0 ("RDMA/rtrs: Do not allow sessname to contain special=
 symbols / and .")
> Cc: stable@vger.kernel.org
> Assisted-by: Claude:claude-opus-5-5 kbound
> Signed-off-by: Yuqiang Sun <izaiahsun@gmail.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261029042719.7586=
8-1-izaiahsun@gmail.com?part=3D3

