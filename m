Received: from out30-132.freemail.mail.aliyun.com (out30-132.freemail.mail.aliyun.com [115.124.30.132])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 701F637B3F9;
	Wed,  5 Aug 2026 03:18:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.132
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785899918; cv=none; b=mbfyUoZQ9PNBUDrUNsiNdOQ8LCyOCSgr4xDTr1UNpnLT52AnY0hxFL5t6Ja7oFX1S3zpK3vciYH0p2VGrKWw51C1K2+j+Qkti8FMkr9IoxjeD7fZUomFalu7aWYU252QuDCxArRcsrLcRcnchDwxRKNELMjnL3LqjC4Rqj0yXDA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785899918; c=relaxed/simple;
	bh=XmTzYePdCPSD7x6GhWoDyr3F6EIdfWcn4K6qWnY16fE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=M06T73acIO3/DLppyqCgvNlXXkXAfWhKIkSmPGrm+JDYXaGxeBBm8y2UQYGCvRBj9ApjdYW8f4HpB9p49fhwGW8aLqxDmig3B/7mWYybEge9aZbIZ1echKCPqB7Eu83TrXm9RgqzZq6wtJh+frsvkMHj2foe5+j5jYd4PAfqc8U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=C+X9a8D0; arc=none smtp.client-ip=115.124.30.132
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="C+X9a8D0"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1785899901; h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type;
	bh=gTMi+9O9uxqWDAp2n+p0LfXJQhDU9mWxjtuUL70XLjc=;
	b=C+X9a8D0Eb84b3wJUnmth/4agAvaenO2F+upvKdVr3/8dPLC3Xg9rXzvXCFbl8Cxt2lEw8iVQ/+Kvxs3DObyyNxzLrVRnRXyYDCrgDzTtczWAD5EZBaAdvs3Nf84vPaOibQk7JOCzd8VE1L/DFMz/fAxjai/E7TTTummkw/e5XY=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R651e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045098064;MF=tonylu@linux.alibaba.com;NM=1;PH=DS;RN=15;SR=0;TI=SMTPD_---0X8PlxZA_1785899900;
Received: from localhost(mailfrom:tonylu@linux.alibaba.com fp:SMTPD_---0X8PlxZA_1785899900 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 05 Aug 2026 11:18:20 +0800
Date: Wed, 5 Aug 2026 11:18:18 +0800
From: Tony Lu <tonylu@linux.alibaba.com>
To: Yifei Gao <gyf161023@gmail.com>
Cc: "D . Wythe" <alibuda@linux.alibaba.com>,
	Dust Li <dust.li@linux.alibaba.com>,
	Sidraya Jayagond <sidraya@linux.ibm.com>,
	Mahanta Jambigi <mjambigi@linux.ibm.com>,
	linux-rdma@vger.kernel.org, linux-s390@vger.kernel.org,
	netdev@vger.kernel.org, Wen Gu <guwen@linux.alibaba.com>,
	Karsten Graul <kgraul@linux.ibm.com>,
	Ursula Braun <ubraun@linux.ibm.com>,
	Wenjia Zhang <wenjia@linux.ibm.com>, linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH] net/smc: fix sock refcount leak in smc_switch_conns()
 error path
Message-ID: <anKretz4IRgMBdR9@TONYMAC-ALIBABA.local>
Reply-To: Tony Lu <tonylu@linux.alibaba.com>
References: <20260804213917.3413525-1-gyf161023@gmail.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260804213917.3413525-1-gyf161023@gmail.com>

> Subject: [PATCH] net/smc: fix sock refcount leak in smc_switch_conns() error path

Please use [PATCH net] as the subject prefix when sending v2, since
this fix targets the net tree.

On Tue, Aug 04, 2026 at 09:39:17PM +0000, Yifei Gao wrote:
> smc_switch_conns() takes a reference on the socket with sock_hold() before
> dropping conns_lock to prefetch a tx slot. On success the reference is
> released by the sock_put() after smc_switch_cursor(). When
> smc_cdc_get_free_slot() fails, however, the function jumps straight to
> err_out without a sock_put(), leaking the reference and leaving the socket
> unreclaimable. During SMC-R link failover with an exhausted backup link
> this leaks one reference per failing connection switch.
> 
> Release the reference before jumping to err_out. The err_out label is also
> reached from the smc_switch_cursor() failure path, which has already done
> its own sock_put(), so the put must stay at the get_free_slot failure site
> rather than at the label.
> 
> Fixes: c6f02ebeea3a ("net/smc: switch connections to alternate link")
> Cc: stable@vger.kernel.org
> Assisted-by: Claude:claude-opus-4-8
> Signed-off-by: Yifei Gao <gyf161023@gmail.com>
> ---
>  net/smc/smc_core.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/net/smc/smc_core.c b/net/smc/smc_core.c
> index cf6b620fef05..04c6ce608ec7 100644
> --- a/net/smc/smc_core.c
> +++ b/net/smc/smc_core.c
> @@ -1148,8 +1148,10 @@ struct smc_link *smc_switch_conns(struct smc_link_group *lgr,
>  		read_unlock_bh(&lgr->conns_lock);
>  		/* pre-fetch buffer outside of send_lock, might sleep */
>  		rc = smc_cdc_get_free_slot(conn, to_lnk, &wr_buf, NULL, &pend);
> -		if (rc)
> +		if (rc) {
> +			sock_put(&smc->sk);
>  			goto err_out;
> +		}
>  		/* avoid race with smcr_tx_sndbuf_nonempty() */
>  		spin_lock_bh(&conn->send_lock);
>  		smc_switch_link_and_count(conn, to_lnk);
> -- 
> 2.43.0
