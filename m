Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793068222;
	b=rOEED32blao+8DXQ24ToNUZo4ied0JjEuA7w1aWpn4CwFV9B9w8R0XAO2lXn15bXa5eQ
	 Kz1PVOOMBH9NSB0OWV4aBYek+TWilEMXhvm/9I2jMD9/VesP4q46vFh/rthuV1fPDaKG0
	 JRXrVJhoGu9I0i2VWeTlD9nJ6QDY6eFB4ZpNsyWhwevjd3a5ge0PQNyscw5wekoWEUd/6
	 Rz0IB6U8jTIN2qv7DS7YgRy3jOAsq1AvVRyzMgMyuVE77uvFY6OqSnc6ZIkhxGJTY/t61
	 LJIshgsZmAZ5hB/RfchyQuqoEl9yshJfV/dqC84/397hxZFc5P17Kwu2YSR4E4LTzDg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793068222;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=0cCyZNLFNGFTSRPmEDuInKKv2TJ9GxuS0fl3jePR86Y=;
	b=itR349rzxIHQmMw4dNZW1di2BEIJSTUIp+l61i+ZOGbLB9PiUWjnCN+mzfusv1st47Vr
	 2WFuSjKNoCGfLPYk6I3fa4OM8WtBjLUhDSCbhceZvqUGcAxpN+3UJB0RqXawvDEKfm4ze
	 GKYBqG1uz15/Qn/X9xmG78xlFZnHtpgluCTq7jC/YskYLO1SEA4ZI3IADHPcHnDhIoMTf
	 lcFP2Fk1Ie7O/CxTbOami/W5irlWQjhPvT79AodvMPwUmY9x2jOE4f13gV4y5mMqgmJek
	 bblVFgUfuG1ioFSAqMZTqqP5s7QmCy1N7pTwJJO8qF9t5FuGBVmifYD+9r4vec/oCaA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DHMuaWSP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBAC1606A31D
	for <linux-rdma@vger.kernel.org>; Tue, 27 Oct 2026 02:30:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DHMuaWSP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 496B31F01828;
	Tue, 27 Oct 2026 02:30:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793068221;
	bh=0cCyZNLFNGFTSRPmEDuInKKv2TJ9GxuS0fl3jePR86Y=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=DHMuaWSPDEusZgIGpaeEMkPCuHSh/+HrkGrnjXnTS0sn6xpadjHJ/HDB3YPjejfwp
	 a8ewsz6W9SH+cK8uLDAK6pY5qqVsztZV+yYtJDCBAF3GERUKF1uh5KCTeCCQTUruAw
	 n6Ldsp3VgmT5sCsFt44TcODchuGfA4t5Pqq8MpTikMGVBSntZpivqiQiZHMau8k5rO
	 7dIJX4TDWdoIgWCfADyE95ArsC7+2uYu1CtSuh3rKlxDWnVac6JZLuci39r+skpbZJ
	 J7+4Im96GuzYI/JvbWIYAiPKo0MEalQYQTgSg1xexUlpg9aNPvQa8S0n2mtjCzgrlQ
	 nJdp0pAWnq+7w==
Message-ID: <sashiko-outbox-186021@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH rdma v7 1/7] RDMA/zrdma: Add build infrastructure and
 module skeleton
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yanze Zhang" <zhang.yanze@zte.com.cn>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261027021119.2325798-2-zhang.yanze@zte.com.cn>
References: <20261027021119.2325798-1-zhang.yanze@zte.com.cn>
 <20261027021119.2325798-2-zhang.yanze@zte.com.cn>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 27 Oct 2026 02:30:20 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> Add MAINTAINERS entry, Kconfig, and Makefile entries for the ZTE DingHai
> RDMA driver. Include a minimal module skeleton with auxiliary driver
> registration structure to ensure the build system works and the module
> can be loaded.
>=20
> The driver depends on DINGHAI because it binds to the auxiliary device
> that the DingHai PF driver will create. The DINGHAI symbol itself is
> already present in the rdma/for-next baseline this series is based on,
> so the dependency resolves.
>=20
> Signed-off-by: Yanze Zhang <zhang.yanze@zte.com.cn>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261027021119.2325=
798-1-zhang.yanze@zte.com.cn?part=3D1

