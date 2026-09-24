Received: from mta0.migadu.com (out-55.mta0.migadu.com [91.218.175.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBE653B42C9
	for <linux-rdma@vger.kernel.org>; Thu, 24 Sep 2026 14:53:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790261635; cv=none; b=kCiEUwqCadSmXple/I7mYU4lsk99Jb8bBWmCw/58f/Z5rv/fPGRopobz7q8I5UzA+ujXZySoPUbyQP9VLn/EiPtYo4LTvF2lWEEmQQY3JH+/DHBRg4x2onESO6r+vGxZhl8S4Z6oRY85+F892IIVT58BkRU8Dxh9+irbAfOEiQQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790261635; c=relaxed/simple;
	bh=iIcGRfP6P86Ywvr29YhM4W1MLJTFsGJnEspBqA74s1E=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ni76ofFb00EtFtaB6dacvBPDV0hLQaRPe57o7CVtYpgXagjZMf2yjrtqNYqqoDWeI0l3R9yee9RB4e/lgXPQyVZjFBx/poOKjsI5IlHbGqGMOUMe0l2w3o7vk5sTbagK68vmzKpBq105rXbVkBIhpuny/0Amrxf5B0g0b/0bLB4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=xa/FcszZ; arc=none smtp.client-ip=91.218.175.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="xa/FcszZ"
X-Envelope-To: linux-rdma@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=iIcGRfP6P86Ywvr29YhM4W1MLJTFsGJnEspBqA74s1E=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790261628; v=1; x=1790866428;
 b=xa/FcszZ2FrjYaR2JAChf0hMaXE58f5qcqhPPFlxp9qnaxuXTprhga9BbRS9rgtmHIMoq3Ng
 Y9bPd82X/skiZh4cPBE/VUNGlGM85D5T1whlcaFDgjwOIk3J9YysfmptFIbkLYTTiIUViX/7efW
 r06JAH8CSx3JPF9bLRh2vs+c=
X-Envelope-To: linux-rdma@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 7a7253bf3aa492dc;
	Thu, 24 Sep 2026 14:53:48 +0000
X-Mizu-Trace-ID: 7a7253bf3aa492dc
X-Migadu-Flow: FLOW_OUT
Message-ID: <54fdf56c-c210-4a31-83e8-25d7a3dfd9b5@linux.dev>
Date: Thu, 24 Sep 2026 16:53:43 +0200
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] RDMA/siw: drop duplicate check_app_limited in
 siw_tcp_sendpages
To: Geliang Tang <geliang@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>,
 Leon Romanovsky <leon@kernel.org>
Cc: Geliang Tang <tanggeliang@kylinos.cn>, linux-rdma@vger.kernel.org
References: <32ef40cc81486adb8f2d43585224ab44d7e77f73.1790234916.git.tanggeliang@kylinos.cn>
From: Bernard Metzler <bernard.metzler@linux.dev>
In-Reply-To: <32ef40cc81486adb8f2d43585224ab44d7e77f73.1790234916.git.tanggeliang@kylinos.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 24.09.2026 09:39, Geliang Tang wrote:
> From: Geliang Tang <tanggeliang@kylinos.cn>
> 
> After do_tcp_sendpages() was converted to use MSG_SPLICE_PAGES and
> later inlined as direct tcp_sendmsg_locked() calls, callers that
> previously needed an explicit tcp_rate_check_app_limited(sk) to cover
> do_tcp_sendpages() no longer need it. tcp_sendmsg_locked() performs the
> check on every path that queues data, making the outer call redundant.
> 
> The site changed here, siw_tcp_sendpages() in siw_qp_tx.c, holds the socket
> lock and invokes tcp_sendmsg_locked() on every iteration. The early-return
> paths in tcp_sendmsg_locked() that skip tcp_rate_check_app_limited() - the
> MSG_ZEROCOPY allocation failure and MSG_FASTOPEN branches - return without
> queueing any MSG_SPLICE_PAGES data, so there is no functional consequence
> from omitting the outer check.
> 
> Signed-off-by: Geliang Tang <tanggeliang@kylinos.cn>
> ---
> Hi,
> 
> I'm Geliang from the MPTCP community. While developing "MPTCP sockmap" and
> "MPTCP KTLS", I found this duplicate check_app_limited issue. I recently
> submitted patches to remove it in BPF [1] and TLS [2], both of which have
> been accepted. I noticed the same duplicate check_app_limited also exists
> in siw_tcp_sendpages, so I'm sending this patch to remove it as well.
> 
> Thanks,
> -Geliang
> 
> [1]
> https://patchwork.kernel.org/project/netdevbpf/patch/1f7dc605b16fc0590f7cbf5a27d57271926c01ce.1790074764.git.tanggeliang@kylinos.cn/
> [2]
> https://patchwork.kernel.org/project/netdevbpf/patch/5bc803abb4e27054eaffc8b26db7812e6347b0dd.1789634247.git.tanggeliang@kylinos.cn/
> ---
>   drivers/infiniband/sw/siw/siw_qp_tx.c | 1 -
>   1 file changed, 1 deletion(-)
> 
> diff --git a/drivers/infiniband/sw/siw/siw_qp_tx.c b/drivers/infiniband/sw/siw/siw_qp_tx.c
> index f7dd32c6e5ba..56bd009879c2 100644
> --- a/drivers/infiniband/sw/siw/siw_qp_tx.c
> +++ b/drivers/infiniband/sw/siw/siw_qp_tx.c
> @@ -336,7 +336,6 @@ static int siw_tcp_sendpages(struct socket *s, struct page **page, int offset,
>   		if (size + offset <= PAGE_SIZE)
>   			msg.msg_flags &= ~MSG_MORE;
>   
> -		tcp_rate_check_app_limited(sk);
>   		if (!sendpage_ok(page[i]))
>   			msg.msg_flags &= ~MSG_SPLICE_PAGES;
>   		bvec_set_page(&bvec, page[i], bytes, offset);

Thank you Geliang, much appreciated.


Acked-by: Bernard Metzler <bernard.metzler@linux.dev>
