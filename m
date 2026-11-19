Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795094580;
	b=S50xoaEpENeIgTjKAH6z6uewClhzMcEJZ6igy9euU+4yaebbALXH5FJGHVM8E+N9iwAS
	 8yY3a8bi5l5f6E5Z9RL7MbhbU8DvycmnOvohF/ZnUE1KTRErtKWLqE9nGPQ6LEAAyg29m
	 mE5pRWlW9kRnUOC+z0KOLKEmREFxMthEPoOTzs4XIjyPBJdvTOqfOOWNy0Eq3H+wXvt9+
	 gxeqv4+RT3XIoFKSxZgS7q+FOPo3wMClnaLw+mDXm+ekAZds0dgWgWLxRn5ZPwhUe5/kw
	 GK+VRN7shL6j9SwdzuvKKscfuPCEE728g5P+cdTts/3c6WFpbcE4Tt0/KqRRjHakwLQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795094580;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=1X0K9jXmJAQDKN80OFhORSXPNhVsCmB9fHtLPRSnAUU=;
	b=Hib7Ndd+CgarJnAbSqduDT+IehphYQbmwnBU1gUVDOgcciPBO/9tfKVi/XAu6Nw0Bt42
	 yrNYY+stpj5iV0/RWaulGFZLjQnWUET7SRCGy7PljXSL0JTNznX1x8UdzBygy0mgYadrv
	 O7SubwLoUN5fU12+6BUF4oji4G/SGsdFD14LPg2WdNYnjKlAYI2iXPXDIgVnKlL18dIYK
	 1qqgs2xuZPHP8vAPrJdxFr0r/Jcue6KuzpMXd0oKMIAZHhbVK/imL4GT/FM/HeqpCl4Da
	 bLLNM8llq6u3iCK2qr5jJrEiL86KGBC+3fD9ndZqGHPJHvL8z3ohx5jCS5LplEZa2TQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gEXDp4Cq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CCA0606A324
	for <linux-rdma@vger.kernel.org>; Thu, 19 Nov 2026 13:23:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gEXDp4Cq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8AB71F000C5;
	Thu, 19 Nov 2026 13:22:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795094580;
	bh=1X0K9jXmJAQDKN80OFhORSXPNhVsCmB9fHtLPRSnAUU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=gEXDp4CqFs7WRp6rohjEGIx1hmZ9p6qduwWoxEmTtv7NE8bOHyYUV8ys/emgfcYZh
	 Z9wUPD5ICXnyTiQ5YPLzkAFZGf1Z4k77taD2v7Q8aMoNorlX5fQOz0YVrY/e+qKNft
	 6goI/hbbe7U8nFZWneQNZWrLMlXXe+SzfDzvoUVnPEAnObZY9+XVzhh6JvtvYpRr5C
	 b0O56wQkgk96Jik8x0FChuaHgP5qvV1BsHBzTVTI3XyQtfSFtnAOfpg4T15rn4lbD3
	 EgO7ds/xilSVws5s61QiO1VP8jNdkkGdZuXre/ay0z2A9O7dvuexh6QDBvaLeItz76
	 VbrliWhw11lyg==
Message-ID: <sashiko-outbox-223167@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 4/4] IB/isert: do not leak the receive descriptor of
 a dropped Data-Out
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yehyeong Lee" <yhlee@isslab.korea.ac.kr>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261119131700.2722108-5-yhlee@isslab.korea.ac.kr>
References: <20261119131700.2722108-1-yhlee@isslab.korea.ac.kr>
 <20261119131700.2722108-5-yhlee@isslab.korea.ac.kr>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 19 Nov 2026 13:22:59 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> isert_handle_iscsi_dataout() works on the command it finds by ITT, which
> holds the descriptor of the SCSI Command PDU and not of this Data-Out,
> which is why the function posts its own descriptor explicitly when it
> succeeds.  None of its other returns do, and isert_recv_done() ignores
> what the handler returned, so each such Data-Out costs one of the
> ISERT_QP_MAX_RECV_DTOS buffers.  That includes the returns where
> iscsit_check_dataout_hdr() answers 0 without a command at all: 200
> Data-Outs carrying an ITT that matches no command stop the connection
> after exactly 128 of them, with no response to a NOP-Out sent afterwards
> and nothing logged beyond the per-PDU "Unable to locate ITT" message;
> with this patch all 200 are taken and the NOP-Out is answered, in 5 boots
> out of 5.
>=20
> So give isert_handle_iscsi_dataout()'s other returns the same post its
> success path already does.
>=20
> That one function only.  Everywhere else a handler returns non-zero, the
> command isert allocated still holds that descriptor and the response
> posts it from isert_post_response(), so re-posting from
> isert_recv_done() would post the same descriptor twice; the second post
> is skipped only while the descriptor has not been refilled, which is not
> something the receive path can promise.  iscsit_handle_logout_cmd() even
> returns 1 for an ordinary logout.
>=20
> Fixes: 4366b19ca5eb ("iser-target: Change the recv buffers posting logic")
> Cc: stable@vger.kernel.org
> Signed-off-by: Yehyeong Lee <yhlee@isslab.korea.ac.kr>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261119131700.2722=
108-1-yhlee@isslab.korea.ac.kr?part=3D4

