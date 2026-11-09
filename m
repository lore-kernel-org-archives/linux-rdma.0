Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794187377;
	b=v0cQ//dnBCZNMkYOxHZpFRp9kGybDxcX0jcJ7bUVeO7CpqVxJ+3LXg5DHc0Qe2vimAJq
	 doMGhQSq95lU6Gw3vAmawRpwlTA93PusLn6DcS4oktIHJ0JT+Hcc2z5KwHvFZU7abSQ4B
	 M8eONfN3zYAkjXfjm+suyWHef9jJ5iV1hf1Uv45FUazuXbhulCzg7IVXGhTJrBRN7KSOi
	 BKO/fIKs4LycdSLgcWcAoWPYz1dy+zuv0wmgSMoJfwHwb6MN0ZjKjZ5zcV7sXqPUjGQgo
	 RYRwrkYiG+o4GRDjZWKd2B1SfggY8OcOtgGUVFSWCebuTWh7qAUwuKJrVFkB0exu/sw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794187377;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=0gfAlVochtQm5lytYfXHTreCqdI78xkjuwG4XImhaMQ=;
	b=1gADcxsgNaWDrAUhz+xW5iFwb3nzv4dT3lms3KtVYs521Y8t9ZHGcuGnMJN5mHZy8n6p
	 8L8/jtUB3myJkj0flrwY6HbDBHCN/LiYx1w3L9zRmGHylT1axyxwtQeXhig9rqtchjR5q
	 ea1j+KAuw1yh/wkh328MgeMAKg4Iic7ssCUNwUiqMleXgan1JLnlM4ZiHp0XvgXJi8UG/
	 68PY2L5RArlCSLK7EmLygCIy47Fbh7BMrfJ+N3NTJM+h0xnkwOYD0srJvRpkbR1RRnnR9
	 PeEzzHDavnnivKy21SFh2sg4SbUq12NVWKnzinledv+sFa0kql9rXea0HfvC+cPxbyA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="B/fADljg";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52239606A33F;
	Mon,  9 Nov 2026 01:22:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=B/fADljg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 385B41F008A5;
	Mon,  9 Nov 2026 01:22:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794187376;
	bh=0gfAlVochtQm5lytYfXHTreCqdI78xkjuwG4XImhaMQ=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=B/fADljgyUCJqhTF/tBUF/VlOJ1/sUpEsAd/SXMlagTzlja1R+xmDQ8heSqWENBiP
	 LpTMvvjpYurt0d/nSn6hxmFucoUCZjhWvVPZGlnYIY7IeDOyQbADsE2dVVoQnreZTE
	 pwF0XgRZHN16CDyZQRQ98rDx2CdY7ixcU1nVyYbsMGjfjixAQuzlVBPN58S3wHrEIg
	 hm1amb+qDSPCxZfUd3XJ6B9oI2wgBlIMp2EEmOvYvCyTUF+oeDzchTBQdmrcC+jhxV
	 n45q9ttgUxFryPoUo0Ck4CdlKMxTiwZhDfI+tzXeQYx4o2i4cK8pAm0/mKa/0uIeN5
	 SNFcj5aCyo3Ug==
Subject: Re: [PATCH net-next v3 2/9] net: devmem: charge the frag length to TX
 skb truesize
From: netdev-bot+sashiko@kernel.org
To: sdf.kernel@gmail.com
Cc: netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
 kuba@kernel.org, pabeni@redhat.com, andrew+netdev@lunn.ch,
 edumazet@kernel.org, horms@kernel.org, corbet@lwn.net,
 skhan@linuxfoundation.org, rdunlap@infradead.org, michael.chan@broadcom.com,
 pavan.chebbi@broadcom.com, saeedm@nvidia.com, tariqt@nvidia.com,
 mbloch@nvidia.com, alexanderduyck@fb.com, kernel-team@meta.com,
 sdf@fomichev.me, dimitri.daskalakis1@gmail.com, almasrymina@google.com,
 dtatulea@nvidia.com, bobbyeshleman@meta.com, asml.silence@gmail.com,
 daniel@iogearbox.net, razor@blackwall.org, leitao@debian.org,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-rdma@vger.kernel.org, linux-kselftest@vger.kernel.org, leon@kernel.org
Date: Mon, 09 Nov 2026 01:22:54 +0000
Message-ID: <179418737471.994134.1610173509867103547@kernel.org>
In-Reply-To: <20261105222058.944293-3-sdf@fomichev.me>
References: <20261105222058.944293-3-sdf@fomichev.me>
X-sashiko-severity: Low
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0

Thank you for your contribution! Sashiko AI review found more severe
issue(s) in other patches of this series. This mail is only an FYI, in case
you want to address the nit picks below when you respin.

Low priority / nit picks for your consideration:

- [Low] The commit author and the Signed-off-by use different email
  addresses.

--

net: devmem: charge the frag length to TX skb truesize

This patch changes zerocopy_fill_skb_from_devmem() so each devmem TX frag
charges its length to skb->truesize, not PAGE_SIZE. TX net_iovs are about
to grow up to 2MB. Charging the net_iov size per frag could then fill the
send buffer with a single skb, and charging by length also matches what
TCP uncharges.

> Author: Stanislav Fomichev <sdf.kernel@gmail.com>

[ ... ]

>     Signed-off-by: Stanislav Fomichev <sdf@fomichev.me>

[Severity: Low]
This isn't a bug, but the author address and the Signed-off-by address are
different.

The author is sdf.kernel@gmail.com, and the only Signed-off-by is
sdf@fomichev.me. The body has no in-body From: line to override the
authorship.

The .mailmap entries for sdf@fomichev.me only map sdf@google.com and
stfomichev@gmail.com, so tools that read .mailmap won't match the two
either. checkpatch.pl reports this as "From:/Signed-off-by: email address
mismatch".

The other patches in the series appear to have the same mismatch. Could the
git author identity be updated, or a matching From: line added, before
resending?

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261105222058.944293-1-sdf%40fomichev.me
