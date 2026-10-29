Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=79.135.106.118
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793261062;
	b=NsXK5u4fkgZoyEbm/FOO4MCZFsReEQ6+5Bg5Douhih1BNNoiya3ONaqSn6fz/PGDqYK7
	 DPBC3sbHIugmFSMd5ikKUDyyVADXDc0IDyhbnBx8Mo13oepjr89joJA8lXlh50TeZ1kT4
	 qvseLXvXnrR6OV0U/jt+iL70FM+7Pi8lS8a/YIzSvP+Ckj6HqY9RT93BGd2cE3RbINI2w
	 6eQa69TGv0SQddEB+FChFcNeaDPaQ5VcjEPqeo7m8/mAvlBMH/ObG1gjNFCCMjatHIxDa
	 MCphMNTzbIFwWi3Jiy0zq1NvMEMBstgL41/dFGr5QVBh5qDaecIMyE2f9h2zyQ4PiZw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793261062;
	h=DMARC-Filter:DKIM-Signature:Date:To:From:Cc:Subject:Message-ID:
	 In-Reply-To:References:Feedback-ID:X-Pm-Message-ID:MIME-Version:
	 Content-Type:Content-Transfer-Encoding;
	bh=3mi8pbVMw8BvzgIqDR4pQfsZ3+QylVo6OT08+KoiPrM=;
	b=BZmiYOpJEQQ81c+BAmYgzmFEUzpRdFfSSM8p/RcM7ODQqNVGUdJp/h5GbcgV9WWQ3sEO
	 VY02GliWG79bct1muZbSaGzMlHn6RaZIU5HmPXCn5EotfW6R6ohyFbjNVs3VIV+or+q96
	 /CyGc00rlXwPSFblkqc7E/3TVxYatIByJ814l+nz9eBPlyy3NTHRNhP9aeOsJkF3wPsLr
	 Mk/Hk9KCFZKwPMDxDA98hR7bsagcTs+86gVa6mTyZhthDGRhXu2e3PFgdQHHsrjrxZ9cJ
	 HfnSv0f33UFq0G3QdNqfEN/rL+YtkfP0WLLdGEKDLuLb/27LhURUpSt0/hMGEW3sAGA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=proton.me;
	spf=pass smtp.mailfrom=proton.me;
	dkim=pass header.d=proton.me header.i=@proton.me header.a=rsa-sha256 header.s=protonmail2 header.b=IiWd7e3S;
	arc=none smtp.remote-ip=79.135.106.118
Received: from mail-106118.protonmail.ch (mail-106118.protonmail.ch [79.135.106.118])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EDC5606A31C
	for <linux-rdma@vger.kernel.org>; Thu, 29 Oct 2026 08:04:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1EDC5606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=proton.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=proton.me
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=proton.me header.i=@proton.me header.a=rsa-sha256 header.s=protonmail2 header.b=IiWd7e3S
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=proton.me;
	s=protonmail2; t=1793261057; x=1793520257;
	bh=3mi8pbVMw8BvzgIqDR4pQfsZ3+QylVo6OT08+KoiPrM=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector;
	b=IiWd7e3S+ETRMNGTnFKt60Hk2tsXc98Iro5IAQsKUoXxI3y/ZWytkooEsMcO3ZxVm
	 WfHs1gJjZrjVBN83/9638VdvmOwX8HRJTc1iEoshMET4bfm+fZw4LcIGh89UC1sLwF
	 xE5CD61F8sDwjpzemkVxdCBpjT0H5sTUVXTn3tSGMx59YEeeb9IKbmSCiOQd1cW/Rl
	 uauLFtbcQYt/1GOFkdxxepZJZCd6Lgyvl4A8+Yq48A9J+dZIipGTETvkBQsDv4HlEi
	 Fioa8urpvZMqN5Y17YAlton7PAl8HJrokHTRyR30GLIAFkeATqScA/eIGkGjfSOQMN
	 xtLdhRTRKRd8w==
Date: Thu, 29 Oct 2026 08:04:08 +0000
To: netdev-bot+sashiko@kernel.org, "D . Wythe" <alibuda@linux.alibaba.com>, Dust Li <dust.li@linux.alibaba.com>, Sidraya Jayagond <sidraya@linux.ibm.com>, Mahanta Jambigi <mjambigi@linux.ibm.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, Eric Dumazet <edumazet@kernel.org>, "David S . Miller" <davem@davemloft.net>
From: Bryam Vargas <hexlabsecurity@proton.me>
Cc: Simon Horman <horms@kernel.org>, Tony Lu <tonylu@linux.alibaba.com>, Wen Gu <guwen@linux.alibaba.com>, Wenjia Zhang <wenjia@linux.ibm.com>, Hidayath Khan <hidayath@linux.ibm.com>, Ursula Braun <ubraun@linux.ibm.com>, Stefan Raspl <raspl@linux.ibm.com>, linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] net/smc: don't spin in smc_rx_recvmsg() while a pipe holds spliced data
Message-ID: <20261029080359.961295-1-hexlabsecurity@proton.me>
In-Reply-To: <179209723095.434549.11206499945190748009@kernel.org>
References: <20261013-b4-disp-193a2a59-v1-1-ed88ac10a41c@proton.me> <179209723095.434549.11206499945190748009@kernel.org>
Feedback-ID: 199661219:user:proton
X-Pm-Message-ID: f58622c7d2ed4f0b82b621aff97d67460d027f59
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Thu, 15 Oct 2026 20:47:10 +0000, netdev-bot+sashiko@kernel.org wrote:
> [Severity: Medium]
> Can this wait miss the final wakeup on weakly ordered architectures?

Yes. Between the entry's store in add_wait_queue() and the read of
splice_pending the sleeper only has an unlock and a lock acquire, not
a full barrier; the release side reads the list after its own
smp_mb(), so the gap is the sleeper's. v2 puts an smp_mb() after
add_wait_queue(). Checked with herd7 against LKMM: the lost wake is
allowed without it, forbidden with it. smc_rx_wait() has the same
gap, but every CDC message that brings data wakes it again; this wait
has only the pipe release to wake it, so the barrier matters here.
Moving the decrement under lock_sock() is the change Hidayath Khan
announced in [1]; the barrier closes the window on its own and
doesn't depend on it.

> [Severity: Low]
> Should smc_rx_wait_splice() do the same?

Yes, v2 sets and clears SOCKWQ_ASYNC_WAITDATA around the sleep.
Measured on the v1 setup with one more case, an O_ASYNC reader owned
by the reading thread, blocked behind the pipe while the peer sends
one more byte: v1 returns -EINTR within 1 ms of the byte, v2 sleeps
on and reads the next 4096 bytes once the pipe is drained, as the
unpatched kernel does.

> [Severity: Medium]
> This is a pre-existing issue that this patch didn't introduce: can the
> splice path read a stale splbytes here?

It can; the fix is Hidayath's change in [1]. This patch doesn't touch
that path.

> [Severity: Medium]
> This is a pre-existing issue rather than one added by this patch, but
> smc_poll() still disagrees with this -EAGAIN:

The commit message of v2 now says so: a non-blocking read behind the
pipe returns -EAGAIN while poll() reports the socket readable, since
bytes_to_rcv counts the data behind the pipe. A level-triggered loop
that keeps the spliced bytes in a pipe gets EPOLLIN and -EAGAIN until
it drains that pipe; before the patch the same read didn't return
until the drain, asleep, one pass per tick, not spinning (measured).
Looking at splice_pending in smc_poll() would hide data splice() can
still take (a second splice with the first undrained returns the next
4096 bytes at once, measured), so v2 leaves poll() alone; the pipe
release wakes the socket.

[1] https://lore.kernel.org/all/7a174d1f-80d8-4294-ae66-829c9dacd662@linux.=
ibm.com/

pw-bot: cr

