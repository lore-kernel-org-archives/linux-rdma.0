Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=115.124.30.100
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793811615;
	b=yY3OHpZOzUEmGrq9oA0bOgu5sKYEfXtJ/Snlk51LdHU4OAFMXO8Gz7lnihrMJIZx0t7M
	 HiN2kX0ah4JvNS8kIQiBhfIyQ47X9n8yYcnZ95klXEAelKD48jXlPb6KHeKgIyTaTqEQV
	 jmh6PaRvWHF3nhQmIgFXCUW81Z+oLR6PMBImOkMi4uFA2fn5UoouIYTh7dQmFNAoFQIUu
	 73vynoXPB5v/y2po9j1ZPoenWaA3Q5BSSbBVWs56sIvv105THEocKUIK4pX0CTPoet0DC
	 dD1anfwm3cQweGfqlqNKTCpg8Tj7FZ9QDlgQ1D/LMzDGefj64m/bwmGgK/UejfzHduA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793811615;
	h=DMARC-Filter:DKIM-Signature:X-Alimail-AntiSpam:Received:Date:From:To:
	 Cc:Subject:Message-ID:Reply-To:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=rp3ZfEOvoyj0AGyhtM1kMEKo3y4yYvcAsluSoIw7ejM=;
	b=aEn1/1ZFyWEpweh/sq7cVxOK/Ya2y5k5J54i+boDF/3EtGx/d3hYKAzR+krwFhYkMirG
	 4oJ+WuzFTEOULmdIBY4Wpvm6ohx9vLVHSl2tJuuHShmhHp2k5euaE/JrEMJACOLz9tkkf
	 GfzrImw04RkhloyGd5cIKYb07+ugCcOjcHxNTF3ra1RsgmD9vb0I5ZxsHCCJXSx2bAy/W
	 KeQmTt9Okr9eSTdkKIRxRu8KhMGJyaIei1tiDd0HMAgL/HLHb4nqBOR1olVVuCbocKKxc
	 UsVjhDOj011118ybmtR3u5o8ZMVWYcjGRy0e2cm9UFMPl0juFKCm5NurTpKdDaC+jVg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.alibaba.com;
	spf=pass smtp.mailfrom=linux.alibaba.com;
	dkim=pass header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=BfDMXCKG;
	arc=none smtp.remote-ip=115.124.30.100
Received: from out30-100.freemail.mail.aliyun.com (out30-100.freemail.mail.aliyun.com [115.124.30.100])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A847606A32F;
	Wed,  4 Nov 2026 17:00:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7A847606A32F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=BfDMXCKG
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1793811605; h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type;
	bh=rp3ZfEOvoyj0AGyhtM1kMEKo3y4yYvcAsluSoIw7ejM=;
	b=BfDMXCKGapvcKcVwLRZU7SJJ4SmFMa9bhjrYPlJ/QH1XdVrgH9KxlUvPTbyFheju/x1O6C934rQJZOf0ieH9xeVSWy5GQiYmg+2AuC9oSRfZYxUk6e5N2kMCn/w4pDAQX+3pQOcic0tMSUTm7zh/L6yZ6TLHggbL51/vt2NsGlY=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R161e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045098064;MF=dust.li@linux.alibaba.com;NM=1;PH=DS;RN=19;SR=0;TI=SMTPD_---0XE6E8un_1793811603;
Received: from localhost(mailfrom:dust.li@linux.alibaba.com fp:SMTPD_---0XE6E8un_1793811603 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 05 Nov 2026 01:00:04 +0800
Date: Thu, 5 Nov 2026 01:00:03 +0800
From: Dust Li <dust.li@linux.alibaba.com>
To: hexlabsecurity@proton.me, "D. Wythe" <alibuda@linux.alibaba.com>,
	Mahanta Jambigi <mjambigi@linux.ibm.com>,
	Sidraya Jayagond <sidraya@linux.ibm.com>,
	"David S. Miller" <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
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
Message-ID: <autkkxC260Mq--dx@linux.alibaba.com>
Reply-To: dust.li@linux.alibaba.com
References: <20261029-b4-disp-da7f8e6a-v2-1-9052904adf72@proton.me>
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
In-Reply-To: <20261029-b4-disp-da7f8e6a-v2-1-9052904adf72@proton.me>

On 2026-10-29 03:03:33, Bryam Vargas via B4 Relay wrote:
>From: Bryam Vargas <hexlabsecurity@proton.me>
>
>While bytes spliced off the RMB are still in a pipe, recvmsg() waits
>for the pipe to release them before it copies the data behind them.
>The path to that wait skips the timeout and signal checks, and
>smc_rx_wait() returns at once on RCV_SHUTDOWN. With a signal pending,
>after SHUT_RD, or once the peer closes or shuts down writing,
>recvmsg() spins on a CPU until the pipe is drained, and SIGKILL cannot
>stop it. MSG_DONTWAIT and an expired SO_RCVTIMEO wait there too
>instead of returning -EAGAIN.
>
>Check the timeout and signals before that wait, and end it when the
>pipe releases the data or the connection is killed, not on RCV_SHUTDOWN.
>A zero-length read returns 0 without waiting for the pipe; a
>non-blocking one returns -EAGAIN while poll() still reports the socket
>readable (splice() can still take those bytes). The wait sets
>SOCKWQ_ASYNC_WAITDATA like smc_rx_wait(), so a byte arriving behind
>the pipe raises no SIGIO on a reader already asleep for it, and a full
>barrier orders its wait queue entry before its read of splice_pending,
>so no wake is lost.
>
>Fixes: 9014db202cb7 ("smc: add support for splice()")
>Cc: stable@vger.kernel.org
>Signed-off-by: Bryam Vargas <hexlabsecurity@proton.me>

Reviewed-by: Dust Li <dust.li@linux.alibaba.com>

Best regards,
Dust

