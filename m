Received: from out30-112.freemail.mail.aliyun.com (out30-112.freemail.mail.aliyun.com [115.124.30.112])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 428063043C8;
	Tue, 16 Jun 2026 09:30:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.112
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781602216; cv=none; b=s9MDrc6jUX9k9qRHpJVZzqbWDN47Tcm0kCDohqgZxuQ+4HzcWZPUXfaQ8HdIFQSc1MOG9WQkTPVFtWXLCXnce5qDRnKHDvI3nlAAKobUE3W8110RKUbJljcxZ7mFlKlk/WFeiZ/2+o4iT+qqpzCTsYCTjZXTOUhADrfZRJmUNrs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781602216; c=relaxed/simple;
	bh=BZd1+7kFgWteNht00h5YxHdkTi83EI5MB+Ho523Bqnk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Sj7B0JPJ3ShqaG2+yxQbklWbkEfGS6WvJU2/+N7yLyBUKOr7osWqEPP3X6a9EE56XG1E7wqvKMfh3LCqjZMAAj8qtHXU3AJ3n/IOLIJvYI0+H6OY2IbqEyTDvm2HZGng3Ej0M54d3nyt7ZxQn8UcMtt9Btnn/8tI8pFQWCkG3jg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=TW7cUI5N; arc=none smtp.client-ip=115.124.30.112
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="TW7cUI5N"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1781602205; h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type;
	bh=081T06/+yJZlOpVrqr9xmO+pHUgrPiz3emTfwHp8+wc=;
	b=TW7cUI5N1kG5CSyANNG2gMx2Bfr9mCgrjynH9crlZJKA+WtJHwDkGR+UweGq8Rqei32w2fwFu2cJ4xgexmrSCB3OZdvLdzOfUYpfg5MpOhvZ4fm0Zcbxw1bhtUMxXU+ugH1AYkSvVVDVLY4NxIAgN3UDLwXjAxitkTZHIh12X/E=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R121e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037033178;MF=dust.li@linux.alibaba.com;NM=1;PH=DS;RN=18;SR=0;TI=SMTPD_---0X5.0WJf_1781602204;
Received: from localhost(mailfrom:dust.li@linux.alibaba.com fp:SMTPD_---0X5.0WJf_1781602204 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 16 Jun 2026 17:30:04 +0800
Date: Tue, 16 Jun 2026 17:30:03 +0800
From: Dust Li <dust.li@linux.alibaba.com>
To: Ren Wei <n05ec@lzu.edu.cn>, linux-rdma@vger.kernel.org,
	linux-s390@vger.kernel.org, netdev@vger.kernel.org
Cc: alibuda@linux.alibaba.com, sidraya@linux.ibm.com, wenjia@linux.ibm.com,
	mjambigi@linux.ibm.com, tonylu@linux.alibaba.com,
	guwen@linux.alibaba.com, ubraun@linux.ibm.com,
	stefan.raspl@linux.ibm.com, davem@davemloft.net,
	yuantan098@gmail.com, zcliangcn@gmail.com, bird@lzu.edu.cn,
	lx24@stu.ynu.edu.cn, d4n.for.sec@gmail.com
Subject: Re: [PATCH net 1/1] net: smc: fix splice entry lifetime imbalance in
 smc_rx_splice
Message-ID: <ajEXm3PDY8Wv8Ohh@linux.alibaba.com>
Reply-To: dust.li@linux.alibaba.com
References: <cover.1781097957.git.d4n.for.sec@gmail.com>
 <192d1b44ed358ca143f44ef167d14153bccc51e9.1781097957.git.d4n.for.sec@gmail.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <192d1b44ed358ca143f44ef167d14153bccc51e9.1781097957.git.d4n.for.sec@gmail.com>

On 2026-06-11 01:54:11, Ren Wei wrote:
>From: Daming Li <d4n.for.sec@gmail.com>
>
>smc_rx_splice() hands candidate pages to splice_to_pipe() without taking
>references for the lifetime of each splice entry first. That breaks the
>splice ownership contract in the VM-backed RMB path.
>
>splice_to_pipe() drops unqueued entries through spd_release(), while
>queued entries are later dropped through the pipe buffer release
>callback. The current code only tries to take page references after the
>splice succeeds, and it derives the number of queued VM pages from a
>mutated offset value. This can underflow page refcounts and trigger a
>use-after-free. It also leaves the socket lifetime imbalanced in the
>multi-page VM case, where one sock_hold() can be followed by multiple
>sock_put() calls.
>
>Fix this by taking the page and socket references for every candidate
>splice entry before calling splice_to_pipe(), and by releasing the
>matching private state, page reference, and socket reference from
>smc_rx_spd_release() for entries that never get queued. This makes the
>SMC splice path follow the normal splice lifetime rules and removes the
>broken post-splice VM page counting entirely.
>
>Fixes: 9014db202cb7 ("smc: add support for splice()")
>Cc: stable@vger.kernel.org
>Reported-by: Yuan Tan <yuantan098@gmail.com>
>Reported-by: Zhengchuan Liang <zcliangcn@gmail.com>
>Reported-by: Xin Liu <bird@lzu.edu.cn>
>Assisted-by: Codex:GPT-5.4
>Co-developed-by: Liu Xiao <lx24@stu.ynu.edu.cn>
>Signed-off-by: Liu Xiao <lx24@stu.ynu.edu.cn>
>Signed-off-by: Daming Li <d4n.for.sec@gmail.com>
>Signed-off-by: Ren Wei <n05ec@lzu.edu.cn>

The patch looks good to me, a minor nit below

Reviewed-by: Dust Li <dust.li@linux.alibaba.com>


>---
> net/smc/smc_rx.c | 21 +++++++++++----------
> 1 file changed, 11 insertions(+), 10 deletions(-)
>
>diff --git a/net/smc/smc_rx.c b/net/smc/smc_rx.c
>index c1d9b923938d..88aee0d93597 100644
>--- a/net/smc/smc_rx.c
>+++ b/net/smc/smc_rx.c
>@@ -150,18 +150,23 @@ static const struct pipe_buf_operations smc_pipe_ops = {
> static void smc_rx_spd_release(struct splice_pipe_desc *spd,
> 			       unsigned int i)
> {
>+	struct smc_spd_priv *priv = (struct smc_spd_priv *)spd->partial[i].private;
>+	struct sock *sk = &priv->smc->sk;
>+
>+	kfree(priv);
> 	put_page(spd->pages[i]);
>+	sock_put(sk);
> }
> 
> static int smc_rx_splice(struct pipe_inode_info *pipe, char *src, size_t len,
> 			 struct smc_sock *smc)
> {
> 	struct smc_link_group *lgr = smc->conn.lgr;
>-	int offset = offset_in_page(src);
> 	struct partial_page *partial;
> 	struct splice_pipe_desc spd;
> 	struct smc_spd_priv **priv;
> 	struct page **pages;
>+	int offset = offset_in_page(src);

Minor nit:
moving int offset = offset_in_page(src) down breaks the existing
reverse-xmas-tree declaration ordering. We keep this style in SMC.

Best regards,
Dust

