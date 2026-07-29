Received: from out-188.mta0.migadu.com (out-188.mta0.migadu.com [91.218.175.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D779A1DFFD
	for <linux-rdma@vger.kernel.org>; Wed, 29 Jul 2026 03:21:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785295292; cv=none; b=kWGKcbkEGWh/baiLVgIos6cDAdxvP+4ufQ42VvCiYtEvWq37BcCCfPJkJ3G7aKhi00fObmjc/BGL9NV7EEjwZqA0KuGLSMuLLhG4q9Xath1Bu5MsGBX+KT4M8zstSax6WhH9B4B2WBXnB9Rnu2SjyGhXpCj3wYqh2KmFNydTDhs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785295292; c=relaxed/simple;
	bh=P+AiosRHc/ZNdkGT3maMniIa4z4l/QNvhWwjWi0s5sI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Orobe59wg9YXJTgOPY8NgN/Ill5UW3Lgplj+pC+6cKCXrPK8X2qfpLeXILGjLfNltL7Kv8z9xyQwBjtje8neC37dFt2hayERROX5ozzUhEWDt6/DfkgJ6aTuPSg5sPeft+jZEFImkhtdl8wDtOgxpgWYTynkDHoVzfCidYfcuW8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=rkQoecOP; arc=none smtp.client-ip=91.218.175.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="rkQoecOP"
Message-ID: <0bcef700-e148-46f3-93b9-c5fda5323aa1@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785295287;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=OnAHw6UuSiLQk5/w/BXHTeKkW/7icrd7IbgaF/P6Wxo=;
	b=rkQoecOPs+1/c5fH/VzXcOr8RaW8RHSmNsetgjAJBSE0uSM0K5NqSF8h/m2KFmP3vJRz6d
	WBwwZVyzRP+SMpeT9OCazlckJbWQCG3lqZtDz7dP0y7NEEHkU0cX3ZTOBdBXgsaIglfPPg
	j19BDR9LhlRd2naT3X4roDJinmFKcos=
Date: Tue, 28 Jul 2026 20:21:19 -0700
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [RFC PATCH 1/2] RDMA/rxe: drive UDP tunnel socket lifetime from
 the GID table
To: Serhat Kumral <serhatkumral1@gmail.com>,
 "yanjun.zhu@linux.dev" <yanjun.zhu@linux.dev>
Cc: mounter625@163.com, zyjzyj2000@gmail.com, xiongwm2026@163.com,
 jgg@ziepe.ca, leon@kernel.org, dsahern@kernel.org,
 linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
 syzbot+8c9eede336e3a843750e@syzkaller.appspotmail.com
References: <c225c004-1fa9-4010-a843-8be033003e93@163.com>
 <20260728172825.43978-1-serhatkumral1@gmail.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Zhu Yanjun <yanjun.zhu@linux.dev>
In-Reply-To: <20260728172825.43978-1-serhatkumral1@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

在 2026/7/28 10:28, Serhat Kumral 写道:
> The crash reproduces here now, and it does not come from this series.
> 
> The tree in that git diff carries v2 of "RDMA/rxe: Hold netdev reference
> for transmit skbs", not the v3 I was pointed at. The pre-image blob of
> rxe_net.c in the diff is 44a16cb1601a, and on f2ec6312bf71:
> 
>    v2 applied -> rxe_net.c 44a16cb1601a
>    v3 applied -> rxe_net.c 86c9b19f65e1
> 
> v2 alone, without this series, crashes on the first run of
> rxe_rping_between_netns.sh:
> 
>    [   67.227061] Oops: general protection fault, probably for
>      non-canonical address 0xdffffc0000000000: 0000 [#1] SMP KASAN NOPTI
>    [   67.231014] KASAN: null-ptr-deref in range
>      [0x0000000000000000-0x0000000000000007]
>    [   67.240200] Workqueue: rxe_wq do_work [rdma_rxe]
>    [   67.241906] RIP: 0010:ip_rcv+0xeb/0x570
> 
> Same fault, same RIP, same Code bytes and same call trace as the oops
> reported in this thread, down to process_backlog+0x341/0x1110 and
> net_rx_action+0x87e/0xe00.
> 
> Runs of rxe_rping_between_netns.sh on f2ec6312bf71:
> 
>    f2ec6312bf71                 120/120
>    + this series                120/120
>    + v3                         120/120
>    + v3 + this series           220/220
>    + v2                         crash on run 1
>    + v2 + this series           crash on run 1
> 
> The mechanism is the one the v3 changelog describes. v2 releases the
> netdev through the live skb->dev and then clears it,
> 
>    if (skb->dev) {
>      dev_put(skb->dev);
>      skb->dev = NULL;
>    }
> 
> but skb->dev has already been rewritten by the transmit path, so the put
> lands on the wrong device and the receive side can find skb->dev == NULL.
> v3 keeps the held netdev in skb_shinfo(skb)->destructor_arg and never
> touches skb->dev.

Hi Serhat,

Thanks for the detailed analysis and testing.

I removed this patch from my tree, and the crash no longer reproduces. 
This confirms that the regression comes from the v2 version of 
"RDMA/rxe: Hold netdev reference for transmit skbs", not from this series.

The root cause analysis looks correct. Since skb->dev can be modified 
during the transmit path, using it to store the held netdev reference 
can result in releasing the wrong device reference. The v3 approach of 
storing the reference in skb_shinfo(skb)->destructor_arg avoids this issue.

I will take a closer look at the related code paths and continue the review.

Thanks again for the help.

Best regards,
Yanjun

> 
> So v3 is the one to carry. Nothing here points at the socket lifetime
> change.
> 
> thanks,
> serhat

