Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=115.124.30.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793811411;
	b=tB0E/JLKheOElIrsYEiB4J7d6sEzYDLpe1HJrQjUNZT9JkZRqXVZOFEuSsar7aIBcl50
	 RNyDhWy72DAG0U9cOfqvpGUwSZoNkz040i17OCa983uAmBA0akLumuGvoRqrsvtR/6dV5
	 4CB7jh5gG3VPCj0AREhdaJ65q5Elyx10D9x38xPaR4CFdl4eAtHkljEidnvBR2ArF6YsY
	 btBb+cHejc7FNmIO1RHAKk2Ulh5HsKF+vBt53mokyF5BfIXnaCalCaJ6v2tZHkc/zAWgZ
	 iyWIgCmKkWLg2UjUSQqzORjI2ggtHBuzl4NiC8ErJJOP1OkeVhop2aoYw3FIBTKpH4w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793811411;
	h=DMARC-Filter:DKIM-Signature:X-Alimail-AntiSpam:Received:Date:From:To:
	 Cc:Subject:Message-ID:Reply-To:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=7oCUzc0IQ+/X/VuHpS7xyE9gBpY1n2hc0ad7jzb6Ehw=;
	b=JqeMU1HbckVczoRcweA15kajEGoDWhEZ6j9/88qR0S1aPmtI0VF07jpFdCO4p5E1Zfzk
	 kLB/j0jQtXrXbcFZBO2j0a2feEwKUOZeB+A2puavJUUkygtTKjDA/R0lk/SjjNbRT9ftE
	 yh1CzIsnH908RpU1f+B/Q/gwdVmyCJuaH1gSouLX+oq9FErGUfIetnxX4D7WOZo/wUJGx
	 a3IZwrlO1yW3uuYwrTLZ/hubqRwN8cVHrANWzf/nAw1gUk/WQFf2yk1vWOo0tWl3Yitph
	 zMX8ekZPc3Xs2TKr2eEN1NI1o3Zm2uB+uvfJDmSvtIdFSIT6oS8iZCaki4jzLQCLZ5A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.alibaba.com;
	spf=pass smtp.mailfrom=linux.alibaba.com;
	dkim=pass header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=mqOaBcjR;
	arc=none smtp.remote-ip=115.124.30.131
Received: from out30-131.freemail.mail.aliyun.com (out30-131.freemail.mail.aliyun.com [115.124.30.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC3BB606A329;
	Wed,  4 Nov 2026 16:56:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BC3BB606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=mqOaBcjR
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1793811401; h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type;
	bh=7oCUzc0IQ+/X/VuHpS7xyE9gBpY1n2hc0ad7jzb6Ehw=;
	b=mqOaBcjRpqGpjCGLVzSSRUeVouDO/Ewh7UfRw6Wwf+fNKP31s1voVAX4AQofQ2zLAm0XXJbmrLtGePnFwmq4ixu32m2FLvUxD/S59b3s6Q9nUTmgOC4RMk7Xxnf74VoEeGqQkE2nuThQXQThuDEJcWHJ4Rh6DLoCJhq6GHggoak=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R101e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam011083073210;MF=dust.li@linux.alibaba.com;NM=1;PH=DS;RN=19;SR=0;TI=SMTPD_---0XE6Ix9y_1793811400;
Received: from localhost(mailfrom:dust.li@linux.alibaba.com fp:SMTPD_---0XE6Ix9y_1793811400 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 05 Nov 2026 00:56:40 +0800
Date: Thu, 5 Nov 2026 00:56:40 +0800
From: Dust Li <dust.li@linux.alibaba.com>
To: Paolo Abeni <pabeni@redhat.com>,
	Bryam Vargas <hexlabsecurity@proton.me>,
	"D. Wythe" <alibuda@linux.alibaba.com>,
	Mahanta Jambigi <mjambigi@linux.ibm.com>,
	Sidraya Jayagond <sidraya@linux.ibm.com>,
	"David S. Miller" <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Eric Dumazet <edumazet@kernel.org>
Cc: linux-s390@vger.kernel.org, Wen Gu <guwen@linux.alibaba.com>,
	linux-rdma@vger.kernel.org, Tony Lu <tonylu@linux.alibaba.com>,
	Wenjia Zhang <wenjia@linux.ibm.com>, netdev@vger.kernel.org,
	Stefan Raspl <raspl@linux.ibm.com>,
	Hidayath Khan <hidayath@linux.ibm.com>,
	Simon Horman <horms@kernel.org>,
	Ursula Braun <ubraun@linux.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net v2] net/smc: don't spin in smc_rx_recvmsg() while a
 pipe holds spliced data
Message-ID: <autjyLEDJ_quR4Nm@linux.alibaba.com>
Reply-To: dust.li@linux.alibaba.com
References: <20261029-b4-disp-da7f8e6a-v2-1-9052904adf72@proton.me>
 <4d97a782-8d88-4dd0-b819-fb704582f2ec@redhat.com>
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
In-Reply-To: <4d97a782-8d88-4dd0-b819-fb704582f2ec@redhat.com>

On 2026-11-03 15:18:36, Paolo Abeni wrote:
>On 10/29/26 09:03, Bryam Vargas wrote:
>> While bytes spliced off the RMB are still in a pipe, recvmsg() waits
>> for the pipe to release them before it copies the data behind them.
>> The path to that wait skips the timeout and signal checks, and
>> smc_rx_wait() returns at once on RCV_SHUTDOWN. With a signal pending,
>> after SHUT_RD, or once the peer closes or shuts down writing,
>> recvmsg() spins on a CPU until the pipe is drained, and SIGKILL cannot
>> stop it. MSG_DONTWAIT and an expired SO_RCVTIMEO wait there too
>> instead of returning -EAGAIN.
>> 
>> Check the timeout and signals before that wait, and end it when the
>> pipe releases the data or the connection is killed, not on RCV_SHUTDOWN.
>> A zero-length read returns 0 without waiting for the pipe; a
>> non-blocking one returns -EAGAIN while poll() still reports the socket
>> readable (splice() can still take those bytes).
>
>@SMC experts, please review. IMHO the above trade-off sounds like a better
>solution is needed.

Hi Bryam, Paolo,

Yes, I agree this is a trade-off. But I think this was not introduced by
this patch; rather, it is a pre-existing bug. And sadly, I don't have a
good solution to solve it yet.

So for now, I prefer to accept this as a stable fix.

As for the long-term fix: the follow-up I have in mind is to remove the
zero-copy mode for splice in SMC, which will simplify things a lot.
Since splice doesn't map easily to a ring buffer like SMC's, and this is
not a very common path as we have seen, falling back to copy is
acceptable IMO.

Happy to hear if anyone has better ideas.

Best regards,
Dust
