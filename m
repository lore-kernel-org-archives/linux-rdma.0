Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=185.70.43.101
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793298843;
	b=q/DEdJ5IKA4/TjKyKkEWnM9OPNhum+RmSJ5H30N+WRo/aSoKZg4aaK9Yjx8ypnn8B1vN
	 fnMK1hiyZxbYTk6t5KwYU/s4SU5YIgHs5DpU0sIju2dA16AM8U1UWOcITjU8ISALB6GXa
	 mcRNcmY6FnGMKnDylWdXZLFzDHu4DMo7NYSVqlcqNwYcbjM+cJlnMU0RDifmAfb4GIC1+
	 Ze0LgUqAO0lizY5gZ/qkxBwJGkdVefv3R3CIWTYjHMA1wq/rxRwKeoWBsjJ9ZZD6w57I2
	 oxH22FqUzUEicYD3oDxNcNq5SdHjAiCRwYNFAftK1nNk7+QXlGRrKZlT4VvkJTwqIDw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793298843;
	h=DMARC-Filter:DKIM-Signature:Date:To:From:Cc:Subject:Message-ID:
	 In-Reply-To:References:Feedback-ID:X-Pm-Message-ID:MIME-Version:
	 Content-Type:Content-Transfer-Encoding;
	bh=ReI8vpnCtRTYHbyXOgXyO4dEW9LUDfpmbIfo36B0CP0=;
	b=b7kZSaF8Y6NDCle2k81G1k3n+Y75Ouob0SaKtrCVUNTyXGMx7xTEt2xnXDyDgbfdcaUi
	 cGZBZbiZ8m+0SAaHWZEj+xyCFB+z72Eb2P0YUi/yskjkavQNQaYwoLjFImZUQ1cFRGa+M
	 0Fgm5+Ot18X4Hq60Mb0FBrYUkpkJKjqZ1nbzoiMMfECRdZKlj7g7JGJ5hShRWJLBo1QuP
	 3TAQCHCr991N1UpLhu/FIhX0jWQMUMqSkbPUlKkE8t1g5sU8gLBxRdp/tO5fBxO11jXAQ
	 amF6gcXNW4QRA+5euF+pkeQHaptapkOXD+p8pqpT+5UVuWYElb8YxX89oVXoSTjfR3w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=proton.me;
	spf=pass smtp.mailfrom=proton.me;
	dkim=pass header.d=proton.me header.i=@proton.me header.a=rsa-sha256 header.s=protonmail2 header.b=uPgbZMaC;
	arc=none smtp.remote-ip=185.70.43.101
Received: from mail-43101.protonmail.ch (mail-43101.protonmail.ch [185.70.43.101])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6701D606A31E
	for <linux-rdma@vger.kernel.org>; Thu, 29 Oct 2026 18:34:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6701D606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=proton.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=proton.me
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=proton.me header.i=@proton.me header.a=rsa-sha256 header.s=protonmail2 header.b=uPgbZMaC
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=proton.me;
	s=protonmail2; t=1793298839; x=1793558039;
	bh=ReI8vpnCtRTYHbyXOgXyO4dEW9LUDfpmbIfo36B0CP0=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector;
	b=uPgbZMaCL8cuOe4ubHKkyXmB91prapVmAtFr93tIm0KVgYrauHpTYcz6oPI9wICKO
	 +ScqOox6XZHzAtVyUOjCj1vHgHTBo6VoC9IRVGxCj+6ENLNd+ChjtOusVaSck8vvCy
	 irxKO8MbFw+sgDE58I8X/dmwCjW1wpkaobuNZ9gPpLb0I41rwESKILaDdXVX7wVSgN
	 AQwyh5IeVpMx5GYDyaCN4hSSHrOEgqfBrQSBd8S4KSXl1nrdsqCr+IjLW9u7gUw395
	 Txb17VugK+iLeyWZkveke9HM4AapdTksjbQuxRfOGUrLGBeOmVN/Tzsw0cSkNUt/SY
	 MyCrv5+9QUvbA==
Date: Thu, 29 Oct 2026 18:33:53 +0000
To: netdev-bot+sashiko@kernel.org, "D . Wythe" <alibuda@linux.alibaba.com>, Dust Li <dust.li@linux.alibaba.com>, Sidraya Jayagond <sidraya@linux.ibm.com>, Mahanta Jambigi <mjambigi@linux.ibm.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, Eric Dumazet <edumazet@kernel.org>, "David S . Miller" <davem@davemloft.net>
From: Bryam Vargas <hexlabsecurity@proton.me>
Cc: Simon Horman <horms@kernel.org>, Tony Lu <tonylu@linux.alibaba.com>, Wen Gu <guwen@linux.alibaba.com>, Wenjia Zhang <wenjia@linux.ibm.com>, Hidayath Khan <hidayath@linux.ibm.com>, Guangguan Wang <guangguan.wang@linux.alibaba.com>, Ursula Braun <ubraun@linux.ibm.com>, Stefan Raspl <raspl@linux.ibm.com>, linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net v7 3/4] net/smc: bound the send length to the send buffer in smc_tx_sendmsg()
Message-ID: <20261029183345.1744839-1-hexlabsecurity@proton.me>
In-Reply-To: <179209532279.434549.3831566859438447501@kernel.org>
References: <20261013-b4-disp-f345196c-v7-3-ef3dddfbfa68@proton.me> <179209532279.434549.3831566859438447501@kernel.org>
Feedback-ID: 199661219:user:proton
X-Pm-Message-ID: 7cc536af40258ff4690ccda99f0c261977797c2a
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

On Thu, 15 Oct 2026 20:15:22 +0000, netdev-bot+sashiko@kernel.org wrote:
> [Severity: High]
> Mapping a negative writespace to sndbuf_desc->len is new behaviour from
> this patch. It turns a negative sndbuf_space into a full-ring copy on
> every pass of the loop. Is that intended?

It is, for what can reach it. With 4/4 in, sndbuf_space goes negative
only through the DMB-merge credit, which runs on the loopback device
alone, IOW only the local kernel can forge it, and it takes 2^31/len
forged CDCs (measured); without 4/4 a forged cursor at failover does it
in one step, which is 4/4's case. The SMC-R over-credit after a failover
is positive (3x the buffer in the measured case), a "<=3D 0" gate wouldn't
see it, and the clamp is what keeps that copy inside the buffer. A gate
that blocks the sender at <=3D 0 is a fair alternative for the loopback
case, but it is four sites and its own change, so v8 keeps the code. The
comment in smc_tx_sendmsg() that claims 0 <=3D sndbuf_space <=3D len is
corrected in v8; the three "guarantee" comments in the credit paths from
your Low item describe the conforming case and stay.

> [Severity: High]
> This is a pre-existing issue, and this patch didn't introduce it. The
> clamp limits the size of each copy but doesn't fix the flow control.

Right: after the over-credit the copy stays in the buffer but can
overwrite data the peer has not received yet. Fixing the credit needs a
cursor compare that survives the u16 wrap rollover, which
smc_curs_comp() doesn't give; not in this series.

> [Severity: High]
> This is also a pre-existing issue. What serializes smc_switch_cursor()
> against smc_cdc_tx_handler()?

Nothing beyond what you list, send_lock on one side and bh_lock_sock()
on the other. The interleaving you give credits the handler's bytes a
second time and leaves tx_curs_fin ahead of tx_curs_sent, and a later
completion moves tx_curs_fin back and credits again. Pre-existing,
conforming peer, failover with CDC sends in flight.

