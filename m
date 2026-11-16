Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794870926;
	b=WEtnGygBdnt2ASJEoNDxolfsYmI5v36f2FMd0LIYRS9yKVyX9F/cb39d+M+271kDpBFG
	 aCx4HJw9ni/4Pif6ZcA7ky7795pv2OO59rNYbZ5tSnIgPWNbkBxMJ4Eo8e4yzNaaQpC2k
	 sXyPEHdyHDOyMRMeB4+QnfbMhdRoUqo7uId0uGpQ6H1Dp1M9tS43LXgSXDTrOnMOEr1BQ
	 OEQ1qYLXmp3Jq7VYU4uWlOVuCTfGKMeHNAwNciqudJHxjNp9W3tTCykQ6TktoaUW4KQd8
	 tWlCqzY/u5CY7szHJpW/W5V79cgJtyqVA99MMQF94wUn5XJDIpZD8O8E4qXc/Y7jy4w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794870926;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=suVMp/gUqPr+Dhc6xYnAFPFfNvulh6rLYdMXix7B0oQ=;
	b=jHYykPdnSpqqcuLqGQg4a79LAhpB8aiBCZqeHifui5jRKi7H93SmgnoeZ6puvsB7Qbqz
	 vNvkR/CXo89wcWHymaPIP8ehJ743FDwFLXCSymGJowWsqvwukJCHfEB2xWqQF1lQ5siTD
	 +FfNQ8JjpFUQtTQ0M5+3JRTeeHcs/cEDa1NHbfvWP4FCiOlevxv9VMQx+yBnFAkhAdbwD
	 Wc1abOIypMS+pfi+IDL1wO9GL2j9fIyf0NZdffJv2/qgT20vF8XlOgjfoALNp98eJnT9t
	 g2PPkLIPRtaDeIsCUpYgY7Bm4vbYhgKZOk0u0J0LR7NFx/69b/S5lhyjdIIUf7tFazg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=D5UcO+Dm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E254F606A32F
	for <linux-rdma@vger.kernel.org>; Mon, 16 Nov 2026 23:15:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=D5UcO+Dm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29EBC1F000C5;
	Mon, 16 Nov 2026 23:15:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794870925;
	bh=suVMp/gUqPr+Dhc6xYnAFPFfNvulh6rLYdMXix7B0oQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=D5UcO+Dm9vLHjmJoRHVzHvjCh9tkwXRr5pxaC9y+3l1f6fcLq7Wv4O+Q0ZKplAJju
	 Y3DSWwmKbGxZI7RsWy9UaGQM/LT6uko5SLp2/trUNjPwjZfTSv8xyvEK/95bKV3DYg
	 g3mUPlGW43uccGYdwa/PK5HtEI9mGHKPQLJ4YVFMHDtKrApXphP/DPpXHX+5/Bnh8T
	 KmdFnCvNOsQIRzfMkHCgQpSU3nWMjxeJZvt+fGKmUbwNpVGFYpEwYCmM10VN97ZKeF
	 6scv64ErWN9X6AJivTJcbx34mwdtTL1Klm6R2W/eZ9XIKAdnk9TS4IueB/tKX7JtgF
	 mVcWQVcvDNN9g==
Message-ID: <sashiko-outbox-217863@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v1 2/7] pipe, fuse: use GFP_HIGHUSER_KASAN for pipe
 buffer pages
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
In-Reply-To: <20261116230627.3537051-3-jeffxu@chromium.org>
References: <20261116230627.3537051-1-jeffxu@chromium.org>
 <20261116230627.3537051-3-jeffxu@chromium.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 16 Nov 2026 23:15:22 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> Pipe buffer pages hold data in transit. Pipe writes allocate them, and
> the kernel fills and drains them through kmap_local_page(). The same
> holds for the page fuse_copy_fill() allocates when a request is spliced
> from /dev/fuse into a pipe.
>=20
> Allocate them with GFP_HIGHUSER_KASAN, so that they keep their KASAN
> tagging when GFP_HIGHUSER starts to skip it later in this series.
>=20
> No functional change: GFP_HIGHUSER_KASAN has the same value as
> GFP_HIGHUSER at this point.
>=20
> Assisted-by: LLM
> Cc: Alexander Viro <viro@zeniv.linux.org.uk>
> Cc: Christian Brauner <brauner@kernel.org>
> Cc: Jan Kara <jack@suse.cz>
> Cc: Miklos Szeredi <miklos@szeredi.hu>
> Cc: linux-fsdevel@vger.kernel.org
> Cc: fuse-devel@lists.linux.dev
> Signed-off-by: Jeff Xu <jeffxu@chromium.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261116230627.3537=
051-1-jeffxu@chromium.org?part=3D2

