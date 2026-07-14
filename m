Received: from out30-97.freemail.mail.aliyun.com (out30-97.freemail.mail.aliyun.com [115.124.30.97])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E165E13AD1C;
	Tue, 14 Jul 2026 16:20:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.97
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784046041; cv=none; b=aGnJu8WIMZBP/fzSLIyym5DVt6RxiggC7TRmTpw4EapZeuIOfUlAyS9O99R/nmEGVP4cjCaCUHC1sTZ6qIC64z6PVlN2qVVPugxte20UaZzQUQsIuthYNTqJCAyAqdP9e0c/O8iAYj17/UGu7cUcg0o0S/uaMmx1cxOPHPXU1Tg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784046041; c=relaxed/simple;
	bh=IpZNZmdgw+p676Cs1fxTuwPWodXLAeTnD3O7eSez+ps=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=F8OsGKh+2KtXlI7M9uYHyqggQJQMmHIGJSDXYpPo9RVnbUffsl9Q2+/V9wEZUI9CXahN2ty5PbVPzFK1tTXzvCsZelh9tMDvJk1od06vvHcq65/IczA+336vysuh5UzyMlWmhEWWBH9lo54Jvbnv7ZaAtbnwown96qCuPr7Jd2M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=P1AVmLOS; arc=none smtp.client-ip=115.124.30.97
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="P1AVmLOS"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1784046028; h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type;
	bh=wEfx3eGjVZPMCAtKcKXPtHssspy6HgilDFHDGZbA6/s=;
	b=P1AVmLOSfVl7kz9XEyIF5bGetJQDn+DRkP+ihkgyQavj0qCQW7JQqioSs/xqeArM4DeZjd1uCPSLvAw4fwyysQJEjygBr8U5wZ89sP1bgmUCMcPms9YwPTd9XfCJgAn3lcwTrRCXgoXW/1YRy973zehbGXbapShNU/j/Udjzgz0=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R131e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045098064;MF=dust.li@linux.alibaba.com;NM=1;PH=DS;RN=18;SR=0;TI=SMTPD_---0X757QX1_1784046027;
Received: from localhost(mailfrom:dust.li@linux.alibaba.com fp:SMTPD_---0X757QX1_1784046027 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 15 Jul 2026 00:20:27 +0800
Date: Wed, 15 Jul 2026 00:20:27 +0800
From: Dust Li <dust.li@linux.alibaba.com>
To: hexlabsecurity@proton.me, "David S. Miller" <davem@davemloft.net>,
	Sidraya Jayagond <sidraya@linux.ibm.com>,
	Eric Dumazet <edumazet@google.com>,
	"D. Wythe" <alibuda@linux.alibaba.com>,
	Jakub Kicinski <kuba@kernel.org>, Simon Horman <horms@kernel.org>,
	Wenjia Zhang <wenjia@linux.ibm.com>,
	Paolo Abeni <pabeni@redhat.com>
Cc: Stefan Raspl <raspl@linux.ibm.com>, Wen Gu <guwen@linux.alibaba.com>,
	linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
	Mahanta Jambigi <mjambigi@linux.ibm.com>,
	Tony Lu <tonylu@linux.alibaba.com>,
	Ursula Braun <ubraun@linux.ibm.com>, linux-s390@vger.kernel.org,
	linux-rdma@vger.kernel.org
Subject: Re: [PATCH net v4 2/3] net/smc: bound the receive length to the RMB
 in smc_rx_recvmsg()
Message-ID: <alZhy6kQIw5NcnZe@linux.alibaba.com>
Reply-To: dust.li@linux.alibaba.com
References: <20260705-b4-disp-28a1bbca-v4-0-be089b98acc6@proton.me>
 <20260705-b4-disp-28a1bbca-v4-2-be089b98acc6@proton.me>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260705-b4-disp-28a1bbca-v4-2-be089b98acc6@proton.me>

On 2026-07-05 02:54:06, Bryam Vargas via B4 Relay wrote:
>From: Bryam Vargas <hexlabsecurity@proton.me>
>
>conn->bytes_to_rcv is accumulated in the receive tasklet from the
>peer's wire-controlled producer cursor via smc_curs_diff(), whose
>differing-wrap branch can exceed rmb_desc->len; a forged cursor drives
>bytes_to_rcv past the RMB, and over many CDC messages overflows the
>signed counter negative. smc_rx_recvmsg() reads it as the readable
>length and does a wrap-around copy whose second chunk is not re-bounded
>to rmb_desc->len, reading past the RMB into adjacent kernel memory and
>disclosing it to the peer. The nearby readable >= rmb_desc->len test
>only feeds SMC_STAT_RMB_RX_FULL on a separate earlier read; it does not
>bound the copy.
>
>Bound the readable length to rmb_desc->len at the consumer, treating a
>negative (sign-overflowed) value as out of range too, so the copy can
>never exceed the ring. This enforces the documented
>0 <= bytes_to_rcv <= rmb_desc->len invariant where it is race-free
>against the producer update in the tasklet; conforming peers are
>unaffected.
>
>Fixes: 952310ccf2d8 ("smc: receive data from RMBE")
>Cc: stable@vger.kernel.org
>Signed-off-by: Bryam Vargas <hexlabsecurity@proton.me>

Reviewed-by: Dust Li <dust.li@linux.alibaba.com>

Best regards,
Dust

>---
> net/smc/smc_rx.c | 12 ++++++++++++
> 1 file changed, 12 insertions(+)
>
>diff --git a/net/smc/smc_rx.c b/net/smc/smc_rx.c
>index c1d9b923938d..f461cf10b085 100644
>--- a/net/smc/smc_rx.c
>+++ b/net/smc/smc_rx.c
>@@ -442,6 +442,18 @@ int smc_rx_recvmsg(struct smc_sock *smc, struct msghdr *msg,
> 		/* initialize variables for 1st iteration of subsequent loop */
> 		/* could be just 1 byte, even after waiting on data above */
> 		readable = smc_rx_data_available(conn, peeked_bytes);
>+		/* bytes_to_rcv is accumulated from the peer's wire-controlled
>+		 * producer cursor; a forged cursor can drive it past the RMB,
>+		 * or overflow the signed accumulator to a negative value across
>+		 * many CDC messages (which a plain "> len" check would miss
>+		 * before the size_t cast below turns it huge).  Bound it to the
>+		 * RMB in either case so the wrap-around copy cannot run past
>+		 * rmb_desc->len.  This enforces the documented
>+		 * 0 <= bytes_to_rcv <= rmb_desc->len invariant at the consumer,
>+		 * race-free against the producer update in the receive tasklet.
>+		 */
>+		if (readable < 0 || readable > conn->rmb_desc->len)
>+			readable = conn->rmb_desc->len;
> 		splbytes = atomic_read(&conn->splice_pending);
> 		if (!readable || (msg && splbytes)) {
> 			if (splbytes)
>
>-- 
>2.43.0
>
