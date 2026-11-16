Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794870937;
	b=lZSJ7GNsgC9qkPlu/ovvBgH9J7GpfHVE3CH0aoE6NoazHpS5FIqDg5ZECtf0HJnQFziw
	 fqZKG+SlRINmDpSwicBrML4bklmNnZccvgIqA4CUiTQVD0bM3UJBBhIT1Qp34ucD2GIEl
	 r5eDL8GXardnnEuWYJSjmhbO6QNQHRmQu8ZPmIDsBKO32TT/X95NNxisCpk0+pZIBny7C
	 +pECqhZEyvKrKq0eCQkLQozxeXunVCc745p+6SbQ/Nl3vxWUBLJQewIYCfci3b+n6hZMx
	 oNptD6znlytdJTN81AjuZv5HXFsb29ZqlSeMLTrXfZABgbPXf/KRZ5/+vqvZ2lGpuAg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794870937;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=irlTfbuxdiMpDcvP4FHkEhCPa2hhZ00WVQ6MUSYj6Pc=;
	b=SLRXGTSG+QYE8hWfjCBp1DT+JWJK1S8PNyo7af0cBqPWy1Svy9wTRnlyVycE+Oxrr4I7
	 o0ZnyX9dfZTkftmiPYbnnvrq8IxXWHNsl8ztL0Rw+f4Gh1A2kY7I4BvGNCo9wPPReu10i
	 qROEz9toAqq7xzuoq/P8tXTcWdEuwKhv/P5qumdTvnnK6LvyUDh5YHhEcs4+VNOnkJWSv
	 mfR/SZgxzLQOue3DSDnWhd+1w8OBYSjmf0Bg8mtOJDQAFT7emC2YIzSi6xTPSSHOzsLej
	 89k/JTM0Ne7GGuTK/ioUcOL4Vi0vyJiHbHxNvv4wRDXV0hTnNgGbMbQHsFpR3DpNfXA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=IKkvvYxV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0CD8606A32A
	for <linux-rdma@vger.kernel.org>; Mon, 16 Nov 2026 23:15:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=IKkvvYxV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBE711F000C5;
	Mon, 16 Nov 2026 23:15:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794870936;
	bh=irlTfbuxdiMpDcvP4FHkEhCPa2hhZ00WVQ6MUSYj6Pc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=IKkvvYxVqcZvdS1TDlwoU2qoUoA5xI9SLsm+DXbuUwb0vz9kbwET7e8B6Cm4jiEtF
	 A+OpELWCjjj0DERNQQSR6+Yuo1dXpQzsNZsQf2/FELRJA7Yw/SVomlqGooaqXkvOhY
	 KhxY7j6827+UFVOH7QsTPhubv5IMORt0lXEhLwhqGjeqQ14outAW41QAU4ErKFA0I3
	 rMtt0BJcEOMjscthUUUCR4womdcHk+MmBWeOZzzfxFigSKhTVlSKoV4IlRUibj8PIz
	 huff0kFBiA/h3qvNgxA6sUJ7CzFrqvv0Xg4GXO6YoV1rvLdK6/Lm/+lB40RBgOcfT2
	 /vQFi/FF113Yw==
Message-ID: <sashiko-outbox-217865@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v1 4/7] net/rds: use GFP_HIGHUSER_KASAN for message
 pages
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
In-Reply-To: <20261116230627.3537051-5-jeffxu@chromium.org>
References: <20261116230627.3537051-1-jeffxu@chromium.org>
 <20261116230627.3537051-5-jeffxu@chromium.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 16 Nov 2026 23:15:29 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> RDS allocates the pages that carry message payload with GFP_HIGHUSER:
> the receive fragments in rds_ib_recv_refill_one() and the send payload
> in rds_message_copy_from_user(). The kernel fills and drains them
> through copy_page_from_iter(), copy_page_to_iter() and kmap_atomic(),
> and they are not mapped into userspace.
>=20
> Allocate them with GFP_HIGHUSER_KASAN, so that they keep their KASAN
> tagging when GFP_HIGHUSER starts to skip it later in this series.
>=20
> No functional change: GFP_HIGHUSER_KASAN has the same value as
> GFP_HIGHUSER at this point. Build tested only.
>=20
> Assisted-by: LLM
> Cc: Allison Henderson <achender@kernel.org>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Eric Dumazet <edumazet@kernel.org>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: Paolo Abeni <pabeni@redhat.com>
> Cc: Simon Horman <horms@kernel.org>
> Cc: netdev@vger.kernel.org
> Cc: linux-rdma@vger.kernel.org
> Cc: rds-devel@oss.oracle.com
> Signed-off-by: Jeff Xu <jeffxu@chromium.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261116230627.3537=
051-1-jeffxu@chromium.org?part=3D4

