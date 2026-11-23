Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795405297;
	b=JJEGi2lFQ+15IApjhFdl4q3lyuqRTmgsJnattu163nBY+YLFxYBfuZryYi90WRZ0WZHy
	 uvjVx7GxT4Zm8GWkxlxYNaDLja7PMAeVrDSoAFabSiL3PhZFpz+Jp+iXEw9mG7a1hAnhj
	 yITyZB7peekAB/b12pyPs3I9j3UCge/xk6e1OuE1FrVfptBTPsWoQGp1KUKo1N21b58MX
	 gPTkdAkmYduc8X9hCyS9oAhuVu4vAVlGLix1opmBJh86+ccFSPCc6yl1+o2t+MeN+6odK
	 3EIONSk1n4KWFc4VKY5kUeWQTdWFV3+WZnFXJMrTHKxNaP9c1n7HV7tyEpsjYFBY5yQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795405297;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=O2PDXHMEw4Fy1/k2MO0pkbPKF0H2GXDc7bKdUmva7j0=;
	b=vGcvwG72knaosACNjx90KjOV33651x+VGj7pMvTlljimcbg+pzA5ct7a92oqinwJkQ3K
	 CNUtNGHEImtPbDgRXaVR162Nc+kDcuyNfCvcZFuhw1hvx1eSyfqKLmUkpuktvGdHWZTHv
	 jNmVNea3gC7mgVYeeMAzcpWzr++pV089LC2aUtHccOO/ssu7dgwSMlhuK3kfSS790Ldjr
	 hYlag0s8RHc85BhhxXBjECEAl9biSQTQRZ1UWSywyyo5OGB/lsrXVEoPadzIiR5wRfcYv
	 Kdq6QzEixVMPQs1QJr5CqYVElGOdWf2t4O1BaMP4SybUnbzRbn9rLxCkzdFds1ZFDAw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HuTvG9Ls;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D93A6606A335
	for <linux-rdma@vger.kernel.org>; Mon, 23 Nov 2026 03:41:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HuTvG9Ls
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2D551F000C0;
	Mon, 23 Nov 2026 03:41:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795405297;
	bh=O2PDXHMEw4Fy1/k2MO0pkbPKF0H2GXDc7bKdUmva7j0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=HuTvG9LsMTyG96xK4He1xnM4Eg6W/7bkzxLa9wAADy8G8YTM6SSATsQz7ndTQg4hU
	 YHF7hfCesJBna1yd/N2+Bt28V9UGpsPZ7gZJv3MiH82D+2mXXkceKkPQ2hhYpGdBEP
	 Jvf1LhzArln55BIY5qwd3p6/XtoePRi3H7yEnl+JCioe1qdAmdURrSYVGosQJ22mzV
	 7L3xfHZHf5XdYI8UkpgNcgk8c3QcXFkpDJSv8FxxDIot0OLoj4Y+h6UuCigirmzPsJ
	 r+gALl2drqsJ8M88YYI0RR9E+Pna5NHsvUztfOVTWdHCgpgLAekrD7n1UIFmvgLZY0
	 X3NbWvWnL48MQ==
Message-ID: <sashiko-outbox-228597@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 0/2] mm: kasan: skip KASAN for GFP_HIGHUSER
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
 Wu" <olvaffe@gmail.com>, "Dev Jain" <dev.jain@arm.com>, "Ian Rickards" <ian.rickards@arm.com>, "Jann
 Horn" <jannh@google.com>, "Jeff Vander Stoep" <jeffv@google.com>, "Jeff Xu" <jeffxu@google.com>, "Kees
 Cook" <kees@kernel.org>, "Mark Rutland" <mark.rutland@arm.com>, "Peter
 Collingbourne" <peter@pcc.me.uk>, =?utf-8?b?UGllcnJlLUNsw6ltZW50IFRvc2k=?= <ptosi@google.com>, "Ryan
 Roberts" <ryan.roberts@arm.com>, "Tomasz Figa" <tfiga@chromium.org>, "Will
 Deacon" <will@kernel.org>, "Alexander Viro" <viro@zeniv.linux.org.uk>, "Christian
 Brauner" <brauner@kernel.org>, "Jan Kara" <jack@suse.cz>, "Miklos Szeredi" <miklos@szeredi.hu>, "Baoquan
 He" <baoquan.he@linux.dev>, "Pasha Tatashin" <pasha.tatashin@soleen.com>, "Pratyush
 Yadav" <pratyush@kernel.org>, "Allison Henderson" <achender@kernel.org>, "David
 S . Miller" <davem@davemloft.net>, "Eric Dumazet" <edumazet@kernel.org>, "Jakub
 Kicinski" <kuba@kernel.org>, "Paolo Abeni" <pabeni@redhat.com>, "Simon
 Horman" <horms@kernel.org>, kasan-dev@googlegroups.com, kexec@lists.infradead.org, linux-rdma@vger.kernel.org, rds-devel@oss.oracle.com
In-Reply-To: <20261123033111.2349160-1-jeffxu@chromium.org>
References: <20261123033111.2349160-1-jeffxu@chromium.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 23 Nov 2026 03:41:34 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

Sashiko has reviewed this 2-patch series and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261123033111.2349=
160-1-jeffxu@chromium.org
