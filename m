Received: from out-171.mta1.migadu.com (out-171.mta1.migadu.com [95.215.58.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3163E223DE9
	for <linux-rdma@vger.kernel.org>; Thu,  4 Jun 2026 01:42:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780537362; cv=none; b=QJnVaSB6usvaGM/ItP58zROw3J2q4JJsUSeJ3vDpcGw3qqPVZtT0HSUcceHvByTXkNxK8AJxOfhN4+3NnOBETIUaGFqmegso/ZGEszCp8LLhvjhpbPpuEGGqbWrH6qFFya5FqSCH+XMskdyT4q1Nc+ratusETX9JwLkAtBfMzUM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780537362; c=relaxed/simple;
	bh=AVhHcHEcbrrrOlWFJlSgo31BfjIcb8vqE+DpvG5a7QA=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=pgRlKdhZozHSaXAhAsgfrxA2h7J6jsErYALYhaiTSIrgPzX1o0PM3V3TxAxxd5Jd0pa6KfGcr50EEEjHdDn7qKO0+GZei4KuXxESy3xkdt2m9sjQv4r7wZb0QMAp1EUowFWrV+2VAWzp9Y2MSpaCsikdEI7ewQUMe731FIcDiuM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=w8FmZVln; arc=none smtp.client-ip=95.215.58.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="w8FmZVln"
Message-ID: <5b2f7b70-1e99-4934-8bef-7e8fe616fdf6@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1780537349;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=57nx9MVIYZiNwA+WjkRPD5MVNVMMqcjHbC9c/VMNG64=;
	b=w8FmZVlnk2ORAlZgkkKvnwmBUXAPMsuENzmPtKkV99FTyVJEwgtD9rcgPgJrRb4VTLdJIu
	kL82p7eSd+UUjAMWLGS6jb2VRwBQH7js+HFmk8zR6++5Yjzy/sB8rRMo2qGjDWIipsBfF6
	i0SlYDEq+FOYF47tL42DMgQATgecjtA=
Date: Wed, 3 Jun 2026 18:42:20 -0700
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH] RDMA/rxe: Fix use-after-free of netdev in
 smc_ib_port_event_work
To: Jordan Walters <jaggyaur@gmail.com>, linux-rdma@vger.kernel.org,
 linux-kernel@vger.kernel.org, "yanjun.zhu@linux.dev" <yanjun.zhu@linux.dev>
References: <20260603100919.268055-1-jaggyaur@gmail.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Zhu Yanjun <yanjun.zhu@linux.dev>
In-Reply-To: <20260603100919.268055-1-jaggyaur@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

在 2026/6/3 3:09, Jordan Walters 写道:
> rxe_net_del() drops its reference to the underlying net_device
> via dev_put() but does not clear the netdev pointer from the
> ib_device. This leaves a dangling pointer that the async
> smc_ib_port_event_work worker can dereference after the
> net_device has been freed, causing a use-after-free in
> __ethtool_get_link_ksettings().
> 
> An unprivileged user can trigger this via user namespaces
> by creating a dummy interface, binding it to rdma_rxe, and
> immediately destroying the namespace before the worker fires.
> 
> Clear the netdev pointer via ib_device_set_netdev() before
> releasing the reference. Downstream callers such as
> ib_get_eth_speed() already handle a NULL netdev safely.
> 
> Note: this is a distinct issue from the socket TOCTOU race
> fixed by Zhu Yanjun in [1]. That patch addresses a race on
> the pernet socket pointers (rxe_sk4/sk6) leading to a NULL
> deref in kernel_sock_shutdown(). This patch fixes a dangling
> netdev pointer leading to a UAF in
> __ethtool_get_link_ksettings via smc_ib_port_event_work.
> 
> Link: https://lore.kernel.org/all/20260519023541.8594-1-yanjun.zhu@linux.dev/ [1]

Thanks a lot. I am fine with this commit.
Although Sashiko complains about this commit, it seems that all the 
problems have already existed.

Reviewed-by: Zhu Yanjun <yanjun.zhu@linux.dev>

Zhu Yanjun

> 
> Signed-off-by: Jordan Walters <jaggyaur@gmail.com>
> ---
>   drivers/infiniband/sw/rxe/rxe_net.c | 1 +
>   1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/infiniband/sw/rxe/rxe_net.c b/drivers/infiniband/sw/rxe/rxe_net.c
> index 50a2cb5405e2..a8f91d6e3b17 100644
> --- a/drivers/infiniband/sw/rxe/rxe_net.c
> +++ b/drivers/infiniband/sw/rxe/rxe_net.c
> @@ -663,6 +663,7 @@ void rxe_net_del(struct ib_device *dev)
>   	if (sk)
>   		rxe_sock_put(sk, rxe_ns_pernet_set_sk6, net);
>   
> +	ib_device_set_netdev(dev, NULL, 1);
>   	dev_put(ndev);
>   }
>   

