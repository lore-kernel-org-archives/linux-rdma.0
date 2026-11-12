Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794443463;
	b=S9mhwcPrnaJnc/d0zvlZFYpB4WpAeJGUvFBjEjpPDVpVTbYJjzN30TQXOlW6/ndhy+Nj
	 ro6qgWEWJ9evzDl7aqZuiqqQqYAYheQqyxkEpHbuRo1I5Eu63oPPYv6oW7Og5A6qDd7fW
	 Ag4KUixeKvvB5n8pVkFQN+P5hStBiNXRV5OE3J4SVBT6lWKGs63106NL45TTFZGy/CKe6
	 2avDlYWlb+ZD3B7HzxQDAIWGlgGiRAPitZuCvI+M2Rcl5lfhh2FGGNWdwo9JeLpLduHLh
	 K/QUUlVplv7qIxcjxGsUHfqRvQWPPU1xx7Q0bPhHq+u/sFQ82nT5jzDrq6CWhwhWp+A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794443463;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=ZHyLXuhe5ofRYJlg+EXjzikm84t9XgGRKPY+j0e1VOQ=;
	b=n4tj33FdqSlFhX4+xGvnRe1OrK44AbnONQM52HGGeMOLcCJj8N6TrgOZ4GgVzE9lXXKi
	 zUxYkMEdYXjcf96cYwNrUCJCGsgZZNIHWRfFiRAoOeh6Vm25QJ9/GMeT5vxBZdrsFW35l
	 vM1mVZ04kJKpYPnePhUWzamEVJz3WCgQfxVeaoKwqph9arJIdNpqTqbvRBwpfeSzzJPS+
	 WhGqlLPBAmfglnPhaVycBlWXfbnAhDyI4b1GSMNs6wdvIPK5bHuPPa7QvIeisjJR81fm+
	 gOYghKisEts0h4fANV8RVf/suRAgIPnPJituC1D+JZuZGlu3lJmfVp4tGW0bFVsUEXQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JY7thy48;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42EA1606A880
	for <linux-rdma@vger.kernel.org>; Thu, 12 Nov 2026 00:31:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JY7thy48
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2C961F00A0A;
	Thu, 12 Nov 2026 00:31:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794443463;
	bh=ZHyLXuhe5ofRYJlg+EXjzikm84t9XgGRKPY+j0e1VOQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=JY7thy48nOaqk7Vc+U0ohydUP4d5OfmXCF0d646zlu+rvvyoVo5gsZiY0UPkMsgLx
	 UY3NFDT7efjNujDxIkps0269vIa8XFzQUkiXWfcmPc0hpmO9g50ZZ7KHKDbDQSw+v3
	 kPdX+SHWGzq7TGd+we3ma2ONAJJjtNxlAxZCmmHmr4SNYe/8rBI62W/HUtegKp6L3l
	 q1Vuqu+U6i8tCtBvS9dwMOtWI90eH7dGB/LmPOUESm/dYWpSLb0HJJwYLLoG01lWaF
	 ud2mBmfsxFg31gMSn5MmozuLRwhMCqpIGIZXyiyqkMvbMpVsSHKweyP/R+ap+Kt6IB
	 6k4oXOsrJ83Zw==
Message-ID: <sashiko-outbox-209931@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net v5 7/8] selftests: drv-net: psp: test that ipv4 psp
 packets aren't fragmented
Reply-To: sashiko-reviews@lists.linux.dev
To: "Todd Freed" <toddfreed@meta.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261111001831.3710881-8-toddfreed@meta.com>
References: <20261111001831.3710881-1-toddfreed@meta.com>
 <20261111001831.3710881-8-toddfreed@meta.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 12 Nov 2026 00:31:02 +0000
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
- [Low] selftests: drv-net: psp: open-coded ctl_file_write() in
  data_send_ipv4_frags()
--

commit f2ab5974348f0d91190d725cd849415716fc0e2e
Author: Todd Freed <toddfreed@meta.com>

selftests: drv-net: psp: test that ipv4 psp packets aren't fragmented

This commit adds a selftest verifying that IPv4 TCP packets on a PSP
socket that exceed the device MTU are dropped rather than fragmented and
sent unencrypted.

> diff --git a/tools/testing/selftests/drivers/net/psp.py b/tools/testing/s=
elftests/drivers/net/psp.py
> index 7e251439a2fd9..5dac62ad96b0b 100755
> --- a/tools/testing/selftests/drivers/net/psp.py
> +++ b/tools/testing/selftests/drivers/net/psp.py

[ ... ]

> @@ -799,6 +801,105 @@ def data_send_ipv6_exthdr(cfg, opt, val):

[ ... ]

> +def data_send_ipv4_frags(cfg):

[ ... ]

> +    # With MTU probing on, TCP caps the MSS at the probing base, whatever
> +    # the route MTU
> +    probing_path =3D "/proc/sys/net/ipv4/tcp_mtu_probing"
> +    with open(probing_path, encoding=3D"utf-8") as fp:
> +        probing =3D fp.read().strip()
> +    if int(probing) > 1:
> +        def set_probing(val):
> +            with open(probing_path, "w", encoding=3D"utf-8") as fp:
> +                fp.write(val)
> +        set_probing("0")
> +        defer(set_probing, probing)

[Severity: Low]
Could this use ctl_file_write("/proc/sys/net/ipv4/tcp_mtu_probing", 0)
from lib.py instead of open-coding the read, write, and deferred restore?

Also, only clearing tcp_mtu_probing when it is greater than 1 leaves blackh=
ole
detection (1) enabled, which can still enable MTU probing and lower the soc=
ket
MSS during the 3-second s.sendall() timeout window if retransmissions pass
tcp_retries1.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261111001831.3710=
881-1-toddfreed@meta.com?part=3D7
