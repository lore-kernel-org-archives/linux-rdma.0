Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795048926;
	b=PaMBuclSwQwOC7Em+uu94HivLuVWrqWC1fS/n+b3DUcSCeqlu0Sf5LphLibVXRG+CR+Q
	 mMVHss8A2QRgmxbqAYEKNXxVvTXN1z4NuHzqZaMdBckn+XTtC3U1Tyfs8tZDxebYaldSF
	 8wYBsY/93Sp/2yjiBPXLZ0owXGTDFdG5jYhm7NPIbQAOcg6M9Jij1ITuWFaIt3G3usRMi
	 tUXXtOCbwD8RgtNcJ5NOHA6IeNKXCChyRiEyjZtK9rl6ULGhyoDH6eG7ov6ScJ6V2o6jY
	 6VY1dRLMtb3n3tvR//Nti4gZV6MfMus8Eo+x2nNB2ibzTjGVAFcH60SQ8CCWhetHifg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795048926;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=vcHtVOybJugyhdhVYJuNF7ystyKMzNyGYsR6qY9NPXY=;
	b=H8ISRFHmm3PcGZDsmt82k/nH4/QDhf6AOGQaa2Y9K4epSk05i537X0LVbJokgvIE47Ms
	 KO/pkoAwsnuPEK6y1Ex5nktTK5hEuUiSC+Y9e+7Cnz7/f755pIfP3Ry2n12PqjM4Qz7t2
	 IureKRwYH9DOq2RQN3dyQe2kCi3bZGhmwFH/Zl9CKCUT+x8lRBCS87DQgJ0qjPRqcmHt6
	 1yNmOmjqED0MdYgXfXeIf850tl9/6qMdARANr6SmRGzCC8nhwEV+m/cSOj4Z26lUbwQvT
	 ksxIyDxYYajivmjXYotV3LvP6OpLUqysDyVV9MdG/iEb7Z5YKdyC2742YME80ruNcpQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="JFVd/K8u";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 056FA606A320
	for <linux-rdma@vger.kernel.org>; Thu, 19 Nov 2026 00:42:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JFVd/K8u
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AA471F000C4;
	Thu, 19 Nov 2026 00:42:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795048925;
	bh=vcHtVOybJugyhdhVYJuNF7ystyKMzNyGYsR6qY9NPXY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=JFVd/K8ugcyz2wOarvyCFkMM4TybBT29q6YZi9UaGHgVXEVvCdjlNtp2mUn/8BD92
	 zSuZc49zIZ94GX6dmed1lxbcJ4BJM7WHBvPAF74p/eP96lmR9Hhqz4Yzbh9tl+HhH/
	 UgOWU4PiqOo+VD8ciH9tF179XtgOCdTD6gIbRBSnaZXZH4OvYLy5IigRt6m2I0LJcB
	 mysTa5kTeqG8kRs0RpzJ4T6gK6ji88k2eR3trwZ1o6MZ5zvKeBY2wgu0imI/ZZofjh
	 bb1lMkC8ilm3MyxdtPg+acozpVoDbLJcWSTBjBNmO+lHqBy3bkj29fQEYJ4ok8GfZl
	 CtoTxYI2A/Xvw==
Message-ID: <sashiko-outbox-222257@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v3 1/3] ionic: make the command timeout per
 device
Reply-To: sashiko-reviews@lists.linux.dev
To: "Nikhil P. Rao" <nikhil.rao@amd.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261119-b4-ionic-cmd-timeout-v3-1-2cdb8fca15fd@amd.com>
References: <20261119-b4-ionic-cmd-timeout-v3-0-2cdb8fca15fd@amd.com>
 <20261119-b4-ionic-cmd-timeout-v3-1-2cdb8fca15fd@amd.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 19 Nov 2026 00:42:05 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> From: Arun Kumar Prakash <ArunKumar.Prakash@amd.com>
>=20
> Device and admin queue command waits, and the firmware heartbeat check
> interval, use the compile-time DEVCMD_TIMEOUT. Make the timeout a
> per-device value, so that it can be made configurable through a devlink
> parameter, and export it to the RDMA driver through
> ionic_cmd_timeout().
>=20
> No functional change.
>=20
> Signed-off-by: Arun Kumar Prakash <ArunKumar.Prakash@amd.com>
> Reviewed-by: Brett Creeley <brett.creeley@amd.com>
> Signed-off-by: Nikhil P. Rao <nikhil.rao@amd.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261119-b4-ionic-c=
md-timeout-v3-0-2cdb8fca15fd@amd.com?part=3D1

