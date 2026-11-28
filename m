Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=185.70.43.102
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795881257;
	b=F4H6vmDw3xxfljc1I00wmKPnXoDWGHc7gQEpN+9Aj1ANJgN73MKni5YE9SEleCGHv8Bn
	 F78RBQpk2Hm4WKMZo9suEG4fQJ42PG56lybOiQh/wP+Eg30KPCqabvbHzpg50JPry6tkV
	 0jDMDgKnuGeksOI4CEIVcMKygezT5njPTT2ncCoaCY9gY1GFhuO+5CeAZJJqcqk1JosD2
	 aSY99VVPod4SRLzAQkZwp8ThrU18boCUp3nJc6Do+0FCLYkJTpdFj424jR+v1+KPaQ16V
	 fr+8uFzqkEQ908j09d3ERoJhtMDWlv2XBJH3q4EpFISHkZtQtz4huKi/7NlYyjXcPrw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795881257;
	h=DMARC-Filter:DKIM-Signature:Date:To:From:Cc:Subject:Message-ID:
	 In-Reply-To:References:Feedback-ID:X-Pm-Message-ID:MIME-Version:
	 Content-Type:Content-Transfer-Encoding;
	bh=orAW4VA6gXoOYwjgpOWFb0op6zmUyN/G4uA/CQXph88=;
	b=hHANI0MA2IQicv7zTVFhiuuGUyhu3/OR3D+kxJQ5U3U/006+/i+uPqo5PPQwQ/ZfZ0rP
	 LUbIdMpNFmlFB9co8GPl6IJ6dc89KFiQJbSLGaLaJ8L350sZbTMnQ5z3RiKamhhaDgyCt
	 Vu6sh+RG7okibzqnZcb+tnkUdd0FY0JIsZeoSXOItBPBG5nHQuRAS2Wm6O303KMmnuBDz
	 igWJcQxWMuwKW+UMIaHUpOOVILjQJad2HgbmyaelAq05zGZT33MvxRve9OIKXlDuPxlfw
	 5UvMBcYiEkNHAWpcPAyaA2MJLF7VStnzNghU4qN94RdjOBAGCYQtXjT7rsJD8hxKOKw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=proton.me;
	spf=pass smtp.mailfrom=proton.me;
	dkim=pass header.d=proton.me header.i=@proton.me header.a=rsa-sha256 header.s=protonmail2 header.b=KG9nNg7e;
	arc=none smtp.remote-ip=185.70.43.102
Received: from mail-43102.protonmail.ch (mail-43102.protonmail.ch [185.70.43.102])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D51DF606A31C
	for <linux-rdma@vger.kernel.org>; Sat, 28 Nov 2026 15:54:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D51DF606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=proton.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=proton.me
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=proton.me header.i=@proton.me header.a=rsa-sha256 header.s=protonmail2 header.b=KG9nNg7e
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=proton.me;
	s=protonmail2; t=1795881254; x=1796140454;
	bh=orAW4VA6gXoOYwjgpOWFb0op6zmUyN/G4uA/CQXph88=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector;
	b=KG9nNg7eIsyEB56GwR/MwAGEFPbmn2vqbmAvep2ujySievDjG1yx+/z4zhhawEXEn
	 GREUAvLop5ndNRxXibPy5apzP87h62OFOju/Tcg/ZYS48q4OT5OKmMdUxNCLbMGXiP
	 cG6iUZZ7ER4YkaILn67Gj5IudkWIKT4FstLGpYUqKZdtX7ooYjQnmWtDjbsqlc8QHY
	 yST8TMZQcN4mXCc6pCH261blCOu5lWKMfhW1wDmqi7fxAwVMFbVcLHmZVa0iQ8YfF+
	 VFH8Eo3B8T/84fLsPhJU4tCWpaK9R9/b0eP657M6YIc3pihJQN+ovm2uGH58t+jBHq
	 O6/vgCndB+GkA==
Date: Sat, 28 Nov 2026 15:54:10 +0000
To: netdev-bot+sashiko@kernel.org
From: Bryam Vargas <hexlabsecurity@proton.me>
Cc: Mahanta Jambigi <mjambigi@linux.ibm.com>, Jakub Kicinski <kuba@kernel.org>, Dust Li <dust.li@linux.alibaba.com>, "David S . Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>, Sidraya Jayagond <sidraya@linux.ibm.com>, Paolo Abeni <pabeni@redhat.com>, "D . Wythe" <alibuda@linux.alibaba.com>, Hans Wippel <hwippel@linux.ibm.com>, linux-kernel@vger.kernel.org, Wenjia Zhang <wenjia@linux.ibm.com>, netdev@vger.kernel.org, Hidayath Khan <hidayath@linux.ibm.com>, Ursula Braun <ubraun@linux.ibm.com>, Tony Lu <tonylu@linux.alibaba.com>, linux-rdma@vger.kernel.org, Wen Gu <guwen@linux.alibaba.com>, linux-s390@vger.kernel.org, Simon Horman <horms@kernel.org>
Subject: Re: [PATCH net v6 3/3] net/smc: skip the DMB nocopy accounting until the send buffer is set
Message-ID: <20261128155407.1427708-1-hexlabsecurity@proton.me>
In-Reply-To: <179487758596.3136.12928828467382443502@kernel.org>
References: <20261112-b4-disp-1c8d3a53-v6-3-36a38ae35021@proton.me> <179487758596.3136.12928828467382443502@kernel.org>
Feedback-ID: 199661219:user:proton
X-Pm-Message-ID: cd7fbe08df8e0d49868652c7f51bf9d63e36efaf
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

On Tue, 17 Nov 2026 01:06:25 +0000, netdev-bot+sashiko@kernel.org wrote:
> - [High] The new NULL check only covers the time before
>   smcd_buf_attach().

Yes. 3/3 removes the NULL deref and nothing else. The cover has the
rest as the second item under "Not fixed here": the old peer's CDCs are
still applied to the new connection, and once the sndbuf is attached
they add to its sndbuf_space. They can also close it during its
handshake, as the cover says. The MSG_OOB wait you describe follows
from the consumer cursor they leave in the connection; by inspection,
not run. 3/6 of the cursor series [1] keeps the send() copy inside the
send buffer; it doesn't correct sndbuf_space.

> - [Medium] The patch stops the NULL dereference, but it keeps processing
>   a CDC that, by the patch's own new comment, can come from the old peer.=
..
[...]
> Is that comparison accurate? A CDC that leaves the consumer cursor alone
> does not create a cons/tx_curs_fin mismatch.

Right, it isn't the same. A consumer cursor that moved stays in
local_rx_ctrl.cons, and the new peer's updates are then measured
against it. The comparison holds only for the flags and the producer
cursor; the code does not depend on it.

> A CDC that moves the consumer cursor before smcd_buf_attach() cannot come
> from the real peer. That is the reasoning behind "Nothing of ours can hav=
e
> been consumed before the attach".
>
> Would it be better to drop such a CDC, or to stop reusing a DMB that a
> previous peer can still signal, instead of applying part of it?

Stop reusing it. That is a series of its own [2]: it stops pooling
DMBs on nocopy devices, so the next connection gets a new DMB and
token. Measured on the loopback device, 8 reuse rounds: on net, the
old peer's CDCs reach the new connection every time; with v3 of [2],
none does. With it on top of this series, no test reached 3/3's skip.

Dropping covers less. Before the attach, a CDC that moves the consumer
cursor is known not to be the new peer's, and could be dropped whole
(by inspection, not tried). The rest looks like the new peer's: the old
peer's CDCs that leave that cursor alone, with its flags and its
producer cursor, and all it sends after the attach. An SMC-D CDC has no
token and no sequence number, and smcd_handle_irq() finds the
connection by the DMB alone.

[1] https://lore.kernel.org/all/20261112-b4-disp-0287c16e-v9-0-e5e8fa688177=
@proton.me/
[2] https://lore.kernel.org/all/20261128-b4-disp-2c190c90-v3-0-c566f64196c8=
@proton.me/

Thanks,
Bryam

