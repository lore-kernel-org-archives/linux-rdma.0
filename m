Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=212.27.60.169
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794735033;
	b=dYNuGG3MLPa6pO5LC//o1T9uVTciEP6fpp8BxdBA7Pb38Plg5VMJ4LPPOOE4Txcv4UPD
	 YSjalIxfAg7od+jJEu7U6RWBWPnBKdVEYcMVTp1r+u8v42YzGWHXdZFWjp+yxDnkiFoUE
	 bTqKuYGPGoZ7uJ7HYSPUYJ+GT8KiNMrGhJDtxnYIDjnaJ7ZBFpO176/dVNmGkJJdtjIW2
	 jgdBbNuFipnkJMythDdNgCXYBsLiciuefQtv9ZSg8eZITV+SnDLGDJCMLUveqoIzVJGrV
	 Cj1xCo//9bbcgZiIXmhCkDHf7Z9zqGdJi+GiqMEodJm6ZvEEb0zXPTON4onphCO59Ew==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794735033;
	h=DMARC-Filter:DKIM-Signature:Received:Message-ID:Date:MIME-Version:
	 User-Agent:Subject:To:Cc:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding;
	bh=BrpBf50Shuz5gnHmrmk51CMXzOUhCrMyBZdF/LZhFnU=;
	b=19ljfOcUeKDDXGlsEgnq8AuI9Ud4oEieIBRVGAeiXKgX1hEZO9CmjygIBru06Sg31cQW
	 CLI0IQiTm7/HFMhd8qhRUw8CQPo0J8piB0I38dyydAHNzsG8r2/11CjYBJaefV2yoaLwX
	 /XYbMxGUSXUceekIRdGEnTFw6hVxekfgKwI0Pfn8lh7U7vWI1rQygvCxgAYvZUW8NC+0k
	 34DeGyL3nQqRtyvnz9sxbSYo2Cva8DT5+kO1jHapvrDRm9SwUBzey/rBYxpG+fd/ciNZI
	 ILazcbzQxhcIwJBHUdtrtfADO4ZaAc31ZhKMs2uvVSbi/zLmaK6uVENTmn1j3+KEzpA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=corp.free.fr;
	spf=pass smtp.mailfrom=corp.free.fr;
	dkim=pass header.d=corp.free.fr header.i=@corp.free.fr header.a=rsa-sha256 header.s=rcs header.b=o3C3wEyP;
	arc=none smtp.remote-ip=212.27.60.169
Received: from rcs.proxad.net (rcs.proxad.net [212.27.60.169])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EB4C606A31D;
	Sun, 15 Nov 2026 09:30:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7EB4C606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=corp.free.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=corp.free.fr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=corp.free.fr header.i=@corp.free.fr header.a=rsa-sha256 header.s=rcs header.b=o3C3wEyP
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=corp.free.fr; s=rcs;
	t=1794735030; bh=/5S/eb2wxut2mjDcbc5EKBu4fo1WIXqEBAbkUVf7T0Q=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=o3C3wEyPYsMEhWvH/BhEZteDVVXh6vcLc+aFLzmCNklvPpp6jEDrMzRCLA+iS5oJS
	 ku356AqmcjXVENVXX1ydmfTRE4PH7FOMrmRu0jbch2kU0jQZbPld5+dGhIKrAlN/uN
	 SPyJTsAkgO0U4YhFwzRv7qrBCUkZ052zauTFVNORTOUCh251KvRwqml88wRIijuGB+
	 hEmAlTLGt7rg8fNOQhlxZAQvXOn9fWfmsdqd9OFEYvDdzpurzeRVFznvtV064RDD/B
	 Ds9ZLsIQ4jHdy+sSaNMhFXI4PDqsdQZKDxkRGbc1wR5B8tfH6eWBskeaqJsilX/QCS
	 Mq9w4wHVWa0sQ==
Received: from [0.0.0.0] (unknown [213.228.1.188])
	by rcs.proxad.net (Postfix) with ESMTPSA id BDBD044C068A;
	Sun, 15 Nov 2026 10:30:28 +0100 (CET)
Message-ID: <5c2301d9-d62a-49f7-9d0b-87a7c254a514@corp.free.fr>
Date: Sun, 15 Nov 2026 10:30:28 +0100
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
Subject: Re: [PATCH net-next 08/10] net/mlx5e: TC, offload RX queue mapping in
 NIC flows
To: netdev-bot+sashiko@kernel.org
Cc: saeedm@nvidia.com, leon@kernel.org, tariqt@nvidia.com, mbloch@nvidia.com,
 jhs@mojatatu.com, jiri@resnulli.us, andrew+netdev@lunn.ch,
 davem@davemloft.net, edumazet@kernel.org, kuba@kernel.org,
 pabeni@redhat.com, horms@kernel.org, michael.chan@broadcom.com,
 pavan.chebbi@broadcom.com, bharat@chelsio.com, donald.hunter@gmail.com,
 corbet@lwn.net, skhan@linuxfoundation.org, rdunlap@infradead.org,
 dsahern@kernel.org, idosch@nvidia.com, shuah@kernel.org,
 netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
 linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org,
 oss-drivers@corigine.com
References: <20261109131039.959438-9-acassen@corp.free.fr>
 <179442433199.2199510.1112413550328435081@kernel.org>
Content-Language: en-US
From: Alexandre Cassen <acassen@corp.free.fr>
In-Reply-To: <179442433199.2199510.1112413550328435081@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 11/11/26 20:12, netdev-bot+sashiko@kernel.org wrote:
> [Severity: Medium]
> 
> Does this guard catch every earlier terminating action whose destination
> the direct TIR would override? It only checks attr->dest_chain on the
> current attr and the HAIRPIN flag.

No. v2 refuses the action after any terminating action, ok included.



> [Severity: Low]
> 
> Is this read of priv->channels.params.num_channels meant to be lockless?

Yes


> Should this read use READ_ONCE(), or should the check take
> priv->state_lock?
Neither. The channel count can change right after the check, with or 
without the lock. The commit message covers that case, the rule always 
points to a valid TIR. READ_ONCE() alone wouldn't quiet KCSAN either, 
because the writer copies the whole struct.

