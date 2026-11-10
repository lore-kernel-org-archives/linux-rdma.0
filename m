Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794336505;
	b=azSSJS9ZwtyNGBdduRlaDMg5lvfuMdHmrys+m2htiLayZk/zqglfkwSKHJG5DnNpU6lZ
	 P6mwh/n3aaKcCzosbxG+9em6/JQeiLaU+a2ldVwmU86+gPRNRxcECinuUDwduMj+i4F6W
	 cQKK45q1B1/Kbgvp1uapvwvL/tBiIXPwK39/UbArdeJuHBUjBiI9XV61weN1GjquQfPhT
	 SQFgdrUUcWvGo2lmyAG++MLOquI+LU0+IN1+T/aJnj4inCsLhqKB2SCFX3Ve/8yJogmeN
	 axYfJzJnDHrNvA0W4rtrpXjrLcbhqenuEullyuljnaFL8LXNoVo7IU89OriVwPuKyvg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794336505;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=hZG2WcNP+L5BKUfSIbKIWESBdYZMCZqr7vvCmA6OjsM=;
	b=Pf2v0RhajDgCBBcbUx2IHrAGHiPdUKWt3Ys4TYekBYkWZ9aeSrE39g7orVagoEabhj61
	 IdBSovIuiB+67ud+mD/189ewG54l2PSdBkfJzPjZyK5vasekiOh2Tx1535KMSXMxZ1suZ
	 GOg0g0J55o7tIwZ+4qNfFwHacunK/DMOujTxldbfzwHUtKOurHivPK62IEYlG8E4wyccZ
	 XdJOz0nh+wITXQMQKfdUHJDvJzgpju3kCKf33a9aWQ3VE+suTgpOx+2uFjHI+c6pm2/MF
	 aXHe9qzDku8bGSrsl7rxaDA28y4Xd6F6WzQGQkmXC8yYGQ/ItbMT6bn4J/AlkdTOvzw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BJFLqA2N;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFC14606A326;
	Tue, 10 Nov 2026 18:48:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BJFLqA2N
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E7441F0089F;
	Tue, 10 Nov 2026 18:48:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794336504;
	bh=hZG2WcNP+L5BKUfSIbKIWESBdYZMCZqr7vvCmA6OjsM=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=BJFLqA2N4rCj+BM0fcpLs7gjwvcXi7S50mrKnKgDJjcm4Z+iPTsBjhXl8iaTE0GCq
	 LBhE2i6VpPPdTnWLiDi63E5B/N+JVHbJVYr3hh/xq2QmaznATtOjAh8gQ9BiegLRCs
	 xkjKdJKtcd3HxgmR6ISlk3w1+KX/HlmUjRKcsXGwxP4okl6mcWRu78dW6KGsQdot6K
	 zAgf+2mTf5pG0HVQrQYDdB08B43p/88Pj4t0S6vIpC16tXs1L/EJ9tD81+DZk3rrEH
	 njPZx0UClbucJAveLmlo3s7fmA5Ry3uyY0VmhWkA6kYLMkKL2mbIV7QA6AiXLuRUc3
	 1+tyv7/IbSAmw==
Date: Tue, 10 Nov 2026 10:48:22 -0800
From: Jakub Kicinski <kuba@kernel.org>
To: "Xin Tian" <tianx@yunsilicon.com>
Cc: "Andrew Lunn" <andrew+netdev@lunn.ch>, "David S. Miller"
 <davem@davemloft.net>, "Eric Dumazet" <edumazet@google.com>, "Paolo Abeni"
 <pabeni@redhat.com>, "Jason Gunthorpe" <jgg@ziepe.ca>, "Leon Romanovsky"
 <leon@kernel.org>, "Junxian Huang" <huangjunxian6@hisilicon.com>,
 <weihg@yunsilicon.com>, <linux-kernel@vger.kernel.org>,
 <netdev@vger.kernel.org>, <linux-rdma@vger.kernel.org>
Subject: Re: [PATCH v1 00/15] Yunsilicon XSC ethernet and RDMA drivers
Message-ID: <20261110104822.5d8a1a76@kernel.org>
In-Reply-To: <20261104155650.37053-1-tianx@yunsilicon.com>
References: <20261104155650.37053-1-tianx@yunsilicon.com>
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 04 Nov 2026 23:57:31 +0800 Xin Tian wrote:
> Subject: [PATCH v1 00/15] Yunsilicon XSC ethernet and RDMA drivers

This is way too big, initial driver should be minimal, maybe 6k LoC.
You may find these prompts helpful:
https://github.com/kuba-moo/ai-prompts/blob/main/driver-upstreaming-prompts.md

Each patch must build cleanly with W=1 C=1.
