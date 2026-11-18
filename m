Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795037336;
	b=DHttt6q3Lqw9uzrQppkzQ9xcw0PETfBl0qCqbNF0f/Arcr6K1aZD+xCbVJcsowF/lSQz
	 oz1NkiBN2tTdbNmvvHm8gAENRR2MXQ03MDAejlH4ABMf4sihwTynNMp8aV4ozvBeFUj1J
	 qZAnjRdr8yw4Q9KC93NAFTysSw9geq/YtbgGwXn7wQkfUC6vfJDFizJG5ocPJIQXH/hXi
	 E/xaKHcFliejJjg3HziXGZOzyf7je9D2PsT4FKxib8wI94pHLy3nV7oXCfANwXw8qxbUk
	 6H5CRk3x/p2pU7cUFf8XYCJ9UfmKOXqHFjxqMuawaq9V2lrC1prvxGy7ZVsqu3pY9fA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795037336;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=C/2hVtjVJHJeJOWQOjIqe/m+q7nagRZXiNpaDJyN05Y=;
	b=OOuSvy/aTqcdbbm3RJhSflEEtLeLEkAAsbqJlCAh4fvJO48zKE0jb8QYBQ/t7AtFdvOz
	 zDWqmLbdBhvOGqAYuPjrbZIba38ZpSCSDxEIB5Ji6hBi6DyqerDBtYHQfoxFyNICC9hT3
	 4GOwKRle5iGDxCEFiwTHWv7H+pkzNMQqWRYfbZuTy2PdPjCyw/vLLyEi1Lfsb9GvInFHH
	 StQc8qNYcilclbCTw5fH2O0E4cTLPGtIY0jjDf1bD9BLhET9Pe+5EbL+0C/umP0fr7xm7
	 ofrlNUT3KPlL6JNlq8K0AhulWip7YTR3DMziajiPXa37YsqRq0gcOwlTKJKkGBCXk4g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hqkEksgL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0329360A382E
	for <linux-rdma@vger.kernel.org>; Wed, 18 Nov 2026 21:28:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hqkEksgL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7093C1F000CF;
	Wed, 18 Nov 2026 21:28:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795037335;
	bh=C/2hVtjVJHJeJOWQOjIqe/m+q7nagRZXiNpaDJyN05Y=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=hqkEksgLHSIodfWKffid4F8HBZaEhqrMcDeBYXFxceZkdTLkf8a500zOVFx4YAKSQ
	 i9Utkr6NC4MVREx4l6v+QnZqqAOBT74FNXMPDF/HIlvNDWu6IhOAfEijDtjfeCv2eR
	 sKwq2NjYPVL6wSt1RwJgsHTYK6Fuy7KMFaaqY0VoKBpTD2w37gfCsYiwCt1zyloohy
	 dOTPcEor0pKWxHLI2Lujx4pDLrVEf1J7k679MiSUxrpX4vOe0Q6JPl6iHitMbx0zgs
	 9JHJJzvDFB/6nx2CJd+0oXkShe9a8kKE85HEKirYMW7242l1P0hREz9r0/XH1279Hy
	 SUqcpRoO3OxHw==
Message-ID: <sashiko-outbox-221993@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 4/4] IB/isert: do not leak the receive descriptor of
 a dropped Data-Out
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yehyeong Lee" <yhlee@isslab.korea.ac.kr>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261118211503.2526705-5-yhlee@isslab.korea.ac.kr>
References: <20261118211503.2526705-1-yhlee@isslab.korea.ac.kr>
 <20261118211503.2526705-5-yhlee@isslab.korea.ac.kr>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 18 Nov 2026 21:28:55 +0000
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
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261118211503.2526=
705-1-yhlee@isslab.korea.ac.kr?part=3D4

