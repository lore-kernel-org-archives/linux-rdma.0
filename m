Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B30A4DAFAB
	for <linux-rdma@vger.kernel.org>; Thu, 17 Sep 2026 11:40:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789645217; cv=none; b=gogN9Q3ARQXYeFMUIJ22XOREDLIIVWJANBuiLZ479T6xwfYaNDWyHTnm1V4EFzKIthMUMEFWjQ+pGPtQcYmleF7GZhgIY0WAakotbE4Glj0xUcez0oShHx8q3STFqNgxPuWvyBa7ygLqR+8/5ZHc959nSlDbvBVJ/SAzi6+QJxM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789645217; c=relaxed/simple;
	bh=08/2hOqmDcggAt+q4gwhOneuv21t2wLj3gvzC8b8ouA=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=B2MeCInrQzFBQkoZWWINBC4xkKFN8sPHq3c1k7Bm+bemv3etyR9rw5XVoTwvUT9Jo2n/ayK8ms6+WFMwsU9jW6vzdIn0FBMt+bmjKfp/es8e8ZDews3zDtyNihilX8DnhwGVgtcVIVIBWwLi2qftqVyqSso/bV6BNIy0OaP1U/s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QNpAlE11; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QNpAlE11"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 435161F00893;
	Thu, 17 Sep 2026 11:40:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789645215;
	bh=UJ1eQ0iwJAMOtkMVqCcIyHBzJT5GQWibGd3xWlhU77g=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=QNpAlE11l14q1sRoQ8zsqj0zytIYf7/v+1bgJqxzM97nFNgbo0gwVCH2KaE50XO81
	 NBfsRGudzArucWHg6rO0fM/cQle48N6dG9LCrLG8E68F11qfWk5XNnmS5g9YmcA/Th
	 fnWJLrNgSq7QXwYPF6dS3oJOoBgFVTGcAatXJIiyW5NzS7dUzYq3DBa9t/+1x0a5H8
	 sUsvjswXpCJhM/ymGzfuxvUfaL6no/VJX/VGglCS0tLoFl7b+C1faeqvurKK8sC/ta
	 lp7nLUa08bfGiT8NUN5EyDLTlZwID/7lCzYJcUCl0JWL+s9kOns425GpmcUkTq65sA
	 4Ob4kHNZ5FCNg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] net/mlx5: Fix rev_entry reference leak in
 mlx5_tc_ct_shared_counter_get()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Wentao Liang" <vulab@iscas.ac.cn>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260917113131.2149024-1-vulab@iscas.ac.cn>
References: <20260917113131.2149024-1-vulab@iscas.ac.cn>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 17 Sep 2026 11:40:14 +0000
Message-Id: <20260917114015.435161F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> When the reverse entry is found but its counter is already being
> released, refcount_inc_not_zero() fails and the reference taken by
> mlx5_tc_ct_entry_get() is never dropped before falling through to
> create_counter.  Drop it so the reverse entry is not kept alive forever
> by a shared counter lookup that did not use it.
>=20
> Fixes: 1edae2335adf ("net/mlx5e: CT: Use the same counter for both direct=
ions")
> Cc: stable@vger.kernel.org
> Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260917113131.2149=
024-1-vulab@iscas.ac.cn?part=3D1

