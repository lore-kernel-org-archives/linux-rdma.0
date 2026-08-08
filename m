Received: from mail-43102.protonmail.ch (mail-43102.protonmail.ch [185.70.43.102])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77D5C395276;
	Sat,  8 Aug 2026 06:29:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.70.43.102
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786170552; cv=none; b=AbWBK/kWQMiev6GE3VK3FTttwaifS1QwZiDFj/XydeJdKNXaVR4ksQiUS02J2ekseqIOAJe3+rpKpBQm/wow6gIC6vTdnuxJmbfAS4kCJKaYptqOSZ4ZuJGqk6VgEwRx9ImHs+V74SWdWdVAhLQz+632ywfjl0FNffcpAkGCxnA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786170552; c=relaxed/simple;
	bh=nhBrPUV+XP2b/6IA3B+Q6UcuPDU/1y+Wtbcu0Kh591g=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cCHbl4mPAWFsvAQebmG97t5iOiA/dGQPpm1+dfKQJFYz7U1hV+dCAAnDIlpACc/OUhDpixn1HuIMZ5eEKov7QvhopKyqdZThQCp49kTYl2VHZ1NwoTzJMXRZjSPghZUGXBRSFNo3FXmcuqrLuub/Nu5L0spB6cmbxqiEUPOPVZg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=proton.me; spf=pass smtp.mailfrom=proton.me; dkim=pass (2048-bit key) header.d=proton.me header.i=@proton.me header.b=Ow2BjcjK; arc=none smtp.client-ip=185.70.43.102
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=proton.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=proton.me
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=proton.me header.i=@proton.me header.b="Ow2BjcjK"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=proton.me;
	s=protonmail; t=1786170538; x=1786429738;
	bh=qsrxYgXmkdW1UwIfKgO2peaMqKoi3mAQHZQNaJ/u4no=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector;
	b=Ow2BjcjKo/VqAflsTslI6onvwhUHZIfegSUCmxKFnb7ykP9LvKv12YdLjJGpD6bea
	 y/f1ds08lplbT83kQR1gXhw8/4whgz6/EwzRmmqHrk+AGeYKoc5yzXuT9J3/2B9bKX
	 1jO3QmNbgL1BXoQ3v/1GaoTVPPnBWEFYYtoEXCPfiDD6TnMQ2m4BvWP8Px28wWpoYA
	 JnNfyE45GCKlqd6L1s3pxX0aIXcTHpS/0mZxQ088almwbvdN1N2+NSwUVAcwU9vTad
	 ZLMxMgzpV+QhwqYWQbdyFjKjSDDSecnZmdrZgK1rO595ie7kORO3yeOdjC0KSGWvQu
	 D26N/CiaTUBDA==
Date: Sat, 08 Aug 2026 06:28:54 +0000
To: Dust Li <dust.li@linux.alibaba.com>
From: Bryam Vargas <hexlabsecurity@proton.me>
Cc: Wenjia Zhang <wenjia@linux.ibm.com>, "D . Wythe" <alibuda@linux.alibaba.com>, Sidraya Jayagond <sidraya@linux.ibm.com>, Mahanta Jambigi <mjambigi@linux.ibm.com>, Tony Lu <tonylu@linux.alibaba.com>, Wen Gu <guwen@linux.alibaba.com>, Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org, linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] net/smc: drain the rx tasklet before detaching the ghost sndbuf
Message-ID: <20260808062847.375972-1-hexlabsecurity@proton.me>
In-Reply-To: <amnL-DjPaTQyOXT1@linux.alibaba.com>
References: <20260726-b4-disp-a135b4e5-v1-1-705aaec79986@proton.me> <amnL-DjPaTQyOXT1@linux.alibaba.com>
Feedback-ID: 199661219:user:proton
X-Pm-Message-ID: c8faf2aee8e5d8d797c32779029c1af836057b14
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Dust,

> I think Sashiko's review makes sense. Your change doesn't seem to fully
> eliminate the race here. I'm wondering if this should be solved with
> RCU rather than just moving smcd_buf_detach() later?

You're right, it doesn't. I built both shapes and measured them on an SMC-D
loopback rig. "path" is connections reaching either teardown site with the =
link
group already unlinked, "armable" how many of those still had both gates in
smcd_handle_irq() open when the drain returned, "re-armed" the device armin=
g
the tasklet again afterwards:

  form                                   path  armable  re-armed
  upstream                                169       73        29
  v1 (drain, then detach)                 172       78        33
  unregister first, then drain             31        0         0
  v1 + RCU                                 24        9         3

Two things about that table before you read anything into it. The last two =
arms
ran much shorter than the first two, so the ratios are the comparable part,=
 not
the absolute path counts. And the third arm also forced tasklet_kill() in t=
he
!soft path; that was inert here because smc_lgr_terminate_work() passes
soft=3Dtrue, but it wasn't only the unregister.

The reorder leaves the window open because smc_conn_free() calls
smc_ism_unset_conn() only while the link group is still on its device list,
and smc_lgr_terminate_sched() unlinks it before the worker kills the
connections. It never sets conn->killed either, so both gates stay open acr=
oss
tasklet_kill().

RCU does not close it. smcd_buf_detach() frees the descriptor and clears th=
e
field, and RCU defers only the free -- the re-armed tasklet still runs and
still finds conn->sndbuf_desc NULL. RCU on the descriptor would still be a
reasonable thing to want for the free itself; it just isn't what shuts this
window, so I didn't fold it in. Say the word if you want it anyway.

v2 unregisters unconditionally before the drain, and clears conn->sndbuf_de=
sc
before freeing it so a reader that samples the pointer can't get a freed on=
e.
It carries a second patch for a dereference the same teardown reaches:
smc_close_stream_wait() calls smc_tx_prepared_sends() from inside
sk_wait_event(), which evaluates its condition once with the socket lock
released. SIOCOUTQ reads the field by hand, so that one is bounded too.

Thanks for catching it.

Bryam

