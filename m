Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794445027;
	b=trdplw8tkxassCqx6KXv9mPXid6KUND++Ah+smftD8fUt8wDCuHzbl/EwMu/UYG4ltl5
	 wXLCndwnLhimzekg69Inh5sPVUCuuk79BxHmz7hAo0THPDvmWCSyzgbdAqAugQ0sdRqlJ
	 5flVMe3nWOYHLhtj7GCx0RWwJOWygT+CV9F6Z0+RmwDzD8zgD8m640/sSL9W1J/L6b2Rg
	 G8OJwffGFpbZtBxNqj2OJdqdlzXJogVbVA5/2ngGX0sNftymbb6SwDVjQ/XHP0dHNfeyt
	 m8eIsFBFkRqcFZmQTZ1Zv2ZGfXD8Uz07t1+sNMzgMOLG6CtZtjM0Prn5FKqssHbKAhQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794445027;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=ah8mYf3nPrmZ4NCAx1PwpSysRzTRnise90PwxwTqOas=;
	b=otTI9YSn8E51HAxVmdsTcpslqiDV8v1caWkAMRRjDZg6SyvBVIM05jOisF1DE/jZxChj
	 B0zu3IqZX9MY+tsc6Fsx/ptxCEnr9NLF7LDv7JjWzE9vRax2u9faZZUN7zsJCFrPPplNO
	 vBzQL6f30nhij8NbllLgwkYd9SfQvNTAMJ+3ymXR3chRDmGAiQm4maKmbxtjOi2GWrx9V
	 Ylo8LI8ZycmIfvTJukPUqq6piiYvln9JsnpHRWKzjsq9j8b35++dJ+2FmyNU3X210E12+
	 gDza80zAXrJrYHAvgQQP3844SXR6ZUamhMDmLNm1c1xw073JkzLxQ9CrbZf478mFcZQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=oWNHrYWj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4669606A335;
	Thu, 12 Nov 2026 00:57:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=oWNHrYWj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3386E1F00A05;
	Thu, 12 Nov 2026 00:57:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794445027;
	bh=ah8mYf3nPrmZ4NCAx1PwpSysRzTRnise90PwxwTqOas=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=oWNHrYWj6fIKyF4VJHEMW1tWrgKK4YmKQJa6MWjdA1GUuvyG5GSuheFF3AYfcvDQi
	 TkTvpwUPaxWZv1LUbbIpKUmHjU4XTLGfQpk3qufLbEVifC5M/BAYmlCUAjRC9Ixgay
	 Gbs3IF1izNLedtKOj6J/oGRWbRM8UujzfkaDcd9mShky0G0RGyHLOBVLaNLvNKxyjD
	 VmwXJKpNnWzxFVVOFj/7PncduJQgrMmPcGe9fyw1tP96Z8yv0bLo7+vx94m6pjPvbq
	 ashzwfo9KpBHyUJr3meFfHjLUiM2pVpZHqFxm7gqHM4sP6BkcdohL6zRwULY+TYEx/
	 ZNDshR9LV168w==
Message-ID: <sashiko-outbox-210014@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v1 11/15] selftests: drv-net: psp: test
 socket-less associations and the tc psp action
Reply-To: sashiko-reviews@lists.linux.dev
To: "Todd Freed" <toddfreed@meta.com>
Cc: bpf@vger.kernel.org, linux-rdma@vger.kernel.org
In-Reply-To: <20261111005533.6436-12-toddfreed@meta.com>
References: <20261111005533.6436-1-toddfreed@meta.com>
 <20261111005533.6436-12-toddfreed@meta.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 12 Nov 2026 00:57:06 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [Low] selftests: drv-net: psp: hand-rolled sysctl and polling helpers
  in psp.py
--

commit 97820709dd90b6f5b2af8e09b179cf5d698f9d28
Author: Todd Freed <toddfreed@meta.com>

selftests: drv-net: psp: test socket-less associations and the tc psp action

This commit adds selftests covering PSP socket-less associations and the tc
psp action for control and data paths.

> diff --git a/tools/testing/selftests/drivers/net/psp.py b/tools/testing/s=
elftests/drivers/net/psp.py
> index 473500901879b..fb75444100515 100755
> --- a/tools/testing/selftests/drivers/net/psp.py
> +++ b/tools/testing/selftests/drivers/net/psp.py

[ ... ]

> @@ -683,6 +685,591 @@ def data_mss_adjust(cfg, ipver):
>      _data_mss_adjust(cfg, ipver)
> =20
> =20
> +#
> +# Socket-less associations and the tc psp action
> +#

[ ... ]

> +def _wait_data_outq(s, exp_len, timeout=3D5):
> +    """ Like _check_data_outq() but leave time for retransmits """
> +    outq =3D 0
> +    end =3D time.monotonic() + timeout
> +    while time.monotonic() < end:
> +        outq =3D _get_outq(s)
> +        if outq =3D=3D exp_len:
> +            break
> +        time.sleep(0.05)
> +    ksft_eq(outq, exp_len)

[ ... ]

> +def data_tc_encap_ingress(cfg):
> +    """ Test packets with an assoc aren't redirected to ingress """
> +    _init_psp_dev(cfg)
> +    _require_tc_psp(cfg)
> +
> +    _, tx =3D _sockless_assocs(cfg)
> +    # Traffic to a local address leaves through lo, and comes back on its
> +    # ingress. With the dst gone, input routing takes a loopback source =
for
> +    # a martian, and needs accept_local for a local one.
> +    sysctl =3D "net.ipv4.conf.lo.accept_local"
> +    old =3D cmd(f"sysctl -n {sysctl}").stdout.strip()
> +    cmd(f"sysctl -w {sysctl}=3D1")
> +    defer(cmd, f"sysctl -w {sysctl}=3D{old}")

[Severity: Low]
This isn't a bug, but could data_tc_encap_ingress() use
ctl_file_write('/proc/sys/net/ipv4/conf/lo/accept_local', 1) from lib.py
instead of spawning sysctl subprocesses to read, write, and restore the
setting?  Similarly, _wait_data_outq() duplicates the polling loop in
_check_data_outq() and could parameterize _check_data_outq() or use
ksft_busy_wait().

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261111005533.6436=
-1-toddfreed@meta.com?part=3D11
