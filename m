Received: from mail-43101.protonmail.ch (mail-43101.protonmail.ch [185.70.43.101])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE07E3A5E9F;
	Tue, 28 Jul 2026 17:26:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.70.43.101
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785259574; cv=none; b=Nd3vVDBT8f1tjc2Tle4+VCrvci7hdDViBf2AKoiMbweeboikHK1Oup/K4Vfh2rqy61Foi3WyqpwjCHUXspCyp+Qs4ntSYPTPgLmhEG6fhD0KhWinIhTwnOtpPZ4/fwci/gLfB7a4zUiPyfuuJmpOA4Aa4xcj3/HTaGTetQ+Mb1E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785259574; c=relaxed/simple;
	bh=q28Sr1aNpbsBs6vn67MJSp6jSWn48v1duQoJS5RjksU=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Ag89MTZOX4QvMpTVmhxsVmdAtFw+2XVanqMWvDp+g1Rsxy1WMHaX7m8R8XhzXlMx1FUFWnMpSz+yVymHVuFDz8Z7DN8cAP7nWlRq2ObbA4IfxJWUN+2lEkNe5Nsanj/hAhizg1zb2IfK1k2Xux7fNxdF3ulLoQWHG/vrjdXdyK0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=proton.me; spf=pass smtp.mailfrom=proton.me; dkim=pass (2048-bit key) header.d=proton.me header.i=@proton.me header.b=fYJr31Ku; arc=none smtp.client-ip=185.70.43.101
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=proton.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=proton.me
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=proton.me header.i=@proton.me header.b="fYJr31Ku"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=proton.me;
	s=protonmail; t=1785259563; x=1785518763;
	bh=q28Sr1aNpbsBs6vn67MJSp6jSWn48v1duQoJS5RjksU=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector;
	b=fYJr31KuQPEOXsEGr8rpi4/VpW52ZyBXhk5NhDRhXpNXZX/f0PFb+GgkUX4la7v0I
	 zFtcBxw/RhN2hG24Uml428yng+8DuF2oZx2bs/97/VCtNaqj9D5/cWFnHe3aM/ndSP
	 dpC6yPkBbWHENo8/MRmn8A5fx3hmgavrmGJm04zPFbeifTOQHYnBfSTbG83MGQhewm
	 KX+ZRXFXNPHJ4IewkSQSNbf+cXBULAJyingI4zYNJxxiMMcRh6XR4TX2zkugyCxUo1
	 AW/HshI7+ZX8sEPliQyU8mw70NcJ9u8mrt2MX+S/4U9PAtb/H8x5RldsrJe7t1CVfE
	 dWTUP1Tzs/+0w==
Date: Tue, 28 Jul 2026 17:25:59 +0000
To: Paolo Abeni <pabeni@redhat.com>
From: Bryam Vargas <hexlabsecurity@proton.me>
Cc: Sidraya Jayagond <sidraya@linux.ibm.com>, Jakub Kicinski <kuba@kernel.org>, "D . Wythe" <alibuda@linux.alibaba.com>, "David S . Miller" <davem@davemloft.net>, Wen Gu <guwen@linux.alibaba.com>, Wenjia Zhang <wenjia@linux.ibm.com>, Eric Dumazet <edumazet@google.com>, Tony Lu <tonylu@linux.alibaba.com>, Mahanta Jambigi <mjambigi@linux.ibm.com>, Dust Li <dust.li@linux.alibaba.com>, Ursula Braun <ubraun@linux.ibm.com>, Stefan Raspl <raspl@linux.ibm.com>, Simon Horman <horms@kernel.org>, linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net v5 1/3] net/smc: bound the wire-controlled producer cursor to the RMB
Message-ID: <20260728172552.69349-1-hexlabsecurity@proton.me>
In-Reply-To: <4b5f67a2-5624-4adb-812a-bd87d99416ed@redhat.com>
References: <20260723-b4-disp-0d07164f-v5-0-6a9e235dbc4e@proton.me> <20260723-b4-disp-0d07164f-v5-1-6a9e235dbc4e@proton.me> <4b5f67a2-5624-4adb-812a-bd87d99416ed@redhat.com>
Feedback-ID: 199661219:user:proton
X-Pm-Message-ID: 00f4050115f71b32b665beecb2c12776f51a9507
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Tue, 28 Jul 2026 15:50:02 +0200, Paolo Abeni wrote:
> Sashiko gemini suspects the above may cause a Null ptr dereference:
>
> https://sashiko.dev/#/patchset/20260723-b4-disp-0d07164f-v5-0-6a9e235dbc4=
e%40proton.me

The window is real, but this patch doesn't open it: the same load is alread=
y
on that path.

smc_cdc_msg_recv_action() dereferences conn->rmb_desc->len unconditionally
at smc_cdc.c:376, and nothing between the conversion call at :339 and that
line can return early, so every CDC that reaches the conversion reaches the
existing dereference as well. The patch moves the load about 37 lines up
inside the same function; it doesn't add an execution that touches
conn->rmb_desc. On SMC-D the existing one comes first anyway --
smcd_cdc_rx_tsklet() reads rmb_desc->cpu_addr at :452 before it calls
smc_cdc_msg_recv() at all. Line numbers are against net/main at
e095f249e220.

What the bot is pointing at is a separate defect. smc_conn_create() puts th=
e
connection in the link group's token tree before smc_buf_create() allocates
the RMB, so a CDC arriving in that window finds a connection whose buffer i=
s
still unset -- with or without this series. That one is fixed by [PATCH net
v4] "net/smc: order the CDC receive path against buffer publication", which
publishes the buffers with smp_store_release() once the receive state is
initialised and makes the CDC entry points bail while they are unset:

https://lore.kernel.org/all/20260728-b4-disp-52ee4e7d-v4-1-0dda94b0f397@pro=
ton.me/

Thanks,
Bryam

