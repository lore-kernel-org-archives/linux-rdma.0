Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F19982737E0
	for <linux-rdma@vger.kernel.org>; Sun, 26 Apr 2026 16:42:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777221769; cv=none; b=dbgXXkgAkFAiNukgYwJirLe4vNJ+g1oNjAYWUnblZMsuZ0RpYLQn4ixzwhYeNkaOc7X/OD9Oh2LXrXRCrfDmLEBh91WReHn2AAtGBCX4lTDq/g7rRMkBgoELtyGqh26xjqPqj4dP4R+xRhdar3UqIISFXZlM6lw3CDzvu9pD5zk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777221769; c=relaxed/simple;
	bh=4eoSr233KZVe73qZSAjf8Rh1mIXFHOGlTzPo+qqUqjU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=bsUg1EbucNxcBS35nf1SwqLgaPfQ3ZY/e3/yD4VgOFBUnLXwS1Y7S+TPAilzFV6J0+MiK5dNNiECBK9MlfCbR9rf3rsiPrWcdXEjcZoexN6n7BiAZHB2K/b4RnVwPKa3g8EHzvJwPT+uaamdqOgkDRXWY8iKdynTbZFcFPivP0k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hiALT5MG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hiALT5MG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 507B5C2BCB7;
	Sun, 26 Apr 2026 16:42:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777221768;
	bh=4eoSr233KZVe73qZSAjf8Rh1mIXFHOGlTzPo+qqUqjU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=hiALT5MGG72g5eHAy6/hfxTzXiWBVB2cURB5l8NCXYwYtf9Tl9EddtfmwNoy+yIdr
	 aoV7832fOb8r2U7OukbPiJm++LD0YWWKLf5yHsFuf7cq29UKd/tvTqPMAfUmZcneG/
	 ZW4DDwOvOxSsvsbCslZoumV0bIDM099fjdWespdheHm5oEkRCncj3mqTtpq6nSs3st
	 HB55oIQD0XvfZMatC5TK/TXZy0rIAgeTdAmIIG8J9tqowCpr76ERb9W4A3UNio7ktJ
	 pvBKa6o5ptGsi8k41PdjLTh8fBNxX+TcNMXTFKB0/nb1B1XDHHEJAay7K8WXvbaZH/
	 TTPe5J5WwVEVQ==
Message-ID: <86499305-4522-4a82-a689-0247f2d5f6c0@kernel.org>
Date: Sun, 26 Apr 2026 10:42:47 -0600
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/2] RDMA/rxe: Fix null-ptr-deref in
 kernel_sock_shutdown().
Content-Language: en-US
To: Zhu Yanjun <yanjun.zhu@linux.dev>, Kuniyuki Iwashima <kuniyu@google.com>,
 Zhu Yanjun <zyjzyj2000@gmail.com>, Jason Gunthorpe <jgg@ziepe.ca>,
 Leon Romanovsky <leon@kernel.org>
Cc: Kuniyuki Iwashima <kuni1840@gmail.com>, linux-rdma@vger.kernel.org,
 syzbot+d8f76778263ab65c2b21@syzkaller.appspotmail.com
References: <20260425060436.2316620-1-kuniyu@google.com>
 <20260425060436.2316620-2-kuniyu@google.com>
 <030d3487-b5b9-4067-8b8c-89b4e8756e1a@linux.dev>
From: David Ahern <dsahern@kernel.org>
In-Reply-To: <030d3487-b5b9-4067-8b8c-89b4e8756e1a@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 4/25/26 3:25 PM, Zhu Yanjun wrote:
> 在 2026/4/24 23:04, Kuniyuki Iwashima 写道:
>> syzbot reported null-ptr-deref in kernel_sock_shutdown(). [0]
>>
>> The problem is ->newlink() and ->dellink() can be called
>> concurrently with no synchronisation, leading sk leak or
>> double free, etc.
>>
>> We defer UDP tunnel allocation to the first device creation,
>> but this would requrie per-netns locking.
>>
>> Let's allocate UDP tunnels in the __init_net hook.
>>
>> Now extra sock_hold() and __sock_put() are no longer needed.
>>
>> Note that rxe_ns_pernet_sk6() is broken and will be fixed
>> in the following patch.
>>
...
> 
> All the commits are functionally correct, but I noticed some regressions
> when running:
> make -C tools/testing/selftests/rdma/ TARGET=rdma run_tests
> 
> After applying this commit, the UDP port 4791 starts listening in both
> init_net and all other net namespaces as soon as modprobe rdma_rxe is
> executed. This breaks tests that expect the port to be unoccupied until
> a device is actually created.

Not opening the port until an rxe device is created in that namespace
needs to be kept.
