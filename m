Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794870929;
	b=CsFMdbmqFIWU321xGHjb8MR/s6ouYSfMxbyE8hcR2p5lZNNvjJvrNeMOvn07JCtdN2X8
	 eIiWlj/VXPJ4rzGXUu+gn6DgChZq7XDsdERINA19CYa8SrwibbPHBqO9EhmXWs/g6It+9
	 adziM8IZcrl38ATerizmpZReBqsw7o12bc8+LBj5DC+60ViCRFu3/2S5MZnCDT/fnOohC
	 XKKeSVNNI/Jx2tYH+VXa7OL2TKutI9o/8kYx7G4QufW+4ie31ArJnenqeijql2wq+HBcq
	 HFDBynHEw4yU7GFzpI9qRwq0jMbUIAFcOwo0QPTQiMHPqMM/bfTqnhIq725B51EaJ5A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794870929;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=bt6ts7L0bnKOqPzNlt3dfuoXHJ5Bu4Y7hwSjTnQSAp0=;
	b=2G++RqBEU4/WQYL6qJBBwy/fHzFIUJMgBKP0l5nYZ62vuzV7/rpG6sx01IBWxPtm27/g
	 HsHKjtq5ZPQyVgmb1rJOo5WUOEJ1uTVy6Fs/+RIGB/D3ExaLFF/rxyxQnpNP0R43GTiZw
	 ZlUh/Zw7c3NJ1N9fAXAPemmkjWlREfaTVW5WEmsda6tFVLyGtuhCVBeX05ixYwG3J+I8i
	 oj6PprZ7D1xElQJi5K2TL6dooaiqM/nPlQQPcda2tw1O1wabmZWtDFruxhDjb28ZQmroP
	 5iOc6N2kTE6l4qUgUeGbN4lb2dONqp3wo6oXbZo+R0/QuR4PX+6J9KAG9CvXQmkt5/Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=KdU25Kpi;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2D1D606A323
	for <linux-rdma@vger.kernel.org>; Mon, 16 Nov 2026 23:15:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=KdU25Kpi
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0172B1F000C4;
	Mon, 16 Nov 2026 23:15:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794870929;
	bh=bt6ts7L0bnKOqPzNlt3dfuoXHJ5Bu4Y7hwSjTnQSAp0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=KdU25KpibMhMkKr2wZ3OtXRIMin7b5HBDedncFx0nAWpUwFpLlALdWJ3w2Snnt64E
	 Q0N3IaTMuq8NA2CHcxJk6xLDLO2uZjbbuitRqYDBVrsaWH7XnTNfzdxXLzsEQ44suP
	 gLXWdd7Lbkbu5K7LSnY3BMXqUBDaQ7yZ/MC6wD9Ah8K2I60XT4tt5323E7gBVIMwFe
	 ULWP7leobkb6ZHZJad5mgTPI7dIEc6DOybB7njeiL42IBg3N5JJaveAnUxYFgWd1gp
	 z1AVQDfdigaaascYmBbNm692jyeBHSGtCxr2abZruqLqyBQFTTxmmjSrYDtrpAXd+w
	 lwRd4RgAKCfhQ==
Message-ID: <sashiko-outbox-217864@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v1 3/7] kexec: use GFP_HIGHUSER_KASAN for segment pages
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
In-Reply-To: <20261116230627.3537051-4-jeffxu@chromium.org>
References: <20261116230627.3537051-1-jeffxu@chromium.org>
 <20261116230627.3537051-4-jeffxu@chromium.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 16 Nov 2026 23:15:25 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> kimage_load_normal_segment() allocates the pages that hold the segments
> of the next kernel. The kernel clears and fills them through
> kmap_local_page(), and they are never mapped into userspace.
>=20
> Allocate them with GFP_HIGHUSER_KASAN, so that they keep their KASAN
> tagging when GFP_HIGHUSER starts to skip it later in this series.
>=20
> No functional change: GFP_HIGHUSER_KASAN has the same value as
> GFP_HIGHUSER at this point. Build tested only.
>=20
> Assisted-by: LLM
> Cc: Baoquan He <baoquan.he@linux.dev>
> Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
> Cc: Pratyush Yadav <pratyush@kernel.org>
> Cc: kexec@lists.infradead.org
> Signed-off-by: Jeff Xu <jeffxu@chromium.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261116230627.3537=
051-1-jeffxu@chromium.org?part=3D3

