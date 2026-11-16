Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794824398;
	b=vvUZsYSZvsOT/n/NhlLcSXiR+htZ7SSisOhcSj4NPW+1+UOLOgloObljscTioQjJz4i0
	 0IPgGdVscaKcpRmI4fP0mAazQ/e4+qscXEcTb2C1KLci4uDCa1l4nxwubvpPswSycuwAw
	 L9hzyQRtUoe/pecw3e6udCpDX1F4LjMBx/nzvi6PJOLF6ohjhCnks8y7XczyCyDlWAA4I
	 3inv9uxULD4/lDzUauKQLvwiZBI9Hk2cgSoMQMOTlL+9wb/wgnJB+YYD265Gy3pyM8De3
	 AjMeBaPzV3+vyK63LY2wwCQDBiBA9Mq/8eZGg+4jAXTupGwxyFEgMr+/QkyKJdtTfwQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794824398;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=tjIRkH1+zcGMQ8+LV5k9nhMcA7yE00K1Y30ib9B9kZg=;
	b=ybxSG3KwrRzBlRi+JXxJQpndybArSVs/SVm6UYNSRTNL0O70KAAT8qvSOcnh03Zrzv8X
	 mE38bWNlAXEzRN+ubwidP9qemrtMaUp26nqEeGc6eqeVOwVzZbPllzcikVKUOcoX3pjaQ
	 Xd/gYKkyN6z4ZJKTa0tCHJwzgUq60TVNKSEj0SJklCC9z4rrAof0A5oMF3IzvBWuj0DyR
	 YwgRqbWmrDtOqY7xqbBDmyO/ahFU702adaoBex5xT8+/wy3g3arXbMOTfQ4e3zUBubxEt
	 AycTZfuYHu+ZoezvG0g4+KUsbEnsaJRgDD4xspwJXx7MtxEw/YSqYMsRTH2gKLNHlOA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Dfx48rNE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26345606A893
	for <linux-rdma@vger.kernel.org>; Mon, 16 Nov 2026 10:19:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Dfx48rNE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8EEA1F000CE;
	Mon, 16 Nov 2026 10:19:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794824398;
	bh=tjIRkH1+zcGMQ8+LV5k9nhMcA7yE00K1Y30ib9B9kZg=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Dfx48rNE4DDCNk9CdZ0MjjOpWyfop8mEwtWNuBmOlDgwWeT3gDEsU6nJ9ikvjec6N
	 9NcU2nuIJbovxP4IbyeSczAXRTZQKFNUw5gMcuKo+aD7JhNU4dL2mAywlHoxFzMNTx
	 m/OXpsSK0/Avx+XqHwy+djtv1vSSEnkYlirG49ht/HIgsiHdKp88DmedVNSR8kKu5/
	 5g0HwmpC4GyKNoGkLKWon4PcUYY+YD4/h6lIq+br1vU4oRRK31jmZYrVvuIggLGK4F
	 gycZbq5+epuVOOpi59gHji/4FqNvb9xEilVq0zIL4o4+adqvTbOObbbioUANxRMQ4v
	 THm9AF0WXF20A==
Message-ID: <sashiko-outbox-216716@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 2/2] IB/isert: do not leak the receive descriptor of a
 dropped Data-Out
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yehyeong Lee" <yhlee@isslab.korea.ac.kr>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261116101108.1650132-2-yhlee@isslab.korea.ac.kr>
References: <20261116101108.1650132-1-yhlee@isslab.korea.ac.kr>
 <20261116101108.1650132-2-yhlee@isslab.korea.ac.kr>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 16 Nov 2026 10:19:57 +0000
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
> after exactly 128 of them, in all 3 runs, with no response to a NOP-Out
> sent afterwards and nothing logged beyond the per-PDU "Unable to locate
> ITT" message; with this patch all 200 are taken and the NOP-Out is
> answered.
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
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261116101108.1650=
132-1-yhlee@isslab.korea.ac.kr?part=3D2

