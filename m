Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=109.224.244.17
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795878853;
	b=O7Y0fizT7JfrYvJlfgvfaF4kD3WfZNOW5jd2wF8E2/s6ZrMe/0LFJDoqjUNc4/Al08AN
	 hxNYeEZNBLcIsXsU6lqYTrXNipv5yJTbECFYZcWt7c/Q7Y6a+ffDon4G/NP6tKvnWHugY
	 pKb6PiMli49Z2E5XnfcTq4oksRtYixQwVxH7e1W7GUt1MnrwbekhLhQ4MIp+0i4mrw0dv
	 g0MLR0UJzqP0KEa7+OKghuw23afEupxXEzIB7WSPWQMZoSU/E/T01qUCRTx7hJ/h6qiyF
	 W6ETqfUHFdhyQMZSwNln4xeIyx/VuTHJlZFot/wKlLVyeHr+j2MyuDR7Fg6AcJxPXpQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795878853;
	h=DMARC-Filter:DKIM-Signature:Date:To:From:Cc:Subject:Message-ID:
	 In-Reply-To:References:Feedback-ID:X-Pm-Message-ID:MIME-Version:
	 Content-Type:Content-Transfer-Encoding;
	bh=E4k035P4dZcMi922utBpmYQuLblJtG64appdTUEPiyk=;
	b=jeCL3rjRCusRV4ffnYY12hZbRbQDoUH+X3ECCfMy+xdzavQauRkr5Xd5RSjiaQBqmZ3J
	 4HT8+XkYyIK2zEw+S8i05umKEaT/J5pDD1pyh6OOH0BT+gD0YEF7dPzLMJ/OFH9oMmyU7
	 AoaEoa7QCMWzdprz4kti++GS2DkS4edrJu0fIykoU5ravFmIYV5F3O29quN1zYKCoP/8k
	 qiyydiaV0BkysPLnrNSWesg38YbLZXp8YSfVuFSN1sKAurcjV2jXApaucfsGDKgkkK8xQ
	 wmBykLvFGif0pvR3Vk+HhemYyDFCUq7xjBtXUEFXUCBBGD16sf9ngThrtRdM8nIzRDA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=proton.me;
	spf=pass smtp.mailfrom=proton.me;
	arc=none smtp.remote-ip=109.224.244.17
Received: from mail-24417.protonmail.ch (mail-24417.protonmail.ch [109.224.244.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D37F4606A31C
	for <linux-rdma@vger.kernel.org>; Sat, 28 Nov 2026 15:14:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D37F4606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=proton.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=proton.me
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=proton.me;
	s=cz5erkleovdxxau5fl226y2e74.protonmail2; t=1795878839;
	x=1796138039; bh=E4k035P4dZcMi922utBpmYQuLblJtG64appdTUEPiyk=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector;
	b=xJlqg7FzKWyvoyBtVA9jzDJ32K9iAHYM1y+c5WNzEA8+VhSWgzgZng2Kemua8OQbP
	 +gTqcHV8GNUwO9YLS98I1omJDnrQnI2UpcWBbIXXt5oIEeUNeXWxsoVeAIQsMsnlmn
	 r8ebmw7etARvx+fpeN+8jDTpfBmvUcoVRn5xgvRAoiuPdwEMPoa8wrK3aLgu53+0un
	 Ml4jYMLpHJXHld7kd7RAujhBAlFVTNPz0S9MBB0jXrxjwlQTiwTQlbifS648b3dSJC
	 YhmwwOoKn94mBqwtUdof3U8qSQ++F3wJzk6vmdCI/OEG1XZr+dwEGUdCxm1wtT9gZY
	 Oxb5USh17a91A==
Date: Sat, 28 Nov 2026 15:13:53 +0000
To: Sidraya Jayagond <sidraya@linux.ibm.com>
From: Bryam Vargas <hexlabsecurity@proton.me>
Cc: Dust Li <dust.li@linux.alibaba.com>, "David S . Miller" <davem@davemloft.net>, Mahanta Jambigi <mjambigi@linux.ibm.com>, Paolo Abeni <pabeni@redhat.com>, Eric Dumazet <edumazet@kernel.org>, Jakub Kicinski <kuba@kernel.org>, "D . Wythe" <alibuda@linux.alibaba.com>, Alexandra Winter <wintera@linux.ibm.com>, Hidayath Khan <hidayath@linux.ibm.com>, linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, netdev@vger.kernel.org, Simon Horman <horms@kernel.org>, Tony Lu <tonylu@linux.alibaba.com>, Wen Gu <guwen@linux.alibaba.com>, linux-s390@vger.kernel.org, Wenjia Zhang <wenjia@linux.ibm.com>, Julian Ruess <julianr@linux.ibm.com>
Subject: Re: [PATCH net v2 2/2] net/smc: do not reuse the DMB of a nocopy device
Message-ID: <20261128151348.1410275-1-hexlabsecurity@proton.me>
In-Reply-To: <3b16c6c2-7bf1-4261-9c0c-abc56aa6d608@linux.ibm.com>
References: <20261114-b4-disp-4e6374c2-v2-0-3b7050bddef7@proton.me> <20261114-b4-disp-4e6374c2-v2-2-3b7050bddef7@proton.me> <3b16c6c2-7bf1-4261-9c0c-abc56aa6d608@linux.ibm.com>
Feedback-ID: 199661219:user:proton
X-Pm-Message-ID: aba3765298940a73bf8eb074a709baca595bd67d
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

On Thu, 19 Nov 2026 12:25:12 +0530, Sidraya Jayagond wrote:
> I don't see what this branch buys us on this path. The link group is
> already off its device list here, so no new connection can join it and
> take the pooled DMB, and __smc_lgr_free_bufs() unregisters anything left
> in lgr->rmbs[] at teardown anyway, neither race from the commit
> message can happen on this path.

Agreed, the unregister buys nothing there. v3 [1] drops it and leaves
that DMB to the link group's free.

> Could you point at the path that dereferences conn->rmb_desc after
> smc_conn_free(), or drop the branch before it goes to stable?

A client that calls connect() again on the same socket. When the
handshake fails with a negative code the socket stays in SMC_INIT, and
a later connect() runs the handshake again with the same
smc_connection. conn->rmb_desc is still the first attempt's: always on
net, and with 2/2 when that attempt was freed with its link group
already off the list. If the retry then cannot allocate its RMB,
smc_conn_free() runs in the new link group with that pointer:
smc_ism_unset_conn() reads it and smc_buf_unuse() acts on it. On net
smc_buf_unuse() then zeroes the freed buffer, 65568 bytes in the test,
and clears ->used in the freed descriptor. With 2/2 and the pointer
left set it unlinks and frees the descriptor.

Measured on the loopback device with KASAN kernels and a non-blocking
connect(): the second call returns ECONNABORTED and the third runs the
handshake again. Three test knobs force the steps: the negative return
of the first attempt, its link group terminated before the attempt is
freed, and the failed RMB allocation of the retry. With
kasan_multi_shot, net gives five UAF reports, the first in
smc_ism_unset_conn(), and falls back to TCP. v1's 2/2, which had no
branch, gives five as well, the first in the same place, then a GPF in
smc_conn_free(), and close() hangs. v2 is clean, and so is v3. I
haven't found a way to get there without the knobs.

So v3 keeps only the clear on that path, WRITE_ONCE(conn->rmb_desc,
NULL), and the commit message says what the retry does with the
pointer. v6 2/3 of the CDC receive ordering series [2] clears both
pointers in smc_conn_create(), which closes the stale use on net too;
2/2's clear is there so that this path doesn't need that patch in
stable.

[1] https://lore.kernel.org/all/20261128-b4-disp-2c190c90-v3-0-c566f64196c8=
@proton.me/
[2] https://lore.kernel.org/all/20261112-b4-disp-1c8d3a53-v6-0-36a38ae35021=
@proton.me/

Thanks,
Bryam

