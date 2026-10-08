Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2816F364EAA
	for <linux-rdma@vger.kernel.org>; Thu,  8 Oct 2026 03:23:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791429796; cv=none; b=FkgQ5FaxHdaOA6V31Q/KcH44+SVvvL+6rjcQb5JFqdSfFoj2tyGeuagRtB0ZLynG2viUB8ByoRW/qIImXIoY/+2zhaKn0MECsElVpDnpUr8iuOoKZ6iqpmdKMlnpkkiZMGlH/fX+rSUTLPCMfOyDieiXyCYTCAX3uknq2BnuIgs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791429796; c=relaxed/simple;
	bh=03BgoWMBfKeV6HYdkOtAfnuvBllhDkvvNLmPloF1PY4=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=mixbJWQ/QpopUluTwgowc0abUEA6gEP9jSqYNEvAvQM9w5Pj+nKSzHQHTLvKd3HtLGrEJ6dnaK/cBv6e5R0BuoHWfnP9Rufgb4YxqM9fjRj+VxPj98I2T7+AHt51xEMpxfeljwoMM+rLCfusuwSsnMzN0+BleSiivpntM56HcfY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ghNO7CX3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ghNO7CX3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 884B31F00893;
	Thu,  8 Oct 2026 03:23:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791429794;
	bh=3XMqpouDKxADoM2buzsCLM61pdOini5Cr5855NyIFdU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ghNO7CX3BlPfzF9UCvV1mZ+L9yrKCLB4mI9KmQcAQfMQC1HoOzYPLN+QPr4kMcP5q
	 95MWcKfrLjJhC9mmCqu6ihTeh/44sHjcOGs+riZG2X35kwDDre+GTKN1TfRZNlooSs
	 917vqaQruKMv5ZoFP2YgN0wa2x7s6TbfEMKbAIW+c2DJBi29APaocvngQyoxBoLB9b
	 licl8zrV11oIY9G3pouF0rxu/v7qQidwlfayw/Hlz5GCyVcLZ4l5/tUUXu0bM4JBhG
	 KUCnijkAyCog2j2n/ESWEx/lSGQyFeQqbo/YSQe8mFeZFqtu1C4vZ9Ezsk9eJWDDdA
	 MNg8A9waoKZRw==
Message-ID: <sashiko-outbox-163530@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net v4 1/2] net/rds: keep the connected peer's scope id
 apart from the bound one
Reply-To: sashiko-reviews@lists.linux.dev
To: "Allison Henderson" <achender@kernel.org>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261008031426.1142344-2-achender@kernel.org>
References: <20261008031426.1142344-1-achender@kernel.org>
 <20261008031426.1142344-2-achender@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 08 Oct 2026 03:23:14 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> rds_connect() has nowhere to keep the scope of a link-local peer, so
> it stores it in rs_bound_scope_id, the scope of the socket's own
> bound address, for rds_bind() to check a later link-local bind
> against.  That field is then also what a send without a destination
> uses as the request's scope, what getpeername() and recvmsg() report
> as the peer's scope, and what a later bind() overwrites:
> rds_add_bound() stores the bound address's scope unconditionally,
> which for a non-link-local address is 0.
>=20
> So after connect(fe80::x%ifA) followed by bind(global), a send() with
> no destination asks for fe80::x with scope 0.  rds_conn_lookup() keys
> on the interface, so that finds or creates a connection with c_dev_if
> 0, which the TCP transport then tries to connect through
> sin6_scope_id 0 and tcp_v6_connect() rejects for a link-local peer:
> the connected socket's data is queued on a connection that can never
> [ ... ]
> observed in the field.
>=20
> Fixes: 1e2b44e78eea ("rds: Enable RDS IPv6 support")
> Assisted-by: Claude-Code:claude-fable-5
> Signed-off-by: Allison Henderson <achender@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261008031426.1142=
344-1-achender@kernel.org?part=3D1

