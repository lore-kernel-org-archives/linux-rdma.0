Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E1E73B5DED
	for <linux-rdma@vger.kernel.org>; Wed,  9 Sep 2026 06:55:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788936948; cv=none; b=Ozkow64OEdhCNYRDqPLewCtteiCoBqD/zGyPHvZ7pZBJ7irMRuKrwRRdGzAHruIddMI1B/aaFWuHEStzTTgGVdycivx/gj7UQW38K+yplmnObvgzPIXluKLD8w0r9qiH60eaLluEq04I6q4qfFd1n3Ucmzzev+hGuBE0sLrme5s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788936948; c=relaxed/simple;
	bh=Bz3YwL0chaCMBnCDEopPF1C6U84WHmBwKmy+OsoWE0w=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=uoKpcnmw2LSUy0ddMv1rgZgf6TCfo4/A16xgOd9y1zRxo9rQezTTd2gNhpbBx/WMpR1zaTeeV8DP323m6wwxSwCdUWDMevyTYDAMx+OHwPE9H8adLe1ws6QY9YZDaMSv44lLSKxlWsKQYmPNMz60qmYDkPNkJHUFbIdV/HTlJtA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lAnjPgf3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lAnjPgf3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD2C91F00A3F;
	Wed,  9 Sep 2026 06:55:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788936947;
	bh=4Wz5r3bkovseDZXXE/3vCh6AS15KQiCU/AZXL0MyQ30=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=lAnjPgf3oATisdkW3y9sir/Yc/vSaGfL+jcwt+Sbdn5NqDoPAKFfaCNPGXLU0s82T
	 vxktN/DG7UV/CdDlL+U+QqXopOZHI6hOeXxttY9Q2GOhDT4zlM0uxX1GJEUZdHew49
	 7ikuiiWyKoBYkCoazRHO09aAd5cWjYDDfr1QjJshJm3lXJp7SzpTKHNKEQ5lULMs76
	 hIQvPTF2nA7nuzRgwvC9hp9cT64Scfm89OSmm1QDGMsxQ6UzYuCIkqvyhoLHFCXlqC
	 s7tUFqIJWu5wt7Nre0qMzqwrd5wsLc+X7u/5Eb3sFwN6ob7jXyrwK2zXb/9zec3qjb
	 AsdST9Dkm53xg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next V4 14/14] selftests: drv-net: Add PSP HW GRO
 conformance tests
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tariq Toukan" <tariqt@nvidia.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260908065244.3799142-15-tariqt@nvidia.com>
References: <20260908065244.3799142-1-tariqt@nvidia.com>
 <20260908065244.3799142-15-tariqt@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 09 Sep 2026 06:55:46 +0000
Message-Id: <20260909065546.DD2C91F00A3F@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [Medium] Hardcoded PSP versions [0, 1] in test_psp_ver_diff instead of dy=
namically using supported capabilities.
- [Medium] Unconditional creation of AF_INET6 socket crashes on IPv6-disabl=
ed systems.
--

commit 2fbb01e97add94de0a14266aa0b2565a8246c7ea
Author: Cosmin Ratiu <cratiu@nvidia.com>

selftests: drv-net: Add PSP HW GRO conformance tests

This commit adds PSP conformance tests to kselftests using the gro helper
binary in --psp mode. The sender crafts encapsulated and SW-encrypted PSP
packets, and the receiver's device decrypts and decapsulates the packets
before an AF_PACKET tap gets to analyze them.

[ ... ]

> diff --git a/tools/testing/selftests/drivers/net/hw/psp_gro.py b/tools/te=
sting/selftests/drivers/net/hw/psp_gro.py
> new file mode 100755
> index 0000000000000..3a069c944ae1e
> --- /dev/null
> +++ b/tools/testing/selftests/drivers/net/hw/psp_gro.py

[ ... ]

> +def _psp_assoc(cfg, version=3D0):
> +    # This socket receives no traffic, exists solely to own the rx assoc.
> +    s =3D socket.socket(socket.AF_INET6, socket.SOCK_STREAM)

[Severity: Medium]
Will unconditionally creating an AF_INET6 socket here crash the test framew=
ork
with an OSError (EAFNOSUPPORT) on systems where IPv6 is disabled at boot?

If the test is running an IPv4 variant on such a system, should the socket
creation match the protocol family, or gracefully skip the test instead of
failing?

[ ... ]

> +@ksft_variants(_ip_variants())
> +def test_psp_ver_diff(cfg, protocol):
> +    """Frames from two different PSP versions must not coalesce."""
> +    init_psp_dev(cfg)
> +    if len(cfg.psp_info['psp-versions-cap']) < 2:
> +        raise KsftSkipEx("Device supports a single PSP version")
> +
> +    _run(cfg, "psp_ver_diff", protocol, [0, 1])

[Severity: Medium]
Could this hardcoded list of versions [0, 1] cause the test to fail on
devices that support multiple versions but do not support version 0 (for
example, if they only support versions 1 and 2)?

Since the test verifies len(cfg.psp_info['psp-versions-cap']) < 2 to ensure
at least two versions are supported, would it be better to dynamically pick
the first two versions from that capabilities array instead of hardcoding t=
hem?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260908065244.3799=
142-1-tariqt@nvidia.com?part=3D14
