Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=115.124.30.101
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795494331;
	b=ec88FkM+EQSqIaZs1N9TYBTBAvNCwzMzkoen2stUdFj7k1APR2dxYsP3mFDosnb7NKyB
	 FTj6VY5BK1DzaZ7DHd8dDy/D+3uh7FbeSVd7LmqJTSXJrheWesjotA1RmZZYbHzAgrQVZ
	 cRfcX5YY1iDNBIg70zXYFGXZvaj2sO/U2WjF5KAQyLtsyqjbFgkM6f5jWNp4qusgr1SRG
	 d1VyLvojnagOrq/sNp0ck4v4bnr9+kH8GI5MwZfJEzCgFP2vVpuLZlxHi5KI5dmjiBO3K
	 A5cjYM8Ov+kNu+s0thoQz608y3QzFCDeIZGbY/2YV2WmRAyHXNuv1s+3BLYoSuBI1Ow==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795494331;
	h=DMARC-Filter:DKIM-Signature:X-Alimail-AntiSpam:Received:Date:From:To:
	 Cc:Subject:Message-ID:Reply-To:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=OEh0PEZT89NLtHRlSYqxwc0geCRim/3SLGx9Dh1iylk=;
	b=z6SjNOr28yxDUM/dDI6N2Xo9COgXKWnSeurFxHcfD89EzTE6L1eV7c4wa29Adgb3p950
	 df10haaaMQKyA8w+NB+2InlHAR/1nHmPA/7TIYvUbI6PKpIzw1sUbxbL97P6lZ/CEZzxM
	 xZoKIDLY8z/XoxiFwIzumUFrx979+LIYkPtFHD2zOxk7NkW8noJYnOORrQsB3d2U3ouls
	 sWHsDrA3uHvfZa/CnQNLO6M9mMFGXaNdwbdPAAOPS8SL4kkm/wLcoAv37LjwJkxb+wWez
	 EmfF0U9M8k+10dEiibMSRCp5frHJCGNLoKQR7470vukDBP/gSI3SHgZyxIvalOXBkRQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.alibaba.com;
	spf=pass smtp.mailfrom=linux.alibaba.com;
	dkim=pass header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=IxpdG9A8;
	arc=none smtp.remote-ip=115.124.30.101
Received: from out30-101.freemail.mail.aliyun.com (out30-101.freemail.mail.aliyun.com [115.124.30.101])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6E8E606A31E;
	Tue, 24 Nov 2026 04:25:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D6E8E606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=IxpdG9A8
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1795494325; h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type;
	bh=OEh0PEZT89NLtHRlSYqxwc0geCRim/3SLGx9Dh1iylk=;
	b=IxpdG9A8qnuRA8pxSS/Vtfm1q9AYaNeaszlZznmzBzJRjcgiLvPIt8RLR961rjg5uW4FeLt175rlpqQDrcVuv1tghRiOYeqons/t172rCbmeuVYL4TUCrsacSBVlMKvwdwHDE6px9Vm1w4M0FU4wEc5xHkcWihlZ0fe3bfVrhhw=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R201e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037026112;MF=dust.li@linux.alibaba.com;NM=1;PH=DS;RN=14;SR=0;TI=SMTPD_---0XFNJdsr_1795494324;
Received: from localhost(mailfrom:dust.li@linux.alibaba.com fp:SMTPD_---0XFNJdsr_1795494324 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 24 Nov 2026 12:25:25 +0800
Date: Tue, 24 Nov 2026 12:25:24 +0800
From: Dust Li <dust.li@linux.alibaba.com>
To: Qican Ma <goonsomeway@gmail.com>, alibuda@linux.alibaba.com,
	sidraya@linux.ibm.com, mjambigi@linux.ibm.com
Cc: tonylu@linux.alibaba.com, guwen@linux.alibaba.com, davem@davemloft.net,
	edumazet@kernel.org, kuba@kernel.org, pabeni@redhat.com,
	horms@kernel.org, linux-rdma@vger.kernel.org,
	linux-s390@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net] net/smc: serialize clcsock release against CDC
 receive path
Message-ID: <awURtCvesMgSBQY2@linux.alibaba.com>
Reply-To: dust.li@linux.alibaba.com
References: <CA+OT+OPkNsk2QHczVmb6KVJ+z_1tpH9DXm8JmACc5E6x-YFwPA@mail.gmail.com>
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+OT+OPkNsk2QHczVmb6KVJ+z_1tpH9DXm8JmACc5E6x-YFwPA@mail.gmail.com>

On 2026-11-23 19:21:06, Qican Ma wrote:
>In smc_cdc_msg_recv_action(), receiving a close or senddone flag writes
>RCV_SHUTDOWN to smc->clcsock->sk->sk_shutdown while holding only
>bh_lock_sock(&smc->sk). Meanwhile __smc_release() drops the socket lock
>and calls smc_clcsock_release() (which clears smc->clcsock and calls
>sock_release() under clcsock_release_lock) before calling
>smc_conn_free(&smc->conn). Even on paths that call smc_conn_free() first,
>an in-flight SMC-R softirq that already looked up the connection in
>smc_cdc_rx_handler() can still enter smc_cdc_msg_recv() concurrently with
>smc_clcsock_release() and dereference or write through a freed clcsock.
>
>Free the SMC connection before releasing clcsock in __smc_release(),
>matching smc_close_active_abort() and smc_close_passive_work(). Because
>smc_conn_free() sets conn->freed = 1 while lock_sock(sk) is held and
>release_sock(sk) synchronizes on sk->sk_lock.slock before
>smc_clcsock_release() runs, checking !smc->conn.freed under
>bh_lock_sock(&smc->sk) in smc_cdc_msg_recv() guarantees that no CDC
>handler accesses smc->clcsock once smc_clcsock_release() can start.
>
>Found with an LLM-assisted code review tool and verified by inspection on
>v7.4-rc4 (b6a9fa34ce4). Build-tested only; not runtime-tested due to lack
>of an SMC-R/SMC-D setup.

This fails to apply to net/main

Best regards,
Dust

