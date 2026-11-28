Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=185.70.43.103
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795881249;
	b=TvQryoWy9Q/IBGyCULAHWAkSuq4GjBnQrPJCEL5wH+6eFvX+fmyRGYuxl0YBHEVlxeQZ
	 j2NEdHKT3a2D6FBo2IYOsJVrzIiehRzvILC931wz7AMwMYRNu/xsRYG5seHL+SxsnjnjK
	 ieBeXrmD1zai+OqqVuQuvmtPk06IHGLbmMODZkppBGSW20eAw2MAHCiqzYWoaokRz0JZd
	 dZCXnLjyBM9TNoCjcq9sMFSPHKhRALarQcG7GQCXRMJyqcCSBMhNWHhRKN23UCpRHt9y3
	 Cpy3GpBIz8VKzWvaMWyn+p/xATp4ktx+ucTbxzLYLJu3ezu/+H2S+mxnmvsjmdGMg+A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795881249;
	h=DMARC-Filter:DKIM-Signature:Date:To:From:Cc:Subject:Message-ID:
	 In-Reply-To:References:Feedback-ID:X-Pm-Message-ID:MIME-Version:
	 Content-Type:Content-Transfer-Encoding;
	bh=GEkTsONajPK1Co5cTsiFpwumQqUlmxmI4EKz6faDMnM=;
	b=pfUowrT7Hm1n//p1ieigTVPYqfIpfO7zhFZ3FLysyVEUH78fDCy9kgXgJSw7/6EJqYyv
	 E17liSbqbMaGdDWlVz0+3sCWunBM4DbidnUl7Ijg89IFTbsKNnmVi7DhnZI+7zMwE77hx
	 CK7Yy/25rKcHOLY0YdxrilG+R5SQATQONk99g4mymt/cH38ddQ1maBpHIzTar37HQH/tw
	 KLQ3ohKun7ULtckdSUP0FplNr6hnC5GOlqI39KEfZXyVp8WNuDhe3BdWGQsR1nyMMpl92
	 SzupKxRt7NAA7tM2Hux43Ozi5/9Ho8cTX2pBP3FPHSZvJnlgAdNWHEqdcvkaiN9yYvg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=proton.me;
	spf=pass smtp.mailfrom=proton.me;
	dkim=pass header.d=proton.me header.i=@proton.me header.a=rsa-sha256 header.s=protonmail2 header.b=Mbz5++10;
	arc=none smtp.remote-ip=185.70.43.103
Received: from mail-43103.protonmail.ch (mail-43103.protonmail.ch [185.70.43.103])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2C4A606A31C
	for <linux-rdma@vger.kernel.org>; Sat, 28 Nov 2026 15:54:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org F2C4A606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=proton.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=proton.me
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=proton.me header.i=@proton.me header.a=rsa-sha256 header.s=protonmail2 header.b=Mbz5++10
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=proton.me;
	s=protonmail2; t=1795881245; x=1796140445;
	bh=GEkTsONajPK1Co5cTsiFpwumQqUlmxmI4EKz6faDMnM=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector;
	b=Mbz5++10plNkTNAPwnSorYwRzxJCNns6mJMPhAE/A2wbh966iPwBOglAfjmQNVbNS
	 Nh2GjAYgouzTX9785xvXjhr8rjn0+rtZ+4g5edPYeuOfZtHDKmk6WIc1/yKM6hVjBQ
	 JNHjiHoLa9cWYO3zIq4vncxruUaDeMxCczbZYb1GXqqO8S2KbmWYziSeAR1HoZFAo4
	 KS/JmSrObkAOTghqlbPWZ9tMy0keVRSx5KMKg4hzJj+rN0lC/8I1+qs15NjDvmg5ZT
	 nxadbiLDqm90U5hFh7XFzi9B3ghbz7s7p/vflMMBG6ICEcNswFUa22db6dtZhWOvbH
	 kWpspl6BQrbKQ==
Date: Sat, 28 Nov 2026 15:53:56 +0000
To: netdev-bot+sashiko@kernel.org
From: Bryam Vargas <hexlabsecurity@proton.me>
Cc: Mahanta Jambigi <mjambigi@linux.ibm.com>, Jakub Kicinski <kuba@kernel.org>, Dust Li <dust.li@linux.alibaba.com>, "David S . Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>, Sidraya Jayagond <sidraya@linux.ibm.com>, Paolo Abeni <pabeni@redhat.com>, "D . Wythe" <alibuda@linux.alibaba.com>, Hans Wippel <hwippel@linux.ibm.com>, linux-kernel@vger.kernel.org, Wenjia Zhang <wenjia@linux.ibm.com>, netdev@vger.kernel.org, Hidayath Khan <hidayath@linux.ibm.com>, Ursula Braun <ubraun@linux.ibm.com>, Tony Lu <tonylu@linux.alibaba.com>, linux-rdma@vger.kernel.org, Wen Gu <guwen@linux.alibaba.com>, linux-s390@vger.kernel.org, Simon Horman <horms@kernel.org>
Subject: Re: [PATCH net v6 2/3] net/smc: clear the buffer pointers before registering a connection
Message-ID: <20261128155344.1427660-1-hexlabsecurity@proton.me>
In-Reply-To: <179487758425.3136.7345936021290037161@kernel.org>
References: <20261112-b4-disp-1c8d3a53-v6-2-36a38ae35021@proton.me> <179487758425.3136.7345936021290037161@kernel.org>
Feedback-ID: 199661219:user:proton
X-Pm-Message-ID: f069d12f754163e21e81426a8fb11fe95c985d89
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

On Tue, 17 Nov 2026 01:06:24 +0000, netdev-bot+sashiko@kernel.org wrote:
> - [High] This patch still leaves rmb_desc and sndbuf_desc dangling while
>   the connection can be found by its token.

It does, and the cover says so: it's the first item under "Not fixed
here". A handler still runs on the released RMB if it found the
connection before smc_conn_free() unregistered it. That predates this
series, and it's the window Weiming Shi's patch [1] is about.

2/3 is for another case, the retry that registers the connection again
under a new token with the pointers from the failed attempt still set.
A CDC with the new token then finds them at any time, with no race
against the release. The note under 2/3 ("a pointer seen set stays
set") is only about the pointer not going back to NULL under the lock;
it says nothing about who owns the buffer.

> Could the pointers instead be cleared under the slock where the buffers
> are released, in smc_buf_unuse()/smc_conn_free()? Or could the token be
> unregistered before the buffers are released? Either would replace the
> clear in smc_conn_create() rather than add to it.

Not with a clear in smc_buf_unuse(): smc_conn_free() skips it when the
link group is already off its list, so the pointers stay set on that
path and a later retry registers them again. Unregistering the token
first clears nothing. Every registration goes through
smc_conn_create(), so the one clear there covers them all.

A clear in smc_conn_free() itself is different. Under the spinlock,
before the buffers are released and on every path through the
function, it would do what the clear in smc_conn_create() does. A
handler that takes the spinlock after that clear would also find NULL
at the check 2/3 adds, which closes the window above for that handler.
By inspection; not written or run.

2/3 keeps its clear in smc_conn_create(). That is enough for the retry,
and the window above is left to [1].

The two cases you list, is_reg_err set or not, are the ones the cover
measured: after the negative CONFIRM_RKEY, the descriptor is back in
the pool and the forged CDC runs on it; after a failed MR registration,
KASAN reports the UAF. Both with the retry; without one, i.e. the
window above, nothing was run here.

[1] https://lore.kernel.org/all/20261021171256.166870-2-bestswngs@gmail.com=
/

Thanks,
Bryam

