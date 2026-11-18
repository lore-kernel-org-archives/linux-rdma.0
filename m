Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794995204;
	b=U91er+ucZBcAOwtvuGxk3foI1ZqeN02N2xWOlpOplV1mWEFbRoFaAfXB5YIBymgUUX6W
	 CV8/Lkuc0uxdhWsYzQXIFZL7G6ayD2V4CXz0NX+A4JR7t3iVKbdwHAWh38HHwiaNKCJo7
	 iHO5L70p7tyBRuTHMyoQiV7XA53aQgkxRaBebxYZOlLN+G1vf2HTCN3Jqqt9Ff92DDhfx
	 b3G092TkBx5U+NNsngK7GMBm/Csd/gk5PAkWqSBtNIJCyvqi/LO0HwlG4bzVqg7Y5pf4I
	 hyOGtfEUgQUTlNsFsjw5tDIQ6CCkvX8Tenww4o1pZx6bFUqKnlLo+jt6+2LyQ3F/EXw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794995204;
	h=Received:DKIM-Signature:Message-ID:Date:MIME-Version:User-Agent:
	 Subject:To:Cc:References:From:Content-Language:Autocrypt:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding;
	bh=CtaieybfS6BQtpEqYoffKr95cQJaQPqI7rmHn30lmpg=;
	b=mg0J7lnPNL6Z51SCOPTACweg0G4aQLWH1RXRU/PRrOFQIBDL85auSM5ENa6rLIGNT8aT
	 lKclzH7qoNz+4Lm6B8Si32HlLj2R++a2tExzBbByVvSZZHlQNFaZFPR4wpXwZSz4czbSJ
	 aMfCNSvcKLIm97jz3z5x/6FNoxqGvmCeWScHH0nOBEmv00mbCtpfQvwboiHA9rbX3k2h3
	 ZjZfC6/eU1+5wKTFsIHByNFmNP/6d1sHn4+Y4fkxVM6oD8JOa94V9vagyEgQHgwxQkKId
	 7KHmcQ6KFEJ67/Ee0pWgWGNMVzte1FCqQLGc4llT9Cc39v/1IVKCSXNkuZzrTs1hWGw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RQYGohhW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E79A606A32F;
	Wed, 18 Nov 2026 09:46:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RQYGohhW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA1101F000C4;
	Wed, 18 Nov 2026 09:46:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794995203;
	bh=CtaieybfS6BQtpEqYoffKr95cQJaQPqI7rmHn30lmpg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=RQYGohhWWhAMmEGxIAzOYr6Fx+D3c8etuGKHMFcbyKBYk19gb0PmTU3vg4xr2/6an
	 SJ/qop6o7easXoypEONyiMJCk8cgR+yJjAnGlWhqyYJ/ziD1aNlj2ESpXtYiDNRwlj
	 e5B2ZdNugULbszT5sBs7bvHePzJ8bmuqz1BjALmVdtQaVhFWk40mYXG3RtN1ZfLaG8
	 CO7RPHtrPQW3mS0ouvPJuJjTBrscheUKbE+yzjJIA5+EdbTjFPpS41EOhTYuSfpYXk
	 m2o215lUT4PGALLB0rFVQlxsiCFea6eOd2CBZHCy/6uKXDd0NHCR7gWa9XW+UGFy9f
	 mZGW3Ic1lhhTw==
Message-ID: <332f315d-ea27-488a-9a3c-28cdfdcd5f27@kernel.org>
Date: Wed, 18 Nov 2026 10:46:24 +0100
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 0/7] mm: kasan: skip KASAN for GFP_HIGHUSER
To: Jeff Xu <jeffxu@chromium.org>, Tomasz Figa <tfiga@chromium.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Vlastimil Babka <vbabka@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>,
 Andrey Ryabinin <ryabinin.a.a@gmail.com>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R . Howlett" <liam@infradead.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Brendan Jackman <brendan.jackman@linux.dev>, Zi Yan <ziy@nvidia.com>,
 Alexander Potapenko <glider@google.com>,
 Andrey Konovalov <andreyknvl@gmail.com>, Dmitry Vyukov <dvyukov@google.com>,
 Vincenzo Frascino <vincenzo.frascino@arm.com>, Marco Elver
 <elver@google.com>, Boris Brezillon <boris.brezillon@collabora.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Chia-I Wu <olvaffe@gmail.com>,
 Dev Jain <dev.jain@arm.com>, Evgenii Stepanov <eugenis@google.com>,
 Ian Rickards <ian.rickards@arm.com>, Jann Horn <jannh@google.com>,
 Jeff Vander Stoep <jeffv@google.com>, Jeff Xu <jeffxu@google.com>,
 Kees Cook <kees@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
 Peter Collingbourne <peter@pcc.me.uk>, =?UTF-8?Q?Pierre-Cl=C3=A9ment_Tosi?=
 <ptosi@google.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Will Deacon <will@kernel.org>, Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 Miklos Szeredi <miklos@szeredi.hu>, Baoquan He <baoquan.he@linux.dev>,
 Pasha Tatashin <pasha.tatashin@soleen.com>,
 Pratyush Yadav <pratyush@kernel.org>, Allison Henderson
 <achender@kernel.org>, "David S . Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@kernel.org>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>,
 linux-mm@kvack.org, kasan-dev@googlegroups.com,
 linux-arm-kernel@lists.infradead.org, linux-fsdevel@vger.kernel.org,
 fuse-devel@lists.linux.dev, kexec@lists.infradead.org,
 netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
 rds-devel@oss.oracle.com, linux-kernel@vger.kernel.org,
 Ryan Roberts <ryan.roberts@arm.com>
References: <20261116230627.3537051-1-jeffxu@chromium.org>
 <2066d131-f999-4747-beb8-520d5e0ce1db@kernel.org>
 <CAAFQd5DzTmyeVQxNdhdy8pPi+ts1cCgbztVJiMoNBeJWBzjdQQ@mail.gmail.com>
 <20261118012858.289236-1-jeffxu@chromium.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261118012858.289236-1-jeffxu@chromium.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/18/26 02:28, Jeff Xu wrote:
> On Tue, Nov 17, 2026 at 11:11 PM Tomasz Figa <tfiga@chromium.org> wrote:
>>
>> On Tue, Nov 17, 2026 at 7:10 PM David Hildenbrand (Arm)
>> <david@kernel.org> wrote:
>>>
>>> I really don't want us to spread KASAN-related GFP flags in the kernel.
>>>
>>> There must be a proper way to abstract this.
>>>
>>> Why is GFP_HIGHUSER not sufficient? We were already told that this is memory to
>>> be mapped into user space. Placing data structure on it and handing out pointers
>>> to that would already be a bit questionable.
>>>
>>> So what are the ways to avoid GFP_HIGHUSER_KASAN?
>>
>> I think the idea behind GFP_HIGHUSER_KASAN is to make it possible to
>> skip KASAN for GFP_HIGHUSER by default (for most of its users), but
>> keep it for some of the users which today use GFP_HIGHUSER for their
>> memory allocations, but could benefit from the added security. As per
>> the other patches in the series:
>>
>>   pipe, fuse: use GFP_HIGHUSER_KASAN for pipe buffer pages
>>   kexec: use GFP_HIGHUSER_KASAN for segment pages
>>   net/rds: use GFP_HIGHUSER_KASAN for message pages
>>
>> That said, I'm not familiar with any of the code mentioned by those
>> patches, so I can't really tell how much they would benefit from KASAN
>> or if their choice of GFP_HIGHUSER to begin with is correct.
> 
> Thanks David and Tomasz for the feedback.
> 
> Tomasz is right about why I added GFP_HIGHUSER_KASAN in v1: out of
> caution, I audited existing GFP_HIGHUSER callers to find any that never
> map the pages to userspace and instead fill/drain them in the kernel via
> kmap_local_page() (pipe, FUSE, kexec, rds). Since this series intends to
> improve KASAN performance while preserving its security aspects, and the
> performance impact on pipe/FUSE/kexec/rds was negligible in my testing,
> v1 was optimized for minimum behavioral change.
> 
> Looking closer at both of your questions, I agree that the security
> benefit of keeping those 4 under KASAN is minimal -- e.g., only linear
> overflows out of the pipe/FUSE/kexec/rds page, since none of them store
> kernel structures or pointers. That is the exact same trade-off we
> already make for GFP_HIGHUSER_MOVABLE.

Yes, that's my understanding as well.

> 
> To avoid introducing GFP_HIGHUSER_KASAN, I see two options:
> 
> 1) Simply keep those 4 cases under GFP_HIGHUSER (drop patches 1-4 and
>    7), reducing the series to just the GFP_HIGHUSER change and its KUnit
>    test.

That's what I would look into first.

> 
> 2) Switch those 4 callers to GFP_USER. Since CONFIG_KASAN_HW_TAGS is
>    64-bit arm64 only (!CONFIG_HIGHMEM), GFP_USER is identical to today's
>    GFP_HIGHUSER on arm64 and all other 64-bit builds (and if 32-bit
>    CONFIG_HIGHMEM=y builds still need ZONE_HIGHMEM, that could be gated
>    on CONFIG_HIGHMEM, though that feels ugly at call sites).
> 
> (1) seems much cleaner to me. David, would (1) work for you?

Agreed, (2) looks more hacky and I don't see the value of doing it like that
just yet.


-- 
Cheers,

David
