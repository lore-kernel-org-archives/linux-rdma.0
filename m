Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794870950;
	b=S1h7iWAkx1W8u+ax7P/QBr+QAXw1/kjBlWOnUk2Qkkbz4f/FoiVbeMXfz3rFcCQoyoVT
	 XG/4yAQTgyW4Ry3jvS9l/hLcpssnqYfberYYlv2hplpAjHS0M7ZRZx/opEJyFqUcRCvrd
	 jrziQZuCJUydi/7k2L2GMd/L/rHRdtMfyJ4ZYmiCVoao+r1tPjBdVC6cNln239AXDRRAJ
	 qUpN/iiBEo9LAUAV8wqijk7ok3bHhICHc+mDkJtd7kLFM7RP6TTwoFLylfAge0JWEINP0
	 11wcuokYXc6ggQiftHkOcnnKWlgDAgcVS5Xc26HhIEuMCcx73ffw4UaPEQO+mUS+6ag==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794870950;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=lRSp/KC43fGl85hMws3gLKnBnmqSKLCoF94lqJrfAqE=;
	b=UqWSM7gyg2waIU7+SzTVb3zujt6JrZbkzN+OQwx2a//4v43pqlE4/g9szvKpaCmZjDQ0
	 efs71javJmsYTmWW01C7p0pXBWtPXCYHut+nSLm4/I+ApiwxD6K9a6viALxM25haJryTx
	 lqhqpZ72tPtoSb73XShZ3tftACpnn0EOy2LHM3gIp+v14fLp0nddoxfmWplJDMPw4M6O2
	 0vXs+h2MLcHZwS0pu/HoNCNDAZTqtV1PALYpC2y+HvGEOcjpLPi3N2qRMdm52WeCQ6P3H
	 iHhtCDPvUXhaOFFDMnDAGBcD+DgQ8X2GGnyU14saYTlC35UAbxuzJMQq2S4UBd4MVNA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HS+icqbZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92B22606A31C
	for <linux-rdma@vger.kernel.org>; Mon, 16 Nov 2026 23:15:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HS+icqbZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA7DC1F000C4;
	Mon, 16 Nov 2026 23:15:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794870950;
	bh=lRSp/KC43fGl85hMws3gLKnBnmqSKLCoF94lqJrfAqE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=HS+icqbZIwAvtzuceRLVtpGNxVXXidAEZwW1IgkoWdrqefKgKmafv6my/m1BetmXq
	 imfVa37wyQPRUWWdHlNgjGFkiGaZO00LWnsnsMMyyZl4umJirEyZcmJB3OQ1TCnGkl
	 U2aPOhqbzZK8LWqf0N6fFXFbiH29M/suvX63zbgyqOjLfn1vhqTrXkU+9L4O2p4hPY
	 tDmjpkjsYW1g1ZcbiUABR9oJn/rCBMAeRF/VWha3yz4if00nMEnPwlhoNEYRqPO0eq
	 te8C8N0VvI2dr24iC8W0rmVZ2gpGnoDNcO7WcnR75uUficH5kM+drNW2eiBq1cU0Tm
	 JEgvU+aTNfPpg==
Message-ID: <sashiko-outbox-217866@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v1 5/7] mm: kasan: skip KASAN for GFP_HIGHUSER
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
In-Reply-To: <20261116230627.3537051-6-jeffxu@chromium.org>
References: <20261116230627.3537051-1-jeffxu@chromium.org>
 <20261116230627.3537051-6-jeffxu@chromium.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 16 Nov 2026 23:15:36 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> Move __GFP_SKIP_KASAN from GFP_HIGHUSER_MOVABLE to GFP_HIGHUSER so that
> both GFP_HIGHUSER and GFP_HIGHUSER_MOVABLE allocations skip KASAN
> unpoisoning on allocation and poisoning on free in HW_TAGS mode.
>=20
> Previously, commit c275c5c6d50a ("kasan: disable freed user page
> poisoning with HW tags"), commit 70c248aca9e7 ("mm: kasan: Skip
> unpoisoning of user pages"), and commit 0a54864f8dfb ("kasan: remove
> PG_skip_kasan_poison flag") added __GFP_SKIP_KASAN to
> GFP_HIGHUSER_MOVABLE because user pages are not intended to be used as
> directly addressable kernel data structures, and the lower likelihood of
> catching a kernel linear-map bug on user payload pages does not justify
> tagging all 256 16-byte MTE granules per 4 KB page on every allocation
> and free.
>=20
> GFP_HIGHUSER shares the same kernel-accessibility contract in
> [ ... ]
>=20
> Link: https://lore.kernel.org/r/20260519-panthor-kasan-v2-1-b7384458f076@=
gmail.com/ [1]
> Link: https://lore.kernel.org/r/20260521105148.5497c281@fedora/ [2]
> Assisted-by: LLM
> Signed-off-by: Jeff Xu <jeffxu@chromium.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261116230627.3537=
051-1-jeffxu@chromium.org?part=3D5

