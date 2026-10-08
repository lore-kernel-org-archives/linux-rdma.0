Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F8A426158B
	for <linux-rdma@vger.kernel.org>; Thu,  8 Oct 2026 03:32:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791430339; cv=none; b=PLorTUMfVtTkknuYgv34xDtGetmq79tE+y4QQIWoBfKsh40U/pnXSRkujYDZaZwW5ZGrJSanc1+dXswoT3py2xKnJ8W2Ds0GfbvLF/S5d4s7OwlEGFrD13hUXufpafjRJpesVxg4H9EXJy+UZ41Ngif+82whC95+d8gYRa729r8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791430339; c=relaxed/simple;
	bh=A1wPdEMKhQ+53W+FqyvPrTH0RLuvnLKZ6ATE1WTjouA=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=msZo9ju+dZDkenIkuPYQ+n5nCk+xqX5Tq3Wuhi5E7yCoz6YeVtba/Q8QGo2Df5H0jOwoffU6ljIUtPdDxM7XyHSNjJsknzAloleOELAfQmgX8NT/qcus6KsJSSJ/m8+gXjaHwEvCjtdhe3bvHcQwQAl3tC/DnLZ8YQsX0gmdUoQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XR3X3jQ6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XR3X3jQ6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 172201F000FF;
	Thu,  8 Oct 2026 03:32:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791430338;
	bh=F3MbSHuKcjvLIn7zYPpHjjuMa66pJ8b0BLA3BrEd6NU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=XR3X3jQ6/t6K4a1m8s+iiCrGD7iTDPdTuyqvVxKFc5a4fTBCePAwfNKqRjMkUc/3m
	 xSmz6xSYarPhrX8v7EVfgANPVO9nZdkpyaoC/+b+2uO8k2bLPsiLHH0RXcS8J/OwZ0
	 qjTT+mJgaiCR6gZcrhK1nIpyXPiLy/pVJmhckR9VNpW8gpD/fWd54ymCG3hjziXSUl
	 XpaZ5XnXGJ0whh/0WOFSzut+6o9AIEf26WuH+wTHMzxpHcoGwdeHFg1x9XnWwLEzOR
	 xAPhgSsGKJtVQt3WawVVtYUZHevPsgzupjYW2MV6Kbov6mE6pUGG+MhmpPESUGwExa
	 x1fDy0Xgkg3Ew==
Message-ID: <sashiko-outbox-163548@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v9 09/13] net/rds: hold a connection reference
 from struct rds_incoming
Reply-To: sashiko-reviews@lists.linux.dev
To: "Allison Henderson" <achender@kernel.org>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261008031333.1142174-10-achender@kernel.org>
References: <20261008031333.1142174-1-achender@kernel.org>
 <20261008031333.1142174-10-achender@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 08 Oct 2026 03:32:17 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> struct rds_incoming->i_conn stores a pointer to the connection a message
> it belongs to, for both received messages and messages the socket sends.
> But without taking a reference, nothing keeps that connection alive.
> Embedded as the messages m_inc, an inc routinely outlives the connection
> it points at, by sitting in the socket's receive queue until the
> application reads it, while the connection is destroyed under it - and
> every dereference of i_conn after that point touches freed memory. Netns
> teardown and unloading rds.ko cannot do that to a live socket, which
> pins both, but a transport unload can: rds_find_bound() does not check
> the transport, so a socket bound with one transport (SO_RDS_TRANSPORT)
> can hold incs that arrived over another transport's connection, and
> unloading that other transport destroys the connection while the socket
> stays open.
>=20
> Chengfeng Ye reported one way to reach it, where the socket info
> [ ... ]
>  m_inc reference is dropped from a shared rds_message_free() helper
>  that both paths call; rds_recv_incoming() takes the new reference
>  before dropping the old; rewrite commit message]
> Assisted-by: Claude-Code:claude-opus-5
> Signed-off-by: Allison Henderson <achender@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261008031333.1142=
174-1-achender@kernel.org?part=3D9

