Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794870953;
	b=kKfAtCSKup2HxlQZ6O594RRDTlLKDjmGhfF7MMh0+D9FOCEblcLuSUzCp2/tyC9sOf1a
	 sCnnD8sjz3TSTQK6Bz+YBz7IugIt/1kQtBZ859dWvTZDCj7Cjx6NH523LaPZVBfqMIQCU
	 6Dv3uJef9j7PnIuIH3+McOzOIcyRvDOR2VKSLnjmEIEhcXZaNqpA3fx6yKqaZcR690Dxz
	 ULUVDfw+je29u+q8sbwrUg5+XUNIFuMmyvF4UOeUFawQJpZUr1HHwoXS3nNFp8z5pFiPd
	 qvniro81Rf3qeBpSmdEfOM7YilkBkbN7R/Ty9OohWUumyQyMCw2C1DB4/ROT2QVVE7A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794870953;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=fM5cIp8F7etXZwtp4KzCr2VDSf5Dwe0uYecZTMnaQ1A=;
	b=WOxSEjkNu8jEep8RIzJx7S28QcV9pajUgZ09Wr7yjwFtzK/vpZ0dxj9619Jnx9smYWvh
	 IwLCE52eO3N3jMqZpNZYSIDCfLVLuzyjNy933ViZvD3XbutExfmR8+APiFWq0BgQIgLQQ
	 3//JQIiZRauVe7PUikyNhFmhhYkvQjQXBgM2FKNm/z3THZBmg5x0qfWbxP/8JY8ouYpte
	 pjw1YTkNspviUkzNPDuY9lR1rMV7TVEW6ruLloYRl/RoPuUbtmegWYb5eqln3BSuhQjZt
	 StgponA5GdoLCcPDWEMefzSGdz0vwxVWkyYQ1Rd2lshuNcagyN0+F44JOV/8NiO75Tw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=TNzMwgu+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 634F4606A32F
	for <linux-rdma@vger.kernel.org>; Mon, 16 Nov 2026 23:15:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=TNzMwgu+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4D5A1F000C4;
	Mon, 16 Nov 2026 23:15:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794870953;
	bh=fM5cIp8F7etXZwtp4KzCr2VDSf5Dwe0uYecZTMnaQ1A=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=TNzMwgu+5P+sBXgz/6Q2bDLIxWlA5kDqzPwNabsENacTG8CW7V+fwP5A5EzfmWM1X
	 Aw3ayEZ0WBP6/mGjdAl0hzPqTMFkTZqOEjMmVmAysHa7JcTxnYHsx//C+YILplelIm
	 bqTfA3wtm/6AlfqP3lsMWanjPkTdMLinSwGMzXCGmPKdUIXYFnG1yiv4QWm+wL9ebZ
	 6Vy9dib0X7bAqt2XHBbBMUftO3xQno0OZO1wg5D0cVV5FKE3QcFJaRWbghKge3FCaN
	 T2O/VG2zJDNg3z8VliSHJqNlIKCokEK/HwVxCppYeja5EJ1RhQiG16YXirPbY/Xu/g
	 YFlhiseM7/Kew==
Message-ID: <sashiko-outbox-217867@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v1 6/7] mm/kasan/kunit: add page_alloc_skip_kasan test
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jeff Xu" <jeffxu@chromium.org>, "Andrew Morton" <akpm@linux-foundation.org>, "David
 Hildenbrand" <david@kernel.org>, "Vlastimil Babka" <vbabka@kernel.org>, "Johannes
 Weiner" <hannes@cmpxchg.org>, "Andrey Ryabinin" <ryabinin.a.a@gmail.com>
Cc: "Lorenzo Stoakes" <ljs@kernel.org>, "Liam R . Howlett" <liam@infradead.org>, "Mike
 Rapoport" <rppt@kernel.org>, "Suren Baghdasaryan" <surenb@google.com>, "Michal
 Hocko" <mhocko@suse.com>, "Brendan Jackman" <brendan.jackman@linux.dev>, "Zi
 Yan" <ziy@nvidia.com>, "Alexander Potapenko" <glider@google.com>, "Andrey
 Konovalov" <andreyknvl@gmail.com>, "Dmitry Vyukov" <dvyukov@google.com>, "Vincenzo
 Frascino" <vincenzo.frascino@arm.com>, "Marco Elver" <elver@google.com>, "Boris
 Brezillon" <boris.brezillon@collabora.com>, "Catalin Marinas" <catalin.marinas@arm.com>, "Chia-I
 Wu" <olvaffe@gmail.com>, "Dev Jain" <dev.jain@arm.com>, "Evgenii Stepanov" <eugenis@google.com>, "Ian
 Rickards" <ian.rickards@arm.com>, "Jann Horn" <jannh@google.com>, "Jeff
 Vander Stoep" <jeffv@google.com>, "Jeff Xu" <jeffxu@google.com>, "Kees Cook" <kees@kernel.org>, "Mark
 Rutland" <mark.rutland@arm.com>, "Peter Collingbourne" <peter@pcc.me.uk>,
 =?utf-8?b?UGllcnJlLUNsw6ltZW50IFRvc2k=?= <ptosi@google.com>, "Ryan Roberts" <ryan.roberts@arm.com>, "Tomasz
 Figa" <tfiga@chromium.org>, "Will Deacon" <will@kernel.org>, "Alexander
 Viro" <viro@zeniv.linux.org.uk>, "Christian Brauner" <brauner@kernel.org>, "Jan
 Kara" <jack@suse.cz>, "Miklos Szeredi" <miklos@szeredi.hu>, "Baoquan He" <baoquan.he@linux.dev>, "Pasha
 Tatashin" <pasha.tatashin@soleen.com>, "Pratyush Yadav" <pratyush@kernel.org>, "Allison
 Henderson" <achender@kernel.org>, "David S . Miller" <davem@davemloft.net>, "Eric
 Dumazet" <edumazet@kernel.org>, "Jakub Kicinski" <kuba@kernel.org>, "Paolo
 Abeni" <pabeni@redhat.com>, "Simon Horman" <horms@kernel.org>, kasan-dev@googlegroups.com, kexec@lists.infradead.org, linux-rdma@vger.kernel.org, rds-devel@oss.oracle.com
In-Reply-To: <20261116230627.3537051-7-jeffxu@chromium.org>
References: <20261116230627.3537051-1-jeffxu@chromium.org>
 <20261116230627.3537051-7-jeffxu@chromium.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 16 Nov 2026 23:15:50 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> Add a KUnit test (page_alloc_skip_kasan) to verify that page allocations
> using __GFP_SKIP_KASAN (GFP_KERNEL | __GFP_SKIP_KASAN, GFP_HIGHUSER, and
> GFP_HIGHUSER_MOVABLE) under CONFIG_KASAN_HW_TAGS:
> 1. Reset page_kasan_tag() to KASAN_TAG_KERNEL (0xff) across all sub-pages
>    of a high-order allocation, and
> 2. Return a match-all (0xff) linear-map pointer from page_address() that
>    does not trigger a KASAN fault even when the underlying physical
>    granules carry a mismatched tag (such as KASAN_TAG_INVALID or
>    restored userspace PROT_MTE tags).
>=20
> Assisted-by: LLM
> Signed-off-by: Jeff Xu <jeffxu@chromium.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261116230627.3537=
051-1-jeffxu@chromium.org?part=3D6

