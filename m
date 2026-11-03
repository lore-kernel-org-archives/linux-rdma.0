Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793705632;
	b=qj5IYOjtu5CRZRxCkIZ6Ly44Sfe6QHgy4vojd3M9Jir4ZwT/6/21TrL47K2VnCB5Mf1h
	 xano1OZArUTsApyZjTE7wQM51au92ygD+nn38xPl8WTy1E+M2EwzmaMO5+HncJ+0RoKDn
	 NbbY15MDgTRKlcygO7XEChcSNOaiJ/utW7UwbPPP6z/wZZfz3PXSheuoNHzKJjwJ0oabv
	 sh0P7wNdMp8k6brc9YuZS/NtVnu7fmZL7QAqassNaZhPvTd4yty+XdDlYCEQOCIOAyxOf
	 Opslfk4kpd5AEB+JCJ/oVFkwRrZQNlCgLLzC/jwjBkIBm6pQFK4VW5BhBBNwXeUKfRA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793705632;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=b/Nr4cIcbHVgDyAnybdyASpu0fa+MG8SetO6p7ILee8=;
	b=Oyeyd/qu9cnOV2Ep9QylEf6M1As7iv5R+gnfg8947MPGIX2qPunrTR48HtNObEjKkqEe
	 Rc8kUmnqN+1D50h1IPn2mq55TQ2FJqy30lc0X6MfaeODLGqFqqbUoUnIO70UUOVUkLmbf
	 fRsY0i3rrPvxmcpV2iY5lowX6SMzTK7JNAstC2kBDQwmR+lRytIfxDMsmFR1digYtZH7N
	 GU8Ssus/xEX6CRjV8qvdwEgWfZ4brerm0JWgY1A41riABBh4tI12A9yS+cDd03mboVeBE
	 imP8XjKjY4v+LSu0X53SpVZEkn29SvoNmekVf1DsQnjIYFIc3XKJzWZPZc0vctBLN+w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="JU/goymq";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56B9C606A330
	for <linux-rdma@vger.kernel.org>; Tue,  3 Nov 2026 11:33:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JU/goymq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C29D71F00A02;
	Tue,  3 Nov 2026 11:33:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793705631;
	bh=b/Nr4cIcbHVgDyAnybdyASpu0fa+MG8SetO6p7ILee8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=JU/goymq9cSgTv87TWjfp1cOgQdan9eOC2OXnw/llbQQsdyG7kh+uDEEBS7mdGM70
	 GJWvDefmHZ8droFbKgzcoSZGBwz0UAzpSKvudgIo41oy0AclC+2nb7so0XNiwuGyYp
	 IJrWLBOyWIqjThgotM6o/m8w8FPwiF3CPUM/72ewCVWFtw+VxxcPDnreLRNwYNip1O
	 o+tH3zErI33ThVSWKAehg8rmu0580fuKg7srphH7JTNyAH+p31lV2iKacZIZD07CM8
	 ShgNxnwgUgCWvQKkKvK63M3wvKN0T5oEIHShMAPLJYGZ66WhU+QwIwlQSQC4l10QSw
	 Dok8DtAHMZ0IQ==
Message-ID: <sashiko-outbox-195155@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH rdma-next v8 8/9] RDMA/mana_ib: Flush and notify CQs
 when kernel QPs enter ERR
Reply-To: sashiko-reviews@lists.linux.dev
To: "Konstantin Taranov" <kotaranov@linux.microsoft.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261103111729.729886-9-kotaranov@linux.microsoft.com>
References: <20261103111729.729886-1-kotaranov@linux.microsoft.com>
 <20261103111729.729886-9-kotaranov@linux.microsoft.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 03 Nov 2026 11:33:51 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> From: Konstantin Taranov <kotaranov@microsoft.com>
>=20
> Complete the RC software flush path by adding a kernel QP to the CQ
> error lists when it transitions to the ERR state.
>=20
> Invoke the CQ handlers after the transition to flush pending work
> requests.
>=20
> Signed-off-by: Konstantin Taranov <kotaranov@microsoft.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261103111729.7298=
86-1-kotaranov@linux.microsoft.com?part=3D8

