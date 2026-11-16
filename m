Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794870956;
	b=QyF7MILIP70E5qi2bfs9hCKRS6r3K7mjQYOZxlu+zLPsiQp+RBGKQhZu7/IyKrKNKK7M
	 qSdGkmBr6rW+N0STvMlGrsZPj4xvkICxrOc45h74eY3fWoTJxrRDVbxJcXjXiruI4dfnU
	 9DfIK6iF0aY7aL8/AsJ/bB2FpYK3xzEDHB9ui0mX1xn/lQtu8xhW4UK2Wc8rUoxGnnpN/
	 yHd6iZzpLth/qwvjSnsnVsHe0J5fBCIcWYc3Pf3PMvBNwckOUFldK8MP7BTv6PwU4F6OH
	 1Ho3ZnyXBad0TXD/aDSSGfn4MvnUGTfDqkjjmoG5Ec3y2q0FTpyd0IwC3wdiHtMJBZQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794870956;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=grGi9MDFa2ndr+WLT5GQOibMFXvsdaKosOQN2//MZ0Y=;
	b=sTpZtbuItfrw+2IHGK/keiNg+rVDGxdFtjwKUeNH7Q+FROX3VQOKDXadBGCsOXRyxMCy
	 I4vlT9YhXeJmw9kjLDf3E79QWCQgbURWzomVxCLFKdIr8XhFYoo8fH+n5ApZiBQNa2xnA
	 1cV312oustqhoXxph4m0ZYhZLdbJ08yMwHFmMfmFui+lgGqblvuBGVm28MFF5p6vbjDNr
	 Fdmz85BzZb9zb83uDAlMWKVUrCvVWZaKRhBjL8eN99VXpH6dtGlJ4bL7ysQCp0sYReiUW
	 EtSJIvE+LOfdHeFCWzWlh37ALZs6wi7FpcbYYkyrvO4430E7HfHs/lvAK3fqfp/Lhlw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LmpQqCUj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74CD5606A31C
	for <linux-rdma@vger.kernel.org>; Mon, 16 Nov 2026 23:15:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LmpQqCUj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8A8B1F000C7;
	Mon, 16 Nov 2026 23:15:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794870956;
	bh=grGi9MDFa2ndr+WLT5GQOibMFXvsdaKosOQN2//MZ0Y=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=LmpQqCUjKYiEcsETYyv8u0vwyxYn4lK7pM6j+tZ8AuGUJy4Rr1G2dEQe2bv90pnFu
	 zSRaaGo+t1IjgZ3ickHcqApDRFYWhFblsJNsMaWB48X1XF7zBmQprhUdwE67ADkRfj
	 N/ajjnLovPa7OEFAIFNmbhpuMwOZEPe1nf7bOfy1y444naRENQFgv/dG97XfvEkvRm
	 JBUS8ANGrDmfV+zaJmKaoMg8swbphPo1nbveD6+NoBTLCLtqwcjQwzPcWd/8zROTxb
	 wfJ7zAdvc6nUKSC0UZ6aMrnwFRP+6LVmAkMZA18+urDD9npW3bwwvLsJ+WFJH3khKW
	 yIDDXvdUsLOTQ==
Message-ID: <sashiko-outbox-217868@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v1 7/7] mm/kasan/kunit: add page_alloc_highuser_kasan
 test
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
In-Reply-To: <20261116230627.3537051-8-jeffxu@chromium.org>
References: <20261116230627.3537051-1-jeffxu@chromium.org>
 <20261116230627.3537051-8-jeffxu@chromium.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 16 Nov 2026 23:15:53 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> Add a KUnit test (page_alloc_highuser_kasan) to verify that, unlike
> GFP_HIGHUSER, page allocations using GFP_HIGHUSER_KASAN under
> CONFIG_KASAN_HW_TAGS:
> 1. Get a KASAN tag in page_kasan_tag() across all sub-pages of a
>    high-order allocation, and the same tag in the pointer returned by
>    page_address(), and
> 2. Are poisoned on free, so that a use-after-free through the stale
>    pointer is reported.
>=20
> The test fails if __GFP_SKIP_KASAN is added to GFP_HIGHUSER_KASAN.
>=20
> Tested on arm64 with CONFIG_KASAN_HW_TAGS under QEMU (virt,mte=3Don) with
> kasan.mode=3Dsync, async and asymm.
>=20
> Assisted-by: LLM
> Signed-off-by: Jeff Xu <jeffxu@chromium.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261116230627.3537=
051-1-jeffxu@chromium.org?part=3D7

