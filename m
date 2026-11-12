Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794445028;
	b=G+cTO4H1OPY1/M3KGEYknTmYKgHGg1LTTB6cabac6IIhsIgqpnfbqg92eMbpcfq8joXx
	 y3SSWhukNar4xvhmWVUnRcfI4iD9gyJDr3n70NVGnox7V7/2gR4t59kF8QR8UhWDtNzUq
	 t4LveOOO7RGuUlvqn2eQ/l0OwCEqLi8LwCn+YA0mzs5sqP2rJHhwGQiG8LZ0VyWcDhVYE
	 w5fTfT5ntICRl3dGlwhmuuhjmbZOaz1WaUsRt4+Pt5l038IMy1qI3oNF23hbkh96bPJWH
	 lRKmlAfDoUtvb2Cue+3qsCCj2hVPk7OViZEWfU2OAlbIT06jvwRrpW3bJMM8HFZYycQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794445028;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=rJPgckWV0k5mDkgB+pDXk9TdyOiAL+z8b6eZY/9G8i0=;
	b=A9QCMAWomwEn0gOI0KgCcU16aRBrS3TQet47rRBw4wFkRPX/9jSvIIDaP9AgYIkbClz1
	 NxjMnhDeDTzMUltk+zHRdlBewNsagy8hkk4RHfYdRJ9ySkaDdKyhSD2mInrMRYWaa8K7X
	 DqLD+R6IJT3WG/pj6lpl3lK+FNt61VXMb2d37BYvDeSXoiOtvXrg1lgV7FgOwCNKGR6J9
	 L9QqScVewFb8mmxY5VbJVPdfcHPBayISpVS6nIA0ZUE9mgF2GXIv3NyvZXEaHI500uHov
	 iv+X9afsF0s6Jts1HbjXcFEB+J1Qb8jl5IO6mF367DAoTyxMKAdB2a3BFNmlPCIceVA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="Xi/Mxvsj";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4999606A898;
	Thu, 12 Nov 2026 00:57:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Xi/Mxvsj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86CFC1F00A05;
	Thu, 12 Nov 2026 00:57:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794445028;
	bh=rJPgckWV0k5mDkgB+pDXk9TdyOiAL+z8b6eZY/9G8i0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Xi/MxvsjqGGrsl9mi5rpdPdCHKFlFcShBcOF2vVgwkdw3wNKc2TItoDvxqYjrH+Qg
	 RCy+tdyVXMa7K/o5DAz19+gg7w3gNx1z1fSTD1BliJ2F0oR1D42lsP8obTfAVbQ8at
	 I2iz6rXj9uZgEm5RCXt/Xx8g3hUkLmmQsNJ1FkCHcf6xwwu8zrgJDvbLnhLFCHahyu
	 TvFBm5sdxta1h+vZVoKCJyfHyXU6V6BcM5/+1G6nosPs+VPeH0w1eHQrTvNHzxUye7
	 6KuKlJGYtgfx3EubZIaiZvl29UiVKQx7QYTusbvz+CLLhRij1pPoZ6cuCCvoPK9wUU
	 K16cmFZAVOijQ==
Message-ID: <sashiko-outbox-210016@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v1 13/15] selftests: tc-testing: run dependsOn
 probes outside the test namespace
Reply-To: sashiko-reviews@lists.linux.dev
To: "Todd Freed" <toddfreed@meta.com>
Cc: bpf@vger.kernel.org, linux-rdma@vger.kernel.org
In-Reply-To: <20261111005533.6436-14-toddfreed@meta.com>
References: <20261111005533.6436-1-toddfreed@meta.com>
 <20261111005533.6436-14-toddfreed@meta.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 12 Nov 2026 00:57:08 +0000
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
- [Low] selftests: tc-testing: missing Fixes: trailer for dependsOn
  probe fix in run_one_test()
--

commit b366286cfdfd21956025890cdfcc1c16cfe59bd5
Author: Todd Freed <toddfreed@meta.com>

> selftests: tc-testing: run dependsOn probes outside the test namespace
>
> a test's dependsOn probe runs as an execute stage command, but is run
> before the test's namespace is created. nsPlugin prefixes the command
> with "ip netns exec tcut", which causes the command to fail. this makes
> every test with a probe that requires nsPlugin skipped currently. for
> example the mirred blockid tests and the tunnel_key nofrag test.
>
> probes are meant to check what tc and the kernel supports, not anything
> in the test's namespace. run them as their own stage ("probe"), which
> makes them run in the base namespace.
>
> Signed-off-by: Todd Freed <toddfreed@meta.com>

[Severity: Low]
Since this fixes dependsOn probes running with the "execute" stage after
per-test namespaces replaced the shared tcut namespace, consider adding a
Fixes: tag:

  Fixes: 98cfbe4234a4 ("selftests/tc-testing: localize test resources")
  Fixes: 7f3f86402609 ("selftests: tc-testing: add "depends_on" property to=
 skip tests")

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261111005533.6436=
-1-toddfreed@meta.com?part=3D13
