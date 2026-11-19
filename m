Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.90
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795057563;
	b=bBJrJ/C3FAPOyz6XB6UqSSjkpCpPtnj+688PeB5GJppu3TK6vFdqXRbvF3J1XVW80uhy
	 bd7Je9Xg/JVHWKlyTKSxuyNuDQpEi6egeHzwShRd65B2x0oPxKKujW3cgHfFQ7WbhWOaB
	 waGevBTkUq+Eyuh1lUdhozRdgUpjlCgP6x82TTHxgWkfDUMkvGVnNw3qhMqkAEe7CbU4y
	 qV70sLz54O/5ffjM317TVN3hcNwCp7g1GeZGiOR+BC6ciNtB/PPLYhmpuF6YtgzFQ4rRZ
	 66VV2a5NV6c2p9CeXWlsnFTxXVelvdJEcdg8AOYhsZbi2mpNfgCkh0a0N8uL+G86Spw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795057563;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Message-ID:Date:MIME-Version:User-Agent:
	 Subject:To:Cc:References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=1nQ8YaDGbdbSQt97QgB7GPkOItZkKsKE3rzuGdpJu68=;
	b=WkQ/4tK0eY2Ouj6OWgpcbuaNUTB8tos4OJoEtA7kgAsUZV65BqpfaWVkel/b7TM6eU+A
	 inesY8WPWnA9k93qiIAV47ZxORK4Y0XCPbu/s9DuyIuzGXmP9FBdEyyvVLCKXCLYJt+PS
	 Pf06aO0hQ55qzdg4RupFMOCT2ZXLBn9awnhHV0KzIK80kaKAK6K6+REzHh57luG2NmYWy
	 UstX4lOufebeIl2LixRbFy2wrVRfYqFtO1izL32BPoYfaBedqpKHeE9LRbeVVPu9eIQDy
	 SM9OajbGK83amwsK6OdZK8TbPVAbDwMZ99YLxzKKvks0YtUgmukfgc2mBjsT4CBMhsQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b="aj/17xhI";
	arc=none smtp.remote-ip=95.215.58.90
Received: from mta1.migadu.com (out-90.mta1.migadu.com [95.215.58.90])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A5B2606A31C
	for <linux-rdma@vger.kernel.org>; Thu, 19 Nov 2026 03:06:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3A5B2606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=aj/17xhI
X-Envelope-To: linux-rdma@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=Ysl+OVqX7d+ztep9qyZyfXqOyAiRMAJ0DrG8uvKUQMk=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795057561; v=1; x=1795662361;
 b=aj/17xhIXphCEjqilT+2cb1FVryRHUM/0lHNhL9SjhGoP4XWnq6luQ47Z9W5AhPIhthQIhGz
 I9BOXHw7O9F0u0oTzTeZr9pr+lh0UHb9CmptH5iJvhClOMivrkR7+FZoVo3n3joNisiRnsH4qWF
 1fy/3glAaG1+cwoCdFNhH/IQ=
X-Envelope-To: linux-rdma@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 3b965933bbe9266c;
	Thu, 19 Nov 2026 03:06:00 +0000
X-Mizu-Trace-ID: 3b965933bbe9266c
X-Migadu-Flow: FLOW_OUT
Message-ID: <f5d63d01-8805-4445-990b-24cd7b495796@linux.dev>
Date: Thu, 19 Nov 2026 12:05:48 +0900
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
Subject: Re: [PATCH net-next v1] net/mlx5e: TX, Do not open a multi-packet WQE
 for a single packet
To: Tariq Toukan <tariqt@nvidia.com>
Cc: saeedm@nvidia.com, leon@kernel.org, mbloch@nvidia.com,
 andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@kernel.org,
 kuba@kernel.org, pabeni@redhat.com, linux-rdma@vger.kernel.org,
 linux-kernel@vger.kernel.org, Xuanqiang Luo <luoxuanqiang@kylinos.cn>,
 netdev@vger.kernel.org
References: <20261117085036.3138779-1-xuanqiang.luo@linux.dev>
 <773ac747-b58b-45eb-8072-8f048da3c54f@nvidia.com>
From: Xuanqiang Luo <xuanqiang.luo@linux.dev>
In-Reply-To: <773ac747-b58b-45eb-8072-8f048da3c54f@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 2026/11/18 at 20:14 Tariq Toukan wrote:
> 
> 
> On 17/11/2026 10:50, Xuanqiang Luo wrote:
>> From: Xuanqiang Luo <luoxuanqiang@kylinos.cn>
>>
> 
> [...]
> 
>> @@ -678,11 +679,13 @@ netdev_tx_t mlx5e_xmit(struct sk_buff *skb, 
>> struct net_device *dev)
>>       mlx5e_sq_xmit_prepare(sq, skb, &accel, &attr);
>>       if (test_bit(MLX5E_SQ_STATE_MPWQE, &sq->state)) {
>> -        if (mlx5e_tx_skb_supports_mpwqe(skb, &attr)) {
>> +        /* An MPWQE for a lone packet saves nothing, use a regular 
>> WQE. */
>> +        if (mlx5e_tx_skb_supports_mpwqe(skb, &attr) &&
>> +            (xmit_more || mlx5e_tx_mpwqe_session_is_active(sq))) {
> 
> I'd swap the two conditions:
> 
>      if ((xmit_more || mlx5e_tx_mpwqe_session_is_active(sq)) &&
>          mlx5e_tx_skb_supports_mpwqe(skb, &attr)) {
> 
> A lone packet, which is the case you optimize, then skips the skb 
> checks, and it reads in the natural order: is there a batch to join, and 
> can this skb join it.
> 

Makes sense, thanks for the suggestion. I will swap the conditions in v2.

> Also, it's be nice if you could test for traffic that goes through the 
> stack, for example UDP_RR / TCP_RR and a UDP stream with netperf, in 
> addition to pktgen.

I will run the tests again with the new code, including the ones you
mentioned.

Thanks!
Xuanqiang
