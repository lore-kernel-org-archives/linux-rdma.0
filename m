Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795198443;
	b=kLtRWXbdMWZfMmQwT0K6HZ50oPJs3anxaxpamyF/nrwhH2vclby96d9RwtlLPtlqm4TI
	 XIPtYlCigyLMLRIXptmroNVwKvKfyZQO+MWANonj3dyNYh2tu7AXeRuCznhAmKLi/1X+j
	 IoQYNc44ixAEK3KG49M6b9upyfrVr7lOUdWFqrKCjjsnlCXvAWeCd7xvaSITykcHRoAt1
	 o+BGH4HHvn0eRXz7/RFkoX4I/SSyk02IVomKaB97es67yBV5aoTzy9RI9V26Z2GES50jI
	 Iff2mW8oaj2mraJOpg/B/DIafX/WL3Fxlz8+rjR0dfGK902owU2i9pIsXanALY56PBg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795198443;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=DcwRzEeD46myz9Fmt8Eed/ljFm/hXw/AXj1bwn9CAlg=;
	b=hWKxTg2EGedJHvf+DkEHBWAyv4MhccDpCGaySRvovHIO9fXkKT4cKu/NG8MhF8I5J+uH
	 adfybXxqWj01ouZ2pfuVcx7ICh75KUORhcdDjih4b6dr2HHbE8WQoQZwfR07qOb6QrAps
	 Aq6BYe6VXt05aID3tzz4UczdolYNx1AGXjc2X8p4ZozMHxTGybFys29zsexxXvBBa7nf7
	 J0oedJICbKTLGc8AbfMiVKISWIry8ZihR5MbL3cEPfrfFMSW+pu6W8VK3Oqg7zPEtrqSj
	 gQLBplPs5qOKJEzOaB9IoSDYjHrwQuPCoNweXaH+qpi2J9yHGNaPOpqxMUA3mjY+ifA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=m6Qpl2wp;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7D49606C6D5;
	Fri, 20 Nov 2026 18:14:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=m6Qpl2wp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4ADC1F01576;
	Fri, 20 Nov 2026 18:14:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795198443;
	bh=DcwRzEeD46myz9Fmt8Eed/ljFm/hXw/AXj1bwn9CAlg=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=m6Qpl2wpDCNuq6MpMatGeD+57diXvt2gofBu0L5cIXnFYeUsy1gfoldTufmKQRv3f
	 mLDOfSilHnbTmrzd7beW2RLqAnOJglQvIl/4LDpLsBQVKsgB+fWcSPUWtAO3esy+2K
	 rARwnHlchx5yW6CCYk/OsVAN1avIf5coIqhrdaeBu56afKJS71Womm0Uvgy7ii3H5L
	 OgYKi9ezrDy8NjqwBuMToW/8H+CtJFljKx1w7opVsQPRHwLgIez8zfeJXTZUzATv3e
	 XhDm0nOxXLoxYD+r7ZBhaXGJ2sE4FORUlVOzaSBi2nMqWk9gcyGhTp0hJtgPRxaS8a
	 ccapIsXYhKgIA==
Date: Fri, 20 Nov 2026 10:14:02 -0800
From: Jakub Kicinski <kuba@kernel.org>
To: Dragos Tatulea <dtatulea@nvidia.com>
Cc: Tariq Toukan <tariqt@nvidia.com>, Andrew Lunn <andrew+netdev@lunn.ch>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet
 <edumazet@kernel.org>, netdev@vger.kernel.org, Paolo Abeni
 <pabeni@redhat.com>, Bobby Eshleman <bobbyeshleman@meta.com>, Carolina
 Jubran <cjubran@nvidia.com>, Cosmin Ratiu <cratiu@nvidia.com>, Daniel
 Borkmann <daniel@iogearbox.net>, David Wei <dw@davidwei.uk>, Erfan
 Sharafzadeh <erfansh@meta.com>, Gal Pressman <gal@nvidia.com>, Jacob Keller
 <Jacob.e.keller@intel.com>, Kaifeng Wang <kaifengw@google.com>, Leon
 Romanovsky <leon@kernel.org>, open list <linux-kernel@vger.kernel.org>,
 linux-rdma@vger.kernel.org, Mark Bloch <mbloch@nvidia.com>, Matt Fleming
 <mfleming@cloudflare.com>, Mina Almasry <almasrymina@google.com>, Nikolay
 Aleksandrov <razor@blackwall.org>, Saeed Mahameed <saeedm@nvidia.com>,
 Simon Horman <horms@kernel.org>, Stanislav Fomichev <sdf@fomichev.me>,
 Stanislav Fomichev <sdf.kernel@gmail.com>, William Tu <witu@nvidia.com>
Subject: Re: [PATCH net-next V2 00/13] net/mlx5e: Add netdev support for
 data direct
Message-ID: <20261120101402.44f66da2@kernel.org>
In-Reply-To: <b5305251-b758-45cf-a28d-406b04d8bccd@nvidia.com>
References: <20261110183826.2927274-1-tariqt@nvidia.com>
	<b5305251-b758-45cf-a28d-406b04d8bccd@nvidia.com>
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

On Fri, 20 Nov 2026 15:39:21 +0100 Dragos Tatulea wrote:
> While working on V3 I realized that keeping the core part in
> this series is not the best approach. Initially it made sense
> because the change was small.
> 
> I think I should re-spin it in a separate series with netdevsim
> based selftests for the new APIs. I would base it on Mina's devmem
> leased queues unregister [1].
> 
> Any reason not to?

Hard no, please read the netdev maintainers profile. netdevsim is not
a sufficient consumer to merge an API.
