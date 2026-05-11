Received: from out30-132.freemail.mail.aliyun.com (out30-132.freemail.mail.aliyun.com [115.124.30.132])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3908231842;
	Mon, 11 May 2026 02:12:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.132
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778465532; cv=none; b=dE2cGG2UyAcZQnvYXxjKj3LnusPSWmAnlUCFRaGm0bDrrbHwZ5n72zJ4N3A4wZlDF0ocb12Uog8pNOJcJyGr74cGU/Uq+fF3C9P3qvyhQRGPKkFVo+K+GenGqfE9oLdnpX+unjpaD7w+GwvdyXmOhe2wnHbRMxRN5VwNVhKeSDc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778465532; c=relaxed/simple;
	bh=UPjHGyjrrdjJl+nThovqLzc1zsiL9JCDWshKZdQkDzI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cpGSbchZFNhHc7tha6xoymZ30di1Wu+2UOVav0wtl8X1e56FqaI1UsF45NP8Dbjw2Bx19BF1Osglr9pUrL1ldoEeR7/tOEwyjGuJKk4gIJlxHf/QND8DHB8PmT9yaK3ewx6ZFJMI1lCAKVlSyQ6NXEN5zXn4FlwBM1C5K4eBs7E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=x/GAPW4f; arc=none smtp.client-ip=115.124.30.132
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="x/GAPW4f"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1778465520; h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type;
	bh=Yh0yv4hpz/w5G4SItF8ufw+BZBwd/7FwIrtXyvyTopY=;
	b=x/GAPW4fvcTcqdK1O0JtGQaq0ZDDGDBHWkODwLEsBWjU84aji+SWnNVolbT9nTUnycHsWCSGhzeqy68ZqQe19g9GpnyfhSkA9CXeotttBdxJtUln4KVpXAX0w+eV7+BGvoegB28lstKXxnbwI0gP3kchmqtVIZxhAWyIEdU8a1Y=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R541e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037009110;MF=dust.li@linux.alibaba.com;NM=1;PH=DS;RN=9;SR=0;TI=SMTPD_---0X2dpEjW_1778465519;
Received: from localhost(mailfrom:dust.li@linux.alibaba.com fp:SMTPD_---0X2dpEjW_1778465519 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 11 May 2026 10:11:59 +0800
Date: Mon, 11 May 2026 10:11:59 +0800
From: Dust Li <dust.li@linux.alibaba.com>
To: Xiang Mei <xmei5@asu.edu>, netdev@vger.kernel.org
Cc: alibuda@linux.alibaba.com, wenjia@linux.ibm.com, sidraya@linux.ibm.com,
	tonylu@linux.alibaba.com, linux-rdma@vger.kernel.org,
	linux-s390@vger.kernel.org, bestswngs@gmail.com
Subject: Re: [PATCH net] net/smc: avoid NULL deref of conn->lnk in
 smc_msg_event tracepoint
Message-ID: <agE678UUAXb9LLDm@linux.alibaba.com>
Reply-To: dust.li@linux.alibaba.com
References: <20260510222640.1230720-1-xmei5@asu.edu>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260510222640.1230720-1-xmei5@asu.edu>

On 2026-05-10 15:26:40, Xiang Mei wrote:
>The smc_msg_event tracepoint class, shared by smc_tx_sendmsg and
>smc_rx_recvmsg, unconditionally dereferences smc->conn.lnk:
>
>	__string(name, smc->conn.lnk->ibname)
>
>conn->lnk is only set for SMC-R; for SMC-D it is NULL. Other code on
>these paths already handles this (e.g. !conn->lnk in
>SMC_STAT_RMB_TX_SIZE_SMALL()). With the tracepoint enabled, the first
>sendmsg()/recvmsg() on an SMC-D socket crashes:
>
>  Oops: general protection fault, probably for non-canonical address
>  KASAN: null-ptr-deref in range [...]
>  RIP: 0010:strlen+0x1e/0xa0
>  Call Trace:
>   trace_event_raw_event_smc_msg_event (net/smc/smc_tracepoint.h:44)
>   smc_rx_recvmsg (net/smc/smc_rx.c:515)
>   smc_recvmsg (net/smc/af_smc.c:2859)
>   __sys_recvfrom (net/socket.c:2315)
>   __x64_sys_recvfrom (net/socket.c:2326)
>   do_syscall_64
>
>The faulting address 0x3e0 is offsetof(struct smc_link, ibname),
>confirming the NULL ->lnk deref. Enabling the tracepoint requires
>root, but the trigger itself is unprivileged: socket(AF_SMC, ...) has
>no capability check, and SMC-D negotiation needs no admin step on
>s390 or on x86 with the loopback ISM device loaded.
>
>Log an empty device name for SMC-D instead of dereferencing NULL.
>
>Fixes: aff3083f10bf ("net/smc: Introduce tracepoints for tx and rx msg")
>Reported-by: Weiming Shi <bestswngs@gmail.com>
>Assisted-by: Claude:claude-opus-4-7
>Signed-off-by: Xiang Mei <xmei5@asu.edu>

Reviewed-by: Dust Li <dust.li@linux.alibaba.com>

Best regards,
Dust

