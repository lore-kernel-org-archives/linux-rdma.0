Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 684FE362154
	for <linux-rdma@vger.kernel.org>; Sat, 17 Oct 2026 03:29:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792207777; cv=none; b=IS4AzBeIc4RpLN8yXT+ysC9pCSm4NH0q+kjPcgZoysssROvqI8GlE+x2ygJGWH1iP7VdF1Wp5uvOp2fzb6lJyyfa7jlZhU1k7CAKCqybUEyIahvLfkydLGHxBqoKVzbtxjlUPbqQhxHOcFl25F8f+VOxSYP30Ppr9ngnU2ck7p4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792207777; c=relaxed/simple;
	bh=q5voTqN3V5tJse13YHXycElduw+NX4CrIpgt7+F8AVY=;
	h=Message-ID:From:Subject:To:In-Reply-To:References:Content-Type:
	 Date; b=Xwv40EEYiw27vl9sUhDTRA29w4KQECMH75tJQAYyjuTNQ9/iQTuz97vMcS0dlTYGkAn9hlfeKZr7H3zc2RHDnIwxT7fFbiDHee32q4zL4DLOuJuJx18Dw851pXBKx+28IYhElprm2HdkNm2KFDUTw/Fv61hnTvBhhaBqicIzehc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nIa2/RB1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nIa2/RB1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCC411F000C4;
	Sat, 17 Oct 2026 03:29:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792207775;
	bh=zXwu3OfgmlYH+WW/8+COF6DEi94vu8Dd+xexBrUkeA8=;
	h=From:Subject:Reply-To:To:In-Reply-To:References:Date;
	b=nIa2/RB1uArGaxJpzTpd1YhPxP6d5MDXryEnyVqd8q3V1SMi3hRI8/ZqRetM4n2XD
	 6ITlPBn9CSubrF6qTZHc4KlEAF+WHlK/3CKKgqNDVgWZzvzyuXuVqc6Clk0bSD+NEj
	 RdrweF+YMl98PnNN55LQTJ6XmYgSMbCY7Oqg4G7IfU0p1NxQKtEROQzRGC/ZBjHh6L
	 m4E8PRzgPbgtBGSmKXDCjCZhWSDxJdvfo8GIA055JHAF1Pbg0XbFFkKjUvijW3R7cj
	 dr1EVUg0Xm1Lq/DyVk5jCksNUu8a07KxUCCZ7yCkhcfts73OOD+jTmakY6oC6v+Ab/
	 8g8P79LB/Kc+Q==
Message-ID: <sashiko-outbox-175248@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v5 1/2] net/rds: keep the connected peer's
 scope id apart from the bound one
Reply-To: sashiko-reviews@lists.linux.dev
To: "Allison Henderson" <achender@kernel.org>, linux-rdma@vger.kernel.org
In-Reply-To: <20261017032358.2563121-2-achender@kernel.org>
References: <20261017032358.2563121-1-achender@kernel.org>
 <20261017032358.2563121-2-achender@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 17 Oct 2026 03:29:35 +0000
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

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261017032358.2563=
121-1-achender@kernel.org?part=3D1

