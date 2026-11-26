Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=212.27.60.169
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795700600;
	b=Az46wLoMB9IdWX2opzw+dPXwu3uaK9HdltEDGMASPTudxcTUmvn3MJOTY7y3HIfrRNpI
	 97oEIZXP4GVAzNlFG/5bqvEO/tLOiE0A+YWhTbNjhKX6ZENhmGOR3jXd9eD/+Fyvl+OwM
	 WqbvF8tz8Z2cUIO4RhiGT0x2CaHMHsfDtfKIXwI3RIsjUuMwsen76r/9mBFIveyV1UUpL
	 mYDWDpDfm5y6Lqw+fcqY8dp2HqBFvCeJI/ylSe5cVbKY4Y5ZKiR7lkN9Af+N/WEd9Nfs7
	 e9mJb5gARKjbCPRI+Z5PuPlhr8m/4zM5bQoPpYWbv3+dCOu9PNVn3IiB9PN/tA6I5Vg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795700600;
	h=DMARC-Filter:DKIM-Signature:Received:Message-ID:Date:MIME-Version:
	 User-Agent:Subject:To:Cc:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding;
	bh=ko4eL4z4K6V3lb/3C7dqqajHBKs8W+KA+MAk4fHSYBk=;
	b=KiJU3PGBZqS22Xjh79Wn9jHGY5DvvWbsU8dc0y7viRQX4s4NpBDaPBwgNMLxdjVykqUv
	 OaiqZwdaGpabqi2igXI4xlDFuZKDDbCzQ8jcIWEdy9c3yHaz5Ene//kFHMF49I+xdAPgM
	 5o9/5vPe0ss9By3B3J/WzOAgumqG1+eBiAfdOt1DylGKssKpX4930HfGdqioSm3iqpLmq
	 xH8d9ruj7rGGxlwOg7SCTOekkvrokCZpkuHjw8cA/IN/Yr68e1mF6y/GaG0FlQlWGIuVK
	 Zihkq7RhvC2XKu8S6ikauKqLMdlvoGTYE4pnafNBoMINrbqNVdbGvVviZ43RfPv2tZA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=corp.free.fr;
	spf=pass smtp.mailfrom=corp.free.fr;
	dkim=pass header.d=corp.free.fr header.i=@corp.free.fr header.a=rsa-sha256 header.s=rcs header.b=SH7PBekn;
	arc=none smtp.remote-ip=212.27.60.169
Received: from rcs.proxad.net (rcs.proxad.net [212.27.60.169])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A261606A31C;
	Thu, 26 Nov 2026 13:43:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0A261606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=corp.free.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=corp.free.fr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=corp.free.fr header.i=@corp.free.fr header.a=rsa-sha256 header.s=rcs header.b=SH7PBekn
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=corp.free.fr; s=rcs;
	t=1795700590; bh=Ru+TyEI2Iupe+FdyreM1ZguqMa4aXugpSK2X1PFjJ3M=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=SH7PBeknUlBS+Ko3TQRwaap3XHmzEB/MeBQW/HN6w6bUpjw67MJLZvURDtbHYG1C1
	 WwKRadD1dZSjfkjOWwqlGzsmgkGAxIiU5aT7NyNE6mxTOwnG2VD2a13oIC38VBFs2D
	 jHY9qhDDo67hlYzC7M5Wb0LmY84iJRLMlZBQRSwtiSlQHlaIzMT7YrwPbbIt4araBL
	 8UR+H0Ag4ltugh0+YFVvhmZYbc9OzXai1ioACygfh+vXDZ+rZa6YxgFSTh0rEalBcW
	 GqEKokbJDejQ3pdF3O0RLYObZ8B6lWC2bBft8UyKgZYfqVUmC2kjDXOtYY+gj4dKaC
	 T5cXTxh9t/YZQ==
Received: from [0.0.0.0] (unknown [213.228.1.188])
	by rcs.proxad.net (Postfix) with ESMTPSA id 512E444C025D;
	Thu, 26 Nov 2026 14:43:09 +0100 (CET)
Message-ID: <c3f3dd4c-5dfa-4fb0-9a64-016192be5782@corp.free.fr>
Date: Thu, 26 Nov 2026 14:43:08 +0100
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
Subject: Re: [PATCH net-next v2] net/mlx5e: Prefetch the packet a few strides
 ahead in the linear MPWQE path
To: Antonio Quartulli <antonio@mandelbit.com>, netdev@vger.kernel.org
Cc: saeedm@nvidia.com, tariqt@nvidia.com, mbloch@nvidia.com, leon@kernel.org,
 dtatulea@nvidia.com, cratiu@nvidia.com, andrew+netdev@lunn.ch,
 davem@davemloft.net, edumazet@kernel.org, kuba@kernel.org,
 pabeni@redhat.com, ast@kernel.org, daniel@iogearbox.net, hawk@kernel.org,
 john.fastabend@gmail.com, sdf@fomichev.me, linux-rdma@vger.kernel.org,
 bpf@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20261104195241.1883539-1-antonio@mandelbit.com>
Content-Language: en-US
From: Alexandre Cassen <acassen@corp.free.fr>
In-Reply-To: <20261104195241.1883539-1-antonio@mandelbit.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Antonio, Dragos,

On 11/4/26 20:52, Antonio Quartulli wrote:
 > numbers from DDIO/SDCI systems and CX-6/CX-7 would be welcome.

we are running perf tests over our 5G UPF code (pure XDP with mlx5), 
just get your patch and test it over our stuff.

use-case here is GTP-U encap, I tweaked your patch to fit tunneling 
use-case around the net_prefetch() to add 128 bytes more.

setup is Xeon Gold 6342 (DDIO) wiht ConnectX-7 (fw 28.48.1000): 2 ports 
x 8 queues. 5G UPF in XDP (GTP-U and MAP-E, ~3200 insns per packet, 
XDP_TX only) with 100k sessions running live mobile network traffic 
pattern. Mpps per port with the 16 cores busy:

                                   base      v2    v2+256B
   RQ just opened                  10.55    10.85   >11.10
   RQ after a burst                 9.96    10.82    10.95
   L1 stride prefetcher off         9.85    10.72    10.84


With DDIO the gain depends on the history of the RQ. Under XDP a stride
is a page. While the pages of a WQE are adjacent the L1 stride
prefetcher fetches the next packet by itself. Once XDP_TX completions 
overflow the page pool cache then pages come back shuffled where the 
vanilla driver loses 5%.


 > +	head_offset &= (1 << rq->mpwqe.page_shift) - 1;

cosmetics: BIT(rq->mpwqe.page_shift) - 1


 > +	net_prefetch(va + rq->buff.headroom);

For our tunneling use-case I just added:

+       net_prefetch(va + rq->buff.headroom + 128);


I will run production with your patch with the +128 for our stuff... 
thanks for that !


cheers,
Alexandre

