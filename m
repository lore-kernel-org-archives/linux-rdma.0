Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795285942;
	b=I8vbqIwr/pVP94Ri3ivV3QNhewW8WkJGKMNIekFUjoJLeFDjzY1WudWtuljAX1+vkDvA
	 ApfglH4gqd725iviC7ERQXnGsshqor3s3rju+Bbqxkmsusc8ApGbejPZN/dpQkcnZ5uD2
	 QPIwjdQ70BXD3t9Ct0OStlDfMjPq6CmHpyRWt94QAmnHukr2KyM+VwhnH6u9uaxaAE5xX
	 QR5ob4EHqCgtlq7vjc7mG7LgWQDZx5Z5CIFAfdMAQBidLSQfpYQGdU5QEVeg7bj0PA8Tz
	 AxdWfRhohT2rgLXkYJQ6LDQP1zOyDKHAMVttmJQL22K3jWtOlJdXokeC4sInPfRFrNw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795285942;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:
	 In-Reply-To:References:Auto-Submitted:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=Uwqp7Bz8a5D3/B2xkBHbhP2Bh4hQYQFs0RxyAqY1Gn8=;
	b=zSyUOAlql4Jf2EvKXcDzdbaSfk8Dy3Xt81V4qdo+ztbQAr3jCcT5E8M+HH9ZQF2osm+Y
	 +TreZaw4T4t8r4/MkiguGtWKTAMFpXUrVrK/7EEDVzjdZqA9SQl1rUDBHLZNtvGS3wXhe
	 RryfF5RegdKiCJTX+8uLdBRqz8C7SNk24l10ERBeU/NcCYlEnf6KLzvf6kDwwNtSxd7Xf
	 AyRirrH0yuZDPv9L0SsLjPa0Y3BsFdE9ZvfXdArwce2XvQjPy3Ir+pHoDLDdg8ZrPjHAV
	 wyQAe5EJDXeqp7yZOZytWLorLgdAAZ5uuaznMhbnHTjJ8YFP/IHk0vl4KY0EkHErzKw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=luVHhdhh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14FD5606A32A;
	Sat, 21 Nov 2026 18:32:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=luVHhdhh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 400C91F000C4;
	Sat, 21 Nov 2026 18:32:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795285941;
	bh=Uwqp7Bz8a5D3/B2xkBHbhP2Bh4hQYQFs0RxyAqY1Gn8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=luVHhdhhhpK9icw+LCkgbtvGaMY1cmgjinFdFBltJHShHSBvir199I1bOaUILkwZm
	 tfVJgsSNDReS4zGi3GQ6RBQlmJr+pBiUXhtB/foet1VjYKSf+kLQIYJGSmz4upIyDM
	 KkfAGQ6y4rDyG6tYp7Dv8nz1nCjC7UdC+GM86agQcJay3hi1wUcb9XubYNgvSv5eG4
	 VMAwReKKQjnzge9DFkqihPP8jee+e5my1VBZalQEdqMrvQOoVlMeqOx8RxYex6YZTk
	 9qBhKNAiqqCTapKVYWXBlH9tWuuTEi0XCgU7uYShIk1kNMQKvSowlidHsAZdqd/Of5
	 kxkeIzNZ34uUw==
From: netdev-bot+sinfo@kernel.org
To: Julius Bairaktaris <julius@bairaktaris.de>
Cc: netdev@vger.kernel.org, davem@davemloft.net, edumazet@kernel.org,
 kuba@kernel.org, pabeni@redhat.com, willemb@google.com, horms@kernel.org,
 andrew+netdev@lunn.ch, dsahern@kernel.org, idosch@nvidia.com,
 ncardwell@google.com, kuniyu@google.com, steffen.klassert@secunet.com,
 herbert@gondor.apana.org.au, richardbgobert@gmail.com, ecree.xilinx@gmail.com,
 andy.moreton@amd.com, alex.austin@amd.com, linux-net-drivers@amd.com,
 saeedm@nvidia.com, tariqt@nvidia.com, mbloch@nvidia.com, leon@kernel.org,
 linux-rdma@vger.kernel.org, alexei.starovoitov@gmail.com, ast@kernel.org,
 daniel@iogearbox.net, andrii@kernel.org, eddyz87@gmail.com, memxor@gmail.com,
 martin.lau@linux.dev, song@kernel.org, yonghong.song@linux.dev,
 jolsa@kernel.org, emil@etsalapatis.com, ihor.solodrai@linux.dev,
 john.fastabend@gmail.com, sdf@fomichev.me, izaiahsun@gmail.com,
 corbet@lwn.net, skhan@linuxfoundation.org, rdunlap@infradead.org,
 shuah@kernel.org, bpf@vger.kernel.org, ipsec@lists.linux.dev,
 linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH net v3 0/2] net: keep the TCP fixed-ID flags on the header
 they describe
Date: Sat, 21 Nov 2026 18:32:18 +0000
Message-ID: <179528593876.3294.15737463278061995689@kernel.org>
In-Reply-To: <cover.1795284858.git.julius@bairaktaris.de>
References: <cover.1795284858.git.julius@bairaktaris.de>
Auto-Submitted: auto-generated
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0

Hi!

This is an automated message. This series looks like a fix, but its
commit messages seem to be missing some information:

 - What hardware the change was tested on. For driver fixes please
   mention the device (and if relevant firmware version) used for
   testing, or say that the change was not tested on real hardware.

Please do not repost the series just to address the above. Instead,
reply to this email with the missing information, so that reviewers
can take it into account.

*IMPORTANT*: If you do repost (for other reasons) - please include
the relevant info in the cover letter or commit messages.
-- 
The evaluation is done by an LLM so it may be wrong, if you think
that is the case please reply and explain.
