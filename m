Received: from out-170.mta1.migadu.com (out-170.mta1.migadu.com [95.215.58.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 820D1224AF1
	for <linux-rdma@vger.kernel.org>; Thu,  4 Jun 2026 03:06:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780542397; cv=none; b=KYns9YdRjHaWjTE4y4uC6ZHY6hL8QsTCiep/r2E6BlP3sUXvhxJAo2JHGBdB3yLODf28rgkoaB3rBVO4QsfhO4LY2O+oC1gz86YB2jOMHn+LuaHmy206t519EY0zumvSGy5XLjjuBE98QpPyQ7WhZyAIFbEFYPwCfHPY1AztFbM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780542397; c=relaxed/simple;
	bh=QPuVoflKdsiaqDzd3ZlNEFCPauwEewX5VY7fTtalMQM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=gqYEpZXUOMYTby3g/dlt4IvOtNQPTa8FvSoyl1DhUwho9ndQt6EVIMhH6lzfd6dTSrV0pCHpAC6ieMQYFZW5a4bzbxINE7NP5yNVIZOWTw6GP5CUmGL7oicXMt9DpQiJzUc9OzuKDPuopLN2Bl8+P5Rg8vNS64z2Etsy0SOlZnI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=W2cNAqxa; arc=none smtp.client-ip=95.215.58.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="W2cNAqxa"
Message-ID: <8269eca8-0ff5-43ae-b3ef-04cfde67882c@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1780542393;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=LmZqS52HgaEyWPt+CCvZthmz6nFexCR5JlPdVyY2C0M=;
	b=W2cNAqxaH0COvxU3F5HpddtjWC8k8Tr/MvDGy7D9TTTRvUMHh28n41j0AYKwCLc+t0d92T
	ot8gWZkSLNo2ldH8mI+Ya57ACwyLtZpivIFnt8ZypOoQ7EtArMDlVvU0gDfi3SdKMfwrme
	YYtF3Ba0++abcBvBhSS4GygTTxhTp2Y=
Date: Wed, 3 Jun 2026 20:06:27 -0700
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH v2 1/1] RDMA/rxe: Fix Use-After-Free problem in
 rxe_net_del
To: Jason Gunthorpe <jgg@nvidia.com>,
 "yanjun.zhu@linux.dev" <yanjun.zhu@linux.dev>
Cc: zyjzyj2000@gmail.com, leon@kernel.org, linux-rdma@vger.kernel.org,
 syzbot+d8f76778263ab65c2b21@syzkaller.appspotmail.com
References: <20260519023541.8594-1-yanjun.zhu@linux.dev>
 <20260603012532.GA1188713@nvidia.com>
 <3cdac159-4c61-448c-8327-d39ac0f87fe3@linux.dev>
 <20260603162537.GD1170766@nvidia.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Zhu Yanjun <yanjun.zhu@linux.dev>
In-Reply-To: <20260603162537.GD1170766@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

在 2026/6/3 9:25, Jason Gunthorpe 写道:
> On Wed, Jun 03, 2026 at 08:43:31AM -0700, Zhu Yanjun wrote:
>>
>> 在 2026/6/2 18:25, Jason Gunthorpe 写道:
>>> On Tue, May 19, 2026 at 04:35:41AM +0200, Zhu Yanjun wrote:
>>>
>>>> index 50a2cb5405e2..0bf5b0eabc7b 100644
>>>> --- a/drivers/infiniband/sw/rxe/rxe_net.c
>>>> +++ b/drivers/infiniband/sw/rxe/rxe_net.c
>>>> @@ -135,13 +135,21 @@ static struct dst_entry *rxe_find_route6(struct rxe_qp *qp,
>>>>    {
>>>>    	struct dst_entry *ndst;
>>>>    	struct flowi6 fl6 = {};
>>>> +	struct sock *sk;
>>>>    	fl6.flowi6_oif = ndev->ifindex;
>>>>    	memcpy(&fl6.saddr, saddr, sizeof(*saddr));
>>>>    	memcpy(&fl6.daddr, daddr, sizeof(*daddr));
>>>>    	fl6.flowi6_proto = IPPROTO_UDP;
>>>> -	ndst = ip6_dst_lookup_flow(net, rxe_ns_pernet_sk6(net), &fl6, NULL);
>>>> +	rxe_ns_lock(net);
>>>> +	sk = rxe_ns_pernet_sk6(net);
>>>> +	if (sk)
>>>> +		sock_hold(sk);
>>>> +	rxe_ns_unlock(net);
>>>> +
>>>> +	ndst = ip6_dst_lookup_flow(net, sk, &fl6, NULL);
>>>> +	sock_put(sk);
>>> Sashiko says this crashes when sk is null, which it can be.
>>>
>>> But this really seems weird, the rxe can be in only one namespace, why
>>> not reach the listening sks associated with the ib_dev through
>>> qp->pd->dev and not do net lookups?
>>>
>>> I would expect net lookups to only exist in the add/del link paths?
>>
>> Thanks a lot. I will send out the new patch, following your advice.
> 
> I was thinking later I don't really know what rxe did here and normal
> rdma core code has multiple namespace flow. IIRC the namespace
> flows from the selected GID entry and the namespace mode selects how
> gid entries are created from namespaces.
> 
> So this still looks quite odd, by the time we get to RXE we should
> have already locked down a source gid entry and that should be where
> the sk really comes from??

You are exactly right on the architecture. Conceptually, the namespace 
and socket context should be strictly locked down via the source GID 
entry by the time we hit the provider routing path.

However, RXE currently relies on an internal, dummy kernel socket 
created per-netns to pass into ip6_dst_lookup_flow(). The 
rxe_ns_pernet_sk6(net) helper fetches this global socket on the fly.

This patch is a localized, tactical fix for an active Use-After-Free 
(UAF) crash. Without it, a concurrent container/netns teardown can free 
that dummy socket right in the middle of ip6_dst_lookup_flow(). The 
rxe_ns_lock and sock_hold() are just there to pin the socket's lifetime 
during the routing call.

I agree that structurally aligning RXE to derive/pin this context 
directly from the GID entry lifecycle would be the cleaner, long-term 
fix. For now, this patch unblocks the immediate crash.

Zhu Yanjun

> 
> Jason

